import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.isDeposit
              ? Colors.green.shade100
              : Colors.red.shade100,
          child: Icon(
            transaction.isDeposit ? Icons.add : Icons.remove,
            color: transaction.isDeposit ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
        ),
        trailing: Text(
          '${transaction.isDeposit ? "+" : "-"} Rp ${transaction.amount.toStringAsFixed(0)}',
          style: TextStyle(
            color: transaction.isDeposit ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}