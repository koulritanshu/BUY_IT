import 'package:buyit/views/buyers/product_detail/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchedValue = '';
  final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.yellow.shade900,
        title: TextFormField(
          onChanged: (value) {
            setState(() {
              _searchedValue = value;
            });
          },
          decoration: InputDecoration(
            labelText: 'Search for products',
            labelStyle: TextStyle(
              fontSize: 26,
              color: Colors.white,
              letterSpacing: 4,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          final searchedData = snapshot.data!.docs.where(
            (element) {
              return element['productName'].toLowerCase().contains(
                    _searchedValue.toLowerCase(),
                  );
            },
          );
          return SingleChildScrollView(
            child: Column(
              children: searchedData.map((e) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductDetailScreen(
                        productData: e,
                      );
                    }));
                  },
                  child: Card(
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(e['imageUrlList'][0]),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                e['productName'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
