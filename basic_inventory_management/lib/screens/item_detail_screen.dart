import 'package:flutter/material.dart';
import 'dart:io';
import 'add_transaction_screen.dart';

class ItemDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const ItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Barang: ${item['name']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Memusatkan judul di AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bagian Gambar
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: item['imagePath'] != null && item['imagePath'].isNotEmpty
                      ? FileImage(File(item['imagePath']))
                      : AssetImage('assets/item_placeholder.png') as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),

              // Bagian Informasi Barang
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.label, color: Colors.blue),
                        title: const Text('Nama', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item['name'], style: const TextStyle(fontSize: 16)),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.category, color: Colors.green),
                        title: const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item['category'], style: const TextStyle(fontSize: 16)),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.description, color: Colors.orange),
                        title: const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item['description'], style: const TextStyle(fontSize: 16)),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.monetization_on, color: Colors.red),
                        title: const Text('Harga', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Rp. ${item['price']}', style: const TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Tambah Riwayat
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTransactionScreen(itemId: item['id']),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna utama tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Membuat tombol lebih melengkung
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15), // Ukuran padding tombol
                ),
                child: const Text(
                  'Tambah Riwayat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
