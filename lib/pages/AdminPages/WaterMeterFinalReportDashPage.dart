import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cd_automation/Apivariables.dart';
import 'package:cd_automation/pages/PopupComponents/FlyoutBar.dart';
import 'package:cd_automation/pages/components/CustomAppBar.dart';

class DayOption {
  final String label;
  final int days;
  final int startIndex;

  DayOption({
    required this.label,
    required this.days,
    required this.startIndex,
  });

  @override
  String toString() => label;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayOption &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          days == other.days &&
          startIndex == other.startIndex;

  @override
  int get hashCode => label.hashCode ^ days.hashCode ^ startIndex.hashCode;
}

class Watermeterfinalreportdashpage extends StatefulWidget {
  final String meterName;
  final DateTime fromDate;
  final DateTime toDate;

  const Watermeterfinalreportdashpage({
    super.key,
    required this.meterName,
    required this.fromDate,
    required this.toDate,
  });

  @override
  State<Watermeterfinalreportdashpage> createState() =>
      _WatermeterfinalreportdashpageState();
}

class _WatermeterfinalreportdashpageState
    extends State<Watermeterfinalreportdashpage> {
  List<FlSpot> allSpots = [];
  List<String> allDateLabels = [];

  List<FlSpot> displayedSpots = [];
  List<String> displayedDateLabels = [];

  bool isLoading = true;
  bool hasError = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<DayOption> dayOptions = [];
  DayOption? selectedOption;

  @override
  void initState() {
    super.initState();
    fetchReadingData();
  }

  Future<void> fetchReadingData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final uri = Uri.parse(
          "${Apivariables.view_dashboard_reports}/${widget.meterName}");

      final formattedFromDate =
          DateFormat('yyyy-MM-dd').format(widget.fromDate);
      final formattedToDate = DateFormat('yyyy-MM-dd').format(widget.toDate);

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "from_date": formattedFromDate,
          "to_date": formattedToDate,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List readings = data['readings'] ?? [];

        final Map<String, List<double>> grouped = {};

        for (var reading in readings) {
          final date = reading['reading_date'];
          final value = reading['reading_value'];
          if (date != null && value != null) {
            grouped.putIfAbsent(date, () => []);
            grouped[date]!.add((value as num).toDouble());
          }
        }

        final sortedKeys = grouped.keys.toList()..sort();
        List<FlSpot> tempSpots = [];
        List<String> tempLabels = [];

        for (int i = 0; i < sortedKeys.length; i++) {
          final date = sortedKeys[i];
          final avgValue =
              grouped[date]!.reduce((a, b) => a + b) / grouped[date]!.length;
          tempSpots.add(FlSpot(i.toDouble(), avgValue));

          // ✅ Fixed date parsing here
          tempLabels.add(
              DateFormat('MM-dd').format(DateFormat('MM/dd/yyyy').parse(date)));
        }

        // Generate dropdown options
        List<DayOption> options = [];
        int step = 10;
        for (int i = 0; i < tempSpots.length; i += step) {
          int end = (i + step > tempSpots.length) ? tempSpots.length : i + step;
          options.add(
              DayOption(label: "$i - $end Days", days: end - i, startIndex: i));
        }

        setState(() {
          allSpots = tempSpots;
          allDateLabels = tempLabels;
          dayOptions = options;
          selectedOption = options.isNotEmpty ? options.last : null;
          if (selectedOption != null) {
            filterDisplayedData(
                selectedOption!.days, selectedOption!.startIndex);
          }
          isLoading = false;
        });
      } else {
        throw Exception("Status code ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching readings: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  void filterDisplayedData(int days, int startIndex) {
    final total = allSpots.length;
    final start = startIndex.clamp(0, total);
    final end = (start + days).clamp(0, total);

    displayedSpots = [];
    displayedDateLabels = [];

    for (int i = start; i < end; i++) {
      displayedSpots.add(FlSpot((i - start).toDouble(), allSpots[i].y));
      displayedDateLabels.add(allDateLabels[i]);
    }

    setState(() {});
  }

  Widget buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 50),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= displayedDateLabels.length) {
                  return const SizedBox();
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(displayedDateLabels[index],
                      style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: displayedSpots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: const FlyoutBar(),
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasError
                ? const Center(
                    child: Text("Failed to load data. Please try again later."))
                : displayedSpots.isEmpty
                    ? const Center(child: Text("No readings available."))
                    : Column(
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
                                'Reports',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              DropdownButton<DayOption>(
                                value: selectedOption,
                                items: dayOptions.map((option) {
                                  return DropdownMenuItem<DayOption>(
                                    value: option,
                                    child: Text(option.label),
                                  );
                                }).toList(),
                                onChanged: (DayOption? newValue) {
                                  if (newValue != null) {
                                    setState(() => selectedOption = newValue);
                                    filterDisplayedData(
                                        newValue.days, newValue.startIndex);
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Meter ID: ${widget.meterName}",
                            style: const TextStyle(
                                fontSize: 20, color: Color(0xFF00536E)),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(height: 300, child: buildChart()),
                        ],
                      ),
      ),
    );
  }
}
