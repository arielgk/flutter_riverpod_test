import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_state_app/entities/Player.dart';
import 'package:test_state_app/entities/filter.dart';
import 'package:test_state_app/repositories/PlayerRepository.dart';

final remotePlayerProvider = FutureProvider<List<Player>>((ref) async {
  return ref.read(apiProvider).getData();
});




class Title extends StatelessWidget {
  const Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Players',
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Helvetica Neue',
      ),
    );
  }
}

class PlayerPage extends ConsumerWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _data = ref.watch(remotePlayerProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Title(),
        ),
        body: _data.when(
            data: (_data) {
             return Center(
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
                          ..._data.map((e) => TableRow(children: [
                                Text(e.name),
                                Text(e.jerseyNumber.toString()),
                              ]))
                        ]),
                  ),
                ]),
              );
            },
            error: (err, s) => Text(err.toString()),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }
}
