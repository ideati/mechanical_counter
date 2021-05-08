import 'package:flutter/material.dart';
import 'package:mechanical_counter/mechanical_counter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mechanical Counter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Mechanical Counter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "This counter has style: 'number' by default",
            ),
            MechanicalCounter(
                digits: 6,
                initialValue: 12345678,
                color: Colors.red,
                backgroundColor: Colors.amber,
                onChanged: (newValue) => print("Value changed to $newValue")),
            Text(
              "And this is meant to resemble a clock, style: 'hh:mm:ss'",
            ),
            MechanicalCounter(
                format: "hh:mm:ss",
                onChanged: (newValue) => print("Value changed to $newValue"))
          ],
        ),
      ),
    );
  }
}
