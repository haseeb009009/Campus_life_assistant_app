class Assignment {
  String id;
  String title;
  String description;
  DateTime dueDate;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
  });

  // Convert from Firestore data
  factory Assignment.fromFirestore(Map<String, dynamic> data, String id) {
    return Assignment(
      id: id,
      title: data['title'],
      description: data['description'],
      dueDate: DateTime.parse(data['dueDate']),
    );
  }

  // Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  // Convert from SQLite data
  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
    );
  }

  // Convert to SQLite data
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
    };
  }
}
