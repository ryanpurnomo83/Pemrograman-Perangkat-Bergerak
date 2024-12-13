class TransactionRecord {
  final int? id;
  final int itemId;
  final String type; // 'in' or 'out'
  final int quantity;
  final DateTime date;

  TransactionRecord({
    this.id,
    required this.itemId,
    required this.type,
    required this.quantity,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemId': itemId,
      'type': type,
      'quantity': quantity,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionRecord.fromMap(Map<String, dynamic> map) {
    return TransactionRecord(
      id: map['id'],
      itemId: map['itemId'],
      type: map['type'],
      quantity: map['quantity'],
      date: DateTime.parse(map['date']),
    );
  }
}
