import 'package:flutter_test/flutter_test.dart';
import 'package:quotierte_redeliste/main.dart';

void main() {
  testWidgets('app should work', (tester) async {
    await tester.pumpWidget(new MyApp());
  });
}
