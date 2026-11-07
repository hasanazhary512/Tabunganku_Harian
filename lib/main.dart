import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/report_screen.dart';

Future<void> main() async {
  // Wajib dipanggil sebelum fungsi async native
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://wctidherzoioyffhslhx.supabase.co',
      publishableKey: 'sb_publishable_BlYiS5UUwUy9HRwjg4sqGg_M2UNUIZ8',
    );
  } catch (e) {
    debugPrint("Gagal inisialisasi Supabase: $e");
  }

  runApp(const TabunganApp());
}

class TabunganApp extends StatelessWidget {
  const TabunganApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Tabungan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/report': (context) => const ReportScreen(),
      },
    );
  }
}