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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGraph() {
    // Sample data for the chart
    final List<charts.Series<LinearSales, int>> seriesList = [
      charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: [
          LinearSales(0, 5),
          LinearSales(1, 25),
          LinearSales(2, 100),
          LinearSales(3, 75),
        ],
      ),
    ];

    return charts.LineChart(
      seriesList,
      animate: true,
    );
  }

  Widget _buildCardView() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildCard(),
              SizedBox(height: 8),
              _buildCard(),
              SizedBox(height: 8),
              _buildCard(),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildCard(),
              SizedBox(height: 8),
              _buildCard(),
              SizedBox(height: 8),
              _buildCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Card(
      child: ListTile(
        title: Text('Card Title'),
        subtitle: Text('Card Subtitle'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Do something when the card is tapped
        },
      ),
    );
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}