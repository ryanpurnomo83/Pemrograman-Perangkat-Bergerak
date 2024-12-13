import 'package:flutter/material.dart';
import 'dart:io';
import '/db/database_helper.dart';
import 'item_detail_screen.dart';
import 'add_item_screen.dart';

class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  late Future<List<Map<String, dynamic>>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    _itemsFuture = DatabaseHelper().getItems();
  }

  void _deleteItem(int id) async {
    await DatabaseHelper().deleteItem(id);
    setState(() {
      _loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Barang'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _itemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data yang ditemukan.'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemDetailScreen(item: item),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: item['imagePath'] != null && item['imagePath'].isNotEmpty
                          ? FileImage(File(item['imagePath']))
                          : AssetImage('assets/item_placeholder.png') as ImageProvider,
                    ),
                    title: Text(item['name']),
                    subtitle: Text('Kategori: ${item['category']} - Stok: ${item['stock']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteItem(item['id']),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );
          setState(() {
            _loadItems();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
