import 'package:buyit/vendors/views/Screens/edit_tab_screens/published.dart';
import 'package:buyit/vendors/views/Screens/edit_tab_screens/unpublished.dart';
import 'package:flutter/material.dart';

class VendorEditScreen extends StatelessWidget {
  const VendorEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Colors.yellow.shade900,
          title: Text(
            'Manage Products',
            style: TextStyle(
              letterSpacing: 7,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  'Published',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Unpublished',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Published(),
            Unpublished()
          ],
        ),
      ),
    );
  }
}
