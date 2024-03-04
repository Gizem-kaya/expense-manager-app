import 'package:expense_manager/components/dialogs/popups.dart';
import 'package:expense_manager/database/database.dart';
import 'package:expense_manager/models/categoricalExpense.dart';
import 'package:expense_manager/models/yearlyExpense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../database/utils.dart';
import '../models/monthlyExpense.dart';
import '../utils.dart';
import 'blankScreen.dart';
import 'card.dart';
import 'dialogs/changeExpense.dart';
import 'dialogs/changeLanguage.dart';
import 'dialogs/newYear.dart';
import 'graph.dart';

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
  int rerenderingRequired = 0;

  @override
  void initState() {
    super.initState();
    selectedMonth = 'january';
  }

  @override
  Widget build(BuildContext context) {
    database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.app_name),
        actions: [
          _buildAddYearButton(context),
          _buildMoreButton(),
        ],
      ),
      body: FutureBuilder<List<Expense>>(
        future: getExpensesFromDatabase(database),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting for fetching data from database...");
            return buildWaitingIndicator();
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
                  generateYearlyExpenses(expenses);

              _getSelectedYear(yearlyExpenses);

              List<MonthlyExpense> selectedMonthlyExpense =
                  getSelectedYearlyExpense(yearlyExpenses, selectedYear);

              return _buildMainScreen(yearlyExpenses, selectedMonthlyExpense);
            } else {
              return buildBlankScreen(context);
            }
          }
        },
      ),
    );
  }

  Column _buildMainScreen(List<YearlyExpense> yearlyExpenses,
      List<MonthlyExpense> selectedMonthlyExpense) {
    return Column(
      children: [
        _buildGraphContainer(yearlyExpenses, selectedMonthlyExpense),
        _buildCardContainer(selectedMonthlyExpense),
      ],
    );
  }

  Widget _buildGraphContainer(List<YearlyExpense> yearlyExpenses,
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
            _buildYearInGraph(previousYear, nextYear),
            SizedBox(height: 10),
            buildGraph(context, monthlyExpenses),
          ],
        ),
      ),
    );
  }

  Row _buildYearInGraph(int previousYear, int nextYear) {
    return Row(
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
    );
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
      child: _buildCardText(monthlyExpenses),
    ));
  }

  Widget _buildCardView(List<MonthlyExpense> monthlyExpenses) {
    List<CategoricalExpense> categoricalExpenses =
        getCategoricalExpensesOf(monthlyExpenses, selectedMonth);

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (1 / .5),
      padding: EdgeInsets.all(10.0),
      crossAxisSpacing: 15.0,
      mainAxisSpacing: 15.0,
      children: List.generate(categoricalExpenses.length, (index) {
        Color color = getColors(categoricalExpenses[index].category);
        return SizedBox(
          child: _buildCard(context, categoricalExpenses[index].category,
              categoricalExpenses[index].amount.toInt(), color),
        );
      }),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, int amount, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        title: buildCardTitle(context, title),
        subtitle: buildCardSubTitle(context, amount),
        trailing: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.3),
          ),
          child: _buildAddExpenseButton(context, title, amount),
        ),
      ),
    );
  }

  IconButton _buildAddExpenseButton(
      BuildContext context, String title, int amount) {
    return IconButton(
      icon: Icon(
        Icons.add,
        color: Colors.white,
        size: 20,
      ),
      onPressed: () async {
        double? enteredValue =
            await increaseExpenseDialog(context, title, amount);
        double updatedValue =
            enteredValue != null ? (amount + enteredValue).toDouble() : -1;
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
            content: Text(AppLocalizations.of(context)!.notValidAmount),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.ok,
              onPressed: () {},
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
  }

  Column _buildCardText(List<MonthlyExpense> monthlyExpenses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            _showMonthPicker(context);
          },
          child:
              Text(capitalize(getSelectedMonthTitle(context, selectedMonth))),
        ),
        Expanded(
          flex: 1,
          child: _buildCardView(monthlyExpenses),
        ),
      ],
    );
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    String _selectedMonth = selectedMonth;
    final String? month = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          child: _buildCupertinoMonthPicker(_selectedMonth, context),
        );
      },
    );

    if (month != null) {
      setState(() {
        selectedMonth = month.toLowerCase();
      });
    }
  }

  Column _buildCupertinoMonthPicker(
      String _selectedMonth, BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CupertinoPicker(
            itemExtent: 40.0,
            scrollController: FixedExtentScrollController(
                initialItem: months.indexOf(selectedMonth)),
            onSelectedItemChanged: (int index) {
              _selectedMonth = months[index];
            },
            children: generateMonthCupertinoList(context),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              selectedMonth = _selectedMonth;
            });
            Navigator.pop(context, selectedMonth);
          },
          child: buildOkButton(context),
        ),
      ],
    );
  }

  PopupMenuButton _buildMoreButton() {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: '1',
          child: Text(AppLocalizations.of(context)!.languages),
        ),
        PopupMenuItem(
          value: '2',
          child: Text(AppLocalizations.of(context)!.about),
        )
      ],
      onSelected: (String value) {
        switch (value) {
          case '1':
            showLanguagePickerDialog(context);
            break;
          case '2':
            showAboutDialog(
                context: context,
                applicationName: AppLocalizations.of(context)!.app_name,
                applicationLegalese:
                    'Copyright © 2024 Gizem Keskin. All Rights Reserved.');
            break;
        }
      },
    );
  }

  IconButton _buildAddYearButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        print('Add button pressed');
        addNewYearDialog(context).then((value) => setState(() {
              rerenderingRequired++;
            }));
      },
    );
  }

  void _getSelectedYear(List<YearlyExpense> yearlyExpenses) {
    try {
      selectedYear;
    } catch (e) {
      selectedYear = getMaxYear(yearlyExpenses);
    }
  }
}
