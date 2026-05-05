import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones del placeholder.
  // Recuerda reemplazar los valores en lib/firebase_options.dart
  // con las credenciales reales de tu proyecto "centralc".
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LifeToursApp());
}

class LifeToursApp extends StatelessWidget {
  const LifeToursApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeTours Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1A6B5A),
        brightness: Brightness.light,
      ),
      home: const LoginScreen(),
    );
  }
}
