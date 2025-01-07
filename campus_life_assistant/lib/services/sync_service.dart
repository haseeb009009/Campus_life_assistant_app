import 'firestore_service.dart';
import 'local_storage_service.dart';
// ignore: unused_import
import '../models/class_schedule.dart';

class SyncService {
  final FirestoreService _firestoreService = FirestoreService();
  final LocalStorageService _localStorageService = LocalStorageService();

  Future<void> syncData() async {
    // Download from Firestore and save to local database
    final schedules = await _firestoreService
        .getClassSchedules()
        .first; // Fetch Firestore data once
    for (var schedule in schedules) {
      await _localStorageService.addClassSchedule(schedule);
    }
  }
}
