import 'package:flutter/material.dart';

class ResponseExpert extends StatefulWidget {
  @override
  _ResponseExpertState createState() => _ResponseExpertState();
}

class _ResponseExpertState extends State<ResponseExpert> {
  TextEditingController _comentario = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _comentario.text = "Todo los indicadores correctos.";
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _comentario.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        title: Text("Respuesta de revisión"),
      ),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode focus = FocusScope.of(context);
          if (!focus.hasPrimaryFocus && focus.hasFocus) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: Container(
          child: ListView(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              "Juan Antonio Ugarte Miranda",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              "Software",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundColor: Colors.brown.shade800,
                        child: Text(
                          'JU',
                          style: TextStyle(fontSize: 40),
                        ),
                        radius: 50,
                        //child: Image.asset("assets/programmer.png"),
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Text(
                  "\"Consumo de minerales tipo b para las comunidades indigenas de la selva alta.\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontStyle: FontStyle.italic
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: Text(
                  "Autores: Joaquin Eslava Pariona \nMarcelo Perez Cuellar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontStyle: FontStyle.italic
                  ),
                ),
              ),
              Divider(),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex:1,
                      child: Text("Aplicable",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                    ),
                    Expanded(
                      flex:1,
                      child: Icon(Icons.check_circle, color: Colors.green,size: 30,),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex:1,
                      child: Text("No Aplicable",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                    ),
                    Expanded(
                      flex:1,
                      child: Icon(Icons.remove_circle, color: Colors.red,size: 30,),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex:1,
                      child: Text("Correción",textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                    ),
                    Expanded(
                      flex:1,
                      child: Icon(Icons.swap_horizontal_circle, color: Colors.orange,size: 30,),
                    ),
                  ],
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _comentario,
                  minLines: 3,
                  maxLines: 3,
                  autocorrect: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    labelText: "Comentario",
                    border: OutlineInputBorder(),
                  ),
                  onTap: () {},
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 50,
        child: FlatButton.icon(
          color: Colors.amber,
          icon: Icon(Icons.send, color: Colors.pink[900],),
          label: Text(
            "Enviar revisión",
            style: TextStyle(
                color: Colors.pink[900],
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
          onPressed: () {
          },
        ),
      ),
    );
  }
}
