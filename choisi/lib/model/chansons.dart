class Chansons {
  String id;
  String nom;
  String image;
  String musique;

  @override
  String toString() {
    return 'Chansons{"id": "$id", "nom": "$nom", "image": "$image", "musique": "$musique"}';
  }

  void fromMap(Map<String, dynamic> map) {
    this.id = map["id"];
    this.nom = map["nom"];
    this.image = map["image"];
    this.musique = map["musique"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nom" : this.nom,
      "image" : this.image,
      "musique" : this.musique,
    };
    if(id != null) {
      map["id"] = this.id;
    }
    return map;
  }

  Chansons.fromJson(Map json) :
        id = json['id'].toString(),
        nom = json['nom'],
        image = json['image'],
        musique = json['musique'];
}