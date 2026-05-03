import 'package:flutter_test/flutter_test.dart';

import 'package:client_flutter/main.dart';

void main() {
  testWidgets('renders literary app shell', (WidgetTester tester) async {
    await tester.pumpWidget(const DbTematicaApp());

    expect(find.text('DbTemática literaria'), findsOneWidget);
    expect(find.text('Autores'), findsOneWidget);
    expect(find.text('Libros'), findsOneWidget);
    expect(find.text('Países Nobel'), findsOneWidget);
  });
}
