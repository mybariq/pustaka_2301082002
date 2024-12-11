class Peminjaman {
  final int? id;
  final String tanggalPinjam;
  final String tanggalKembali;
  final int anggotaId;
  final int bukuId;
  final String? namaAnggota;  // Untuk tampilan
  final String? judulBuku;    // Untuk tampilan

  Peminjaman({
    this.id,
    required this.tanggalPinjam,
    required this.tanggalKembali,
    required this.anggotaId,
    required this.bukuId,
    this.namaAnggota,
    this.judulBuku,
  });

  factory Peminjaman.fromJson(Map<String, dynamic> json) {
    return Peminjaman(
      id: int.parse(json['id'].toString()),
      tanggalPinjam: json['tanggal_pinjam'],
      tanggalKembali: json['tanggal_kembali'],
      anggotaId: int.parse(json['anggota_id'].toString()),
      bukuId: int.parse(json['buku_id'].toString()),
      namaAnggota: json['nama_anggota'],
      judulBuku: json['judul_buku'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal_pinjam': tanggalPinjam,
      'tanggal_kembali': tanggalKembali,
      'anggota_id': anggotaId,
      'buku_id': bukuId,
    };
  }
} 