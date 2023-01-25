import 'package:expert/src/pages/student/widgets/header.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class ExpertResp extends StatefulWidget {
  const ExpertResp({Key? key}) : super(key: key);
  @override
  _ExpertRespState createState() => _ExpertRespState();
}
class _ExpertRespState extends State<ExpertResp> {
  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Header(
                texto: 'Respuesta del Experto',
              ),
              SizedBox(
                height: responsive.hp(10),
              ),
              ExpertContact(),
            ],
          ),
        ),
        //bottomNavigationBar: NavigatorN(),
      ),
    );
  }
}

class ExpertContact extends StatelessWidget {
  const ExpertContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      constraints: BoxConstraints(
          minWidth: responsive.wp(85), maxWidth: responsive.wp(85)),
      height: responsive.hp(50),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey[200]),
      child: Column(
        children: <Widget>[
          DataExpert(
            name: 'Jose Luis',
            expert: 'Software',
          ),
        ],
      ),
    );
  }
}

class DataExpert extends StatelessWidget {
  const DataExpert({Key? key, this.name, this.expert}) : super(key: key);

  final String? name;
  final String? expert;

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: responsive.hp(23), top: responsive.hp(2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: responsive.hp(3),
              ),
              Container(
                height: responsive.hp(20),
                width: responsive.wp(45),
                child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Nombre: $name',
                            style: TextStyle(fontSize: responsive.ip(1.7)),
                          )),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Expercialista: $expert',
                            style: TextStyle(fontSize: responsive.ip(1.7)),
                          )),
                      SizedBox(
                        height: responsive.hp(8),
                      ),
                      Container(
                        height: responsive.hp(3.5),
                        width: responsive.wp(30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.green),
                        child: Align(
                            child: Text(
                          'Download',
                          style: TextStyle(color: Colors.white),
                        )),
                      )
                    ]),
              ),
            ],
          ),
          SizedBox(
            width: responsive.wp(5),
          ),
          Container(
            height: responsive.hp(20),
            width: responsive.wp(26),
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class ComentExpert extends StatelessWidget {
  const ComentExpert({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
      height: responsive.hp(15),
      width: responsive.wp(10),
      color: Colors.white,
    );
  }
}
