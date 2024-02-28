import '../database/database.dart';

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
