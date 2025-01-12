import 'services/notification_service.dart';

class AppSetup {
  static Future<void> initialize() async {
    await NotificationService.initialize();
  }
}
