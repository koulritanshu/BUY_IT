import 'package:buyit/provider/product_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ImagesScreen extends StatefulWidget {
  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final ImagePicker _imagePicker = ImagePicker();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  List<File> _image = [];
  List<String> _imageUrlList = [];
  List<Color> white = [Colors.white];
  List<Color> yellowones = [Colors.yellow.shade900, Colors.yellow.shade700];

  chooseImage() async {
    XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      print("No file picked");
    } else {
      setState(
        () {
          _image.add(File(pickedFile.path));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            itemCount: _image.length + 1,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              childAspectRatio: 3 / 3,
            ),
            itemBuilder: (context, index) {
              return index == 0
                  ? Center(
                      child: IconButton(
                        onPressed: () {
                          chooseImage();
                        },
                        icon: Icon(Icons.add),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        setState(
                          () {
                            _image.removeAt(index - 1);
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(_image[index - 1]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
            },
          ),
          SizedBox(
            height: 30,
          ),
          if (_image.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(colors: yellowones),
              ),
              child: TextButton(
                onPressed: () async {
                  EasyLoading.show(
                    status: 'Saving Images',
                  );
                  for (var img in _image) {
                    Reference ref = _firebaseStorage
                        .ref()
                        .child('productImage')
                        .child(Uuid().v4());
                    await ref.putFile(img).whenComplete(
                      () async {
                        await ref.getDownloadURL().then(
                          (value) {
                            setState(
                              () {
                                _imageUrlList.add(value);
                              },
                            );
                          },
                        );
                      },
                    );
                  }
                  setState(
                    () {
                      _productProvider.getFormData(imageUrlList: _imageUrlList);

                      EasyLoading.dismiss();
                    },
                  );
                },
                child: Text(
                  _image.isNotEmpty ? 'UPLOAD' : '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
