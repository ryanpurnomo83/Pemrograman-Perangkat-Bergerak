import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> insertItem(Map<String, dynamic> item) async {
    try {
      await _firestore.collection('items').add(item);
    } catch (e) {
      throw Exception("Error inserting item: $e");
    }
  }

  Future<void> updateItem(String id, Map<String, dynamic> item) async {
    try {
      await _firestore.collection('items').doc(id).update(item);
    } catch (e) {
      throw Exception("Error updating item: $e");
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _firestore.collection('items').doc(id).delete();
    } catch (e) {
      throw Exception("Error deleting item: $e");
    }
  }

  Future<Map<String, dynamic>?> getItemById(String id) async {
    try {
      final doc = await _firestore.collection('items').doc(id).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching item: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    try {
      final querySnapshot = await _firestore.collection('items').get();
      if (querySnapshot.docs.isEmpty) {
        return [];
      }
      return querySnapshot.docs.map((doc) => {
        ...doc.data(),
        'id': doc.id,
      }).toList();
    } catch (e) {
      throw Exception("Error fetching items: $e");
    }
  }

  Future<void> clearItems() async {
    try {
      final querySnapshot = await _firestore.collection('items').get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception("Error clearing items: $e");
    }
  }

  Future<void> insertTransaction(Map<String, dynamic> transaction) async {
    try {
      await _firestore.collection('transactions').add(transaction);
    } catch (e) {
      throw Exception("Error inserting transaction: $e");
    }
  }

  Future<void> updateItemStock(String itemId, int quantity, String transactionType) async {
    try {
      final itemDoc = await _firestore.collection('items').doc(itemId).get();

      if (itemDoc.exists) {
        int currentStock = itemDoc['stock'] ?? 0;

        if (transactionType == 'masuk') {
          currentStock += quantity;
        } else if (transactionType == 'keluar') {
          currentStock -= quantity;
        }

        if (currentStock < 0) {
          currentStock = 0;
        }

        await updateItem(itemId, {'stock': currentStock});
      } else {
        throw Exception("Item not found");
      }
    } catch (e) {
      throw Exception("Error updating stock: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getTransactions(String itemId) async {
    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('itemId', isEqualTo: itemId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        print("Fetched Transaction: ${doc.data()}");
        return {
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        };
      }).toList();
    } catch (e) {
      throw Exception("Error fetching transactions: $e");
    }
  }
}
