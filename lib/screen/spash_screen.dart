import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpashScreen extends StatefulWidget {
  const SpashScreen({super.key});

  @override
  State<SpashScreen> createState() => _SpashScreenState();
}

class _SpashScreenState extends State<SpashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/page_list_klinik');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: Colors.teal,
              child: Icon(Icons.local_hospital, size: 48, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'KlinikM',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Solusi Kesehatan Anda',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              color: Colors.teal,
            ),
          ],
        ),
      ),
    );
  }
}
