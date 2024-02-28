import 'database.dart';

Future<List<Expense>> getExpensesFromDatabase(AppDatabase database) async {
  return await database.getAllSortedByColumn('year');
}
