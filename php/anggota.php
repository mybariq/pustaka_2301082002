<?php
require 'connection.php';

// GET all anggota
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT * FROM anggota";
    $result = mysqli_query($conn, $sql);
    $data = array();
    
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
    echo json_encode($data);
}

// POST new anggota
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $nim = $data['nim'];
    $nama = $data['nama'];
    $alamat = $data['alamat'];
    $jenis_kelamin = $data['jenis_kelamin'];
    
    $sql = "INSERT INTO anggota (nim, nama, alamat, jenis_kelamin) 
            VALUES ('$nim', '$nama', '$alamat', '$jenis_kelamin')";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Anggota berhasil ditambahkan"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}

// PUT/UPDATE anggota
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    
    $id = $data['id'];
    $nim = $data['nim'];
    $nama = $data['nama'];
    $alamat = $data['alamat'];
    $jenis_kelamin = $data['jenis_kelamin'];
    
    $sql = "UPDATE anggota SET 
            nim='$nim', 
            nama='$nama', 
            alamat='$alamat', 
            jenis_kelamin='$jenis_kelamin' 
            WHERE id=$id";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Anggota berhasil diupdate"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}

// DELETE anggota
if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $id = $_GET['id'];
    
    $sql = "DELETE FROM anggota WHERE id=$id";
    
    if (mysqli_query($conn, $sql)) {
        echo json_encode(["message" => "Anggota berhasil dihapus"]);
    } else {
        echo json_encode(["message" => "Error: " . mysqli_error($conn)]);
    }
}
?> 