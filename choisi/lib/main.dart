import 'dart:async';
import 'package:choisi/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:choisi/api.dart';
import 'package:xml/xml.dart' as xml;


void main() {
  List<DeviceOrientation> values = [DeviceOrientation.portraitUp];
  SystemChrome.setPreferredOrientations(values);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sofyan Boudouni',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Sofyan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String token;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    API.getToken().then((value) {
      if(value.status==200) {
        setState(() {
          token = value.result.token;
        });
      } else {
        print("${value.status} : ${value.message}");
      }
    });
  }

InkWell imageLogo(String image, String url) {
    return new InkWell(
      child: new Image.asset(
        image,
        width: (image=="youtube.png") ? MediaQuery.of(context).size.width/4 : MediaQuery.of(context).size.width/5,
      ),
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
  }

  Future changePage(/*bool sexe*/) async {
    var shared = await SharedPreferences.getInstance();
    shared.setString("tourSuivant", "");
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bContext){
      return new Menu(token: token,);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Inspire des idees du youtubeur \nSofyan Boudouni',
              textAlign: TextAlign.center,
              textScaleFactor: 2.0,
              style: new TextStyle(
                fontFamily: 'Brushield'
              ),
            ),
            Container(
                width: 200.0,
                height: 200.0,
                margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: ExactAssetImage("assets/sofyan.jpg")
                    )
                )
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                imageLogo("instagram.png", "https://www.instagram.com/sofyanboudouni/?hl=fr"),
                imageLogo("youtube.png", "https://www.youtube.com/user/sofyanfaitducinema"),
                imageLogo("twitter.png", "https://twitter.com/sofyanboudouni"),
              ],
            ),
            //new CircularProgressIndicator(),
            Padding(padding: EdgeInsets.all(20.0),),
            RaisedButton(
              onPressed: () {
                changePage();
                //_showDialog();
              },
              child: new Text(
                "Aller au menu",
                textScaleFactor: 2.0,
                style: new TextStyle(
                    fontFamily: 'Brushield'
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
