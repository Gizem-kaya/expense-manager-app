import '../database/database.dart';
import '../utils.dart';
import 'categoricalExpense.dart';
import 'monthlyExpense.dart';

class YearlyExpense {
  int year;
  List<MonthlyExpense> monthlyExpenses;

  YearlyExpense(this.year, this.monthlyExpenses);
}

List<MonthlyExpense> getSelectedYearlyExpense(
    List<YearlyExpense> yearlyExpenses, int selectedYear) {
  return yearlyExpenses
      .firstWhere((yearlyExpense) => yearlyExpense.year == selectedYear)
      .monthlyExpenses;
}

void addNewYearlyExpense(List<YearlyExpense> yearlyExpenses, Expense expense) {
  YearlyExpense newYearlyExpense = YearlyExpense(expense.year, []);

  int monthIndex = newYearlyExpense.monthlyExpenses.indexWhere(
      (monthlyExpense) =>
          expense.year == monthlyExpense.year &&
          expense.month == monthlyExpense.month);

  isItemFound(monthIndex)
      ? addCategoryToExistingMonth(newYearlyExpense, monthIndex, expense)
      : addCategoryToNonExistingYearMonth(newYearlyExpense, expense);

  yearlyExpenses.add(newYearlyExpense);
}

List<YearlyExpense> generateYearlyExpenses(List<Expense> expenses) {
  List<YearlyExpense> yearlyExpenses = [];

  expenses.forEach((expense) {
    final yearlyExpenseIndex = yearlyExpenses
        .indexWhere((yearlyExpense) => yearlyExpense.year == expense.year);

    isItemFound(yearlyExpenseIndex)
        ? addNewExpenseToYearlyExpenses(
            yearlyExpenses, yearlyExpenseIndex, expense)
        : addNewYearlyExpense(yearlyExpenses, expense);
  });

  return yearlyExpenses;
}

void addNewExpenseToYearlyExpenses(List<YearlyExpense> yearlyExpenses,
    int yearlyExpenseIndex, Expense expense) {
  int monthIndex = yearlyExpenses[yearlyExpenseIndex]
      .monthlyExpenses
      .indexWhere((monthlyExpense) =>
          expense.year == monthlyExpense.year &&
          expense.month == monthlyExpense.month);

  if (isItemFound(monthIndex)) {
    // the year and month already exist
    yearlyExpenses[yearlyExpenseIndex]
        .monthlyExpenses[monthIndex]
        .categoricalExpensesList
        .add(
          buildCategoricalExpense(expense),
        );
  } else {
    // only the year exists
    yearlyExpenses[yearlyExpenseIndex].monthlyExpenses.add(
          MonthlyExpense(
            expense.month,
            expense.year,
            [
              buildCategoricalExpense(expense),
            ],
          ),
        );
  }
}

void fillInAllTheMonthsWithZero(YearlyExpense yearlyExpense, int currentYear,
    List<CategoricalExpense> emptyCategoricalExpenses) {
  for (int monthIndex = 0; monthIndex < 12; monthIndex++) {
    yearlyExpense.monthlyExpenses[monthIndex] = MonthlyExpense(
        months[monthIndex], currentYear, emptyCategoricalExpenses);
  }
}

void addCategoryToNonExistingYearMonth(
    YearlyExpense newYearlyExpense, Expense expense) {
  return newYearlyExpense.monthlyExpenses.add(
    MonthlyExpense(
      expense.month,
      expense.year,
      [
        buildCategoricalExpense(expense),
      ],
    ),
  );
}

void addCategoryToExistingMonth(
    YearlyExpense newYearlyExpense, int monthIndex, Expense expense) {
  newYearlyExpense.monthlyExpenses[monthIndex].categoricalExpensesList.add(
    buildCategoricalExpense(expense),
  );
}
