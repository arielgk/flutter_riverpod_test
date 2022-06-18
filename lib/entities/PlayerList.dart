import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'Player.dart';

class PlayerList extends StateNotifier<List<Player>> {
  PlayerList([List<Player>? initialState]) : super(initialState ?? []);
}
