import 'package:cd_automation/pages/AdminPages/DownloadReport.dart';
import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:cd_automation/pages/components/Downloadreportfrompicker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Powermeterlistdetailsdwn extends StatelessWidget {
  final String metername;
  final String categoryName;
  final DateTime? fromdate;
  final DateTime? todate;

  Powermeterlistdetailsdwn(
      {super.key,
      required this.metername,
      required this.categoryName,
      this.fromdate,
      this.todate});

  final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FlyoutBar(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00536E),
        title: const Text(
          'CD Automation',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () {}),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  'Power Meter',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8), // Space between texts
                const Text(
                  '>', // Breadcrumb separator
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8), // Space between texts
                Text(
                  categoryName, // ✅ Display category name dynamically
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue[100],
              ),
              child: Center(
                child: Text(
                  metername,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70),
            Column(
              children: [
                // Text(
                //   'Select a Date',
                //   style: TextStyle(fontSize: 20),
                //   textAlign: TextAlign.left,
                // ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150, // Set a fixed width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF387589), // Dark Teal
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Downloadreportfrompicker(
                            meter: metername,
                            category: "Power meter",
                          ),
                        ),
                      );
                    },
                    child: Text(
                      fromdate != null
                          ? dateFormatter.format(fromdate!)
                          : 'From Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 150, // Set a fixed width
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF387589), // Dark Teal
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      // Action
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => DwdToPage(
                      //       userName: userName,
                      //       fromDate: DateTime.now(),
                      //       toDate: DateTime.now(),
                      //     ),
                      //   ),
                      // );
                    },
                    child: Text(
                      todate != null
                          ? dateFormatter.format(todate!)
                          : 'To Date',
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
            const SizedBox(height: 150),
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
                // Your view report action here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Downloadreport(
                      meter: metername,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Download Report', // Change text as per need: Edit / Delete / Submit
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 20),
                  Icon(Icons.cloud_download, size: 25, color: Colors.white),
                ],
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Dark Teal

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Color(0xFF00536E), width: 1),
                ),
                padding: EdgeInsets.symmetric(vertical: 14),
                minimumSize: Size(double.infinity, 50), // full width
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Downloadreport(
                      meter: metername,
                    ),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Report', // Change text as per need: Edit / Delete / Submit
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00536E),
                    ),
                  ),
                  SizedBox(width: 20),
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size: 25,
                    color: Color(0xFF00536E),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
