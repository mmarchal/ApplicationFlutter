class Disney {

  String id;
  String nom;
  String image;
  String annee;
  String gentil;
  String mechant;

  @override
  String toString() {
    return 'Disney{"id": "$id", "nom": "$nom", "image": "$image", "annee": "$annee", "gentil": "$gentil", "mechant": "$mechant"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.annee = map["annee"];
    this.gentil = map["gentil"];
    this.mechant = map["mechant"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "annee" : this.annee,
      "gentil" : this.gentil,
      "mechant" : this.mechant,
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
        annee = json['annee'],
        gentil = json['gentil'],
        mechant = json['mechant'];
}