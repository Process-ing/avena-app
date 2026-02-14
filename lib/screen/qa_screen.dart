import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/profile_provider.dart';
import '../model/user_profile_model.dart';

class QAScreen extends ConsumerStatefulWidget {
  const QAScreen({super.key});

  @override
  ConsumerState<QAScreen> createState() => _QAScreenState();
}

class _QAScreenState extends ConsumerState<QAScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSaving = false;

  void _nextPage() {
    if (_currentPage < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Finish questionnaire and save to backend
      _saveProfile();
    }
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await ref.read(questionnaireProvider.notifier).saveProfile();

      if (!mounted) return;

      // Navigate to next screen after successful save
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const PantryScreen()),
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
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
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F3),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isSaving ? null : _previousPage,
        ),
        title: Row(
          children: List.generate(7, (index) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 4,
                decoration: BoxDecoration(
                  color: index <= _currentPage
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _AboutYouStep(onNext: _nextPage),
          _HealthGoalStep(onNext: _nextPage),
          _PaceStep(onNext: _nextPage),
          _ActivityLevelStep(onNext: _nextPage),
          _MealsStep(onNext: _nextPage),
          _RestrictionsStep(onNext: _nextPage),
          _SummaryStep(onNext: _nextPage, isSaving: _isSaving),
        ],
      ),
    );
  }
}

// Base Step Widget
class _StepContainer extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback onNext;
  final String buttonText;
  final bool isLoading;

  const _StepContainer({
    required this.title,
    this.subtitle,
    required this.child,
    required this.onNext,
    this.buttonText = 'Continue',
    this.isLoading = false,
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
                  onPressed: isLoading ? null : onNext,
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
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
class _AboutYouStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const _AboutYouStep({required this.onNext});

  @override
  ConsumerState<_AboutYouStep> createState() => _AboutYouStepState();
}

class _AboutYouStepState extends ConsumerState<_AboutYouStep> {
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  String? _selectedGender;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize with empty controllers - we'll populate them in didChangeDependencies
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only initialize once
    if (!_isInitialized) {
      final profile = ref.read(questionnaireProvider);
      if (profile.age != null) {
        _ageController.text = profile.age.toString();
      }
      if (profile.weight != null) {
        _weightController.text = profile.weight.toString();
      }
      if (profile.height != null) {
        _heightController.text = profile.height.toString();
      }
      _selectedGender = profile.gender;
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    // Validate fields
    if (_selectedGender == null ||
        _ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final age = double.tryParse(_ageController.text);
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);

    if (age == null || weight == null || height == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numbers'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final notifier = ref.read(questionnaireProvider.notifier);
    final currentProfile = ref.read(questionnaireProvider);

    notifier.updateData(
      currentProfile.copyWith(
        gender: _selectedGender,
        age: age,
        weight: weight,
        height: height,
      ),
    );

    print('=== SAVED ABOUT YOU ===');
    print('Gender: $_selectedGender');
    print('Age: $age');
    print('Weight: $weight');
    print('Height: $height');

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'Tell us about yourself',
      subtitle: 'This helps us personalize your experience',
      onNext: _saveAndContinue,
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
            children: ['Male', 'Female', 'Other'].map((gender) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _OptionButton(
                    label: gender,
                    isSelected: _selectedGender == gender,
                    onTap: () => setState(() => _selectedGender = gender),
                  ),
                ),
              );
            }).toList(),
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
class _HealthGoalStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const _HealthGoalStep({required this.onNext});

  @override
  ConsumerState<_HealthGoalStep> createState() => _HealthGoalStepState();
}

class _HealthGoalStepState extends ConsumerState<_HealthGoalStep> {
  String? _selectedGoal;
  late TextEditingController _goalWeightController;
  bool _isInitialized = false;
  final List<String> _goals = [
    'Lose Weight',
    'Stay Fit',
    'Build Muscle',
    'Eat Healthier',
  ];

  @override
  void initState() {
    super.initState();
    _goalWeightController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final profile = ref.read(questionnaireProvider);
      _selectedGoal = profile.healthGoal;
      if (profile.goalWeight != null) {
        _goalWeightController.text = profile.goalWeight.toString();
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _goalWeightController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    // Validate
    if (_selectedGoal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a health goal'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final notifier = ref.read(questionnaireProvider.notifier);
    final currentProfile = ref.read(questionnaireProvider);

    double? goalWeight;
    if (_selectedGoal == 'Lose Weight') {
      goalWeight = double.tryParse(_goalWeightController.text);
      if (goalWeight == null && _goalWeightController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid goal weight'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    notifier.updateData(
      currentProfile.copyWith(
        healthGoal: _selectedGoal,
        goalWeight: goalWeight,
      ),
    );

    print('=== SAVED HEALTH GOAL ===');
    print('Goal: $_selectedGoal');
    print('Goal Weight: $goalWeight');

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'What is your health goal?',
      subtitle: 'Choose your primary objective',
      onNext: _saveAndContinue,
      child: Column(
        children: [
          ..._goals.map((goal) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OptionButton(
                label: goal,
                isSelected: _selectedGoal == goal,
                onTap: () => setState(() => _selectedGoal = goal),
              ),
            );
          }),
          if (_selectedGoal == 'Lose Weight') ...[
            const SizedBox(height: 24),
            TextField(
              controller: _goalWeightController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
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

// Step 3: Pace
class _PaceStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const _PaceStep({required this.onNext});

  @override
  ConsumerState<_PaceStep> createState() => _PaceStepState();
}

class _PaceStepState extends ConsumerState<_PaceStep> {
  String? _selectedPace;
  bool _isInitialized = false;
  final Map<String, String> _paces = {
    'Steady & Sustainable': 'Gradual progress, long-term habits',
    'Balanced': 'Moderate pace with flexibility',
    'Intensive': 'Fast results, strict plan',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _selectedPace = ref.read(questionnaireProvider).pace;
      _isInitialized = true;
    }
  }

  void _saveAndContinue() {
    if (_selectedPace == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a pace'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final notifier = ref.read(questionnaireProvider.notifier);
    final currentProfile = ref.read(questionnaireProvider);

    notifier.updateData(
      currentProfile.copyWith(pace: _selectedPace),
    );

    print('=== SAVED PACE ===');
    print('Pace: $_selectedPace');

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'How fast do you want to get there?',
      subtitle: 'Choose your preferred pace',
      onNext: _saveAndContinue,
      child: Column(
        children: _paces.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionButtonWithSubtitle(
              label: entry.key,
              subtitle: entry.value,
              isSelected: _selectedPace == entry.key,
              onTap: () => setState(() => _selectedPace = entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Step 4: Activity Level
class _ActivityLevelStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const _ActivityLevelStep({required this.onNext});

  @override
  ConsumerState<_ActivityLevelStep> createState() =>
      _ActivityLevelStepState();
}

class _ActivityLevelStepState extends ConsumerState<_ActivityLevelStep> {
  String? _selectedActivityLevel;
  bool _isInitialized = false;
  final Map<String, String> _activityLevels = {
    'Sedentary': 'Little or no exercise',
    'Lightly Active': 'Light exercise, 1-3 days/week',
    'Moderately Active': 'Moderate exercise, 3-5 days/week',
    'Very Active': 'Hard exercise, 6-7 days/week',
    'Extra Active': 'Very hard exercise & physical job',
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _selectedActivityLevel = ref.read(questionnaireProvider).activityLevel;
      _isInitialized = true;
    }
  }

  void _saveAndContinue() {
    if (_selectedActivityLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an activity level'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final notifier = ref.read(questionnaireProvider.notifier);
    final currentProfile = ref.read(questionnaireProvider);

    notifier.updateData(
      currentProfile.copyWith(activityLevel: _selectedActivityLevel),
    );

    print('=== SAVED ACTIVITY LEVEL ===');
    print('Activity Level: $_selectedActivityLevel');

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'What is your activity level?',
      subtitle: 'Pick your usual activity',
      onNext: _saveAndContinue,
      child: Column(
        children: _activityLevels.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _OptionButtonWithSubtitle(
              label: entry.key,
              subtitle: entry.value,
              isSelected: _selectedActivityLevel == entry.key,
              onTap: () => setState(() => _selectedActivityLevel = entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Step 5: Meals
class _MealsStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const _MealsStep({required this.onNext});

  @override
  ConsumerState<_MealsStep> createState() => _MealsStepState();
}

class _MealsStepState extends ConsumerState<_MealsStep> {
  late Map<String, bool> _meals;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _meals = {
      'Breakfast': true,
      'Brunch': false,
      'Lunch': true,
      'Afternoon Snack': false,
      'Dinner': true,
      'Midnight Snack': false,
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final profile = ref.read(questionnaireProvider);
      if (profile.meals.isNotEmpty) {
        for (var entry in profile.meals.entries) {
          if (_meals.containsKey(entry.key)) {
            _meals[entry.key] = entry.value;
          }
        }
      }
      _isInitialized = true;
    }
  }

  void _saveAndContinue() {
    final notifier = ref.read(questionnaireProvider.notifier);
    final currentProfile = ref.read(questionnaireProvider);

    notifier.updateData(
      currentProfile.copyWith(meals: Map<String, bool>.from(_meals)),
    );

    print('=== SAVED MEALS ===');
    print('Meals: $_meals');

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'Which meals do you include?',
      subtitle: 'Select all that apply',
      onNext: _saveAndContinue,
      child: Column(
        children: _meals.keys.map((meal) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _meals[meal]!
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
                width: _meals[meal]! ? 2 : 1,
              ),
            ),
            child: CheckboxListTile(
              title: Text(
                meal,
                style: TextStyle(
                  fontWeight:
                  _meals[meal]! ? FontWeight.w600 : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              value: _meals[meal],
              onChanged: (value) {
                setState(() {
                  _meals[meal] = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Step 6: Restrictions
class _RestrictionsStep extends ConsumerStatefulWidget {
  final VoidCallback onNext;

  const _RestrictionsStep({required this.onNext});

  @override
  ConsumerState<_RestrictionsStep> createState() => _RestrictionsStepState();
}

class _RestrictionsStepState extends ConsumerState<_RestrictionsStep> {
  late Map<String, bool> _restrictions;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _restrictions = {
      'Gluten-free': false,
      'Dairy-free': false,
      'Nut-free': false,
      'Shellfish-free': false,
      'Vegetarian': false,
      'Vegan': false,
      'Pescatarian': false,
      'No Pork': false,
      'No Alcohol': false,
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final profile = ref.read(questionnaireProvider);
      if (profile.restrictions.isNotEmpty) {
        for (var entry in profile.restrictions.entries) {
          if (_restrictions.containsKey(entry.key)) {
            _restrictions[entry.key] = entry.value;
          }
        }
      }
      _isInitialized = true;
    }
  }

  void _saveAndContinue() {
    final notifier = ref.read(questionnaireProvider.notifier);
    final currentProfile = ref.read(questionnaireProvider);

    notifier.updateData(
      currentProfile.copyWith(
        restrictions: Map<String, bool>.from(_restrictions),
      ),
    );

    print('=== SAVED RESTRICTIONS ===');
    print('Restrictions: $_restrictions');

    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'Any dietary restrictions?',
      subtitle: 'Select all that apply',
      onNext: _saveAndContinue,
      child: Column(
        children: _restrictions.keys.map((restriction) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _restrictions[restriction]!
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
                width: _restrictions[restriction]! ? 2 : 1,
              ),
            ),
            child: CheckboxListTile(
              title: Text(
                restriction,
                style: TextStyle(
                  fontWeight: _restrictions[restriction]!
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: Colors.black87,
                ),
              ),
              value: _restrictions[restriction],
              onChanged: (value) {
                setState(() {
                  _restrictions[restriction] = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Step 7: Summary with TMB/TDEE
class _SummaryStep extends ConsumerWidget {
  final VoidCallback onNext;
  final bool isSaving;

  const _SummaryStep({
    required this.onNext,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profile = ref.watch(questionnaireProvider);
    final notifier = ref.read(questionnaireProvider.notifier);

    final tmb = notifier.calculateTMB();
    final tdee = notifier.calculateTDEE();
    final recommendedCalories = notifier.calculateRecommendedCalories();
    final weeksToGoal = notifier.calculateWeeksToGoal();

    // Debug: Print profile data to see what's available
    print('=== PROFILE DATA ===');
    print('Gender: ${profile.gender}');
    print('Age: ${profile.age}');
    print('Weight: ${profile.weight}');
    print('Height: ${profile.height}');
    print('Activity Level: ${profile.activityLevel}');
    print('Health Goal: ${profile.healthGoal}');
    print('TMB: $tmb');
    print('TDEE: $tdee');
    print('==================');

    return _StepContainer(
      title: 'Your Personalized Plan',
      subtitle: 'Based on your information',
      onNext: onNext,
      buttonText: 'Get Started',
      isLoading: isSaving,
      child: Column(
        children: [
          // Show warning if data is incomplete
          if (tmb == null || tdee == null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Missing data: ${profile.gender == null ? "Gender " : ""}${profile.age == null ? "Age " : ""}${profile.weight == null ? "Weight " : ""}${profile.height == null ? "Height " : ""}${profile.activityLevel == null ? "Activity Level" : ""}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          // TMB/TDEE Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.colorScheme.primary, width: 2),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.local_fire_department,
                  size: 48,
                  color: theme.colorScheme.primary,
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
                            tmb != null ? '${tmb.round()} kcal' : '-- kcal',
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
                            tdee != null ? '${tdee.round()} kcal' : '-- kcal',
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
                if (recommendedCalories != null) ...[
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
                              '${recommendedCalories.round()} kcal',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Goal summary
          if (profile.healthGoal == 'Lose Weight' &&
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
                  Icon(Icons.flag, color: theme.colorScheme.primary),
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
                        if (weeksToGoal != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Est. ${weeksToGoal.round()} weeks',
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
                        color: theme.colorScheme.primary,
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
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your BMR is the calories you burn at rest. TDEE includes your activity level. We\'ll use this to create your personalized meal plan.',
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

// Option Button Widget
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
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey[300]!,
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

// Option Button with Subtitle
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
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : Colors.grey[300]!,
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