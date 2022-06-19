import 'package:flutter/material.dart';



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


}

