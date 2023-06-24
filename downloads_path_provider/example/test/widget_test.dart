import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:downloads_path_provider_28_example/main.dart';

void main() {
  testWidgets('Get downloads directory', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp());

    // Verify that downloads directory is retrieved.
    expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is Text && widget.data!.startsWith('Downloads directory:'),
        ),
        findsOneWidget);
  });
}
