import 'package:cd_automation/pages/AdminPages/Powermeterlistdetailsdwn.dart';
import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:flutter/material.dart';

class Powermeterlistdwnrpt extends StatelessWidget {
  const Powermeterlistdwnrpt({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<String>> categories = {
      'Power House': ['Lighting', 'Main Incoming', 'Generator'],
      'Fabric Section': [
        'Ro plant',
        'IR Compressor',
        'LG Compressor',
        'Tape Plant Chiller',
        'Tape Plant main',
        'Loom 1-8',
        'Jp-Printing',
        'Vp -Printing',
        'Loom 9-21',
        'Old Lamination',
        'Lamination Chiller',
        'Lamination',
      ],
      'Conversion': [
        '2 Colour Printing',
        'Beal',
        'Stiching',
        'Manual Cutting',
        'BCS 2',
        'BCS 1',
        'BCS 3',
        'Gusseting',
        'Tubing',
        'Lamination Cooling Tower',
        '4 Colour Printing',
        'Big Bag Cutting',
        'Solar',
        'Bore Well',
        'Godown Main',
      ],
    };

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
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => NotificationPage()),
                  // );
                },
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                    'Power Meter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...categories.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...entry.value.map((meter) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Powermeterlistdetailsdwn(
                                    categoryName: entry.key,
                                    metername: meter,
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 16,
                              ),
                              side: const BorderSide(color: Color(0xFF00536E)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                meter,
                                style: const TextStyle(
                                  color: Color(0xFF00536E),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
