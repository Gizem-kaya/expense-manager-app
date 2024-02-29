import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/categoricalExpense.dart';
import '../utils.dart';

Text buildCardTitle(BuildContext context, String title) {
  return Text(
    capitalize(getCategoryName(context, title)),
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
      color: Colors.white,
    ),
    overflow: TextOverflow.ellipsis,
  );
}

Text buildCardSubTitle(BuildContext context, int amount) {
  return Text(
    '$amount ' + AppLocalizations.of(context)!.currency,
    style: TextStyle(
      fontSize: 18,
      color: Colors.white70,
    ),
  );
}
