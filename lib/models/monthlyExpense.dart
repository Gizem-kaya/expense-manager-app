import 'categoricalExpense.dart';

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
