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
  Stream<List<Expense>> watchAllExpenses() => select(expenses).watch();
  Future insertNewExpense(Expense expense) async =>
      await into(expenses).insert(expense);
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
