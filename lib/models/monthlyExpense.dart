import 'categoricalExpense.dart';

final List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
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
