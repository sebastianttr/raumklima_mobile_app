import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget{
  @override
  _AboutPage createState() =>_AboutPage();
}

class _AboutPage extends State<AboutPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About page"),
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            Navigator.pop(context);
          }),
        ),
      ),
    );
  }
}