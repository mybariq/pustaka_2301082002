<?php
require 'connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $type = isset($_GET['type']) ? $_GET['type'] : 'peminjaman';
    $start_date = isset($_GET['start_date']) ? $_GET['start_date'] : date('Y-m-01');
    $end_date = isset($_GET['end_date']) ? $_GET['end_date'] : date('Y-m-d');
    
    if ($type === 'peminjaman') {
        $sql = "SELECT p.*, a.nama as nama_anggota, b.judul as judul_buku,
                pg.tanggal_dikembalikan, pg.terlambat, pg.denda
                FROM peminjaman p
                JOIN anggota a ON p.anggota_id = a.id
                JOIN buku b ON p.buku_id = b.id
                LEFT JOIN pengembalian pg ON p.id = pg.peminjaman_id
                WHERE p.tanggal_pinjam BETWEEN '$start_date' AND '$end_date'
                ORDER BY p.tanggal_pinjam DESC";
    } else {
        $sql = "SELECT pg.*, p.tanggal_pinjam, p.tanggal_kembali,
                a.nama as nama_anggota, b.judul as judul_buku
                FROM pengembalian pg
                JOIN peminjaman p ON pg.peminjaman_id = p.id
                JOIN anggota a ON p.anggota_id = a.id
                JOIN buku b ON p.buku_id = b.id
                WHERE pg.tanggal_dikembalikan BETWEEN '$start_date' AND '$end_date'
                ORDER BY pg.tanggal_dikembalikan DESC";
    }
    
    $result = mysqli_query($conn, $sql);
    $data = array();
    
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
    
    echo json_encode($data);
}
?> 