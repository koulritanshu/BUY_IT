import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorProductDetail extends StatefulWidget {
  final dynamic productData;

  const VendorProductDetail({super.key, this.productData});

  @override
  State<VendorProductDetail> createState() => _VendorProductDetailState();
}

class _VendorProductDetailState extends State<VendorProductDetail> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    setState(
      () {
        _nameController.text = widget.productData['productName'];
        _brandNameController.text = widget.productData['brandName'];
        _priceController.text = widget.productData['productPrice'].toString();
        _quantityController.text =
            widget.productData['productQuantity'].toString();
        _descriptionController.text = widget.productData['productDescription'];
        _descriptionController.text = widget.productData['productDescription'];
        _categoryController.text = widget.productData['productCategory'];
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
          widget.productData['productName'],
          style: TextStyle(
            letterSpacing: 6,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _brandNameController,
                decoration: InputDecoration(
                  labelText: 'Product Brand',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Product Quantity',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Product Price',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLength: 800,
                maxLines: 3,
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Product Description',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                enabled: false,
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: InkWell(
        onTap: () async {
          await _firebaseFirestore
              .collection('products')
              .doc(widget.productData['productId'])
              .update(
            {
              'productName': _nameController.text,
              'brandName': _brandNameController.text,
              'productQuantity': int.parse(_quantityController.text),
              'productPrice': double.parse(_priceController.text),
              'productDescription': _descriptionController.text,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Container(
            height: 60,
            width: 180,
            decoration: BoxDecoration(
              color: Colors.yellow.shade900,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'UPDATE',
                style: TextStyle(
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
