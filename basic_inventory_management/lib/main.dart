import 'package:flutter/material.dart';
import 'screens/item_list_screen.dart';
import 'screens/add_item_screen.dart';
import 'screens/item_detail_screen.dart';
import 'screens/add_transaction_screen.dart';

void main() {
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventory Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ItemListScreen(),
        '/add-item': (context) => const AddItemScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/item-detail') {
          final item = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ItemDetailScreen(item: item),
          );
        } else if (settings.name == '/add-transaction') {
          final itemId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => AddTransactionScreen(itemId: itemId),
          );
        }
        return null;
      },
    );
  }
}
