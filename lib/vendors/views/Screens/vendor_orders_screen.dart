import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VendorOrdersScreen extends StatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  State<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String formatedDate(date) {
    final outputDateFormat = DateFormat('dd/MM/yyyy');
    final outputDate = outputDateFormat.format(date);
    return outputDate;
  }

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where(
          'vendorId',
          isEqualTo: _firebaseAuth.currentUser!.uid,
        )
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.pink.shade600,
        title: Text(
          'ORDERS',
          style: TextStyle(
            fontSize: 22,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
          // return Container(
          //   height: 500,
          //   child: GridView.builder(
          //     itemCount: snapshot.data!.docs.length,
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       mainAxisSpacing: 8,
          //       crossAxisSpacing: 8,
          //       childAspectRatio: 150 / 300,
          //     ),
          //     itemBuilder: (context, index) {
          //       final currentOrder = snapshot.data!.docs[index];
          //       return Card(
          //         child: Center(
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.all(4.0),
          //                 child: Container(
          //                   height: 150,
          //                   width: 150,
          //                   decoration: BoxDecoration(
          //                     image: DecorationImage(
          //                       image: NetworkImage(
          //                         currentOrder['productImage'][0],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(4.0),
          //                 child: Text(
          //                   'NAME: ' + currentOrder['productName'],
          //                   style: TextStyle(
          //                     fontSize: 20,
          //                     letterSpacing: 3,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(4.0),
          //                 child: Text(
          //                   'QUANTITY: ' +
          //                       currentOrder['productQuantity'].toString(),
          //                   style: TextStyle(
          //                     fontSize: 20,
          //                     letterSpacing: 3,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(4.0),
          //                 child: Text(
          //                   'PRICE: ' + currentOrder['productPrice'].toString(),
          //                   style: TextStyle(
          //                     fontSize: 20,
          //                     letterSpacing: 3,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(4.0),
          //                 child: Text(
          //                   'SCHEDULE : ' +
          //                       currentOrder['productPrice'].toString(),
          //                   style: TextStyle(
          //                     fontSize: 20,
          //                     letterSpacing: 3,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // );
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: document['accepted'] == true
                          ? Icon(Icons.delivery_dining)
                          : Icon(Icons.access_time),
                    ),
                    title: document['accepted'] == true
                        ? Text(
                            'Accepted',
                            style: TextStyle(
                              fontSize: 22,
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade900,
                            ),
                          )
                        : Text(
                            'Not Accepted',
                            style: TextStyle(
                              fontSize: 22,
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                    trailing: Text(
                      'Amount: ' + document['productPrice'].toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      formatedDate(
                        document['orderDate'].toDate(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: ExpansionTile(
                      title: Text(
                        'Order Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Click to view order details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              document['productImage'][0],
                            ),
                          ),
                          title: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              'Name: ' + document['productName'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text(
                                  'Quantity: ' +
                                      document['productQuantity'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              document['accepted'] == true
                                  ? Text('Scheduled Delivery Date: ' +
                                      formatedDate(
                                          document['scheduleDate'].toDate()))
                                  : Text(''),
                              SizedBox(
                                height: 20,
                              ),
                              ListTile(
                                title: Text(
                                  'Buyers Details',
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      document['fullName'],
                                    ),
                                    Text(
                                      document['email'],
                                    ),
                                    Text(
                                      document['address'],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () async {
                          await _firebaseFirestore
                              .collection('orders')
                              .doc(document['orderId'])
                              .update(
                            {
                              'accepted': false,
                            },
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.red,
                          ),
                          child: Center(
                            child: Text(
                              'REJECT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          await _firebaseFirestore
                              .collection('orders')
                              .doc(document['orderId'])
                              .update(
                            {
                              'accepted': true,
                            },
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.green,
                          ),
                          child: Center(
                            child: Text(
                              'ACCEPT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
