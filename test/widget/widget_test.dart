import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('add a broker', (WidgetTester tester) async {
    // find all widgets needed

    final addNameField = find.byKey(const ValueKey('__brokerNameField__'));
    final addButton = find.byKey(const ValueKey('__saveNewBroker__'));

    // execute the actual test
    // await tester
    //     .pumpWidget(MaterialApp(home: AddEditBrokerScreen(isEditing: false)));
    await tester.enterText(addNameField, 'Mosquitto');
    await tester.tap(addButton);
    await tester.pump(); // rebuilds your widget

    // check outputs
    expect(find.text('Mosquitto'), findsOneWidget);
  });
}
