import 'dart:convert';
import 'package:attendance/pages/student_home.dart';
import 'package:attendance/pages/admin_home.dart';
import 'package:attendance/pages/faculty_home.dart';
//import 'package:attendance/pages/second_page.dart';
//import 'package:attendance/components/square_title.dart';
import 'package:attendance/components/my_button.dart';
import 'package:attendance/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  //text editing controller
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  Future<void> login(BuildContext context) async {
    if (username.text.trim().isEmpty || password.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill all fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    } else {
      //var url = "http://192.168.56.1/localconnect/login.php";

      final response = await http.post(
        Uri.parse('http://192.168.56.1/localconnect/login.php'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': username.text, 'password': password.text},
      );

      print("Server Response: ${response.body}"); // Debugging output

      try {
        var data = json.decode(response.body);

        if (data["status"] == "Success") {
          String role = data["role"];
          Fluttertoast.showToast(
            msg: "Login successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          if (role == "admin") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminPage()),
            );
          } else if (role == "faculty") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FacultyPage()),
            );
          } else if (role == "student") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentPage()),
            );
          } else {
            Fluttertoast.showToast(
              msg: "Unknown role: $role",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Invalid username or password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      } catch (e) {
        print("Error decoding response: $e");
      }
    }
  }

  //singUserIn method
  void singUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),
              //lock image
              const Icon(Icons.lock, size: 90),

              SizedBox(height: 50),

              //welcome text
              Text(
                "welcome",
                style: TextStyle(color: Colors.grey[850], fontSize: 16),
              ),

              SizedBox(height: 20),

              //login form usrename
              MyTextField(
                controller: username,
                hintText: "Username",
                obscureText: false,
              ),

              SizedBox(height: 10),
              //password
              MyTextField(
                controller: password,
                hintText: "Password",
                obscureText: true,
              ),

              //forgot password
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey[850], fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              //sign in button
              ButtonTheme(
                minWidth: 200,
                height: 50,
                child: MyButton(
                  onTap: () {
                    login(context);
                  },
                ),
              ),

              //not a member register now
            ],
          ),
        ),
      ),
    );
  }
}
