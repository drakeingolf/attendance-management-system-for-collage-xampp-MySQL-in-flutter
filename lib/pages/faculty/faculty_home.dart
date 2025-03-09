import 'package:attendance/pages/faculty/Widgets/drawer.dart';
import 'package:flutter/material.dart';

class FacultyDashboard extends StatefulWidget {
  @override
  _FacultyDashboardState createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  String facultyName = "Lini Miss."; // Simulated database fetch
  String selectedSubject = "";

  @override
  void initState() {
    super.initState();
    fetchFacultyName();
  }

  void fetchFacultyName() {
    // Simulate fetching from database
    setState(() {
      facultyName = "Dr. John Doe"; // Replace with actual fetched name
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDFFFD7), // Light green background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      drawer: CustomDrawer(facultyName: facultyName),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi,",
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  facultyName,
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.07,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "your subjects:",
                  style: TextStyle(
                    fontSize: constraints.maxWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Subject List
                SubjectCard(
                  "CST201",
                  "DATA STRUCTURES",
                  selectedSubject,
                  (code) => setState(() => selectedSubject = code),
                ),
                SubjectCard(
                  "CST301",
                  "ALGORITHM AND ANALYSIS",
                  selectedSubject,
                  (code) => setState(() => selectedSubject = code),
                ),
                SubjectCard(
                  "CST202",
                  "OBJECTIVE ORIENTED PROGRAMMING",
                  selectedSubject,
                  (code) => setState(() => selectedSubject = code),
                ),
                Spacer(),
                // Buttons at the bottom
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.black),
                      onPressed: () {
                        // Navigate to mark attendance page
                        Navigator.pushNamed(context, '/markAttendance');
                      },
                      iconSize: constraints.maxWidth * 0.08,
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: Icon(Icons.visibility, color: Colors.black),
                      onPressed: () {},
                      iconSize: constraints.maxWidth * 0.08,
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Widget for displaying subject details
class SubjectCard extends StatelessWidget {
  final String code;
  final String title;
  final String selectedSubject;
  final Function(String) onSelect;

  SubjectCard(this.code, this.title, this.selectedSubject, this.onSelect);

  @override
  Widget build(BuildContext context) {
    bool isSelected = selectedSubject == code;
    return GestureDetector(
      onTap: () => onSelect(code),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: isSelected ? Colors.greenAccent : Colors.white,
        child: ListTile(
          title: Text(
            code,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          subtitle: Text(
            title,
            style: TextStyle(color: isSelected ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
