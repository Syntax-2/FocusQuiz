package com.example.getsmarter

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.focus_quiz/foreground_app"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            when (call.method) {
                "getForegroundApp" -> {
                    if (!hasUsageStatsPermission()) {
                        result.error("PERMISSION_DENIED", "Usage stats permission is not enabled.", null)
                    } else {
                        val foregroundApp = getForegroundAppPackageName()
                        if (foregroundApp != null) {
                            result.success(foregroundApp)
                        } else {
                            result.error("UNAVAILABLE", "Could not get foreground app.", null)
                        }
                    }
                }
                "openUsageAccessSettings" -> {
                    try {
                        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERROR", "Could not open settings", e.toString())
                    }
                }
                "hasUsageStatsPermission" -> {
                    result.success(hasUsageStatsPermission())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun hasUsageStatsPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(
            AppOpsManager.OPSTR_GET_USAGE_STATS,
            android.os.Process.myUid(),
            packageName
        )
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun getForegroundAppPackageName(): String? {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val time = System.currentTimeMillis()
        val stats = usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, time - 1000 * 10, time)
        if (stats != null && stats.isNotEmpty()) {
            val sortedStats = stats.sortedByDescending { it.lastTimeUsed }
            return sortedStats.firstOrNull()?.packageName
        }
        return null
    }
}
