import 'package:buyit/vendors/controllers/vendor_register_controller.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class VendorRegisterationScreen extends StatefulWidget {
  @override
  State<VendorRegisterationScreen> createState() =>
      _VendorRegisterationScreenState();
}

class _VendorRegisterationScreenState extends State<VendorRegisterationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String countryValue;
  late String stateValue;
  late String cityValue;
  late String _businessName;
  late String _email;
  late String _phoneNumber;
  String? taxNumber;

  final VendorController _vendorController = VendorController();

  Uint8List? _image;

  selectGalleryImage() async {
    Uint8List im = await _vendorController.pickStoreImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  List<String> _taxOptions = ['YES', 'NO'];
  String? _taxStatus;

  _saveVendorDetail() async {
    EasyLoading.show(
      status: 'Processing',
    );
    if (_formKey.currentState!.validate()) {
      await _vendorController
          .registerVendor(_businessName, _email, _phoneNumber, countryValue,
              stateValue, cityValue, _taxStatus!, taxNumber!, _image)
          .whenComplete(
        () {
          EasyLoading.dismiss();
          setState(() {
            _formKey.currentState!.reset();
            _image = null;
          });
        },
      );
    } else {
      print('Bad');
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 200,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow,
                          Colors.yellow.shade900,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: _image != null
                                ? Image.memory(_image!)
                                : IconButton(
                                    onPressed: () {
                                      selectGalleryImage();
                                    },
                                    icon: Icon(
                                      CupertinoIcons.photo,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      onChanged: (value) {
                        _businessName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter business name';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Business Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        _email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email address';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        _phoneNumber = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter phone number';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: SelectState(
                        onCountryChanged: (value) {
                          setState(() {
                            countryValue = value;
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            stateValue = value;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            cityValue = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tax Registered?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Flexible(
                            child: Container(
                              width: 200,
                              child: DropdownButtonFormField(
                                hint: Text('Select'),
                                items: _taxOptions
                                    .map<DropdownMenuItem<String>>(
                                        (String value) =>
                                            DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value)))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _taxStatus = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_taxStatus == 'YES')
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          onChanged: (value) {
                            taxNumber = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Tax Number';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Tax Number',
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        _saveVendorDetail();
                      },
                      child: Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
