import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:choisi/model/ApiResponse.dart';
import 'package:http/http.dart' as http;

const urlServeur  = "http://ns329111.ip-37-187-107.eu:16512";

class API {
  static Future getUsers(String token) {
    var url = urlServeur + "/realisateur";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getSongs(String token) {
    var url = urlServeur + "/chanson";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getDisney(String token) {
    var url = urlServeur + "/dessinsanimes";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getGames(String token) {
    var url = urlServeur + "/jeuxvideos";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getMovies(String token) {
    var url = urlServeur + "/films";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getAvengers(String token) {
    var url = urlServeur + "/avengers";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getMechants(String token) {
    var url = urlServeur + "/mechants";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getSeriesAnimes(String token) {
    var url = urlServeur + "/seriesanimes";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getSeries(String token) {
    var url = urlServeur + "/series";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getHorreurs(String token) {
    var url = urlServeur + "/horreur";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getSports(String token) {
    var url = urlServeur + "/sports";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getSagas(String token) {
    var url = urlServeur + "/saga";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getSuperHeros(String token) {
    var url = urlServeur + "/superheros";
    return http.get(url, headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    }).catchError((err) {
      print(err.toString());
      return null;
    });
  }

  static Future getToken() async {
    var url = urlServeur + "/token";
    Map data = {
      "password": "sof@59chOix",
      "username": "app"
    };
    //encode Map to JSON
    var body = json.encode(data);

    try {
      var response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      if (response.statusCode==200){
        var apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
        return apiResponse;
      } else {
        return null;
      }
    } on SocketException catch (e) {
      print(e.message);
      return null;
    }

  }
}