import 'package:buyit/provider/product_provider.dart';
import 'package:buyit/vendors/views/Screens/main_vendor_screen.dart';
import 'package:buyit/vendors/views/Screens/upload_tab_screens/attributes_screen.dart';
import 'package:buyit/vendors/views/Screens/upload_tab_screens/general_screen.dart';
import 'package:buyit/vendors/views/Screens/upload_tab_screens/images_screen.dart';
import 'package:buyit/vendors/views/Screens/upload_tab_screens/shipping_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class VendorUploadScreen extends StatefulWidget {
  @override
  State<VendorUploadScreen> createState() => _VendorUploadScreenState();
}

class _VendorUploadScreenState extends State<VendorUploadScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ProductProvider _productProvier =
        Provider.of<ProductProvider>(context);
    return Form(
      key: _formKey,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.yellow.shade900,
            elevation: 0,
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'General',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Shipping',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Attributes',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Images',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              GeneralScreen(),
              ShippingScreen(),
              AttributesScreen(),
              ImagesScreen(),
            ],
          ),
          bottomSheet: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow.shade900,
            ),
            onPressed: () async {
              EasyLoading.show(
                status: 'Uploading data',
              );
              if (_formKey.currentState!.validate()) {
                final productId = Uuid().v4();
                await _firebaseFirestore
                    .collection('products')
                    .doc(productId)
                    .set(
                  {
                    'productId': productId,
                    'productName': _productProvier.productData['productName'],
                    'productPrice': _productProvier.productData['productPrice'],
                    'productQuantity':
                        _productProvier.productData['productQuantity'],
                    'productCategory':
                        _productProvier.productData['productCategory'],
                    'productDescription':
                        _productProvier.productData['productDescription'],
                    'imageUrlList': _productProvier.productData['imageUrlList'],
                    'scheduleDate': _productProvier.productData['scheduleDate'],
                    'chargeShipping':
                        _productProvier.productData['chargeShipping'],
                    'shippingCharges':
                        _productProvier.productData['shippingCharges'],
                    'brandName': _productProvier.productData['brandName'],
                    'sizeList': _productProvier.productData['sizeList'],
                    'vendorId': FirebaseAuth.instance.currentUser!.uid,
                    'approved':false,
                  },
                ).whenComplete(
                  () {
                    EasyLoading.dismiss();
                    _productProvier.clearData();
                    _formKey.currentState!.reset();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MainVendorScreen();
                        },
                      ),
                    );
                  },
                );
              }
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
