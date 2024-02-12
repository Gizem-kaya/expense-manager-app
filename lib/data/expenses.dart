import 'package:moor_flutter/moor_flutter.dart';
part 'expenses.g.dart';

@DataClassName("Expense")
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get year => integer()();
  TextColumn get month => text()();
  TextColumn get category => text()();
  RealColumn get value => real()();
}

@UseMoor(tables: [Expenses])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: "db.sqlite", logStatements: true));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) {
          return m.createAll();
        },
      );

  Future<List<Expense>> getAllExpenses() => select(expenses).get();
  Stream<List<Expense>> watchAllExpenses() => select(expenses).watch();
  Future insertNewExpense(Expense expense) => into(expenses).insert(expense);
  Future deleteExpense(Expense expense) => delete(expenses).delete(expense);

  Future<List<Expense>> getExpensesFromSpecificYear(int year) =>
      (select(expenses)..where((t) => t.year.equals(year))).get();

  Future<List<Expense>> getExpensesFromSpecificMonth(String month) =>
      (select(expenses)..where((t) => t.month.equals(month))).get();

  Future<List<Expense>> getExpensesFromSpecificCategory(String category) =>
      (select(expenses)..where((t) => t.category.equals(category))).get();

  Future<List<Expense>> getExpensesFromSpecificYearAndMonth(
          int year, String month) =>
      (select(expenses)
            ..where((t) => t.year.equals(year))
            ..where((t) => t.month.equals(month)))
          .get();

  Future<List<Expense>> getExpensesFromSpecificYearMonthAndCategory(
          int year, String month, String category) =>
      (select(expenses)
            ..where((t) => t.year.equals(year))
            ..where((t) => t.month.equals(month))
            ..where((t) => t.category.equals(category)))
          .get();
}
