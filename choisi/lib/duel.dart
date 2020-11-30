import 'package:cached_network_image/cached_network_image.dart';
import 'package:choisi/utilities/shared.dart';
import 'package:flutter/material.dart';

class Duel extends StatefulWidget {

  var domicile;
  var exterieur;
  int numeroDuel;

  Duel({Key key,
    @required this.domicile,
    @required this.exterieur,
    @required this.numeroDuel
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _Duel();
  }
}

class _Duel extends State<Duel> {

  Future<void> choixEffectue(var t) async {

    await SharedApp().initStringValue("bool", "film-${widget.numeroDuel.toString()}", true);
    String test = await SharedApp().getStringValuesSF("tourSuivant");
    if(test ==null) {
      SharedApp().initStringValue("string", "tourSuivant", t.toString());
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      String data = "${SharedApp().getStringValuesSF("tourSuivant")}?${t.toString()}";
      SharedApp().initStringValue("string", "tourSuivant", data);
      Navigator.pop(context);
      Navigator.pop(context);
    }

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
                choixEffectue(tournoi);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text("${widget.domicile.nom} VS ${widget.exterieur.nom}", textScaleFactor: 0.75,),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            InkWell(
              child: new Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,
                color: Colors.lightBlue.shade300,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(widget.domicile.nom, style: TextStyle(fontFamily: 'Lemon'),),
                    new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + widget.domicile.image,
                              width: MediaQuery.of(context).size.width/2,
                              height: MediaQuery.of(context).size.width/2,
                              placeholder: (context,url) => CircularProgressIndicator(),
                              errorWidget: (context,url,error) => new Icon(Icons.error),
                            ),
                            Text("Année : ${widget.domicile.annee}", style: TextStyle(fontFamily: 'Lemon'),)
                          ],
                        ),
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Acteurs principaux", style: TextStyle(fontFamily: 'Lemon'),),
                            Text(widget.domicile.acteur1, style: TextStyle(fontFamily: 'Lemon'),),
                            Text(widget.domicile.acteur2, style: TextStyle(fontFamily: 'Lemon'),),
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              width: MediaQuery.of(context).size.width/3,
                              child: Text("Synopsis : ${widget.domicile.synopsis}", textScaleFactor: 0.7, textAlign: TextAlign.center,),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                realChoisi(widget.domicile);
              },
            ),
            InkWell(
              child: new Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,
                color: Colors.yellow.shade300,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(widget.exterieur.nom, style: TextStyle(fontFamily: 'Lemon'),),
                    new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: "http://ns329111.ip-37-187-107.eu/sofyan/" + widget.exterieur.image,
                              width: MediaQuery.of(context).size.width/2,
                              height: MediaQuery.of(context).size.width/2,
                              placeholder: (context,url) => CircularProgressIndicator(),
                              errorWidget: (context,url,error) => new Icon(Icons.error),
                            ),
                            Text("Année : ${widget.exterieur.annee}", style: TextStyle(fontFamily: 'Lemon'),)
                          ],
                        ),
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Acteurs principaux", style: TextStyle(fontFamily: 'Lemon'),),
                            Text(widget.exterieur.acteur1, style: TextStyle(fontFamily: 'Lemon'),),
                            Text(widget.exterieur.acteur2, style: TextStyle(fontFamily: 'Lemon'),),
                            Container(
                              margin: EdgeInsets.only(top: 30),
                              width: MediaQuery.of(context).size.width/3,
                              child: Text("Synopsis : ${widget.exterieur.synopsis}", textScaleFactor: 0.7, textAlign: TextAlign.center,),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                realChoisi(widget.exterieur);
              },
            )
          ],
        ),
      ),
    );
  }

}