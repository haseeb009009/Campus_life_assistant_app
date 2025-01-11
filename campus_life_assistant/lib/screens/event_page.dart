import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/firestore_service.dart';
import '../services/local_event_service.dart';
import '../services/event_sync_service.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final EventFirestoreService _firestoreService = EventFirestoreService();
  final LocalEventService _localService = LocalEventService();
  final EventSyncService _syncService = EventSyncService();

  @override
  void initState() {
    super.initState();
    LocalEventService.initialize();
  }

  /// Displays a form dialog for adding or editing events
  Future<void> _showEventDialog({Event? event}) async {
    final TextEditingController nameController =
        TextEditingController(text: event?.name ?? '');
    final TextEditingController locationController =
        TextEditingController(text: event?.location ?? '');
    final TextEditingController dateController =
        TextEditingController(text: event?.date.toIso8601String() ?? '');

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(event == null ? 'Add Event' : 'Edit Event'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                  controller: nameController,
                  label: 'Name',
                ),
                _buildTextField(
                  controller: locationController,
                  label: 'Location',
                ),
                _buildTextField(
                  controller: dateController,
                  label: 'Date',
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      dateController.text = date.toIso8601String();
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
              onPressed: () => _saveEvent(
                nameController: nameController,
                locationController: locationController,
                dateController: dateController,
                event: event,
              ),
              child: Text(event == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  /// Builds a reusable TextField widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      readOnly: readOnly,
      onTap: onTap,
    );
  }

  /// Saves a new or updated event
  Future<void> _saveEvent({
    required TextEditingController nameController,
    required TextEditingController locationController,
    required TextEditingController dateController,
    Event? event,
  }) async {
    if (nameController.text.isEmpty ||
        locationController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    final newEvent = Event(
      id: event?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      location: locationController.text,
      date: DateTime.parse(dateController.text),
    );

    if (event == null) {
      await _firestoreService.addEvent(newEvent);
      await _localService.addEvent(newEvent);
    } else {
      await _firestoreService.updateEvent(newEvent);
      await _localService.updateEvent(newEvent);
    }

    if (mounted) Navigator.pop(context);
  }

  /// Deletes an event
  Future<void> _deleteEvent(Event event) async {
    await _firestoreService.deleteEvent(event.id);
    await _localService.deleteEvent(event.id);
    setState(() {});
  }

  /// Synchronizes events between Firestore and SQLite
  Future<void> _syncEvents() async {
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
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _syncEvents,
          ),
        ],
      ),
      body: _buildEventList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Builds the event list view
  Widget _buildEventList() {
    return StreamBuilder<List<Event>>(
      stream: _firestoreService.getEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final events = snapshot.data ?? [];
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventListItem(event);
          },
        );
      },
    );
  }

  /// Builds a single event list item
  Widget _buildEventListItem(Event event) {
    return ListTile(
      title: Text(event.name),
      subtitle: Text(event.location),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEventDialog(event: event),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteEvent(event),
          ),
        ],
      ),
    );
  }
}
