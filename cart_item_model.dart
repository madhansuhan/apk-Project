import 'dart:convert';
import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  final String? customNotes;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.customNotes,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'customNotes': customNotes,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      product: ProductModel.fromMap(map['product']),
      quantity: map['quantity'] ?? 1,
      customNotes: map['customNotes'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source));
}
