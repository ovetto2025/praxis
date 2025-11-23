package com.example.praxis

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "unity_channel"   // nome del canale per Dart

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "openUnity") {
                    openUnityActivity()
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun openUnityActivity() {
        try {
            val intent = Intent(this, Class.forName("com.unity3d.player.UnityPlayerGameActivity"))
            startActivity(intent)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
