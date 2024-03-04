import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../l10n/languageCodes.dart';
import '../../models/monthlyExpense.dart';

Container buildOkButton(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.0),
    color: Colors.grey[200],
    child: Text(
      AppLocalizations.of(context)!.ok,
      style: TextStyle(fontSize: 20.0),
    ),
  );
}

List<Widget> generateMonthCupertinoList(BuildContext context) {
  return List.generate(months.length, (index) {
    return Center(
      child: Text(
        getSelectedMonthTitle(context, months[index]),
        style: TextStyle(fontSize: 20.0),
      ),
    );
  });
}
