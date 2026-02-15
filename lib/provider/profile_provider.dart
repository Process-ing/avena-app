import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/user_profile_model.dart';
import 'api.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class UserProfileNotifier extends _$UserProfileNotifier {
  @override
  Future<UserProfile> build() async {
    final api = ref.watch(backendApiProvider);

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
    Set<Meal>? meals,
    Set<Restriction>? restrictions,
  }) {
    final api = ref.watch(backendApiProvider);
    final old = state.value ?? UserProfile();

    state = AsyncValue.data(
      old.copyWith(
        gender: gender,
        age: age,
        weight: weight,
        height: height,
        healthGoal: healthGoal,
        goalWeight: goalWeight,
        pace: pace,
        activityLevel: activityLevel,
        meals: meals ?? old.meals,
        restrictions: restrictions ?? old.restrictions,
      ),
    );

    api.updateUserProfile(state.value!);
  }

  /// Reset the profile to initial state
  void reset() {
    state = AsyncValue.data(UserProfile());
  }
}
