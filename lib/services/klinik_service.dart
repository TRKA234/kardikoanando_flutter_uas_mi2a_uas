import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/klinik.dart';

class KlinikService {
  final String baseUrl = 'http://10.242.178.111:8000';

  // Ambil semua klinik
  Future<List<Klinik>> fetchKlinik() async {
    final response = await http.get(Uri.parse('$baseUrl/klinik'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Klinik.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data klinik');
    }
  }

  // Tambah klinik
  Future<bool> createKlinik(Klinik klinik) async {
    final response = await http.post(
      Uri.parse('$baseUrl/klinik'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(klinik.toJson()),
    );

    return response.statusCode == 201;
  }

  // Update klinik
  Future<bool> updateKlinik(int id, Klinik klinik) async {
    final response = await http.put(
      Uri.parse('$baseUrl/klinik/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(klinik.toJson()),
    );

    return response.statusCode == 200;
  }

  // Hapus klinik
  Future<bool> deleteKlinik(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/klinik/$id'));
    return response.statusCode == 200;
  }
}
