import 'package:campus_life_assistant/screens/feedback_page.dart';
import 'package:campus_life_assistant/screens/study_group_page.dart';
import 'package:flutter/material.dart';
import '../screens/class_schedule_page.dart';
import '../screens/event_page.dart';
import '../screens/assignment_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildElevatedButton(
                context: context,
                label: "View Classes",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ClassSchedulePage()),
                  );
                },
              ),
              _buildElevatedButton(
                context: context,
                label: "View Events",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EventPage()),
                  );
                },
              ),
              _buildElevatedButton(
                context: context,
                label: "View Assignments",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AssignmentPage()),
                  );
                },
              ),
              _buildElevatedButton(
                context: context,
                label: "View Study Groups",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StudyGroupPage()),
                  );
                },
              ),
              _buildElevatedButton(
                context: context,
                label: "Feedback System",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FeedbackPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A helper method to create consistently styled buttons
  Widget _buildElevatedButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          backgroundColor: Colors.lightBlue.shade600,
          foregroundColor: Colors.white,
          shadowColor: Colors.lightBlueAccent,
          elevation: 6.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
