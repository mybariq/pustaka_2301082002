<?php
require 'connection.php';

// GET all peminjaman
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT p.*, a.nama as nama_anggota, b.judul as judul_buku 
            FROM peminjaman p 
            JOIN anggota a ON p.anggota_id = a.id 
            JOIN buku b ON p.buku_id = b.id";
    $result = mysqli_query($conn, $sql);
    $data = array();
    
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
    echo json_encode($data);
}

// POST new peminjaman
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $tanggal_pinjam = $data['tanggal_pinjam'];
    $tanggal_kembali = $data['tanggal_kembali'];
    $anggota_id = $data['anggota_id'];
    $buku_id = $data['buku_id'];
    
    $sql = "INSERT INTO peminjaman (tanggal_pinjam, tanggal_kembali, anggota_id, buku_id) 
            VALUES ('$tanggal_pinjam', '$tanggal_kembali', $anggota_id, $buku_id)";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Peminjaman berhasil ditambahkan"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}

// PUT/UPDATE peminjaman
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $id = $data['id'];
    $tanggal_pinjam = $data['tanggal_pinjam'];
    $tanggal_kembali = $data['tanggal_kembali'];
    $anggota_id = $data['anggota_id'];
    $buku_id = $data['buku_id'];
    
    $sql = "UPDATE peminjaman SET 
            tanggal_pinjam='$tanggal_pinjam', 
            tanggal_kembali='$tanggal_kembali', 
            anggota_id=$anggota_id, 
            buku_id=$buku_id 
            WHERE id=$id";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Peminjaman berhasil diupdate"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}

// DELETE peminjaman
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $id = $_GET['id'];
    
    $sql = "DELETE FROM peminjaman WHERE id=$id";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Peminjaman berhasil dihapus"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}
?> 