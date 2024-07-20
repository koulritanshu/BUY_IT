import 'package:buyit/vendors/models/vendors_user_models.dart';
import 'package:buyit/vendors/views/Screens/main_vendor_screen.dart';
import 'package:buyit/vendors/views/auth/vendor_registeration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CollectionReference _vendorsStream =
        FirebaseFirestore.instance.collection('vendors');
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _vendorsStream.doc(_auth.currentUser!.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          if (!snapshot.data!.exists) {
            return VendorRegisterationScreen();
          }

          VendorUserModel vendorUserModel = VendorUserModel.fromJson(
              snapshot.data!.data()! as Map<String, dynamic>);

          if (vendorUserModel.approved == true) {
            return MainVendorScreen();
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      vendorUserModel.storeImage.toString(),
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    vendorUserModel.businessName.toString(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Your application has been sent to shop admin\n Admin will get back to you soon',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    child: Text(
                      'Sign Out',
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
