import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/films.dart';

class TableauV2 extends StatefulWidget {

  final String nom;
  final String token;
  final List liste;

  TableauV2({Key key,this.nom, @required this.token, @required this.liste}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _TableauV2();
  }

}

class _TableauV2 extends State<TableauV2> {

  @override
  Widget build(BuildContext context) {
    print(widget.liste.toString());
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.nom),
        centerTitle: true,
      ),
    );
  }


}