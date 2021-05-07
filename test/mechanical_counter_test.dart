import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mechanical_counter/mechanical_counter.dart';

void main() {
  test('creates a single digit counter', () {
    final single = MechanicalCounter(
      onChanged: (value) => print("Changed value to $value"),
      digits: 1,
    );
    expect(single.digits, 1);
    expect(single.value, "0");
  });
  test('creates a triple digit counter', () {
    final triple = MechanicalCounter(
      onChanged: (value) => print("Changed value to $value"),
      digits: 3,
    );
    expect(triple.digits, 3);
    expect(triple.value, "000");
  });
  testWidgets('MechanicalCounter has 6 digits', (WidgetTester tester) async {
    await tester.pumpWidget(TestBench(
      title: "Testing",
      value: "Result",
    ));
    final titleFinder = find.text('Testing');
    expect(titleFinder, findsOneWidget);
    final digitFinder = find.text('0');
    expect(digitFinder, findsNWidgets(6));
  });
}

class TestBench extends StatelessWidget {
  final String title;
  final String value;

  const TestBench({
    Key? key,
    this.title = "Test",
    this.value = "Value",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing Widget',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: MechanicalCounter(
          onChanged: (value) => print("Changed value to $value"),
          digits: 6,
        ),
      ),
    );
  }
}
