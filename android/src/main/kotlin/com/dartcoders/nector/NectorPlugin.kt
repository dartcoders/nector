package com.dartcoders.nector

import NectorNotificationService
import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.NewIntentListener
import java.util.*

/** NectorPlugin */
class NectorPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, NewIntentListener {

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "nector")
    channel.setMethodCallHandler(this)
    // val receiver = NectorNotificationReceiver()
    // val intentFilter = IntentFilter()
    // intentFilter.addAction("com.nector.NOTIFICATION_CLICKED")
    // context.registerReceiver(receiver, intentFilter)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    binding.addOnNewIntentListener(this)
    activity = binding.getActivity()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    binding.addOnNewIntentListener(this)
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "createNotificationChannel") {
      val argData = call.arguments as java.util.HashMap<String, String>
      val completed = createNotificationChannel(argData)
      if (completed) result.success(completed)
      else result.error("", "Unable to create channel", null)
    } else {
      result.notImplemented()
    }

    if (call.method == "showNotification") {
      val argData = call.arguments as java.util.HashMap<String, String>
      val service = NectorNotificationService(context)
      service.showNotification(argData)
    }
  }

  private fun getLaunchIntent(context: Context): Intent? {
    val packageName = context.packageName
    val packageManager = context.packageManager
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
      packageManager.getLaunchIntentForPackage(packageName)
    } else {
      TODO("VERSION.SDK_INT < CUPCAKE")
    }
  }

  private fun createNotificationChannel(mapData: HashMap<String, String>): Boolean {
    val completed: Boolean
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      val id = mapData["id"]
      val name = mapData["name"]
      val descriptionText = mapData["description"]
      val importance = NotificationManager.IMPORTANCE_DEFAULT
      val mChannel = NotificationChannel(id, name, importance)
      mChannel.description = descriptionText
      val notificationManager =
          context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
      notificationManager.createNotificationChannel(mChannel)
      completed = true
    } else completed = false
    return completed
  }

  override fun onNewIntent(intent: Intent): Boolean {
    // to be implemented yet
    Log.e("hello", "====================================>")
    return true
  }
}
