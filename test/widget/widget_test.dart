import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_flutter_bloc/main.dart';
import 'package:mqtt_flutter_bloc/widgets/brokers/brokers_view.dart';

void main() {
  testWidgets('Add a broker', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(BrokersView());
    await tester.pump();

    // find all widgets needed
    //final addBrokerFab = find.text('Broker');
    //final addBrokerFab = find.byKey(const ValueKey('addBrokerFab'));

    // execute the actual test
    //await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.add));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // check outputs
    expect(
        find.widgetWithIcon(FloatingActionButton, Icons.add), findsOneWidget);
    //expect(find.text('Add Broker'), findsOneWidget);

    // // find all widgets needed
    // final brokerNameField = find.byKey(const ValueKey('__brokerNameField__'));
    // final brokerAddressField =
    //     find.byKey(const ValueKey('__brokerAddressField__'));
    // final brokerPortField = find.byKey(const ValueKey('__brokerPortField__'));
    // final brokerIdentifierField =
    //     find.byKey(const ValueKey('__brokerIdentifierField__'));
    // final addBrokerButton = find.byKey(const ValueKey('__saveNewBroker__'));

    // // execute the actual test
    // await tester.enterText(brokerNameField, 'Mosquitto');
    // await tester.enterText(brokerAddressField, 'test.mosquitto.org');
    // await tester.enterText(brokerPortField, '1883');
    // await tester.enterText(brokerIdentifierField, 'Flutter');
    // await tester.tap(addBrokerButton);
    // await tester.pump(); // rebuilds your widget

    // // check outputs
    // expect(find.text('Mosquitto'), findsOneWidget);
  });
}
