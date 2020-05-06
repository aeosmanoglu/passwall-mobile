import 'objects.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class Antenna {
  Future<bool> login(String username, String password, server) async {
    print("User logging in...");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("server", server);
    preferences.setString("username", username);
    preferences.setString("password", password);
    String url = "$server/auth/signin";
    Map<String, String> headers = {HttpHeaders.contentTypeHeader: "application/json"};
    String body = jsonEncode({"Username": username, "Password": password});
    Response response;
    try {
      response = await post(url, headers: headers, body: body);
    } catch (e) {
      print(e);
      return false;
    }
    Map<String, dynamic> answer = jsonDecode(response.body);
    print(answer["message"] ?? answer["access_token"]);
    if (response.statusCode == 200) {
      preferences.setString("token", answer["access_token"]);
      return true;
    } else {
      return false;
    }
  }

  Future<List<Login>> getAllLogins() async {
    print("Geting logins...");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/api/logins";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await get(url, headers: headers);
    List<Login> logins = (jsonDecode(response.body) as List).map((i) => Login.fromJson(i)).toList();
    return logins;
  }

  Future<List<Login>> search(String searchQuery) async {
    print("Searching: $searchQuery");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/api/logins/?Search=$searchQuery";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await get(url, headers: headers);
    List<Login> logins = (jsonDecode(response.body) as List).map((i) => Login.fromJson(i)).toList();
    return logins;
  }

  Future<bool> deleteLogin(int id) async {
    print("Deleting login the number $id");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/api/logins/$id";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await delete(url, headers: headers);
    Map<String, dynamic> answer = jsonDecode(response.body);
    print(answer["message"]);
    return response.statusCode == 200;
  }

  Future<bool> createNewLogin({String title = "", String username = "", String password}) async {
    print("Creating a new login");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/api/logins";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token", HttpHeaders.contentTypeHeader: "application/json"};
    String body = jsonEncode({"URL": title, "Username": username, "Password": password});
    Response response = await post(url, headers: headers, body: body);
    response.statusCode == 200 ? print("created") : print("Samething went wrong!");
    return response.statusCode == 200;
  }

  Future<String> generatePassword() async {
    print("Rolling a dice and getting a new password");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/api/logins/generate-password";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await post(url, headers: headers);
    Map<String, dynamic> answer = jsonDecode(response.body);
    return answer["message"];
  }

  update(int id, String title, String username, String password) async {
    print("Updating login the number $id");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/api/logins/$id";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token", HttpHeaders.contentTypeHeader: "application/json"};
    String body = jsonEncode({"URL": title, "Username": username, "Password": password});
    Response response = await put(url, headers: headers, body: body);
    response.statusCode == 200 ? print("updated") : print("Samething went wrong!");
  }

  /// Returns the path of documents directory
  Future<String> get pathFinder async {
    final dir = await getApplicationSupportDirectory();
    return dir.path;
  }

  /// Opens the file
  Future<File> secretarial({String file = "export.csv"}) async {
    final path = await pathFinder;
    return File("$path/$file");
  }

  export() async {
    print("Exporting...");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/api/logins/export";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await post(url, headers: headers);
    final file = await secretarial();
    print("Writting data to file...");
    file.writeAsStringSync(response.body);
    print("Done. File is closed. Exporting...");
    List<int> bytes = file.readAsBytesSync();
    String now = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    Share.file("Sensitive data from PassWall", "PassWall-Export-$now.csv", bytes, "text/csv");
  }

  import(File file) async {
    print("Importing...");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/api/logins/import";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token", HttpHeaders.contentTypeHeader: "multipart/form-data"};
    Uri uri = Uri.parse(url);
    MultipartRequest multipartRequest = MultipartRequest("POST", uri);
    multipartRequest.fields["url"] = "URL";
    multipartRequest.fields["username"] = "Username";
    multipartRequest.fields["password"] = "Password";
    multipartRequest.files.add(MultipartFile.fromString(
      "file",
      file.readAsStringSync(),
      filename: file.path
          .split("/")
          .last,
      contentType: MediaType("text", "csv"),
    ));
    multipartRequest.headers.addAll(headers);
    StreamedResponse response = await multipartRequest.send();
    if (response.statusCode == 200) print('Imported!');
  }
}