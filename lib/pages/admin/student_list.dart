import 'package:flutter/material.dart';
import 'package:attendance/components/custom_drawer.dart'; // Ensure this path is correct

class StudentPage extends StatefulWidget {
  final String adminName;
  final String department;
  StudentPage({required this.adminName, required this.department});

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.department} - Student"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
      ),
      drawer: CustomDrawer(adminName: widget.adminName),
      body: Center(
        child: Text("Welcome to the Student Page of ${widget.department}"),
      ),
    );
  }
}
