import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test_state_app/entities/Player.dart';
import 'package:test_state_app/entities/PlayerList.dart';
import 'package:test_state_app/features/counter/page.dart';
import 'package:test_state_app/features/players/page.dart';

import 'package:test_state_app/main.dart';

final counterProvider = StateProvider((ref) => 0);
//
// final playerProvider = StateNotifierProvider<PlayerList, List<Player>>((ref) {
//   return PlayerList([
//     Player(
//         contractUntil: "2020-06-30",
//         dateOfBirth: "1997-10-31",
//         jerseyNumber: 19,
//         name: "Marcus Rashford",
//         nationality: "England",
//         position: "Centre-Forward"),
//
//   ]);
// });

final filteredPlayers = FutureProvider((ref) async => <Player>[]);

final playerProvider = StateNotifierProvider<PlayerList, List<Player>>((ref) {
  return PlayerList([
    Player(
        contractUntil: "2020-06-30",
        dateOfBirth: "1997-10-31",
        jerseyNumber: 19,
        name: "Marcus Rashford",
        nationality: "England",
        position: "Centre-Forward"),
  ]);
});

enum PlayerListFilter {
  all,
}

class PlayerRepositoryMock {
  Future<List<Player>> getData() async {
    return [
      Player(
          contractUntil: "2020-06-30",
          dateOfBirth: "1997-10-31",
          jerseyNumber: 19,
          name: "Marcus Rashford",
          nationality: "England",
          position: "Centre-Forward"),
    ];
  }
}

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return ProviderScope(
        child: MaterialApp(
      home: child,
    ));
  }

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(child: const CounterPage()));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('override players repositoryProvider', (tester) async {
    await tester.pumpWidget(ProviderScope(overrides: [
      filteredPlayers.overrideWithValue(AsyncValue.data([
        Player(
            contractUntil: "2020-06-30",
            dateOfBirth: "1997-10-31",
            jerseyNumber: 19,
            name: "Marcus Rashford",
            position: "Centre-Forward",
            nationality: "England")
      ]))
    ], child: MaterialApp(home: PlayerPage())));

    await tester.pumpWidget(ProviderScope(
        overrides: [],
        child: ProviderScope(overrides: [], child: PlayerPage())));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Players'), findsOneWidget);

    // expect(find.text('Marcus Rashford'), findsOneWidget);
  });
}
