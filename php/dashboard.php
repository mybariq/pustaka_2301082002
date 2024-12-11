<?php
require 'connection.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Total buku
    $sql_buku = "SELECT COUNT(*) as total_buku FROM buku";
    $result_buku = mysqli_query($conn, $sql_buku);
    $total_buku = mysqli_fetch_assoc($result_buku)['total_buku'];
    
    // Total anggota
    $sql_anggota = "SELECT COUNT(*) as total_anggota FROM anggota";
    $result_anggota = mysqli_query($conn, $sql_anggota);
    $total_anggota = mysqli_fetch_assoc($result_anggota)['total_anggota'];
    
    // Total peminjaman aktif
    $sql_peminjaman = "SELECT COUNT(*) as total_peminjaman 
                       FROM peminjaman p 
                       LEFT JOIN pengembalian pg ON p.id = pg.peminjaman_id 
                       WHERE pg.id IS NULL";
    $result_peminjaman = mysqli_query($conn, $sql_peminjaman);
    $total_peminjaman = mysqli_fetch_assoc($result_peminjaman)['total_peminjaman'];
    
    // Total denda
    $sql_denda = "SELECT SUM(denda) as total_denda FROM pengembalian";
    $result_denda = mysqli_query($conn, $sql_denda);
    $total_denda = mysqli_fetch_assoc($result_denda)['total_denda'];
    
    $data = array(
        'total_buku' => $total_buku,
        'total_anggota' => $total_anggota,
        'total_peminjaman_aktif' => $total_peminjaman,
        'total_denda' => $total_denda
    );
    
    echo json_encode($data);
}
?> 