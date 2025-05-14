import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cd_automation/pages/AdminPages/ScannerDetailsPage.dart';
import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:cd_automation/pages/components/CustomAppBar.dart';
import 'package:cd_automation/util/Localstorage.dart';

class Scannerviewpage extends StatefulWidget {
  final String metername;
  final String metertype;
  const Scannerviewpage(
      {super.key, required this.metername, required this.metertype});

  @override
  _ScannerviewpageState createState() => _ScannerviewpageState();
}

class _ScannerviewpageState extends State<Scannerviewpage> {
  String? usertype;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    usertype = await LocalStorage().getUserTypeData();
    setState(() {}); // Call setState after fetching the data
  }

  Future<void> captureImage() async {
    if (usertype == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User type is not ready. Please wait...")),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final File capturedImage = File(pickedFile.path);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Scannerdetailspage(
              capturedImage: capturedImage,
              metername: widget.metername,
              meterType: widget.metertype,
              userType: usertype!),
        ),
      );
    } else {
      print('No image selected.');
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
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Scanner',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.metername,
              style: const TextStyle(fontSize: 20, color: Color(0xFF00536E)),
            ),
            const SizedBox(height: 20),
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Check if user type is admin to show the edit and upload button
                    if (usertype == "admin_users")
                      IconButton(
                        icon: const Icon(Icons.edit_note,
                            size: 32, color: Color(0xFF00536E)),
                        onPressed: captureImage,
                      ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt,
                          size: 32, color: Color(0xFF00536E)),
                      onPressed: captureImage,
                    ),
                    if (usertype == "admin_users")
                      IconButton(
                        icon: const Icon(Icons.cloud_upload_rounded,
                            size: 32, color: Color(0xFF00536E)),
                        onPressed: () {
                          // Implement upload logic here
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 150),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00536E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: captureImage,
              child: const Text(
                'Click camera to capture',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00536E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
