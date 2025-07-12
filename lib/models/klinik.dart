// To parse this JSON data, do
//
//     final klinik = klinikFromJson(jsonString);

import 'dart:convert';

Klinik klinikFromJson(String str) => Klinik.fromJson(json.decode(str));

String klinikToJson(Klinik data) => json.encode(data.toJson());

class Klinik {
  String? nama;
  String? alamat;
  String? noTelp;
  String? jenis;
  String? latitude;
  String? longitude;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Klinik({
    this.nama,
    this.alamat,
    this.noTelp,
    this.jenis,
    this.latitude,
    this.longitude,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Klinik.fromJson(Map<String, dynamic> json) => Klinik(
    nama: json["nama"],
    alamat: json["alamat"],
    noTelp: json["no_telp"],
    jenis: json["jenis"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "nama": nama,
    "alamat": alamat,
    "no_telp": noTelp,
    "jenis": jenis,
    "latitude": latitude,
    "longitude": longitude,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
