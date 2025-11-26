import 'package:hive/hive.dart';

part 'favorite.g.dart';

@HiveType(typeId: 3)
class Favorite {
  @HiveField(0)
  String productId;

  Favorite(this.productId);
}


