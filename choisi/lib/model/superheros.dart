class SuperHeros {

  String id;
  String nom;
  String image;
  String pouvoir;

  @override
  String toString() {
    return 'SuperHeros{"id": "$id", "nom": "$nom", "image": "$image", "pouvoir": "$pouvoir"}';
  }


  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.pouvoir = map["pouvoir"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "pouvoir" : this.pouvoir,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  SuperHeros.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        pouvoir = json['pouvoir'];

}