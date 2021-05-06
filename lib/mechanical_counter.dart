library mechanical_counter;

import 'package:flutter/material.dart';

class _NumericWheel extends StatefulWidget {
  _NumericWheel({this.topValue = 9});
  final int topValue;
  int _currentValue = 0;

  get value {
    return _currentValue;
  }

  @override
  __NumericWheelState createState() => __NumericWheelState();
}

class __NumericWheelState extends State<_NumericWheel> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dy < -5)
          setState(() {
            widget._currentValue++;
            if (widget._currentValue > widget.topValue)
              widget._currentValue = 0;
          });
        else if (details.delta.dy > 5)
          setState(() {
            widget._currentValue--;
            if (widget._currentValue < 0)
              widget._currentValue = widget.topValue;
          });
      },
      child: Container(
        alignment: Alignment(0, 0),
        color: Colors.grey,
        height: 80,
        width: 40,
        child: Column(children: [
          Text(
            '${(widget._currentValue == 0) ? widget.topValue : (widget._currentValue - 1)}',
            style: TextStyle(color: Colors.grey[600], fontSize: 20),
          ),
          Text(
            '${widget._currentValue}',
            style: TextStyle(color: Colors.black, fontSize: 24),
          ),
          Text(
            '${(widget._currentValue == widget.topValue) ? 0 : (widget._currentValue + 1)}',
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
    this.digits = 1,
    this.style = 'number',
  }) : super(key: key) {
    switch (style) {
      case "hh:mm:ss":
        _wheels = [
          _NumericWheel(topValue: 2),
          _NumericWheel(),
          _NumericWheel(topValue: 5),
          _NumericWheel(),
          _NumericWheel(topValue: 5),
          _NumericWheel(),
        ];
        break;
      case "hh:mm":
        _wheels = [
          _NumericWheel(topValue: 2),
          _NumericWheel(),
          _NumericWheel(topValue: 5),
          _NumericWheel(),
        ];
        break;
      default:
        _wheels = List<_NumericWheel>.filled(digits, _NumericWheel());
        break;
    }
    assert(style != 'number' || digits != null);
  }
  final digits;
  final style;
  List<_NumericWheel>? _wheels;

  get value {
    String ans = "";
    for (int i = 0; i < _wheels!.length; i++) {
      ans += '${_wheels![i].value}';
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
              Text(":"),
              _wheels![2],
              _wheels![3],
              Text(":"),
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
              Text(":"),
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
