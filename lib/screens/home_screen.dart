import 'package:flutter/material.dart';
import '../DynamicTheme.dart';
import 'dashboard_screen.dart';
import 'menu_items_screen.dart';
import 'menus_screen.dart';
import 'venues_screen.dart';
import 'qr_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    DashboardScreen(),
    VenuesScreen(),
    MenusScreen(),
    MenuItemsScreen(),
    QrScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            backgroundColor: DynamicTheme.of(context).data.primaryColor,
            label:'Dashboard',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            backgroundColor: DynamicTheme.of(context).data.primaryColor,
            label: 'Venues',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Menus',
            backgroundColor: DynamicTheme.of(context).data.primaryColor,
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'MenuItems',
            backgroundColor: DynamicTheme.of(context).data.primaryColor,
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.qr_code),
            label: 'Qr Codes',
            backgroundColor: DynamicTheme.of(context).data.primaryColor,
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

