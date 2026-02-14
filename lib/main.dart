import 'package:flutter/material.dart';
// 1. Importa o teu ecrã de login (ajusta o caminho se necessário)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:avena/screen/login_screen.dart';

void main() {
  runApp(
    // ⚠️ IMPORTANTE: ProviderScope é obrigatório para Riverpod funcionar!
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}