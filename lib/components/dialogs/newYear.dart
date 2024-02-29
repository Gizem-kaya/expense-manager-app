import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import '../../models/categoricalExpense.dart';
import '../../models/monthlyExpense.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> addNewYearDialog(BuildContext context) async {
  TextEditingController yearController = TextEditingController();
  Completer<void> completer = Completer<void>(); // Create a Completer

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      late AppDatabase database;
      database = Provider.of<AppDatabase>(context);
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.addYear),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: yearController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.year),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              int? selectedYear = int.tryParse(yearController.text);
              if (selectedYear == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(AppLocalizations.of(context)!.invalidYear)),
                );
              } else {
                List<Expense> expenses = [];
                months.forEach((month) {
                  categories.forEach((category) {
                    expenses.add(Expense(
                      month: month,
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
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      );
    },
  );

  return completer.future; // Return the Future
}
