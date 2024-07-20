import 'package:buyit/views/buyers/nav_screens/category_screen.dart';
import 'package:buyit/views/buyers/nav_screens/widgets/home_products.dart';
import 'package:buyit/views/buyers/nav_screens/widgets/main_products_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryText extends StatefulWidget {
  @override
  State<CategoryText> createState() => _CategoryTextState();
}

class _CategoryTextState extends State<CategoryText> {
  String? _selectedCategory;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _categoryStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(
              fontSize: 19,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _categoryStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Loading Categories"),
                );
              }

              return Container(
                height: 40.0,
                child: Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          final categoryData = snapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ActionChip(
                              onPressed: () {
                                setState(
                                  () {
                                    _selectedCategory =
                                        categoryData['categoryName'];
                                  },
                                );
                              },
                              backgroundColor: Colors.grey,
                              label: Text(
                                categoryData['categoryName'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return CategoryScreen();
                            },
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          if (_selectedCategory == null) MainProductWidget(),
          if (_selectedCategory != null)
            HomeProductsWidget(
              categoryName: _selectedCategory!,
            ),
        ],
      ),
    );
  }
}
