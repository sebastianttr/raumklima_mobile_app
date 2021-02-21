import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AIDemoPage extends StatefulWidget{
  @override
  _AIDemoPage createState() =>_AIDemoPage();
}

class _AIDemoPage extends State<AIDemoPage>{
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
                  tag:"appbarTitle2",
                  child: Text(
                      "AI Demo",
                      style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold)),
                )
            )
          ],

        ),
      ),
    );
  }
}