// lib/features/category/presentation/widgets/category_grid_item.dart
import 'package:flutter/material.dart';

import '../../model/model_class.dart';


class CategoryGridItem extends StatelessWidget {
  final Category category;


  const CategoryGridItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            category.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        child: Image.network(
          category.imageUrl,
          fit: BoxFit.fill,

          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.broken_image, size: 40));
          },
        ),
      ),
    );
  }
}