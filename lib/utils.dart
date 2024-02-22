import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expense_manager/database/database.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

Future<double?> increaseExpenseDialog(
  BuildContext context,
  String category,
  int price,
) async {
  return showDialog<double>(
    context: context,
    builder: (BuildContext context) {
      TextEditingController _textEditingController = TextEditingController();

      return AlertDialog(
        title: Text(capitalize(category)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(labelText: "Enter the amount"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                  RegExp(r'^-?\d*\.?\d*$'),
                ),
              ],
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              double? enteredValue =
                  double.tryParse(_textEditingController.text);
              Navigator.of(context).pop(enteredValue);
            },
            child: Text('ADD'),
          ),
        ],
      );
    },
  );
}

void addExpenseDialog(BuildContext context, int year, String month,
    String category, double expense) {
  TextEditingController expenseController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      late AppDatabase database;
      database = Provider.of<AppDatabase>(context);
      return AlertDialog(
        title: Text('Add an expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: expenseController,
              decoration: InputDecoration(labelText: 'Expense'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              double newExpense =
                  double.tryParse(expenseController.text) ?? 0.0;
              if (newExpense != 0.0) {
                Expense newExpenseObject = Expense(
                  month: month.toLowerCase(),
                  year: year,
                  category: category.toLowerCase(),
                  value: newExpense,
                );

                database.insertNewExpense(newExpenseObject).then((value) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Expense added successfully')),
                  );
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add expense: $error')),
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Please enter a valid expense amount')),
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}

String getAbbreviation(String longMonthName) {
  switch (longMonthName) {
    case 'january':
      return 'JAN';
    case 'february':
      return 'FEB';
    case 'march':
      return 'MAR';
    case 'april':
      return 'APR';
    case 'may':
      return 'MAY';
    case 'june':
      return 'JUN';
    case 'july':
      return 'JUL';
    case 'august':
      return 'AUG';
    case 'september':
      return 'SEP';
    case 'october':
      return 'OCT';
    case 'november':
      return 'NOV';
    case 'december':
      return 'DEC';
    default:
      throw Exception('Month name is not correct!');
  }
}

String capitalize(String text) {
  return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
}

Color getColors(String text) {
  switch (text) {
    case 'food':
      return Color(0xFFFFB74D);
    case 'gwe':
      return const Color(0xFFFFD54F);
    case 'transportation':
      return const Color(0xFF81C784);
    case 'rent':
      return const Color(0xFFE57373);
    case 'activities':
      return const Color(0xFF64B5F6);
    case 'insurances':
      return const Color(0xFF9575CD);
    default:
      return Colors.blue;
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
