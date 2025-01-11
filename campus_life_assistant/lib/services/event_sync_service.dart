// ignore: unused_import
import '../models/event.dart';
import 'firestore_service.dart';
import 'local_event_service.dart';

class EventSyncService {
  final EventFirestoreService _firestoreService = EventFirestoreService();
  final LocalEventService _localService = LocalEventService();

  /// Sync events from Firestore to SQLite
  Future<void> syncFromFirestoreToLocal() async {
    // Fetch events from Firestore
    final events = await _firestoreService.getEvents().first;

    // Save events to local SQLite database
    for (var event in events) {
      await _localService.addEvent(event);
    }
  }

  /// Sync events from SQLite to Firestore
  Future<void> syncFromLocalToFirestore() async {
    // Fetch events from local SQLite database
    final localEvents = await _localService.getEvents();

    // Save events to Firestore
    for (var event in localEvents) {
      await _firestoreService.addEvent(event);
    }
  }

  /// Two-way sync between Firestore and SQLite
  Future<void> syncData() async {
    // Sync from Firestore to SQLite
    await syncFromFirestoreToLocal();

    // Sync from SQLite to Firestore
    await syncFromLocalToFirestore();
  }
}
