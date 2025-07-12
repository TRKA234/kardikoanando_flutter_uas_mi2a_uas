import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/klinik.dart';
import '../services/klinik_service.dart';

class PageFormKlinik extends StatefulWidget {
  final Klinik? klinik;
  const PageFormKlinik({this.klinik, super.key});

  @override
  State<PageFormKlinik> createState() => _PageFormKlinikState();
}

class _PageFormKlinikState extends State<PageFormKlinik> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  String? _jenis;
  final List<String> _jenisList = ['Umum', 'Gigi', 'Bersalin', 'Kecantikan'];

  @override
  void initState() {
    super.initState();
    if (widget.klinik != null) {
      _namaController.text = widget.klinik!.nama ?? '';
      _alamatController.text = widget.klinik!.alamat ?? '';
      _noTelpController.text = widget.klinik!.noTelp ?? '';
      _latitudeController.text = widget.klinik!.latitude ?? '';
      _longitudeController.text = widget.klinik!.longitude ?? '';
      // Normalisasi value agar cocok dengan dropdown
      if (widget.klinik!.jenis != null) {
        final jenisNormalized = _jenisList.firstWhere(
          (e) => e.toLowerCase() == widget.klinik!.jenis!.toLowerCase(),
          orElse: () {
            return ''; // Pastikan return String, bukan null
          },
        );
        _jenis = jenisNormalized.isEmpty ? null : jenisNormalized;
      }
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    Klinik newKlinik = Klinik(
      id: widget.klinik?.id,
      nama: _namaController.text,
      alamat: _alamatController.text,
      noTelp: _noTelpController.text,
      jenis: _jenis,
      latitude: _latitudeController.text,
      longitude: _longitudeController.text,
    );

    bool success;
    if (widget.klinik == null) {
      success = await KlinikService().createKlinik(newKlinik);
    } else {
      success = await KlinikService().updateKlinik(
        widget.klinik!.id!,
        newKlinik,
      );
    }

    if (success) {
      Fluttertoast.showToast(msg: 'Berhasil disimpan');
      Navigator.pop(context, newKlinik); // Kirim data terbaru!
    } else {
      Fluttertoast.showToast(msg: 'Gagal menyimpan');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.klinik != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Klinik' : 'Tambah Klinik',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_namaController, 'Nama Klinik'),
              _buildTextField(_alamatController, 'Alamat'),
              _buildTextField(_noTelpController, 'No Telepon'),
              _buildDropdown('Jenis Klinik', _jenisList, _jenis, (val) {
                setState(() => _jenis = val);
              }),
              _buildTextField(_latitudeController, 'Latitude'),
              _buildTextField(_longitudeController, 'Longitude'),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: GoogleFonts.poppins(fontSize: 16),
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        validator: (value) => value!.isEmpty ? 'Tidak boleh kosong' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? value,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (val) => val == null ? 'Harus dipilih' : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
