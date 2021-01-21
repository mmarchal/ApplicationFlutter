import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:choisi/model/acteurActrice.dart';
import 'package:choisi/model/avengers.dart';
import 'package:choisi/model/chansons.dart';
import 'package:choisi/model/disney.dart';
import 'package:choisi/model/films.dart';
import 'package:choisi/model/jeux.dart';
import 'package:choisi/model/mechants.dart';
import 'package:choisi/model/pokemon.dart';
import 'package:choisi/model/sagas.dart';
import 'package:choisi/model/series.dart';
import 'package:choisi/model/sports.dart';
import 'package:choisi/model/superheros.dart';
import 'package:choisi/resultat.dart';
import 'package:choisi/tableau.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:xml/xml.dart';
import 'model/realisateur.dart';
import 'dart:convert';
import 'dart:io';
import 'package:xml/xml.dart' as xml;

class Match extends StatefulWidget {

  final List domiciles;
  final List exterieurs;
  final int id;

  Match({Key key, this.domiciles, this.exterieurs, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _Match();
  }

}

class _Match extends State<Match> {

  int idMatch;
  int nombreMatchs;
  var domicile;
  var exterieur;
  bool songIsPlayingD = false;
  bool songIsPlayingE = false;

  List<Map> rencontres = new List();

  AudioPlayer audioPlayerD = new AudioPlayer();
  AudioPlayer audioPlayerE = new AudioPlayer();

  List<String> contenusDatasD = new List();
  List<String> contenusDatasE = new List();

  final translator = GoogleTranslator();

  @override
  void initState() {
    super.initState();
    if(widget.domiciles.isNotEmpty) getDatasInMemory();
  }

  @override
  void dispose() {
    audioPlayerD.stop();
    audioPlayerE.stop();
    super.dispose();
  }

  void getDatasInMemory() async {
    domicile = widget.domiciles[0];
    exterieur = widget.exterieurs[0];
  }

  @override
  Widget build(BuildContext context) {
    if(widget.domiciles.length==0) {
      return new Scaffold(
        body: Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text("Tour terminé !", textAlign: TextAlign.center, textScaleFactor: 2.0,),
                new RaisedButton(
                  onPressed: () {
                    memorySortingAndGo();
                  },
                  child: new Text("Passer à la manche suivante !"),
                ),
              ],
            )
        ),
      );
    } else {
      return new Scaffold(
        body: new Center(
          child: new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgetAselectionner()
          ),
        ),
      );
    }
  }

  List<Widget> widgetAselectionner() {
    List<Widget> list = new List();
    switch (widget.id) {
      case 1 :
        createWidgetsFilms(list);
        break;
      case 2 :
        createWidgetsRealisateur(list);
        break;
      case 3 :
        createWidgetsJeuxOrSports(list);
        break;
      case 4 :
        createWidgetsFilms(list);
        break;
      case 5 :
        createWidgetsSeries(list);
        break;
      case 6 :
        createWidgetsSeries(list);
        break;
      case 7 :
        createWidgetsSuperHeros(list);
        break;
      case 8 :
        createWidgetsAvengers(list);
        break;
      case 9 :
        createWidgetsChansons(list);
        break;
      case 10 :
        createWidgetsMechants(list);
        break;
      case 11 :
        createWidgetsDisney(list);
        break;
      case 12 :
        createWidgetsJeuxOrSports(list);
        break;
      case 13 :
        createWidgetsSagas(list);
        break;
      case 14 :
        createWidgetsActeursActrices(list);
        break;
      case 15 :
        createWidgetsActeursActrices(list);
        break;
      case 16 :
        createWidgetsPokemons(list);
        break;
    }
    return list;
  }

  void realChoisi(var tournoi) {
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
                setDatas(tournoi);
              },
            )
          ],
        );
      },
    );
  }

  void setDatas(var tournoi) async {
    widget.domiciles.removeAt(0);
    widget.exterieurs.removeAt(0);
    var sharedPreferences = await SharedPreferences.getInstance();
    String test = sharedPreferences.getString("tourSuivant");
    print(test);
    if(test ==null) {
      sharedPreferences.setString("tourSuivant", tournoi.toString());
    } else {
      String data = "${sharedPreferences.getString("tourSuivant")}?${tournoi.toString()}";
      sharedPreferences.setString("tourSuivant", data);
    }
    domicile = null;
    exterieur = null;
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC){
      return new Match(id: widget.id, domiciles: widget.domiciles, exterieurs: widget.exterieurs,);
    }));
  }

  void memorySortingAndGo() async {
    List listeT = new List();
    List<String> decoupe = new List();
    var shared = await SharedPreferences.getInstance();
    if(widget.id==12) {
      decoupe = shared.getString("tourSuivant").split('?Sagas');
    } else {
      decoupe = shared.getString("tourSuivant").split('?');
    }
    if(decoupe.length==2) {
      String data;
      var vainqueur;
      switch (widget.id) {
        case 1 :
          data = shared.getString("tourSuivant").split("Films")[1];
          vainqueur = Realisateur.fromJson(json.decode(data));
          break;
        case 2 :
          data = shared.getString("tourSuivant").split("Tournoi")[1];
          vainqueur = Realisateur.fromJson(json.decode(data));
          break;
        case 3 :
          data = shared.getString("tourSuivant").split("Jeux")[1];
          vainqueur = Jeux.fromJson(json.decode(data));
          break;
        case 4 :
          data = shared.getString("tourSuivant").split("Films")[1];
          vainqueur = Jeux.fromJson(json.decode(data));
          break;
        case 5 :
          data = shared.getString("tourSuivant").split("Series")[1];
          vainqueur = Chansons.fromJson(json.decode(data));
          break;
        case 6 :
          data = shared.getString("tourSuivant").split("Series")[1];
          vainqueur = Jeux.fromJson(json.decode(data));
          break;
        case 7 :
          data = shared.getString("tourSuivant").split("SuperHeros")[1];
          vainqueur = SuperHeros.fromJson(json.decode(data));
          break;
        case 8 :
          data = shared.getString("tourSuivant").split("Avengers")[1];
          vainqueur = Jeux.fromJson(json.decode(data));
          break;
        case 9 :
          data = shared.getString("tourSuivant").split("Chansons")[1];
          vainqueur = Chansons.fromJson(json.decode(data));
          break;
        case 10 :
          data = shared.getString("tourSuivant").split("Mechants")[1];
          vainqueur = Jeux.fromJson(json.decode(data));
          break;
        case 11 :
          data = shared.getString("tourSuivant").split("Disney")[1];
          vainqueur = Jeux.fromJson(json.decode(data));
          break;
        case 12 :
          data = shared.getString("tourSuivant").split("Sports")[1];
          vainqueur = Sports.fromJson(json.decode(data));
          break;
        case 13 :
          data = shared.getString("tourSuivant").split("Sagas")[1];
          vainqueur = Sagas.fromJson(json.decode(data));
          break;
        case 14 :
          data = shared.getString("tourSuivant").split("ActeurActrice")[1];
          vainqueur = ActeurActrice.fromJson(json.decode(data));
          break;
        case 15 :
          data = shared.getString("tourSuivant").split("ActeurActrice")[1];
          vainqueur = ActeurActrice.fromJson(json.decode(data));
          break;
        case 16 :
          data = shared.getString("tourSuivant").split("Pokemon")[1];
          vainqueur = Pokemon.fromJson(json.decode(data));
          break;
      }
      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bContext){
        return new Resultat(vainqueur: vainqueur,id : widget.id);
      }));
    }
    else {
      String must;
      for(int i=1; i<decoupe.length; i++) {
        switch (widget.id) {
          case 1 :
            must = decoupe[i].split("Films")[1];
            try {
              Films data = Films.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
              print(must);
            }
            break;
          case 2 :
            must = decoupe[i].split("Realisateur")[1];
            try {
              Realisateur data = Realisateur.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 3 :
            must = decoupe[i].split("Jeux")[1];
            try {
              Jeux data = Jeux.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 4 :
            must = decoupe[i].split("Films")[1];
            try {
              Films data = Films.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 5 :
            must = decoupe[i].split("Series")[1];
            try {
              Series data = Series.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 6 :
            must = decoupe[i].split("Series")[1];
            try {
              Series data = Series.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 7 :
            must = decoupe[i].split("SuperHeros")[1];
            try {
              SuperHeros data = SuperHeros.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 8 :
            must = decoupe[i].split("Avengers")[1];
            try {
              Avengers data = Avengers.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 9 :
            must = decoupe[i].split("Chansons")[1];
            try {
              Chansons data = Chansons.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 10 :
            must = decoupe[i].split("Mechants")[1];
            try {
              var test = json.decode(must);
              print(test);
              Mechants data = Mechants.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 11 :
            must = decoupe[i].split("Disney")[1];
            try {
              Disney data = Disney.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 12 :
            must = decoupe[i].split("Sports")[1];
            try {
              Sports data = Sports.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 13 :
            must = decoupe[i].split("Sagas")[1];
            try {
              Sagas data = Sagas.fromJson(json.decode(decoupe[i]));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 14 :
            must = decoupe[i].split("ActeurActrice")[1];
            try {
              var test = json.decode(must);
              print(test);
              ActeurActrice data = ActeurActrice.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 15 :
            must = decoupe[i].split("ActeurActrice")[1];
            try {
              ActeurActrice data = ActeurActrice.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
          case 16 :
            must = decoupe[i].split("Pokemon")[1];
            try {
              Pokemon data = Pokemon.fromJson(json.decode(must));
              listeT.add(data);
            } catch(e) {
              print(e);
            }
            break;
        }
      }
      listeT.shuffle();
      rencontres.clear();
      for(int i=0; i<listeT.length; i=i+2) {
        Map map = {
          "domicile" : listeT[i],
          "exterieur" : listeT[i+1]
        };
        try {
          rencontres.add(map);
        } catch (e) {
          print(e);
        }
      }
      shared.setString("tourSuivant", "");
      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext buildContext){
        return new Tableau(id: widget.id, tests: rencontres,);
      }));
    }
  }

  Future<void> playD(String url) async {
    await audioPlayerD.play(url);
  }

  Future<void> playE(String url) async {
    await audioPlayerE.play(url);
  }

  Future<void> pauseD() async {
    await audioPlayerD.pause();
  }

  Future<void> pauseE() async {
    await audioPlayerE.pause();
  }

  void createWidgetsRealisateur(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.orange,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
            new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Ses réalisations", style: TextStyle(fontFamily: 'Lemon'),),
                new Text(domicile.colonne1, style: TextStyle(fontFamily: 'Lemon'),),
                new Padding(padding: EdgeInsets.only(left: 20.0)),
                new Text(domicile.colonne2, style: TextStyle(fontFamily: 'Lemon'),),
                new Padding(padding: EdgeInsets.only(left: 20.0)),
                new Text(domicile.colonne3, style: TextStyle(fontFamily: 'Lemon'),)
              ],
            )
          ],
        ),
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.blue,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
            new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text("Ses réalisations", style: TextStyle(fontFamily: 'Lemon'),),
                new Text(exterieur.colonne1, style: TextStyle(fontFamily: 'Lemon'),),
                new Padding(padding: EdgeInsets.only(left: 20.0)),
                new Text(exterieur.colonne2, style: TextStyle(fontFamily: 'Lemon'),),
                new Padding(padding: EdgeInsets.only(left: 20.0)),
                new Text(exterieur.colonne3, style: TextStyle(fontFamily: 'Lemon'),)
              ],
            )
          ],
        ),
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsJeuxOrSports(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.orange,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
          ],
        ),
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.blue,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
          ],
        ),
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsChansons(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.green,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            //new Text(domicile.musique)
            new IconButton(
              onPressed: () {
                (songIsPlayingD) ? audioPlayerD.pause() : audioPlayerD.play(domicile.colonne1);
                setState(() {
                  songIsPlayingD = !songIsPlayingD;
                });
              },
              icon: (!songIsPlayingD) ? new Icon(Icons.play_circle_outline, size: 50.0,) : new Icon(Icons.pause_circle_outline, size: 50.0),
            ),
          ],
        ),
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.red,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            new IconButton(
              onPressed: () {
                (songIsPlayingE) ? audioPlayerE.pause() : audioPlayerE.play(exterieur.colonne1);
                setState(() {
                  songIsPlayingE = !songIsPlayingE;
                });
              },
              icon: (!songIsPlayingE) ? new Icon(Icons.play_circle_outline, size: 50.0,) : new Icon(Icons.pause_circle_outline, size: 50.0),
            ),
          ],
        ),
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsFilms(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.lightBlue.shade300,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
            new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.width/2,
                      placeholder: (context,url) => CircularProgressIndicator(),
                      errorWidget: (context,url,error) => new Icon(Icons.error),
                    ),
                    Text("Année : ${domicile.colonne3}", style: TextStyle(fontFamily: 'Lemon'),)
                  ],
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Acteurs principaux", style: TextStyle(fontFamily: 'Lemon'),),
                    Text(domicile.colonne1, style: TextStyle(fontFamily: 'Lemon'),),
                    Text(domicile.colonne2, style: TextStyle(fontFamily: 'Lemon'),),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      width: MediaQuery.of(context).size.width/3,
                      child: Text("Synopsis : ${domicile.colonne4}", textScaleFactor: 0.7, textAlign: TextAlign.center,),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.yellow.shade300,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
            new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.width/2,
                      placeholder: (context,url) => CircularProgressIndicator(),
                      errorWidget: (context,url,error) => new Icon(Icons.error),
                    ),
                    Text("Année : ${exterieur.colonne3}", style: TextStyle(fontFamily: 'Lemon'),)
                  ],
                ),
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Acteurs principaux", style: TextStyle(fontFamily: 'Lemon'),),
                    Text(exterieur.colonne1, style: TextStyle(fontFamily: 'Lemon'),),
                    Text(exterieur.colonne2, style: TextStyle(fontFamily: 'Lemon'),),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      width: MediaQuery.of(context).size.width/3,
                      child: Text("Synopsis : ${exterieur.colonne4}", textScaleFactor: 0.7, textAlign: TextAlign.center,),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsAvengers(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.pink.shade300,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            new Text("Capacité : ${domicile.colonne1}", style: TextStyle(fontFamily: 'Lemon'),)
          ],
        ),
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.amber.shade800,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            new Text("Capacité : ${exterieur.colonne1}", style: TextStyle(fontFamily: 'Lemon'),)
          ],
        ),
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsMechants(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.indigo.shade200,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            new Text("Ennemi : ${domicile.colonne1}", style: TextStyle(fontFamily: 'Lemon'),)
          ],
        ),
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.deepOrange.shade200,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            new Text("Ennemi : ${exterieur.colonne1}", style: TextStyle(fontFamily: 'Lemon'),)
          ],
        ),
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsDisney(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.deepOrange.shade800,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
            new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.width/2,
                      placeholder: (context,url) => CircularProgressIndicator(),
                      errorWidget: (context,url,error) => new Icon(Icons.error),
                    ),
                    Text("Année de sortie : ${domicile.colonne1}", style: TextStyle(fontFamily: 'Lemon'),)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.deepPurpleAccent.shade100,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
            new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.width/2,
                      placeholder: (context,url) => CircularProgressIndicator(),
                      errorWidget: (context,url,error) => new Icon(Icons.error),
                    ),
                    Text("Année de sortie : ${exterieur.colonne1}", style: TextStyle(fontFamily: 'Lemon'),)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsSeries(List<Widget> list) {
    print(domicile);
    Widget widget1 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.white,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            Text("Année de début : ${domicile.colonne1}", style: TextStyle(fontFamily: 'Lemon'),),
            Text("Année de fin : ${domicile.colonne2}", style: TextStyle(fontFamily: 'Lemon'),),
          ],
        ),
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.teal,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            Text("Année de début : ${exterieur.colonne1}", style: TextStyle(fontFamily: 'Lemon'),),
            Text("Année de fin : ${exterieur.colonne2}", style: TextStyle(fontFamily: 'Lemon'),),
          ],
        ),
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsPokemons(List<Widget> list) {

    Widget widget1 = new InkWell(
      child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2,
          color: Colors.orange.shade200,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
                  CachedNetworkImage(
                    imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.width/2,
                    placeholder: (context,url) => CircularProgressIndicator(),
                    errorWidget: (context,url,error) => new Icon(Icons.error),
                  ),
                  new Text("Pokémon n° ${domicile.colonne1.toString()}", style: TextStyle(fontFamily: 'Lemon'),),
                ],
              ),
            ],
          )
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2,
          color: Colors.teal.shade600,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
                  CachedNetworkImage(
                    imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.width/2,
                    placeholder: (context,url) => CircularProgressIndicator(),
                    errorWidget: (context,url,error) => new Icon(Icons.error),
                  ),
                  new Text("Pokémon n° ${exterieur.colonne1.toString()}", style: TextStyle(fontFamily: 'Lemon'),),
                ],
              ),
            ],
          )
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsSagas(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2,
          color: Colors.orange.shade200,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
                  CachedNetworkImage(
                    imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.width/2,
                    placeholder: (context,url) => CircularProgressIndicator(),
                    errorWidget: (context,url,error) => new Icon(Icons.error),
                  ),
                  new Text("Nombre de films : ${domicile.colonne1.toString()}", style: TextStyle(fontFamily: 'Lemon'),),
                ],
              ),
            ],
          )
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2,
          color: Colors.teal.shade600,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
                  CachedNetworkImage(
                    imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.width/2,
                    placeholder: (context,url) => CircularProgressIndicator(),
                    errorWidget: (context,url,error) => new Icon(Icons.error),
                  ),
                  new Text("Nombre de films : ${exterieur.colonne1.toString()}", style: TextStyle(fontFamily: 'Lemon'),),
                ],
              ),
            ],
          )
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  Widget xmlConverter(datas) {
    XmlDocument xmlData = xml.parse(datas.colonne2);
    List<String> listContenu = new List();

    var test = xmlData.findAllElements('element');
    var noms = test.map((f) => f.findElements('nomFilm').single.text).toList();
    var annees = test.map((t) => t.findElements('dateSortieFilm').single.text).toList();

    for(int i=0; i<noms.length; i++) { listContenu.add("Nom : ${noms[i]} sorti en ${annees[i]}\n"); }

    return Expanded(
        child: ListView.builder(
            itemCount: listContenu.length,
            itemBuilder: (BuildContext context, int id) {
              return new Center(
                child: new Container(
                  margin: EdgeInsets.all(15.0),
                  width: MediaQuery.of(context).size.width/2,
                  child: Text(
                    listContenu[id],
                    textScaleFactor: 0.8,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Lemon'),
                  ),
                ),
              );
            })
    );
  }

  void createWidgetsSuperHeros(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.lightGreen,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            Text("Pouvoir : ${domicile.colonne1}", style: TextStyle(fontFamily: 'Lemon'),),
          ],
        ),
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.blue.shade200,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
            CachedNetworkImage(
              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            Text("Pouvoir : ${exterieur.colonne1}", style: TextStyle(fontFamily: 'Lemon'),),
          ],
        ),
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsActeursActrices(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2,
          color: Colors.orange.shade200,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
                  CachedNetworkImage(
                    imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + domicile.image,
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.width/2,
                    placeholder: (context,url) => CircularProgressIndicator(),
                    errorWidget: (context,url,error) => new Icon(Icons.error),
                  ),
                  new Text("Films : ${domicile.colonne1.toString()}\n${domicile.colonne2.toString()}\n", style: TextStyle(fontFamily: 'Lemon'),),
                ],
              ),
            ],
          )
      ),
      onTap: () {
        realChoisi(domicile);
      },
    );
    Widget widget2 = new InkWell(
      child: new Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height/2,
          color: Colors.teal.shade600,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
                  CachedNetworkImage(
                    imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + exterieur.image,
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.width/2,
                    placeholder: (context,url) => CircularProgressIndicator(),
                    errorWidget: (context,url,error) => new Icon(Icons.error),
                  ),
                  new Text("Films : ${exterieur.colonne1.toString()}\n${exterieur.colonne2.toString()}\n", style: TextStyle(fontFamily: 'Lemon'),),
                ],
              ),
            ],
          )
      ),
      onTap: () {
        realChoisi(exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

}

