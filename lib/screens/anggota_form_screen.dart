import 'package:flutter/material.dart';
import '../models/anggota.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class AnggotaFormScreen extends StatefulWidget {
  final Anggota? anggota;

  const AnggotaFormScreen({super.key, this.anggota});

  @override
  State<AnggotaFormScreen> createState() => _AnggotaFormScreenState();
}

class _AnggotaFormScreenState extends State<AnggotaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  
  late TextEditingController _nimController;
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  String _jenisKelamin = 'L';

  @override
  void initState() {
    super.initState();
    _nimController = TextEditingController(text: widget.anggota?.nim ?? '');
    _namaController = TextEditingController(text: widget.anggota?.nama ?? '');
    _alamatController = TextEditingController(text: widget.anggota?.alamat ?? '');
    _jenisKelamin = widget.anggota?.jenisKelamin ?? 'L';
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _saveAnggota() async {
    if (_formKey.currentState!.validate()) {
      try {
        final anggota = {
          if (widget.anggota?.id != null) 'id': widget.anggota!.id,
          'nim': _nimController.text,
          'nama': _namaController.text,
          'alamat': _alamatController.text,
          'jenis_kelamin': _jenisKelamin,
        };

        if (widget.anggota == null) {
          await _apiService.post(ApiConfig.anggota, anggota);
        } else {
          await _apiService.put(ApiConfig.anggota, anggota);
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
        title: Text(widget.anggota == null ? 'Tambah Anggota' : 'Edit Anggota'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nimController,
              decoration: const InputDecoration(
                labelText: 'NIM',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIM tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _alamatController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _jenisKelamin,
              decoration: const InputDecoration(
                labelText: 'Jenis Kelamin',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'L', child: Text('Laki-laki')),
                DropdownMenuItem(value: 'P', child: Text('Perempuan')),
              ],
              onChanged: (value) {
                setState(() {
                  _jenisKelamin = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveAnggota,
              child: Text(
                widget.anggota == null ? 'Simpan' : 'Update',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 