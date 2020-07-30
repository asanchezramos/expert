import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class ListExpert extends StatelessWidget {
  const ListExpert({Key key, this.name, this.expert}) : super(key: key);

  final String name;
  final String expert;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      constraints: BoxConstraints(
          maxWidth: responsive.wp(85), minWidth: responsive.wp(85)),
      height: responsive.hp(10),
      //width: responsive.wp(80),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.grey[300]),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Nombre: $name', style: TextStyle(fontSize: responsive.ip(2))),
            Text('Especialidad: $expert',
                style: TextStyle(fontSize: responsive.ip(2)))
          ]),
    );
  }
}

class ListStatus extends StatelessWidget {
  const ListStatus({Key key, this.name, this.status}) : super(key: key);

  final String name;
  final String status;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      constraints: BoxConstraints(
          maxWidth: responsive.wp(85), minWidth: responsive.wp(85)),
      height: responsive.hp(10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      //width: responsive.wp(80),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[300],
      ),
      child: Row(
        children: <Widget>[
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(name, style: TextStyle(fontSize: responsive.ip(2))),
                Text(status,
                    style: TextStyle(
                        fontSize: responsive.ip(2), color: Colors.green[300]))
              ]),
        ],
      ),
    );
  }
}
