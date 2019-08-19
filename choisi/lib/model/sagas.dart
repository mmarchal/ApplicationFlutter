class Sagas {

  String id;
  String nom;
  String image;
  int nombreFilms;
  String contenu;

  @override
  String toString() {
    return 'Sagas{"id": "$id", "nom": "$nom", "image": "$image", "nombreFilms": "$nombreFilms", "contenu": "$contenu"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.nombreFilms = map["nombreFilms"];
    this.contenu = map["contenu"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "nombreFilms" : this.nombreFilms,
      "contenu" : this.contenu,
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
        nombreFilms = json['nombreFilms'],
        contenu = json['contenu'];
}

class Contenu {
  String id;
  String nomFilm;
  String dateSortieFilm;

  Contenu.fromJson(Map json) :
        id = json['id'].toString(),
        nomFilm = json['nomFilm'],
        dateSortieFilm = json['dateSortieFilm'];
}