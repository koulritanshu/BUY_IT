import 'package:buyit/provider/cart_provider.dart';
import 'package:buyit/views/buyers/inner_screens/edit_profile.dart';
import 'package:buyit/views/buyers/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              elevation: 3,
              backgroundColor: Colors.yellow.shade900,
              title: Text(
                'Checkout',
                style: TextStyle(
                  letterSpacing: 6,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: _cartProvider.getCartItem.length,
              itemBuilder: (context, index) {
                final cartData =
                    _cartProvider.getCartItem.values.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  '₹' +
                                      cartData.productPrice.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 5,
                                  ),
                                ),
                                Text(
                                  'Quantity: ' +
                                      cartData.productQuantity.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 5,
                                  ),
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            bottomSheet: data['address'] == ''
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade900,
                      minimumSize: Size(200, 60),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return EditProfile(
                              userData: data,
                            );
                          },
                        ),
                      ).whenComplete(() => Navigator.pop(context));
                    },
                    child: Text(
                      'Enter billing address',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                        letterSpacing: 5,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Total Price: ₹' +
                                _cartProvider
                                    .getTotalPrice()
                                    .toStringAsFixed(2),
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
                            width: MediaQuery.of(context).size.width - 230,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.yellow.shade900,
                            ),
                            child: InkWell(
                              onTap: () {
                                EasyLoading.show(status: 'Placing Order');
                                _cartProvider.getCartItem.forEach(
                                  (key, value) {
                                    final orderId = Uuid().v4();
                                    _firebaseFirestore
                                        .collection('orders')
                                        .doc(orderId)
                                        .set(
                                      {
                                        'orderId': orderId,
                                        'vendorId': value.vendorId,
                                        'email': data['email'],
                                        'phone': data['phoneNumber'],
                                        'address': data['address'],
                                        'buyerId': data['buyerId'],
                                        'fullName': data['fullName'],
                                        'buyerPhoto': data['profileImage'],
                                        'productName': value.productName,
                                        'productPrice': value.productPrice,
                                        'productId': value.productId,
                                        'scheduleDate': value.scheduleTime,
                                        'productImage': value.imageUrlList,
                                        'productQuantity':
                                            value.productQuantity,
                                        'productSize': value.productSize,
                                        'orderDate': DateTime.now(),
                                        'accepeted': false,
                                      },
                                    ).whenComplete(
                                      () {
                                        EasyLoading.dismiss();
                                        setState(
                                          () {
                                            _cartProvider.removeAllItems();
                                          },
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return MainScreen();
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: Center(
                                child: Text(
                                  'Place Order',
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
        return Center(
          child: CircularProgressIndicator(
            color: Colors.yellow.shade900,
          ),
        );
      },
    );
  }
}
