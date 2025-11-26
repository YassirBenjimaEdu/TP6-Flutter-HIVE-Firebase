import 'package:hive_flutter/hive_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/favorite.dart';

class HiveService {
  static late Box<Product> _productBox;
  static late Box<CartItem> _cartBox;
  static late Box<Favorite> _favoritesBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ProductAdapter());
    Hive.registerAdapter(CartItemAdapter());
    Hive.registerAdapter(FavoriteAdapter());

    _productBox = await Hive.openBox<Product>('products');
    _cartBox = await Hive.openBox<CartItem>('cart');
    _favoritesBox = await Hive.openBox<Favorite>('favorites');
  }

  // Produits
  static List<Product> getAllProducts() => _productBox.values.toList();

  static void addProduct(Product p) {
    _productBox.put(p.id, p);
    FirebaseService.addProduct(p);
  }

  static void deleteProduct(String id) => _productBox.delete(id);

  static Product? getProductById(String id) => _productBox.get(id);

  // Panier
  static List<CartItem> getCartItems() => _cartBox.values.toList();

  static void addToCart(Product p) {
    final index =
        _cartBox.values.toList().indexWhere((e) => e.productId == p.id);

    if (index == -1) {
      _cartBox.add(CartItem(productId: p.id, quantity: 1));
    } else {
      final item = _cartBox.getAt(index)!;
      _cartBox.putAt(
        index,
        CartItem(productId: item.productId, quantity: item.quantity + 1),
      );
    }
  }

  static void removeFromCart(int index) => _cartBox.deleteAt(index);

  static void clearCart() => _cartBox.clear();

  // Favoris
  static List<String> getFavoritesIds() =>
      _favoritesBox.values.map((f) => f.productId).toList();

  static bool isFavorite(String id) => getFavoritesIds().contains(id);

  static void toggleFavorite(String id) {
    final index =
        _favoritesBox.values.toList().indexWhere((f) => f.productId == id);

    if (index == -1) {
      _favoritesBox.add(Favorite(id));
    } else {
      _favoritesBox.deleteAt(index);
    }
  }
}

class FirebaseService {
  static final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  static Future<void> addProduct(Product p) async {
    await productsRef.doc(p.id).set(p.toMap());
  }

  static Future<List<Product>> getAllProducts() async {
    final snapshot = await productsRef.get();
    return snapshot.docs
        .map((doc) =>
            Product.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}


