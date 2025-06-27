import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  final List<Map<String, String>> riwayat;

  RiwayatPage({required this.riwayat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Kosongkan riwayat saat tombol delete ditekan
              // Kembali ke halaman utama, di sana riwayat akan dibersihkan
              Navigator.pop(context, true); // Kirim sinyal untuk hapus
            },
          ),
        ],
      ),
      body: riwayat.isEmpty
          ? Center(child: Text('Belum ada riwayat'))
          : ListView.builder(
              itemCount: riwayat.length,
              itemBuilder: (context, index) {
                final item = riwayat[index];
                return ListTile(
                  title: Text('${item['input']} = ${item['result']}'),
                );
              },
            ),
    );
  }
}
