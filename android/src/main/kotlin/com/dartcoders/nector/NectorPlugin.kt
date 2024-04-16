package com.dartcoders.nector

import NectorNotificationService
import android.app.Activity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** NectorPlugin */
class NectorPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "nector")
    context = flutterPluginBinding.applicationContext
    channel.setMethodCallHandler(this)
    // val receiver = NectorNotificationReceiver()
    // val intentFilter = IntentFilter()
    // intentFilter.addAction("com.nector.NOTIFICATION_CLICKED")
    // context.registerReceiver(receiver, intentFilter)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "createNotificationChannel") {
      val argData = call.arguments as java.util.HashMap<String, String>
      val completed = createNotifcationChannel(argData)
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

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  private fun createNotifcationChannel(mapData: HashMap<String, String>): Boolean {
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

  fun onClickNotification(message: String) {
    channel.invokeMethod("onClickNotification", message)
  }
}
