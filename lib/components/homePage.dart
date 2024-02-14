import 'package:expense_manager/data/dummyData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../data/models/monthlyExpenses.dart';
import '../utils.dart';
import 'categoryPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final betweenSpace = 0.3;

  late List<MonthlyExpenses> expensesOf2023;
  @override
  void initState() {
    super.initState();
    expensesOf2023 = [
      MonthlyExpenses("JAN", DummyData.instance.januaryExpenses),
      MonthlyExpenses("FEB", DummyData.instance.februaryExpenses),
      MonthlyExpenses("MAR", DummyData.instance.marchExpenses),
      MonthlyExpenses("APR", DummyData.instance.aprilExpenses),
      MonthlyExpenses("MAY", DummyData.instance.mayExpenses),
      MonthlyExpenses("JUN", DummyData.instance.juneExpenses),
      MonthlyExpenses("JUL", DummyData.instance.julyExpenses),
      MonthlyExpenses("AUG", DummyData.instance.augustExpenses),
      MonthlyExpenses("SEP", DummyData.instance.septemberExpenses),
      MonthlyExpenses("OCT", DummyData.instance.octoberExpenses),
      MonthlyExpenses("NOV", DummyData.instance.novemberExpenses),
      MonthlyExpenses("DEC", DummyData.instance.decemberExpenses),
    ];
  }

  BarChartGroupData generateGroupData(
    int x,
    double food,
    double gwe,
    double transportation,
    double rent,
    double activities,
    double insurances,
  ) {
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
              activities,
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
              activities +
              betweenSpace,
          toY: rent +
              betweenSpace +
              food +
              betweenSpace +
              gwe +
              betweenSpace +
              transportation +
              betweenSpace +
              activities +
              betweenSpace +
              insurances,
          colors: [const Color(0xFF9575CD)],
          width: 8,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: _buildGraph(),
          ),
          Expanded(
            flex: 1,
            child: _buildCardView(),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  Widget _buildGraph() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 20, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '2023',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          AspectRatio(
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
                      maxY: expensesOf2023
                              .map((monthlyExpense) =>
                                  monthlyExpense.getTotalExpense())
                              .reduce((value, element) =>
                                  value > element ? value : element) +
                          300,
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTextStyles: (context, value) => const TextStyle(
                              color: Colors.black38, fontSize: 11),
                          margin: 10,
                          getTitles: (double value) {
                            int index = value.toInt();
                            if (index >= 0 && index < expensesOf2023.length) {
                              return expensesOf2023[index].column;
                            }
                            return 'error';
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 20,
                          getTextStyles: (context, value) => const TextStyle(
                              color: Colors.black38, fontSize: 11),
                          margin: 7,
                        ),
                        topTitles: SideTitles(showTitles: false),
                        rightTitles: SideTitles(showTitles: false),
                      ),
                      barGroups: List.generate(
                        expensesOf2023.length,
                        (index) => generateGroupData(
                          index,
                          expensesOf2023[index]
                              .categoricalExpensesList[0]
                              .amount
                              .toDouble(),
                          expensesOf2023[index]
                              .categoricalExpensesList[1]
                              .amount
                              .toDouble(),
                          expensesOf2023[index]
                              .categoricalExpensesList[2]
                              .amount
                              .toDouble(),
                          expensesOf2023[index]
                              .categoricalExpensesList[3]
                              .amount
                              .toDouble(),
                          expensesOf2023[index]
                              .categoricalExpensesList[4]
                              .amount
                              .toDouble(),
                          expensesOf2023[index]
                              .categoricalExpensesList[5]
                              .amount
                              .toDouble(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardView() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (1 / .4),
      children:
          List.generate(DummyData.instance.januaryExpenses.length, (index) {
        return SizedBox(
          child: _buildCard(
            context,
            DummyData.instance.januaryExpenses[index].category,
            DummyData.instance.januaryExpenses[index].amount.toInt(),
            DummyData.instance.januaryExpenses[index].currency.sign,
          ),
        );
      }),
    );
  }

  Widget _buildCard(
      BuildContext context, String title, int amount, String currency) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('$amount $currency'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () => increaseExpenseDialog(context),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryPage()),
          );
        },
      ),
    );
  }
}
