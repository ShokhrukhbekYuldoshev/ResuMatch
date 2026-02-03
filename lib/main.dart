import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resumatch/core/theme/app_theme.dart';
import 'package:resumatch/firebase_options.dart';

// Import your layers
import 'data/services/ai_service.dart';
import 'logic/analysis/analysis_bloc.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final aiService = AIService();

  runApp(
    BlocProvider(
      create: (context) => AnalysisBloc(aiService),
      child: const ResuMatchApp(),
    ),
  );
}

class ResuMatchApp extends StatelessWidget {
  const ResuMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResuMatch AI',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
