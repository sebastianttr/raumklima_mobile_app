import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:raumklima/Widgets/IoTDemoCards.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class IoTDemoPage extends StatefulWidget{
  @override
  _IoTDemoPage createState() =>_IoTDemoPage();
}

class _IoTDemoPage extends State<IoTDemoPage> with SingleTickerProviderStateMixin{
  IOWebSocketChannel channel;
  // ignore: close_sinks
  StreamController<dynamic> webSocketStreamController = StreamController<dynamic>();
  Stream webSocketStream;
  dynamic jsonStream;
  List<String> widgetSensorName = [];
  List<List<Widget>> widgets = [];
  bool webSocketConnectionError = false;

  void connectAndHandle(){
    WebSocket.connect('ws://192.168.0.135:81/').timeout(Duration(seconds: 3)).then((value) {

      setState(()=>this.webSocketConnectionError = false);
      this.channel = IOWebSocketChannel(value);
      this.webSocketStream = this.channel.stream;
      this.webSocketStream.timeout(Duration(seconds: 3));
      this.webSocketStream.listen((value) {
        //print(value.toString());
        setState(() {
          this.widgetSensorName.clear();
          this.widgets.clear();
        });
        jsonStream = jsonDecode(value.toString());
        //print(jsonStream["sensors"].length);
        this.channel.sink.add("OK");
        jsonStream["sensors"].forEach((value) {
          widgetSensorName.add(value["name"]);
          List<Widget> values = [];
          value["values"].forEach((valData){
            values.add(IotDemoCard(name:valData[valData.keys.toList()[0]],value: valData[valData.keys.toList()[1]],));
          });
          setState(() {
            this.widgets.add(values);
          });
        });
      });
      this.webSocketStream.handleError((err){
        print("Unable to establish a WebSocket Connection!");
      });
    }).catchError((err){
      print("Error!");
      setState(()=>this.webSocketConnectionError = true);
    });
  }


  @override
  void initState() {
    super.initState();
    this.connectAndHandle();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    this.channel.sink.close();
    setState(()=>this.webSocketConnectionError = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.pop(context);
          }),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            Expanded(
            flex:2,
                child: Padding(
                  padding: EdgeInsets.only(left:10,right: 10),
                  child: SingleChildScrollView(

                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "IoT Demo",
                                  style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold)),
                              IconButton(icon: Icon(Icons.refresh), alignment: Alignment.centerRight,
                                onPressed: (){
                                  setState(()=>this.webSocketConnectionError = false);
                                  this.connectAndHandle();
                                },)
                            ],
                          ),
                          AnimatedSize(duration: Duration(milliseconds: 800),curve: Curves.fastOutSlowIn,vsync: this, child: Container(
                            height: !this.webSocketConnectionError?0:30,
                            width: MediaQuery.of(context).size.width,
                            margin:EdgeInsets.only(top:5),
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
                                          setState(()=>this.webSocketConnectionError = false);
                                          this.connectAndHandle();
                                        }
                                    )
                                )
                              ],
                            ),
                          )
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width - 20,
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: this.widgets.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding:EdgeInsets.all(5),
                                          child: Text(
                                              this.widgetSensorName[index],
                                              style: TextStyle(color: Colors.black,fontSize: 25)),
                                        ),
                                        Container(
                                            height:100,
                                            child:
                                            ListView.builder(
                                                physics: BouncingScrollPhysics(),
                                                itemCount: this.widgets[index].length,
                                                shrinkWrap: true,
                                                itemBuilder: (context,index2){
                                                  return Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment:  CrossAxisAlignment.stretch,
                                                      children: [
                                                        Padding(
                                                            padding: EdgeInsets.all(5),
                                                            child:this.widgets[index][index2]
                                                        )
                                                      ]
                                                  );
                                                },
                                                scrollDirection: Axis.horizontal
                                            )
                                        )
                                      ],
                                    );
                                  })
                          ),
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Graphs",style: new TextStyle(fontSize: 25, color: Colors.black)),
                                  Text("Press on one of the cards above.",style: new TextStyle(fontSize: 16, color: Colors.black)),
                                ],
                              )
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5,bottom: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.lightBlueAccent.withOpacity(0.8), Colors.blueAccent.withOpacity(0.6)],
                                )
                            ),
                            child: CustomPaint(
                              painter: ShapePainter(),
                              child: Container(),
                            ),
                          )
                        ]
                    ),
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                  )
                )
            )
          ],
        ),
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    Offset p1 = Offset(10, size.height-20 );
    Offset p2 = Offset(size.width-20, size.height -20);
    canvas.drawLine(p1, p2, paint);

    Offset p3 = Offset(20, 20);
    Offset p4 = Offset(20, size.height -10);
    canvas.drawLine(p3, p4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}