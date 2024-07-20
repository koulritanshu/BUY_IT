import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuyerOrderScreen extends StatefulWidget {
  @override
  State<BuyerOrderScreen> createState() => _BuyerOrderScreenState();
}

class _BuyerOrderScreenState extends State<BuyerOrderScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
      .collection('orders')
      .where(
        'buyerId',
        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
      )
      .snapshots();

  String formatDate(date) {
    final outputDateFormat = DateFormat('dd/MM/yyyy');
    final outputDate = outputDateFormat.format(date);
    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        elevation: 3,
        backgroundColor: Colors.yellow.shade900,
        title: Text(
          'Orders',
          style: TextStyle(
            fontSize: 24,
            letterSpacing: 6,
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
            return Center(
              child: CircularProgressIndicator(
                color: Colors.yellow.shade900,
              ),
            );
          }

          return Container(
            height: 400,
            width: 400,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final currentOrder = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          currentOrder['productImage'][0],
                        ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        currentOrder['productName'],
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹' + currentOrder['productPrice'].toString(),
                        ),
                        Text(
                          currentOrder['productQuantity'].toString() + ' units',
                        ),
                      ],
                    ),
                    trailing: Text(
                      'Estimated Delivery: ' +
                          formatDate(currentOrder['scheduleDate'].toDate()),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
