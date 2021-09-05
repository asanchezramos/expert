import 'package:expert/src/api/resource_api_provider.dart';
import 'package:expert/src/managers/session_manager.dart';
import 'package:expert/src/models/resource_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/material.dart';

class ResourceUserAdd extends StatefulWidget {
  @override
  _ResourceUserAddState createState() => _ResourceUserAddState();
}

class _ResourceUserAddState extends State<ResourceUserAdd> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _subtitle = TextEditingController();
  final TextEditingController _link = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool isBusy = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Nuevo recurso",
          style: TextStyle(color: Colors.pink[900]),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _title,
                validator: (val) {
                  if (val.isEmpty) return 'Este campo es requerido';
                  return null;
                },
                keyboardType: TextInputType.text,
                autocorrect: false,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "Título",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _subtitle,
                validator: (val) {
                  if (val.isEmpty) return 'Este campo es requerido';
                  return null;
                },
                keyboardType: TextInputType.text,
                autocorrect: false,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "Detalle",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                controller: _link,
                validator: (val) {
                  if (val.isEmpty) return 'Este campo es requerido';
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                decoration: InputDecoration(
                  labelText: "Recurso Url",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        height: 50,
        child: FlatButton(
          color: Colors.amber,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Registrar recurso",
                style: TextStyle(
                    color: Colors.pink[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Visibility(
                  visible: !isBusy,
                  child: Icon(Icons.save, color: Colors.pink[900])),
              Visibility(
                visible: isBusy,
                child: Padding(
                  padding: EdgeInsets.all(10),
                ),
              ),
              Visibility(
                visible: isBusy,
                child: Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.pink[900],
                  ),
                ),
              ),
            ],
          ),
          onPressed: () async {
            bool _validURL = true;
            try {
              _validURL = Uri.parse(_link.text).isAbsolute;
            } catch (e){
              _validURL= false;
            }
            if(!_validURL){
              Dialogs.alert(context,title: "Campo inválido", message: "Utilice la forma: http://google.com");
              return;
            }

            if (_form.currentState.validate() && !isBusy) {
              setState(() {
                isBusy = true;
              });
              final session = await SessionManager.getInstance();
              ResourceEntity oSend = ResourceEntity(
                  expertId: session.getUserId(),
                  title: _title.text,
                  subtitle: _subtitle.text,
                  link: _link.text);
              final success = await ResourceApiProvider.createResource(context, oSend);
              if (success) {
                Navigator.of(context).pop(success);
              } else {
                Navigator.of(context).pop();
              }
              setState(() {
                isBusy = false;
              });
            }
          },
        ),
      ),
    );
  }
}
