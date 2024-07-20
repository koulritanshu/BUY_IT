import 'package:buyit/views/buyers/auth/register_screen.dart';
import 'package:buyit/views/buyers/inner_screens/buyer_orders_screen.dart';
import 'package:buyit/views/buyers/inner_screens/edit_profile.dart';
import 'package:buyit/views/buyers/nav_screens/cart_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('buyers');
    return _firebaseAuth.currentUser == null
        ? Scaffold(
            appBar: AppBar(
              elevation: 2,
              backgroundColor: Colors.yellow.shade900,
              centerTitle: true,
              title: Text(
                'Profile',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(
                    Icons.wb_sunny,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Login to access your account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 6,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return BuyerRegisterScreen();
                          },
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : FutureBuilder<DocumentSnapshot>(
            future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                    elevation: 2,
                    backgroundColor: Colors.yellow.shade900,
                    centerTitle: true,
                    title: Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 4,
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Icon(
                          Icons.wb_sunny,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: CircleAvatar(
                          radius: 64,
                          backgroundColor: Colors.yellow.shade900,
                          backgroundImage: NetworkImage(data['profileImage']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['fullName'],
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['email'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EditProfile(
                                  userData: data,
                                );
                              },
                            ),
                          );
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'EDIT',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.settings,
                          ),
                          title: Text(
                            'Settings',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(
                            Icons.phone,
                          ),
                          title: Text(
                            'Phone',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return CartScreen();
                                },
                              ),
                            );
                          },
                          leading: Icon(
                            Icons.shopping_cart,
                          ),
                          title: Text(
                            'Cart',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return BuyerOrderScreen();
                                },
                              ),
                            );
                          },
                          leading: Icon(
                            Icons.shopping_cart,
                          ),
                          title: Text(
                            'Orders',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () async {
                            await _firebaseAuth.signOut().whenComplete(
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return BuyerRegisterScreen();
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          leading: Icon(
                            Icons.logout,
                          ),
                          title: Text(
                            'Logout',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Text("loading");
            },
          );
  }
}
