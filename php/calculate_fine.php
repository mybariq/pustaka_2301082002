<?php
require 'connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $peminjaman_id = $data['peminjaman_id'];
    $tanggal_dikembalikan = $data['tanggal_dikembalikan'];
    
    // Ambil data peminjaman
    $sql = "SELECT tanggal_kembali FROM peminjaman WHERE id = $peminjaman_id";
    $result = mysqli_query($conn, $sql);
    $peminjaman = mysqli_fetch_assoc($result);
    
    // Hitung selisih hari
    $tanggal_kembali = new DateTime($peminjaman['tanggal_kembali']);
    $tanggal_actual = new DateTime($tanggal_dikembalikan);
    $selisih = $tanggal_actual->diff($tanggal_kembali);
    
    $terlambat = 0;
    $denda = 0;
    
    // Jika terlambat
    if ($tanggal_actual > $tanggal_kembali) {
        $terlambat = $selisih->days;
        $denda = $terlambat * 1000; // Denda Rp 1.000 per hari
    }
    
    echo json_encode([
        'terlambat' => $terlambat,
        'denda' => $denda
    ]);
}
?> 