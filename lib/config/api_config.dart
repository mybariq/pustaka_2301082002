class ApiConfig {
  // Untuk Android Emulator
  // static const String baseUrl = 'http://10.0.2.2/flutter_pustaka/php';
  
  // Untuk device fisik atau testing lokal
  // Ganti sesuai dengan IP komputer Anda
  static const String baseUrl = 'http://192.168.1.33/flutter_pustaka/php';
  
  // Endpoints
  static const String anggota = '$baseUrl/anggota.php';
  static const String buku = '$baseUrl/buku.php';
  static const String peminjaman = '$baseUrl/peminjaman.php';
  static const String pengembalian = '$baseUrl/pengembalian.php';
  static const String search = '$baseUrl/search.php';
  static const String dashboard = '$baseUrl/dashboard.php';
  static const String report = '$baseUrl/report.php';
  static const String calculateFine = '$baseUrl/calculate_fine.php';
} 