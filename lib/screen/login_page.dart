import 'package:avena/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    // TODO: Implement login logic
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // Usando o gradiente do tema como base
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
                    Text('Avena', style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 16),
                    Image.asset('assets/img.png', width: 80, height: 80), // Imagem ligeiramente menor
                    const SizedBox(height: 32),

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

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Forgot Password?', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(onPressed: _onLogin, child: const Text('Login')),

                    const SizedBox(height: 32), // Espaço antes da secção "pequena"

                    // --- SECÇÃO MINI (Social Login) ---
                    Opacity(
                      opacity: 0.8, // Torna um pouco mais discreto
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Expanded(child: Divider(thickness: 0.5)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Text('Or log in with', style: TextStyle(fontSize: 11)),
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
                                  onTap: () {}
                              ),
                              const SizedBox(width: 16),
                              _buildSocialBtn(
                                  icon: Icons.code,
                                  theme: theme,
                                  onTap: () {}
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- RODAPÉ MINI ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?", style: TextStyle(fontSize: 12)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignupPage()),
                            );
                          },
                          style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                          child: const Text('Sign up', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para criar os botões sociais bem pequenos
  Widget _buildSocialBtn({String? label, IconData? icon, required ThemeData theme, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40, // Tamanho reduzido (antes era 56)
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