class Buku {
  final int? id;
  final String judul;
  final String pengarang;
  final String penerbit;
  final int tahunTerbit;

  Buku({
    this.id,
    required this.judul,
    required this.pengarang,
    required this.penerbit,
    required this.tahunTerbit,
  });

  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: int.parse(json['id'].toString()),
      judul: json['judul'],
      pengarang: json['pengarang'],
      penerbit: json['penerbit'],
      tahunTerbit: int.parse(json['tahun_terbit'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'pengarang': pengarang,
      'penerbit': penerbit,
      'tahun_terbit': tahunTerbit,
    };
  }
} 