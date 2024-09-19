import 'package:flutter/material.dart';
import 'package:flutter_saas/constant/colors.dart';
import 'package:flutter_saas/screens/home_page.dart';
import 'package:flutter_saas/screens/user_history.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectIndex = 0;

  void _onTapItem(int index){
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.transform),
            label: "Conversion",
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
        ],
        onTap: _onTapItem,
        currentIndex: _selectIndex,
        unselectedItemColor: const Color.fromARGB(255, 89, 89, 184),
        selectedItemColor: const Color.fromARGB(255, 9, 10, 10),
        backgroundColor: mainColor,
      ),
      body: _selectIndex == 0 ? const HomePage() : const UserHistory() ,
    );
  }
}
