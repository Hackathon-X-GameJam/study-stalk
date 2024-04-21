import 'dart:convert';
import 'package:http/http.dart' as http;

const String server = "https://test.maxap.eu/";

Future<void> initDb() async {
  var uri = Uri.parse("$server/init/db")
      .replace(queryParameters: {"password": "test"});
  await http.get(uri);
}

Future<void> pushPos(String id, String pos) async {
  var uri =
      Uri.parse("$server/push-pos/$id").replace(queryParameters: {"pos": pos});
  await http.get(uri);
}

Future<void> pushPosGps(String id, double lat, double lon) async {
  var uri = Uri.parse("$server/push-pos-gps/$id")
      .replace(queryParameters: {"lat": lat.toString(), "lon": lon.toString()});
  await http.get(uri);
}

Future<String> getPos(String id) async {
  var uri = Uri.parse("$server/get-pos/$id");
  var response = await http.get(uri);
  List<dynamic> rawPosition = jsonDecode(response.body);
  String position = rawPosition[0];
  return position;
}

Future<List<String>> getAllUsers() async {
  var uri = Uri.parse("$server/get-all-users");
  var response = await http.get(uri);
  List<String> users = List<String>.from(jsonDecode(response.body));
  return users;
}

Future<void> main() async {
  // await initDb();
  // await pushPosGps("Kenan", 48.4233381, 9.9578115);
  // await pushPos("Kenan", "helholz");
  List<String> users = await getAllUsers();
  for (String user in users) {
    print("$user   :   ${await getPos(user)}");
  }
}
