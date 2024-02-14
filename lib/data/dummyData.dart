import 'models/categoricalExpenses.dart';

class DummyData {
  DummyData._();

  static final DummyData _instance = DummyData._();

  static DummyData get instance => _instance;

  List<CategoricalExpenses> januaryExpenses = [
    CategoricalExpenses("Food", 600, Currency.Euro),
    CategoricalExpenses("GWE", 350, Currency.Euro),
    CategoricalExpenses('Transportation', 250, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 500, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> februaryExpenses = [
    CategoricalExpenses("Food", 550, Currency.Euro),
    CategoricalExpenses("GWE", 450, Currency.Euro),
    CategoricalExpenses('Transportation', 220, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 150, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> marchExpenses = [
    CategoricalExpenses("Food", 600, Currency.Euro),
    CategoricalExpenses("GWE", 250, Currency.Euro),
    CategoricalExpenses('Transportation', 250, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 400, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> aprilExpenses = [
    CategoricalExpenses("Food", 550, Currency.Euro),
    CategoricalExpenses("GWE", 200, Currency.Euro),
    CategoricalExpenses('Transportation', 20, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 150, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> mayExpenses = [
    CategoricalExpenses("Food", 600, Currency.Euro),
    CategoricalExpenses("GWE", 170, Currency.Euro),
    CategoricalExpenses('Transportation', 50, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 100, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> juneExpenses = [
    CategoricalExpenses("Food", 550, Currency.Euro),
    CategoricalExpenses("GWE", 60, Currency.Euro),
    CategoricalExpenses('Transportation', 20, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 150, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> julyExpenses = [
    CategoricalExpenses("Food", 600, Currency.Euro),
    CategoricalExpenses("GWE", 50, Currency.Euro),
    CategoricalExpenses('Transportation', 50, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 100, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> augustExpenses = [
    CategoricalExpenses("Food", 550, Currency.Euro),
    CategoricalExpenses("GWE", 30, Currency.Euro),
    CategoricalExpenses('Transportation', 220, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 150, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> septemberExpenses = [
    CategoricalExpenses("Food", 600, Currency.Euro),
    CategoricalExpenses("GWE", 50, Currency.Euro),
    CategoricalExpenses('Transportation', 250, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 100, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> octoberExpenses = [
    CategoricalExpenses("Food", 550, Currency.Euro),
    CategoricalExpenses("GWE", 90, Currency.Euro),
    CategoricalExpenses('Transportation', 220, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 150, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> novemberExpenses = [
    CategoricalExpenses("Food", 600, Currency.Euro),
    CategoricalExpenses("GWE", 150, Currency.Euro),
    CategoricalExpenses('Transportation', 250, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 100, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];

  List<CategoricalExpenses> decemberExpenses = [
    CategoricalExpenses("Food", 550, Currency.Euro),
    CategoricalExpenses("GWE", 300, Currency.Euro),
    CategoricalExpenses('Transportation', 220, Currency.Euro),
    CategoricalExpenses('Rent', 1600, Currency.Euro),
    CategoricalExpenses('Activities', 150, Currency.Euro),
    CategoricalExpenses('Insurances', 350, Currency.Euro)
  ];
}
