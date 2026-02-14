import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 4) {
      setState(() => _currentPage++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold com fundo transparente para mostrar o gradiente do AppTheme
    return Scaffold(
      body: AppTheme.backgroundGradient(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) => setState(() => _currentPage = index),
          children: [
            _TellUsAboutYourselfStep(onNext: _nextPage, onBack: _previousPage),
            _HealthPriorityStep(onNext: _nextPage, onBack: _previousPage),
            _PaceStep(onNext: _nextPage, onBack: _previousPage),
            _MealsStep(onNext: _nextPage, onBack: _previousPage),
            _RestrictionsStep(
              onBack: _previousPage,
              onFinish: () => Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ],
        ),
      ),
    );
  }
}

// --- BASE WIDGET ---
class _QuestionnaireStep extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final String nextButtonText;

  const _QuestionnaireStep({
    required this.title,
    required this.child,
    required this.onNext,
    required this.onBack,
    this.nextButtonText = 'Next',
  });

  @override
  Widget build(BuildContext context) {
    return Center( // Centraliza o bloco inteiro na tela
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Faz a coluna encolher para o centro
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32), // Espaço entre título e respostas

              // Conteúdo (as tuas respostas/opções)
              child,

              const SizedBox(height: 32), // Espaço entre respostas e botões

              // Botões Back e Next (agora colados ao conteúdo)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onBack,
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onNext,
                      child: const Text('Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// --- STEP 1: TELL US ABOUT YOURSELF ---
class _TellUsAboutYourselfStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TellUsAboutYourselfStep({required this.onNext, required this.onBack});

  @override
  State<_TellUsAboutYourselfStep> createState() => _TellUsAboutYourselfStepState();
}

class _TellUsAboutYourselfStepState extends State<_TellUsAboutYourselfStep> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return _QuestionnaireStep(
      title: 'Tell us about yourself',
      onNext: widget.onNext,
      onBack: widget.onBack,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: ['Men', 'Women', 'Other'].map((gender) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _OptionButton(
                    label: gender,
                    isSelected: _selectedGender == gender,
                    onTap: () => setState(() => _selectedGender = gender),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 32),
            TextField(controller: _weightController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Weight (kg)')),
            const SizedBox(height: 16),
            TextField(controller: _heightController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Height (cm)')),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET AUXILIAR PARA OPÇÕES ---
class _OptionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? theme.colorScheme.primary : Colors.transparent,
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : theme.dividerColor,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Text(label),
    );
  }
}
// --- STEP 2: HEALTH PRIORITY ---
class _HealthPriorityStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _HealthPriorityStep({required this.onNext, required this.onBack});

  @override
  State<_HealthPriorityStep> createState() => _HealthPriorityStepState();
}

class _HealthPriorityStepState extends State<_HealthPriorityStep> {
  final List<String> _options = ['Loose weight', 'Stay fit', 'Build muscle'];
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return _QuestionnaireStep(
      title: 'What is your health priority?',
      onNext: widget.onNext,
      onBack: widget.onBack,
      child: Column(
        mainAxisSize: MainAxisSize.min, // CENTRA O CONTEÚDO
        children: _options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _OptionButton(
            label: option,
            isSelected: _selectedOption == option,
            onTap: () => setState(() => _selectedOption = option),
          ),
        )).toList(),
      ),
    );
  }
}

// --- STEP 3: PACE ---
class _PaceStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _PaceStep({required this.onNext, required this.onBack});

  @override
  State<_PaceStep> createState() => _PaceStepState();
}

class _PaceStepState extends State<_PaceStep> {
  final List<String> _options = ['Steady & Sustainable', 'Balanced', 'Intensive'];
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return _QuestionnaireStep(
      title: 'How fast would you like to get there?',
      onNext: widget.onNext,
      onBack: widget.onBack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _options.map((option) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _OptionButton(
            label: option,
            isSelected: _selectedOption == option,
            onTap: () => setState(() => _selectedOption = option),
          ),
        )).toList(),
      ),
    );
  }
}

// --- STEP 4: MEALS ---
class _MealsStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _MealsStep({required this.onNext, required this.onBack});

  @override
  State<_MealsStep> createState() => _MealsStepState();
}

class _MealsStepState extends State<_MealsStep> {
  final Map<String, bool> _options = {
    'Breakfast': false, 'Brunch': false, 'Lunch': false,
    'Afternoon Snack': false, 'Dinner': false, 'Midnight Snack': false,
  };

  @override
  Widget build(BuildContext context) {
    return _QuestionnaireStep(
      title: 'Which meals do you include?',
      onNext: widget.onNext,
      onBack: widget.onBack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _options.keys.map((key) => CheckboxListTile(
          title: Text(key, style: const TextStyle(fontWeight: FontWeight.w500)),
          value: _options[key],
          onChanged: (val) => setState(() => _options[key] = val!),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        )).toList(),
      ),
    );
  }
}

// --- STEP 5: RESTRICTIONS ---
class _RestrictionsStep extends StatefulWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;
  const _RestrictionsStep({required this.onFinish, required this.onBack});

  @override
  State<_RestrictionsStep> createState() => _RestrictionsStepState();
}

class _RestrictionsStepState extends State<_RestrictionsStep> {
  final Map<String, bool> _options = {
    'Gluten-free': false, 'Dairy-free': false, 'Nut-free': false,
    'Shellfish-free': false, 'Vegetarian': false, 'Vegan': false,
    'Pescatarian': false, 'No Pork': false, 'No Alcohol': false, 'None': false,
  };

  @override
  Widget build(BuildContext context) {
    return _QuestionnaireStep(
      title: 'Do you have any restrictions?',
      onNext: widget.onFinish,
      onBack: widget.onBack,
      nextButtonText: 'Finish',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _options.keys.map((key) => CheckboxListTile(
          title: Text(key, style: const TextStyle(fontWeight: FontWeight.w500)),
          value: _options[key],
          onChanged: (val) => setState(() => _options[key] = val!),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        )).toList(),
      ),
    );
  }
}