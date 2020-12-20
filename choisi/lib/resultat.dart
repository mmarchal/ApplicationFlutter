import 'package:cached_network_image/cached_network_image.dart';
import 'package:choisi/api.dart';
import 'package:flutter/material.dart';
import 'package:choisi/menu.dart';
import 'package:choisi/model/realisateur.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resultat extends StatefulWidget {

  final vainqueur;
  final id;

  Resultat({Key key, this.vainqueur, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _Resultat();
  }

}

class _Resultat extends State<Resultat> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fini.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Center(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.vainqueur.image,
                width: MediaQuery.of(context).size.width/1.5,
                height: MediaQuery.of(context).size.width/1.5,
                placeholder: (context,url) => CircularProgressIndicator(),
                errorWidget: (context,url,error) => new Icon(Icons.error),
              ),
              textInFunctionId(widget.id),
              new RaisedButton(
                child: new Text("Retourner au menu", textScaleFactor: 2.0,),
                  onPressed: () async {
                    SharedPreferences shared = await SharedPreferences.getInstance();
                    shared.setString("tourSuivant", "");
                    String token;
                    API.getToken().then((value) {
                      if(value.status==200) {
                        setState(() {
                          token = value.result.token;
                          Navigator.push(context, new MaterialPageRoute(builder: (BuildContext bc) {
                            return new Menu(token: token,);
                          }));
                        });
                      } else {
                        print("${value.status} : ${value.message}");
                      }
                    });
                  }
              )
            ],
          ),
        ) /* add child content here */,
      ),
    );
  }

  Widget textInFunctionId(id) {
    switch (id) {
      case 1 :
        return new Text("Votre film préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 2 :
        return new Text("Votre réalisateur préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 3 :
        return new Text("Votre jeu vidéo préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 4 :
        return new Text("Votre film d'horreur préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 5 :
        return new Text("Votre série préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 6 :
        return new Text("Votre série animé préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 7 :
        return new Text("Votre super héros préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 8 :
        return new Text("Votre Avengers préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 9 :
        return new Text("Votre chanson Disney préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 10 :
        return new Text("Votre méchant de film préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 11 :
        return new Text("Votre film Disney préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 12 :
        return new Text("Votre sport préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
      case 13 :
        return new Text("Votre saga de film préféré est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),);
        break;
    }
  }

}