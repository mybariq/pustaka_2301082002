-- Membuat database
CREATE DATABASE flutter_pustaka;

-- Menggunakan database
USE flutter_pustaka;

-- Membuat tabel Anggota
CREATE TABLE anggota (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nim VARCHAR(20) NOT NULL,
    nama VARCHAR(100) NOT NULL,
    alamat TEXT,
    jenis_kelamin ENUM('L', 'P') NOT NULL
);

-- Membuat tabel Buku
CREATE TABLE buku (
    id INT PRIMARY KEY AUTO_INCREMENT,
    judul VARCHAR(200) NOT NULL,
    pengarang VARCHAR(100),
    penerbit VARCHAR(100),
    tahun_terbit INT
);

-- Membuat tabel Peminjaman
CREATE TABLE peminjaman (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tanggal_pinjam DATE NOT NULL,
    tanggal_kembali DATE NOT NULL,
    anggota_id INT,
    buku_id INT,
    FOREIGN KEY (anggota_id) REFERENCES anggota(id),
    FOREIGN KEY (buku_id) REFERENCES buku(id)
);

-- Membuat tabel Pengembalian
CREATE TABLE pengembalian (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tanggal_dikembalikan DATE NOT NULL,
    terlambat INT DEFAULT 0,
    denda DECIMAL(10,2) DEFAULT 0.00,
    peminjaman_id INT,
    FOREIGN KEY (peminjaman_id) REFERENCES peminjaman(id)
); 