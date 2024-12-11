<?php
require 'connection.php';

// GET all pengembalian
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT pg.*, p.tanggal_pinjam, p.tanggal_kembali, 
            a.nama as nama_anggota, b.judul as judul_buku 
            FROM pengembalian pg 
            JOIN peminjaman p ON pg.peminjaman_id = p.id 
            JOIN anggota a ON p.anggota_id = a.id 
            JOIN buku b ON p.buku_id = b.id";
    $result = mysqli_query($conn, $sql);
    $data = array();
    
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
    echo json_encode($data);
}

// POST new pengembalian
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $tanggal_dikembalikan = $data['tanggal_dikembalikan'];
    $terlambat = $data['terlambat'];
    $denda = $data['denda'];
    $peminjaman_id = $data['peminjaman_id'];
    
    $sql = "INSERT INTO pengembalian (tanggal_dikembalikan, terlambat, denda, peminjaman_id) 
            VALUES ('$tanggal_dikembalikan', $terlambat, $denda, $peminjaman_id)";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Pengembalian berhasil ditambahkan"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}

// PUT/UPDATE pengembalian
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $id = $data['id'];
    $tanggal_dikembalikan = $data['tanggal_dikembalikan'];
    $terlambat = $data['terlambat'];
    $denda = $data['denda'];
    $peminjaman_id = $data['peminjaman_id'];
    
    $sql = "UPDATE pengembalian SET 
            tanggal_dikembalikan='$tanggal_dikembalikan', 
            terlambat=$terlambat, 
            denda=$denda, 
            peminjaman_id=$peminjaman_id 
            WHERE id=$id";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Pengembalian berhasil diupdate"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}

// DELETE pengembalian
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $id = $_GET['id'];
    
    $sql = "DELETE FROM pengembalian WHERE id=$id";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Pengembalian berhasil dihapus"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}
?> 