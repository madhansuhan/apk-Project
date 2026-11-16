import 'dart:convert';

class ProductModel {
  final String id;
  final String title;
  final String sku;
  final String category;
  final String description;
  final double price;
  final int minOrderQuantity;
  final double rating;
  final int reviewCount;
  final String stockStatus; // 'In Stock', 'Lead Time: 5 Days', 'Custom Order'
  final String imageUrl;
  final List<String> gallery;
  final Map<String, String> specifications;
  final List<String> applications;
  final bool isFeatured;
  final String materialGrade;

  const ProductModel({
    required this.id,
    required this.title,
    required this.sku,
    required this.category,
    required this.description,
    required this.price,
    this.minOrderQuantity = 10,
    this.rating = 4.8,
    this.reviewCount = 24,
    this.stockStatus = 'In Stock',
    required this.imageUrl,
    this.gallery = const [],
    this.specifications = const {},
    this.applications = const [],
    this.isFeatured = false,
    this.materialGrade = 'OEM Grade',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'sku': sku,
      'category': category,
      'description': description,
      'price': price,
      'minOrderQuantity': minOrderQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
      'stockStatus': stockStatus,
      'imageUrl': imageUrl,
      'gallery': gallery,
      'specifications': specifications,
      'applications': applications,
      'isFeatured': isFeatured,
      'materialGrade': materialGrade,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id']?.toString() ?? '',
      title: map['title'] ?? map['name'] ?? '',
      sku: map['sku'] ?? 'SKU-${map['id'] ?? '000'}',
      category: map['category'] ?? 'General',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      minOrderQuantity: (map['minOrderQuantity'] as num?)?.toInt() ?? 10,
      rating: (map['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 12,
      stockStatus: map['stockStatus'] ?? 'In Stock',
      imageUrl: map['imageUrl'] ?? map['thumbnail'] ?? '',
      gallery: List<String>.from(map['gallery'] ?? (map['images'] ?? [])),
      specifications: Map<String, String>.from(map['specifications'] ?? {}),
      applications: List<String>.from(map['applications'] ?? []),
      isFeatured: map['isFeatured'] ?? false,
      materialGrade: map['materialGrade'] ?? 'OEM Spec',
    );
  }

  // Adapter for public DummyJSON API if used
  factory ProductModel.fromDummyJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      sku: 'SG-DJ-${json['id']}',
      category: json['category'] ?? 'General',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 49.99,
      minOrderQuantity: 5,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: (json['stock'] as num?)?.toInt() ?? 30,
      stockStatus: (json['stock'] != null && json['stock'] > 0)
          ? 'In Stock (${json['stock']} units)'
          : 'Backorder',
      imageUrl: json['thumbnail'] ?? '',
      gallery: List<String>.from(json['images'] ?? []),
      specifications: {
        'Brand': json['brand'] ?? 'Industrial Standard',
        'Category': json['category'] ?? 'Component',
        'Discount': '${json['discountPercentage'] ?? 0}% off MOQ',
      },
      applications: ['Automotive', 'Industrial Machinery', 'Assembly Lines'],
      isFeatured: (json['rating'] as num? ?? 0) > 4.5,
      materialGrade: 'Standard Certified',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
