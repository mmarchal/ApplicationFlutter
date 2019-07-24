import 'package:choisi/model/jeux.dart';
import 'package:flutter/material.dart';
import 'package:choisi/model/chansons.dart';
import 'package:choisi/model/tournoi.dart';
import 'package:choisi/match.dart';

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

  @override
  void initState() {
    super.initState();
    print(widget.tests.length);
    widget.tests.forEach((test) {
      switch (widget.id) {
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
        case 5 :
          Rencontre rencontre = Rencontre.chansonFromJson(test);
          listeDomicile.add(rencontre.domicileC);
          listeExterieur.add(rencontre.exterieurC);
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
              new Container(
                margin: EdgeInsets.all(20.0),
                child: new Text("Voici les matchs !"),
              ),
              new Flexible(
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
                              child: new Text(joueur1.nom, maxLines: 3,
                                  textAlign: TextAlign.center),
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
                                textAlign: TextAlign.center,),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              new RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (BuildContext buildC) {
                        return new Match(domiciles: listeDomicile,
                            exterieurs: listeExterieur,
                            id: widget.id);
                      }));
                },
                child: new Text("Lancer !"),
              )
            ],
          )
      ),
    );
  }
}

class Rencontre {
  Tournoi domicileT, exterieurT;
  Chansons domicileC, exterieurC;
  Jeux domicileJ, exterieurJ;

  Rencontre.tournoiFromJson(Map map) :
    domicileT = map["domicile"],
    exterieurT = map["exterieur"];

  Rencontre.chansonFromJson(Map map) :
      domicileC = map["domicile"],
      exterieurC = map["exterieur"];

  Rencontre.jeuxFromJson(Map map) :
        domicileJ = map["domicile"],
        exterieurJ = map["exterieur"];
}