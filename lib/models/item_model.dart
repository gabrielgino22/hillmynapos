import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String name;
  final double price;
  final String? imageUrl;
  final String details;
  final int stock;
  final bool isAvailable;
  final String categoryId;
  final String serviceId;

  Item({
    required this.id,
    required this.name,
    required this.price,
    this.imageUrl,
    required this.details,
    required this.stock,
    required this.isAvailable,
    required this.categoryId,
    required this.serviceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'details': details,
      'stock': stock,
      'isAvailable': isAvailable,
      'categoryId': categoryId,
      'serviceId': serviceId,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
