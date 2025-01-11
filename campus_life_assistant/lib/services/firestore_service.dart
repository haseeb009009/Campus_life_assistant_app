import 'package:campus_life_assistant/models/event.dart';
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

class EventFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'events';

  Future<void> addEvent(Event event) async {
    await _firestore.collection(collectionPath).add(event.toFirestore());
  }

  Future<void> updateEvent(Event event) async {
    await _firestore
        .collection(collectionPath)
        .doc(event.id)
        .update(event.toFirestore());
  }

  Future<void> deleteEvent(String id) async {
    await _firestore.collection(collectionPath).doc(id).delete();
  }

  Stream<List<Event>> getEvents() {
    return _firestore.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Event.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}
