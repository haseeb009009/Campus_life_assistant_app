// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import '../screens/class_schedule_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClassSchedulePage()),
            );
          },
          child: const Text("View Classes"),
        ),
      ),
    );
  }
}
