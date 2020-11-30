import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:choisi/api.dart';
import 'package:choisi/duel.dart';
import 'package:choisi/match.dart';
import 'package:choisi/utilities/shared.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'model/films.dart';

class TableauV2 extends StatefulWidget {

  final String nom;
  final String token;
  final List liste;

  TableauV2({Key key, this.nom, @required this.token, @required this.liste}) : super(key: key);

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

  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  List listeRencontres = new List();

  List<Color> listeCouleurs = [
    Colors.red,
    Colors.green,
  ];

  Color couleurDepart;

  var logg = new Logger();

  @override
  void initState() {
    super.initState();
    setState(() {
      listeRencontres = widget.liste;
    });
  }


  Future<void> fonction() async {
    for( int i = 0; i<listeRencontres.length; i++) {
      bool etatDuel = await SharedApp().getBoolValuesSF("film-${i.toString()}");
      if(!etatDuel) {
        setState(() {
          couleurDepart = listeCouleurs[0];
        });
      } else {
        setState(() {
          couleurDepart = listeCouleurs[1];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    fonction();
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
      body: checkDuels(),
    );
  }

  checkDuels() {
    return ListView(
      children: affichageDuels(listeRencontres.length),
    );
  }

  _showMaterialDialog(int compteur, var domicile, var exterieur) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("DUEL", textAlign: TextAlign.center, style: GoogleFonts.aBeeZee(),),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.lightBlue.shade300,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'), textAlign: TextAlign.center,),
                      CachedNetworkImage(
                        imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
                        width: MediaQuery.of(context).size.width/2,
                        height: MediaQuery.of(context).size.width/2,
                        placeholder: (context,url) => CircularProgressIndicator(),
                        errorWidget: (context,url,error) => new Icon(Icons.error),
                      ),
                      RaisedButton(
                          child: Text("Je le choisi"),
                          onPressed: () {
                            realChoisi(compteur, domicile);
                          }
                      ),
                      Text("Année : ${domicile.annee}", style: TextStyle(fontFamily: 'Lemon'),),
                      Text("Acteurs principaux", style: TextStyle(fontFamily: 'Lemon'),),
                      Text(domicile.acteur1, style: TextStyle(fontFamily: 'Lemon'),),
                      Text(domicile.acteur2, style: TextStyle(fontFamily: 'Lemon'),),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        width: MediaQuery.of(context).size.width/3,
                        child: Text("Synopsis : ${domicile.synopsis}", textScaleFactor: 0.7, textAlign: TextAlign.center,),
                      )
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.yellow.shade300,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'), textAlign: TextAlign.center),
                      CachedNetworkImage(
                        imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
                        width: MediaQuery.of(context).size.width/2,
                        height: MediaQuery.of(context).size.width/2,
                        placeholder: (context,url) => CircularProgressIndicator(),
                        errorWidget: (context,url,error) => new Icon(Icons.error),
                      ),
                      RaisedButton(
                          child: Text("Je le choisi"),
                          onPressed: () {
                            realChoisi(compteur, exterieur);
                          }
                      ),
                      Text("Année : ${exterieur.annee}", style: TextStyle(fontFamily: 'Lemon'),),
                      Text("Acteurs principaux", style: TextStyle(fontFamily: 'Lemon'),),
                      Text(exterieur.acteur1, style: TextStyle(fontFamily: 'Lemon'),),
                      Text(exterieur.acteur2, style: TextStyle(fontFamily: 'Lemon'),),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        width: MediaQuery.of(context).size.width/3,
                        child: Text("Synopsis : ${exterieur.synopsis}", textScaleFactor: 0.7, textAlign: TextAlign.center,),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close me!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  affichageDuels(int length) {

    List<Widget> listes = new List();
    listes.add(Container(margin: EdgeInsets.all(20), child: Text("Le tirage au sort à été effectué !", style: GoogleFonts.aBeeZee(color: Colors.red), textAlign: TextAlign.center, textScaleFactor: 2.0,),));

    List listeDomicile = new List();
    List listeExterieur = new List();

    for (int count=0; count < length; count++ ) {
      Rencontre r = listeRencontres[count];
      Films domicile = Films.testJson(r.domicile.toString());
      Films exterieur = Films.testJson(r.exterieur.toString());
      listeDomicile.add(domicile);
      listeExterieur.add(exterieur);

      Widget w = InkWell(
        onTap: () {
          _showMaterialDialog(count, domicile, exterieur);
        },
        child: Card(
          color: couleurDepart,
          elevation: 20,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(domicile.nom, textAlign: TextAlign.center, style: GoogleFonts.aBeeZee(),),
              ),
              Image.asset("assets/versus.png", width: MediaQuery.of(context).size.width/10,),
              Flexible(
                child: Text(exterieur.nom, textAlign: TextAlign.center, style: GoogleFonts.aBeeZee(),),
              )
            ],
          ),
        ),
      );
      listes.add(w);
    }

    /*Widget w1 = new RaisedButton(
      onPressed: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext buildC) {
              return new Match(domiciles: listeDomicile, exterieurs: listeExterieur,);
            }));
      },
      child: new Text("Lancer !", style: TextStyle(fontFamily:'Varsity'),),
    );

    listes.add(w1);*/

    return listes;
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

  void realChoisi(int i, var tournoi) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation', style: TextStyle(fontFamily: 'Disney'),),
          content: Text(
            'Vous préférez \n${tournoi.nom} ?', style: TextStyle(fontFamily: 'Disney'), textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('NON', style: TextStyle(fontFamily: 'Disney'),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('OUI', style: TextStyle(fontFamily: 'Disney'),),
              onPressed: () {
                setDatas(i, tournoi);
              },
            )
          ],
        );
      },
    );
  }

  void setDatas(int i, var tournoi) async {

    await SharedApp().initStringValue("bool", "film-${i.toString()}", true);
    String test = await SharedApp().getStringValuesSF("tourSuivant");
    if(test ==null) {
      SharedApp().initStringValue("string", "tourSuivant", tournoi.toString());
    } else {
      String data = "${SharedApp().getStringValuesSF("tourSuivant")}?${tournoi.toString()}";
      SharedApp().initStringValue("string", "tourSuivant", data);
    }

    Navigator.pop(context);
    Navigator.pop(context);
  }

  tableauBody() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(listeRencontres.length, (index) {
        Films domicile = Films.testJson(listeRencontres[index].domicile.toString());
        Films exterieur = Films.testJson(listeRencontres[index].exterieur.toString());
        return InkWell(
          child: Card(
            elevation: 10,
            color: couleurDepart,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Text(
                    '${domicile.nom}',
                    textAlign: TextAlign.center,
                      style: GoogleFonts.aBeeZee()
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
                    style: GoogleFonts.aBeeZee(),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            alertDuel(index, domicile, exterieur);
          },
        );
      }),
    );
  }

  void alertDuel(int index, Films domicile, Films exterieur) {
    String titre = "Duel n°${index+1}";
    return EasyDialog(
        cardColor: Colors.white,
        title: Text(titre, style: GoogleFonts.aBeeZee(),),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/1.8,
        contentList: contenuDuel(domicile, exterieur)
    ).show(context);
  }

  List<Widget> contenuDuel(Films d, Films e) {
    Widget w = SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Image.network("http://ns329111.ip-37-187-107.eu/sofyan/${d.image}", width: MediaQuery.of(context).size.width/1.8,),
                  Container(
                    child: Text('''
                  Nom du film : ${d.nom}\n
                  Année de sortie : ${d.annee}\n
                  Acteur : ${d.acteur1} / ${d.acteur2}
                '''),
                  )
                ],
              )
          ),
          Image.asset("assets/versus.png", width: MediaQuery.of(context).size.width/8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Image.network("http://ns329111.ip-37-187-107.eu/sofyan/${e.image}", width: MediaQuery.of(context).size.width/1.8,),
                Container(
                  child: Text('''
                  Nom du film : ${e.nom}\n
                  Année de sortie : ${e.annee}\n
                  Acteur : ${e.acteur1} / ${e.acteur2}
                '''),
                )
              ],
            ),
          ),
        ],
      ),
    );

    List<Widget> liste = new List();
    liste.add(w);
    return liste;
  }

}