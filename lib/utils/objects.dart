class Login {
  int id;
  String url;
  String username;
  String password;

  Login({this.id, this.url, this.username, this.password});

  Login.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['username'] = this.username;
    data['password'] = this.password;
    return data;
  }
}
