import 'dart:convert';
import 'package:cd_automation/Apivariables.dart';
import 'package:cd_automation/pages/AdminPages/DownloadReport.dart';
import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:cd_automation/pages/components/CustomAppBar.dart';
import 'package:cd_automation/pages/components/Downloadreportfrompicker.dart';
import 'package:cd_automation/util/Filestorage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Watermeterlistdwndetails extends StatefulWidget {
  final String meter;
  final DateTime? fromdate;
  final DateTime? todate;

  const Watermeterlistdwndetails({
    super.key,
    required this.meter,
    this.fromdate,
    this.todate,
  });

  @override
  State<Watermeterlistdwndetails> createState() =>
      _WatermeterlistdwndetailsState();
}

class _WatermeterlistdwndetailsState extends State<Watermeterlistdwndetails> {
  final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String? formatDateTimeToString(DateTime? dateTime) {
    if (dateTime == null) {
      return null;
    }
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future<void> downloadReport(BuildContext context, String fromDate,
      String toDate, String meterName) async {
    try {
      final response = await http.post(
        Uri.parse('${Apivariables.download_reports}/$meterName'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "from_date": fromDate,
          "to_date": toDate,
        }),
      );

      if (response.statusCode == 200) {
        await FileStorage.writeBinaryFile(
            response.bodyBytes, '$meterName-report.pdf');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report saved to Downloads as $meterName-report.pdf'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to generate the report from the server.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while saving the report.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const FlyoutBar(),
      key: scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
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
                const Text(
                  'Water Meter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[100],
                ),
                child: Center(
                  child: Text(
                    widget.meter,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70),
            // (Optional) Additional Widgets can go here
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // From Date Button
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF387589),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Downloadreportfrompicker(
                            category: "Water meter",
                            meter: widget.meter,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      widget.fromdate != null
                          ? dateFormatter.format(widget.fromdate!)
                          : 'From Date',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF387589),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {},
                    child: Text(
                      widget.todate != null
                          ? dateFormatter.format(widget.todate!)
                          : 'To Date',
                      style: const TextStyle(
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
            Opacity(
              opacity: (widget.fromdate != null && widget.todate != null)
                  ? 1.0
                  : 0.9, // 👈 reduced opacity when disabled
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00536E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: (widget.fromdate != null && widget.todate != null)
                    ? () {
                        String? fromDate =
                            formatDateTimeToString(widget.fromdate);
                        String? toDate = formatDateTimeToString(widget.todate);
                        downloadReport(
                            context, fromDate!, toDate!, widget.meter);
                      }
                    : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Download Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.cloud_download,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            Opacity(
              opacity: (widget.fromdate != null && widget.todate != null)
                  ? 1.0
                  : 0.5,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF00536E), width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: (widget.fromdate != null && widget.todate != null)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Downloadreport(
                              meter: widget.meter,
                              fromdate: widget.fromdate,
                              todate: widget.todate,
                            ),
                          ),
                        );
                      }
                    : null, // disables the button if either date is null
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'View Report',
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
            ),
          ],
        ),
      ),
    );
  }
}
