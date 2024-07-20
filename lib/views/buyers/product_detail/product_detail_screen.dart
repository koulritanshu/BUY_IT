import 'package:buyit/provider/cart_provider.dart';
import 'package:buyit/utils/show_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, this.productData});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _imageIndex = 0;

  String _formattedDate(date) {
    final outputDateFormat = DateFormat('dd/MM/yyyy');
    final output = outputDateFormat.format(date);
    return output;
  }

  String? _selectedSize;

  @override
  Widget build(BuildContext context) {
    final CartProvider _cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          widget.productData['productName'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 370,
                  width: double.infinity,
                  child: PhotoView(
                    backgroundDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    imageProvider: NetworkImage(
                      widget.productData['imageUrlList'][_imageIndex],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productData['imageUrlList'].length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(
                              () {
                                _imageIndex = index;
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.yellow.shade900,
                              )),
                              height: 60,
                              width: 60,
                              child: Image.network(
                                widget.productData['imageUrlList'][index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'PRICE: ₹' +
                  widget.productData['productPrice'].toStringAsFixed(2),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 3,
              ),
            ),
            Text(
              'NAME: ' + widget.productData['productName'],
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 4,
              ),
            ),
            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Product Description',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'View More',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productData['productDescription'],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    'This product will be shipped by ' +
                        _formattedDate(
                          widget.productData['scheduleDate'].toDate(),
                        ),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Available Size',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              children: [
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.productData['sizeList'].length,
                    itemBuilder: (context, index) {
                      return OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedSize ==
                                  widget.productData['sizeList'][index]
                              ? Colors.orange
                              : Colors.white,
                        ),
                        onPressed: () {
                          setState(
                            () {
                              _selectedSize =
                                  widget.productData['sizeList'][index];
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.productData['sizeList'][index],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            if (_cartProvider.getCartItem
                .containsKey(widget.productData['productId'])) {
              return null;
            } else if (_selectedSize == null) {
              return showSnack(context, 'Select a Size for this product');
            } else {
              _cartProvider.addProductToCart(
                  widget.productData['productName'],
                  widget.productData['productId'],
                  widget.productData['imageUrlList'],
                  widget.productData['productQuantity'],
                  widget.productData['productPrice'],
                  widget.productData['vendorId'],
                  _selectedSize!,
                  widget.productData['scheduleDate'],
                  widget.productData['productQuantity']);
              return showSnack(context, 'Added To Cart');
            }
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: _cartProvider.getCartItem
                      .containsKey(widget.productData['productId'])
                  ? Colors.grey
                  : Colors.yellow.shade900,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.cart,
                  color: Colors.white,
                  size: 22,
                ),
                SizedBox(
                  width: 20,
                ),
                _cartProvider.getCartItem
                        .containsKey(widget.productData['productId'])
                    ? Text(
                        'Already In Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 5,
                        ),
                      )
                    : Text(
                        'Add To Cart',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          letterSpacing: 5,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
