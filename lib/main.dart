import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/homePage.dart';
import 'database/database.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  runApp(MyApp(database: db));
}

class MyApp extends StatefulWidget {
  final AppDatabase database;
  const MyApp({Key? key, required this.database});

  @override
  MyAppState createState() => MyAppState();

  static MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp> {
  Locale locale = Locale('en');

  void setLocale(Locale value) {
    setState(() {
      locale = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _getLocal().then((locale) {
      setState(() {
        this.locale = locale;
      });
    });
  }

  Future<Locale> _getLocal() async {
    final prefs = await SharedPreferences.getInstance();

    final languageCode = prefs.getString('languageCode') ?? 'en';
    return Locale(languageCode);
  }

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
          locale: locale,
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
