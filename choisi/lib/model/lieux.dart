class Lieux {

  String id;
  String nom;
  String image;
  String ville;
  String pays;

  @override
  String toString() {
    return 'Lieux{id: $id, nom: $nom, image: $image, ville: $ville, pays: $pays}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.ville = map["ville"];
    this.pays = map["pays"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "ville" : this.ville,
      "pays" : this.pays,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Lieux.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        ville = json['ville'],
        pays = json['pays'];
}