import 'dart:convert';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entities/Player.dart';
import 'package:http/http.dart' as http;

class PlayerRepository{

  Future<List<Player>> getData() async {
    List<Player> list = <Player>[];
    String link = "https://test-players-a141f.web.app/players.json";
    var res =
    await http.get(Uri.parse(link), headers: {"Accept": "application/json"});
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data as List;
      return rest.map<Player>((json) => Player.fromJson(json)).toList();
    }else{
      throw Exception(res.reasonPhrase);
    }
  }
}


final apiProvider = Provider<PlayerRepository>((ref)=> PlayerRepository());