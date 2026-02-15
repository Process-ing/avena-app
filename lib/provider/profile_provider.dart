import 'dart:async';

import 'package:avena/provider/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/user_profile_model.dart';
import 'api.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile> build() async {
    final api = ref.watch(backendApiProvider);

    final authenticatedUser = await ref.watch(authenticatedUserProvider.future);
    if (authenticatedUser == null) throw Exception();

    return await api.getUserProfile();
  }

  void updateData({
    Gender? gender,
    int? age,
    double? weight,
    double? height,
    HealthGoal? healthGoal,
    double? goalWeight,
    Pace? pace,
    ActivityLevel? activityLevel,
    List<Meal>? meals,
    List<Restriction>? restrictions,
  }) {
    final api = ref.watch(backendApiProvider);
    final old = state.value ?? UserProfile();

    state = AsyncValue.data(
      UserProfile(
        gender: gender ?? old.gender,
        age: age ?? old.age,
        weight: weight ?? old.weight,
        height: height ?? old.height,
        healthGoal: healthGoal ?? old.healthGoal,
        goalWeight: goalWeight ?? old.goalWeight,
        pace: pace ?? old.pace,
        activityLevel: activityLevel ?? old.activityLevel,
        meals: meals ?? old.meals,
        restrictions: restrictions ?? old.restrictions,
      ),
    );

    unawaited(api.updateUserProfile(state.value!));
  }

  /// Reset the profile to initial state
  void reset() {
    state = AsyncValue.data(UserProfile());
  }
}
