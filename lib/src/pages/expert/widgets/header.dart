import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key key, @required this.texto }) : super(key: key);

  final String texto;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context); 
    return Container(
      alignment: Alignment.center,
      height: responsive.hp(20),
      width: double.infinity,
      color: Colors.green,
      child: Text('$texto', style: TextStyle(color: Colors.white,fontSize: responsive.ip(2.5),fontWeight: FontWeight.w700),),
    );
  }
}