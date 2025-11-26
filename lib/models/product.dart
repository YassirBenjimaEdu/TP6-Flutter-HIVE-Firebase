import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Product.fromMap(String id, Map<String, dynamic> map) => Product(
        id: id,
        name: map['name'] ?? '',
        price: (map['price'] ?? 0).toDouble(),
        image: map['image'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'price': price,
        'image': image,
      };
}


