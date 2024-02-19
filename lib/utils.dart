import 'package:flutter/material.dart';
import 'package:expense_manager/database/database.dart';
import 'package:provider/provider.dart';

void increaseExpenseDialog(BuildContext context) {
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
                  month: month,
                  year: year,
                  category: category,
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
