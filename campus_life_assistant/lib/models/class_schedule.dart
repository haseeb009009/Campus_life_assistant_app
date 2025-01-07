class ClassSchedule {
  String id; // Firestore document ID
  String title;
  String description;
  DateTime startTime;
  DateTime endTime;

  ClassSchedule({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
  });

  // Convert from Firestore data
  factory ClassSchedule.fromFirestore(Map<String, dynamic> data, String id) {
    return ClassSchedule(
      id: id,
      title: data['title'],
      description: data['description'],
      startTime: DateTime.parse(data['startTime']),
      endTime: DateTime.parse(data['endTime']),
    );
  }

  // Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }

  // Convert to/from SQLite
  factory ClassSchedule.fromMap(Map<String, dynamic> map) {
    return ClassSchedule(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    };
  }
}
