import 'dart:io';
import 'package:cd_automation/pages/AdminPages/ScannerViewReport.dart';
import 'package:cd_automation/util/Localstorage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:cd_automation/Apivariables.dart';
import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:cd_automation/pages/PopupComponents/SuccessDialog.dart';
import 'package:cd_automation/pages/components/CustomAppBar.dart';

class Scannerdetailspage extends StatefulWidget {
  final File capturedImage;
  final String metername;
  final String meterType;
  final String userType;

  const Scannerdetailspage({
    super.key,
    required this.capturedImage,
    required this.metername,
    required this.meterType,
    required this.userType,
  });

  @override
  State<Scannerdetailspage> createState() => _ScannerdetailspageState();
}

class _ScannerdetailspageState extends State<Scannerdetailspage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  String _extractedDigits = '';

  @override
  void initState() {
    super.initState();
    initFunctions();
    print(widget.meterType);
  }

  void initFunctions() async {
    if (widget.meterType == "WaterMeter") {
      await _submitWaterReading();
    } else {
      await _submitPowerReading();
    }
  }

  Future<void> postReadingValue(String meterName, dynamic detectedValue) async {
    final cleanedMeterName = meterName.trim();
    String? username = await LocalStorage().getUserNameData();

    final url =
        Uri.parse('${Apivariables.add_water_meter_reading}/$cleanedMeterName');

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'readingValue': detectedValue, "username": username}),
      );

      final responseJson = json.decode(response.body);
      final message = responseJson['message'] ?? 'Unknown error';

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reading successfully submitted')),
        );
        showSuccessDialog(
            context, "Reading Extracted: $detectedValue", widget.metername);
        setState(() => _extractedDigits = detectedValue.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $message')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting reading: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitWaterReading() async {
    if (!widget.capturedImage.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image captured or file missing')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(Apivariables.extract_water_meter_reading);

      var request = http.MultipartRequest('POST', url)
        ..fields['meterName'] = widget.metername
        ..files.add(await http.MultipartFile.fromPath(
            'file', widget.capturedImage.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final responseJson = json.decode(responseData.body);

        if (responseJson['status'] == 'success') {
          final detectedValue = responseJson['detected_values'];
          setState(() => _extractedDigits = detectedValue.toString());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Detection failed: ${responseJson['detected_values'] ?? 'Unknown error'}',
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image')),
        );
      }
    } catch (e) {
      print("Error uploading reading: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during upload')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitPowerReading() async {
    if (!widget.capturedImage.existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image captured or file missing')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final url = Uri.parse(Apivariables.power_meter_image);

      final request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          widget.capturedImage.path,
          contentType: MediaType('image', 'jpeg'), // optional but recommended
        ));

      // Optional: Add extra fields if your API needs them
      // request.fields['meterName'] = widget.metername;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body);
        final detectedDigits = responseJson['digits'];

        print("detected value $detectedDigits");

        if (detectedDigits != null && detectedDigits.isNotEmpty) {
          setState(() => _extractedDigits = detectedDigits);
          await postReadingValue(widget.metername, detectedDigits);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No digits detected from image')),
          );
        }
      } else {
        print("Status: ${response.statusCode}, Body: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to extract reading from image')),
        );
      }
    } catch (e) {
      print("Error uploading power meter reading: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during upload')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void showSuccessDialog(
      BuildContext context, String message, String meterName) {
    showDialog(
      context: context,
      builder: (context) {
        return SuccessDialog(
          message: message,
          isButton: true,
        );
      },
    ).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scannerviewreport(
            meterName: meterName.trim(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const FlyoutBar(),
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
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
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.metername,
                      style: const TextStyle(
                          fontSize: 20, color: Color(0xFF00536E)),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _extractedDigits.isNotEmpty
                                ? _extractedDigits
                                : "No Data",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00536E),
                            ),
                          ),
                          Row(
                            children: [
                              if (widget.userType == "admin_users")
                                IconButton(
                                  icon: const Icon(Icons.edit_note,
                                      size: 32, color: Color(0xFF00536E)),
                                  onPressed: () {},
                                ),
                              IconButton(
                                icon: const Icon(Icons.camera_alt,
                                    size: 32, color: Color(0xFF00536E)),
                                onPressed: () {},
                              ),
                              if (widget.userType == "admin_users")
                                IconButton(
                                  icon: const Icon(Icons.cloud_upload_rounded,
                                      size: 32, color: Color(0xFF00536E)),
                                  onPressed: widget.meterType == "Water Meter"
                                      ? _submitWaterReading
                                      : _submitPowerReading,
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.capturedImage.existsSync())
                      Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF00536E)),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            widget.capturedImage,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      const Text(
                        "Image not found",
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(
                                    color: Color(0xFF00536E), width: 1),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00536E),
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
                            onPressed: () => postReadingValue(
                                widget.metername, _extractedDigits),
                            child: const Text(
                              'Submit',
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
    );
  }
}
