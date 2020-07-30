import 'package:expert/src/api/solicitude_api_provider.dart';
import 'package:expert/src/models/solicitude_entity.dart';
import 'package:expert/src/pages/expert/widgets/header.dart';
import 'package:expert/src/pages/expert/widgets/list.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class ResultStudentPage extends StatelessWidget {
  const ResultStudentPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Header(
              texto: 'Solicitud de respuesta',
            ),
            SizedBox(
              height: responsive.hp(3),
            ),
            SizedBox(
              height: responsive.hp(3),
            ),
            _buildList(context),
          ],
        ),
      ),
    );
  }
}

Widget _buildList(BuildContext context) {
  final Responsive responsive = Responsive.of(context);
  return FutureBuilder<List<SolicitudeEntity>>(
      future: SolicitudeApiProvider.getSolicitudesByExpert(),
      builder: (BuildContext context,
          AsyncSnapshot<List<SolicitudeEntity>> snapshot) {
        if (snapshot.hasData) {
          final items = snapshot.data;
          if (items.length == 0) {
            return Text("No hay solicitudes");
          }
          return Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      ListStatus(
                        name: items[index].fullName,
                        status: items[index].status,
                      ),
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
