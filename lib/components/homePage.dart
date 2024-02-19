import 'package:expense_manager/data/dummyData.dart';
import 'package:expense_manager/database/database.dart';
import 'package:expense_manager/models/categoricalExpenses.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/monthlyExpenses.dart';
import '../utils.dart';
import 'categoryPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppDatabase database;
  late List<MonthlyExpenses> expensesOf2023;
  @override
  void initState() {
    super.initState();
    expensesOf2023 = [
      MonthlyExpenses("JAN", 2023, DummyData.instance.januaryExpenses),
      MonthlyExpenses("FEB", 2023, DummyData.instance.februaryExpenses),
      MonthlyExpenses("MAR", 2023, DummyData.instance.marchExpenses),
      MonthlyExpenses("APR", 2023, DummyData.instance.aprilExpenses),
      MonthlyExpenses("MAY", 2023, DummyData.instance.mayExpenses),
      MonthlyExpenses("JUN", 2023, DummyData.instance.juneExpenses),
      MonthlyExpenses("JUL", 2023, DummyData.instance.julyExpenses),
      MonthlyExpenses("AUG", 2023, DummyData.instance.augustExpenses),
      MonthlyExpenses("SEP", 2023, DummyData.instance.septemberExpenses),
      MonthlyExpenses("OCT", 2023, DummyData.instance.octoberExpenses),
      MonthlyExpenses("NOV", 2023, DummyData.instance.novemberExpenses),
      MonthlyExpenses("DEC", 2023, DummyData.instance.decemberExpenses),
    ];
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Expense>>(
        future: _getExpensesFromDatabase(database),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting for fetching data from database...");
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print("The database has an error!");
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            print("No data in the database!");
            return Center(child: Text('No data'));
          } else {
            List<Expense>? expenses = snapshot.data;
            print(expenses);
            if (expenses != null && expenses.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildGraph(expenses),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildCardView(),
                  ),
                ],
              );
            } else {
              return Center(
                  child: Text(
                "No expenses found!\n"
                "Click + button to add a new expense",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ));
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Floating action button pressed');
          addExpenseDialog(context, 2023, "march", "transportation", 210);
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Future<List<Expense>> _getExpensesFromDatabase(AppDatabase database) async {
    return await database.getAllExpenses();
  }

  List<MonthlyExpenses> _createMonthlyExpenses(List<Expense> expenses) {
    List<MonthlyExpenses> monthlyExpenses = [];

    expenses.forEach((expense) {
      int index = monthlyExpenses.indexWhere((monthlyExpense) =>
          expense.year == monthlyExpense.year &&
          expense.month == monthlyExpense.month);
      if (index == -1) {
        monthlyExpenses.add(MonthlyExpenses(expense.month, expense.year, [
          CategoricalExpenses(
              expense.category, expense.value!.toInt(), Currency.Euro)
        ]));
      } else {
        monthlyExpenses[index].categoricalExpensesList.add(CategoricalExpenses(
            expense.category, expense.value!.toInt(), Currency.Euro));
      }
    });

    return monthlyExpenses;
  }

  Widget _buildGraph(List<Expense> expenses) {
    List<MonthlyExpenses> monthlyExpenses = _createMonthlyExpenses(expenses);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 20, 5),
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
                      maxY: monthlyExpenses
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
                            if (index >= 0 && index < monthlyExpenses.length) {
                              return getAbbreviation(
                                  monthlyExpenses[index].month);
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
                        monthlyExpenses.length,
                        (index) => generateGroupData(
                          index,
                          monthlyExpenses[index]
                              .categoricalExpensesList[0]
                              .amount
                              .toDouble(),
                          monthlyExpenses[index]
                              .categoricalExpensesList[1]
                              .amount
                              .toDouble(),
                          monthlyExpenses[index]
                              .categoricalExpensesList[2]
                              .amount
                              .toDouble(),
                          monthlyExpenses[index]
                              .categoricalExpensesList[3]
                              .amount
                              .toDouble(),
                          monthlyExpenses[index]
                              .categoricalExpensesList[4]
                              .amount
                              .toDouble(),
                          monthlyExpenses[index]
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
      children:
          List.generate(DummyData.instance.januaryExpenses.length, (index) {
        return SizedBox(
          child: _buildCard(
            context,
            DummyData.instance.januaryExpenses[index].category,
            DummyData.instance.januaryExpenses[index].amount.toInt(),
            DummyData.instance.januaryExpenses[index].currency.sign,
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
          onPressed: () => increaseExpenseDialog(context),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryPage()),
          );
        },
      ),
    );
  }
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
  final betweenSpace = 0.3;

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
