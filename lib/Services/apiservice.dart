import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/songmodel.dart';

class ApiService {

  static const String apiKey = "AIzaSyCOf2JrzCNVpZSHiZGQ82x_RS5j6kvef8Q";

 Future<List<Song>> searchSongs(String query) async {

  final url = 
      "https://www.googleapis.com/youtube/v3/search"
      "?part=snippet"
      "&q=$query"
      "&type=video"
      "&maxResults=50"
       "&key=$apiKey";

  final response = await http.get(Uri.parse(url));

  final data = jsonDecode(response.body);

  List items = data["items"];

  return items.map((e) => Song.fromJson(e)).toList();

}
}