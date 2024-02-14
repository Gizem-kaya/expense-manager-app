import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as p;
part 'database.g.dart';

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
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
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}
