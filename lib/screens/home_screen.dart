import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction.dart';
import '../widgets/summary_card.dart';
import '../widgets/transaction_item.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  // Mengambil data transaksi dari Supabase Database
  Future<void> _fetchTransactions() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabase
          .from('transactions')
          .select()
          .order('created_at', ascending: false);

      final data = response as List<dynamic>;
      if (!mounted) return;
      setState(() {
        _transactions = data.map((item) => Transaction.fromMap(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 4,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: Colors.red.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Gagal mengambil data: $e',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  // Fungsi untuk Logout
  Future<void> _logout() async {
    try {
      await _supabase.auth.signOut();
      if (!mounted) return;
      // Mengarahkan pengguna kembali ke halaman Login & menghapus riwayat tumpukan route
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal logout: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  double get _totalSaldo {
    double total = 0;
    for (var item in _transactions) {
      if (item.isDeposit) {
        total += item.amount;
      } else {
        total -= item.amount;
      }
    }
    return total;
  }

  void _navigateToAddScreen() async {
    final isAdded = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );

    if (isAdded == true) {
      _fetchTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Dashboard Tabungan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        actions: [
          // Tombol Cetak Laporan
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.print_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            tooltip: 'Cetak Laporan',
            onPressed: () {
              Navigator.pushNamed(context, '/report');
            },
          ),
          // Tombol Logout
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
              tooltip: 'Keluar',
              onPressed: _logout,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchTransactions,
        color: Colors.blue.shade800,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Gradient Container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade900,
                      Colors.blue.shade700,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                child: SummaryCard(totalSaldo: _totalSaldo),
              ),
              const SizedBox(height: 24),

              // Riwayat Transaksi Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Riwayat Transaksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_transactions.length} Item',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Transaction List Container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _isLoading
                    ? SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue.shade800,
                          ),
                        ),
                      )
                    : _transactions.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Belum ada transaksi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tekan tombol + untuk menambah baru',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _transactions.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (ctx, index) {
                              return TransactionItem(
                                transaction: _transactions[index],
                              );
                            },
                          ),
              ),
              const SizedBox(height: 80), // Padding bawah agar FAB tidak menutupi list
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddScreen,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tambah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}