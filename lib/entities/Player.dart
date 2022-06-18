import 'package:flutter/material.dart';
import 'dart:convert';

Map<String, Player> playerResponseFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, Player>(k, Player.fromJson(v)));

String feedResponseToJson(Map<String, Player> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())));

@immutable
class Player {
  Player({
    required this.contractUntil,
    required this.dateOfBirth,
    required this.jerseyNumber,
    required this.name,
    required this.nationality,
    required this.position,
  });

  String contractUntil;
  String dateOfBirth;
  int jerseyNumber;
  String name;
  String nationality;
  String position;



  factory Player.fromJson(Map<String, dynamic> json) => Player(
    contractUntil: json["contractUntil"],
    dateOfBirth: json["dateOfBirth"],
    jerseyNumber: json["jerseyNumber"],
    name: json["name"],
    nationality: json["nationality"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "contractUntil": contractUntil,
    "dateOfBirth": dateOfBirth,
    "jerseyNumber": jerseyNumber,
    "name": name,
    "nationality": nationality,
    "position": position,
  };
}

