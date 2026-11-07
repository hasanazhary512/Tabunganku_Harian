import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isDeposit = true;
  bool _isSubmitting = false;

  final _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _showCustomSnackBar({
    required String message,
    required bool isError,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 4,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: isError ? Colors.red.shade700 : Colors.amber.shade800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.warning_amber_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menyimpan data transaksi ke Supabase Database
  Future<void> _submitData() async {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.replaceAll('.', '').trim();
    final amount = double.tryParse(amountText) ?? 0;

    if (title.isEmpty || amount <= 0) {
      _showCustomSnackBar(
        message: 'Isi keteragan dan nominal dengan benar!',
        isError: false,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _supabase.from('transactions').insert({
        'title': title,
        'amount': amount,
        'is_deposit': _isDeposit,
      });

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        _showCustomSnackBar(
          message: 'Gagal menyimpan transaksi: $e',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Tambah Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Accent Container
            Container(
              width: double.infinity,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Jenis Transaksi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Custom Segmented Selector for Deposit / Withdraw
                      Row(
                        children: [
                          Expanded(
                            child: _buildTypeCard(
                              title: 'Setoran',
                              icon: Icons.arrow_downward_rounded,
                              activeColor: Colors.green.shade600,
                              isSelected: _isDeposit,
                              onTap: () => setState(() => _isDeposit = true),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTypeCard(
                              title: 'Penarikan',
                              icon: Icons.arrow_upward_rounded,
                              activeColor: Colors.red.shade600,
                              isSelected: !_isDeposit,
                              onTap: () => setState(() => _isDeposit = false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Input Keterangan
                      TextField(
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Keterangan',
                          hintText: 'Contoh: Tabungan Bulanan, Beli Pulsa',
                          prefixIcon: const Icon(Icons.notes_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blue.shade700,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Input Nominal
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _isSubmitting ? null : _submitData(),
                        decoration: InputDecoration(
                          labelText: 'Nominal',
                          hintText: '0',
                          prefixIcon: const Icon(Icons.attach_money_rounded),
                          prefixText: 'Rp ',
                          prefixStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.blue.shade700,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade800,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isSubmitting ? null : _submitData,
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Simpan Transaksi',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required String title,
    required IconData icon,
    required Color activeColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withAlpha(20) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? activeColor : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? activeColor : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}