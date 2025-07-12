import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/klinik.dart';
import '../services/klinik_service.dart';
import 'page_form_klinik.dart';

class PageDetailKlinik extends StatefulWidget {
  final Klinik klinik;
  const PageDetailKlinik({required this.klinik, super.key});

  @override
  State<PageDetailKlinik> createState() => _PageDetailKlinikState();
}

class _PageDetailKlinikState extends State<PageDetailKlinik> {
  late Klinik klinik;

  @override
  void initState() {
    super.initState();
    klinik = widget.klinik;
  }

  Future<void> _deleteKlinik() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Klinik'),
        content: Text('Yakin ingin menghapus klinik ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final success = await KlinikService().deleteKlinik(klinik.id!);
      if (success) {
        Fluttertoast.showToast(msg: 'Klinik berhasil dihapus');
        Navigator.pop(context, true); // trigger refresh di list
      } else {
        Fluttertoast.showToast(msg: 'Gagal menghapus klinik');
      }
    }
  }

  Future<void> _editKlinik() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageFormKlinik(klinik: klinik)),
    );
    if (result is Klinik) {
      setState(() {
        klinik = result;
      });
      Fluttertoast.showToast(msg: 'Data klinik diperbarui');
      Navigator.pop(context, true); // <-- ini trigger refresh di list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Klinik', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: _editKlinik,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Hapus',
            onPressed: _deleteKlinik,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.teal[50],
                    child: Icon(
                      Icons.local_hospital,
                      color: Colors.teal[700],
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildDetailRow('Nama Klinik', klinik.nama ?? '-'),
                _buildDetailRow('Alamat', klinik.alamat ?? '-'),
                _buildDetailRow('No Telepon', klinik.noTelp ?? '-'),
                _buildDetailRow('Jenis', klinik.jenis ?? '-'),
                _buildDetailRow('Latitude', klinik.latitude ?? '-'),
                _buildDetailRow('Longitude', klinik.longitude ?? '-'),
                SizedBox(height: 12),
                if (klinik.latitude != null && klinik.longitude != null)
                  SizedBox(
                    height: 200,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          double.tryParse(klinik.latitude ?? '0') ?? 0,
                          double.tryParse(klinik.longitude ?? '0') ?? 0,
                        ),
                        zoom: 15,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('klinik'),
                          position: LatLng(
                            double.tryParse(klinik.latitude ?? '0') ?? 0,
                            double.tryParse(klinik.longitude ?? '0') ?? 0,
                          ),
                          infoWindow: InfoWindow(title: klinik.nama ?? '-'),
                        ),
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                  ),
                SizedBox(height: 12),
                if (klinik.createdAt != null)
                  _buildDetailRow('Dibuat', klinik.createdAt.toString()),
                if (klinik.updatedAt != null)
                  _buildDetailRow('Diubah', klinik.updatedAt.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.teal[900],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }
}
