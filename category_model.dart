import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final int itemCount;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.itemCount = 0,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      icon: Icons.precision_manufacturing_outlined,
      itemCount: map['itemCount'] ?? 0,
    );
  }
}
