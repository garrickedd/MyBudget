import 'package:flutter/material.dart';
import 'package:my_budget/ui/screens/home_screen/home_screen.dart';
import 'package:my_budget/ui/screens/introduction_screens/introduction_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "MyBudget",
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Introduction(),
        '/home': (context) => HomeScreen(),
      },
      // home: HomeScreen()
    );
  }
}
