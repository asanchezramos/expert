import 'package:expert/src/api/criterio_api_provider.dart';
import 'package:expert/src/api/dimension_api_provider.dart';
import 'package:expert/src/models/criterio_entity.dart';
import 'package:expert/src/models/dimension_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddDimensions extends StatefulWidget {
  String? speciality;
  int? expertId;
  int? _researchId;
  DimensionEntity dimension;
  AddDimensions(this.speciality, this.expertId ,this.dimension,this._researchId);
  @override
  _AddDimensionsState createState() => _AddDimensionsState();
}

class _AddDimensionsState extends State<AddDimensions> {
  final TextEditingController _dimensionController = TextEditingController();
  final TextEditingController _variableController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String? sDimensionFinal = "";
  String? sVariableFinal = "";
  bool isBusy = false;
  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.dimension.dimensionId != null) {
      setState(() {
        isEdit = true;
        sDimensionFinal =  widget.dimension.name;
        sVariableFinal =  widget.dimension.variable;
        _dimensionController.text = widget.dimension.name!;
        _variableController.text = widget.dimension.variable!;
      });
    } else {
      setState(() {
        isEdit = false;
        _dimensionController.text = widget.dimension.name!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( 
          title: Text(
            isEdit ? "Editar dimensión" : "Nueva dimesión", 
          ),
          centerTitle: true, 
        ),
        body: GestureDetector(
          onTap: () {
            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              FocusManager.instance.primaryFocus!.unfocus();
            }
          },
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text( isEdit? "Tu dimensión está creada, puedes añadir nuevos indicadores" :"A continuación podrás crear una variable que será evaluada por el experto.", style: TextStyle(fontSize: 20),),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _dimensionController,
                        validator: (val) {
                          if (val!.isEmpty) return 'Este campo es requerido';
                          return null;
                        },
                        readOnly: isEdit,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          labelText: "Dimensión",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value){
                          _form.currentState!.validate();
                        },
                      ),
                    ),
                    Divider(),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        controller: _variableController,
                        validator: (val) {
                          if (val!.isEmpty) return 'Este campo es requerido';
                          return null;
                        },
                        minLines: 3,
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          labelText: "Indicador",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value){
                          _form.currentState!.validate();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Criterios de evaluación",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Los siguientes criterios de evaluación fueron definidos por el experto.",style: TextStyle(fontSize: 14),),
                    ),
                    FutureBuilder(
                      future: CriterioApiProvider.getCriterios(widget.speciality, widget.expertId),
                      builder: (_, snapshot){
                        if(snapshot.hasData){
                          List<CriterioEntity>? criteriolist = snapshot.data as List<CriterioEntity>;
                          print( criteriolist.length);
                          return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:criteriolist.length,
                              itemBuilder: (context, index){
                                CriterioEntity element = criteriolist[index];
                                return ListTile(
                                  leading: Icon(Icons.filter_tilt_shift,color: Colors.green,),
                                  title: Text(element.name!),
                                );
                              }

                          );
                        } else {
                          return Container(child: Center(child: CircularProgressIndicator(),),);
                        }
                      },

                    ),
                    Padding(
                      padding: EdgeInsets.all(40),
                    )
                  ],
                ),
              )),
        ),

      bottomSheet: Container(
        width: double.infinity,
        height: 50,
        child: ElevatedButton( 
          child:  Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(isEdit ? "Agregar" : "Crear", style: TextStyle(fontSize: 18,  ),),
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
                    child: CircularProgressIndicator(  ),
                  ),
                ),
              ],
            ),
          ) ,
          onPressed: () async {

            if (_form.currentState!.validate() && !isBusy) {
              String oMessage = "";
              if(isEdit){
                if(sDimensionFinal != _dimensionController.text && sVariableFinal != _variableController.text){
                  oMessage = "¿Está seguro de editar la dimensión y la variable?";
                } else if(sVariableFinal == _variableController.text) {
                  oMessage = "¿Está seguro de editar la dimensión?";
                } else if(sDimensionFinal == _dimensionController.text){
                  oMessage = "¿Está seguro de editar la variable?";
                }
                Dialogs.confirm(context,title: "Confirmación",message: oMessage).then((value) async {
                  if(value!){

                    setState(() {
                      isBusy = true;
                    });
                    final request = DimensionEntity(
                      dimensionId: widget.dimension.dimensionId,
                        status: 'P',
                        name: _dimensionController.text,
                        variable: _variableController.text,
                        researchId: widget._researchId
                    );
                    final success = await DimensionApiProvider.putUpdateDimension(context, request);
                    setState(() {
                      isBusy = false;
                    });
                    if (success) {
                      print("asdasd 34");
                      print(request.toJson());
                      Navigator.of(context).pop(success);
                    } else {
                      print("asdasd 12");
                      Navigator.of(context).pop();
                    }
                  }
                });
              }else{
                oMessage = "¿Está seguro de registar la dimensión?";
                Dialogs.confirm(context,title: "Confirmación",message: oMessage).then((value) async {
                  if(value!){

                    setState(() {
                      isBusy = true;
                    });
                    final request = DimensionEntity(
                        status: 'P',
                        name: _dimensionController.text,
                        variable: _variableController.text,
                        researchId: widget._researchId
                    );
                    final success = await DimensionApiProvider.postRegisterDimension(context, request);
                    setState(() {
                      isBusy = false;
                    });
                    if (success) {
                      print(request.toJson());
                      Navigator.of(context).pop(success);
                    } else {
                      Navigator.of(context).pop();
                    }
                  }
                });
              }

            }  else {
              Dialogs.alert(context,title: "Alerta", message: "Complete los campos requeridos");
            }
          },
        ),
      ),
    );
  }
}
