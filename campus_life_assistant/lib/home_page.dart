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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClassSchedulePage()),
                );
              },
              child: const Text("View Classes"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EventPage()),
                );
              },
              child: const Text("View Events"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AssignmentPage()),
                );
              },
              child: const Text("View Assignments"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StudyGroupPage()),
                );
              },
              child: const Text("View Study Groups"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackPage()),
                );
              },
              child: const Text("Feedback System"),
            ),
          ],
        ),
      ),
    );
  }
}
