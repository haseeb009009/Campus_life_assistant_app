import 'package:flutter/material.dart';
import '../models/assignment.dart';
import '../services/assignment_firestore_service.dart';
import '../services/local_assignment_service.dart';
import '../services/assignment_sync_service.dart';

class AssignmentPage extends StatefulWidget {
  const AssignmentPage({super.key});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final AssignmentFirestoreService _firestoreService =
      AssignmentFirestoreService();
  final LocalAssignmentService _localService = LocalAssignmentService();
  final AssignmentSyncService _syncService = AssignmentSyncService();

  @override
  void initState() {
    super.initState();
    LocalAssignmentService.initialize();
  }

  Future<void> _showAssignmentDialog({Assignment? assignment}) async {
    final TextEditingController titleController =
        TextEditingController(text: assignment?.title ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: assignment?.description ?? '');
    final TextEditingController dueDateController = TextEditingController(
        text: assignment?.dueDate.toIso8601String() ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(assignment == null ? 'Add Assignment' : 'Edit Assignment'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: dueDateController,
                  decoration: const InputDecoration(labelText: 'Due Date'),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      dueDateController.text = date.toIso8601String();
                    }
                  },
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
                if (titleController.text.isEmpty ||
                    descriptionController.text.isEmpty ||
                    dueDateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }

                final newAssignment = Assignment(
                  id: assignment?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  dueDate: DateTime.parse(dueDateController.text),
                );

                if (assignment == null) {
                  await _firestoreService.addAssignment(newAssignment);
                  await _localService.addAssignment(newAssignment);
                } else {
                  await _firestoreService.updateAssignment(newAssignment);
                  await _localService.updateAssignment(newAssignment);
                }

                // ignore: use_build_context_synchronously
                if (mounted) Navigator.pop(context);
              },
              child: Text(assignment == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAssignment(Assignment assignment) async {
    await _firestoreService.deleteAssignment(assignment.id);
    await _localService.deleteAssignment(assignment.id);
    setState(() {});
  }

  /// Sync assignments between Firestore and SQLite
  Future<void> _syncAssignments() async {
    await _syncService.syncData();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sync completed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _syncAssignments,
          ),
        ],
      ),
      body: StreamBuilder<List<Assignment>>(
        stream: _firestoreService.getAssignments(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final assignments = snapshot.data ?? [];

          return ListView.builder(
            itemCount: assignments.length,
            itemBuilder: (context, index) {
              final assignment = assignments[index];
              return ListTile(
                title: Text(assignment.title),
                subtitle: Text(assignment.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showAssignmentDialog(assignment: assignment),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteAssignment(assignment),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAssignmentDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
