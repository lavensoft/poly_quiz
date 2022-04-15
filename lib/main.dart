import 'package:flutter/material.dart';

//Screens
import 'screens/home/main.dart';
import "screens/quiz/main.dart";
import "screens/auth/login/main.dart";
import "screens/auth/signup/main.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/signup': (context) => SignupScreen(),
        '/login': (context) => LoginScreen(),
        '/quiz': (context) => QuizScreen(
          data: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
        ),
        '/': (context) => HomeScreen(),
      },
    );
  }
}
