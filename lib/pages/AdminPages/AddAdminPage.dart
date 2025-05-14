import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:cd_automation/Apivariables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddAdminPage extends StatefulWidget {
  const AddAdminPage({super.key});

  @override
  State<AddAdminPage> createState() => _AddAdminPageState();
}

class _AddAdminPageState extends State<AddAdminPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController uuidController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final Uuid uuid = Uuid();

  bool isLoading = false;

  Widget customTextField({
    required String label,
    required String hint,
    bool isOptional = false,
    TextInputType inputType = TextInputType.text,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00536E),
              ),
            ),
            if (isOptional)
              const Text(
                ' (optional)',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF00536E),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: inputType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF00536E)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF00536E)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Future<void> addAdminUser() async {
    setState(() {
      isLoading = true;
    });

    String url = '${Apivariables.add_user}/admin_users';

    Map<String, dynamic> userData = {
      "Name": nameController.text,
      "Username": usernameController.text,
      "Password": passwordController.text,
      "EmailId": emailController.text,
      "Phoneno": int.tryParse(mobileController.text),
      "UserdeviceId": uuidController.text,
      "IsDeviceActive": false
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );

      final responseData = jsonDecode(response.body);
      String message = responseData['message'] ?? 'User updated successfully';

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Admin user added successfully",
                style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        nameController.clear();
        usernameController.clear();
        passwordController.clear();
        emailController.clear();
        mobileController.clear();
        uuidController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Internal server error",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void createUniqueDeviceId(TextEditingController controller) {
    String deviceId = uuid.v4();
    controller.text = deviceId;
  }

  @override
  Widget build(BuildContext context) {
    print(uuidController.text);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/industries.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                const Text(
                  'CD Technotex',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00536E),
                  ),
                ),
                const Text(
                  'Add your admin account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00536E),
                  ),
                ),
                const SizedBox(height: 40),
                customTextField(
                  label: 'Name*',
                  hint: 'kavin',
                  controller: nameController,
                ),
                customTextField(
                  label: 'Username*',
                  hint: 'Mr.kavin123',
                  controller: usernameController,
                ),
                customTextField(
                  label: 'Password*',
                  hint: 'kavin123',
                  controller: passwordController,
                ),
                customTextField(
                  label: 'Email*',
                  hint: 'user@gmail.com',
                  controller: emailController,
                ),
                Row(
                  children: [
                    // UUID TextField
                    Expanded(
                      child: TextFormField(
                        controller: uuidController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Device UUID*',
                          hintText: 'Tap the icon to generate',
                          labelStyle: TextStyle(
                              color: Color(0xFF00536E), // Label color
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xFF387589), width: 1.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color(0xFF387589), width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 8),

                    // IconButton styled to match other inputs
                    Container(
                      height: 58,
                      width: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFF387589),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.auto_fix_high, color: Colors.white),
                        onPressed: () {
                          createUniqueDeviceId(uuidController);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                customTextField(
                  label: 'Mobile number*',
                  hint: '6345 8475 89',
                  controller: mobileController,
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF387589),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00536E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: isLoading ? null : addAdminUser,
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
