# Laboratory Activity 4: Flutter Calculator

**Topic:** StatefulWidget  
**Project:** roque_calculator  
**Student:** Charles Jayson R Roque  
**Section:** 3447

The calculator follows the activity's indigo interface and uses two number fields, four operation buttons, a result display, and a Clear button. It accepts signed decimal numbers and shows messages for invalid input and division by zero.

## Run on Android

Open this project folder in VS Code, connect an Android phone with USB debugging enabled (or start an Android emulator), and run:

```sh
flutter pub get
flutter run
```

Select the Android device if prompted. This project includes the Android platform.

## Source files

- `lib/main.dart`: starts `CalculatorApp`, sets the Material theme, and opens `CalculatorPage`.
- `lib/page.dart`: contains the `StatefulWidget`, controllers, calculation and Clear functions, controller disposal, and calculator interface.
- `test/widget_test.dart`: checks the interface, arithmetic, signed decimals, invalid inputs, division by zero, and Clear.

## Code tracing: 8 + 2

| Step | Code or event | Value or effect |
| --- | --- | --- |
| 1 | Type `8` into First Number | `firstNumberController.text` is `'8'`. |
| 2 | Type `2` into Second Number | `secondNumberController.text` is `'2'`. |
| 3 | Tap `+` | `onPressed` calls `calculate('+')`. |
| 4 | `.text.trim()` and `double.tryParse()` | `first` becomes `8.0`; `second` becomes `2.0`. |
| 5 | Input validation | Both numbers are valid and finite, so calculation continues. |
| 6 | `switch (operation)`, `case '+'` | `answer = first + second` produces `10.0`. |
| 7 | `setState()` | `result` becomes `'10.0'`; `operationLabel` becomes `'8.0 + 2.0'`. |
| 8 | Flutter rebuilds the screen | The result display shows the updated operation and answer. |

For subtraction, the button displays `−` and passes `'-'` to `calculate()` to match the switch case. All results use `double.toString()`, as in the activity, so whole-number answers display a decimal (for example, `10.0`).

`clearCalculator()` clears both controllers and resets `result` to `'0'` and `operationLabel` to `'Enter two numbers'` inside `setState()`. `dispose()` releases both controllers when the screen is permanently removed.

## Checks

```sh
flutter analyze
flutter test
```

Static analysis completed with no issues. The widget test suite compiled, but this session's local connection restriction prevented the test runner from loading the suite. Run `flutter test` on your laptop to execute the included tests.
