import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../services/storage_service.dart';

class CartProvider extends ChangeNotifier {
  final StorageService _storageService;
  List<CartItemModel> _items = [];

  CartProvider(this._storageService) {
    _loadCart();
  }

  List<CartItemModel> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  int get uniqueItemCount => _items.length;
  double get totalEstimatedAmount =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get isEmpty => _items.isEmpty;

  void _loadCart() {
    _items = _storageService.getCartItems();
    notifyListeners();
  }

  Future<void> _saveCart() async {
    await _storageService.saveCartItems(_items);
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  int getQuantity(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    return index != -1 ? _items[index].quantity : 0;
  }

  Future<void> addItem(ProductModel product, {int quantity = 1, String? notes}) async {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(
        CartItemModel(
          product: product,
          quantity: quantity > 0 ? quantity : product.minOrderQuantity,
          customNotes: notes,
        ),
      );
    }
    notifyListeners();
    await _saveCart();
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (newQuantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
      await _saveCart();
    }
  }

  Future<void> removeItem(String productId) async {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
    await _saveCart();
  }

  Future<void> clearCart() async {
    _items.clear();
    notifyListeners();
    await _saveCart();
  }
}
