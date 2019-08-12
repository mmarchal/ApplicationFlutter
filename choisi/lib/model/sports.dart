class Sports {

  String id;
  String nom;
  String image;

  @override
  String toString() {
    return 'Sports{"id": "$id", "nom": "$nom", "image": "$image"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Sports.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'];
}