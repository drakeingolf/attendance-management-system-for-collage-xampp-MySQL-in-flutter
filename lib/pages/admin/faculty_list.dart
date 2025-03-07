import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:attendance/components/custom_drawer.dart';

class FacultyPage extends StatefulWidget {
  final String adminName;
  final String department;

  FacultyPage({required this.adminName, required this.department});

  @override
  _FacultyPageState createState() => _FacultyPageState();
}

class _FacultyPageState extends State<FacultyPage> {
  List<String> facultyList = [];
  List<String> filteredList = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFacultyList();
  }

  Future<void> fetchFacultyList() async {
    final url = Uri.parse(
      "http://10.0.2.2/localconnect/faculty_list.php?department=${widget.department}",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('faculty')) {
          // ✅ Check for 'faculty' key
          setState(() {
            facultyList = List<String>.from(data['faculty']);
            filteredList = facultyList;
            isLoading = false;
          });
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception("Failed to load faculty data");
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteFaculty(String facultyName) async {
    final url = Uri.parse("http://10.0.2.2/localconnect/delete_faculty.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"name": facultyName}),
      );

      final data = json.decode(response.body);
      if (data['success'] == true) {
        setState(() {
          facultyList.remove(facultyName);
          filteredList = List.from(facultyList);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$facultyName deleted successfully")),
        );
      } else {
        throw Exception(data['error']);
      }
    } catch (e) {
      print("Error deleting faculty: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete $facultyName")));
    }
  }

  void filterSearch(String query) {
    setState(() {
      filteredList =
          facultyList
              .where((name) => name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text(
          "Total Staffs: ${facultyList.length}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
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
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: filterSearch,
                      decoration: InputDecoration(
                        hintText: "Search Faculty",
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // Faculty List
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, blurRadius: 4),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          String facultyName = filteredList[index];

                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Text(
                                    facultyName,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteFaculty(facultyName),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Bottom Action Buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(Icons.upload, "Upload"),
                        _buildActionButton(Icons.download, "Download"),
                        _buildActionButton(Icons.add, "Add"),
                        //_buildActionButton(Icons.delete, "Delete"),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildActionButton(IconData icon, String tooltip) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.black12, size: 28),
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
