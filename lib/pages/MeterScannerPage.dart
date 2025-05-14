import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cd_automation/pages/AdminPages/ScannerViewPage.dart';

class MeterScannerPage extends StatefulWidget {
  final String metertype;
  const MeterScannerPage({super.key, required this.metertype});

  @override
  _MeterScannerPageState createState() => _MeterScannerPageState();
}

class _MeterScannerPageState extends State<MeterScannerPage> {
  bool textAvailable = false;
  String barcodeText = '';
  late String metertype;

  @override
  void initState() {
    super.initState();
    if (widget.metertype == "PowerMeter") {
      metertype = "Power Meter";
    } else {
      metertype = "Water Meter";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cd Automation',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF00536E),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please scan the $metertype",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MobileScanner(
                  fit: BoxFit.cover,
                  onDetect: (BarcodeCapture capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        setState(() {
                          textAvailable = true;
                          barcodeText = barcode.rawValue!;
                        });
                      }
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (textAvailable)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Scanned Barcode: $barcodeText',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: textAvailable
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scannerviewpage(
                              metername: barcodeText,
                              metertype: widget.metertype),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    textAvailable ? const Color(0xFF00536E) : Colors.grey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                "Click camera to capture",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                side: const BorderSide(color: Color(0xFF00536E)),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 16, color: Color(0xFF00536E)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
