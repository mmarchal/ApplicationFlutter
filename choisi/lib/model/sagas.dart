class Sagas {

  String id;
  String nom;
  String image;
  String colonne1;
  String colonne2;

  @override
  String toString() {
    return 'Sagas{"id": "$id", "nom": "$nom", "image": "$image", "nombreFilms": "$colonne1", "contenu": "$colonne2"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.colonne1 = map["nombreFilms"];
    this.colonne2 = map["contenu"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "nombreFilms" : this.colonne1,
      "contenu" : this.colonne2,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Sagas.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        colonne1 = json['nombreFilms'],
        colonne2 = json['contenu'];
}