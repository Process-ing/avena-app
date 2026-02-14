class UserProfile {
  final String? gender;
  final double? age;
  final double? weight;
  final double? height;
  final String? healthGoal;
  final double? goalWeight;
  final String? pace;
  final String? activityLevel;
  final Map<String, bool> meals;
  final Map<String, bool> restrictions;

  UserProfile({
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.healthGoal,
    this.goalWeight,
    this.pace,
    this.activityLevel,
    this.meals = const {},
    this.restrictions = const {},
  });

  /// Converts the object to JSON for your API call
  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
      'healthGoal': healthGoal,
      'goalWeight': goalWeight,
      'pace': pace,
      'activityLevel': activityLevel,
      'meals': meals.entries.where((e) => e.value).map((e) => e.key).toList(),
      'restrictions':
      restrictions.entries.where((e) => e.value).map((e) => e.key).toList(),
    };
  }

  /// Helper to update state in Riverpod
  UserProfile copyWith({
    String? gender,
    double? age,
    double? weight,
    double? height,
    String? healthGoal,
    double? goalWeight,
    String? pace,
    String? activityLevel,
    Map<String, bool>? meals,
    Map<String, bool>? restrictions,
  }) {
    return UserProfile(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      healthGoal: healthGoal ?? this.healthGoal,
      goalWeight: goalWeight ?? this.goalWeight,
      pace: pace ?? this.pace,
      activityLevel: activityLevel ?? this.activityLevel,
      meals: meals ?? this.meals,
      restrictions: restrictions ?? this.restrictions,
    );
  }

  /// Validate if basic info is complete
  bool get hasBasicInfo =>
      gender != null && age != null && weight != null && height != null;

  /// Validate if health goal is complete
  bool get hasHealthGoal => healthGoal != null;

  /// Validate if activity level is set
  bool get hasActivityLevel => activityLevel != null;

  /// Check if profile is complete enough to calculate metrics
  bool get canCalculateMetrics =>
      hasBasicInfo && hasActivityLevel;
}