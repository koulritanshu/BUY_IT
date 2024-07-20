import 'package:buyit/views/buyers/product_detail/store_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatefulWidget {
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final Stream<QuerySnapshot> _vendorsStream =
      FirebaseFirestore.instance.collection('vendors').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _vendorsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          height: 500,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final currentVendor = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return StoreDetail(
                            storeData: currentVendor,
                          );
                        },
                      ),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      currentVendor['businessName'],
                    ),
                    subtitle: Text(
                      currentVendor['countryValue'],
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        currentVendor['storeImage'],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
