class Mechants {

  String id;
  String nom;
  String image;
  String colonne1;

  @override
  String toString() {
    return 'Mechants{"id": "$id", "nom": "$nom", "image": "$image", "ennemi": "$colonne1"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.colonne1 = map["ennemi"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "ennemi" : this.colonne1,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Mechants.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        colonne1 = json['ennemi'];
}