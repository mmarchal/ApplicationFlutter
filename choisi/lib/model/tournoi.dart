class Tournoi {
  String id;
  String nom;
  String image;
  String info1;
  String info2;
  String info3;

  @override
  String toString() {
    return 'Tournoi{"id": "$id", "nom": "$nom", "image": "$image", "info1": "$info1", "info2": "$info2", "info3": "$info3"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.info1 = map["info1"];
    this.info2 = map["info2"];
    this.info3 = map["info3"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "info1" : this.info1,
      "info2" : this.info2,
      "info3" : this.info3,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Tournoi.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        info1 = json['info1'],
        info2 = json['info2'],
        info3 = json['info3'];

}