import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ARDemoPage extends StatefulWidget{
  @override
  _ARDemoPage createState() =>_ARDemoPage();
}

class _ARDemoPage extends State<ARDemoPage>{
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
        child: Row(
          children: [
            Padding(
                padding: EdgeInsets.all(10),child:
                Hero(
                  tag:"appbarTitle1",
                  child: Text(
                      "AR Demo",
                      style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold)),
                )
            )
          ],

        ),
      ),
    );
  }
}