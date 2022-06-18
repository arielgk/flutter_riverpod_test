import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_state_app/entities/Player.dart';
import 'package:http/http.dart' as http;
import 'package:test_state_app/entities/filter.dart';
import 'package:test_state_app/repositories/PlayerRepository.dart';





// final counterProvider = StateProvider((ref) => 0);

final remotePlayerProvider = FutureProvider<List<Player>>((ref) async {
  List<Player> list = <Player>[];
  String link = "https://test-players-a141f.web.app/players.json";
  var res =
  await http.get(Uri.parse(link), headers: {"Accept": "application/json"});

  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var rest = data as List;

    list = rest.map<Player>((json) => Player.fromJson(json)).toList();
  }
  return list;
});



// enum PlayerListFilter {
//   all,
//   greaterThan10,
// }

Future<List<Player>> getData() async {
  List<Player> list = <Player>[];
  String link = "https://test-players-a141f.web.app/players.json";
  var res =
  await http.get(Uri.parse(link), headers: {"Accept": "application/json"});
  if (res.statusCode == 200) {
    var data = json.decode(res.body);
    var rest = data as List;
    list = rest.map<Player>((json) => Player.fromJson(json)).toList();
  }

  return list;
}

final playerListFilter = StateProvider((_) => Filter.all);

final filteredPlayers = Provider<List<Player>>((ref) {
  final filter = ref.watch(playerListFilter);
  // final players = ref.watch(playerProvider);
  AsyncValue<List<Player>> playerList = ref.watch(remotePlayerProvider);

  return playerList.when(
      loading: () => <Player>[],
      error: (err, stack) => <Player>[],
      data: (playerList) {
        switch (filter) {
          case Filter.all:
            return playerList;

        }
      });
});



class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Players',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color.fromARGB(38, 47, 47, 247),
        fontSize: 100,
        fontWeight: FontWeight.w100,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}

class PlayerPage extends ConsumerWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final int counter = ref.watch(playerProvider);
    final players = ref.watch(filteredPlayers);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Players'),
        ),
        body: FutureBuilder(
            future: PlayerRepository().getData(),
            builder: (context, snapshot) {
              return snapshot.data != null
                  ? Center(
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1.0),
                          1: FlexColumnWidth(2.0),
                        },
                        border: TableBorder.all(),
                        defaultVerticalAlignment:
                        TableCellVerticalAlignment.middle,
                        children: [
                          for (var item in players)
                            TableRow(children: [
                              Text(item.name),
                              Text(item.jerseyNumber.toString()),
                            ])
                        ]),
                  ),
                ]),
              )
                  : const Center(child: CircularProgressIndicator());
            }));
  }
}
