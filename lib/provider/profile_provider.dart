import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/user_profile_model.dart';
import 'api.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class Questionnaire extends _$Questionnaire {
  @override
  UserProfile build() {
    return UserProfile();
  }
  /// Converte qualquer String ou lista de Strings para minúsculas
  dynamic _clean(dynamic value) {
    if (value is String) return value.toLowerCase();
    if (value is List<String>) return value.map((e) => e.toLowerCase()).toList();
    if (value is Map<String, bool>) {
      return value.entries
          .where((e) => e.value == true)
          .map((e) => e.key.toLowerCase())
          .toList();
    }
    return value;
  }
  void updateData(UserProfile newData) {
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
    );}

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
    final dio = ref.read(dioProvider);

    // Montamos o payload exatamente como no teu exemplo de curl
    final payload = {
      "gender": _clean(state.gender),
      "age": state.age ?? 0,
      "weight": state.weight ?? 0,
      "height": state.height ?? 0,
      "activityLevel": _clean(state.activityLevel),
      "healthGoal": _clean(state.healthGoal),
      "meals": _clean(state.meals),
      "dietaryRestrictions": _clean(state.restrictions), // Se usares restrições
    };

    try {
      print('📤 Enviando PATCH para /user/profile: $payload');

      final response = await dio.patch(
        '/user/profile',
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Perfil atualizado com sucesso!');
      }
    } catch (e) {
      print('❌ Erro ao guardar perfil: $e');
      // Se der 401 aqui, lembra-te de fazer Sign Out e Sign In novamente
      // para o CookieManager capturar a sessão.
      throw Exception('Falha na comunicação com o servidor.');
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