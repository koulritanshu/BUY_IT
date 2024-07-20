import 'package:buyit/vendors/views/Screens/vendor_product_details/vendor_product_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Published extends StatefulWidget {
  @override
  State<Published> createState() => _PublishedState();
}

class _PublishedState extends State<Published> {
  final Stream<QuerySnapshot> _vendorsProductStream = FirebaseFirestore.instance
      .collection('products')
      .where(
        'vendorId',
        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
      )
      .where('approved', isEqualTo: true)
      .snapshots();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _vendorsProductStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went  wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'NO UNPUBLISHED PRODUCTS',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          );
        }

        return Container(
          height: 150,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final vendorProductsData = snapshot.data!.docs[index];
              return Slidable(
                key: const ValueKey(0),
                startActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      flex: 2,
                      onPressed: (context) async {
                        await _firebaseFirestore
                            .collection('products')
                            .doc(vendorProductsData['productId'])
                            .update(
                          {
                            'approved': false,
                          },
                        );
                      },
                      backgroundColor: Color(0xFF21B7CA),
                      foregroundColor: Colors.white,
                      icon: Icons.approval_rounded,
                      label: 'Unpublish',
                    ),
                    SlidableAction(
                      flex: 2,
                      onPressed: (context) async {
                        await _firebaseFirestore
                            .collection('products')
                            .doc(vendorProductsData['productId'])
                            .delete();
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VendorProductDetail(
                          productData: vendorProductsData,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          child: Image.network(
                            vendorProductsData['imageUrlList'][0],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vendorProductsData['productName'],
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '₹' +
                                    vendorProductsData['productPrice']
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
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
        );
      },
    );
  }
}
