library mechanical_counter;

import 'package:flutter/material.dart';

class _NumericWheel extends StatefulWidget {
  _NumericWheel({
    required this.onChanged,
    required this.index,
    this.topValue = 9,
    this.initialValue = 0,
  }) : assert(initialValue >= 0 && initialValue <= topValue);
  final int index;
  final int topValue;
  final int initialValue;
  final Function onChanged;

  @override
  __NumericWheelState createState() => __NumericWheelState();
}

class __NumericWheelState extends State<_NumericWheel> {
  int _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dy < -5) {
          setState(() {
            _currentValue++;
            if (_currentValue > widget.topValue) _currentValue = 0;
          });
          widget.onChanged(widget.index, _currentValue);
        } else if (details.delta.dy > 5) {
          setState(() {
            _currentValue--;
            if (_currentValue < 0) _currentValue = widget.topValue;
          });
          widget.onChanged(widget.index, _currentValue);
        }
      },
      child: Container(
        alignment: Alignment(0, 0),
        color: Colors.grey,
        height: 80,
        width: 40,
        child: Column(children: [
          Text(
            '${(_currentValue == 0) ? widget.topValue : (_currentValue - 1)}',
            style: TextStyle(color: Colors.grey[600], fontSize: 20),
          ),
          Text(
            '$_currentValue',
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          Text(
            '${(_currentValue == widget.topValue) ? 0 : (_currentValue + 1)}',
            style: TextStyle(color: Colors.grey[600], fontSize: 20),
          ),
        ]),
      ),
    );
  }
}

/// A convenience widget that presents an interface for changing numeric values
/// using simple touch gestures.
///
/// A container encloses the minimal size for a useful interaction in touch
/// screens.
/// [style] defines the type of target number. Currently it could be
/// `number` (default) or time in the form of: `hh:mm:ss`, `hh:mm`
/// [digits] defines the number of digits for the `number` type.
class MechanicalCounter extends StatelessWidget {
  MechanicalCounter({
    Key? key,
    required this.onChanged,
    this.digits = 1,
    this.style = 'number',
  }) : super(key: key) {
    switch (style) {
      case "hh:mm:ss":
        _wheels = [
          _NumericWheel(
            index: 0,
            onChanged: _changedDigit,
            topValue: 2, //Hours
          ),
          _NumericWheel(
            index: 1,
            onChanged: _changedDigit,
          ),
          _NumericWheel(
            index: 2,
            onChanged: _changedDigit,
            topValue: 5, //Minutes
          ),
          _NumericWheel(
            index: 3,
            onChanged: _changedDigit,
          ),
          _NumericWheel(
            index: 4,
            onChanged: _changedDigit,
            topValue: 5, //Seconds
          ),
          _NumericWheel(
            index: 5,
            onChanged: _changedDigit,
          ),
        ];
        break;
      case "hh:mm":
        _wheels = [
          _NumericWheel(
            index: 0,
            onChanged: _changedDigit,
            topValue: 2, // Hours
          ),
          _NumericWheel(
            index: 1,
            onChanged: _changedDigit,
          ),
          _NumericWheel(
            index: 2, // Minutes
            onChanged: _changedDigit,
            topValue: 5,
          ),
          _NumericWheel(
            index: 3,
            onChanged: _changedDigit,
          ),
        ];
        break;
      default:
        _wheels = List<_NumericWheel>.generate(
          digits,
          (index) => _NumericWheel(
            index: index,
            onChanged: _changedDigit,
          ),
        );
        break;
    }
    assert(style != 'number' || digits != null);
  }
  final digits;
  final ValueChanged<int> onChanged;
  final style;
  List<_NumericWheel>? _wheels;

  void _changedDigit(int index, int newValue) {}

  get value {
    String ans = "";
    for (int i = 0; i < _wheels!.length; i++) {
      ans += "0"; //'${_wheels![i]}';
    }
    return ans;
  }

  @override
  Widget build(context) {
    switch (style) {
      case "hh:mm:ss":
        return Container(
          width: (300),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _wheels![0],
              _wheels![1],
              Text(
                ":",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              _wheels![2],
              _wheels![3],
              Text(
                ":",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              _wheels![4],
              _wheels![5],
            ],
          ),
        );
      case "hh:mm":
        return Container(
          width: (200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _wheels![0],
              _wheels![1],
              Text(
                ":",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              _wheels![2],
              _wheels![3],
            ],
          ),
        );
      default:
        return Container(
          width: (40.0 * digits + 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _wheels!,
          ),
        );
    }
  }
}
