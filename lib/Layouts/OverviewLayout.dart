import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:http/io_client.dart';
import 'package:raumklima/Models/RaumklimaModel.dart';
import 'package:raumklima/Models/WeatherDataModel.dart';
import 'package:raumklima/main.dart';
import 'package:http/http.dart' as http;
import '../Widgets/WidgetSensorModel.dart';

class OverviewLayout extends StatefulWidget{

  final List<RaumklimaModel> listOfSensors;
  final Function onUpdateRequest;
  const OverviewLayout({Key key, this.listOfSensors, this.onUpdateRequest}) : super(key: key);

  @override
  OverviewLayoutState createState() => OverviewLayoutState();
}

class OverviewLayoutState extends State<OverviewLayout>  with SingleTickerProviderStateMixin{

  List<RaumklimaModel> _listOfSensor = [];
  List<RaumklimaModel> _listOfMesswerte = [];
  Timer timer;
  bool showRetryDialog = false;

  List<RaumklimaModel> getList(){
    if(_listOfSensor.isEmpty) _listOfSensor = widget.listOfSensors;
    return _listOfSensor;
  }

  List<RaumklimaModel> getListOfMesswerte(){
    List<RaumklimaModel> list = [];
    _listOfSensor.forEach((element) {
      if(element.temperatur != null)
        list.add(
            new RaumklimaModel(
                "",
                element.temperatur,
                element.humidtiy,
                element.CO2,
                element.time
            )
        );
    });

    return list;
  }

  void update(List<RaumklimaModel> listOfSensors){
    print("Updating");
    setState((){
      _listOfSensor = listOfSensors;
    });
  }


  void removeCard(int index)async{
    HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    var ioClient = new IOClient(client);
    await ioClient.get("https://192.168.0.159:45455/api/removeSensor/${getList()[index].raumBezeichnung}").then((value) => widget.onUpdateRequest());
  }

  void updateCityName(int index, String name)async{
    //await http.get("http://192.168.0.159/updateCity?id=${getList()[index].id}&name=$name").then((value) => widget.onUpdateRequest());
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState((){
        if(_listOfSensor.isEmpty){
          print("List of sensor is empty.");
          this.showRetryDialog = true;
          timer?.cancel();
        }
        else this.showRetryDialog = false;
      });
    });
    setState((){
      _listOfSensor = widget.listOfSensors;
      _listOfMesswerte =  getListOfMesswerte();
    });
  }

  _showEditingDialog(int index) {
    TextEditingController textEditingController = new TextEditingController();
    textEditingController.text = getList()[index].raumBezeichnung;
    showGeneralDialog(context: context,
        barrierLabel: "Hello there",
        barrierDismissible: true,
        transitionDuration: Duration(milliseconds: 250), //This is time
        barrierColor: Colors.black.withOpacity(0.5), // Add this property is color
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return Center(
              child: Card(
                margin:MediaQuery.of(context).viewInsets ,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width-30,
                  padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Change room name",style: TextStyle(fontSize: 30)),
                      Container(
                          margin: EdgeInsets.only(top: 15,bottom: 15),
                          child: TextField(
                            controller: textEditingController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25))
                              ),
                              focusedBorder: OutlineInputBorder(),
                              hintText: "Room name",
                            ),
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            child: Text('Chancel'),
                            textColor: Colors.lightBlue,
                            onPressed: () {
                              textEditingController.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Set'),
                            textColor: Colors.lightBlue,
                            onPressed: ()async {
                              HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
                              var ioClient = new IOClient(client);
                              await ioClient.get("https://192.168.0.159:45455/api/updateSensor/${getList()[index].raumBezeichnung}/${textEditingController.text}").then((value) => widget.onUpdateRequest());
                              widget.onUpdateRequest();
                              textEditingController.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          AnimatedSize(duration: Duration(milliseconds: 800),curve: Curves.fastOutSlowIn,vsync: this,
              child: Container(
                height:showRetryDialog?30:0,
                width: MediaQuery.of(context).size.width,
                margin:EdgeInsets.only(top:5,left:10,right:10),
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.6),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(left:15),
                          child:
                          Text("Error connecting. Try Again!",style: TextStyle(color: Colors.black,fontSize: 15))
                      ),
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: MaterialButton(
                              color: Colors.red.withOpacity(0.9),
                              shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
                              child: new Text('Retry',
                                  style: new TextStyle(fontSize: 13, color: Colors.white)),
                              onPressed: (){
                                setState(()=>showRetryDialog=false);
                                widget.onUpdateRequest();
                              }
                          )
                      )
                    ],
                  ),
              )
          ),
          if(getListOfMesswerte().isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left:20,top:10),
                  child: Column(
                    children: [
                      Text(
                          "Messwerte",
                          style: TextStyle(color: Colors.black,fontSize: 30)
                      ),
                    ],
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(left:20),
                  child: Column(
                    children: [
                      Text(
                          "Aktuelle Sensor Messwerte",
                          style: TextStyle(color: Colors.black,fontSize: 18)
                      ),
                    ],
                  )
              ),
            ],
          ),
          SizedBox(
            height: 125.0,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount:  getListOfMesswerte().length,
              itemBuilder: (BuildContext context, int index) => WidgetSensorModel(sensorModel:getListOfMesswerte()[index]),
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _listOfSensor.length,
            itemBuilder: (context, index) {
              return
                FocusedMenuHolder(
                    onPressed: ()=>{},
                    menuWidth: MediaQuery.of(context).size.width * 0.35,
                    animateMenuItems: true,
                    //or showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
                    menuItems: <FocusedMenuItem>[
                      // Add Each FocusedMenuItem  for Menu Options
                      FocusedMenuItem(title: Text("Edit"),trailingIcon: Icon(Icons.edit) ,onPressed: (){
                        _showEditingDialog(index);
                      }),
                      FocusedMenuItem(title: Text("Delete"),trailingIcon: Icon(Icons.delete) ,onPressed: (){
                        removeCard(index);
                      }),
                    ],
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(index == 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left:20,top:10),
                                  child: Column(
                                    children: [
                                      Text(
                                          "Räume",
                                          style: TextStyle(color: Colors.black,fontSize: 30)
                                      ),
                                    ],
                                  )
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left:20),
                                  child: Column(
                                    children: [
                                      Text(
                                          "Raumklima in den einzelnen Räumen",
                                          style: TextStyle(color: Colors.black,fontSize: 18)
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                          Column(children: [
                            WidgetSensorModel(sensorModel: _listOfSensor[index]),
                          ]),
                      ],
                    )
                );
            },
          ),
        ],
      ),
    );
  }
}