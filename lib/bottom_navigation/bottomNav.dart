import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Search",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.remove_done_outlined),
          label: "Do's & Don'ts",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "User",
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.lightBlue,
      unselectedItemColor: Colors.black26,
      onTap: onItemTapped,
    );
  }
}
