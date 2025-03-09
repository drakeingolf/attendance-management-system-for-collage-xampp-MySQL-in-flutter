import 'package:attendance/pages/faculty/faculty_home.dart';
import 'package:attendance/pages/login_page.dart';
import 'package:attendance/pages/faculty/mark_attendance.dart'; // Add this line
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FacultyDashboard(),
      routes: {
        '/faculty': (context) => FacultyDashboard(),
        '/login': (context) => LoginPage(),
        '/markAttendance': (context) => AttendancePage(),
      },
    );
  }
}
