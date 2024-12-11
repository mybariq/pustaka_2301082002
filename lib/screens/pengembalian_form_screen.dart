import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/peminjaman.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class PengembalianFormScreen extends StatefulWidget {
  const PengembalianFormScreen({super.key});

  @override
  State<PengembalianFormScreen> createState() => _PengembalianFormScreenState();
}

class _PengembalianFormScreenState extends State<PengembalianFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  List<Peminjaman> _peminjamanList = [];
  int? _selectedPeminjamanId;
  DateTime _tanggalDikembalikan = DateTime.now();
  int _terlambat = 0;
  double _denda = 0;
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
        // Filter hanya peminjaman yang belum dikembalikan
        _peminjamanList = _peminjamanList.where((peminjaman) {
          return !_peminjamanList.any((p) =>
              p.id == peminjaman.id); // Sesuaikan dengan logika backend
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _calculateFine() async {
    if (_selectedPeminjamanId == null) return;

    try {
      final response = await _apiService.post(ApiConfig.calculateFine, {
        'peminjaman_id': _selectedPeminjamanId,
        'tanggal_dikembalikan':
            DateFormat('yyyy-MM-dd').format(_tanggalDikembalikan),
      });

      setState(() {
        _terlambat = response['terlambat'];
        _denda = response['denda'].toDouble();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _savePengembalian() async {
    if (_formKey.currentState!.validate()) {
      try {
        final pengembalian = {
          'tanggal_dikembalikan':
              DateFormat('yyyy-MM-dd').format(_tanggalDikembalikan),
          'terlambat': _terlambat,
          'denda': _denda,
          'peminjaman_id': _selectedPeminjamanId,
        };

        await _apiService.post(ApiConfig.pengembalian, pengembalian);

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengembalian berhasil disimpan')),
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
        title: const Text('Tambah Pengembalian'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  DropdownButtonFormField<int>(
                    value: _selectedPeminjamanId,
                    decoration: const InputDecoration(
                      labelText: 'Pilih Peminjaman',
                      border: OutlineInputBorder(),
                    ),
                    items: _peminjamanList.map((peminjaman) {
                      return DropdownMenuItem(
                        value: peminjaman.id,
                        child: Text(
                            '${peminjaman.judulBuku} - ${peminjaman.namaAnggota}'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPeminjamanId = value;
                        _calculateFine();
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih peminjaman';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Tanggal Pengembalian'),
                    subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(_tanggalDikembalikan)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _tanggalDikembalikan,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() {
                          _tanggalDikembalikan = picked;
                          _calculateFine();
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Keterlambatan: $_terlambat hari'),
                          const SizedBox(height: 8),
                          Text(
                              'Denda: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_denda)}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _savePengembalian,
                    child: const Text(
                      'Simpan',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 