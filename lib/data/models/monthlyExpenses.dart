import 'categoricalExpenses.dart';

class MonthlyExpenses {
  final String column;
  List<CategoricalExpenses> categoricalExpensesList;

  MonthlyExpenses(this.column, this.categoricalExpensesList);
  getTotalExpense() {
    double total = 0;
    for (var e in categoricalExpensesList) {
      total += e.amount;
    }
    return total;
  }
}
