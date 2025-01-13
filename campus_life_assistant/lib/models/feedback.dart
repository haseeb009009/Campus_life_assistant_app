class FeedbackModel {
  String id;
  String category; // E.g., "Course", "Professor", "Service"
  String itemName; // Name of the course, professor, or service
  String userId; // ID of the user giving feedback
  double rating;
  String comment;

  FeedbackModel({
    required this.id,
    required this.category,
    required this.itemName,
    required this.userId,
    required this.rating,
    required this.comment,
  });

  // Convert from Firestore data
  factory FeedbackModel.fromFirestore(Map<String, dynamic> data, String id) {
    return FeedbackModel(
      id: id,
      category: data['category'],
      itemName: data['itemName'],
      userId: data['userId'],
      rating: data['rating'].toDouble(),
      comment: data['comment'],
    );
  }

  // Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'category': category,
      'itemName': itemName,
      'userId': userId,
      'rating': rating,
      'comment': comment,
    };
  }
}
