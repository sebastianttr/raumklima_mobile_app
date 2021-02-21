import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:raumklima/Models/WeatherDataModel.dart';
import 'package:raumklima/Pages/AIDemoPage.dart';
import 'package:raumklima/Pages/ARDemoPage.dart';
import 'package:raumklima/Pages/IoTDemoPage.dart';
import 'package:raumklima/Widgets/ExplorationCard.dart';

class ExplorationLayout extends StatefulWidget{

  final List<WeatherDataModel> listOfSensors;
  const ExplorationLayout({Key key, this.listOfSensors}) : super(key: key);

  @override
  _ExplorationLayout createState() => _ExplorationLayout();

}

class _ExplorationLayout extends State<ExplorationLayout>{
  var titles = [
    "IoT Demo","AR Demo","AI Demo","Instagram Followers Tool"
  ];

  var description = [
    "This will show you a page, where you can see data from a Sensor Node in real time using websockets.",
    "A small Augmented Reality app to display a 3D models and change its rotation.",
    "An artificial inteligence demo to train a certain image to then predict, which of the trained images it is.",
    "A tool to extract several information from an instagram page like followers, followed and posts."
  ];

  var images = [
    'images/iot_cropped.png',
    'images/ar_cropped.png',
    'images/ai_cropped.png',
    'images/instagram.png'
  ];

  List<Widget> pages = [IoTDemoPage(),ARDemoPage(),AIDemoPage()];

  void click(String title){
    print("Pressed on " + title);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = List.generate(titles.length, (index) {
      return
        GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return pages[index];
            }));
          },
            child: ExplorationCard(
              title: titles[index],
              tag: "appbarTitle$index",
              description: description[index],
              onClick: click,
              imgPath: images[index],
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 2,
            )
        );
    });

    return StaggeredGridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(2.0),
      children: cards,
      staggeredTiles:cards
          .map<StaggeredTile>((_) => StaggeredTile.fit(2))
          .toList(),
      mainAxisSpacing: 3.0,
      crossAxisSpacing: 4.0,
    );
  }

}