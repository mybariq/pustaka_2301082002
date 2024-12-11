import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/pengembalian.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';
import 'pengembalian_form_screen.dart';

class PengembalianScreen extends StatefulWidget {
  const PengembalianScreen({super.key});

  @override
  State<PengembalianScreen> createState() => _PengembalianScreenState();
}

class _PengembalianScreenState extends State<PengembalianScreen> {
  final ApiService _apiService = ApiService();
  List<Pengembalian> _pengembalianList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPengembalian();
  }

  Future<void> _loadPengembalian() async {
    try {
      final data = await _apiService.get(ApiConfig.pengembalian);
      setState(() {
        _pengembalianList =
            (data as List).map((item) => Pengembalian.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String _formatDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Pengembalian'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _pengembalianList.length,
              itemBuilder: (context, index) {
                final pengembalian = _pengembalianList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(pengembalian.judulBuku ?? ''),
                    subtitle: Text(
                      'Peminjam: ${pengembalian.namaAnggota}\n'
                      'Tanggal Kembali: ${_formatDate(pengembalian.tanggalKembali ?? '')}\n'
                      'Dikembalikan: ${_formatDate(pengembalian.tanggalDikembalikan)}\n'
                      'Terlambat: ${pengembalian.terlambat} hari\n'
                      'Denda: ${_formatCurrency(pengembalian.denda)}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PengembalianFormScreen(),
            ),
          ).then((_) => _loadPengembalian());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 