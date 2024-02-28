import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/monthlyExpense.dart';

Container buildOkButton() {
  return Container(
    padding: EdgeInsets.all(16.0),
    color: Colors.grey[200],
    child: Text(
      'OK',
      style: TextStyle(fontSize: 20.0),
    ),
  );
}

List<Widget> generateCupertinoList() {
  return List.generate(months.length, (index) {
    return Center(
      child: Text(
        months[index],
        style: TextStyle(fontSize: 20.0),
      ),
    );
  });
}
