import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        color: Colors.red,
        child: Text('Hola mundo'),
      );
  }
}