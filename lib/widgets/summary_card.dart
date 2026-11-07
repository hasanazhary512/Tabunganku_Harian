import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final double totalSaldo;

  const SummaryCard({super.key, required this.totalSaldo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.teal.shade700,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Saldo',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${totalSaldo.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const CircleAvatar(
              backgroundColor: Colors.white24,
              radius: 24,
              child: Icon(Icons.account_balance_wallet, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}