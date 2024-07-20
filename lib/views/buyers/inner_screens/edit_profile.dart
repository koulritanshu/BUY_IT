import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProfile extends StatefulWidget {
  final dynamic userData;

  EditProfile({super.key, this.userData});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  String? address;
  late String oldImage;

  @override
  void initState() {
    super.initState();
    setState(
      () {
        _fullNameController.text = widget.userData['fullName'];
        _emailController.text = widget.userData['email'];
        _phoneController.text = widget.userData['phoneNumber'];
        _addressController.text = widget.userData['address'];
        oldImage = widget.userData['profileImage'];
      },
    );
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
          'Edit Profile',
          style: TextStyle(
            letterSpacing: 6,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.yellow.shade900,
                        backgroundImage: NetworkImage(
                          oldImage,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 12,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            CupertinoIcons.photo,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Enter full name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Enter phone',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Enter address',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () async {
            EasyLoading.show(
              status: 'Updating',
            );
            await _firebaseFirestore
                .collection('buyers')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update(
              {
                'fullName': _fullNameController.text,
                'phoneNumber': _phoneController.text,
                'address': _addressController.text,
                'email': _emailController.text,
              },
            ).whenComplete(
              () {
                EasyLoading.dismiss();
                Navigator.pop(context);
              },
            );
          },
          child: Container(
            height: 40,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.yellow.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'SAVE',
                style: TextStyle( 
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
