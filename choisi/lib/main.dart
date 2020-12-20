import 'dart:async';
import 'dart:convert';
import 'package:choisi/menu.dart';
import 'package:choisi/model/superheros.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:choisi/api.dart';
import 'package:choisi/model/chansons.dart';
import 'package:choisi/model/disney.dart';
import 'package:choisi/model/films.dart';
import 'package:choisi/model/jeux.dart';
import 'package:choisi/model/avengers.dart';
import 'package:choisi/model/mechants.dart';
import 'package:choisi/model/sagas.dart';
import 'package:choisi/model/series.dart';
import 'package:choisi/model/sports.dart';
import 'package:choisi/model/realisateur.dart';


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

  var films = new List<Films>();
  var realisateurs = new List<Realisateur>();
  var chansons = new List<Chansons>();
  var jeux = new List<Jeux>();
  var avengers = new List<Avengers>();
  var mechants = new List<Mechants>();
  var disney = new List<Disney>();
  var horreur = new List<Films>();
  var series = new List<Series>();
  var seriesAnimes = new List<Series>();
  var sports = new List<Sports>();
  var sagas = new List<Sagas>();
  var superHeros = new List<SuperHeros>();

  var logg = new Logger();
  var erreur;

  bool allIsFinish = false;
  bool progressBool = true;

  @override
  void initState() {
    super.initState();
    API.getToken().then((value) {
      try {
        if(value.status==200) {
          setState(() {
            token = value.result.token;
            progressBool = false;
            allIsFinish = true;
          });
          print(superHeros.isEmpty);
          if(superHeros.isEmpty) {
            getAll();
          }
        }
      } on Error catch(e) {
        progressBool = false;
        print(e.stackTrace);
        setState(() {
          erreur = e;
        });
        showErrorDialog();
      }
    });
  }

  getAll() {
    API.getMovies(token).then((response) {
      setState(() {
        try {
          Iterable list = json.decode(response.body);
          films = list.map((film) => Films.fromJson(film)).toList();
        } on NoSuchMethodError catch (e) {
          logg.i(e.toString());
        }
      });
    });
    API.getRealisateurs(token).then((response) {
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          realisateurs = list.map((model) => Realisateur.fromJson(model)).toList();
        }
      });
    });
    API.getGames(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          jeux = list.map((jeu) => Jeux.fromJson(jeu)).toList();
        }
      });
    });
    API.getHorreurs(token).then((response) {
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          horreur = list.map((hor) => Films.fromJson(hor)).toList();
        }
      });
    });
    API.getSeries(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          series = list.map((serie) => Series.fromJson(serie)).toList();
        }
      });
    });
    API.getSeriesAnimes(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          seriesAnimes = list.map((serie) => Series.fromJson(serie)).toList();
        }
      });
    });
    API.getAvengers(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          avengers = list.map((heros) => Avengers.fromJson(heros)).toList();
        }
      });
    });
    API.getSongs(token).then((response) {
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          chansons = list.map((model) => Chansons.fromJson(model)).toList();
        }
      });
    });
    API.getMechants(token).then((response) {
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          mechants = list.map((mechant) => Mechants.fromJson(mechant)).toList();
        }
      });
    });
    API.getDisney(token).then((response) {
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          disney = list.map((disneyF) => Disney.fromJson(disneyF)).toList();
        }
      });
    });
    API.getSports(token).then((response){
      print(response.body);
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          sports = list.map((sport) => Sports.fromJson(sport)).toList();
        }
      });
    });
    API.getSagas(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          sagas = list.map((saga) => Sagas.fromJson(saga)).toList();
        }
      });
    });
    API.getSuperHeros(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          superHeros = list.map((sh) => SuperHeros.fromJson(sh)).toList();
        }
      });
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
      return new Menu(token: token, films: films, realisateurs: realisateurs,chansons: chansons, jeux: jeux, avengers: avengers, mechants: mechants, disney: disney, horreur: horreur, series: series, seriesAnimes: seriesAnimes, sports: sports, sagas: sagas, superH: superHeros,);
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
            Container(
              child: Visibility(
                visible: progressBool,
                child: CircularProgressIndicator()
              ),
            ),
            Visibility(
              visible: allIsFinish,
              child: RaisedButton(
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Erreur de serveur"),
          content: new Text("Impossible d'accéder aux données\n$erreur"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK, recharger la page !"),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext bC){
                  return new MyHomePage();
                }));
              },
            ),
          ],
        );
      },
    );
  }
}
