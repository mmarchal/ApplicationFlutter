
class Films {

  String id;
  String nom;
  String image;
  String acteur1;
  String acteur2;
  String annee;
  String synopsis;

  @override
  String toString() {
    return 'Films{id: $id, nom: $nom, image: $image, acteur1: $acteur1, acteur2: $acteur2, annee: $annee, synopsis: $synopsis}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.acteur1 = map["acteur1"];
    this.acteur2 = map["acteur2"];
    this.annee = map["annee"];
    this.synopsis = map["synopsis"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "acteur1" : this.acteur1,
      "acteur2" : this.acteur2,
      "annee" : this.annee,
      "synopsis" : this.synopsis,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Films.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        acteur1 = json['acteur1'],
        acteur2 = json['acteur2'],
        annee = json['annee'],
        synopsis = json['synopsis'];
}