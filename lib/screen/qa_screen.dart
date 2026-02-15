import 'package:flutter/material.dart';
import 'package:avena/screen/main_shell.dart';

class QAScreen extends StatefulWidget {
  const QAScreen({super.key});

  @override
  State<QAScreen> createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const _pageCount = 7;

  final Map<String, dynamic> _userData = {
    'gender': null,
    'age': null,
    'weight': null,
    'height': null,
    'goalWeight': null,
    'healthGoal': null,
    'pace': null,
    'activityLevel': null,
    'meals': {},
    'restrictions': {},
  };

  double? _calculateTMB() {
    final gender = _userData['gender'];
    final age = _userData['age'];
    final weight = _userData['weight'];
    final height = _userData['height'];
    if (gender == null || age == null || weight == null || height == null) {
      return null;
    }
    if (age is! num ||
        age <= 0 ||
        weight is! num ||
        weight <= 0 ||
        height is! num ||
        height <= 0) {
      return null;
    }

    double tmb;
    if (gender == 'Male') {
      tmb = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else if (gender == 'Female') {
      tmb = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    } else {
      tmb =
          (((10 * weight) +
              (6.25 * height) -
              (5 * age) +
              5 +
              10 * weight +
              6.25 * height -
              5 * age -
              161) /
          2);
    }
    // Clamp to >= 0
    if (tmb <= 0) return null;
    return tmb;
  }

  double? _calculateTDEE() {
    final tmb = _calculateTMB();
    if (tmb == null) return null;
    final activityLevel = _userData['activityLevel'];
    double activityFactor;
    switch (activityLevel) {
      case 'Sedentary':
        activityFactor = 1.2;
        break;
      case 'Lightly Active':
        activityFactor = 1.375;
        break;
      case 'Moderately Active':
        activityFactor = 1.55;
        break;
      case 'Very Active':
        activityFactor = 1.725;
        break;
      case 'Extra Active':
        activityFactor = 1.9;
        break;
      default:
        activityFactor = 1.2;
    }
    final tdee = tmb * activityFactor;
    return tdee > 0 ? tdee : null;
  }

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
  Widget build(BuildContext context) {
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
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentPage = index),
        children: [
          _AboutYouStep(onNext: _nextPage, userData: _userData),
          _HealthGoalStep(onNext: _nextPage, userData: _userData),
          _PaceStep(onNext: _nextPage, userData: _userData),
          _ActivityLevelStep(onNext: _nextPage, userData: _userData),
          _MealsStep(onNext: _nextPage, userData: _userData),
          _RestrictionsStep(onNext: _nextPage, userData: _userData),
          _SummaryStep(
            onNext: _nextPage,
            userData: _userData,
            tmb: _calculateTMB(),
            tdee: _calculateTDEE(),
          ),
        ],
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
  const _StepContainer({
    required this.title,
    this.subtitle,
    required this.child,
    required this.onNext,
    this.buttonText = 'Continue',
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
                  onPressed: onNext,
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
  final VoidCallback onNext;
  final Map<String, dynamic> userData;
  const _AboutYouStep({required this.onNext, required this.userData});
  @override
  State<_AboutYouStep> createState() => _AboutYouStepState();
}

class _AboutYouStepState extends State<_AboutYouStep> {
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  String? _selectedGender;
  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(
      text: widget.userData['age']?.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: widget.userData['weight']?.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: widget.userData['height']?.toString() ?? '',
    );
    _selectedGender = widget.userData['gender'];
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    final age = double.tryParse(_ageController.text);
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    if (_selectedGender == null ||
        age == null ||
        weight == null ||
        height == null ||
        age <= 0 ||
        weight <= 0 ||
        height <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields with valid positive numbers.'),
        ),
      );
      return;
    }
    widget.userData['gender'] = _selectedGender;
    widget.userData['age'] = age;
    widget.userData['weight'] = weight;
    widget.userData['height'] = height;
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
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              hintText: 'Enter your weight',
              prefixIcon: Icon(Icons.monitor_weight_outlined),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _heightController,
            keyboardType: TextInputType.number,
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
  final VoidCallback onNext;
  final Map<String, dynamic> userData;
  const _HealthGoalStep({required this.onNext, required this.userData});
  @override
  State<_HealthGoalStep> createState() => _HealthGoalStepState();
}

class _HealthGoalStepState extends State<_HealthGoalStep> {
  String? _selectedGoal;
  late TextEditingController _goalWeightController;
  final List<String> _goals = [
    'Lose Weight',
    'Stay Fit',
    'Build Muscle',
    'Eat Healthier',
  ];
  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.userData['healthGoal'];
    _goalWeightController = TextEditingController(
      text: widget.userData['goalWeight']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _goalWeightController.dispose();
    super.dispose();
  }

  void _saveAndContinue() {
    widget.userData['healthGoal'] = _selectedGoal;
    if (_selectedGoal == 'Lose Weight') {
      widget.userData['goalWeight'] = double.tryParse(
        _goalWeightController.text,
      );
    }
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
              keyboardType: TextInputType.number,
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
class _PaceStep extends StatefulWidget {
  final VoidCallback onNext;
  final Map<String, dynamic> userData;
  const _PaceStep({required this.onNext, required this.userData});
  @override
  State<_PaceStep> createState() => _PaceStepState();
}

class _PaceStepState extends State<_PaceStep> {
  String? _selectedPace;
  final Map<String, String> _paces = {
    'Steady & Sustainable': 'Gradual progress, long-term habits',
    'Balanced': 'Moderate pace with flexibility',
    'Intensive': 'Fast results, strict plan',
  };
  @override
  void initState() {
    super.initState();
    _selectedPace = widget.userData['pace'];
  }

  void _saveAndContinue() {
    widget.userData['pace'] = _selectedPace;
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
class _ActivityLevelStep extends StatefulWidget {
  final VoidCallback onNext;
  final Map<String, dynamic> userData;
  const _ActivityLevelStep({required this.onNext, required this.userData});
  @override
  State<_ActivityLevelStep> createState() => _ActivityLevelStepState();
}

class _ActivityLevelStepState extends State<_ActivityLevelStep> {
  String? _selectedActivityLevel;
  final Map<String, String> _activityLevels = {
    'Sedentary': 'Little or no exercise',
    'Lightly Active': 'Light exercise, 1-3 days/week',
    'Moderately Active': 'Moderate exercise, 3-5 days/week',
    'Very Active': 'Hard exercise, 6-7 days/week',
    'Extra Active': 'Very hard exercise & physical job',
  };
  @override
  void initState() {
    super.initState();
    _selectedActivityLevel = widget.userData['activityLevel'];
  }

  void _saveAndContinue() {
    widget.userData['activityLevel'] = _selectedActivityLevel;
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
class _MealsStep extends StatefulWidget {
  final VoidCallback onNext;
  final Map<String, dynamic> userData;
  const _MealsStep({required this.onNext, required this.userData});
  @override
  State<_MealsStep> createState() => _MealsStepState();
}

class _MealsStepState extends State<_MealsStep> {
  final Map<String, bool> _meals = {
    'Breakfast': true,
    'Morning Snack': false,
    'Brunch': false,
    'Lunch': true,
    'Afternoon Snack': false,
    'Dinner': true,
    'Midnight Snack': false,
  };
  @override
  void initState() {
    super.initState();
    if (widget.userData['meals'] != null &&
        (widget.userData['meals'] as Map).isNotEmpty) {
      _meals.addAll(Map<String, bool>.from(widget.userData['meals']));
    }
  }

  void _saveAndContinue() {
    widget.userData['meals'] = Map<String, bool>.from(_meals);
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
                color: _meals[meal]! ? Colors.amber[700]! : Colors.grey[300]!,
                width: _meals[meal]! ? 2 : 1,
              ),
            ),
            child: CheckboxListTile(
              title: Text(
                meal,
                style: TextStyle(
                  fontWeight: _meals[meal]!
                      ? FontWeight.w600
                      : FontWeight.normal,
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
              activeColor: Colors.amber[700],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Step 6: Restrictions
class _RestrictionsStep extends StatefulWidget {
  final VoidCallback onNext;
  final Map<String, dynamic> userData;
  const _RestrictionsStep({required this.onNext, required this.userData});
  @override
  State<_RestrictionsStep> createState() => _RestrictionsStepState();
}

class _RestrictionsStepState extends State<_RestrictionsStep> {
  final Map<String, bool> _restrictions = {
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
  @override
  void initState() {
    super.initState();
    if (widget.userData['restrictions'] != null &&
        (widget.userData['restrictions'] as Map).isNotEmpty) {
      _restrictions.addAll(
        Map<String, bool>.from(widget.userData['restrictions']),
      );
    }
  }

  void _saveAndContinue() {
    widget.userData['restrictions'] = Map<String, bool>.from(_restrictions);
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
                    ? Colors.amber[700]!
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
              activeColor: Colors.amber[700],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Step 7: Summary with TMB/TDEE
class _SummaryStep extends StatelessWidget {
  final VoidCallback onNext;
  final Map<String, dynamic> userData;
  final double? tmb;
  final double? tdee;
  const _SummaryStep({
    required this.onNext,
    required this.userData,
    required this.tmb,
    required this.tdee,
  });

  @override
  Widget build(BuildContext context) {
    return _StepContainer(
      title: 'Your Personalized Plan',
      subtitle: 'Based on your information',
      onNext: onNext,
      buttonText: 'Get Started',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                          tmb != null ? '${tmb?.round()} kcal' : '-- kcal',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
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
                          tdee != null ? '${tdee?.round()} kcal' : '-- kcal',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (userData['healthGoal'] == 'Lose Weight' &&
              userData['goalWeight'] != null) ...[
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
                          '${userData['goalWeight']} kg',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (userData['weight'] != null &&
                      userData['goalWeight'] != null)
                    Text(
                      '${(userData['weight'] - userData['goalWeight']).abs().toStringAsFixed(1)} kg to go',
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
