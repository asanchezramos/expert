import 'package:expert/src/api/criterio_api_provider.dart';
import 'package:expert/src/api/criterio_response_api_provider.dart';
import 'package:expert/src/api/dimension_api_provider.dart';
import 'package:expert/src/models/criterio_entity.dart';
import 'package:expert/src/models/criterio_response_entity.dart';
import 'package:expert/src/models/dimension_entity.dart';
import 'package:expert/src/models/research_entity.dart';
import 'package:expert/src/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewCriterioResponse extends StatefulWidget {
  String? speciality;
  int? expertId;
  DimensionEntity dimension;
  int? _researchId;
  ResearchEntity? _researchSelected;
  ViewCriterioResponse(
      this.speciality, this.expertId, this.dimension, this._researchId,this._researchSelected);
  @override
  _ViewCriterioResponseState createState() => _ViewCriterioResponseState();
}

class _ViewCriterioResponseState extends State<ViewCriterioResponse> {
  final TextEditingController _dimensionController = TextEditingController();
  final TextEditingController _variableController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String? sDimensionFinal = "";
  String? sVariableFinal = "";
  List<CriterioResponseEntity>? _criteriosResponse = [];
  bool isBusy = false;
  bool isEdit = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      sDimensionFinal =  widget.dimension.name;
      sVariableFinal =  widget.dimension.variable;
      _dimensionController.text = widget.dimension.name!;
      _variableController.text = widget.dimension.variable!;
      CriterioResponseApiProvider.getCriterios(widget._researchId)
          .then((value) {
        setState(() {
          _criteriosResponse = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        title: Text(
          isEdit ? "Revisión de dimensión" : "Revisión de dimensión", 
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
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      controller: _dimensionController,
                      validator: (val) {
                        if (val!.isEmpty) return 'Este campo es requerido';
                        return null;
                      },
                      readOnly:   isEdit  ,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: "Dimensión",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
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
                      readOnly:  isEdit   ,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: "Indicador",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _form.currentState!.validate();
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Criterios de evaluación",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Los siguientes criterios de evaluación fueron definidos y evaluados por el experto.",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  FutureBuilder(
                    future: CriterioApiProvider.getCriterios(
                        widget.speciality, widget.expertId),
                    builder: (_, snapshot) {
                      if (snapshot.hasData) {
                        List<CriterioEntity>? criterios =snapshot.data as List<CriterioEntity>; 
                        return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: criterios.length,
                            itemBuilder: (context, index) {
                              CriterioEntity element = criterios[index];
                              return ListTile(
                                leading: Icon(
                                  Icons.filter_tilt_shift,
                                  color: Colors.green,
                                ),
                                title: Text(element.name!),
                                subtitle: onBuildSubtitleDimension(widget.dimension,element,index),
                              );
                            });
                      } else {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
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
        padding: EdgeInsets.all(5),
        height: 50,
        child: ElevatedButton( 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Modificar ",
                  style: TextStyle( 
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              Visibility(
                  visible: !isBusy,child: Icon(Icons.cached  )),
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
                  child: CircularProgressIndicator( ),
                ),
              ),
            ],
          ),
          onPressed: () {
            String oMessage = "";
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
                final success = await DimensionApiProvider.putUpdateDimension(context,request);
                if (success) {
                  print("asdasd 34");
                  print(request.toJson());
                  Navigator.of(context).pop(success);
                } else {
                  print("asdasd 12");
                  Navigator.of(context).pop();
                }

                setState(() {
                  isBusy = false;
                });
              }
            });

          },
        ),
      ),
    );
  }
  onFindCriterioResponse(int? criterioId, int? dimensionId){
    int index =  _criteriosResponse!.indexWhere((element) => element.criterioId == criterioId && element.dimensionId == dimensionId );
    if(index == -1){
      return null;
    } else {
      return _criteriosResponse![index];
    }
  }
  onGetStatusDimension(CriterioResponseEntity criterioResponse){
    String statusStr= "";
    switch(criterioResponse.status){
      case "A":
        statusStr = "Aprobado";
        break;
      case "R":
        statusStr = "Rechazado";
        break;
    }
    return statusStr;
  }

  Widget onBuildSubtitleDimension(DimensionEntity dimension, CriterioEntity criterio, int indexDimension ){
    final CriterioResponseEntity? criterioResponse = onFindCriterioResponse(criterio.criterioId,dimension.dimensionId);
    if(criterioResponse != null){
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: onGetStatusDimension(criterioResponse) ,
                        style: TextStyle(color: (criterioResponse.status == 'R') ? Colors.red:Colors.green),
                      )
                    ]
                ),
              )
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          Expanded(
              child: RichText(
                text: TextSpan(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "En revisión " ,
                        style: TextStyle(color: Colors.deepOrange),
                      )
                    ]
                ),
              )
          ),
        ],
      );
    }
  }
}
