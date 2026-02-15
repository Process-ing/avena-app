import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

enum Gender {
  male("Male", 5),
  female("Female", -161),
  other("Other", -78);

  const Gender(this.name, this.offset);
  final String name;
  final double offset;
}

enum HealthGoal {
  @JsonValue('lose weight')
  loseWeight("Lose Weight", -500),
  @JsonValue('build muscle')
  buildMuscle("Build Muscle", 300),
  @JsonValue('stay fit')
  stayFit("Stay Fit", 0),
  @JsonValue('eat healthier')
  eatHealthier("Eat Healthier", 0);

  const HealthGoal(this.name, this.offset);
  final String name;
  final double offset;
}

enum Pace {
  intensive("Intensive", "Fast results, strict plan", 0.7),
  balanced("Balanced", "Moderate pace with flexibility", 1),
  steady("Steady & Sustainable", "Gradual progress, long-term habits", 1.3);

  const Pace(this.name, this.description, this.factor);
  final String name;
  final String description;
  final double factor;
}

enum ActivityLevel {
  sedentary("Sedentary", 'Little or no exercise', 1.2),
  @JsonValue('lightly active')
  lightlyActive("Lightly Active", 'Light exercise, 1-3 days/week', 1.375),
  @JsonValue('moderately active')
  moderatelyActive(
    "Moderately Active",
    'Moderate exercise, 3-5 days/week',
    1.55,
  ),
  @JsonValue('very active')
  veryActive("Very Active", 'Hard exercise, 6-7 days/week', 1.725),
  @JsonValue('extra active')
  extraActive("Extra Active", 'Very hard exercise & physical job', 1.9);

  const ActivityLevel(this.name, this.description, this.factor);
  final String name;
  final String description;
  final double factor;
}

enum Meal {
  breakfast("Breakfast"),
  @JsonValue('morning snack')
  morningSnack("Morning snack"),
  brunch("Brunch"),
  lunch("Lunch"),
  @JsonValue('afternoon snack')
  afternoonSnack("Afternoon Snack"),
  dinner("Dinner"),
  @JsonValue('midnight snack')
  midnightSnack("Midnight Snack");

  const Meal(this.name);
  final String name;
}

enum Restriction {
  @JsonValue('gluten-free')
  gluten('Gluten-free'),
  // dairy('Dairy-free'),
  // nut('Nut-free'),
  // shellfish('Shellfish-free'),
  vegetarian('Vegetarian'),
  vegan('Vegan'),
  pescatarian('Pescatarian'),
  @JsonValue('no-pork')
  pork('No Pork'),
  @JsonValue('no-alcohol')
  alcohol('No Alcohol');

  const Restriction(this.name);
  final String name;
}

enum QAStep {
  aboutYou,
  healthGoal,
  pace,
  activityLevel,
  meals,
  restrictions,
  summary,
}

@freezed
abstract class UserProfile with _$UserProfile {
  const UserProfile._();

  const factory UserProfile({
    Gender? gender,
    int? age,
    double? weight,
    double? height,
    HealthGoal? healthGoal,
    double? goalWeight,
    Pace? pace,
    ActivityLevel? activityLevel,
    @Default([Meal.breakfast, Meal.lunch, Meal.dinner]) List<Meal> meals,
    @Default([]) List<Restriction> restrictions,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  bool get finished =>
      gender != null &&
      age != null &&
      weight != null &&
      height != null &&
      healthGoal != null &&
      (healthGoal != HealthGoal.loseWeight || goalWeight != null) &&
      activityLevel != null &&
      meals.isNotEmpty;

  double? get bmr {
    if (weight == null || height == null || age == null || gender == null) {
      return null;
    }

    return (10 * weight!) + (6.25 * height!) - (5 * age!) + gender!.offset;
  }

  double? get tdee {
    if (activityLevel == null || bmr == null) return null;

    return bmr! * activityLevel!.factor;
  }

  double? get recommendedCalories {
    if (healthGoal == null || tdee == null) return null;

    return tdee! + healthGoal!.offset;
  }

  double? get weeksToGoal {
    if (healthGoal != HealthGoal.loseWeight ||
        weight == null ||
        goalWeight == null ||
        pace == null) {
      return null;
    }

    final weightDifference = (weight! - goalWeight!).abs();
    final weeksNeeded = weightDifference / 0.5;

    return weeksNeeded * pace!.factor;
  }

  bool finishedStep(QAStep step) => switch (step) {
    QAStep.aboutYou =>
      gender != null && age != null && weight != null && height != null,
    QAStep.healthGoal =>
      healthGoal != null &&
          (healthGoal != HealthGoal.loseWeight || goalWeight != null),
    QAStep.pace => pace != null,
    QAStep.activityLevel => activityLevel != null,
    QAStep.meals => meals.isNotEmpty,
    QAStep.restrictions => true,
    QAStep.summary => finished,
  };
}
