import 'package:flutter/material.dart';
import 'package:student_management_system/screens/home_screen.dart'; // Correct import path

void main() {
  runApp(StudentCrudApp());
}

class StudentCrudApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student CRUD',
      home: HomeScreen(), // Make sure HomeScreen exists in home_screen.dart
    );
  }
}
