import 'package:buyit/vendors/views/Screens/vendor_upload_screen.dart';
import 'package:buyit/vendors/views/Screens/vendor_earnings_screen.dart';
import 'package:buyit/vendors/views/Screens/vendor_edit_screen.dart';
import 'package:buyit/vendors/views/Screens/vendor_logout_screen.dart';
import 'package:buyit/vendors/views/Screens/vendor_orders_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainVendorScreen extends StatefulWidget {
  const MainVendorScreen({super.key});

  @override
  State<MainVendorScreen> createState() => _MainVendorScreenState();
}

class _MainVendorScreenState extends State<MainVendorScreen> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    VendorEarningScreen(),
    VendorUploadScreen(),
    VendorEditScreen(),
    VendorOrdersScreen(),
    VendorLogoutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: (value) {
          setState(
            () {
              _pageIndex = value;
            },
          );
        },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.yellow.shade900,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.money_dollar,
            ),
            label: 'EARNINGS',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.upload,
            ),
            label: 'UPLOAD',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.edit,
            ),
            label: 'EDIT',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.shopping_cart,
            ),
            label: 'ORDERS',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
            ),
            label: 'LOGOUT',
          ),
        ],
      ),
      body: _pages[_pageIndex],
    );
  }
}
