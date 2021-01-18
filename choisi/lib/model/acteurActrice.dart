class ActeurActrice {

  String id;
  String nom;
  String image;
  String colonne1;
  String colonne2;


  @override
  String toString() {
    return 'ActeurActrice{"id": "$id", "nom": "$nom", "image": "$image", "colonne1": "$colonne1", "colonne2": "$colonne2"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.colonne1 = map["colonne1"];
    this.colonne2 = map["colonne2"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "colonne1" : this.colonne1,
      "colonne2" : this.colonne2,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  ActeurActrice.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        colonne1 = json['colonne1'],
        colonne2 = json['colonne2'];
}