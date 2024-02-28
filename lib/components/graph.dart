import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/monthlyExpense.dart';
import '../utils.dart';

AspectRatio buildGraph(List<MonthlyExpense> monthlyExpenses) {
  return AspectRatio(
    aspectRatio: 1.1,
    child: Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(enabled: false),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(show: false),
              maxY: getMaxY(monthlyExpenses),
              titlesData: buildTitlesData(monthlyExpenses),
              barGroups: generateBarGroups(monthlyExpenses),
            ),
          ),
        ),
      ],
    ),
  );
}

FlTitlesData buildTitlesData(List<MonthlyExpense> monthlyExpenses) {
  return FlTitlesData(
    bottomTitles: SideTitles(
      showTitles: true,
      reservedSize: 20,
      getTextStyles: (context, value) =>
          const TextStyle(color: Colors.black38, fontSize: 11),
      margin: 10,
      getTitles: (double value) {
        int index = value.toInt();
        if (index >= 0 && index < monthlyExpenses.length) {
          return getAbbreviation(monthlyExpenses[index].month);
        }
        return 'error';
      },
    ),
    leftTitles: SideTitles(
      showTitles: true,
      reservedSize: 20,
      getTextStyles: (context, value) =>
          const TextStyle(color: Colors.black38, fontSize: 11),
      margin: 7,
    ),
    topTitles: SideTitles(showTitles: false),
    rightTitles: SideTitles(showTitles: false),
  );
}

List<BarChartGroupData> generateBarGroups(
    List<MonthlyExpense> monthlyExpenses) {
  return List.generate(
    monthlyExpenses.length,
    (index) => generateGroupData(
      index,
      monthlyExpenses[index].categoricalExpensesList[0].amount.toDouble(),
      monthlyExpenses[index].categoricalExpensesList[1].amount.toDouble(),
      monthlyExpenses[index].categoricalExpensesList[2].amount.toDouble(),
      monthlyExpenses[index].categoricalExpensesList[3].amount.toDouble(),
      monthlyExpenses[index].categoricalExpensesList[4].amount.toDouble(),
      monthlyExpenses[index].categoricalExpensesList[5].amount.toDouble(),
    ),
  );
}

BarChartGroupData generateGroupData(
  int x,
  double food,
  double transportation,
  double gwe,
  double rent,
  double activities,
  double insurances,
) {
  final betweenSpace = 0.3;

  return BarChartGroupData(
    x: x,
    groupVertically: true,
    barRods: [
      BarChartRodData(
        fromY: 0,
        toY: rent,
        colors: [const Color(0xFFE57373)],
        width: 8,
      ),
      BarChartRodData(
        fromY: rent + betweenSpace,
        toY: rent + betweenSpace + food,
        colors: [const Color(0xFFFFB74D)],
        width: 8,
      ),
      BarChartRodData(
        fromY: rent + betweenSpace + food + betweenSpace,
        toY: rent + betweenSpace + food + betweenSpace + gwe,
        colors: [const Color(0xFFFFD54F)],
        width: 8,
      ),
      BarChartRodData(
        fromY: rent + betweenSpace + food + betweenSpace + gwe + betweenSpace,
        toY: rent +
            betweenSpace +
            food +
            betweenSpace +
            gwe +
            betweenSpace +
            transportation,
        colors: [const Color(0xFF81C784)],
        width: 8,
      ),
      BarChartRodData(
        fromY: rent +
            betweenSpace +
            food +
            betweenSpace +
            gwe +
            betweenSpace +
            transportation +
            betweenSpace,
        toY: rent +
            betweenSpace +
            food +
            betweenSpace +
            gwe +
            betweenSpace +
            transportation +
            betweenSpace +
            insurances,
        colors: [const Color(0xFF64B5F6)],
        width: 8,
      ),
      BarChartRodData(
        fromY: rent +
            betweenSpace +
            food +
            betweenSpace +
            gwe +
            betweenSpace +
            transportation +
            betweenSpace +
            insurances +
            betweenSpace,
        toY: rent +
            betweenSpace +
            food +
            betweenSpace +
            gwe +
            betweenSpace +
            transportation +
            betweenSpace +
            insurances +
            betweenSpace +
            activities,
        colors: [const Color(0xFF9575CD)],
        width: 8,
      ),
    ],
  );
}

Color getColors(String text) {
  switch (text) {
    case 'food':
      return const Color(0xFFFFB74D);
    case 'gwe':
      return const Color(0xFFFFD54F);
    case 'transportation':
      return const Color(0xFF81C784);
    case 'rent':
      return const Color(0xFFE57373);
    case 'activities':
      return const Color(0xFF64B5F6);
    case 'insurances':
      return const Color(0xFF9575CD);
    default:
      return Colors.blue;
  }
}

String getAbbreviation(String longMonthName) {
  switch (longMonthName) {
    case 'january':
      return 'JAN';
    case 'february':
      return 'FEB';
    case 'march':
      return 'MAR';
    case 'april':
      return 'APR';
    case 'may':
      return 'MAY';
    case 'june':
      return 'JUN';
    case 'july':
      return 'JUL';
    case 'august':
      return 'AUG';
    case 'september':
      return 'SEP';
    case 'october':
      return 'OCT';
    case 'november':
      return 'NOV';
    case 'december':
      return 'DEC';
    default:
      throw Exception('Month name is not correct!');
  }
}
