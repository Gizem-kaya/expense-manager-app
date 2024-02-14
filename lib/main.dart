import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/homePage.dart';
import 'database/database.dart';

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
    return Provider(
        create: (context) => AppDatabase(),
        child: MaterialApp(
          title: 'Expense Manager',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: const HomePage(title: 'Expense Manager'),
        ));
  }
}
