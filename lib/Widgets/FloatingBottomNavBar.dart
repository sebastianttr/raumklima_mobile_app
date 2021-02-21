import 'package:flutter/material.dart';
import 'package:raumklima/Models/FloatingBottomBarItems.dart';

class FloatingBottomNavbar extends StatefulWidget{
  final int nElements;
  final Function callback;
  final List<FloatingBottomBarItems> elements;
  final int index;
  const FloatingBottomNavbar({Key key, this.callback, this.nElements, this.elements, this.index}) : super(key: key);

  @override
  _FloatingBottomNavbar createState() =>_FloatingBottomNavbar();
}

class _FloatingBottomNavbar extends State<FloatingBottomNavbar>{

  @override
  Widget build(BuildContext context) {
    int index = widget.index;
    return Align(
        alignment: Alignment.bottomCenter,
        child:(
            Container(
                height: 65,
                width: MediaQuery.of(context).size.width,
                margin: new EdgeInsets.all(7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Colors.white10.withOpacity(1),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 4,
                          blurRadius: 6
                      )
                    ]
                ),
                child:(
                    Container(
                      margin: EdgeInsets.only(bottom:5),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for(int i = 0;i<widget.nElements;i++)
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  widget.callback(i);
                                  index = i;
                                });
                              },
                              child:  Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AnimatedContainer(
                                    width: MediaQuery.of(context).size.width/widget.nElements - 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white
                                    ),
                                      padding: EdgeInsets.only(
                                        top: 5,
                                        bottom: (i==index)?8:5,
                                      ),
                                      child:
                                        Column(
                                            children: [
                                              Icon(widget.elements[i].icon,color: (i==index)?Colors.blueAccent:Colors.black),
                                              Text(widget.elements[i].label,style : TextStyle(color: (i==index)?Colors.blueAccent:Colors.black))
                                            ]
                                        ),
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.fastOutSlowIn,
                                  )
                                ],
                              ),
                            ),
                        ],
                      ),
                    )
                )
            )
        )
    );
  }

}
