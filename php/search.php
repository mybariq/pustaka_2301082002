<?php
require 'connection.php';

// Search buku
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $keyword = isset($_GET['keyword']) ? $_GET['keyword'] : '';
    
    $sql = "SELECT * FROM buku 
            WHERE judul LIKE '%$keyword%' 
            OR pengarang LIKE '%$keyword%' 
            OR penerbit LIKE '%$keyword%'";
            
    $result = mysqli_query($conn, $sql);
    $data = array();
    
    while ($row = mysqli_fetch_assoc($result)) {
        $data[] = $row;
    }
    echo json_encode($data);
}
?> 