import 'package:expert/src/api/solicitude_api_provider.dart';
import 'package:expert/src/models/user_solicitude_entity.dart';
import 'package:expert/src/pages/expert/pages/contac_student.dart';
import 'package:expert/src/pages/student/widgets/header.dart';
import 'package:expert/src/pages/student/widgets/list.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../student/widgets/list.dart';

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Header(
              texto: 'Solicitud de Estudiantes',
            ),
            SizedBox(
              height: responsive.hp(3),
            ),
            //Search(),
            SizedBox(
              height: responsive.hp(3),
            ),
            _buildList(context),
          ],
        ),
        //bottomNavigationBar: NavigatorN(),
      ),
    );
  }
}

Widget _buildList(BuildContext context) {
  final Responsive responsive = Responsive.of(context);
  return FutureBuilder<List<UserSolicitudeEntity>?>(
      future: SolicitudeApiProvider.getAllUserSolicitudesByExpert(),
      builder: (BuildContext context,
          AsyncSnapshot<List<UserSolicitudeEntity>?> snapshot) {
        if (snapshot.hasData) {
          final items = snapshot.data!;
          if (items.length == 0) {
            return Text("No hay solicitudes");
          }
          return Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ContactStudent(
                                  userSolicitudeEntity: items[index],
                                ),
                              ),
                            );
                          },
                          child: ListStudent(
                            name: items[index].fullName,
                            photo: snapshot.data![index].photo,
                            expert: items[index].specialty != ''
                                ? items[index].specialty
                                : '-',
                          )),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                    ],
                  );
                }),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      });
}

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return Container(
        height: responsive.hp(6.5),
        width: responsive.wp(85),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Buscar',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ));
  }
}
