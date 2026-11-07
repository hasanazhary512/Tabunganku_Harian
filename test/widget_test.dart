import 'package:flutter_test/flutter_test.dart';
import 'package:tabunganku_harian/main.dart';

void main() {
  testWidgets('Smoke test aplikasi tabungan', (WidgetTester tester) async {
    // Jalankan aplikasi TabunganApp
    await tester.pumpWidget(const TabunganApp());

    // Memastikan judul atau teks di HomeScreen muncul
    expect(find.text('Tabungan Saya'), findsOneWidget);
  });
}