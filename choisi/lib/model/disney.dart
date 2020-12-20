class Disney {

  String id;
  String nom;
  String image;
  String colonne1;
  String colonne2;
  String colonne3;

  @override
  String toString() {
    return 'Disney{"id": "$id", "nom": "$nom", "image": "$image", "annee": "$colonne1", "gentil": "$colonne2", "mechant": "$colonne3"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.colonne1 = map["annee"];
    this.colonne2 = map["gentil"];
    this.colonne3 = map["mechant"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "annee" : this.colonne1,
      "gentil" : this.colonne2,
      "mechant" : this.colonne3,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Disney.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        colonne1 = json['annee'],
        colonne2 = json['gentil'],
        colonne3 = json['mechant'];
}