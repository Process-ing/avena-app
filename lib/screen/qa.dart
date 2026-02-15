import 'package:avena/model/user_profile_model.dart';
import 'package:avena/provider/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:avena/screen/main_shell.dart';

class QAScreen extends ConsumerStatefulWidget {
  const QAScreen({super.key});

  @override
  ConsumerState<QAScreen> createState() => _QAScreenState();
}

class _QAScreenState extends ConsumerState<QAScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const _pageCount = 7;

  void _nextPage() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final profileNotifier = ref.watch(userProfileProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousPage,
        ),
        title: Row(
          children: List.generate(_pageCount, (index) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 4,
                decoration: BoxDecoration(
                  color: index <= _currentPage
                      ? Colors.amber[700]
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ),
      body: profile.map(
        data: (profile) => PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            _AboutYouStep(profile.value, profileNotifier, _nextPage),
            _HealthGoalStep(profile.value, profileNotifier, _nextPage),
            _ActivityLevelStep(profile.value, profileNotifier, _nextPage),
            _MealsStep(profile.value, profileNotifier, _nextPage),
            _RestrictionsStep(profile.value, profileNotifier, _nextPage),
            _SummaryStep(profile.value, profileNotifier, _nextPage),
          ],
        ),
        error: (error) => Text(error.error.toString()),
        loading: (_) => CircularProgressIndicator(),
      ),
    );
  }
}

class _StepContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback onNext;
  final String buttonText;
  final bool finished;

  const _StepContainer({
    required this.title,
    this.subtitle,
    required this.child,
    required this.onNext,
    this.buttonText = 'Continue',
    required this.finished,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      subtitle!,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                  const SizedBox(height: 32),
                  child,
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: finished ? onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Step 1: About You
class _AboutYouStep extends StatefulWidget {
  final UserProfile profile;
  final UserProfileNotifier profileNotifier;
  final VoidCallback onNext;

  const _AboutYouStep(this.profile, this.profileNotifier, this.onNext);

  @override
  State<_AboutYouStep> createState() => _AboutYouStepState();
}

class _AboutYouStepState extends State<_AboutYouStep> {
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(
      text: widget.profile.age?.toString(),
    );
    _ageController.addListener(() {
      widget.profileNotifier.updateData(age: int.tryParse(_ageController.text));
    });
    _weightController = TextEditingController(
      text: widget.profile.weight?.toString(),
    );
    _weightController.addListener(() {
      widget.profileNotifier.updateData(
        weight: double.tryParse(_weightController.text),
      );
    });
    _heightController = TextEditingController(
      text: widget.profile.height?.toString(),
    );
    _heightController.addListener(() {
      widget.profileNotifier.updateData(
        height: double.tryParse(_heightController.text),
      );
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'Tell us about yourself',
      subtitle: 'This helps us personalize your experience',
      onNext: widget.onNext,
      finished: widget.profile.finishedStep(QAStep.aboutYou),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gender',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            spacing: 8,
            children: Gender.values
                .map(
                  (gender) => Expanded(
                    child: _OptionButton(
                      label: gender.name,
                      isSelected: widget.profile.gender == gender,
                      onTap: () =>
                          widget.profileNotifier.updateData(gender: gender),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Age',
              hintText: 'Enter your age',
              prefixIcon: Icon(Icons.cake_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              hintText: 'Enter your weight',
              prefixIcon: Icon(Icons.monitor_weight_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              hintText: 'Enter your height',
              prefixIcon: Icon(Icons.height),
            ),
          ),
        ],
      ),
    );
  }
}

// Step 2: Health Goal
class _HealthGoalStep extends StatefulWidget {
  final UserProfile profile;
  final UserProfileNotifier profileNotifier;
  final VoidCallback onNext;

  const _HealthGoalStep(this.profile, this.profileNotifier, this.onNext);

  @override
  State<_HealthGoalStep> createState() => _HealthGoalStepState();
}

class _HealthGoalStepState extends State<_HealthGoalStep> {
  late TextEditingController _goalWeightController;

  @override
  void initState() {
    super.initState();
    _goalWeightController = TextEditingController(
      text: widget.profile.goalWeight?.toString(),
    );
    _goalWeightController.addListener(() {
      widget.profileNotifier.updateData(
        goalWeight: double.tryParse(_goalWeightController.text),
      );
    });
  }

  @override
  void dispose() {
    _goalWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'What is your health goal?',
      subtitle: 'Choose your primary objective',
      onNext: widget.onNext,
      finished: widget.profile.finishedStep(QAStep.healthGoal),
      child: Column(
        spacing: 12,
        children: [
          ...HealthGoal.values.map(
            (goal) => _OptionButton(
              label: goal.name,
              isSelected: widget.profile.healthGoal == goal,
              onTap: () => widget.profileNotifier.updateData(healthGoal: goal),
            ),
          ),
          if (widget.profile.healthGoal == HealthGoal.loseWeight) ...[
            const SizedBox(height: 24),
            TextField(
              controller: _goalWeightController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Goal Weight (kg)',
                hintText: 'What weight do you want to reach?',
                prefixIcon: Icon(Icons.flag_outlined),
                helperText: 'Your target weight',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Step 3: Activity Level
class _ActivityLevelStep extends StatelessWidget {
  final UserProfile profile;
  final UserProfileNotifier profileNotifier;
  final VoidCallback onNext;

  const _ActivityLevelStep(this.profile, this.profileNotifier, this.onNext);

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'What is your activity level?',
      subtitle: 'Pick your usual activity',
      onNext: onNext,
      finished: profile.finishedStep(QAStep.activityLevel),
      child: Column(
        spacing: 12,
        children: ActivityLevel.values
            .map(
              (level) => _OptionButtonWithSubtitle(
                label: level.name,
                subtitle: level.description,
                isSelected: profile.activityLevel == level,
                onTap: () => profileNotifier.updateData(activityLevel: level),
              ),
            )
            .toList(),
      ),
    );
  }
}

// Step 4: Meals
class _MealsStep extends StatelessWidget {
  final UserProfile profile;
  final UserProfileNotifier profileNotifier;
  final VoidCallback onNext;

  const _MealsStep(this.profile, this.profileNotifier, this.onNext);

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'Which meals do you include?',
      subtitle: 'Select all that apply',
      onNext: onNext,
      finished: profile.finishedStep(QAStep.meals),
      child: Column(
        spacing: 8,
        children: Meal.values.map((meal) {
          final selected = profile.meals.contains(meal);

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
                width: selected ? 2 : 1,
              ),
            ),
            child: CheckboxListTile(
              title: Text(
                meal.name,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              value: selected,
              onChanged: (value) {
                if (value == true) {
                  profile.meals.add(meal);
                } else {
                  profile.meals.remove(meal);
                }
                profileNotifier.updateData(meals: profile.meals);
              },
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: Colors.amber[700],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Step 5: Restrictions
class _RestrictionsStep extends StatelessWidget {
  final UserProfile profile;
  final UserProfileNotifier profileNotifier;
  final VoidCallback onNext;

  const _RestrictionsStep(this.profile, this.profileNotifier, this.onNext);

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'Any dietary restrictions?',
      subtitle: 'Select all that apply',
      onNext: onNext,
      finished: profile.finishedStep(QAStep.restrictions),
      child: Column(
        spacing: 8,
        children: Restriction.values.map((restriction) {
          final selected = profile.restrictions.contains(restriction);

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
                width: selected ? 2 : 1,
              ),
            ),
            child: CheckboxListTile(
              title: Text(
                restriction.name,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              value: selected,
              onChanged: (value) {
                final updatedRestrictions = [...profile.restrictions];
                if (value == true) {
                  updatedRestrictions.add(restriction);
                } else {
                  updatedRestrictions.remove(restriction);
                }
                profileNotifier.updateData(restrictions: updatedRestrictions);
              },
              controlAffinity: ListTileControlAffinity.trailing,
              activeColor: Colors.amber[700],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Step 6: Summary with TMB/TDEE
class _SummaryStep extends StatelessWidget {
  final UserProfile profile;
  final UserProfileNotifier profileNotifier;
  final VoidCallback onNext;

  const _SummaryStep(this.profile, this.profileNotifier, this.onNext);

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'Your Personalized Plan',
      subtitle: 'Based on your information',
      onNext: onNext,
      buttonText: 'Get Started',
      finished: profile.finishedStep(QAStep.summary),
      child: Column(
        children: [
          // TMB/TDEE Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber[700]!, width: 2),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 48,
                  color: Colors.amber[700],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Daily Calorie Needs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                // TMB
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Basal Metabolic Rate',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.bmr != null
                                ? '${profile.bmr!.round()} kcal'
                                : '-- kcal',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 16),
                // TDEE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Daily Energy',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.tdee != null
                                ? '${profile.tdee!.round()} kcal'
                                : '-- kcal',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 16),
                // Recommended Calories
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recommended Intake',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile.recommendedCalories != null
                                ? '${profile.recommendedCalories!.round()} kcal'
                                : '-- kcal',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Goal summary
          if (profile.healthGoal == HealthGoal.loseWeight &&
              profile.goalWeight != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.flag, color: Colors.amber[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Weight Goal',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${profile.goalWeight} kg',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        if (profile.weeksToGoal != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Est. ${profile.weeksToGoal!.round()} weeks',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (profile.weight != null && profile.goalWeight != null)
                    Text(
                      '${(profile.weight! - profile.goalWeight!).abs().toStringAsFixed(1)} kg to go',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.amber[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Info text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[700]!.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 20, color: Colors.amber[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Your BMR is the calories you burn at rest. TDEE includes your activity level. We'll use this to create your personalized meal plan.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _OptionButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber[700] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.amber[700]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _OptionButtonWithSubtitle extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  const _OptionButtonWithSubtitle({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber[700] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.amber[700]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
