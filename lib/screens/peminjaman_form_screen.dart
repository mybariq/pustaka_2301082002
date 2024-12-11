import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/peminjaman.dart';
import '../models/anggota.dart';
import '../models/buku.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class PeminjamanFormScreen extends StatefulWidget {
  final Peminjaman? peminjaman;

  const PeminjamanFormScreen({super.key, this.peminjaman});

  @override
  State<PeminjamanFormScreen> createState() => _PeminjamanFormScreenState();
}

class _PeminjamanFormScreenState extends State<PeminjamanFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  DateTime _tanggalPinjam = DateTime.now();
  DateTime _tanggalKembali = DateTime.now().add(const Duration(days: 7));
  List<Anggota> _anggotaList = [];
  List<Buku> _bukuList = [];
  int? _selectedAnggotaId;
  int? _selectedBukuId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    if (widget.peminjaman != null) {
      _tanggalPinjam = DateTime.parse(widget.peminjaman!.tanggalPinjam);
      _tanggalKembali = DateTime.parse(widget.peminjaman!.tanggalKembali);
      _selectedAnggotaId = widget.peminjaman!.anggotaId;
      _selectedBukuId = widget.peminjaman!.bukuId;
    }
  }

  Future<void> _loadData() async {
    try {
      final anggotaData = await _apiService.get(ApiConfig.anggota);
      final bukuData = await _apiService.get(ApiConfig.buku);

      setState(() {
        _anggotaList =
            (anggotaData as List).map((item) => Anggota.fromJson(item)).toList();
        _bukuList = (bukuData as List).map((item) => Buku.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isPinjam) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isPinjam ? _tanggalPinjam : _tanggalKembali,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isPinjam) {
          _tanggalPinjam = picked;
        } else {
          _tanggalKembali = picked;
        }
      });
    }
  }

  Future<void> _savePeminjaman() async {
    if (_formKey.currentState!.validate()) {
      try {
        final peminjaman = {
          if (widget.peminjaman?.id != null) 'id': widget.peminjaman!.id,
          'tanggal_pinjam':
              DateFormat('yyyy-MM-dd').format(_tanggalPinjam),
          'tanggal_kembali':
              DateFormat('yyyy-MM-dd').format(_tanggalKembali),
          'anggota_id': _selectedAnggotaId,
          'buku_id': _selectedBukuId,
        };

        if (widget.peminjaman == null) {
          await _apiService.post(ApiConfig.peminjaman, peminjaman);
        } else {
          await _apiService.put(ApiConfig.peminjaman, peminjaman);
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
        title: Text(widget.peminjaman == null
            ? 'Tambah Peminjaman'
            : 'Edit Peminjaman'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  DropdownButtonFormField<int>(
                    value: _selectedAnggotaId,
                    decoration: const InputDecoration(
                      labelText: 'Anggota',
                      border: OutlineInputBorder(),
                    ),
                    items: _anggotaList.map((anggota) {
                      return DropdownMenuItem(
                        value: anggota.id,
                        child: Text('${anggota.nim} - ${anggota.nama}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAnggotaId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih anggota';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedBukuId,
                    decoration: const InputDecoration(
                      labelText: 'Buku',
                      border: OutlineInputBorder(),
                    ),
                    items: _bukuList.map((buku) {
                      return DropdownMenuItem(
                        value: buku.id,
                        child: Text(buku.judul),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBukuId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih buku';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Tanggal Pinjam'),
                    subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_tanggalPinjam)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context, true),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Tanggal Kembali'),
                    subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_tanggalKembali)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context, false),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _savePeminjaman,
                    child: Text(
                      widget.peminjaman == null ? 'Simpan' : 'Update',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 