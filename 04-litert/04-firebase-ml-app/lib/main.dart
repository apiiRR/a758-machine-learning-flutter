import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ml_app/firebase_options.dart';
import 'package:firebase_ml_app/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  // todo-00: init firebase 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
      ),
      home: HomePage(),
    );
  }
}
