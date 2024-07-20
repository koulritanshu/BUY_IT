import 'package:buyit/models/cart_attributes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};

  Map<String, CartAttr> get getCartItem {
    return _cartItems;
  }

  void addProductToCart(
    String productName,
    String productId,
    List imageUrlList,
    int quantity,
    double productPrice,
    String vendorId,
    String productSize,
    Timestamp scheduleTime,
    int productQuantity,
  ) {
    if (_cartItems.containsKey(productId) == true) {
      _cartItems.update(
        productId,
        (existingCart) => CartAttr(
          productName: existingCart.productName,
          productId: existingCart.productId,
          imageUrlList: existingCart.imageUrlList,
          quantity: existingCart.quantity + 1,
          productPrice: existingCart.productPrice,
          vendorId: existingCart.vendorId,
          productSize: existingCart.productSize,
          scheduleTime: existingCart.scheduleTime,
          productQuantity: existingCart.productQuantity,
        ),
      );
      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartAttr(
          productName: productName,
          productId: productId,
          imageUrlList: imageUrlList,
          quantity: 1,
          productPrice: productPrice,
          vendorId: vendorId,
          productSize: productSize,
          scheduleTime: scheduleTime,
          productQuantity: productQuantity,
        ),
      );
      notifyListeners();
    }
  }

  double getTotalPrice() {
    var total = 0.0;
    _cartItems.forEach(
      (key, value) {
        total += value.productPrice * value.quantity;
      },
    );
    return total;
  }

  void increment(CartAttr) {
    CartAttr.increase();
    notifyListeners();
  }

  void decrement(CartAttr) {
    CartAttr.decrease();
    notifyListeners();
  }

  void delete(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void removeAllItems() {
    _cartItems.clear();
    notifyListeners();
  }
}
