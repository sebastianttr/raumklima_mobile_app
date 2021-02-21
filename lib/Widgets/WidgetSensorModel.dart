import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:raumklima/Models/RaumklimaModel.dart';
import 'package:raumklima/Widgets/SensorValueWidget.dart';
import 'package:http/http.dart' as http;
import '../Models/WeatherDataModel.dart';


class WidgetSensorModel extends StatefulWidget{
  const WidgetSensorModel({Key key,this.sensorModel}) : super(key: key);

  final RaumklimaModel sensorModel;

  @override
  _WidgetSensorModel createState() => _WidgetSensorModel();
}


class _WidgetSensorModel extends State<WidgetSensorModel>{

  Timer timer;
  String APPID = "f314ea552d5dbd5a3cc3e263bd69ca80";
  String description = " ";
  String img = "01n";

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  List<Widget> getWidgets(){
    List<Widget> widgets = [];
    if(widget.sensorModel.temperatur!=null)
    {
      widgets.add(
          Padding(
              padding: EdgeInsets.only(left: 5,right:5),
              child: SensorValueWidget(title: "Temperatur",value: widget.sensorModel.temperatur.toString()+" °C")
          )
      );
      widgets.add(
          Padding(
              padding: EdgeInsets.only(left: 5,right:5),
              child: SensorValueWidget(title: "Feuchte",value: widget.sensorModel.humidtiy.toString()+" %")
          )
      );
      widgets.add(
          Padding(
              padding: EdgeInsets.only(left: 4,right:4),
              child: SensorValueWidget(title: "CO2",value: widget.sensorModel.CO2.toString()+" ppm"))
      );
    }
    else {
      widgets.add(
          Padding(
              padding: EdgeInsets.only(left: 5,right:5),
              child: Text("Keine Messwerte in diesem Raum!",style: TextStyle(fontSize: 20),)
          )
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
        margin: new EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),
              spreadRadius: 2,
              blurRadius: 6
            )
          ]
        ),
        child:
        Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if(widget.sensorModel.raumBezeichnung.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:4.0,left: 4.0),
                          child: Text(
                              widget.sensorModel.raumBezeichnung,
                              style: TextStyle(color: Colors.black,fontSize: 30)
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom:4.0,left: 4.0),
                            child:
                              (widget.sensorModel.time!=null)
                              ?Text(
                                  "Letzter Timestamp: "
                                      "${widget.sensorModel.time.hour.toString().padLeft(2, '0')}"
                                      ":${widget.sensorModel.time.minute.toString().padLeft(2, '0')}",
                                  style: TextStyle(color: Colors.black,fontSize: 15))
                                  :Container()
                          ),
                      ],
                    ),
                ],
              ),
             AnimatedOpacity(
               opacity: getWidgets().isEmpty ? 0.0:1.0,
               duration: Duration(milliseconds: 500),
               curve: Curves.fastOutSlowIn,
               child: SizedBox(
                   height: 80,
                   child: ListView(
                       scrollDirection: Axis.horizontal,
                       clipBehavior: Clip.hardEdge,
                       shrinkWrap: true,
                       children:getWidgets(),
                   )
                  )
                )
            ],
          ),
        )

    );
  }
}