import 'package:buyit/vendors/views/Screens/vendor_inner_screen/withdrawal_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorEarningScreen extends StatefulWidget {
  const VendorEarningScreen({super.key});

  @override
  State<VendorEarningScreen> createState() => _VendorEarningScreenState();
}

class _VendorEarningScreenState extends State<VendorEarningScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('vendors');

    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where(
          'vendorId',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .snapshots();

    // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    // String vendorIdOfSignedInUser = _firebaseAuth.currentUser!.uid;

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
              centerTitle: true,
              backgroundColor: Colors.pink.shade600,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.yellow.shade900,
                    backgroundImage: NetworkImage(
                      data['storeImage'],
                    ),
                  ),
                  Text(
                    'Welcome ' + data['businessName'],
                    style: TextStyle(
                      fontSize: 22,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 140,
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _ordersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("Loading");
                }

                double totalEarnings = 0.0;
                for (var orderItem in snapshot.data!.docs) {
                  // if (orderItem['vendorId'] == vendorIdOfSignedInUser) {
                  totalEarnings +=
                      orderItem['productQuantity'] * orderItem['productPrice'];
                  // }
                }

                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow.shade600,
                                Colors.pink.shade900,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'TOTAL EARNINGS',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  '₹' + totalEarnings.toString(),
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow.shade600,
                                Colors.pink.shade900,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'TOTAL ORDERS',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return WithdrawalScreen();
                            }),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.purple.shade900,
                              Colors.pink,
                            ]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'WITHDRAW',
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 6,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
