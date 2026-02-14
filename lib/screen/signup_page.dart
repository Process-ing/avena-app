import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'questionnaire_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignup() {
    // TODO: Validar e criar conta
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const QuestionnairePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: AppTheme.backgroundGradient(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/img.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.account_circle, size: 80, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),

                    // Formulário
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(hintText: 'Username'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Confirm Password'),
                    ),
                    const SizedBox(height: 24),

                    FilledButton(
                      onPressed: _onSignup,
                      child: const Text('Sign Up'),
                    ),

                    const SizedBox(height: 24),

                    // --- SECÇÃO SOCIAL MINI ---
                    Opacity(
                      opacity: 0.8,
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Expanded(child: Divider(thickness: 0.5)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('Or sign up with', style: TextStyle(fontSize: 11)),
                              ),
                              Expanded(child: Divider(thickness: 0.5)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialBtn(
                                  label: "G",
                                  theme: theme,
                                  onTap: () { /* Google Logic */ }
                              ),
                              const SizedBox(width: 16),
                              _buildSocialBtn(
                                  icon: Icons.code,
                                  theme: theme,
                                  onTap: () { /* GitHub Logic */ }
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // --- RODAPÉ MINI ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?", style: TextStyle(fontSize: 12)),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                          child: const Text(
                              'Log in',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Mesmo widget auxiliar compacto da LoginPage
  Widget _buildSocialBtn({String? label, IconData? icon, required ThemeData theme, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.8),
          border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
        ),
        child: Center(
          child: label != null
              ? Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
              : Icon(icon, size: 18),
        ),
      ),
    );
  }
}