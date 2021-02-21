
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExplorationCard extends StatelessWidget{

  const ExplorationCard({Key key, this.description, this.title, this.width, this.onClick, this.imgPath, this.tag}) : super(key: key);

  final String description;
  final String title;
  final String imgPath;
  final double width;
  final Function onClick;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Container(
              width: width,
              decoration:  BoxDecoration(
                  borderRadius:  BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                    )
                  ]
              ),
              margin: EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: width,
                    height: width*9/16,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: AssetImage(imgPath)),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    child: Hero(
                      tag: tag,
                      child: Text(
                          title,
                          style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),
                    ),
                  Container(
                      padding: EdgeInsets.all(4),
                      child:
                      Text(
                          description,
                          style: TextStyle(color: Colors.black,fontSize: 15))),
                ],
              ),
            )
          ],
        ),
    );
  }

}