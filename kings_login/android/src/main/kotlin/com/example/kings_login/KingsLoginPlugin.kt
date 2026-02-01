package com.example.kings_login

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.newmedia.kingslogin.CallbackManager
import com.newmedia.kingslogin.helper.KingsLogin
import com.newmedia.kingslogin.KingsLoginCallback
import com.newmedia.kingslogin.KingsLoginManager
import com.newmedia.kingslogin.KingsLoginException
// duplicate import removed
import com.newmedia.kingslogin.model.KcScopes
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

/** KingsLoginPlugin */
class KingsLoginPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var context: Context? = null
    private var callbackManager: CallbackManager? = null
    private var pendingResult: Result? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "kings_login")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "login") {
            if (activity == null) {
                result.error("NO_ACTIVITY", "KingsLogin requires a foreground activity", null)
                return
            }
            if (pendingResult != null) {
                result.error("PENDING_RESULT", "A login request is already in progress", null)
                return
            }
            pendingResult = result

            KingsLogin.init(context!!) 

            callbackManager = CallbackManager.Factory.create()
            KingsLoginManager.getInstance().registerCallback(callbackManager!!, object : KingsLoginCallback {
                override fun onSuccess(token: String, scopes: KcScopes) {
                    val attributes = mapOf(
                        "code" to token,
                        "accepted_scopes" to scopes.accepted.toString(),
                        "rejected_scopes" to scopes.declined.toString()
                    )
                    finishWithSuccess(attributes)
                }

                override fun onCancel() {
                     finishWithError("CANCELLED", "User cancelled login")
                }

                override fun onError(e: KingsLoginException) {
                     finishWithError("ERROR", e.message ?: "Unknown error")
                }
            })

            KingsLogin.requestPermissions(activity!!, listOf("user"))

        } else {
            result.notImplemented()
        }
    }

    private fun finishWithSuccess(data: Map<String, String>) {
        pendingResult?.success(data)
        pendingResult = null
    }

    private fun finishWithError(errorCode: String, errorMessage: String) {
        pendingResult?.error(errorCode, errorMessage, null)
        pendingResult = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        context = null
    }

    // ActivityAware implementation
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
         activity = null
    }

    // ActivityResultListener implementation
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
         return callbackManager?.onActivityResult(requestCode, resultCode, data) ?: false
    }
}
