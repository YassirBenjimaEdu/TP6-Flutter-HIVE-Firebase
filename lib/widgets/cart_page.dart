import 'package:flutter/material.dart';

import '../Service/hive_service.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    setState(() {
      _items = HiveService.getCartItems();
    });
  }

  double get _total {
    double sum = 0;
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      final Product? p = HiveService.getProductById(item.productId);
      if (p != null) {
        sum += p.price * item.quantity;
      }
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              HiveService.clearCart();
              _loadCart();
            },
          )
        ],
      ),
      body: _items.isEmpty
          ? const Center(child: Text('Votre panier est vide'))
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final product = HiveService.getProductById(item.productId);
                if (product == null) {
                  return const SizedBox.shrink();
                }
                return ListTile(
                  leading: product.image.isNotEmpty
                      ? Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(product.name),
                  subtitle: Text(
                      'Qté: ${item.quantity}  -  ${(product.price * item.quantity).toStringAsFixed(2)} €'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      HiveService.removeFromCart(index);
                      _loadCart();
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Theme.of(context).colorScheme.surface,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total : ${_total.toStringAsFixed(2)} €',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: _items.isEmpty ? null : () {},
              child: const Text('Commander'),
            ),
          ],
        ),
      ),
    );
  }
}


