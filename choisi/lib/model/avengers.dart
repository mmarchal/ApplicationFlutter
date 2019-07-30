class Avengers {

  String id;
  String nom;
  String image;
  String description;

  @override
  String toString() {
    return 'Avengers{"id": "$id", "nom": "$nom", "image": "$image", "description": "$description"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.description = map["description"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "description" : this.description,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Avengers.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        description = json['description'];
}