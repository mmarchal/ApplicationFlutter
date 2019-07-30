class Mechants {

  String id;
  String nom;
  String image;
  String ennemi;

  @override
  String toString() {
    return 'Mechants{"id": "$id", "nom": "$nom", "image": "$image", "ennemi": "$ennemi"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.ennemi = map["ennemi"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "ennemi" : this.ennemi,
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
        ennemi = json['ennemi'];
}