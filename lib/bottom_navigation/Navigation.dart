import 'package:flutter/material.dart';
import 'package:shikha_tycs/favourite/wishlist.dart';
import 'bottomNav.dart';
import '../bottom_screens/homeScreen.dart';
import '../bottom_screens/search.dart';
import '../bottom_screens/user.dart';
import '../bottom_screens/do_dont.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    HomeScreen(),
    SearchScreen(),
    ExploreScreen(),
    UserScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
