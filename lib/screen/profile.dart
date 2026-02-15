import 'package:avena/mutation/auth.dart';
import 'package:avena/provider/auth.dart';
import 'package:avena/provider/profile.dart';
import 'package:avena/provider/weight_diary.dart';
import 'package:avena/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _weightController = TextEditingController();
  final _editWeightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _editWeightController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Add listener to rebuild when weight diary changes
    ref.read(weightDiaryProvider).addListener(() {
      if (mounted) setState(() {});
    });
    
    // Initialize weight diary with profile weight
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profile = await ref.read(userProfileProvider.future);
      final weightDiary = ref.read(weightDiaryProvider);
      if (profile.weight != null) {
        await weightDiary.initializeWithProfileWeight(profile.weight!);
      }
    });
  }

  void _addWeightEntry() {
    final double? weight = double.tryParse(_weightController.text);
    if (weight != null) {
      ref.read(weightDiaryProvider).addEntry(weight);
      _weightController.clear();
      Navigator.of(context).pop();
    }
  }

  void _showAddWeightDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Weight Entry'),
        content: TextField(
          controller: _weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: "Enter weight (kg)",
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber[700]!, width: 2),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: _addWeightEntry,
            style: TextButton.styleFrom(foregroundColor: Colors.amber[700]),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditWeightDialog(int index, WeightEntry entry) {
    _editWeightController.text = entry.weight.toString();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Weight Entry'),
        content: TextField(
          controller: _editWeightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: "Enter weight (kg)",
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber[700]!, width: 2),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(weightDiaryProvider).deleteEntry(index);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final double? weight = double.tryParse(_editWeightController.text);
              if (weight != null) {
                ref.read(weightDiaryProvider).updateEntry(index, weight);
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.amber[700]),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await signOut(ref);
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign out failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authUser = ref.watch(authenticatedUserProvider);
    final profile = ref.watch(userProfileProvider);
    final weightDiary = ref.watch(weightDiaryProvider);

    if (weightDiary.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (weightDiary.error != null) {
      return Scaffold(
        body: Center(child: Text('Error: ${weightDiary.error}')),
      );
    }

    final entries = weightDiary.entries;

    // Calculate weight stats
    final currentWeight = entries.isNotEmpty
        ? entries.last.weight
        : profile.value?.weight ?? 0.0;
    final startWeight = entries.isNotEmpty
        ? entries.first.weight
        : profile.value?.weight ?? 0.0;
    final weightChange = currentWeight - startWeight;

    // Prepare chart data
    final List<FlSpot> spots = entries.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weight);
    }).toList();

    final minWeight = entries.isNotEmpty
        ? (entries.map((e) => e.weight).reduce((a, b) => a < b ? a : b) - 1.0)
            .clamp(0.0, double.infinity)
        : 0.0;
    final maxWeight = entries.isNotEmpty
        ? (entries.map((e) => e.weight).reduce((a, b) => a > b ? a : b) + 1.0)
            .clamp(0.0, double.infinity)
        : 100.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          authUser.value?.name ?? 'Profile',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
              // Stats Row
              Row(
                children: [
                  // Current Weight
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${currentWeight.toStringAsFixed(1)} kg',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Weight Change
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Progress',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                weightChange < 0
                                    ? Icons.trending_down
                                    : Icons.trending_up,
                                color: weightChange < 0 ? Colors.green : Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${weightChange < 0 ? '' : '+'}${weightChange.toStringAsFixed(1)} kg',
                                style: TextStyle(
                                  color: weightChange < 0 ? Colors.green : Colors.orange,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Weight Progress Section
              const Text(
                'Weight Progress',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Chart Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: entries.isEmpty
                          ? const Center(
                              child: Text(
                                'No weight entries yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : LineChart(
                              LineChartData(
                                minY: minWeight,
                                maxY: maxWeight,
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: spots,
                                    isCurved: true,
                                    color: Colors.amber[700],
                                    barWidth: 3,
                                    dotData: FlDotData(
                                      show: true,
                                      getDotPainter: (spot, percent, barData, index) {
                                        return FlDotCirclePainter(
                                          radius: 4,
                                          color: Colors.amber[700]!,
                                          strokeWidth: 2,
                                          strokeColor: Colors.white,
                                        );
                                      },
                                    ),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: Colors.amber.withValues(alpha: 0.1),
                                    ),
                                  ),
                                ],
                                titlesData: FlTitlesData(
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: entries.length > 5 ? 2 : 1,
                                      getTitlesWidget: (value, meta) {
                                        final idx = value.round();
                                        if (idx < 0 || idx >= entries.length) {
                                          return const SizedBox.shrink();
                                        }
                                        final date = entries[idx].date;
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            "${date.day}/${date.month}",
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: (maxWeight - minWeight) / 4,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.amber[50]!,
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recent Entries
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Entries',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _showAddWeightDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: TextButton.styleFrom(foregroundColor: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Weight entries list - limited to 3
              ...entries.reversed.take(3).toList().asMap().entries.map((mapEntry) {
                final displayIndex = mapEntry.key;
                final actualIndex = entries.length - 1 - displayIndex;
                final entry = mapEntry.value;
                
                return GestureDetector(
                  onTap: () => _showEditWeightDialog(actualIndex, entry),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.weight.toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${entry.date.day}/${entry.date.month}/${entry.date.year}',
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        Icon(Icons.fitness_center, color: Colors.grey[400], size: 20),
                      ],
                    ),
                  ),
                );
              }),

              const SizedBox(height: 32),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _signOut,
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
      ),
    );
  }
}
