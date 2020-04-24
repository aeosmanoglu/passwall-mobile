import 'package:Passwall/utils/objects.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class Antenna {
  /// This is the main function that the access token still valid.
  /// So we can understand user is authorized or not.
  // TODO: Must use every connection
  Future<bool> gateKeeper(String token) async {
    print("Gate Keeper patrolling...");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String url = "$server/auth/check";
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
    print(answer["Message"] ?? answer["message"]);
    return response.statusCode == 200 ? true : false;
  }

  Future<bool> login(String username, String password, server) async {
    print("User logging in...");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("server", server);
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
    print(answer["message"] ?? answer["token"]);
    if (response.statusCode == 200) {
      preferences.setString("token", answer["token"]);
      return true;
    } else {
      return false;
    }
  }

  Future<List<Credential>> getCredentials() async {
    print("Geting credentials...");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/logins";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await get(url, headers: headers);
    List<Credential> credentials = (jsonDecode(response.body) as List).map((i) => Credential.fromJson(i)).toList();
    return credentials;
  }

  Future<List<Credential>> search(String searchQuery) async {
    print("Searching: $searchQuery");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/logins/?Search=$searchQuery";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await get(url, headers: headers);
    List<Credential> credentials = (jsonDecode(response.body) as List).map((i) => Credential.fromJson(i)).toList();
    return credentials;
  }

  deleteCredential(int id) async {
    print("Deleting credential the number $id");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/logins/$id";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await delete(url, headers: headers);
    Map<String, dynamic> answer = jsonDecode(response.body);
    print(answer["Message"] ?? answer["message"]);
  }

  create({String title = "", String username = "", String password}) async {
    print("Creating a new credential");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/logins/";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token", HttpHeaders.contentTypeHeader: "application/json"};
    String body = jsonEncode({"URL": title, "Username": username, "Password": password});
    Response response = await post(url, headers: headers, body: body);
    response.statusCode == 200 ? print("created") : print("Samething went wrong!");
  }

  Future<String> generatePassword() async {
    print("Rolling a dice and getting a new password");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/logins/generate-password";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token"};
    Response response = await post(url, headers: headers);
    Map<String, dynamic> answer = jsonDecode(response.body);
    return answer["Message"] ?? answer["message"];
  }

  update(int id, String title, String username, String password) async {
    print("Updating credential the number $id");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server");
    String token = preferences.getString("token");
    String url = "$server/logins/$id";
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
    String url = "$server/logins/export";
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
    String url = "$server/logins/import";
    Map<String, String> headers = {HttpHeaders.authorizationHeader: "Bearer $token", HttpHeaders.contentTypeHeader: "multipart/form-data"};
    Uri uri = Uri.parse(url);
    MultipartRequest multipartRequest = MultipartRequest("POST", uri);
    multipartRequest.fields["URL"] = "URL";
    multipartRequest.fields["Username"] = "Username";
    multipartRequest.fields["Password"] = "Password";
    multipartRequest.files.add(MultipartFile.fromString(
      "File",
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
