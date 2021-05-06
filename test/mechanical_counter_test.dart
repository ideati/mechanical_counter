import 'package:flutter_test/flutter_test.dart';

import 'package:mechanical_counter/mechanical_counter.dart';

void main() {
  test('creates a single digit counter', () {
    final single = MechanicalCounter(digits: 1);
    expect(single.digits, 1);
    expect(single.value, "0");
  });
  test('creates a triple digit counter', () {
    final triple = MechanicalCounter(digits: 3);
    expect(triple.digits, 3);
    expect(triple.value, "000");
  });
}
