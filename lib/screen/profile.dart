import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Colors for consistency (adjust as needed for your theme)
const Color kPrimary = Colors.black;
const Color kGold = Color(0xFFB98B47);
const Color kGray = Color(0xFFF3F3F3);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> weightDiary = [
    {'date': DateTime.now().subtract(const Duration(days: 5)), 'weight': 74.5},
    {'date': DateTime.now().subtract(const Duration(days: 3)), 'weight': 74.0},
    {'date': DateTime.now().subtract(const Duration(days: 1)), 'weight': 73.8},
  ];

  final _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _addWeightEntry() {
    final double? weight = double.tryParse(_weightController.text);
    if (weight != null) {
      setState(() {
        weightDiary.add({'date': DateTime.now(), 'weight': weight});
      });
      _weightController.clear();
    }
  }

  void _signOut() {
    // TODO: Replace with your sign-out logic
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void _recalculateCalories() {
    // TODO: Replace with your recalc logic/navigation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Start recalculation questionnaire')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = "Alice"; // TODO: Use real username

    // Prepare chart data
    final List<FlSpot> spots = weightDiary.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        (entry.value['weight'] as double),
      );
    }).toList();

    final minWeight = (weightDiary.map((e) => e['weight'] as double).reduce((a, b) => a < b ? a : b) - 0.5).clamp(0.0, double.infinity);
    final maxWeight = (weightDiary.map((e) => e['weight'] as double).reduce((a, b) => a > b ? a : b) + 0.5).clamp(0.0, double.infinity);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          userName,
          style: const TextStyle(
            color: kPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        children: [
          // --- Weight Diary Section ---
          const Text(
            "Weight Diary",
            style: TextStyle(
              color: kPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // fl_chart LineChart
                SizedBox(
                  height: 120,
                  child: LineChart(
                    LineChartData(
                      minY: minWeight,
                      maxY: maxWeight,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: kPrimary,
                          barWidth: 4,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final idx = value.round();
                              if (idx < 0 || idx >= weightDiary.length) return const SizedBox.shrink();
                              final date = weightDiary[idx]['date'] as DateTime;
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  "${date.day}/${date.month}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                            interval: 1,
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Clean weight list
                ...weightDiary.reversed.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text(
                        "${e['weight']} kg",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kPrimary,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Text(
                        "${e['date'].day}/${e['date'].month}/${e['date'].year}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // --- Upload Weight Section ---
          const Text(
            "Upload Current Weight",
            style: TextStyle(
              color: kPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter weight (kg)",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _addWeightEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(60, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  elevation: 0,
                ),
                child: const Text("Upload", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 34),
          // --- Recalculate Calories ---
          ElevatedButton.icon(
            onPressed: _recalculateCalories,
            icon: const Icon(Icons.calculate, color: kGold),
            label: const Text(
              "Recalculate Calories",
              style: TextStyle(color: kGold, fontWeight: FontWeight.w600, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
              minimumSize: const Size(double.infinity, 54),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 17),
          // --- Sign Out ---
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout, color: kPrimary),
              label: const Text(
                "Sign Out",
                style: TextStyle(color: kPrimary, fontWeight: FontWeight.w600, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGray,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17),
                ),
                minimumSize: const Size(double.infinity, 54),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}