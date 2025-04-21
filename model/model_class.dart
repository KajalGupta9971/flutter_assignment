
import 'package:flutter/foundation.dart';

@immutable
class Category {
  final String id;
  final String name;
  final String imageUrl; // Let's assume a dummy image URL or asset path


  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  // Factory constructor from a Map (e.g., JSON)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  // Method to convert instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  // copyWith method to create a new instance with modified properties
  Category copyWith({
    String? id,
    String? name,
    String? imageUrl,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }


  @override
  String toString() => 'Category(id: $id, name: $name, imageUrl: $imageUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ imageUrl.hashCode;
}