import 'package:cronometro/services/notification_services.dart';

class NotificationViewModel {
  final NotificationService _notificationService = NotificationService();

  Future initializeNotifications() async {
    await _notificationService.initialize();
  }

  Future generateSimpleNotification() async {
    await _notificationService.showSimpleNotification();
  }

  Future showRunningNotification(String elapsedTime) async {
    await _notificationService.showRunningNotification(elapsedTime);
  }

  Future cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
  }

  Future showLapNotification(String lapTime, String totalTime) async {
    await _notificationService.showLapNotification(lapTime, totalTime);
  }

  Future showPauseReminder() async {
    await _notificationService.showPauseReminder();
  }
}