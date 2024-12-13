import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/models/item_model.dart';
import '/models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const _databaseName = "inventory_management.db";
  static const _databaseVersion = 1;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Tambahkan onUpgrade untuk migrasi skema
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price REAL,
        stock INTEGER,
        imagePath TEXT 
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itemId INTEGER NOT NULL,
        transactionType TEXT NOT NULL, 
        quantity INTEGER NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (itemId) REFERENCES items (id) ON DELETE CASCADE
      )
    ''' );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE items ADD COLUMN description TEXT");
      await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itemId INTEGER NOT NULL,
        transactionType TEXT NOT NULL, 
        quantity INTEGER NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (itemId) REFERENCES items (id) ON DELETE CASCADE
      )
    ''' );
    }
  }

  Future<int> insertItem(Map<String, dynamic> item) async {
    final db = await database;
    return await db.insert('items', item);
  }

  Future<int> updateItem(int id, Map<String, dynamic> item) async {
    final db = await database;
    return await db.update('items', item, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getItemById(int id) async {
    final db = await database;
    final results = await db.query('items', where: 'id = ?', whereArgs: [id]);
    if (results.isNotEmpty) return results.first;
    return null;
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query('items');
  }

  Future<void> clearItems() async {
    final db = await database;
    await db.delete('items');
  }

  /// Fungsi untuk menyisipkan riwayat transaksi ke dalam tabel `transactions`
  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction);
  }

  /// Fungsi untuk memperbarui stok barang berdasarkan id item dan jumlah
  Future<int> updateItemStock(int itemId, int quantity, String transactionType) async {
    final db = await database;
    final currentItem = await getItemById(itemId);
    if (currentItem != null) {
      int currentStock = currentItem['stock'] ?? 0;

      if (transactionType == 'masuk') {
        currentStock += quantity;
      } else if (transactionType == 'keluar') {
        currentStock -= quantity;
      }

      if (currentStock < 0) {
        currentStock = 0; // Pastikan stok tidak negatif
      }

      return await updateItem(itemId, {'stock': currentStock});
    } else {
      throw Exception("Item not found");
    }
  }
}
