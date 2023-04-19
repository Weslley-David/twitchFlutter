import 'package:flutter/material.dart';
import '../view/createUsers.dart';
import '../view/listUsers.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/createusers',
      routes: {
        '/createusers': (context) => const createUsers(),
        '/listusers': (context) => const listUsers(),
      },
    );
  }
}
