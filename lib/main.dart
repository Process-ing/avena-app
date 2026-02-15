import 'package:avena/model/initial.dart';
import 'package:avena/provider/initial.dart';
import 'package:avena/screen/home.dart';
import 'package:avena/screen/qa_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:avena/screen/login_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
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
              InitialState.authenticate => LoginScreen(),
              InitialState.qa => QAScreen(),
              InitialState.home => HomeScreen(),
            },
          ),
        );
      }
    });

    return Scaffold();
  }
}
