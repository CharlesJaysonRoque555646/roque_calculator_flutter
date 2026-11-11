import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:roque_calculator/main.dart';

Future<void> enterNumbers(
  WidgetTester tester,
  String first,
  String second,
) async {
  await tester.enterText(find.byType(TextField).at(0), first);
  await tester.enterText(find.byType(TextField).at(1), second);
}

Future<void> pressButton(WidgetTester tester, String label) async {
  final button = find.widgetWithText(ElevatedButton, label);
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the required calculator interface', (tester) async {
    await tester.pumpWidget(const CalculatorApp());

    expect(find.text('My Stateful Calculator'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(4));
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Enter two numbers'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);
    expect(
      find.text('Created by: Charles Jayson R Roque\nSection: 3447'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  const expectedResults = {'+': '10.0', '−': '6.0', '×': '16.0', '÷': '4.0'};
  for (final entry in expectedResults.entries) {
    testWidgets('calculates ${entry.key} and updates the display', (
      tester,
    ) async {
      await tester.pumpWidget(const CalculatorApp());
      await enterNumbers(tester, '8', '2');
      await pressButton(tester, entry.key);

      expect(find.text(entry.value), findsOneWidget);
      final operation = entry.key == '−' ? '-' : entry.key;
      expect(find.text('8.0 $operation 2.0'), findsOneWidget);
    });
  }

  testWidgets('accepts signed decimals and surrounding whitespace', (
    tester,
  ) async {
    await tester.pumpWidget(const CalculatorApp());
    await enterNumbers(tester, ' -2.5 ', ' 1.25 ');
    await pressButton(tester, '+');

    expect(find.text('-1.25'), findsOneWidget);
  });

  const invalidInputs = [
    ['', '2'],
    ['2', ''],
    ['abc', '2'],
    ['2', 'abc'],
    ['NaN', '2'],
    ['2', 'Infinity'],
  ];
  for (var index = 0; index < invalidInputs.length; index++) {
    final inputs = invalidInputs[index];
    testWidgets('rejects invalid input case ${index + 1}', (tester) async {
      await tester.pumpWidget(const CalculatorApp());
      await enterNumbers(tester, inputs[0], inputs[1]);
      await pressButton(tester, '+');

      expect(find.text('Invalid input'), findsOneWidget);
      expect(find.text('Please enter two valid numbers'), findsOneWidget);
    });
  }

  testWidgets('handles division by zero and allows correction', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await enterNumbers(tester, '8', '0');
    await pressButton(tester, '÷');

    expect(find.text('Cannot divide by zero'), findsOneWidget);
    expect(find.text('Please change the second number'), findsOneWidget);

    await enterNumbers(tester, '8', '2');
    await pressButton(tester, '÷');
    expect(find.text('4.0'), findsOneWidget);
  });

  testWidgets('clears both inputs and resets the display', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await enterNumbers(tester, '8', '2');
    await pressButton(tester, '+');

    final clearButton = find.widgetWithText(OutlinedButton, 'Clear');
    await tester.ensureVisible(clearButton);
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    for (final field in tester.widgetList<TextField>(find.byType(TextField))) {
      expect(field.controller!.text, isEmpty);
    }
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Enter two numbers'), findsOneWidget);
  });
}
