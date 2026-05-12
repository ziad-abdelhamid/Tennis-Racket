import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:untitled5/main.dart';

void main() {
  testWidgets('basic app test', (WidgetTester tester) async {
    await tester.pumpWidget(const TennisRacketApp());
    expect(find.text('Tennis Racket'), findsOneWidget);
  });
}