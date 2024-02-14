import 'categoricalExpenses.dart';

class MonthlyExpenses {
  final String month;
  final int year;
  List<CategoricalExpenses> categoricalExpensesList;

  MonthlyExpenses(this.month, this.year, this.categoricalExpensesList);

  getTotalExpense() {
    double total = 0;
    for (var e in categoricalExpensesList) {
      total += e.amount;
    }
    return total;
  }
}
