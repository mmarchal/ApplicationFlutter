import 'package:cached_network_image/cached_network_image.dart';
import 'package:choisi/api.dart';
import 'package:flutter/material.dart';
import 'package:choisi/menu.dart';
import 'package:choisi/model/tournoi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Resultat extends StatefulWidget {

  final vainqueur;

  Resultat({Key key, this.vainqueur}) : super(key: key);

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
              new Text("Le grand gagnant est ${widget.vainqueur.nom}",textAlign: TextAlign.center, textScaleFactor: 3.0, style: new TextStyle(color: Colors.white),),
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

}