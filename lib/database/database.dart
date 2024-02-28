import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_sqflite/drift_sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
part 'database.g.dart';

class Expenses extends Table {
  IntColumn get year => integer()();
  TextColumn get month => text()();
  TextColumn get category => text()();
  RealColumn get value => real().nullable()();
}

@DriftDatabase(tables: [Expenses])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Expense>> getAllExpenses() async => await select(expenses).get();
  Future<List<Expense>> getAllSortedByColumn(String columnName) async {
    return (select(expenses)
          ..orderBy([
            (t) => OrderingTerm(expression: expenses.year),
          ]))
        .get();
  }

  Stream<List<Expense>> watchAllExpenses() => select(expenses).watch();
  Future insertNewExpense(Expense expense) async {
    // Check if the combination of year, month, and category already exists
    final existingExpense = await (select(expenses)
          ..where((t) =>
              t.year.equals(expense.year) &
              t.month.equals(expense.month) &
              t.category.equals(expense.category)))
        .getSingleOrNull();

    // If the combination already exists, return an error or handle it accordingly
    if (existingExpense != null) {
      throw Exception(
          'An expense with the same year, month, and category already exists.');
    }

    // Otherwise, insert the new expense
    await into(expenses).insert(expense);
  }

  Future<void> insertListOfExpenses(List<Expense> expensesList) async {
    await batch((batch) {
      for (final expense in expensesList) {
        batch.insert(expenses, expense);
      }
    });
  }

  Future updateExpense(Expense updatedExpense) async {
    // Check if the expense exists
    final existingExpense = await (select(expenses)
          ..where((t) =>
              t.year.equals(updatedExpense.year) &
              t.month.equals(updatedExpense.month) &
              t.category.equals(updatedExpense.category)))
        .getSingleOrNull();

    // If the expense does not exist, throw an error or handle it accordingly
    if (existingExpense == null) {
      throw Exception('Expense does not exist.');
    }

    // Update the expense
    await (update(expenses)
          ..where((t) =>
              t.year.equals(updatedExpense.year) &
              t.month.equals(updatedExpense.month) &
              t.category.equals(updatedExpense.category)))
        .write(updatedExpense);
  }

  Future deleteExpense(Expense expense) async =>
      await delete(expenses).delete(expense);

  Future<List<Expense>> getExpensesFromSpecificYear(int year) async =>
      await (select(expenses)..where((t) => t.year.equals(year))).get();

  Future<List<Expense>> getExpensesFromSpecificMonth(String month) async =>
      await (select(expenses)..where((t) => t.month.equals(month))).get();

  Future<List<Expense>> getExpensesFromSpecificCategory(
          String category) async =>
      await (select(expenses)..where((t) => t.category.equals(category))).get();

  Future<List<Expense>> getExpensesFromSpecificYearAndMonth(
          int year, String month) async =>
      await (select(expenses)
            ..where((t) => t.year.equals(year))
            ..where((t) => t.month.equals(month)))
          .get();

  Future<List<Expense>> getExpensesFromSpecificYearMonthAndCategory(
          int year, String month, String category) async =>
      await (select(expenses)
            ..where((t) => t.year.equals(year))
            ..where((t) => t.month.equals(month))
            ..where((t) => t.category.equals(category)))
          .get();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getDatabasesPath();
    final file = File(p.join(dbFolder, 'db.sqlite'));

    if (Platform.isAndroid) {
      return SqfliteQueryExecutor.inDatabaseFolder(path: 'db.sqlite');
    } else {
      return NativeDatabase(file);
    }
  });
}
