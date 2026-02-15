import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightEntry {
  final DateTime date;
  final double weight;

  WeightEntry({required this.date, required this.weight});

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'weight': weight,
      };

  factory WeightEntry.fromJson(Map<String, dynamic> json) => WeightEntry(
        date: DateTime.parse(json['date'] as String),
        weight: (json['weight'] as num).toDouble(),
      );
}

class WeightDiaryNotifier extends ChangeNotifier {
  static const String _storageKey = 'weight_diary';
  List<WeightEntry> _entries = [];
  bool _isLoading = true;
  String? _error;

  List<WeightEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  WeightDiaryNotifier() {
    _init();
  }

  Future<void> _init() async {
    try {
      _entries = await _loadEntries();
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<WeightEntry>> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => WeightEntry.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_entries.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  Future<void> addEntry(double weight, {DateTime? date}) async {
    _entries.add(WeightEntry(date: date ?? DateTime.now(), weight: weight));
    _entries.sort((a, b) => a.date.compareTo(b.date));
    await _saveEntries();
    notifyListeners();
  }

  Future<void> updateEntry(int index, double weight, {DateTime? date}) async {
    if (index < 0 || index >= _entries.length) return;

    final oldEntry = _entries[index];
    _entries[index] = WeightEntry(
      date: date ?? oldEntry.date,
      weight: weight,
    );
    _entries.sort((a, b) => a.date.compareTo(b.date));
    await _saveEntries();
    notifyListeners();
  }

  Future<void> deleteEntry(int index) async {
    if (index < 0 || index >= _entries.length) return;
    _entries.removeAt(index);
    await _saveEntries();
    notifyListeners();
  }

  Future<void> initializeWithProfileWeight(double weight) async {
    if (_entries.isEmpty) {
      await addEntry(weight);
    }
  }
}

final weightDiaryProvider = Provider<WeightDiaryNotifier>((ref) {
  final notifier = WeightDiaryNotifier();
  ref.onDispose(notifier.dispose);
  return notifier;
});
