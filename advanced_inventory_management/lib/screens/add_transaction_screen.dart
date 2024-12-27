import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/db/database_helper.dart'; // Pastikan Anda memiliki DatabaseHelper untuk mengelola SQLite

class AddTransactionScreen extends StatefulWidget {
  final String itemId; // Ubah itemId menjadi String, karena ID Firestore adalah string

  const AddTransactionScreen({super.key, required this.itemId});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _transactionType = 'Masuk'; // Default "Masuk"

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Tanggal saat ini
  }

  Future<void> _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      final int amount = int.tryParse(_amountController.text) ?? 0;
      final String date = _dateController.text;
      final String transactionType = _transactionType;

      final transactionData = {
        'itemId': widget.itemId,
        'transactionType': transactionType,
        'quantity': amount,
        'date': date,
      };

      await DatabaseHelper().insertTransaction(transactionData);

      if (transactionType == 'Masuk') {
        await DatabaseHelper().updateItemStock(widget.itemId, amount, 'masuk');
      } else {
        await DatabaseHelper().updateItemStock(widget.itemId, -amount, 'keluar');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Riwayat transaksi ditambahkan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Riwayat Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'ID Barang: ${widget.itemId}', // Tampilkan ID Barang
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _transactionType,
                decoration: const InputDecoration(
                  labelText: 'Jenis Transaksi',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Masuk', child: Text('Barang Masuk')),
                  DropdownMenuItem(value: 'Keluar', child: Text('Barang Keluar')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _transactionType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Jumlah harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      _dateController.text = formattedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: const Text('Simpan Riwayat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
