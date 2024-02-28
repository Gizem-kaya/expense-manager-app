import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../models/categoricalExpense.dart';
import '../../models/monthlyExpense.dart';

Future<void> addNewYearDialog(BuildContext context) async {
  TextEditingController yearController = TextEditingController();
  Completer<void> completer = Completer<void>(); // Create a Completer

  await showDialog(
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
              controller: yearController,
              decoration: InputDecoration(labelText: 'Year'),
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
            onPressed: () async {
              int? selectedYear = int.tryParse(yearController.text);
              if (selectedYear == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a valid year')),
                );
              } else {
                List<Expense> expenses = [];
                months.forEach((month) {
                  categories.forEach((category) {
                    expenses.add(Expense(
                      month: month.toLowerCase(),
                      year: selectedYear,
                      category: category.toLowerCase(),
                      value: 0.0,
                    ));
                  });
                });

                try {
                  await database.insertListOfExpenses(expenses);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Expense added successfully')),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add expense: $error')),
                  );
                } finally {
                  completer.complete(); // Complete the Future when done
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );

  return completer.future; // Return the Future
}
