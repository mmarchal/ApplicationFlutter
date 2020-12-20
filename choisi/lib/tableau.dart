import 'package:choisi/match.dart';
import 'package:choisi/menu.dart';
import 'package:choisi/model/avengers.dart';
import 'package:choisi/model/chansons.dart';
import 'package:choisi/model/disney.dart';
import 'package:choisi/model/films.dart';
import 'package:choisi/model/jeux.dart';
import 'package:choisi/model/mechants.dart';
import 'package:choisi/model/sagas.dart';
import 'package:choisi/model/series.dart';
import 'package:choisi/model/sports.dart';
import 'package:choisi/model/superheros.dart';
import 'package:choisi/model/realisateur.dart';
import 'package:flutter/material.dart';

class Tableau extends StatefulWidget {

  final List<Map> tests;
  final int id;

  Tableau({Key key,this.tests, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _Tableau();
  }

}

class _Tableau extends State<Tableau> {

  int adversaire;
  List listeDomicile = new List();
  List listeExterieur = new List();

  var isVisible = true;

  @override
  void initState() {
    super.initState();
    if(widget.tests.length==0) {
      setState(() {
        isVisible = false;
      });
    } else {
      setState(() {
        isVisible = true;
      });
    }
    widget.tests.forEach((test) {
      switch (widget.id) {
        case 1:
          Rencontre rencontre = Rencontre.filmsFromJson(test);
          listeDomicile.add(rencontre.domicileF);
          listeExterieur.add(rencontre.exterieurF);
          break;
        case 2:
          Rencontre rencontre = Rencontre.tournoiFromJson(test);
          listeDomicile.add(rencontre.domicileT);
          listeExterieur.add(rencontre.exterieurT);
          break;
        case 3 :
          Rencontre rencontre = Rencontre.jeuxFromJson(test);
          listeDomicile.add(rencontre.domicileJ);
          listeExterieur.add(rencontre.exterieurJ);
          break;
        case 4 :
          Rencontre rencontre = Rencontre.horreurFromJson(test);
          listeDomicile.add(rencontre.domicileH);
          listeExterieur.add(rencontre.exterieurH);
          break;
        case 5 :
          Rencontre rencontre = Rencontre.seriesFromJson(test);
          listeDomicile.add(rencontre.domicileS);
          listeExterieur.add(rencontre.exterieurS);
          break;
        case 6 :
          Rencontre rencontre = Rencontre.seriesAnimesFromJson(test);
          listeDomicile.add(rencontre.domicileSA);
          listeExterieur.add(rencontre.exterieurSA);
          break;
        case 7 :
          Rencontre rencontre = Rencontre.superHerosFromJson(test);
          listeDomicile.add(rencontre.domicileSh);
          listeExterieur.add(rencontre.exterieurSh);
          break;
        case 8 :
          Rencontre rencontre = Rencontre.avengersFromJson(test);
          listeDomicile.add(rencontre.domicileA);
          listeExterieur.add(rencontre.exterieurA);
          break;
        case 9 :
          Rencontre rencontre = Rencontre.chansonFromJson(test);
          listeDomicile.add(rencontre.domicileC);
          listeExterieur.add(rencontre.exterieurC);
          break;
        case 10 :
          Rencontre rencontre = Rencontre.mechantsFromJson(test);
          listeDomicile.add(rencontre.domicileM);
          listeExterieur.add(rencontre.exterieurM);
          break;
        case 11 :
          Rencontre rencontre = Rencontre.disneyFromJson(test);
          listeDomicile.add(rencontre.domicileD);
          listeExterieur.add(rencontre.exterieurD);
          break;
        case 12 :
          Rencontre rencontre = Rencontre.sportsFromJson(test);
          listeDomicile.add(rencontre.domicileSp);
          listeExterieur.add(rencontre.exterieurSp);
          break;
        case 13 :
          Rencontre rencontre = Rencontre.sagasFromJson(test);
          listeDomicile.add(rencontre.domicileSa);
          listeExterieur.add(rencontre.exterieurSa);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: isVisible,
                child: new Container(
                  margin: EdgeInsets.all(20.0),
                  child: new Text("Voici les matchs !", style: TextStyle(fontFamily:'Varsity' ),),
                ),
              ),
              generateWidgets(),
              Visibility(
                visible: isVisible,
                child: new RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (BuildContext buildC) {
                          return new Match(domiciles: listeDomicile,
                              exterieurs: listeExterieur,
                              id: widget.id);
                        }));
                  },
                  child: new Text("Lancer !", style: TextStyle(fontFamily:'Varsity'),),
                ),
              )
            ],
          )
      ),
    );
  }

  generateWidgets() {
    if(widget.tests.length==0) {
      return new Center(
        child: new Text('Les datas se sont pas chargés, revenez au menu principal !', textScaleFactor: 2.5, textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
      );
    } else {
      return new Flexible(
        child: new ListView.builder(
          itemCount: listeDomicile.length,
          itemBuilder: (context, i) {
            var joueur1 = listeDomicile[i];
            var joueur2 = listeExterieur[i];
            return Card(
              elevation: 10.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      alignment: Alignment.center,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 3,
                      child: new Text(
                        joueur1.nom,
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Varsity'),
                      ),
                    ),
                    new Image.asset(
                      "assets/versus.png", width: 80.0, height: 80.0,),
                    new Container(
                      alignment: Alignment.center,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 3,
                      child: new Text(joueur2.nom, maxLines: 3,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'Varsity'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}

class Rencontre {
  Films domicileF, exterieurF;
  Realisateur domicileT, exterieurT; //Réalisateur
  Jeux domicileJ, exterieurJ;
  Films domicileH, exterieurH;
  Series domicileS, exterieurS;
  Series domicileSA, exterieurSA;
  Avengers domicileA, exterieurA;
  Chansons domicileC, exterieurC;
  Mechants domicileM, exterieurM;
  Disney domicileD, exterieurD;
  Sports domicileSp, exterieurSp;
  Sagas domicileSa, exterieurSa;
  SuperHeros domicileSh, exterieurSh;


  Rencontre.filmsFromJson(Map map) :
        domicileF = map["domicile"],
        exterieurF = map["exterieur"];

  Rencontre.tournoiFromJson(Map map) :
    domicileT = map["domicile"],
    exterieurT = map["exterieur"];

  Rencontre.jeuxFromJson(Map map) :
        domicileJ = map["domicile"],
        exterieurJ = map["exterieur"];

  Rencontre.horreurFromJson(Map map) :
      domicileH = map["domicile"],
      exterieurH = map["exterieur"];

  Rencontre.seriesFromJson(Map map) :
        domicileS = map["domicile"],
        exterieurS = map["exterieur"];

  Rencontre.seriesAnimesFromJson(Map map) :
        domicileSA = map["domicile"],
        exterieurSA = map["exterieur"];

  Rencontre.superHerosFromJson(Map map) :
        domicileSh = map["domicile"],
        exterieurSh = map["exterieur"];

  Rencontre.avengersFromJson(Map map) :
        domicileA = map["domicile"],
        exterieurA = map["exterieur"];

  Rencontre.chansonFromJson(Map map) :
      domicileC = map["domicile"],
      exterieurC = map["exterieur"];

  Rencontre.mechantsFromJson(Map map) :
        domicileM = map["domicile"],
        exterieurM = map["exterieur"];

  Rencontre.disneyFromJson(Map map) :
        domicileD = map["domicile"],
        exterieurD = map["exterieur"];

  Rencontre.sportsFromJson(Map map) :
      domicileSp = map["domicile"],
      exterieurSp = map["exterieur"];

  Rencontre.sagasFromJson(Map test) :
      domicileSa = test["domicile"],
      exterieurSa = test["exterieur"];
}