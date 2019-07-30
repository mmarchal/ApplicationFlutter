import 'dart:convert';
import 'package:choisi/api.dart';
import 'package:choisi/model/chansons.dart';
import 'package:choisi/model/films.dart';
import 'package:choisi/model/jeux.dart';
import 'package:choisi/model/avengers.dart';
import 'package:choisi/model/mechants.dart';
import 'package:choisi/model/tournoi.dart';
import 'package:choisi/tableau.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {

  String token;

  Menu({Key key, @required this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _Menu();
  }
}

class _Menu extends State<Menu> {

  var films = new List<Films>();
  var realisateurs = new List<Tournoi>();
  var chansons = new List<Chansons>();
  var jeux = new List<Jeux>();
  var avengers = new List<Avengers>();
  var mechants = new List<Mechants>();
  var rencontresId = new List<int>();
  var mapRencontres = new List<Map>();

  bool isFinish = false;

  @override
  void initState() {
    super.initState();
    _getAll();
  }

  _getAll() {
    API.getUsers(widget.token).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        realisateurs = list.map((model) => Tournoi.fromJson(model)).toList();
      });
    });
    API.getSongs(widget.token).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        chansons = list.map((model) => Chansons.fromJson(model)).toList();
      });
    });
    API.getGames(widget.token).then((response){
      setState(() {
        Iterable list = json.decode(response.body);
        jeux = list.map((jeu) => Jeux.fromJson(jeu)).toList();
      });
    });
    API.getMovies(widget.token).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        films = list.map((film) => Films.fromJson(film)).toList();
      });
    });
    API.getAvengers(widget.token).then((response){
      setState(() {
        Iterable list = json.decode(response.body);
        avengers = list.map((heros) => Avengers.fromJson(heros)).toList();
      });
    });
    API.getMechants(widget.token).then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        mechants = list.map((mechant) => Mechants.fromJson(mechant)).toList();
      });
    });
    isFinish = true;
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
      switch (nb) {
        case 1 :
          map = {
            "domicile" : films[list[i]],
            "exterieur" : films[list[i+1]]
          };
          break;
        case 2 :
          map = {
          "domicile" : realisateurs[list[i]],
          "exterieur" : realisateurs[list[i+1]]
          };
          break;
        case 3 :
          map = {
            "domicile" : jeux[list[i]],
            "exterieur" : jeux[list[i+1]]
          };
          break;
        case 4 :
          map = {
            "domicile" : avengers[list[i]],
            "exterieur" : avengers[list[i+1]]
          };
          break;
        case 5 :
          map = {
            "domicile" : chansons[list[i]],
            "exterieur" : chansons[list[i+1]]
          };
          break;
        case 6 :
          map = {
            "domicile" : mechants[list[i]],
            "exterieur" : mechants[list[i+1]]
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
    if(isFinish) {
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
                          Text("Les tournois de Sofyan", style: TextStyle(fontFamily: 'Disney'),),
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width /2.5,
                                    child: RaisedButton(
                                      onPressed: () {
                                        checkDatasInRealisateur(1, realisateurs);
                                      },
                                      child: new Text("Films", style: TextStyle(fontFamily: 'Disney'),),
                                    ),
                                    margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width /2.5,
                                    child: RaisedButton(
                                      onPressed: () {checkDatasInRealisateur(2, realisateurs);},
                                      child: new Text("Réalisateur", style: TextStyle(fontFamily: 'Disney'),),
                                    ),
                                    margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width /2.5,
                                    child: RaisedButton(
                                      onPressed: () {checkDatasInRealisateur(3, jeux);},
                                      child: new Text("Jeux vidéos", style: TextStyle(fontFamily: 'Disney'),),
                                    ),
                                    margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
                                  ),
                                ],
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
                        new Text("Les autres tournois", style: TextStyle(fontFamily: 'Disney'),),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width /2.5,
                                  child: RaisedButton(
                                    onPressed: () {
                                      checkDatasInRealisateur(4, avengers);
                                    },
                                    child: new Text("Avengers", style: TextStyle(fontFamily: 'Disney'),),
                                  ),
                                  margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width /2.5,
                                  child: RaisedButton(
                                    onPressed: () {
                                      checkDatasInRealisateur(5, chansons);
                                    },
                                    child: new Text("Chansons Disney", textScaleFactor: 0.9, style: TextStyle(fontFamily: 'Disney'),),
                                  ),
                                  margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width /2.5,
                                  child: RaisedButton(
                                    onPressed: () {
                                      checkDatasInRealisateur(6, mechants);
                                    },
                                    child: new Text("Méchants", style: TextStyle(fontFamily: 'Disney'),),
                                  ),
                                  margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
                                ),
                              ],
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
    } else {
      return new Scaffold(
        body: new Center(
          child: new CircularProgressIndicator(),
        ),
      );
    }
  }
}