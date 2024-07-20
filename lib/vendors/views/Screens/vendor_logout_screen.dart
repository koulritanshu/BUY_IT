import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorLogoutScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text('Log Out'),
          onPressed: () {
            _auth.signOut();
          },
        ),
      ),
    );
  }
}
