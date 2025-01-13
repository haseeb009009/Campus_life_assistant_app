import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/feedback.dart';

class FeedbackFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = 'feedback';

  // Add feedback
  Future<void> addFeedback(FeedbackModel feedback) async {
    await _firestore.collection(collectionPath).add(feedback.toFirestore());
  }

  // Fetch all feedback for a category
  Stream<List<FeedbackModel>> getFeedbackByCategory(String category) {
    return _firestore
        .collection(collectionPath)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return FeedbackModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}
