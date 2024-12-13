class Item {
  final int? id;
  final String name;
  final String description;
  final String category;
  final double price;
  final int stock;
  final String imagePath;

  Item({
    this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    required this.stock,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'stock': stock,
      'imagePath': imagePath,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      stock: map['stock'],
      imagePath: map['imagePath'],
    );
  }
}
