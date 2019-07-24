import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:choisi/model/ApiResponse.dart';
import 'package:choisi/model/token.dart';
import 'package:http/http.dart' as http;

const urlServeur = "http://192.168.0.241:8080";

class API {
  static Future getUsers(String token) {
    var url = urlServeur + "/realisateur";
    return http.get(url,  headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    });
  }

  static Future getSongs(String token) {
    var url = urlServeur + "/chanson";
    return http.get(url,  headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    });
  }

  static Future getGames(String token) {
    var url = urlServeur + "/jeuxvideos";
    return http.get(url,  headers: {
      HttpHeaders.authorizationHeader : "Bearer $token"
    });
  }

  static Future getToken() async {
    var url = urlServeur + "/token";
    Map data = {
      "password": "marchal",
      "username": "maxime"
    };
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: body
    );
    var apiResponse = ApiResponse.fromJson(jsonDecode(response.body));
    return apiResponse;
  }
}