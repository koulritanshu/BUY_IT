import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class VendorController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  // FUNCTION TO PICK STORE IMAGE
  pickStoreImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No image picket yet');
    }
  }

  // FUNCTION TO UPLOAD VENDOR IMAGE TO STORAGE
  _uploadVendorImageToStorage(Uint8List? image) async {
    Reference ref = await _firebaseStorage
        .ref()
        .child('storeImages')
        .child(_firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // FUNCTION TO SAVE VENDOR DATA
  Future<String> registerVendor(
    String businessName,
    String email,
    String phoneNumber,
    String countryValue,
    String stateValue,
    String cityValue,
    String taxOptions,
    String taxNumber,
    Uint8List? image,
  ) async {
    String res = 'some error occured';
    try {
      if (businessName.isNotEmpty &&
          email.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          countryValue.isNotEmpty &&
          stateValue.isNotEmpty &&
          cityValue.isNotEmpty &&
          taxOptions.isNotEmpty &&
          taxNumber.isNotEmpty &&
          image != null) {
        // Save data to cloud firestore
        String url = await _uploadVendorImageToStorage(image);
        await _firebaseFirestore
            .collection('vendors')
            .doc(_firebaseAuth.currentUser!.uid)
            .set({
          'businessName': businessName,
          'email': email,
          'phoneNumber': phoneNumber,
          'countryValue': countryValue,
          'stateValue': stateValue,
          'cityValue': cityValue,
          'taxStatus': taxOptions,
          'taxNumber': taxNumber,
          'storeImage': url,
          'approved': false,
          'vendorId': _firebaseAuth.currentUser!.uid,
        });
      } else {
        res = 'Fields cannot be empty.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
