import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/class_schedule.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'classSchedules';

  Future<void> addClassSchedule(ClassSchedule schedule) async {
    await _firestore.collection(collectionPath).add(schedule.toFirestore());
  }

  Future<void> updateClassSchedule(ClassSchedule schedule) async {
    await _firestore
        .collection(collectionPath)
        .doc(schedule.id)
        .update(schedule.toFirestore());
  }

  Future<void> deleteClassSchedule(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }

  Stream<List<ClassSchedule>> getClassSchedules() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ClassSchedule.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}
