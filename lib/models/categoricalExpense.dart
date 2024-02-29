import 'package:flutter/cupertino.dart';

import '../database/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final List<String> categories = [
  'food',
  'transportation',
  'gwe',
  'rent',
  'insurances',
  'activities',
];

class CategoricalExpense {
  final String category;
  final int amount;

  CategoricalExpense(this.category, this.amount);
}

CategoricalExpense buildCategoricalExpense(Expense expense) {
  return CategoricalExpense(expense.category, expense.value!.toInt());
}

String getCategoryName(BuildContext context, String categoryName) {
  switch (categoryName) {
    case 'food':
      return AppLocalizations.of(context)!.food;
    case 'transportation':
      return AppLocalizations.of(context)!.transportation;
    case 'gwe':
      return AppLocalizations.of(context)!.gwe;
    case 'rent':
      return AppLocalizations.of(context)!.rent;
    case 'insurances':
      return AppLocalizations.of(context)!.insurances;
    case 'activities':
      return AppLocalizations.of(context)!.activities;
    default:
      throw Exception('Category name is not correct!');
  }
}
