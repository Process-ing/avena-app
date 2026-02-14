import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/user_profile_model.dart';
import 'api.dart';
import 'auth.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class Questionnaire extends _$Questionnaire {
  @override
  UserProfile build() {
    print('🔄 QUESTIONNAIRE PROVIDER BUILD CALLED');
    return UserProfile();
  }

  /// Updates the current state using the copyWith pattern
  void updateData(UserProfile newData) {
    print('📝 UPDATE DATA CALLED');
    print('   Previous state: Gender=${state.gender}, Age=${state.age}, Weight=${state.weight}');
    print('   New data: Gender=${newData.gender}, Age=${newData.age}, Weight=${newData.weight}');

    // Merge new data with existing state, preserving non-null values
    state = UserProfile(
      gender: newData.gender ?? state.gender,
      age: newData.age ?? state.age,
      weight: newData.weight ?? state.weight,
      height: newData.height ?? state.height,
      healthGoal: newData.healthGoal ?? state.healthGoal,
      goalWeight: newData.goalWeight ?? state.goalWeight,
      pace: newData.pace ?? state.pace,
      activityLevel: newData.activityLevel ?? state.activityLevel,
      meals: newData.meals.isNotEmpty ? newData.meals : state.meals,
      restrictions: newData.restrictions.isNotEmpty ? newData.restrictions : state.restrictions,
    );

    print('   Current state after update: Gender=${state.gender}, Age=${state.age}, Weight=${state.weight}');
  }

  /// Calculate Basal Metabolic Rate (BMR/TMB) using Mifflin-St Jeor Equation
  double? calculateTMB() {
    final weight = state.weight;
    final height = state.height;
    final age = state.age;
    final gender = state.gender;

    if (weight == null || height == null || age == null || gender == null) {
      return null;
    }

    if (gender == 'Male') {
      return (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else if (gender == 'Female') {
      return (10 * weight) + (6.25 * height) - (5 * age) - 161;
    } else {
      // Average for 'Other'
      return ((10 * weight) + (6.25 * height) - (5 * age) - 78);
    }
  }

  /// Calculate Total Daily Energy Expenditure based on activity level
  double? calculateTDEE() {
    final tmb = calculateTMB();
    if (tmb == null) return null;

    double factor = 1.2; // Default Sedentary
    switch (state.activityLevel) {
      case 'Lightly Active':
        factor = 1.375;
        break;
      case 'Moderately Active':
        factor = 1.55;
        break;
      case 'Very Active':
        factor = 1.725;
        break;
      case 'Extra Active':
        factor = 1.9;
        break;
      default:
        factor = 1.2; // Sedentary
    }
    return tmb * factor;
  }

  /// Calculate recommended daily calorie intake based on health goal
  double? calculateRecommendedCalories() {
    final tdee = calculateTDEE();
    if (tdee == null) return null;

    switch (state.healthGoal) {
      case 'Lose Weight':
        return tdee - 500; // 500 calorie deficit for ~0.5kg/week loss
      case 'Build Muscle':
        return tdee + 300; // 300 calorie surplus
      case 'Stay Fit':
      case 'Eat Healthier':
      default:
        return tdee; // Maintenance
    }
  }

  /// Calculate estimated time to reach goal weight (in weeks)
  double? calculateWeeksToGoal() {
    if (state.healthGoal != 'Lose Weight' ||
        state.weight == null ||
        state.goalWeight == null) {
      return null;
    }

    final weightDifference = (state.weight! - state.goalWeight!).abs();

    // Assuming 0.5kg per week loss (safe rate)
    double weeksNeeded = weightDifference / 0.5;

    // Adjust based on pace
    switch (state.pace) {
      case 'Intensive':
        weeksNeeded *= 0.7; // Faster
        break;
      case 'Steady & Sustainable':
        weeksNeeded *= 1.3; // Slower, more sustainable
        break;
      default: // Balanced
        break;
    }

    return weeksNeeded;
  }

  /// Final API call to save the questionnaire results
  Future<void> saveProfile() async {
    // Validate that we have enough data
    if (!state.canCalculateMetrics) {
      throw Exception('Incomplete profile data. Please fill all required fields.');
    }

    final dio = ref.read(dioProvider);

    // Build payload with calculated values
    final payload = state.toJson();
    payload['tmb'] = calculateTMB();
    payload['tdee'] = calculateTDEE();
    payload['recommendedCalories'] = calculateRecommendedCalories();
    payload['weeksToGoal'] = calculateWeeksToGoal();

    try {
      final response = await dio.post(
        '/user/setup-profile',
        data: payload,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to save profile: ${response.statusMessage}');
      }

      // Safety check before continuing after async gap
      if (!ref.mounted) return;
    } catch (e) {
      // Re-throw with more context
      throw Exception('Error saving profile: $e');
    }
  }

  /// Reset the profile to initial state
  void reset() {
    state = UserProfile();
  }

  /// Validate current step data before proceeding
  bool validateStep(int step) {
    switch (step) {
      case 0: // About You
        return state.gender != null &&
            state.age != null &&
            state.weight != null &&
            state.height != null;
      case 1: // Health Goal
        return state.healthGoal != null;
      case 2: // Pace
        return state.pace != null;
      case 3: // Activity Level
        return state.activityLevel != null;
      case 4: // Meals
        return state.meals.values.any((selected) => selected);
      case 5: // Restrictions
        return true; // Optional step
      case 6: // Summary
        return state.canCalculateMetrics;
      default:
        return false;
    }
  }
}