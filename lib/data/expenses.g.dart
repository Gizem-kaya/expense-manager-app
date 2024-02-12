// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenses.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int year;
  final String month;
  final String category;
  final double value;
  Expense(
      {required this.id,
      required this.year,
      required this.month,
      required this.category,
      required this.value});
  factory Expense.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Expense(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      year: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}year'])!,
      month: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}month'])!,
      category: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}category'])!,
      value: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}value'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<String>(month);
    map['category'] = Variable<String>(category);
    map['value'] = Variable<double>(value);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      category: Value(category),
      value: Value(value),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<String>(json['month']),
      category: serializer.fromJson<String>(json['category']),
      value: serializer.fromJson<double>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<String>(month),
      'category': serializer.toJson<String>(category),
      'value': serializer.toJson<double>(value),
    };
  }

  Expense copyWith(
          {int? id,
          int? year,
          String? month,
          String? category,
          double? value}) =>
      Expense(
        id: id ?? this.id,
        year: year ?? this.year,
        month: month ?? this.month,
        category: category ?? this.category,
        value: value ?? this.value,
      );
  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('category: $category, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, year, month, category, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.year == this.year &&
          other.month == this.month &&
          other.category == this.category &&
          other.value == this.value);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<int> year;
  final Value<String> month;
  final Value<String> category;
  final Value<double> value;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.category = const Value.absent(),
    this.value = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int year,
    required String month,
    required String category,
    required double value,
  })  : year = Value(year),
        month = Value(month),
        category = Value(category),
        value = Value(value);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<int>? year,
    Expression<String>? month,
    Expression<String>? category,
    Expression<double>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (category != null) 'category': category,
      if (value != null) 'value': value,
    });
  }

  ExpensesCompanion copyWith(
      {Value<int>? id,
      Value<int>? year,
      Value<String>? month,
      Value<String>? category,
      Value<double>? value}) {
    return ExpensesCompanion(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      category: category ?? this.category,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('category: $category, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int?> year = GeneratedColumn<int?>(
      'year', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String?> month = GeneratedColumn<String?>(
      'month', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  @override
  late final GeneratedColumn<String?> category = GeneratedColumn<String?>(
      'category', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double?> value = GeneratedColumn<double?>(
      'value', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, year, month, category, value];
  @override
  String get aliasedName => _alias ?? 'expenses';
  @override
  String get actualTableName => 'expenses';
  @override
  VerificationContext validateIntegrity(Insertable<Expense> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('month')) {
      context.handle(
          _monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Expense.fromData(data, attachedDatabase,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [expenses];
}
