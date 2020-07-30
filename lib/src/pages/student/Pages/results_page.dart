import 'package:expert/src/api/solicitude_api_provider.dart';
import 'package:expert/src/models/solicitude_entity.dart';
import 'package:expert/src/pages/expert/widgets/list.dart';
import 'package:expert/src/pages/student/Pages/answer_expert.dart';
import 'package:expert/src/pages/student/widgets/header.dart';
import 'package:expert/src/utils/responsive.dart';
import 'package:flutter/material.dart';

class ResultExpertPage extends StatelessWidget {
  const ResultExpertPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Header2(
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
      future: SolicitudeApiProvider.getSolicitudesByUser(),
      builder: (BuildContext context,
          AsyncSnapshot<List<SolicitudeEntity>> snapshot) {
        if (snapshot.hasData) {
          final items = snapshot.data;
          if (items.length == 0) {
            return Text("No hay respuestas");
          }
          return Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          if (items[index].status != "Denegado") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AnswerExpert(
                                  solicitudeId: items[index].id,
                                ),
                              ),
                            );
                          }
                        },
                        child: ListStatus(
                          name: items[index].fullName,
                          status: items[index].status,
                        ),
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
