import 'dart:convert';

import 'package:choisi/api.dart';
import 'package:choisi/main.dart';
import 'package:choisi/model/superheros.dart';
import 'package:choisi/tableau.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
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

class Menu extends StatefulWidget {

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
  var superH = new List<SuperHeros>();

  Menu({Key key,
    @required this.token,
    @required this.films,
    @required this.realisateurs,
    @required this.chansons,
    @required this.jeux,
    @required this.avengers,
    @required this.mechants,
    @required this.disney,
    @required this.horreur,
    @required this.series,
    @required this.seriesAnimes,
    @required this.sports,
    @required this.sagas,
    @required this.superH
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _Menu();
  }
}

class _Menu extends State<Menu> {

  var rencontresId = new List<int>();
  var mapRencontres = new List<Map>();
  var listFinished = new List<bool>(11);

  var logg = new Logger();

  @override
  void initState() {
    super.initState();
    if(widget.superH==null) {
      getAll(widget.token);
    }
  }

  Future checkDatasInRealisateur(int nb, List listeTest) async {
    var list = new List<int>.generate(listeTest.length, (int index) => index); //rencontres par id
    List<String> listIdString = new List();
    list.shuffle();
    list.forEach((variable){
      listIdString.add(variable.toString());
    });
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setStringList("tableauID", listIdString);
    shared.setInt("id", 0);
    for(int i=0; i<list.length; i=i+2) {
      Map map = new Map();
      switch (nb) { //a modifier car ajout nouveaux boutons
        case 1 :
          map = {
            "domicile" : widget.films[list[i]],
            "exterieur" : widget.films[list[i+1]]
          };
          break;
        case 2 :
          map = {
          "domicile" : widget.realisateurs[list[i]],
          "exterieur" : widget.realisateurs[list[i+1]]
          };
          break;
        case 3 :
          map = {
            "domicile" : widget.jeux[list[i]],
            "exterieur" : widget.jeux[list[i+1]]
          };
          break;
        case 4 :
          map = {
            "domicile" : widget.horreur[list[i]],
            "exterieur" : widget.horreur[list[i+1]]
          };
          break;
        case 5 :
          map = {
            "domicile" : widget.series[list[i]],
            "exterieur" : widget.series[list[i+1]]
          };
          break;
        case 6 :
          map = {
            "domicile" : widget.seriesAnimes[list[i]],
            "exterieur" : widget.seriesAnimes[list[i+1]]
          };
          break;
        case 7 :
          map = {
            "domicile" : widget.superH[list[i]],
            "exterieur" : widget.superH[list[i+1]]
          };
          break;
        case 8 :
          map = {
            "domicile" : widget.avengers[list[i]],
            "exterieur" : widget.avengers[list[i+1]]
          };
          break;
        case 9 :
          map = {
            "domicile" : widget.chansons[list[i]],
            "exterieur" : widget.chansons[list[i+1]]
          };
          break;
        case 10 :
          map = {
            "domicile" : widget.mechants[list[i]],
            "exterieur" : widget.mechants[list[i+1]]
          };
          break;
        case 11 :
          map = {
            "domicile" : widget.disney[list[i]],
            "exterieur" : widget.disney[list[i+1]]
          };
          break;
        case 12 :
          map = {
            "domicile" : widget.sports[list[i]],
            "exterieur" : widget.sports[list[i+1]]
          };
          break;
        case 13 :
          map = {
            "domicile" : widget.sagas[list[i]],
            "exterieur" : widget.sagas[list[i+1]]
          };
          break;
      }
      mapRencontres.add(map);
    }
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC){
      return new Tableau(tests: mapRencontres, id: nb);
    }));

  }

  @override
  Widget build(BuildContext context) {
    if(mapRencontres.length!=0) { mapRencontres.clear(); }
    print(listFinished);
    return new Scaffold(
      body: new Center(
        child: new Column(
            children : <Widget>[
              new SizedBox(
                child: new Container(
                    decoration: new BoxDecoration(
                        color: Colors.red
                    ),
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text("Les tournois de Sofyan", textScaleFactor: 1.5, style: TextStyle(fontFamily: 'Disney'),),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                width: 150.0,
                                height: 150.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: ExactAssetImage("assets/sofyan.jpg")
                                    )
                                )
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height/3.5,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      containerBouton(1, widget.films, "Films"),
                                      containerBouton(2, widget.realisateurs, "Réalisateurs"),
                                      containerBouton(3, widget.jeux, "Jeux Vidéos"),
                                      containerBouton(4, widget.horreur, "Films d'horreur"),
                                      containerBouton(5, widget.series, "Séries"),
                                      containerBouton(6, widget.seriesAnimes, "Séries Animés"),
                                      //containerBouton(7, widget.superH, "Super Héros")
                                    ],
                                  ),
                                )
                            )
                          ],
                        ),
                      ],
                    )
                ),
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height/2),
              ),
              new SizedBox(
                child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.blue
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text("Les autres tournois", textScaleFactor: 1.5, style: TextStyle(fontFamily: 'Disney'),),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height/3.5,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  containerBouton(8, widget.avengers, "Avengers"),
                                  //containerBouton(9, widget.chansons, "Chansons Disney"),
                                  containerBouton(10, widget.mechants, "Méchants"),
                                  //containerBouton(11, widget.disney, "Films Disney"),
                                  containerBouton(12, widget.sports, "Sports"),
                                  containerBouton(13, widget.sagas, "Sagas")
                                ],
                              ),
                            ),
                          ),
                          Container(
                              width: 150.0,
                              height: 150.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: ExactAssetImage("assets/point_interrogation.jpg")
                                  )
                              )
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.height/2),
              ),
            ]
        ),
      ),
    );
  }

  containerBouton(int id, List list, String nom ) {
    return Container(
      width: MediaQuery.of(context).size.width /2.5,
      child: RaisedButton(
        onPressed: () {
          checkDatasInRealisateur(id, list);
        },
        child: new Text(nom, style: TextStyle(fontFamily: 'Disney'), textAlign: TextAlign.center,),
      ),
      margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
    );
  }

  getAll(String token) {
    API.getMovies(token).then((response) {
      setState(() {
        try {
          Iterable list = json.decode(response.body);
          widget.films = list.map((film) => Films.fromJson(film)).toList();
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
          widget.realisateurs = list.map((model) => Realisateur.fromJson(model)).toList();
        }
      });
    });
    API.getGames(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.jeux = list.map((jeu) => Jeux.fromJson(jeu)).toList();
        }
      });
    });
    API.getHorreurs(token).then((response) {
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.horreur = list.map((hor) => Films.fromJson(hor)).toList();
        }
      });
    });
    API.getSeries(token).then((response){
      print(response.body);
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.series = list.map((serie) => Series.fromJson(serie)).toList();
        }
      });
    });
    API.getSeriesAnimes(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.seriesAnimes = list.map((serie) => Series.fromJson(serie)).toList();
        }
      });
    });
    API.getAvengers(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.avengers = list.map((heros) => Avengers.fromJson(heros)).toList();
        }
      });
    });
    API.getSongs(token).then((response) {
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.chansons = list.map((model) => Chansons.fromJson(model)).toList();
        }
      });
    });
    API.getMechants(token).then((response) {
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.mechants = list.map((mechant) => Mechants.fromJson(mechant)).toList();
        }
      });
    });
    API.getDisney(token).then((response) {
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.disney = list.map((disneyF) => Disney.fromJson(disneyF)).toList();
        }
      });
    });
    API.getSports(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.sports = list.map((sport) => Sports.fromJson(sport)).toList();
        }
      });
    });
    API.getSagas(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.sagas = list.map((saga) => Sagas.fromJson(saga)).toList();
        }
      });
    });
    API.getSuperHeros(token).then((response){
      setState(() {
        if(response.body == null) {
          logg.i("Erreur");
        } else {
          Iterable list = json.decode(response.body);
          widget.superH = list.map((sh) => SuperHeros.fromJson(sh)).toList();
        }
      });
    });
  }
}