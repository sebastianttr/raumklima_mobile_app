import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget{
  final Function onPress;

  const CustomAppBar({Key key,  this.onPress}) : super(key: key);

  @override
  CustomAppBarState createState(){
    return CustomAppBarState();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size.fromHeight(55.0);
}

class CustomAppBarState extends State<CustomAppBar>{
  static bool addButton = true;

  @override
  void initState() {
    super.initState();
  }

  void showAddButton(bool state) => addButton = state;

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text("Raumklima",style: TextStyle(color: Colors.black),),
      elevation: 0,
      backgroundColor: Colors.white60,
      automaticallyImplyLeading: true,
      leading: Icon(
          Icons.home,color: Colors.black,size: 30,
      ),
      actions: [
          if(addButton)
            AnimatedContainer(
              duration: Duration(microseconds: 600),
              curve: Curves.fastOutSlowIn,
              child: IconButton(icon: Icon(Icons.add), onPressed: (){
                  widget.onPress();
              }),
            ),
          IconButton(icon: Icon(Icons.info), onPressed: (){
            Navigator.pushNamed(context, '/about');
          }),
      ],
      actionsIconTheme: IconThemeData(
          size: 30.0,
          color: Colors.black,
          opacity: 10.0
      ),
    );
  }

}