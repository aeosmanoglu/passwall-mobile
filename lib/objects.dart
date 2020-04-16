class Credential {
  int id;
  String url;
  String username;
  String password;

  Credential({this.id, this.url, this.username, this.password});

  Credential.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    url = json['URL'];
    username = json['Username'];
    password = json['Password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['URL'] = this.url;
    data['Username'] = this.username;
    data['Password'] = this.password;
    return data;
  }
}

