import 'package:hive/hive.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 2)
class CartItem {
  @HiveField(0)
  String productId;

  @HiveField(1)
  int quantity;

  CartItem({
    required this.productId,
    required this.quantity,
  });
}


