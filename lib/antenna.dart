import 'package:Passwall/objects.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class Antenna {
  /// This is the main function that the access token still valid.
  /// So we can understand user is authorized or not.
  /// TODO: Must use every connection
  Future<bool> gateKeeper(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server") ?? "localhost:3625";

    String url = "http://$server/auth/check";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response;

    // Sometimes the token may come null or "". When it happens, flutter can not parse
    // the header value. Fot that reason, we are trying to get response.
    try {
      response = await post(url, headers: headers);
    } catch (e) {
      print(e);
      return false;
    }

    Map<String, dynamic> answer = jsonDecode(response.body);
    print(answer["Message"]);
    return response.statusCode == 200 ? true : false;
  }

  Future<bool> login(String username, String password, server) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("server", server);

    String url = "http://$server/auth/signin";
    Map<String, String> headers = {HttpHeaders.contentTypeHeader: "application/json"};
    String body = jsonEncode({"Username": username, "Password": password});
    Response response = await post(url, headers: headers, body: body);

    Map<String, dynamic> answer = jsonDecode(response.body);
    print(answer["message"] ?? answer["token"]);

    if (response.statusCode == 200) {
      preferences.setString("token", answer["token"]);
      return true;
    } else {
      return false;
    }
  }

  Future<List<Credential>> getCredentials() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "http://$server/logins";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await get(url, headers: headers);
    List<Credential> credentials = (jsonDecode(response.body) as List).map((i) => Credential.fromJson(i)).toList();
    return credentials;
  }

  Future<List<Credential>> search(String searchQuery) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "http://$server/logins/?Search=$searchQuery";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await get(url, headers: headers);
    List<Credential> credentials = (jsonDecode(response.body) as List).map((i) => Credential.fromJson(i)).toList();
    return credentials;
  }

  deleteCredential(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "http://$server/logins/$id";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    await delete(url, headers: headers);
  }

  create({String title = "", String username = "", String password}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "http://$server/logins/";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token", HttpHeaders.contentTypeHeader: "application/json"};
    String body = jsonEncode({"URL": title, "Username": username, "Password": password});
    Response response = await post(url, headers: headers, body: body);
    print("Create: " + response.statusCode.toString());
  }

  Future<String> generatePassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "http://$server/logins/generate-password";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await post(url, headers: headers);
    Map<String, dynamic> answer = jsonDecode(response.body);
    return answer["Message"];
  }

  update(int id, String title, String username, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "http://$server/logins/$id";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token", HttpHeaders.contentTypeHeader: "application/json"};
    String body = jsonEncode({"URL": title, "Username": username, "Password": password});
    await put(url, headers: headers, body: body);
  }
}
