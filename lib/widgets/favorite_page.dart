import 'package:flutter/material.dart';

import '../Service/hive_service.dart';
import '../models/product.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Product> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    final ids = HiveService.getFavoritesIds();
    final products =
        HiveService.getAllProducts().where((p) => ids.contains(p.id)).toList();
    setState(() {
      _favorites = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
      ),
      body: _favorites.isEmpty
          ? const Center(child: Text('Aucun favori pour le moment'))
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final product = _favorites[index];
                final isFavorite = HiveService.isFavorite(product.id);
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
                  subtitle: Text('${product.price.toStringAsFixed(2)} €'),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      HiveService.toggleFavorite(product.id);
                      _loadFavorites();
                    },
                  ),
                );
              },
            ),
    );
  }
}


