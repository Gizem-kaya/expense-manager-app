import 'package:expense_manager/models/categoricalExpense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../utils.dart';

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
        title: Text(capitalize(getCategoryName(context, category))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterTheAmount),
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
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              double? enteredValue =
                  double.tryParse(_textEditingController.text);
              Navigator.of(context).pop(enteredValue);
            },
            child: Text(AppLocalizations.of(context)!.add),
          ),
        ],
      );
    },
  );
}
