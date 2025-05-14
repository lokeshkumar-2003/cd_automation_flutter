import 'dart:convert';

import 'package:cd_automation/Apivariables.dart';
import 'package:cd_automation/util/Localstorage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? selectedUserType;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _signIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(Apivariables.login_url);
      Map<String, dynamic> logindata = {
        "Username": usernameController.text.trim(),
        "Password": passwordController.text.trim(),
        "Usertype": selectedUserType,
      };

      final response = await http.post(
        url,
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(logindata),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        String userDeviceId = responseData['device_uuid'];
        String? userIdOnDevice = sharedPreferences.getString("device_uuid");
        userIdOnDevice = userIdOnDevice?.replaceAll(RegExp(r'[\[\]]'), '');
        if (userDeviceId != userIdOnDevice) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Login failed: This account is not registered on this device.",
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Login successful'),
            backgroundColor: Colors.green,
          ),
        );

        await LocalStorage().setUserTypeData(selectedUserType!);
        await LocalStorage().setUserNameData(usernameController.text.trim());
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        final responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['error'] ?? 'Login failed'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred during sign in. Please try again."),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and Title
              Column(
                children: [
                  Image.asset(
                    "assets/images/industries.png",
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "CD Technotex",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Dropdown for User Type Selection
              DropdownButtonFormField<String>(
                value: selectedUserType,
                decoration: InputDecoration(
                  labelText: "Select User",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.person, color: Colors.grey),
                ),
                items: ["Admin User", "Regular User"]
                    .map(
                      (user) => DropdownMenuItem(
                        value: user == "Admin User"
                            ? "admin_users"
                            : "regular_users",
                        child: Text(user),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUserType = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Username TextField
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 20),

              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 30),

              // Sign in button with loading indicator
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00536E),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isLoading ? null : _signIn,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          "Sign in",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
