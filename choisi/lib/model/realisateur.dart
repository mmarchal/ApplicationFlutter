class Realisateur {
  String id;
  String nom;
  String image;
  String colonne1;
  String colonne2;
  String colonne3;

  @override
  String toString() {
    return 'Realisateur{"id": "$id", "nom": "$nom", "image": "$image", "colonne1": "$colonne1", "colonne": "$colonne2", "colonne3": "$colonne3"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.colonne1 = map["colonne1"];
    this.colonne2 = map["colonne2"];
    this.colonne3 = map["colonne3"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "colonne1" : this.colonne1,
      "colonne2" : this.colonne2,
      "colonne3" : this.colonne3,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Realisateur.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        colonne1 = json['colonne1'],
        colonne2 = json['colonne2'],
        colonne3 = json['colonne3'];

}