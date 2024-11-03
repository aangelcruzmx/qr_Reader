import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  int? id;
  late String tipo;
  @required String valor;

  ScanModel({
  this.id,
  required this.valor,
}) {
  //para determinar el tipo de scan en este caso hice pruebas quise hacerlo conyoutube, twitter, instagram y http
  if (this.valor.contains('http')) {
    if (this.valor.contains('twitter.com') || this.valor.contains('x.com')) {
      this.tipo = 'twitter';
    } else if (this.valor.contains('instagram.com')) {
      this.tipo = 'instagram';
    } else if (this.valor.contains('youtube.com') || this.valor.contains('youtu.be')) {
      this.tipo = 'youtube';
    } else {
      this.tipo = 'http';
    }
  } else {
    this.tipo = 'geo';
  }
}

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
      };

  // Obtener latitud y longitud para coordenadas de tipo 'geo'
  LatLng getLatLng() {
    final latLng = valor.substring(4).split(',');
    final lat = double.parse(latLng[0]);
    final lng = double.parse(latLng[1]);
    return LatLng(lat, lng);
  }
}
