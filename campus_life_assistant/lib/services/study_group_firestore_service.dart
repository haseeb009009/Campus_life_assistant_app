import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/study_group.dart';

class StudyGroupFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'studyGroups';

  // Create a new study group
  Future<void> createStudyGroup(StudyGroup group) async {
    await _firestore.collection(collectionPath).add(group.toFirestore());
  }

  // Join a study group by adding a user to the members list
  Future<void> joinStudyGroup(String groupId, String userId) async {
    final groupRef = _firestore.collection(collectionPath).doc(groupId);
    await groupRef.update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }

  // Leave a study group by removing a user from the members list
  Future<void> leaveStudyGroup(String groupId, String userId) async {
    final groupRef = _firestore.collection(collectionPath).doc(groupId);
    await groupRef.update({
      'members': FieldValue.arrayRemove([userId]),
    });
  }

  // Delete a study group
  Future<void> deleteStudyGroup(String groupId) async {
    await _firestore.collection(collectionPath).doc(groupId).delete();
  }

  // Fetch all study groups
  Stream<List<StudyGroup>> getStudyGroups() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return StudyGroup.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}
