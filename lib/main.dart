import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:raumklima/Models/FloatingBottomBarItems.dart';
import 'package:raumklima/Models/RaumklimaModel.dart';

import 'Layouts/ExplorationLayout.dart';
import 'Layouts/OverviewLayout.dart';
import 'Models/WeatherDataModel.dart';
import 'Pages/AboutPage.dart';
import 'Widgets/CustomAppBar.dart';
import 'Widgets/FloatingBottomNavBar.dart';
import 'Widgets/PlaceholderWidget.dart';
import 'package:http/http.dart' as http;


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_){
    runApp(MyApp());
  }
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'OpenSans',
          primaryColor: Colors.white
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/about': (context) => AboutPage(),
      },
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  List<FloatingBottomBarItems> floatingBottomNavBarElements = [
    FloatingBottomBarItems(Icons.home,"Dashboard"),
    FloatingBottomBarItems(Icons.dashboard,"Sensoren"),
    FloatingBottomBarItems(Icons.location_city,"Räume")
  ];

  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();

  setBottomAppBar(bool bool) {}
}



class _MyHomePageState extends State<MyHomePage> {
  int bottomNavBarIndex = 0;
  bool bottomNavBarVisible = true;

  int startPosition = 0;
  int endPosition = 0;

  List<RaumklimaModel> listOfSensors = [];

  List<Widget> children(){
    return [
      OverviewLayout(listOfSensors: listOfSensors,key: overviewLayoutKey,onUpdateRequest: fetchCities,),
      ExplorationLayout(),
      PlaceholderWidget(Colors.green),
    ];
  }

  GlobalKey<CustomAppBarState> customAppBarKey = GlobalKey<CustomAppBarState>();
  GlobalKey<OverviewLayoutState> overviewLayoutKey = GlobalKey<OverviewLayoutState>();
  ValueNotifier<int> valueNotifier = ValueNotifier(0);
  TextEditingController cityNameFieldController = TextEditingController();
  PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchCities();
  }

  void changeIndex(int index){
    setState(() {
      _pageController.jumpToPage(index);
      bottomNavBarIndex = index;
    });
  }

  void fetchCities() async {
    print("Fetching...");
    HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    var ioClient = new IOClient(client);
    http.Response response = await ioClient.get("https://192.168.0.159:45455/api/getSensoren");
    listOfSensors = [];
    if (response.statusCode == 200) {
      //print("Got a response");
      //print(response.body);
      var json = jsonDecode(response.body);
      json.forEach((key,val){
          setState(() {
            if(val!=null)
              listOfSensors.add(
                new RaumklimaModel(
                    key.toString(),
                    double.parse(val["temperatur"].toString()),
                    int.parse(val["feuchte"].toString()),
                    int.parse(val["cO2"].toString()),
                    DateTime.parse(val["zeit"])));
            else if(val==null)
              listOfSensors.add(
                new RaumklimaModel(
                    key.toString(),
                    null,
                    null,
                    null,
                    null));
          });
      });
      overviewLayoutKey.currentState.update(listOfSensors);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  _showMaterialDialog() {
    showGeneralDialog(context: context,
        barrierLabel: "Hello there",
        barrierDismissible: true,
        transitionDuration: Duration(milliseconds: 250), //This is time
        barrierColor: Colors.black.withOpacity(0.5), // Add this property is color
        pageBuilder: (BuildContext context, Animation animation,
            Animation secondaryAnimation) {
          return Center(
              child: Card(
                margin:MediaQuery.of(context).viewInsets ,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width-30,
                  padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Add new room",style: TextStyle(fontSize: 25)),
                      Container(
                          margin: EdgeInsets.only(top: 15,bottom: 15),
                          child: TextField(
                            controller: cityNameFieldController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25))
                              ),
                              focusedBorder: OutlineInputBorder(),
                              hintText: "Raum hinzufügen",
                            ),
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            child: Text('Abbrechen'),
                            textColor: Colors.lightBlue,
                            onPressed: () {
                              cityNameFieldController.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Ok'),
                            textColor: Colors.lightBlue,
                            onPressed: ()async {
                              HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
                              var ioClient = new IOClient(client);
                              ioClient.get("https://192.168.0.159:45455/api/addSensor/${cityNameFieldController.text}")
                              .then((value) {
                                if(value.statusCode == 200){
                                  fetchCities();
                                }
                                return null;
                              });
                              cityNameFieldController.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          key: customAppBarKey,
          onPress: (){
            _showMaterialDialog();
          },
        ),
        body: Stack(
          children: [
            Listener(
                onPointerDown: (data){
                  startPosition = data.position.dy.toInt();
                },
                onPointerUp: (data){
                  endPosition = data.position.dy.toInt();
                  int delta = startPosition - endPosition;
                  if(delta >= 50){
                    setState(() {
                      bottomNavBarVisible = false;
                    });
                  }
                  else if(delta <= -50){
                    setState(() {
                      bottomNavBarVisible = true;
                    });
                  }
                },
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  children: children(),
                  pageSnapping: true,
                  onPageChanged: (pos){
                    setState(() {
                      bottomNavBarIndex = pos;
                      customAppBarKey.currentState.showAddButton(bottomNavBarIndex==0);
                    });
                  },
                )

            ),
            AnimatedPositioned(duration: Duration(milliseconds: 450),
                bottom: bottomNavBarVisible?0:-100,
                width: MediaQuery.of(context).size.width,
                curve: Curves.fastOutSlowIn,
                child: FloatingBottomNavbar(callback: changeIndex,nElements: children().length,elements: widget.floatingBottomNavBarElements,index: bottomNavBarIndex)
            ),
          ],
        )
    );
  }
}