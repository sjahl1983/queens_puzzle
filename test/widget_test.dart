// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eight_queens_puzzle/main.dart';

void main() {

  testWidgets('Solve Queen Puzzle', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    Finder finder = find.byKey(Key('board_size_button'));
    await tester.tap(finder);
    await tester.pump();

    String value = '4';
    finder = find.byKey(Key('board_size_field'));
    await tester.enterText(finder, value);
    TextFormField f = tester.widget(finder);
    expect(f.controller.text, value);

    finder = find.byKey(Key('board_size_solve_button'));
    await tester.tap(finder);
    await tester.pump();

    finder = find.byKey(Key('solutions'));
    await tester.pump();
    expect(finder, findsNWidgets(2));

  });
}
