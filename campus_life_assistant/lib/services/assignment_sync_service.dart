// ignore: unused_import
import '../models/assignment.dart';
import 'assignment_firestore_service.dart';
import 'local_assignment_service.dart';

class AssignmentSyncService {
  final AssignmentFirestoreService _firestoreService = AssignmentFirestoreService();
  final LocalAssignmentService _localService = LocalAssignmentService();

  /// Sync assignments from Firestore to SQLite
  Future<void> syncFromFirestoreToLocal() async {
    // Fetch assignments from Firestore
    final assignments = await _firestoreService.getAssignments().first;

    // Save assignments to local SQLite database
    for (var assignment in assignments) {
      await _localService.addAssignment(assignment);
    }
  }

  /// Sync assignments from SQLite to Firestore
  Future<void> syncFromLocalToFirestore() async {
    // Fetch assignments from local SQLite database
    final localAssignments = await _localService.getAssignments();

    // Save assignments to Firestore
    for (var assignment in localAssignments) {
      await _firestoreService.addAssignment(assignment);
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
