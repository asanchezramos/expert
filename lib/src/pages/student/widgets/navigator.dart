import 'package:flutter/material.dart';

class NavigatorN extends StatefulWidget {
  @override
  _NavigatorNState createState() => _NavigatorNState();
}

class _NavigatorNState extends State<NavigatorN> {
  int _currentIndex = 0;
  @override
   Widget build(BuildContext context) {
    return  BottomNavigationBar(
        backgroundColor: Colors.red[900],
        unselectedItemColor: Colors.white,
        fixedColor: Colors.grey[700],
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label:   'Inicio' ,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label:   'Consulta' ,
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      );
  }
}
