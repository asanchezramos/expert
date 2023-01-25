import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class ListExpert extends StatelessWidget {
  const ListExpert({Key? key, this.name, this.expert, this.photo})
      : super(key: key);

  final String? name;
  final String? expert;
  final String? photo;

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
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: photo != ""
                ? Image.network(
                    photo!,
                  )
                : SizedBox(),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Nombre: $name',
                    style: TextStyle(fontSize: responsive.ip(2))),
                Text('Especialidad: $expert',
                    style: TextStyle(fontSize: responsive.ip(2)))
              ]),
        ],
      ),
    );
  }
}

class ListStudent extends StatelessWidget {
  const ListStudent({Key? key, this.name, this.expert, this.photo})
      : super(key: key);

  final String? name;
  final String? expert;
  final String? photo;

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
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: photo != ""
                ? Image.network(
                    photo!,
                  )
                : SizedBox(),
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Estudiante: $name',
                    style: TextStyle(fontSize: responsive.ip(2))),
                Text('Especialidad: $expert',
                    style: TextStyle(fontSize: responsive.ip(2)))
              ]),
        ],
      ),
    );
  }
}
