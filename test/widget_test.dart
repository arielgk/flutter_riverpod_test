import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:test_state_app/entities/Player.dart';
import 'package:test_state_app/features/counter/page.dart';
import 'package:test_state_app/features/players/page.dart';

final counterProvider = StateProvider((ref) => 0);

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

final apiProviderMock =
    Provider<PlayerRepositoryMock>((ref) => PlayerRepositoryMock());
final remotePlayerProviderMock = FutureProvider<List<Player>>((ref) async {
  return ref.read(apiProviderMock).getData();
});

class PlayerRepositoryError {
  Future<List<Player>> getData() async {
    throw Exception("Not found");
  }
}

final apiProviderError =
    Provider<PlayerRepositoryError>((ref) => PlayerRepositoryError());
final remotePlayerProviderError = FutureProvider<List<Player>>((ref) async {
  return ref.read(apiProviderError).getData();
});

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
      remotePlayerProvider.overrideWithProvider(remotePlayerProviderMock)
    ], child: MaterialApp(home: PlayerPage())));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Marcus Rashford'), findsNothing);

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Players'), findsOneWidget);
    expect(find.text('Marcus Rashford'), findsOneWidget);
  });

  testWidgets("fail repository error", (tester) async {
    await tester.pumpWidget(ProviderScope(overrides: [
      remotePlayerProvider.overrideWithProvider(remotePlayerProviderError)
    ], child: MaterialApp(home: PlayerPage())));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Players'), findsOneWidget);

    expect(find.text("Exception: Not found"), findsOneWidget);
  });

  testWidgets("test json to Player", (tester) async {
    Map<String, dynamic> json = {
      "contractUntil": "2022-06-30",
      "dateOfBirth": "1993-05-13",
      "jerseyNumber": 9,
      "name": "Romelu Lukaku",
      "nationality": "Belgium",
      "position": "Centre-Forward"
    };

    Player player = Player.fromJson(json);

    expect(player.name, "Romelu Lukaku");
  });


}
