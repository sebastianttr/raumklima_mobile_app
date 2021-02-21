import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IotDemoCard extends StatefulWidget{
  final double height;
  final double width;
  final String value;
  final String name;

  const IotDemoCard({Key key, this.height, this.width, this.value, this.name}) : super(key: key);

  @override
  _IotDemoCard createState()  => _IotDemoCard();
}

class _IotDemoCard extends State<IotDemoCard>{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
            colors: [Colors.lightGreen.withOpacity(0.8), Colors.greenAccent.withOpacity(0.6)],
        )
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(2),
              child: Text(widget.value,style: TextStyle(fontSize: 40)),
            ),
            Padding(
              padding: EdgeInsets.all(3),
              child: Text(widget.name,style: TextStyle(fontSize: 19)),
            )
          ],
        )


    );
  }
}