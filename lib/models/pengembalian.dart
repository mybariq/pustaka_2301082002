class Pengembalian {
  final int? id;
  final String tanggalDikembalikan;
  final int terlambat;
  final double denda;
  final int peminjamanId;
  // Fields tambahan untuk tampilan
  final String? namaAnggota;
  final String? judulBuku;
  final String? tanggalPinjam;
  final String? tanggalKembali;

  Pengembalian({
    this.id,
    required this.tanggalDikembalikan,
    required this.terlambat,
    required this.denda,
    required this.peminjamanId,
    this.namaAnggota,
    this.judulBuku,
    this.tanggalPinjam,
    this.tanggalKembali,
  });

  factory Pengembalian.fromJson(Map<String, dynamic> json) {
    return Pengembalian(
      id: int.parse(json['id'].toString()),
      tanggalDikembalikan: json['tanggal_dikembalikan'],
      terlambat: int.parse(json['terlambat'].toString()),
      denda: double.parse(json['denda'].toString()),
      peminjamanId: int.parse(json['peminjaman_id'].toString()),
      namaAnggota: json['nama_anggota'],
      judulBuku: json['judul_buku'],
      tanggalPinjam: json['tanggal_pinjam'],
      tanggalKembali: json['tanggal_kembali'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal_dikembalikan': tanggalDikembalikan,
      'terlambat': terlambat,
      'denda': denda,
      'peminjaman_id': peminjamanId,
    };
  }
} 