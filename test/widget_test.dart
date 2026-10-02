import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ab_client/common/controllers/async_list_controller.dart';
import 'package:ab_client/common/widgets/async_list_view.dart';

void main() {
  testWidgets('AsyncListView renders items once the list loads', (tester) async {
    final response = Completer<List<String>>();
    final controller = AsyncListController<String>(() => response.future);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AsyncListView<String>(
            controller: controller,
            itemBuilder: (context, item) => Text(item),
          ),
        ),
      ),
    );

    unawaited(controller.load());
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    response.complete(['Namespace A', 'Namespace B']);
    await tester.pumpAndSettle();

    expect(find.text('Namespace A'), findsOneWidget);
    expect(find.text('Namespace B'), findsOneWidget);

    controller.dispose();
  });
}
