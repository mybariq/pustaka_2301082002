<?php
require 'connection.php';

// GET all buku
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT * FROM buku";
    $result = mysqli_query($conn, $sql);
    $data = array();
    
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
    echo json_encode($data);
}

// POST new buku
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $judul = $data['judul'];
    $pengarang = $data['pengarang'];
    $penerbit = $data['penerbit'];
    $tahun_terbit = $data['tahun_terbit'];
    
    $sql = "INSERT INTO buku (judul, pengarang, penerbit, tahun_terbit) 
            VALUES ('$judul', '$pengarang', '$penerbit', $tahun_terbit)";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Buku berhasil ditambahkan"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}

// PUT/UPDATE buku
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $id = $data['id'];
    $judul = $data['judul'];
    $pengarang = $data['pengarang'];
    $penerbit = $data['penerbit'];
    $tahun_terbit = $data['tahun_terbit'];
    
    $sql = "UPDATE buku SET 
            judul='$judul', 
            pengarang='$pengarang', 
            penerbit='$penerbit', 
            tahun_terbit=$tahun_terbit 
            WHERE id=$id";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Buku berhasil diupdate"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}

// DELETE buku
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $id = $_GET['id'];
    
    $sql = "DELETE FROM buku WHERE id=$id";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Buku berhasil dihapus"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}
?> 