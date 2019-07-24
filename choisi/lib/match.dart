import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:choisi/model/chansons.dart';
import 'package:choisi/model/jeux.dart';
import 'package:choisi/resultat.dart';
import 'package:choisi/tableau.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/tournoi.dart';
import 'dart:convert';

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
      case 2 :
        createWidgetsRealisateur(list);
        break;
      case 3 :
        createWidgetsJeux(list);
        break;
      case 5 :
        createWidgetsChansons(list);
        break;
    }
    return list;
  }

  void realChoisi(int i, var tournoi) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(
              'Vous préférez ${tournoi.nom} ?'
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('NON'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('OUI'),
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
    widget.domiciles.removeAt(0);
    widget.exterieurs.removeAt(0);
    var sharedPreferences = await SharedPreferences.getInstance();
    String test = sharedPreferences.getString("tourSuivant");
    if(test ==null) {
      sharedPreferences.setString("tourSuivant", tournoi.toString());
    } else {
      String data = "${sharedPreferences.getString("tourSuivant")}?${tournoi.toString()}";
      sharedPreferences.setString("tourSuivant", data);
    }
    Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bC){
      return new Match(id: widget.id, domiciles: widget.domiciles, exterieurs: widget.exterieurs,);
    }));
  }

  void memorySortingAndGo() async {
    List listeT = new List();
    var shared = await SharedPreferences.getInstance();
    List<String> decoupe = shared.getString("tourSuivant").split('?');
    if(decoupe.length==2) {
      String data;
      var vainqueur;
      switch (widget.id) {
        case 2 :
          data = shared.getString("tourSuivant").split("Tournoi")[1];
          vainqueur = Tournoi.fromJson(json.decode(data));
          break;
        case 3 :
          data = shared.getString("tourSuivant").split("Jeux")[1];
          vainqueur = Jeux.fromJson(json.decode(data));
          break;
        case 5 :
          data = shared.getString("tourSuivant").split("Chansons")[1];
          vainqueur = Chansons.fromJson(json.decode(data));
          break;
      }
      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bContext){
        return new Resultat(vainqueur: vainqueur,);
      }));
    }
    else {
      String must;
      for(int i=1; i<decoupe.length; i++) {
        switch (widget.id) {
          case 2 :
            must = decoupe[i].split("Tournoi")[1];
            try {
              Tournoi data = Tournoi.fromJson(json.decode(must));
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
          case 5 :
            must = decoupe[i].split("Chansons")[1];
            try {
              Chansons data = Chansons.fromJson(json.decode(must));
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
              imageUrl: domicile.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            new Text(domicile.nom),
           new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  new Text(domicile.info1),
              new Padding(padding: EdgeInsets.only(left: 20.0)),
              new Text(domicile.info2),
              new Padding(padding: EdgeInsets.only(left: 20.0)),
              new Text(domicile.info3)
              ],
            )
          ],
        ),
      ),
      onTap: () {
        realChoisi(0, domicile);
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
              imageUrl: exterieur.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            new Text(exterieur.nom),
            new Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(exterieur.info1),
                new Padding(padding: EdgeInsets.only(left: 20.0)),
                new Text(exterieur.info2),
                new Padding(padding: EdgeInsets.only(left: 20.0)),
                new Text(exterieur.info3)
              ],
            )
          ],
        ),
      ),
      onTap: () {
        realChoisi(1, exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }

  void createWidgetsJeux(List<Widget> list) {
    Widget widget1 = new InkWell(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/2,
        color: Colors.orange,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Text(domicile.nom),
            CachedNetworkImage(
              imageUrl: domicile.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
          ],
        ),
      ),
      onTap: () {
        realChoisi(0, domicile);
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
            new Text(exterieur.nom),
            CachedNetworkImage(
              imageUrl: exterieur.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
          ],
        ),
      ),
      onTap: () {
        realChoisi(1, exterieur);
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
            new Text(domicile.nom),
            CachedNetworkImage(
              imageUrl: domicile.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            //new Text(domicile.musique)
            new IconButton(
              onPressed: () {
                (songIsPlayingD) ? audioPlayerD.pause() : audioPlayerD.play(domicile.musique);
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
        realChoisi(0, domicile);
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
            new Text(exterieur.nom),
            CachedNetworkImage(
              imageUrl: exterieur.image,
              width: MediaQuery.of(context).size.width/2,
              height: MediaQuery.of(context).size.width/2,
              placeholder: (context,url) => CircularProgressIndicator(),
              errorWidget: (context,url,error) => new Icon(Icons.error),
            ),
            new IconButton(
              onPressed: () {
                (songIsPlayingE) ? audioPlayerE.pause() : audioPlayerE.play(exterieur.musique);
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
        realChoisi(1, exterieur);
      },
    );
    list.add(widget1);
    list.add(widget2);
  }
}

