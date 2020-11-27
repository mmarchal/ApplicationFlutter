import 'dart:convert';

import 'package:choisi/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'model/films.dart';

class TableauV2 extends StatefulWidget {

  final int id;
  final String nom;
  final String token;

  TableauV2({Key key, @required this.id, this.nom, @required this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _TableauV2();
  }

}

class Rencontre {
  var domicile;
  var exterieur;

  Rencontre.fromJson(Map map) :
        domicile = map["domicile"],
        exterieur = map["exterieur"];
}

class _TableauV2 extends State<TableauV2> {

  List listeTournoi = new List();
  List listeRencontres = new List();

  List<Color> listeCouleurs = [
    Colors.red.shade200,
    Colors.blue.shade200,
    Colors.green.shade200,
  ];

  var logg = new Logger();

  @override
  void initState() {
    super.initState();
    switch (widget.id) {
      case 1 :
        API.getMovies(widget.token).then((response) {
          setState(() {
            try {
              Iterable list = json.decode(response.body);
              listeTournoi = list.map((film) => Films.fromJson(film)).toList();
            } on NoSuchMethodError catch (e) {
              logg.i(e.toString());
            } finally {
              listeTournoi = API.shuffle(listeTournoi);
              for (int i =0 ; i<listeTournoi.length ; i=i+2) {
                Map map = {
                  "domicile" : listeTournoi[i],
                  "exterieur" : listeTournoi[i+1]
                };
                listeRencontres.add(Rencontre.fromJson(map));
              }
              /*for( int i = 0; i<listeTournoi.length; i=i+2) {
                print(i);
              }*/
            }
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.nom),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                clickInfo(context);
              }
          )
        ],
      ),
      body: tableauBody(),
    );
  }

  double relativeDouble(BuildContext context, double originalDouble) {
    double defaultRatio = 812 / 375;
    double currentRatio = MediaQuery.of(context).size.height / MediaQuery.of(context).size.width;
    return currentRatio * originalDouble / defaultRatio;
  }

  Future clickInfo(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0))
          ),
          title: Text('CODE COULEUR', textAlign: TextAlign.center, textScaleFactor: 2.0, style: TextStyle(color: Colors.black),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("BLEU --> DUEL NON REALISE", textAlign: TextAlign.center, textScaleFactor: 1.5, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Text("VERT --> DUEL REALISE", textAlign: TextAlign.center, textScaleFactor: 1.5, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
            ],
          ),
          actions: [
            FlatButton(
              child: Text("OK", textAlign: TextAlign.center, textScaleFactor: 1.5, style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  tableauBody() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(listeRencontres.length, (index) {
        Films domicile = Films.testJson(listeRencontres[index].domicile.toString());
        Films exterieur = Films.testJson(listeRencontres[index].exterieur.toString());
        return Card(
          elevation: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Text(
                  '${domicile.nom}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Image.asset(
                "assets/versus.png",
                width: MediaQuery.of(context).size.width/7,
              ),
              Container(
                child: Text(
                  '${exterieur.nom}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}