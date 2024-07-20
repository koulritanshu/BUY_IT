import 'package:buyit/provider/cart_provider.dart';
import 'package:buyit/views/buyers/inner_screens/checkout_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return _cartProvider.getCartItem.length == 0
        ? EmptyCart()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.yellow.shade900,
              elevation: 0,
              title: Text(
                'Cart Screen',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    _cartProvider.removeAllItems();
                  },
                  icon: Icon(
                    CupertinoIcons.delete,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: _cartProvider.getCartItem.length,
              itemBuilder: (context, index) {
                final cartData =
                    _cartProvider.getCartItem.values.toList()[index];
                return Card(
                  child: SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.network(
                            cartData.imageUrlList[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cartData.productName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 5,
                                ),
                              ),
                              Text(
                                '₹' + cartData.productPrice.toStringAsFixed(2),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 5,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.yellow.shade900,
                                ),
                                onPressed: null,
                                child: Text(
                                  cartData.productSize,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade900,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            _cartProvider.decrement(cartData);
                                            if (cartData.quantity == 0) {
                                              _cartProvider
                                                  .delete(cartData.productId);
                                            }
                                          },
                                          icon: Icon(
                                            CupertinoIcons.minus,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          cartData.quantity.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 5,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: (cartData.quantity >=
                                                  cartData.productQuantity)
                                              ? null
                                              : () {
                                                  _cartProvider
                                                      .increment(cartData);
                                                },
                                          icon: Icon(
                                            CupertinoIcons.add,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _cartProvider.delete(cartData.productId);
                                    },
                                    icon: Icon(
                                      CupertinoIcons.delete,
                                      size: 30,
                                      color: Colors.yellow.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Price: ₹' +
                          _cartProvider.getTotalPrice().toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellow.shade900,
                      ),
                      child: InkWell(
                        onTap: () {
                          _cartProvider.getCartItem.length != 0
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CheckoutScreen();
                                    },
                                  ),
                                )
                              : null;
                        },
                        child: Center(
                          child: Text(
                            'CHECKOUT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 6,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your shopping cart is empty',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'CONTINUE SHOPPING',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
