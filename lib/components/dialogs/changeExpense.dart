import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
