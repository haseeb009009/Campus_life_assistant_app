import 'package:flutter/material.dart';
import '../models/feedback.dart';
import '../services/feedback_firestore_service.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FeedbackFirestoreService _feedbackService = FeedbackFirestoreService();
  String selectedCategory = "Course";
  final List<String> categories = ["Course", "Professor", "Service"];

  Future<void> _showFeedbackDialog() async {
    final TextEditingController itemNameController = TextEditingController();
    final TextEditingController commentController = TextEditingController();
    double rating = 3.0; // Initial rating value

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Feedback'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setDialogState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: categories
                          .map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value ?? "Course";
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    TextField(
                      controller: itemNameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: commentController,
                      decoration: const InputDecoration(labelText: 'Comment'),
                    ),
                    const SizedBox(height: 10),
                    Text('Rating: ${rating.toStringAsFixed(1)}'),
                    Slider(
                      value: rating,
                      min: 1.0,
                      max: 5.0,
                      divisions: 4,
                      label: rating.toString(),
                      onChanged: (value) {
                        setDialogState(() {
                          rating = value;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (itemNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Item name is required')),
                  );
                  return;
                }

                final feedback = FeedbackModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  category: selectedCategory,
                  itemName: itemNameController.text,
                  userId: 'haseeb',
                  rating: rating,
                  comment: commentController.text,
                );

                await _feedbackService.addFeedback(feedback);

                if (mounted) Navigator.pop(context);
              },
              child: const Text('Submit'),
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
        title: const Text('Feedback'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade700,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3E5FC), // Light Blue
              Color(0xFF81D4FA), // Medium Blue
              Color(0xFF0288D1), // Darker Blue
            ],
          ),
        ),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              items: categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value ?? "Course";
                });
              },
            ),
            Expanded(
              child: StreamBuilder<List<FeedbackModel>>(
                stream:
                    _feedbackService.getFeedbackByCategory(selectedCategory),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final feedbackList = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: feedbackList.length,
                    itemBuilder: (context, index) {
                      final feedback = feedbackList[index];
                      return ListTile(
                        title: Text(feedback.itemName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(feedback.comment),
                            Row(
                              children: List.generate(
                                feedback.rating.round(),
                                (index) =>
                                    const Icon(Icons.star, color: Colors.amber),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFeedbackDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
