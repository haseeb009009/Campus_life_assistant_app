// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:flutter/material.dart';
import '../models/class_schedule.dart';
import '../services/firestore_service.dart';
import '../services/local_storage_service.dart';

class ClassSchedulePage extends StatefulWidget {
  const ClassSchedulePage({Key? key}) : super(key: key);

  @override
  State<ClassSchedulePage> createState() => _ClassSchedulePageState();
}

class _ClassSchedulePageState extends State<ClassSchedulePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final LocalStorageService _localStorageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    LocalStorageService.initialize(); // Initialize SQLite database
  }

  Future<void> _showFormDialog({ClassSchedule? schedule}) async {
    final TextEditingController titleController =
        TextEditingController(text: schedule != null ? schedule.title : '');
    final TextEditingController descriptionController = TextEditingController(
        text: schedule != null ? schedule.description : '');
    final TextEditingController startTimeController = TextEditingController(
        text: schedule != null ? schedule.startTime.toIso8601String() : '');
    final TextEditingController endTimeController = TextEditingController(
        text: schedule != null ? schedule.endTime.toIso8601String() : '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(schedule == null ? 'Add Schedule' : 'Edit Schedule'),
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
                  controller: startTimeController,
                  decoration: const InputDecoration(labelText: 'Start Time'),
                  onTap: () async {
                    final time = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (time != null) {
                      startTimeController.text = time.toIso8601String();
                    }
                  },
                ),
                TextField(
                  controller: endTimeController,
                  decoration: const InputDecoration(labelText: 'End Time'),
                  onTap: () async {
                    final time = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (time != null) {
                      endTimeController.text = time.toIso8601String();
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
                    startTimeController.text.isEmpty ||
                    endTimeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }

                final newSchedule = ClassSchedule(
                  id: schedule?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text,
                  description: descriptionController.text,
                  startTime: DateTime.parse(startTimeController.text),
                  endTime: DateTime.parse(endTimeController.text),
                );

                if (schedule == null) {
                  await _firestoreService.addClassSchedule(newSchedule);
                  await _localStorageService.addClassSchedule(newSchedule);
                } else {
                  await _firestoreService.updateClassSchedule(newSchedule);
                  await _localStorageService.updateClassSchedule(newSchedule);
                }

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(schedule == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteSchedule(ClassSchedule schedule) async {
    await _firestoreService.deleteClassSchedule(schedule.id);
    await _localStorageService.deleteClassSchedule(schedule.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Schedules'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              // Call sync logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing data...')),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ClassSchedule>>(
        stream: _firestoreService.getClassSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final schedules = snapshot.data ?? [];

          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ListTile(
                title: Text(schedule.title),
                subtitle: Text(schedule.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showFormDialog(schedule: schedule),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteSchedule(schedule),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
