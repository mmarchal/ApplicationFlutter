import 'dart:convert';

import 'package:choisi/api.dart';
import 'package:choisi/model/films.dart';
import 'package:choisi/tableauV2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

class MenuV2 extends StatefulWidget {

  String token;

  MenuV2({Key key,
    @required this.token
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _MenuV2();
  }
}

class _MenuV2 extends State<MenuV2> {

  var logg = new Logger();

  List<Films> tournoi = new List();

  containerBouton(int id, String nom ) {
    return Container(
      width: MediaQuery.of(context).size.width /2.5,
      child: RaisedButton(
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC) {
            return new TableauV2(id : id, nom: nom, token: widget.token, isStarting: true,);
          }));
        },
        child: new Text(nom, style: TextStyle(fontFamily: 'Disney'), textAlign: TextAlign.center,),
      ),
      margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
                                      containerBouton(1, "Films"),
                                      //containerBouton(2, widget.realisateurs, "Réalisateurs"),
                                      //containerBouton(3, "Jeux Vidéos"),
                                      //containerBouton(4, widget.horreur, "Films d'horreur"),
                                      //containerBouton(5, "Séries"),
                                      //containerBouton(6, "Séries Animés"),
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
                                  //containerBouton(8, "Avengers"),
                                  //containerBouton(9, widget.chansons, "Chansons Disney"),
                                  //containerBouton(10, "Méchants"),
                                  //containerBouton(11, widget.disney, "Films Disney"),
                                  //containerBouton(12, "Sports"),
                                  //containerBouton(13, "Sagas")
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

}