import 'package:flutter/material.dart';
import 'components/homePage.dart';
import './data/expenses.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(MyApp(database: db));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;
  const MyApp({Key? key, required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(title: 'Expense Manager'),
    );
  }
}
