import 'package:buyit/provider/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GeneralScreen extends StatefulWidget {
  @override
  State<GeneralScreen> createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> _categories = [];

  _getCategories() async {
    await _firestore.collection('categories').get().then(
      (QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            setState(
              () {
                _categories.add(doc['categoryName']);
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  String formattedDate(date) {
    final outputDateFormat = DateFormat('dd/MM/yyyy');

    final outputDate = outputDateFormat.format(date);
    return outputDate;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProductProvider _productProvider =
        Provider.of<ProductProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter product name';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _productProvider.getFormData(productName: value);
                },
                decoration: InputDecoration(
                  labelText: 'Enter product name',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter product price';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _productProvider.getFormData(
                      productPrice: double.parse(value));
                },
                decoration: InputDecoration(
                  labelText: 'Enter product price',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter product quantity';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _productProvider.getFormData(
                      productQuantity: int.parse(value));
                },
                decoration: InputDecoration(
                  labelText: 'Enter product quantity',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              DropdownButtonFormField(
                hint: Text(
                  'Select category',
                ),
                items: _categories.map<DropdownMenuItem<String>>(
                  (e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                      ),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  _productProvider.getFormData(productCategory: value);
                },
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter product description';
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  _productProvider.getFormData(productDescription: value);
                },
                maxLines: 10,
                maxLength: 800,
                decoration: InputDecoration(
                  labelText: 'Enter product description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    child: Text(
                      'SCHEDULE',
                    ),
                    onPressed: () {
                      showOmniDateTimePicker(
                        context: context,
                        type: OmniDateTimePickerType.date,
                        firstDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      ).then(
                        (value) {
                          setState(
                            () {
                              _productProvider.getFormData(scheduleDate: value);
                            },
                          );
                        },
                      );
                    },
                  ),
                  if (_productProvider.productData['scheduleDate'] != null)
                    Text(
                      formattedDate(
                          _productProvider.productData['scheduleDate']),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
