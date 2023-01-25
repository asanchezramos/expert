import 'package:flutter/material.dart';

import '../../../api/expert_api_provider.dart';
import '../../../models/expert_entity.dart';
import '../../../utils/responsive.dart';
import '../widgets/header.dart';
import '../widgets/list.dart';
import 'contact_expert.dart';

class ExpertoList extends StatefulWidget {
  const ExpertoList({Key? key}) : super(key: key);

  @override
  _ExpertoListState createState() => _ExpertoListState();
}

class _ExpertoListState extends State<ExpertoList> {
  List<ExpertEntity> users = [];
  List<ExpertEntity> usersForDisplay = [];
  @override
  void initState() {
    super.initState();
    ExpertApiProvider.getExperts().then((userSpecialty) {
      setState(() {
        users.addAll(userSpecialty!);
        usersForDisplay = users;
        //filterUsers = users;
      });
    });
  }

  Widget build(BuildContext context) {
    final Responsive responsive = Responsive.of(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: Column(
            children: <Widget>[
              Header(
                texto: 'Lista de Expertos',
              ),
              SizedBox(
                height: responsive.hp(3),
              ),
              // Container(
              //     height: responsive.hp(6.5),
              //     width: responsive.wp(85),
              //     // decoration: BoxDecoration(
              //     //     color: Colors.grey[200],
              //     //     borderRadius: BorderRadius.circular(12)),
              //     child: TextField(
              //       onChanged: (string) {
              //         string = string.toLowerCase();
              //         setState(() {
                        
              //           usersForDisplay = users.where((u){
              //             var fullnames = u.specialty.toLowerCase();
              //             return fullnames.contains(string);
              //           }).toList();

                        
              //         });
              //       },
              //       // decoration: InputDecoration(
              //       //   labelText: 'Buscar',
              //       //   prefixIcon: Icon(Icons.search),
              //       //   border: OutlineInputBorder(
              //       //       borderRadius: BorderRadius.circular(20)),
              //       // ),
              //     )),
              SizedBox(
                height: responsive.hp(3),
              ),
              _buildList(context),
            ],
          ),
          //bottomNavigationBar: NavigatorN(),
        ),
      ),
    );
  }
}

Widget _buildList(BuildContext context) {
  final Responsive responsive = Responsive.of(context);
  return FutureBuilder<List<ExpertEntity>?>(
      future: ExpertApiProvider.getExperts(),
      builder: (
        BuildContext context,
        AsyncSnapshot<List<ExpertEntity>?> snapshot,
      ) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContactExpert(
                                        expertEntity: snapshot.data![index],
                                      )),
                            );
                          },
                          child: ListExpert(
                            name: snapshot.data![index].fullName,
                            photo: snapshot.data![index].photo,
                            expert: snapshot.data![index].specialty != ''
                                ? snapshot.data![index].specialty
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

// Widget _searchBar(BuildContext context) {
//   final Responsive responsive = Responsive.of(context);
//   return Container(
//       height: responsive.hp(6.5),
//       width: responsive.wp(85),
//       decoration: BoxDecoration(
//           color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
//       child: TextField(
//         onChanged: (string) {},
//         decoration: InputDecoration(
//           labelText: 'Buscar',
//           prefixIcon: Icon(Icons.search),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//         ),
//       ));
// }
