import 'package:expense_manager/database/database.dart';
import 'package:expense_manager/models/categoricalExpenses.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
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
  late int selectedYear;
  late String selectedMonth;
  late Currency selectedCurrency;

  @override
  void initState() {
    super.initState();
    selectedMonth = 'december';
    selectedCurrency = Currency.Euro;
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print('Add button pressed');
              addExpenseDialog(context, 2023, "march", "transportation", 210);
            },
          ),
        ],
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
            if (expenses != null && expenses.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildGraph(expenses),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildCardContainer(expenses),
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
    );
  }

  Future<List<Expense>> _getExpensesFromDatabase(AppDatabase database) async {
    return await database.getAllExpenses();
  }

  List<MonthlyExpenses> _createMonthlyExpenses(List<Expense> expenses) {
    List<MonthlyExpenses> monthlyExpenses = [];

    int maxYear = 0;

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
      selectedYear = expense.year > maxYear ? expense.year : maxYear;
    });

    return monthlyExpenses
        .where((expense) => expense.year == selectedYear)
        .toList();
  }

  Widget _buildCardContainer(List<Expense> expenses) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: () {
              _showMonthPicker(context);
            },
            child: Text(capitalize(selectedMonth)),
          ),
          Expanded(
            flex: 1,
            child: _buildCardView(expenses),
          ),
        ],
      ),
    );
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    final String? month = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  itemExtent: 40.0,
                  onSelectedItemChanged: (int index) {
                    setState(() {
                      selectedMonth = months[index];
                    });
                  },
                  children: List.generate(months.length, (index) {
                    return Center(
                      child: Text(
                        months[index],
                        style: TextStyle(fontSize: 20.0),
                      ),
                    );
                  }),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, selectedMonth);
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey[200],
                  child: Text(
                    'OK',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (month != null) {
      setState(() {
        selectedMonth = month.toLowerCase();
      });
    }
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

  Widget _buildCardView(List<Expense> expenses) {
    List<CategoricalExpenses> categoricalExpenses =
        _getCategoricalExpensesOf(expenses);

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (1 / .5),
      padding: EdgeInsets.all(10.0),
      crossAxisSpacing: 15.0,
      mainAxisSpacing: 15.0,
      children: List.generate(categoricalExpenses.length, (index) {
        return SizedBox(
          child: _buildCard(
            context,
            categoricalExpenses[index].category,
            categoricalExpenses[index].amount.toInt(),
            categoricalExpenses[index].currency.sign,
          ),
        );
      }),
    );
  }

  List<CategoricalExpenses> _getCategoricalExpensesOf(List<Expense> expenses) {
    List<CategoricalExpenses> categoricalExpenses = [];
    expenses.forEach((expense) {
      if (expense.year == selectedYear && expense.month == selectedMonth)
        categoricalExpenses.add(CategoricalExpenses(
            expense.category, expense.value?.toInt() ?? 0, selectedCurrency));
    });
    return categoricalExpenses;
  }

  Widget _buildCard(
      BuildContext context, String title, int amount, String currency) {
    Color color = getColors(title);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        title: Text(
          capitalize(title),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '$amount $currency',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        trailing: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.3),
          ),
          child: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => increaseExpenseDialog(context),
          ),
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
