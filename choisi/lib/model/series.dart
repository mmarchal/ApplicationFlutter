class Series {

  String id;
  String nom;
  String image;
  String anneeDebut;
  String anneeFin;

  @override
  String toString() {
    return 'Series{"id": "$id", "nom": "$nom", "image": "$image", "anneeDebut": "$anneeDebut", "anneeFin": "$anneeFin"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.anneeDebut = map["anneeDebut"];
    this.anneeFin = map["anneeFin"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "anneeDebut" : this.anneeDebut,
      "anneeFin" : this.anneeFin,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Series.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        anneeDebut = json['anneeDebut'],
        anneeFin = json['anneeFin'];
}