import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/db/database_helper.dart';

class TransactionListScreen extends StatefulWidget {
  final String itemId;

  const TransactionListScreen({super.key, required this.itemId});

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  late Future<List<Map<String, dynamic>>> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = DatabaseHelper().getTransactions(widget.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada riwayat transaksi'),
            );
          } else {
            final transactions = snapshot.data!;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      transaction['transactionType'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal: ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(transaction['date']))}'),
                        Text('Jumlah: ${transaction['quantity'] ?? 'Tidak tersedia'}'),
                      ],
                    ),
                    trailing: transaction['transactionType'] == 'Masuk'
                        ? const Icon(Icons.arrow_downward, color: Colors.green)
                        : const Icon(Icons.arrow_upward, color: Colors.red),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
