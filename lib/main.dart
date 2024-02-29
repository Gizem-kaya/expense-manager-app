import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/homePage.dart';
import 'database/database.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'l10n/l10n.dart';

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
          supportedLocales: L10n.all,
          locale: const Locale('tr'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          home: const HomePage(title: 'Expense Manager'),
        ));
  }
}
