import 'package:avena/model/initial.dart';
import 'package:avena/provider/initial.dart';
import 'package:avena/screen/main_shell.dart';
import 'package:avena/screen/qa.dart';
import 'package:flutter/material.dart';
import 'package:avena/screen/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.amber[700]!,
        ),
        appBarTheme: const AppBarTheme(
          // backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        useMaterial3: true,
      ),
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(initialStateProvider, (_, state) {
      if (state.hasValue) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => switch (state.value!) {
              InitialState.authenticate => const LoginScreen(),
              InitialState.qa => const QAScreen(),
              InitialState.home => const MainShell(),
            },
          ),
        );
      }
    });

    return Scaffold();
  }
}
