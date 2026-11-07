class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isDeposit;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isDeposit,
  });

  // Konversi data dari Supabase (JSON/Map) ke Object Dart
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'].toString(),
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['created_at'] as String),
      isDeposit: map['is_deposit'] as bool,
    );
  }

  // Konversi Object Dart ke JSON/Map untuk disimpan ke Supabase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'is_deposit': isDeposit,
    };
  }
}