import 'models/categoricalExpense.dart';
import 'models/monthlyExpense.dart';
import 'models/yearlyExpense.dart';

String capitalize(String text) {
  return "${text[0].toUpperCase()}${text.substring(1).toLowerCase()}";
}

bool isItemFound(int index) {
  return index != -1;
}

int getMaxYear(List<YearlyExpense> yearlyExpenses) {
  int maxYear = 0;
  yearlyExpenses.forEach((expense) {
    if (expense.year > maxYear) maxYear = expense.year;
  });
  return maxYear;
}

getMaxY(List<MonthlyExpense> monthlyExpenses) {
  monthlyExpenses
          .map((monthlyExpense) => monthlyExpense.getTotalExpense())
          .reduce((value, element) => value > element ? value : element) +
      300;
}

void fillInTheBlankData(List<YearlyExpense> yearlyExpenses) {
  List<CategoricalExpense> emptyCategoricalExpenses = [
    CategoricalExpense('food', 0),
    CategoricalExpense('transportation', 0),
    CategoricalExpense('gwe', 0),
    CategoricalExpense('rent', 0),
    CategoricalExpense('insurances', 0),
    CategoricalExpense('activities', 0)
  ];

  yearlyExpenses.forEach((yearlyExpense) {
    int currentYear = yearlyExpense.year;
    if (yearlyExpense.monthlyExpenses.length < 12) {
      fillInAllTheMonthsWithZero(
          yearlyExpense, currentYear, emptyCategoricalExpenses);
    }
  });
}
