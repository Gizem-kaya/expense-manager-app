import 'package:expense_manager/components/dialogs/popups.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/languageCodes.dart';
import '../../main.dart';

void showLanguagePickerDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 300.0,
        child: _buildCupertinoLanguagePicker(context),
      );
    },
  );
}

_buildCupertinoLanguagePicker(BuildContext context) {
  int _index = MyApp.of(context)?.locale.languageCode == 'tr' ? 0 : 1;
  return Column(
    children: [
      Expanded(
        child: CupertinoPicker(
          itemExtent: 40.0,
          scrollController: FixedExtentScrollController(initialItem: _index),
          onSelectedItemChanged: (int index) {
            _index = index;
          },
          children: generateLanguagesCupertinoList(context),
        ),
      ),
      GestureDetector(
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          Navigator.pop(context, _index);
          if (_index == 0) {
            MyApp.of(context)?.setLocale(Locale('tr'));
            await prefs.setString('languageCode', 'tr');
          } else if (_index == 1) {
            MyApp.of(context)?.setLocale(Locale('en'));
            await prefs.setString('languageCode', 'en');
          }
        },
        child: buildOkButton(context),
      ),
    ],
  );
}

List<Widget> generateLanguagesCupertinoList(BuildContext context) {
  return List<Widget>.generate(getLanguages(context).length, (index) {
    return Center(
      child: Text(
        getLanguages(context)[index],
        style: TextStyle(fontSize: 20.0),
      ),
    );
  });
}
