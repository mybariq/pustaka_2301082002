import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/peminjaman.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';
import 'peminjaman_form_screen.dart';

class PeminjamanScreen extends StatefulWidget {
  const PeminjamanScreen({super.key});

  @override
  State<PeminjamanScreen> createState() => _PeminjamanScreenState();
}

class _PeminjamanScreenState extends State<PeminjamanScreen> {
  final ApiService _apiService = ApiService();
  List<Peminjaman> _peminjamanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPeminjaman();
  }

  Future<void> _loadPeminjaman() async {
    try {
      final data = await _apiService.get(ApiConfig.peminjaman);
      setState(() {
        _peminjamanList =
            (data as List).map((item) => Peminjaman.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deletePeminjaman(int id) async {
    try {
      await _apiService.delete(ApiConfig.peminjaman, id);
      _loadPeminjaman();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peminjaman berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Peminjaman'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _peminjamanList.length,
              itemBuilder: (context, index) {
                final peminjaman = _peminjamanList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(peminjaman.judulBuku ?? ''),
                    subtitle: Text(
                      'Peminjam: ${peminjaman.namaAnggota}\n'
                      'Tanggal Pinjam: ${_formatDate(peminjaman.tanggalPinjam)}\n'
                      'Tanggal Kembali: ${_formatDate(peminjaman.tanggalKembali)}',
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PeminjamanFormScreen(peminjaman: peminjaman),
                              ),
                            ).then((_) => _loadPeminjaman());
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Konfirmasi'),
                              content: const Text(
                                  'Yakin ingin menghapus peminjaman ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deletePeminjaman(peminjaman.id!);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PeminjamanFormScreen(),
            ),
          ).then((_) => _loadPeminjaman());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 