import 'dart:convert';
import 'package:cd_automation/Apivariables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cd_automation/pages/AdminPages/PowerMeterSubList.dart';
import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:cd_automation/pages/components/CustomAppBar.dart';

class PowerMeterList extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const PowerMeterList({super.key, required this.scaffoldKey});

  @override
  State<PowerMeterList> createState() => _PowerMeterListState();
}

class _PowerMeterListState extends State<PowerMeterList> {
  bool _isLoading = false;
  List<Map<String, dynamic>> meterList = [];

  @override
  void initState() {
    super.initState();
    getMeterList(); // Fetch data on init
  }

  Future<void> getMeterList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse('${Apivariables.get_meter_list}/Power Meter');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);

        if (decodedData["data"] != null && decodedData["data"] is List) {
          setState(() {
            meterList = List<Map<String, dynamic>>.from(decodedData["data"]);
          });
        }
        print(meterList);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to load meter list"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: const FlyoutBar(),
      appBar: CustomAppBar(scaffoldKey: widget.scaffoldKey),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        const Text(
                          'Meter',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 50,
                      width: 500,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.table_chart),
                          SizedBox(width: 5),
                          Text(
                            'Power Meter',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00536E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...meterList.map((meter) {
                      final meterName = meter['MeterName'] ?? 'Unnamed Meter';
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              final sectionName =
                                  meterName.replaceAll('/t', '');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PowerMeterSubList(
                                    powerMeterSection: sectionName,
                                  ),
                                ),
                              );
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
                                meterName,
                                style:
                                    const TextStyle(color: Color(0xFF00536E)),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20.0),
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
                        Navigator.pushNamed(context, "/admin/addnewwatermeter");
                      },
                      child: const Text(
                        'Add a new meter',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
