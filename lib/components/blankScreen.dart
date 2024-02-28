import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Center buildWaitingIndicator() {
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
}

Center buildBlankScreen(BuildContext context) {
  return Center(
      child: Text(
    "No expenses found!\n"
    "Click + button to add a new expense",
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.bodyMedium,
  ));
}
