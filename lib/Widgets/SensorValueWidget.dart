
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SensorValueWidget extends StatelessWidget{
  const SensorValueWidget({Key key, this.value, this.title, this.width}) : super(key: key);
  
  final String value;
  final String title;
  final double width;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: width,
            decoration:  BoxDecoration(
                borderRadius:  BorderRadius.all(Radius.circular(10.0)),
                gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color.fromRGBO(0, 67, 130,1), Color.fromRGBO(0,130,124,1)]),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 1.5,
                    blurRadius: 1.5,
                  )
                ]
            ),
            margin: EdgeInsets.all(3.0),
            padding: EdgeInsets.all(3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(4),
                  child:
                    Text(
                        title,
                        style: TextStyle(color: Colors.white,fontSize: 16)),),
                Text(value,textScaleFactor: 2.0,style: TextStyle(color: Colors.white))
              ],
            ),
          )

        ],
      ),
    );
  }

}