import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:flutter/material.dart';

class UserEditPage extends StatelessWidget {
  final String userName;
  const UserEditPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FlyoutBar(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00536E),
        title:
            const Text('CD Automation', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
          Stack(
            children: [
              IconButton(
                  icon: const Icon(Icons.notifications_none), onPressed: () {}),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle),
                  child: const Text('3',
                      style: TextStyle(fontSize: 10, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                SizedBox(width: 8),
                Text('Regular User',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 80),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey.shade100,
              ),
              child: Text(
                userName,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00536E), // Dark Teal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size(double.infinity, 50), // full width
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/admin/editregularuserform");
              },
              child: Text(
                'Edit', // Change text as per need: Edit / Delete / Submit
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00536E), // Dark Teal
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size(double.infinity, 50), // full width
              ),
              onPressed: () {
                // Your action here
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) => DeleteConfirmPage()),
                // );
              },
              child: Text(
                'Delete ', // Change text as per need: Edit / Delete / Submit
                style: TextStyle(
                    fontSize: 16,
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
