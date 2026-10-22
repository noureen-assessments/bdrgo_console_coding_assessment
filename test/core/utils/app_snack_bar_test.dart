import 'package:badrgo_console_assesment/config/theme/app_colors.dart';
import 'package:badrgo_console_assesment/core/utils/app_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(void Function(BuildContext) onTap) => MaterialApp(
  home: Scaffold(
    body: Builder(
      builder: (context) =>
          TextButton(onPressed: () => onTap(context), child: const Text('go')),
    ),
  ),
);

void main() {
  testWidgets('error: text on the error color, no icon', (tester) async {
    await tester.pumpWidget(
      _host((context) => AppSnackBar.showError(context, 'Could not sign out')),
    );
    await tester.tap(find.text('go'));
    await tester.pump();

    final bar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(bar.backgroundColor, AppColors.snackBarError);
    expect(find.text('Could not sign out'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(SnackBar), matching: find.byType(Icon)),
      findsNothing,
    );
  });

  testWidgets('success uses the success color and replaces the previous', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      _host(
        (context) => calls++ == 0
            ? AppSnackBar.showError(context, 'first')
            : AppSnackBar.showSuccess(context, 'Saved'),
      ),
    );
    await tester.tap(find.text('go'));
    await tester.pump();
    await tester.tap(find.text('go'));
    await tester.pumpAndSettle();

    expect(find.text('first'), findsNothing);
    final bar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(bar.backgroundColor, AppColors.snackBarSuccess);
  });
}
