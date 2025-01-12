import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/assignment.dart';

class AssignmentFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'assignments';

  Future<void> addAssignment(Assignment assignment) async {
    await _firestore.collection(collectionPath).add(assignment.toFirestore());
  }

  Future<void> updateAssignment(Assignment assignment) async {
    await _firestore.collection(collectionPath).doc(assignment.id).update(assignment.toFirestore());
  }

  Future<void> deleteAssignment(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }

  Stream<List<Assignment>> getAssignments() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Assignment.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}
