import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'categoricalExpenses.dart';
import 'monthlyExpenses.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Expense Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final betweenSpace = 0.3;

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

  late List<MonthlyExpenses> expensesOf2023;
  @override
  void initState() {
    super.initState();
    expensesOf2023 = [
      MonthlyExpenses("JAN", januaryExpenses),
      MonthlyExpenses("FEB", februaryExpenses),
      MonthlyExpenses("MAR", marchExpenses),
      MonthlyExpenses("APR", aprilExpenses),
      MonthlyExpenses("MAY", mayExpenses),
      MonthlyExpenses("JUN", juneExpenses),
      MonthlyExpenses("JUL", julyExpenses),
      MonthlyExpenses("AUG", augustExpenses),
      MonthlyExpenses("SEP", septemberExpenses),
      MonthlyExpenses("OCT", octoberExpenses),
      MonthlyExpenses("NOV", novemberExpenses),
      MonthlyExpenses("DEC", decemberExpenses),
    ];
  }

  BarChartGroupData generateGroupData(
    int x,
    double food,
    double gwe,
    double transportation,
    double rent,
    double activities,
    double insurances,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: rent,
          colors: [const Color(0xFFE57373)],
          width: 8,
        ),
        BarChartRodData(
          fromY: rent + betweenSpace,
          toY: rent + betweenSpace + food,
          colors: [const Color(0xFFFFB74D)],
          width: 8,
        ),
        BarChartRodData(
          fromY: rent + betweenSpace + food + betweenSpace,
          toY: rent + betweenSpace + food + betweenSpace + gwe,
          colors: [const Color(0xFFFFD54F)],
          width: 8,
        ),
        BarChartRodData(
          fromY: rent + betweenSpace + food + betweenSpace + gwe + betweenSpace,
          toY: rent +
              betweenSpace +
              food +
              betweenSpace +
              gwe +
              betweenSpace +
              transportation,
          colors: [const Color(0xFF81C784)],
          width: 8,
        ),
        BarChartRodData(
          fromY: rent +
              betweenSpace +
              food +
              betweenSpace +
              gwe +
              betweenSpace +
              transportation +
              betweenSpace,
          toY: rent +
              betweenSpace +
              food +
              betweenSpace +
              gwe +
              betweenSpace +
              transportation +
              betweenSpace +
              activities,
          colors: [const Color(0xFF64B5F6)],
          width: 8,
        ),
        BarChartRodData(
          fromY: rent +
              betweenSpace +
              food +
              betweenSpace +
              gwe +
              betweenSpace +
              transportation +
              betweenSpace +
              activities +
              betweenSpace,
          toY: rent +
              betweenSpace +
              food +
              betweenSpace +
              gwe +
              betweenSpace +
              transportation +
              betweenSpace +
              activities +
              betweenSpace +
              insurances,
          colors: [const Color(0xFF9575CD)],
          width: 8,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: _buildGraph(),
          ),
          Expanded(
            flex: 1,
            child: _buildCardView(),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Widget _buildGraph() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 20, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '2023',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          AspectRatio(
            aspectRatio: 1.1,
            child: Column(
              children: [
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barTouchData: BarTouchData(enabled: false),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      maxY: expensesOf2023
                              .map((monthlyExpense) =>
                                  monthlyExpense.getTotalExpense())
                              .reduce((value, element) =>
                                  value > element ? value : element) +
                          300,
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTextStyles: (context, value) => const TextStyle(
                              color: Colors.black38, fontSize: 11),
                          margin: 10,
                          getTitles: (double value) {
                            int index = value.toInt();
                            if (index >= 0 && index < expensesOf2023.length) {
                              return expensesOf2023[index].column;
                            }
                            return 'error';
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTextStyles: (context, value) => const TextStyle(
                              color: Colors.black38, fontSize: 11),
                          margin: 7,
                        ),
                        topTitles: SideTitles(showTitles: false),
                        rightTitles: SideTitles(showTitles: false),
                      ),
                      barGroups: List.generate(
                        expensesOf2023.length,
                        (index) => generateGroupData(
                          index,
                          expensesOf2023[index]
                              .categoricalExpensesList[0]
                              .amount
                              .toDouble(),
                          expensesOf2023[index]
                              .categoricalExpensesList[1]
                              .amount
                              .toDouble(),
                          expensesOf2023[index]
                              .categoricalExpensesList[2]
                              .amount
                              .toDouble(),
                          expensesOf2023[index]
                              .categoricalExpensesList[3]
                              .amount
                              .toDouble(),
                          expensesOf2023[index]
                              .categoricalExpensesList[4]
                              .amount
                              .toDouble(),
                          expensesOf2023[index]
                              .categoricalExpensesList[5]
                              .amount
                              .toDouble(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardView() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (1 / .4),
      children: List.generate(januaryExpenses.length, (index) {
        return SizedBox(
          child: _buildCard(
            context,
            januaryExpenses[index].category,
            januaryExpenses[index].amount.toInt(),
            januaryExpenses[index].currency.sign,
          ),
        );
      }),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, int amount, String currency) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('$amount $currency'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _showDialog(context);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewScreen()),
          );
        },
      ),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Dialog Title'),
        content: Text('This is a dialog.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Screen'),
      ),
      body: Center(
        child: Text('This is a new screen.'),
      ),
    );
  }
}
