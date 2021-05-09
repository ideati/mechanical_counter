library mechanical_counter;

import 'package:flutter/material.dart';

/// Numeric wheels are handled internally. They are not intended
/// to be used directly by outside code
class _NumericWheel extends StatefulWidget {
  _NumericWheel({
    required this.onChanged,
    required this.index,
    required this.color,
    required this.backgroundColor,
    this.topValue = 9,
    this.initialValue = 0,
  }) : assert(initialValue >= 0 && initialValue <= topValue);
  final Color color;
  final Color backgroundColor;
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
      onTap: () {
        setState(() {
          _currentValue++;
          if (_currentValue > widget.topValue) _currentValue = 0;
        });
        widget.onChanged(widget.index, _currentValue);
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        if (details.delta.dy < -4) {
          setState(() {
            _currentValue++;
            if (_currentValue > widget.topValue) _currentValue = 0;
          });
          widget.onChanged(widget.index, _currentValue);
        } else if (details.delta.dy > 4) {
          setState(() {
            _currentValue--;
            if (_currentValue < 0) _currentValue = widget.topValue;
          });
          widget.onChanged(widget.index, _currentValue);
        }
      },
      child: Container(
        alignment: Alignment(0, 0),
        color: widget.backgroundColor,
        height: 80,
        width: 40,
        child: Column(children: [
          Text(
            '${(_currentValue == 0) ? widget.topValue : (_currentValue - 1)}',
            style: TextStyle(
              color: widget.color.withAlpha(120),
              fontSize: 20,
            ),
          ),
          Text(
            '$_currentValue',
            style: TextStyle(
              color: widget.color,
              fontSize: 24,
            ),
          ),
          Text(
            '${(_currentValue == widget.topValue) ? 0 : (_currentValue + 1)}',
            style: TextStyle(
              color: widget.color.withAlpha(120),
              fontSize: 20,
            ),
          ),
        ]),
      ),
    );
  }
}

/// A convenience widget that presents an interface for changing numeric values
/// using simple touch gestures.
///
/// A container encloses the minimal size needed for a useful interaction
/// by touch gestures. Swipe up and down or tap for single increment.
class MechanicalCounter extends StatelessWidget {
  MechanicalCounter({
    Key? key,
    required this.onChanged,
    this.color,
    this.backgroundColor,
    this.format = 'number',
    this.digits = 1,
    this.initialValue = 0,
  })  : assert(format != 'number' || digits != null),
        super(key: key);

  /// [format] defines the type of target number. Currently it could be
  /// `number` (default) or time in the form of: `hh:mm:ss`, `hh:mm`
  final format;

  /// [digits] defines the number of digits for the `number` format. For the
  /// other formats, it has no effect.
  final digits;

  /// [initialValue] set the starting values for each digit. If the value given
  /// has more digits than [digits], extra digits are discarded.
  /// For the clock formats, [initialValues] are the digits without colons (:).
  /// Ie: for 23:59:59 -> initialValue: 235959.
  final initialValue;

  /// Optional [color] for numbers and symbols. If not given, the theme's
  /// primaryColor is used
  final Color? color;

  /// Optional [backgroundColor] for the body of the counter. If not given, the
  /// theme's backgroundColor is used.
  final Color? backgroundColor;

  /// Required [onChanged] is called when the user modifies the number by tapping
  /// or swipping on the counter's face.
  final ValueChanged<String> onChanged;

  /// Internal tracker for individual values
  final List<int> _values = [];

  /// Internal function to track individual digit changes
  void _changedDigit(int index, int newValue) {
    _values[index] = newValue;
    onChanged(this.value);
  }

  /// Internal initialization routine
  int _init() {
    int _digits;
    switch (format) {
      case "hh:mm:ss":
        _digits = 6;
        break;
      case "hh:mm":
        _digits = 4;
        break;
      default:
        _digits = digits;
    }
    if (_values.length == 0) {
      _values.clear();
      final initialStr = initialValue.toString().padLeft(6, '0');
      for (int i = 0; i < _digits; i++) _values.add(int.parse(initialStr[i]));
    }
    return _digits;
  }

  /// Actual display value as a String, according to [format].
  get value {
    final _digits = _init();
    switch (format) {
      case "hh:mm:ss":
        return '${_values[0]}${_values[1]}:${_values[2]}${_values[3]}:${_values[4]}${_values[5]}';
      case "hh:mm":
        return '${_values[0]}${_values[1]}:${_values[2]}${_values[3]}';
      default:
        String ans = "";
        for (int i = 0; i < _digits; i++) ans += '${_values[i]}';
        return ans;
    }
  }

  @override
  Widget build(context) {
    Color _color;
    Color _backgroundColor;
    if (color == null) {
      _color = Theme.of(context).primaryColor;
    } else {
      _color = color!;
    }
    if (backgroundColor == null) {
      _backgroundColor = Theme.of(context).backgroundColor;
    } else {
      _backgroundColor = backgroundColor!;
    }
    if (_values.length == 0) {
      _init();
    }
    switch (format) {
      case "hh:mm:ss":
        return Container(
          width: (300),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NumericWheel(
                index: 0,
                initialValue: _values[0],
                onChanged: _changedDigit,
                color: _color,
                backgroundColor: _backgroundColor,
                topValue: 2, //Hours
              ),
              _NumericWheel(
                index: 1,
                initialValue: _values[1],
                onChanged: _changedDigit,
                color: _color,
                backgroundColor: _backgroundColor,
              ),
              Text(
                ":",
                style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              _NumericWheel(
                index: 2,
                initialValue: _values[2],
                onChanged: _changedDigit,
                color: _color,
                backgroundColor: _backgroundColor,
                topValue: 5, //Minutes
              ),
              _NumericWheel(
                index: 3,
                initialValue: _values[3],
                onChanged: _changedDigit,
                color: _color,
                backgroundColor: _backgroundColor,
              ),
              Text(
                ":",
                style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              _NumericWheel(
                index: 4,
                initialValue: _values[4],
                onChanged: _changedDigit,
                color: _color,
                backgroundColor: _backgroundColor,
                topValue: 5, //Seconds
              ),
              _NumericWheel(
                index: 5,
                initialValue: _values[5],
                onChanged: _changedDigit,
                color: _color,
                backgroundColor: _backgroundColor,
              ),
            ],
          ),
        );
      case "hh:mm":
        return Container(
          width: (200),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NumericWheel(
                index: 0,
                initialValue: _values[0],
                onChanged: _changedDigit,
                color: _color,
                backgroundColor: _backgroundColor,
                topValue: 2, //Hours
              ),
              _NumericWheel(
                index: 1,
                initialValue: _values[1],
                onChanged: _changedDigit,
                color: _color,
                backgroundColor: _backgroundColor,
              ),
              Text(
                ":",
                style: TextStyle(
                  color: _color,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              _NumericWheel(
                index: 2,
                initialValue: _values[2],
                onChanged: _changedDigit,
                color: _color,
                backgroundColor: _backgroundColor,
                topValue: 5, //Minutes
              ),
              _NumericWheel(
                index: 3,
                initialValue: _values[3],
                onChanged: _changedDigit,
                color: _color,
                backgroundColor: _backgroundColor,
              ),
            ],
          ),
        );
      default:
        return Container(
          width: (40.0 * digits + 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              digits,
              (index) => _NumericWheel(
                index: index,
                color: _color,
                backgroundColor: _backgroundColor,
                initialValue: _values[index],
                onChanged: _changedDigit,
              ),
            ),
          ),
        );
    }
  }
}
