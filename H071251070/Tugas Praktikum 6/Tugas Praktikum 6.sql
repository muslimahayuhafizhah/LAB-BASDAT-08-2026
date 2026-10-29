SET search_path TO classicmodels, public;

SELECT * FROM products;

-- soal 1
SELECT productcode, productname, msrp, quantityinstock,
CASE
	WHEN msrp < 50 AND quantityinstock > 500 THEN 'Ekonomis-Stok Tinggi'
	WHEN msrp < 50 AND quantityinstock <= 500 THEN 'Ekonomis-Stok Rendah'
	WHEN msrp BETWEEN 50 AND 100 THEN 'Harga Menengah'
	WHEN msrp > 100 THEN 'Harga Premium'
END AS "Kategori_Stok"
FROM products;

-- soal 2
SELECT productcode, SUM(quantityordered) AS "total unit terjual", COUNT(DISTINCT ordernumber) AS "jumlah pesanan berbeda"
FROM orderdetails
GROUP BY productcode
HAVING SUM(quantityordered) > (
SELECT AVG(quantityordered)
FROM orderdetails
) AND COUNT(DISTINCT ordernumber) > 10
ORDER BY "total unit terjual" DESC;

-- soal 3
SELECT productcode, productname, quantityinstock, msrp
FROM products
WHERE quantityinstock > (SELECT AVG(quantityinstock) FROM products)
AND msrp > (SELECT AVG(msrp) FROM products)
ORDER BY quantityinstock DESC;

-- soal 4
BEGIN;

UPDATE orders
SET status = 'Pengiriman'
WHERE orderNumber = 10100;

SAVEPOINT status_pengiriman;

UPDATE orders
SET status = 'Batal'
WHERE orderNumber = 10100;

ROLLBACk TO SAVEPOINT status_pengiriman;

COMMIT;

-- soal 5
--anggota
CREATE TABLE anggota (
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nama_anggota VARCHAR(50) NOT NULL,
kota_domisili VARCHAR(20) NOT NULL
);

--buku
CREATE TABLE buku (
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
judul_buku VARCHAR(20) NOT NULL,
genre VARCHAR(20) NOT NULL,
stok INT DEFAULT 1
);

--pinjaman
CREATE TABLE pinjaman (
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_anggota INT REFERENCES anggota(id),
id_buku INT REFERENCES buku(id),
tanggal_pinjam DATE NOT NULL,
tanggal_kembali DATE,
denda INT DEFAULT 0
);

CREATE INDEX idx_buku_genre
ON buku(genre);

CREATE INDEX idx_anggota_kota_domisili
ON anggota(kota_domisili);