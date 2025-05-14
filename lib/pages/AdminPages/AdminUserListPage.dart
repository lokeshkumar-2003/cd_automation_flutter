import 'dart:convert';

import 'package:cd_automation/Apivariables.dart';
import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:cd_automation/pages/components/CustomAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cd_automation/pages/AdminPages/DetailsPage.dart';

class AdminUserListPage extends StatefulWidget {
  const AdminUserListPage({super.key});

  @override
  State<AdminUserListPage> createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends State<AdminUserListPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> adminUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAdminUsers();
  }

  Future<void> loadAdminUsers() async {
    setState(() {
      isLoading = true;
    });

    String url = '${Apivariables.get_user_list}/admin_users';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          adminUsers =
              data.map((user) => Map<String, dynamic>.from(user)).toList();
          isLoading = false;
        });
      } else {
        print("Failed to load admin users: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching admin users: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const FlyoutBar(),
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Admin List',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Admin User',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00536E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  ...adminUsers.map((user) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdminDetailPage(
                                  userName: user['Name'] ?? 'Unnamed',
                                  userId: user['userId'],
                                  userType: "admin_users",
                                ),
                              ),
                            );

                            if (result == true) {
                              loadAdminUsers();
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: const Color(0xFFF8F9FA),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 20,
                            ),
                            side: const BorderSide(color: Color(0xFF00536E)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              user['Name'] ?? 'Unnamed',
                              style: const TextStyle(color: Color(0xFF00536E)),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }
}
