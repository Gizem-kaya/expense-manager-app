// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
      'month', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
      'value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, year, month, category, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
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
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      month: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}month'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}value']),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int year;
  final String month;
  final String category;
  final double? value;
  const Expense(
      {required this.id,
      required this.year,
      required this.month,
      required this.category,
      this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['year'] = Variable<int>(year);
    map['month'] = Variable<String>(month);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<double>(value);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      year: Value(year),
      month: Value(month),
      category: Value(category),
      value:
          value == null && nullToAbsent ? const Value.absent() : Value(value),
    );
  }

  factory Expense.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      year: serializer.fromJson<int>(json['year']),
      month: serializer.fromJson<String>(json['month']),
      category: serializer.fromJson<String>(json['category']),
      value: serializer.fromJson<double?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'year': serializer.toJson<int>(year),
      'month': serializer.toJson<String>(month),
      'category': serializer.toJson<String>(category),
      'value': serializer.toJson<double?>(value),
    };
  }

  Expense copyWith(
          {int? id,
          int? year,
          String? month,
          String? category,
          Value<double?> value = const Value.absent()}) =>
      Expense(
        id: id ?? this.id,
        year: year ?? this.year,
        month: month ?? this.month,
        category: category ?? this.category,
        value: value.present ? value.value : this.value,
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
  final Value<double?> value;
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
    this.value = const Value.absent(),
  })  : year = Value(year),
        month = Value(month),
        category = Value(category);
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
      Value<double?>? value}) {
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [expenses];
}
