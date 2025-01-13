class StudyGroup {
  String id;
  String name;
  String description;
  List<String> members; // Store user IDs of group members

  StudyGroup({
    required this.id,
    required this.name,
    required this.description,
    required this.members,
  });

  // Convert from Firestore data
  factory StudyGroup.fromFirestore(Map<String, dynamic> data, String id) {
    return StudyGroup(
      id: id,
      name: data['name'],
      description: data['description'],
      members: List<String>.from(data['members'] ?? []),
    );
  }

  // Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'members': members,
    };
  }
}
