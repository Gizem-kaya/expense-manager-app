import 'package:expense_manager/database/database.dart';
import 'package:expense_manager/models/categoricalExpense.dart';
import 'package:expense_manager/models/yearlyExpense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/monthlyExpense.dart';
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
  int renders = 0;
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
              addNewYearDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Expense>>(
        future: _getExpensesFromDatabase(database),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting for fetching data from database...");
            return Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  value: null,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            print("The database has an error!");
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            print("No data in the database!");
            return Center(child: Text('No data'));
          } else {
            List<Expense>? expenses = snapshot.data;
            if (expenses != null && expenses.isNotEmpty) {
              List<YearlyExpense> yearlyExpenses =
                  _generateYearlyExpenses(expenses);

              try {
                selectedYear;
              } catch (e) {
                selectedYear = _getMaxYear(yearlyExpenses);
              }

              List<MonthlyExpense> selectedMonthlyExpense = yearlyExpenses
                  .firstWhere(
                      (yearlyExpense) => yearlyExpense.year == selectedYear)
                  .monthlyExpenses;

              return Column(
                children: [
                  _buildGraph(yearlyExpenses, selectedMonthlyExpense),
                  _buildCardContainer(selectedMonthlyExpense),
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

  List<YearlyExpense> _generateYearlyExpenses(List<Expense> expenses) {
    List<YearlyExpense> yearlyExpenses = [];

    expenses.forEach((expense) {
      final yearlyExpenseIndex = yearlyExpenses
          .indexWhere((yearlyExpense) => yearlyExpense.year == expense.year);

      if (isItemFound(yearlyExpenseIndex)) {
        addNewExpenseToYearlyExpenses(
            yearlyExpenses, yearlyExpenseIndex, expense);
      } else {
        addNewYearlyExpense(yearlyExpenses, expense);
      }
    });

    return yearlyExpenses;
  }

  Widget _buildCardContainer(List<MonthlyExpense> monthlyExpenses) {
    return Expanded(
        child: Container(
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
            child: _buildCardView(monthlyExpenses),
          ),
        ],
      ),
    ));
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
                  scrollController: FixedExtentScrollController(
                      initialItem: months.indexOf(capitalize(selectedMonth))),
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

  Widget _buildGraph(List<YearlyExpense> yearlyExpenses,
      List<MonthlyExpense> monthlyExpenses) {
    int yearIndex =
        yearlyExpenses.indexWhere((expense) => expense.year == selectedYear);
    int previousYear = -1;
    int nextYear = -1;

    try {
      previousYear = yearlyExpenses[yearIndex - 1].year;
    } catch (e) {}
    try {
      nextYear = yearlyExpenses[yearIndex + 1].year;
    } catch (e) {}

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 20, 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  child: Visibility(
                      visible: previousYear > 0,
                      child: TextButton(
                        child: Text(
                          '<',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedYear = previousYear;
                          });
                        },
                      )),
                ),
                Text(
                  selectedYear.toString(),
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  width: 30,
                  child: Visibility(
                      visible: nextYear > 0,
                      child: TextButton(
                        child: Text(
                          '>',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            selectedYear = nextYear;
                          });
                        },
                      )),
                ),
              ],
            ),
            const SizedBox(),
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
                              if (index >= 0 &&
                                  index < monthlyExpenses.length) {
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
      ),
    );
  }

  Widget _buildCardView(List<MonthlyExpense> monthlyExpenses) {
    List<CategoricalExpense> categoricalExpenses =
        _getCategoricalExpensesOf(monthlyExpenses);

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

  List<CategoricalExpense> _getCategoricalExpensesOf(
      List<MonthlyExpense> monthlyExpenses) {
    return monthlyExpenses
        .firstWhere((expense) => (expense.month == selectedMonth))
        .categoricalExpensesList;
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
            onPressed: () async {
              double? enteredValue =
                  await increaseExpenseDialog(context, title, amount);
              double updatedValue = enteredValue != null
                  ? (amount + enteredValue).toDouble()
                  : -1;
              if (updatedValue >= 0) {
                database
                    .updateExpense(Expense(
                        year: selectedYear,
                        month: selectedMonth,
                        category: title,
                        value: updatedValue))
                    .then((value) => setState(() {}));
              } else {
                final snackBar = SnackBar(
                  content: const Text('You can not go under zero!'),
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {},
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
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

  void addNewExpenseToYearlyExpenses(List<YearlyExpense> yearlyExpenses,
      int yearlyExpenseIndex, Expense expense) {
    int monthIndex = yearlyExpenses[yearlyExpenseIndex]
        .monthlyExpenses
        .indexWhere((monthlyExpense) =>
            expense.year == monthlyExpense.year &&
            expense.month == monthlyExpense.month);

    if (isItemFound(monthIndex)) {
      // the year and month already exist
      yearlyExpenses[yearlyExpenseIndex]
          .monthlyExpenses[monthIndex]
          .categoricalExpensesList
          .add(
            CategoricalExpense(
              expense.category,
              expense.value!.toInt(),
              Currency.Euro,
            ),
          );
    } else {
      // only the year exists
      yearlyExpenses[yearlyExpenseIndex].monthlyExpenses.add(
            MonthlyExpense(
              expense.month,
              expense.year,
              [
                CategoricalExpense(
                  expense.category,
                  expense.value!.toInt(),
                  Currency.Euro,
                ),
              ],
            ),
          );
    }
  }

  void addNewYearlyExpense(
      List<YearlyExpense> yearlyExpenses, Expense expense) {
    YearlyExpense newYearlyExpense = YearlyExpense(expense.year, []);

    int monthIndex = newYearlyExpense.monthlyExpenses.indexWhere(
        (monthlyExpense) =>
            expense.year == monthlyExpense.year &&
            expense.month == monthlyExpense.month);

    if (isItemFound(monthIndex)) {
      // only the month exists
      newYearlyExpense.monthlyExpenses[monthIndex].categoricalExpensesList.add(
        CategoricalExpense(
          expense.category,
          expense.value!.toInt(),
          Currency.Euro,
        ),
      );
    } else {
      newYearlyExpense.monthlyExpenses.add(
        // the year and month don't exist
        MonthlyExpense(
          expense.month,
          expense.year,
          [
            CategoricalExpense(
              expense.category,
              expense.value!.toInt(),
              Currency.Euro,
            ),
          ],
        ),
      );
    }
    yearlyExpenses.add(newYearlyExpense);
  }

  void fillInTheBlankData(List<YearlyExpense> yearlyExpenses) {
    List<CategoricalExpense> emptyCategoricalExpenses = [
      CategoricalExpense('food', 0, selectedCurrency),
      CategoricalExpense('transportation', 0, selectedCurrency),
      CategoricalExpense('gwe', 0, selectedCurrency),
      CategoricalExpense('rent', 0, selectedCurrency),
      CategoricalExpense('insurances', 0, selectedCurrency),
      CategoricalExpense('activities', 0, selectedCurrency)
    ];

    yearlyExpenses.forEach((yearlyExpense) {
      int currentYear = yearlyExpense.year;
      if (yearlyExpense.monthlyExpenses.length < 12) {
        for (int monthIndex = 0; monthIndex < 12; monthIndex++) {
          yearlyExpense.monthlyExpenses[monthIndex] = MonthlyExpense(
              months[monthIndex], currentYear, emptyCategoricalExpenses);
        }
      }
    });
  }
}

int _getMaxYear(List<YearlyExpense> yearlyExpenses) {
  int maxYear = 0;
  yearlyExpenses.forEach((expense) {
    if (expense.year > maxYear) maxYear = expense.year;
  });
  return maxYear;
}
