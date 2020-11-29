import 'dart:convert';
import 'package:choisi/api.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'model/films.dart';

class TableauV2 extends StatefulWidget {

  final int id;
  final String nom;
  final String token;
  final bool isStarting;

  TableauV2({Key key, @required this.id, this.nom, @required this.token, @required this.isStarting}) : super(key: key);

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
    Colors.blue,
    Colors.green,
  ];

  Color couleurDepart;

  var logg = new Logger();

  @override
  void initState() {
    super.initState();
    if(widget.isStarting) {
      setState(() {
        couleurDepart = listeCouleurs[0];
      });
    }
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
      body: checkDuels(),
    );
  }

  checkDuels() {
    return ListView(
      children: affichageDuels(listeRencontres.length),
    );
  }

  affichageDuels(int length) {

    List<Widget> listes = new List();
    listes.add(Container(margin: EdgeInsets.all(20), child: Text("Le tirage au sort à été effectué !", style: GoogleFonts.aBeeZee(color: Colors.red), textAlign: TextAlign.center, textScaleFactor: 2.0,),));

    for (int count=0; count < length; count++ ) {
      Rencontre r = listeRencontres[count];
      Films domicile = Films.testJson(r.domicile.toString());
      Films exterieur = Films.testJson(r.exterieur.toString());

      Widget w = Card(
        elevation: 20,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(domicile.nom, style: GoogleFonts.aBeeZee(),),
            Image.asset("assets/versus.png", width: MediaQuery.of(context).size.width/10,),
            Text(exterieur.nom, style: GoogleFonts.aBeeZee(),),
          ],
        ),
      );
      listes.add(w);
    }

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