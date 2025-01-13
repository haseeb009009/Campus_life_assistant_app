import 'package:flutter/material.dart';
import '../models/study_group.dart';
import '../services/study_group_firestore_service.dart';

class StudyGroupPage extends StatefulWidget {
  const StudyGroupPage({Key? key}) : super(key: key);

  @override
  State<StudyGroupPage> createState() => _StudyGroupPageState();
}

class _StudyGroupPageState extends State<StudyGroupPage> {
  final StudyGroupFirestoreService _firestoreService =
      StudyGroupFirestoreService();

  Future<void> _showStudyGroupDialog({StudyGroup? group}) async {
    final TextEditingController nameController =
        TextEditingController(text: group?.name ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: group?.description ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(group == null ? 'Create Study Group' : 'Edit Study Group'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Group Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }

                final newGroup = StudyGroup(
                  id: group?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  description: descriptionController.text,
                  members: group?.members ?? [],
                );

                if (group == null) {
                  await _firestoreService.createStudyGroup(newGroup);
                } else {
                  await _firestoreService
                      .createStudyGroup(newGroup); // Update logic if needed
                }

                if (mounted) Navigator.pop(context);
              },
              child: Text(group == null ? 'Create' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Groups'),
      ),
      body: StreamBuilder<List<StudyGroup>>(
        stream: _firestoreService.getStudyGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final groups = snapshot.data ?? [];

          return ListView.builder(
            itemCount: groups.length,
            itemBuilder: (context, index) {
              final group = groups[index];
              return ListTile(
                title: Text(group.name),
                subtitle: Text(group.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.group_add),
                      onPressed: () async {
                        // Replace 'user123' with the actual user ID
                        await _firestoreService.joinStudyGroup(
                            group.id, 'user123');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Joined group')),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.group_remove),
                      onPressed: () async {
                        // Replace 'user123' with the actual user ID
                        await _firestoreService.leaveStudyGroup(
                            group.id, 'haseeb009');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Left group')),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStudyGroupDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
