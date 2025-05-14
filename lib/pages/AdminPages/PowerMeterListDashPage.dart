import 'package:cd_automation/pages/AdminPages/PowerMeterDetailsDashPage.dart';
import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:cd_automation/pages/components/CustomAppBar.dart';
import 'package:flutter/material.dart';

class Powermeterlistdashpage extends StatefulWidget {
  const Powermeterlistdashpage({super.key});

  @override
  State<Powermeterlistdashpage> createState() => _PowermeterlistdashpageState();
}

class _PowermeterlistdashpageState extends State<Powermeterlistdashpage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FlyoutBar(),
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
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
                    ...entry.value.map((metername) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Powermeterdetailsdashpage(
                                    categoryName: entry.key,
                                    powerMeterName: metername,
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
                                metername,
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
