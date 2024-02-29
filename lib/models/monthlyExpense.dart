import 'package:flutter/cupertino.dart';

import 'categoricalExpense.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final List<String> months = [
  'january',
  'february',
  'march',
  'april',
  'may',
  'june',
  'july',
  'august',
  'september',
  'october',
  'november',
  'december',
];

class MonthlyExpense {
  final String month;
  final int year;
  List<CategoricalExpense> categoricalExpensesList;

  MonthlyExpense(this.month, this.year, this.categoricalExpensesList);

  getTotalExpense() {
    double total = 0;
    for (var e in categoricalExpensesList) {
      total += e.amount;
    }
    return total;
  }
}

List<CategoricalExpense> getCategoricalExpensesOf(
    List<MonthlyExpense> monthlyExpenses, String selectedMonth) {
  return monthlyExpenses
      .firstWhere((expense) => (expense.month == selectedMonth))
      .categoricalExpensesList;
}

String getSelectedMonthTitle(BuildContext context, String selectedMonth) {
  switch (selectedMonth) {
    case 'january':
      return AppLocalizations.of(context)!.january;
    case 'february':
      return AppLocalizations.of(context)!.february;
    case 'march':
      return AppLocalizations.of(context)!.march;
    case 'april':
      return AppLocalizations.of(context)!.april;
    case 'may':
      return AppLocalizations.of(context)!.may;
    case 'june':
      return AppLocalizations.of(context)!.june;
    case 'july':
      return AppLocalizations.of(context)!.july;
    case 'august':
      return AppLocalizations.of(context)!.august;
    case 'september':
      return AppLocalizations.of(context)!.september;
    case 'october':
      return AppLocalizations.of(context)!.october;
    case 'november':
      return AppLocalizations.of(context)!.november;
    case 'december':
      return AppLocalizations.of(context)!.december;
    default:
      return AppLocalizations.of(context)!.error;
  }
}
