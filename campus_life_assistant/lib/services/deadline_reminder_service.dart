import 'package:flutter/material.dart';
import 'notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DeadlineReminderService {
  static Future<void> scheduleClassReminder({
    required String title,
    required DateTime deadline,
    required int id,
  }) async {
    _scheduleReminder(title: title, deadline: deadline, id: id);
  }

  static Future<void> scheduleEventReminder({
    required String title,
    required DateTime deadline,
    required int id,
  }) async {
    _scheduleReminder(title: title, deadline: deadline, id: id + 1000); // Separate IDs
  }

  static Future<void> scheduleAssignmentReminder({
    required String title,
    required DateTime deadline,
    required int id,
  }) async {
    _scheduleReminder(title: title, deadline: deadline, id: id + 2000); // Separate IDs
  }

  static Future<void> _scheduleReminder({
    required String title,
    required DateTime deadline,
    required int id,
  }) async {
    tz.initializeTimeZones();
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(deadline, tz.local);

    await NotificationService.scheduleNotification(
      id: id,
      title: 'Reminder: $title',
      body: 'Your deadline is approaching!',
      scheduledDate: scheduledDate,
    );
  }

  static Future<void> cancelReminder(int id) async {
    await NotificationService.cancelNotification(id);
  }

  static Future<void> cancelAllReminders() async {
    await NotificationService.cancelAllNotifications();
  }
}
