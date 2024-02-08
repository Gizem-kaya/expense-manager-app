import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Expense Manager'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<LinearExpenses> monthlyExpenses = [
    LinearExpenses(0, 1600),
    LinearExpenses(1, 2000),
    LinearExpenses(2, 2500),
    LinearExpenses(3, 2600),
    LinearExpenses(4, 2100)
  ];

  final List<CategoricalExpenses> categoricalExpenses = [CategoricalExpenses("Food", 500, Currency.Euro),
    CategoricalExpenses("GWE", 500, Currency.Euro),
    CategoricalExpenses('Transportation', 200, Currency.Euro),
    CategoricalExpenses('Rent', 1550, Currency.Euro),
    CategoricalExpenses('Activities', 200, Currency.Euro),
    CategoricalExpenses('Insurances', 300, Currency.Euro)
  ];

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
    // Sample data for the chart
    final List<charts.Series<LinearExpenses, int>> seriesList = [
      charts.Series<LinearExpenses, int>(
        id: 'expenses',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearExpenses expenses, _) => expenses.column,
        measureFn: (LinearExpenses expenses, _) => expenses.row,
        data: monthlyExpenses,
      ),
    ];

    return charts.LineChart(
      seriesList,
      animate: true,
    );
  }

  Widget _buildCardView() {
    return GridView.count(
      crossAxisCount: 2,
        childAspectRatio: (1 / .4),
      children: List.generate(categoricalExpenses.length, (index) {
        return SizedBox(

          child: _buildCard(
            context,
            categoricalExpenses[index].category,
            categoricalExpenses[index].amount,
            categoricalExpenses[index].currency.sign,
          ),
        );
      }),
    );
  }

  Widget _buildCard(BuildContext context, String title, int amount, String currency) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('$amount $currency'),
        trailing: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _showDialog(context);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewScreen()),
          );
        },
      ),
    );
  }
}

class LinearExpenses {
  final int column;
  final int row;

  LinearExpenses(this.column, this.row);
}

enum Currency {
  Lira('₺'),
  Euro('€'),
  Dollar('\$');

  final String sign;
  const Currency(this.sign);
}


class CategoricalExpenses {
  final String category;
  final int amount;
  final Currency currency;

  CategoricalExpenses(this.category, this.amount, this.currency);
}


void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Dialog Title'),
        content: Text('This is a dialog.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}


class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Screen'),
      ),
      body: Center(
        child: Text('This is a new screen.'),
      ),
    );
  }
}
