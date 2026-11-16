import 'package:flutter_test/flutter_test.dart';
import 'package:sankar_connect/core/utils/validators.dart';
import 'package:sankar_connect/models/product_model.dart';
import 'package:sankar_connect/models/cart_item_model.dart';

void main() {
  group('Validators Test Suite', () {
    test('Email validation tests', () {
      expect(Validators.validateEmail(''), 'Please enter an email address');
      expect(Validators.validateEmail('invalid-email'), 'Please enter a valid email address');
      expect(Validators.validateEmail('test@sankargroup.com'), null);
    });

    test('Password validation tests', () {
      expect(Validators.validatePassword(''), 'Please enter a password');
      expect(Validators.validatePassword('12345'), 'Password must be at least 6 characters long');
      expect(Validators.validatePassword('sankar2026'), null);
    });

    test('Name validation tests', () {
      expect(Validators.validateName(''), 'Please enter your full name');
      expect(Validators.validateName('Al'), 'Name must be at least 3 characters long');
      expect(Validators.validateName('Ramesh Kumar'), null);
    });

    test('Phone validation tests', () {
      expect(Validators.validatePhone(''), 'Please enter your contact number');
      expect(Validators.validatePhone('123'), 'Please enter a valid phone number (10-14 digits)');
      expect(Validators.validatePhone('+919876543210'), null);
    });
  });

  group('Product & Cart Model Test Suite', () {
    const testProduct = ProductModel(
      id: 'sg-test-01',
      title: 'MLS Cylinder Gasket',
      sku: 'SG-TEST-01',
      category: 'Gaskets',
      description: 'High performance gasket',
      price: 1500.0,
      minOrderQuantity: 10,
      imageUrl: 'https://example.com/image.jpg',
    );

    test('Product model toMap and fromMap serialization', () {
      final map = testProduct.toMap();
      final reconstructed = ProductModel.fromMap(map);

      expect(reconstructed.id, testProduct.id);
      expect(reconstructed.sku, testProduct.sku);
      expect(reconstructed.price, 1500.0);
    });

    test('CartItemModel calculation test', () {
      final cartItem = CartItemModel(
        product: testProduct,
        quantity: 20,
      );

      expect(cartItem.totalPrice, 30000.0);
    });
  });
}
