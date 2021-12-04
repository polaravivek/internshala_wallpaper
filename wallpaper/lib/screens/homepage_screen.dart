
import 'package:flutter/material.dart';
import 'package:wallpaper/screens/downloaded_images_screen.dart';
import 'package:wallpaper/screens/menu_screen.dart';
import 'package:wallpaper/screens/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var urlData;

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final Set<Widget> _widgetOptions = <Widget>{
    MenuScreen(),
    FetchImages(),
    ProfileScreen()
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.widgets),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.download,
            ),
            label: 'Downloads',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff3B4071),
        unselectedItemColor: Colors.black26,
        iconSize: 30,
        onTap: _onItemTapped,
        elevation: 10,
      ),
    );
  }
}
