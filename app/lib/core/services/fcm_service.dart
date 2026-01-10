import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/api_client.dart';
import '../constants/api_constants.dart';

final fcmServiceProvider = Provider<FcmService>((ref) {
  return FcmService(ref);
});

class FcmService {
  final Ref _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FcmService(this._ref);

  Future<void> initialize() async {
    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      // Get token and send to backend
      final token = await _messaging.getToken();
      if (token != null) {
        await _sendTokenToBackend(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen(_sendTokenToBackend);
    }

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background/terminated message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // Check for initial message (app opened from terminated state)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      final dio = _ref.read(dioProvider);
      await dio.put(ApiConstants.userFcmToken, data: {'fcm_token': token});
    } catch (e) {
      // Log error but don't crash - token sync can retry later
      print('Failed to send FCM token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Could show a local notification or update badge
    // For now just log it
    print('Foreground message: ${message.notification?.title}');
  }

  void _handleMessageTap(RemoteMessage message) {
    // TODO: Navigate to relevant screen based on message.data
    // This would require access to GoRouter or a global navigation key
    print('Message tapped: ${message.data}');
  }

  Future<void> deleteToken() async {
    await _messaging.deleteToken();
    try {
      final dio = _ref.read(dioProvider);
      await dio.put(ApiConstants.userFcmToken, data: {'fcm_token': null});
    } catch (e) {
      print('Failed to clear FCM token: $e');
    }
  }
}
