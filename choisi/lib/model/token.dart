class Token {

  String token;
  String username;
  int userId;

  Token(this.token, this.username, this.userId);

  factory Token.fromJson(Map<String, dynamic> json){
    return Token(
        json['token'],
        json['username'],
        json['userId']
    );
  }

}