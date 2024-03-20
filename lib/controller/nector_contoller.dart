import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nector/model/network_call.dart';
import 'package:nector/model/network_response.dart';
import 'package:nector/utils/nector_utils.dart';
import 'package:nector/view/calls_view.dart';
import 'package:rxdart/rxdart.dart';

class NectorController {
  final String appName;

  final String appIcon;

  final BehaviorSubject<List<NectorNetworkCall>> callsSubject =
      BehaviorSubject.seeded([]);

  final GlobalKey<NavigatorState> _navigatorKey;

  final int _maxCallsCount = 1000;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isNotificationProcessing = false, showNotification;

  OverlayEntry? _callsListView, _callDetailView;

  NectorController({
    required this.showNotification,
    required this.appName,
    required this.appIcon,
    required GlobalKey<NavigatorState> navigatorKey,
  }) : _navigatorKey = navigatorKey {
    _initialiseNotificationsPlugin();
    callsSubject.listen((_) => _onCallsChanged());
  }

  /// Adds network call to calls subject
  void addNetworkCall(NectorNetworkCall call) {
    final int callsCount = callsSubject.value.length;
    final calls = List<NectorNetworkCall>.from(callsSubject.value);
    if (callsCount >= _maxCallsCount) calls.removeLast();
    calls.insert(0, call);
    callsSubject.add(calls);
  }

  /// Adds response to existing network call
  void addResponse(NectorNetworkResponse response, int requestId) {
    final requestCall = _getRequestCall(requestId);
    if (requestCall == null) {
      NectorUtils.log('Request call is null');
      return;
    }
    requestCall
      ..isLoading = false
      ..networkResponse = response
      ..duration = response.time
          .difference(requestCall.networkRequest!.time)
          .inMilliseconds;

    callsSubject.add(callsSubject.value);
  }

  Future<void> _onCallsChanged() async {
    if (callsSubject.value.isNotEmpty) {
      if (showNotification && !_isNotificationProcessing) {
        await _showNotification();
      }
    }
  }

  Future<void> _showNotification() async {
    _isNotificationProcessing = true;
    const channelId = 'Nector';
    const channelName = 'Nector';
    const channelDescription = 'Nector';
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      enableVibration: false,
      playSound: false,
      largeIcon: DrawableResourceAndroidBitmap(appIcon),
    );
    const iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(presentSound: false);
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Recording Network Activity',
      '${callsSubject.value.length} requests',
      platformChannelSpecifics,
      payload: '',
    );
    _isNotificationProcessing = false;
  }

  void _initialiseNotificationsPlugin() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(appIcon);
    const initializationSettingsIOS = DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          _onSelectNotification();
          break;
        default:
          break;
      }
    });
  }

  void _onSelectNotification() {
    navigateToInspector();
  }

  void navigateToInspector() {
    _addCallsListView(OverlayEntry(builder: (context) {
      return NectorCallsView(this);
    }));
  }

  void onClickClearLogs() {
    callsSubject.add([]);
  }

  void _addCallsListView(OverlayEntry widget) {
    removeCallsListView();
    removeCallDetailView();
    _callsListView = widget;
    _navigatorKey.currentState!.overlay!.insert(widget);
  }

  void addCallDetailView(OverlayEntry widget) {
    _callDetailView = widget;
    _navigatorKey.currentState?.overlay?.insert(widget);
  }

  void removeCallsListView() {
    _callsListView?.remove();
    _callsListView = null;
  }

  void removeCallDetailView() {
    _callDetailView?.remove();
    _callDetailView = null;
  }

  NectorNetworkCall? _getRequestCall(int requestId) =>
      callsSubject.value.firstWhere((call) => call.id == requestId);
}
