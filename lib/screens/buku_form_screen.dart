import 'package:flutter/material.dart';
import '../models/buku.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class BukuFormScreen extends StatefulWidget {
  final Buku? buku;

  const BukuFormScreen({super.key, this.buku});

  @override
  State<BukuFormScreen> createState() => _BukuFormScreenState();
}

class _BukuFormScreenState extends State<BukuFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  late TextEditingController _judulController;
  late TextEditingController _pengarangController;
  late TextEditingController _penerbitController;
  late TextEditingController _tahunTerbitController;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.buku?.judul ?? '');
    _pengarangController =
        TextEditingController(text: widget.buku?.pengarang ?? '');
    _penerbitController = TextEditingController(text: widget.buku?.penerbit ?? '');
    _tahunTerbitController = TextEditingController(
        text: widget.buku?.tahunTerbit.toString() ?? '');
  }

  @override
  void dispose() {
    _judulController.dispose();
    _pengarangController.dispose();
    _penerbitController.dispose();
    _tahunTerbitController.dispose();
    super.dispose();
  }

  Future<void> _saveBuku() async {
    if (_formKey.currentState!.validate()) {
      try {
        final buku = {
          if (widget.buku?.id != null) 'id': widget.buku!.id,
          'judul': _judulController.text,
          'pengarang': _pengarangController.text,
          'penerbit': _penerbitController.text,
          'tahun_terbit': int.parse(_tahunTerbitController.text),
        };

        if (widget.buku == null) {
          await _apiService.post(ApiConfig.buku, buku);
        } else {
          await _apiService.put(ApiConfig.buku, buku);
        }

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil disimpan')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.buku == null ? 'Tambah Buku' : 'Edit Buku'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _pengarangController,
              decoration: const InputDecoration(
                labelText: 'Pengarang',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pengarang tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _penerbitController,
              decoration: const InputDecoration(
                labelText: 'Penerbit',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Penerbit tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tahunTerbitController,
              decoration: const InputDecoration(
                labelText: 'Tahun Terbit',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tahun terbit tidak boleh kosong';
                }
                if (int.tryParse(value) == null) {
                  return 'Tahun terbit harus berupa angka';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveBuku,
              child: Text(
                widget.buku == null ? 'Simpan' : 'Update',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 