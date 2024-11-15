-- BÀI THỰC HÀNH SỐ 4: Trigger - Procedure

-- a. Bài tập về Store Procedure
-- 1. In ra dòng ‘Xin chào’
CREATE PROCEDURE p1
AS
BEGIN
PRINT N'Xin chào'
END;
-- exec
EXEC p1;

-- 2. In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên của bạn.
-- Cho thực thi và in giá trị của các tham số này để kiểm tra
CREATE PROCEDURE p2
    @ten NVARCHAR(50)
AS
BEGIN
DECLARE	@result NVARCHAR(50)
SET		@result = N'Xin chào ' + @ten
    PRINT	@result
END;
-- exec
EXEC p2 N'Trương Văn Hiển';

-- 3. Nhập vào 2 số @s1, @s2. In ra câu ‘tổng là : @tg ‘ với @tg = @s1 + @s2
CREATE PROCEDURE p3
    @s1 REAL, @s2 REAL
AS
BEGIN
DECLARE @tg REAL, @out NVARCHAR(50)
SET		@tg = @s1 + @s2
SET		@out = N'tổng là : ' + CAST(@tg AS NVARCHAR(50))
    PRINT	@out
END;
-- exec
EXEC p3 3.21, 7.65;

-- 4. Nhập vào 2 số @s1, @s2. Xuất tổng @s1+@s2 ra tham số @tong.
--Nhập vào 2 số @s1, @s2. In ra câu ‘Số lớn nhất của @s1 và @s2 là max’
-- với @s1, @s2, max là các giá trị tương ứng
CREATE PROCEDURE p4
    @s1 REAL, @s2 REAL
AS
BEGIN
DECLARE @tong REAL, @max REAL, @out NVARCHAR(50)

SET		@tong = @s1 + @s2
    PRINT	@tong

    IF @s1 < @s2
BEGIN
SET @max = @s2
END
    ELSE
BEGIN
SET @max = @s1
END
SET @out = CONCAT(N'Số lớn nhất của ', @s1, N' và ', @s2, N' là ', @max)
    PRINT @out
END;
-- exec
EXEC p4 3.21, 7.65;

-- 5. Nhập vào 2 số @s1, @s2. Xuất min và max của chúng ra tham số @max.
-- Cho thực thi và in giá trị của các tham số này để kiểm tra
CREATE PROCEDURE p5
    @s1 REAL, @s2 REAL
AS
BEGIN
DECLARE @min REAL, @max REAL, @out NVARCHAR(50)
	IF @s1 < @s2
		BEGIN
SET @min = @s1
SET @max = @s2
END
    ELSE
BEGIN
SET @min = @s2
SET @max = @s1
END
SET @out = CONCAT('Min: ', @min, N' và Max: ', @max)
    PRINT @out
END;
-- exec
EXEC p5 3.21, 7.65;

-- 6. Nhập vào số nguyên @n. In ra các số từ 1 đến @n
CREATE PROCEDURE p6
    @n INT
AS
BEGIN
DECLARE @i INT, @out NVARCHAR(50)
SET @i = 1
SET @out = ''
    WHILE @i <= @n
BEGIN
SET @out = CONCAT(@out, ' ', @i)
SET @i = @i + 1
END
    PRINT @out
END;
-- exec
EXEC p6 10;

-- 7. Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n
CREATE PROCEDURE p7
    @n INT
AS
BEGIN
DECLARE @i INT, @sum INT, @out NVARCHAR(50)
SET @i = 1
SET @sum = 0
    WHILE @i <= @n
BEGIN
IF @i % 2 = 0
				BEGIN
SET @sum = @sum + @i
END
SET @i = @i + 1
END
SET @out = CONCAT(N'Tổng các số chẵn từ 1 đến ', @n, N' là ', @sum)
    PRINT @out
END;
-- exec
EXEC p7 10;

-- 8. Nhập vào số nguyên @n. In ra tổng và số lượng các số chẵn từ 1 đến @n
-- Cho thực thi và in giá trị của các tham số này để kiểm tra
CREATE PROCEDURE p8
    @n INT
AS
BEGIN
DECLARE @i INT, @sum INT, @count INT
SET @i = 1
SET @sum = 0
SET @count = 0
    WHILE @i <= @n
BEGIN
IF @i % 2 = 0
				BEGIN
SET @sum = @sum + @i
SET @count = @count + 1
END
SET @i = @i + 1
END
    PRINT N'Tổng các số chẵn từ 1 đến ' + CAST(@n AS NVARCHAR(50)) + N' là ' + CAST(@sum AS NVARCHAR(50))
	PRINT N'Số lượng các số chẵn từ 1 đến ' + CAST(@n AS NVARCHAR(50)) + N' là ' + CAST(@count AS NVARCHAR(50))
END;
-- exec
EXEC p8 10;

-- 9. Viết store procedure tương ứng với các câu ở phần View. Sau đó cho thực hiện để kiểm tra kết quả
-- 9.1. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ
-- thuộc đội bóng “SHB Đà Nẵng” có quốc tịch “Bra-xin”
CREATE PROCEDURE p9_v1
AS
BEGIN
SELECT MACT, HOTEN, NGAYSINH, DIACHI, VITRI
FROM CAUTHU ct, CAULACBO clb, QUOCGIA qg
WHERE ct.MACLB = clb.MACLB AND TENCLB = N'SHB Đà Nẵng'
  AND ct.MAQG = qg.MAQG AND TENQG = N'Bra-xin'
END;
-- exec
EXEC p9_v1;

-- 9.2. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận
-- đấu vòng 3 của mùa bóng năm 2009
CREATE PROCEDURE p9_v2
AS
BEGIN
SELECT MATRAN, NGAYTD, svd.TENSAN, clb1.TENCLB AS [TENCLB1], clb2.TENCLB AS [TENCLB2], KETQUA
FROM TRANDAU td, SANVD svd, CAULACBO clb1, CAULACBO clb2
WHERE clb1.MACLB = td.MACLB1 AND clb2.MACLB = td.MACLB2
  AND svd.MASAN = td.MASAN
  AND VONG = 3 and NAM = 2009
END;

EXEC p9_v2;
-- exec
-- 9.3. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc
-- của các huấn luyện viên có quốc tịch “Việt Nam”
CREATE PROCEDURE p9_v3
AS
BEGIN
SELECT hlv.MAHLV, TENHLV, NGAYSINH, DIACHI, VAITRO, TENCLB
FROM HUANLUYENVIEN hlv, HLV_CLB, CAULACBO clb, QUOCGIA qg
WHERE hlv.MAHLV = HLV_CLB.MAHLV
  AND HLV_CLB.MACLB = clb.MACLB
  AND hlv.MAQG = qg.MAQG AND TENQG = N'Việt Nam'
END;

EXEC p9_v3;
-- exec
-- 9.4. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ
-- nước ngoài (có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ nhiều hơn
-- 2 cầu thủ nước ngoài
CREATE PROCEDURE p9_v4
AS
BEGIN
SELECT clb.MACLB, TENCLB, TENSAN, svd.DIACHI, COUNT(MACT) AS [Số lượng cầu thủ nước ngoài]
FROM CAULACBO clb, SANVD svd, CAUTHU ct, QUOCGIA qg
WHERE clb.MASAN = svd.MASAN
  AND clb.MACLB = ct.MACLB
  AND ct.MAQG = qg.MAQG
  AND TENQG <> N'Việt Nam'
GROUP BY clb.MACLB, TENCLB, TENSAN, svd.DIACHI
HAVING COUNT(MACT) > 2
END;
-- exec
EXEC p9_v4;

-- 9.5. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc
-- bộ thuộc địa bàn tỉnh đó quản lý
CREATE PROCEDURE p9_v5
AS
BEGIN
SELECT TENTINH, COUNT(MACT) AS [Số lượng cầu thủ đang thi đấu ở vị trí tiền đạo]
FROM TINH, CAULACBO clb, CAUTHU ct
WHERE TINH.MATINH = clb.MATINH
  AND clb.MACLB = ct.MACLB
  AND VITRI = N'Tiền đạo'
GROUP BY TENTINH
END;
-- exec
EXEC p9_v5;

-- 9.6. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất
-- của bảng xếp hạng của vòng 3 năm 2009
CREATE PROCEDURE p9_v6
AS
BEGIN
SELECT TOP 1 TENCLB, TENTINH
FROM CAULACBO clb, TINH, BANGXH bxh
WHERE bxh.MACLB = clb.MACLB
  AND clb.MATINH = TINH.MATINH
  AND VONG = 3 AND NAM = 2009
END;
-- exec
EXEC p9_v6;

-- 9.7. Cho biết tên huấn luyện viên đang nắm giữ một vị trí
-- trong 1 câu lạc bộ mà chưa có số điện thoại
CREATE PROCEDURE p9_v7
AS
BEGIN
SELECT TENHLV
FROM HUANLUYENVIEN hlv,HLV_CLB
WHERE hlv.MAHLV = HLV_CLB.MAHLV
  AND HLV_CLB.VAITRO IS NOT NULL
  AND hlv.DIENTHOAI IS NULL
END;
-- exec
EXEC p9_v7;

-- 9.8. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện
-- tại bất kỳ một câu lạc bộ
CREATE PROCEDURE p9_v8
AS
BEGIN
SELECT TENHLV
FROM HUANLUYENVIEN hlv, HLV_CLB, QUOCGIA qg
WHERE hlv.MAHLV = HLV_CLB.MACLB
  AND hlv.MAQG = qg.MAQG
  AND qg.TENQG = N'Việt Nam'
  AND HLV_CLB.MACLB IS NULL
  AND HLV_CLB.VAITRO IS NULL
END;
-- exec
EXEC p9_v8;

-- 9.9. Cho biết kết quả các trận đấu đã diễn ra (MACLB1, MACLB2, NAM, VONG, SOBANTHANG, SOBANTHUA)
CREATE PROCEDURE p9_v9
AS
BEGIN
SELECT MACLB1, MACLB2, NAM, VONG,
       SUBSTRING(KETQUA, 1, CHARINDEX('-',KETQUA,1)-1) AS [Số bàn thắng của CLB1],
		   SUBSTRING(KETQUA, CHARINDEX('-',KETQUA,1)+1, LEN(KETQUA)) AS [Số bàn thua của CLB1]
FROM TRANDAU
END;
-- exec
EXEC p9_v9;

-- 9.10. Cho biết kết quả các trận đấu trên sân nhà (MACLB, NAM, VONG, SOBANTHANG, SOBANTHUA)
CREATE PROCEDURE p9_v10
AS
BEGIN
SELECT MACLB1 AS [MA CLB], NAM, VONG,
		   SUBSTRING(KETQUA, 1, CHARINDEX('-',KETQUA,1)-1) AS [SOBANTHANG],
		   SUBSTRING(KETQUA, CHARINDEX('-', KETQUA,1) + 1, LEN(KETQUA)) AS [SOBANTHUA]
FROM TRANDAU
END;
-- exec
EXEC p9_v10;

-- 9.11. Cho biết kết quả các trận đấu trên sân khách (MACLB, NAM, VONG, SOBANTHANG, SOBANTHUA)
CREATE PROCEDURE p9_v11
AS
BEGIN
SELECT MACLB2 AS [MA CLB], NAM, VONG,
		   SUBSTRING(KETQUA, CHARINDEX('-',KETQUA,1) + 1, LEN(KETQUA)) AS [SOBANTHANG],
	       SUBSTRING(KETQUA, 1, CHARINDEX('-',KETQUA,1)-1) AS [SOBANTHUA]
FROM TRANDAU
END;
-- exec
EXEC p9_v11;

-- 9.12. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA)
-- của câu lạc bộ CLB đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009
CREATE PROCEDURE p9_v12
AS
BEGIN
SELECT NGAYTD, TENSAN, clb1.TENCLB AS [TENCLB1], clb2.TENCLB AS [TENCLB2], KETQUA
FROM TRANDAU td INNER JOIN SANVD svd ON td.MASAN = svd.MASAN
                INNER JOIN CAULACBO clb1 ON td.MACLB1 = clb1.MACLB
                INNER JOIN CAULACBO clb2 ON td.MACLB2 = clb2.MACLB
WHERE td.MACLB1 = (SELECT TOP 1 MACLB FROM BANGXH
                   ORDER BY DIEM DESC)
   OR td.MACLB2 = (SELECT TOP 1 MACLB FROM BANGXH
                   ORDER BY DIEM DESC)
END;
-- exec
EXEC p9_v12;

-- 9.13. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA)
-- của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009
CREATE PROCEDURE p9_v13
AS
BEGIN
SELECT NGAYTD, TENSAN, clb1.TENCLB AS [TENCLB1], clb2.TENCLB AS [TENCLB2], KETQUA
FROM TRANDAU td INNER JOIN SANVD svd ON td.MASAN = svd.MASAN
                INNER JOIN CAULACBO clb1 ON td.MACLB1 = clb1.MACLB
                INNER JOIN CAULACBO clb2 ON td.MACLB2 = clb2.MACLB
WHERE td.MACLB1 = (SELECT TOP 1 MACLB FROM BANGXH
                   ORDER BY DIEM)
   OR td.MACLB2 = (SELECT TOP 1 MACLB FROM BANGXH
                   ORDER BY DIEM)
END;
-- exec
EXEC p9_V13;



-- 10. Ứng với mỗi bảng trong CSDL Quản lý bóng đá, bạn hãy viết 4 Stored
-- Procedure ứng với 4 công việc Insert/Update/Delete/Select. Trong đó
-- Stored Procedure Update và Delete lấy khóa chính làm tham số

/* Bảng QUOCGIA */
-- QUOCGIA_INSERT
CREATE PROCEDURE p10_QUOCGIA_INSERT
    @maqg VARCHAR(5), @tenqg NVARCHAR(60)
AS
BEGIN
INSERT INTO QUOCGIA(MAQG, TENQG)
VALUES (@maqg, @tenqg)
END;
-- exec
SELECT * FROM QUOCGIA;
EXEC p10_QUOCGIA_INSERT 'CHN', N'China';
SELECT * FROM QUOCGIA;

-- QUOCGIA_UPDATE
CREATE PROCEDURE p10_QUOCGIA_UPDATE
    @maqg VARCHAR(5), @tenqg NVARCHAR(60)
AS
BEGIN
UPDATE QUOCGIA
SET TENQG = @tenqg
WHERE MAQG = @maqg
END;
-- exec
SELECT * FROM QUOCGIA;
EXEC p10_QUOCGIA_UPDATE 'CHN', N'Trung Quốc';
SELECT * FROM QUOCGIA;

-- QUOCGIA_DELETE
CREATE PROCEDURE p10_QUOCGIA_DELETE
    @maqg VARCHAR(5)
AS
BEGIN
DELETE QUOCGIA
WHERE MAQG = @maqg
END;
-- exec
SELECT * FROM QUOCGIA;
EXEC p10_QUOCGIA_DELETE 'CHN';
SELECT * FROM QUOCGIA;

-- QUOCGIA_SELECT
CREATE PROCEDURE p10_QUOCGIA_SELECT
AS
BEGIN
SELECT * FROM QUOCGIA
END;
-- exec
EXEC p10_QUOCGIA_SELECT;


/* Bảng TINH */
-- TINH_INSERT
CREATE PROCEDURE p10_TINH_INSERT
    @matinh VARCHAR(5), @tentinh NVARCHAR(100)
AS
BEGIN
INSERT INTO TINH(MATINH, TENTINH)
VALUES (@matinh, @tentinh)
END;
-- exec
SELECT * FROM TINH;
EXEC p10_TINH_INSERT 'LC', N'Cam Đường';
SELECT * FROM TINH;

-- TINH_UPDATE
CREATE PROCEDURE p10_TINH_UPDATE
    @matinh VARCHAR(5), @tentinh NVARCHAR(100)
AS
BEGIN
UPDATE TINH
SET TENTINH = @tentinh
WHERE MATINH = @matinh
END;
-- exec
SELECT * FROM TINH;
EXEC p10_TINH_UPDATE 'LC', N'Lào Cai';
SELECT * FROM TINH;

-- TINH_DELETE
CREATE PROCEDURE p10_TINH_DELETE
    @matinh VARCHAR(5)
AS
BEGIN
DELETE TINH
WHERE MATINH = @matinh
END;
-- exec
SELECT * FROM TINH;
EXEC p10_TINH_DELETE 'LC';
SELECT * FROM TINH;

-- TINH_SELECT
CREATE PROCEDURE p10_TINH_SELECT
AS
BEGIN
SELECT * FROM TINH
END;
-- exec
EXEC p10_TINH_SELECT;


/* Bảng SANVD */
-- SANVD_INSERT
CREATE PROCEDURE p10_SANVD_INSERT
    @masan VARCHAR(5), @tensan NVARCHAR(100), @diachi NVARCHAR(200)
AS
BEGIN
INSERT INTO SANVD(MASAN, TENSAN, DIACHI)
VALUES (@masan, @tensan, @diachi)
END;
-- exec
SELECT * FROM SANVD;
EXEC p10_SANVD_INSERT 'BK', N'Bách Khoa', N'Tạ Quang Bửu, quận Hai Bà Trưng, TP. Hà Nội';
SELECT * FROM SANVD;

-- SANVD_UPDATE
CREATE PROCEDURE p10_SANVD_UPDATE
    @masan VARCHAR(5), @tensan NVARCHAR(100), @diachi NVARCHAR(200)
AS
BEGIN
UPDATE SANVD
SET TENSAN = @tensan, DIACHI = @diachi
WHERE MASAN = @masan
END;
-- exec
SELECT * FROM SANVD;
EXEC p10_SANVD_UPDATE 'BK', N'Đại học Bách Khoa', N'Trần Đại Nghĩa, quận Hai Bà Trưng, TP. Hà Nội';
SELECT * FROM SANVD;

-- SANVD_DELETE
CREATE PROCEDURE p10_SANVD_DELETE
    @masan VARCHAR(5)
AS
BEGIN
DELETE SANVD
WHERE MASAN = @masan
END;
-- exec
SELECT * FROM SANVD;
EXEC p10_SANVD_DELETE 'BK';
SELECT * FROM SANVD;

-- SANVD_SELECT
CREATE PROCEDURE p10_SANVD_SELECT
AS
BEGIN
SELECT * FROM SANVD
END;
-- exec
EXEC p10_SANVD_SELECT;


/* Bảng HUANLUYENVIEN */
-- HUANLUYENVIEN_INSERT
CREATE PROCEDURE p10_HUANLUYENVIEN_INSERT
    @mahlv VARCHAR(5),
    @tenhlv NVARCHAR(100),
    @ngaysinh DATETIME,
    @diachi NVARCHAR(200),
    @dienthoai NVARCHAR(20),
    @maqg VARCHAR(5)
AS
BEGIN
INSERT INTO HUANLUYENVIEN(MAHLV, TENHLV, NGAYSINH, DIACHI, DIENTHOAI, MAQG)
VALUES (@mahlv, @tenhlv, @ngaysinh, @diachi, @dienthoai, @maqg)
END;
-- exec
SELECT * FROM HUANLUYENVIEN;
EXEC p10_HUANLUYENVIEN_INSERT HLV07, N'Phạm Quang Khánh', '29-05-2004', NULL, '0836999389', 'VN';
SELECT * FROM HUANLUYENVIEN;

-- HUANLUYENVIEN_UPDATE
CREATE PROCEDURE p10_HUANLUYENVIEN_UPDATE
    @mahlv VARCHAR(5),
    @tenhlv NVARCHAR(100),
    @ngaysinh DATETIME,
    @diachi NVARCHAR(200),
    @dienthoai NVARCHAR(20),
    @maqg VARCHAR(5)
AS
BEGIN
UPDATE HUANLUYENVIEN
SET TENHLV = @tenhlv,
    NGAYSINH = @ngaysinh,
    DIACHI = @diachi,
    DIENTHOAI = @dienthoai,
    MAQG = @maqg
WHERE MAHLV = @mahlv
END;
-- exec
SELECT * FROM HUANLUYENVIEN;
EXEC p10_HUANLUYENVIEN_UPDATE HLV07, N'Phạm Đức Mạnh', '01-01-2004', NULL, '0123456789', 'VN';
SELECT * FROM HUANLUYENVIEN;

-- HUANLUYENVIEN_DELETE
CREATE PROCEDURE p10_HUANLUYENVIEN_DELETE
    @mahlv VARCHAR(5)
AS
BEGIN
DELETE HUANLUYENVIEN
WHERE MAHLV = @mahlv
END;
-- exec
SELECT * FROM HUANLUYENVIEN;
EXEC p10_HUANLUYENVIEN_DELETE HLV07;
SELECT * FROM HUANLUYENVIEN;

-- HUANLUYENVIEN_SELECT
CREATE PROCEDURE p10_HUANLUYENVIEN_SELECT
AS
BEGIN
SELECT * FROM HUANLUYENVIEN
END;
-- exec
EXEC p10_HUANLUYENVIEN_SELECT;


/* Bảng CAULACBO */
-- CAULACBO_INSERT
CREATE PROCEDURE p10_CAULACBO_INSERT
    @maclb VARCHAR(5),
    @tenclb NVARCHAR(100),
    @masan VARCHAR(5),
    @matinh VARCHAR(5)
AS
BEGIN
INSERT INTO CAULACBO(MACLB, TENCLB, MASAN, MATINH)
VALUES (@maclb, @tenclb, @masan, @matinh)
END;
-- exec
SELECT * FROM CAULACBO;
EXEC p10_CAULACBO_INSERT 'HALA', N'CLC HALA', 'LA', 'LA';
SELECT * FROM CAULACBO;

-- CAULACBO_UPDATE
CREATE PROCEDURE p10_CAULACBO_UPDATE
    @maclb VARCHAR(5),
    @tenclb NVARCHAR(100),
    @masan VARCHAR(5),
    @matinh VARCHAR(5)
AS
BEGIN
UPDATE CAULACBO
SET TENCLB = @tenclb,
    MASAN = @masan,
    MATINH = @matinh
WHERE MACLB = @maclb
END;
-- exec
SELECT * FROM CAULACBO;
EXEC p10_CAULACBO_UPDATE 'HALA', N'CLC HALA FC', 'LA', 'LA';
SELECT * FROM CAULACBO;

-- CAULACBO_DELETE
CREATE PROCEDURE p10_CAULACBO_DELETE
    @maclb VARCHAR(5)
AS
BEGIN
DELETE CAULACBO
WHERE MACLB = @maclb
END;
-- exec
SELECT * FROM CAULACBO;
EXEC p10_CAULACBO_DELETE 'HALA';
SELECT * FROM CAULACBO;

-- CAULACBO_SELECT
CREATE PROCEDURE p10_CAULACBO_SELECT
AS
BEGIN
SELECT * FROM CAULACBO
END;
-- exec
EXEC p10_CAULACBO_SELECT;


/* Bảng HLV_CLB */
-- HLV_CLB_INSERT
CREATE PROCEDURE p10_HLV_CLB_INSERT
    @mahlv VARCHAR(5),
    @maclb VARCHAR(5),
    @vaitro NVARCHAR(100)
AS
BEGIN
INSERT INTO HLV_CLB
VALUES (@mahlv, @maclb, @vaitro)
END;
-- exec
SELECT * FROM HLV_CLB;
EXEC p10_HLV_CLB_INSERT 'HLV07', 'HAGL', N'HLV tinh thần';
SELECT * FROM HLV_CLB;

-- HLV_CLB_UPDATE
CREATE PROCEDURE p10_HLV_CLB_UPDATE
    @mahlv VARCHAR(5),
    @maclb VARCHAR(5),
    @vaitro NVARCHAR(100)
AS
BEGIN
UPDATE HLV_CLB
SET VAITRO = @vaitro
WHERE MAHLV = @mahlv AND MACLB = @maclb
END;
-- exec
SELECT * FROM HLV_CLB;
EXEC p10_HLV_CLB_UPDATE 'HLV07', 'HAGL', N'HLV tâm lý';
SELECT * FROM HLV_CLB;

-- HLV_CLB_DELETE
CREATE PROCEDURE p10_HLV_CLB_DELETE
    @mahlv VARCHAR(5),
    @maclb VARCHAR(5)
AS
BEGIN
DELETE HLV_CLB
WHERE MAHLV = @mahlv AND MACLB = @maclb
END;
-- exec
SELECT * FROM HLV_CLB;
EXEC p10_HLV_CLB_DELETE 'HLV07', 'HAGL';
SELECT * FROM HLV_CLB;

-- HLV_CLB_SELECT
CREATE PROCEDURE p10_HLV_CLB_SELECT
AS
BEGIN
SELECT * FROM HLV_CLB
END;
-- exec
EXEC p10_CAULACBO_SELECT;


/* Bảng CAUTHU */
-- CAUTHU_INSERT
CREATE PROCEDURE p10_CAUTHU_INSERT
    -- MACT tăng tự động: MACT NUMERIC IDENTITY(1,1)
    @hoten NVARCHAR(100),
    @vitri NVARCHAR(20),
    @ngaysinh DATETIME,
    @diachi NVARCHAR(200),
    @maclb VARCHAR(5),
    @maqg VARCHAR(5),
    @so INT
AS
BEGIN
INSERT INTO CAUTHU(HOTEN, VITRI, NGAYSINH, DIACHI, MACLB, MAQG, SO)
VALUES (@hoten, @vitri, @ngaysinh, @diachi, @maclb, @maqg, @so)
END;
-- exec
SELECT * FROM CAUTHU;
EXEC p10_CAUTHU_INSERT N'Ph', N'Trung vệ', '04-17-2002', NULL, 'GDT', 'VN', 5;
SELECT * FROM CAUTHU;

-- CAUTHU_UPDATE
CREATE PROCEDURE p10_CAUTHU_UPDATE
    @mact NUMERIC,
    @hoten NVARCHAR(100),
    @vitri NVARCHAR(20),
    @ngaysinh DATETIME,
    @diachi NVARCHAR(200),
    @maclb VARCHAR(5),
    @maqg VARCHAR(5),
    @so INT
AS
BEGIN
UPDATE CAUTHU
SET HOTEN = @hoten,
    VITRI = @vitri,
    NGAYSINH = @ngaysinh,
    DIACHI = @diachi,
    MACLB = @maclb,
    MAQG = @maqg,
    SO = @so
WHERE MACT = @mact
END;
-- exec
SELECT * FROM CAUTHU;
EXEC p10_CAUTHU_UPDATE 12, N'Ngô Trung Hiếu', N'Hậu vệ', '07-09-2002', NULL, 'HAGL', 'VN', 6;
SELECT * FROM CAUTHU;

-- CAUTHU_DELETE
CREATE PROCEDURE p10_CAUTHU_DELETE
    @mact NUMERIC
AS
BEGIN
DELETE CAUTHU
WHERE MACT = @mact
END;
-- exec
SELECT * FROM CAUTHU;
EXEC p10_CAUTHU_DELETE 12;
SELECT * FROM CAUTHU;

-- CAUTHU_SELECT
CREATE PROCEDURE p10_CAUTHU_SELECT
AS
BEGIN
SELECT * FROM CAUTHU
END;
-- exec
EXEC p10_CAUTHU_SELECT;


/* Bảng TRANDAU */
-- TRANDAU_INSERT
CREATE PROCEDURE p10_TRANDAU_INSERT
    -- MATRAN tăng tự động: MATRAN NUMERIC IDENTITY(1,1)
    @nam INT,
    @vong INT,
    @ngaytd DATETIME,
    @maclb1 VARCHAR(5),
    @maclb2 VARCHAR(5),
    @masan VARCHAR(5),
    @ketqua VARCHAR(5)
AS
BEGIN
INSERT INTO TRANDAU(NAM, VONG, NGAYTD, MACLB1, MACLB2, MASAN, KETQUA)
VALUES (@nam, @vong, @ngaytd, @maclb1, @maclb2, @masan, @ketqua)
END;
-- exec
SELECT * FROM TRANDAU;
EXEC p10_TRANDAU_INSERT 2009, 5, '03-10-2009', 'SDN', 'HAGL', 'TH', '2-0';
SELECT * FROM TRANDAU;

-- TRANDAU_UPDATE
CREATE PROCEDURE p10_TRANDAU_UPDATE
    @matran NUMERIC,
    @nam INT,
    @vong INT,
    @ngaytd DATETIME,
    @maclb1 VARCHAR(5),
    @maclb2 VARCHAR(5),
    @masan VARCHAR(5),
    @ketqua VARCHAR(5)
AS
BEGIN
UPDATE TRANDAU
SET NAM = @nam,
    VONG = @vong,
    NGAYTD = @ngaytd,
    MACLB1 = @maclb1,
    MACLB2 = @maclb2,
    MASAN = @masan,
    KETQUA = @ketqua
WHERE MATRAN = @matran
END;
-- exec
SELECT * FROM TRANDAU;
EXEC p10_TRANDAU_UPDATE 9, 2009, 5, '03-15-2009', 'KKH', 'BBD', 'CL', '3-1';
SELECT * FROM TRANDAU;

-- TRANDAU_DELETE
CREATE PROCEDURE p10_TRANDAU_DELETE
    @matran NUMERIC
AS
BEGIN
DELETE TRANDAU
WHERE MATRAN = @matran
END;
-- exec
SELECT * FROM TRANDAU;
EXEC p10_TRANDAU_DELETE 9;
SELECT * FROM TRANDAU;

-- TRANDAU_SELECT
CREATE PROCEDURE p10_TRANDAU_SELECT
AS
BEGIN
SELECT * FROM TRANDAU;
END;
-- exec
EXEC p10_TRANDAU_SELECT;


/* Bảng BANGXH */
-- BANGXH_INSERT
CREATE PROCEDURE p10_BANGXH_INSERT
    @maclb VARCHAR(5),
    @nam INT,
    @vong INT,
    @sotran INT,
    @thang INT,
    @hoa INT,
    @thua INT,
    @hieuso VARCHAR(5),
    @diem INT,
    @hang INT
AS
BEGIN
INSERT INTO BANGXH(MACLB, NAM, VONG, SOTRAN, THANG, HOA, THUA, HIEUSO, DIEM, HANG)
VALUES (@maclb, @nam, @vong, @sotran, @thang, @hoa, @thua, @hieuso, @diem, @hang)
END;
-- exec
SELECT * FROM BANGXH;
EXEC p10_BANGXH_INSERT 'BBD', 2009, 5, 3, 2, 1, 1, '5-4', 2, 5;
SELECT * FROM BANGXH;

-- BANGXH_UPDATE
CREATE PROCEDURE p10_BANGXH_UPDATE
    @maclb VARCHAR(5),
    @nam INT,
    @vong INT,
    @sotran INT,
    @thang INT,
    @hoa INT,
    @thua INT,
    @hieuso VARCHAR(5),
    @diem INT,
    @hang INT
AS
BEGIN
UPDATE BANGXH
SET SOTRAN = @sotran,
    THANG = @thang,
    HOA = @hoa,
    THUA = @thua,
    HIEUSO = @hieuso,
    DIEM = @diem,
    HANG = @hang
WHERE MACLB = @maclb AND NAM = @nam AND VONG = @vong
END;
-- exec
SELECT * FROM BANGXH;
EXEC p10_BANGXH_UPDATE 'BBD', 2009, 5, 4, 1, 1, 2, '6-3', 1, 7;
SELECT * FROM BANGXH;

-- BANGXH_DELETE
CREATE PROCEDURE p10_BANGXH_DELETE
    @maclb VARCHAR(5),
    @nam INT,
    @vong INT
AS
BEGIN
DELETE BANGXH
WHERE MACLB = @maclb AND NAM = @nam AND VONG = @vong
END;
-- exec
SELECT * FROM BANGXH;
EXEC p10_BANGXH_DELETE 'BBD', 2009, 5;
SELECT * FROM BANGXH;

-- BANGXH_SELECT
CREATE PROCEDURE p10_BANGXH_SELECT
AS
BEGIN
SELECT * FROM BANGXH
END;
-- exec
EXEC p10_BANGXH_SELECT;




-- b. Bài tập về Trigger
-- Viết các trigger có nội dung như sau:
-- 1. Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cần thủ chỉ thuộc một
-- trong các vị trí sau: Thủ môn, Tiền đạo, Tiền vệ, Trung vệ, Hậu vệ
CREATE TRIGGER trg1 ON CAUTHU
    FOR INSERT
    AS
BEGIN
DECLARE @vitri NVARCHAR(20)
SELECT @vitri = VITRI FROM inserted

IF @vitri IN (N'Thủ môn', N'Tiền đạo', N'Tiền vệ', N'Trung vệ', N'Hậu vệ')
BEGIN
PRINT N'Thêm cầu thủ mới thành công'
END
    ELSE
ROLLBACK TRANSACTION
END;
-- exec
SELECT * FROM CAUTHU;
INSERT INTO CAUTHU(HOTEN, VITRI, NGAYSINH, DIACHI, MACLB, MAQG, SO)
VALUES (N'Phạm Quang Khánh', N'Thủ Môn', '29-05-2004', NULL, 'HALA', 'VN', 29);
SELECT * FROM CAUTHU;

-- 2. Khi thêm cầu thủ mới, kiểm tra số áo của cầu thủ thuộc cùng một câu lạc bộ phải khác nhau
CREATE TRIGGER trg2 ON CAUTHU
    FOR INSERT
    AS
BEGIN
DECLARE @maclb VARCHAR(5), @so INT
SELECT @maclb = MACLB, @so = SO FROM inserted

IF (SELECT COUNT(*) FROM CAUTHU WHERE MACLB = @maclb AND SO = @so) > 1 -- đã tồn tại cầu thủ
ROLLBACK TRANSACTION
    ELSE
BEGIN
PRINT N'Thêm cầu thủ mới thành công'
END
END;
-- exec
SELECT * FROM CAUTHU;
INSERT INTO CAUTHU(HOTEN, VITRI, NGAYSINH, DIACHI, MACLB, MAQG, SO)
VALUES (N'Phạm Quang Khánh', N'Thủ Môn', '29-05-2004', NULL, 'HALA', 'VN', 29);
SELECT * FROM CAUTHU;

-- 3. Khi thêm thông tin cầu thủ thì in ra câu thông báo bằng Tiếng Việt ‘Đã thêm cầu thủ mới’
CREATE TRIGGER trg3 ON CAUTHU
    FOR INSERT
    AS
BEGIN
PRINT N'Đã thêm cầu thủ mới'
END;
-- exec
SELECT * FROM CAUTHU;
INSERT INTO CAUTHU(HOTEN, VITRI, NGAYSINH, DIACHI, MACLB, MAQG, SO)
VALUES (N'Phạm Quang Khánh', N'Thủ Môn', '29-05-2004', NULL, 'HALA', 'VN', 29);
SELECT * FROM CAUTHU;

-- 4. Khi thêm cầu thủ mới, kiểm tra số lượng cầu thủ nước ngoài ở mỗi câu lạc
-- bộ chỉ được phép đăng ký tối đa 8 cầu thủ
CREATE TRIGGER trg4 ON CAUTHU
    FOR INSERT
    AS
BEGIN
DECLARE @maclb VARCHAR(5), @maqg VARCHAR(5)
SELECT @maclb = MACLB, @maqg = MAQG FROM inserted

IF (SELECT COUNT(*) FROM CAUTHU WHERE MACLB = @maclb AND MAQG <> 'VN' GROUP BY MACLB) <= 8
BEGIN
PRINT N'Thêm cầu thủ mới thành công'
END
    ELSE
ROLLBACK TRANSACTION
END;
-- exec
SELECT * FROM CAUTHU;
INSERT INTO CAUTHU(HOTEN, VITRI, NGAYSINH, DIACHI, MACLB, MAQG, SO)
VALUES (N'Phạm Quang Khánh', N'Thủ Môn', '29-05-2004', NULL, 'HALA', 'VN', 29);
SELECT * FROM CAUTHU;

-- 5. Khi thêm tên quốc gia, kiểm tra tên quốc gia không được trùng với tên quốc gia đã có
CREATE TRIGGER trg5 ON QUOCGIA
    FOR INSERT
    AS
BEGIN
DECLARE @tenqg NVARCHAR(60)
SELECT @tenqg = TENQG FROM inserted

IF (SELECT COUNT(*) FROM QUOCGIA WHERE TENQG = @tenqg) > 1
ROLLBACK TRANSACTION
    ELSE
BEGIN
PRINT N'Thêm quốc gia mới thành công'
END
END;
-- exec
SELECT * FROM QUOCGIA;
INSERT INTO QUOCGIA(MAQG, TENQG)
VALUES ('CHN', N'Trung Quốc');
SELECT * FROM QUOCGIA;

-- 6. Khi thêm tên tỉnh thành, kiểm tra tên tỉnh thành không được trùng với tên tỉnh thành đã có
CREATE TRIGGER trg6 ON TINH
    FOR INSERT
    AS
BEGIN
DECLARE @tentinh NVARCHAR(100)
SELECT @tentinh = TENTINH FROM inserted

IF (SELECT COUNT(*) FROM TINH WHERE TENTINH = @tentinh) > 1
ROLLBACK TRANSACTION
    ELSE
BEGIN
PRINT N'Thêm tỉnh mới thành công'
END
END;
-- exec
SELECT * FROM TINH;
INSERT INTO TINH(MATINH, TENTINH)
VALUES ('LC', N'Lào Cai');
SELECT * FROM TINH;

-- 7. Không cho sửa kết quả của các trận đã diễn ra
CREATE TRIGGER trg7 ON TRANDAU
    FOR UPDATE
    AS
BEGIN
    IF UPDATE(KETQUA)
        BEGIN
            PRINT N'Không được phép sửa kết quả của các trận đã diễn ra'
            ROLLBACK TRANSACTION
        END
END;
-- exec
SELECT * FROM TRANDAU;
UPDATE TRANDAU SET KETQUA = '2-1' WHERE MATRAN = 1;
SELECT * FROM TRANDAU;

-- 8. Khi phân công huấn luyện viên cho câu lạc bộ:
-- 8a. Kiểm tra vai trò của huấn luyện viên chỉ thuộc một trong các vai trò sau: HLV chính, HLV phụ, HLV thể lực, HLV thủ môn
CREATE TRIGGER trg8a ON HLV_CLB
    FOR INSERT
    AS
BEGIN
DECLARE @vaitro NVARCHAR(100)
SELECT @vaitro = VAITRO FROM inserted

IF @vaitro IN (N'HLV Chính', N'HLV phụ', N'HLV thể lực', N'HLV thủ môn')
BEGIN
PRINT N'Phân công vai trò huấn luyện viên thành công'
END
    ELSE
ROLLBACK TRANSACTION
END;
-- exec
SELECT * FROM HLV_CLB;
INSERT INTO HLV_CLB(MAHLV, MACLB, VAITRO)
VALUES ('HLV01', 'BBD', N'HLV thủ môn');
SELECT * FROM HLV_CLB;

-- 8b. Kiểm tra mỗi câu lạc bộ chỉ có tối đa 2 HLV chính
CREATE TRIGGER trg8b ON HLV_CLB
    FOR INSERT
    AS
BEGIN
DECLARE @maclb VARCHAR(5)
SELECT @maclb = MACLB FROM inserted

IF (SELECT COUNT(*) FROM HLV_CLB WHERE MACLB = @maclb AND VAITRO = N'HLV Chính' GROUP BY MACLB) <= 2
BEGIN
PRINT N'Phân công vai trò huấn luyện viên thành công'
END
    ELSE
ROLLBACK TRANSACTION
END;
SELECT * FROM HLV_CLB;
INSERT INTO HLV_CLB(MAHLV, MACLB, VAITRO)
VALUES ('HLV02', 'BBD', N'HLV Chính');
SELECT * FROM HLV_CLB;

-- 9. Khi thêm mới một câu lạc bộ thì kiểm tra xem đã có câu lạc bộ trùng tên
-- với câu lạc bộ vừa được thêm hay không?
-- 9c. chỉ thông báo vẫn cho insert
CREATE TRIGGER trg9c ON CAULACBO
    FOR INSERT
    AS
BEGIN
    DECLARE @tenclb NVARCHAR(100)
    SELECT @tenclb = TENCLB FROM inserted
    IF (SELECT COUNT(*) FROM CAULACBO WHERE TENCLB = @tenclb) > 1
        BEGIN
            PRINT N'Đã tồn tại câu lạc bộ với tên này'
        END
END;
-- exec
SELECT * FROM CAULACBO;
INSERT INTO CAULACBO(MACLB, TENCLB, MASAN, MATINH)
VALUES ('GDT', N'GẠCH ĐỒNG TÂM LONG AN', 'LA', 'LA');
SELECT * FROM CAULACBO;

-- 9d. thông báo và không cho insert
CREATE TRIGGER trg9d ON CAULACBO
    FOR INSERT
    AS
BEGIN
    DECLARE @tenclb NVARCHAR(100)
    SELECT @tenclb = TENCLB FROM inserted
    IF (SELECT COUNT(*) FROM CAULACBO WHERE TENCLB = @tenclb) > 1
        BEGIN
            PRINT N'Đã tồn tại câu lạc bộ với tên này'
            ROLLBACK TRANSACTION
        END
END;
-- exec
SELECT * FROM CAULACBO;
INSERT INTO CAULACBO(MACLB, TENCLB, MASAN, MATINH)
VALUES ('GDT', N'GẠCH ĐỒNG TÂM LONG AN', 'LA', 'LA');
SELECT * FROM CAULACBO;

-- 10. Khi sửa tên cầu thủ cho một (hoặc nhiều) cầu thủ thì in ra:
-- 10e. danh sách mã cầu thủ của các cầu thủ vừa được sửa
CREATE TRIGGER trg10e ON CAUTHU
    FOR UPDATE
    AS
BEGIN
    IF UPDATE(HOTEN)
        BEGIN
            DECLARE @updatedIDs NVARCHAR(MAX)
            SELECT @updatedIDs = COALESCE(@updatedIDs + ', ', '') + CAST(MACT AS NVARCHAR)
            FROM inserted
            PRINT N'Danh sách mã cầu thủ vừa được sửa: ' + @updatedIDs
    END
END;
-- exec
SELECT * FROM CAUTHU;
UPDATE CAUTHU SET HOTEN = N'Nguyễn Vũ Phin' WHERE MACT = 7;
SELECT * FROM CAUTHU;

-- 10f. danh sách mã cầu thủ vừa được sửa và tên cầu thủ mới
CREATE TRIGGER trg10f ON CAUTHU
    FOR UPDATE
    AS
BEGIN
    IF UPDATE(HOTEN)
        BEGIN
            DECLARE @updatedInfo NVARCHAR(MAX)
            SELECT @updatedInfo = COALESCE(@updatedInfo + '; ', '') + CAST(MACT AS NVARCHAR) + N': ' + HOTEN
            FROM inserted
            PRINT N'Danh sách mã cầu thủ và tên cầu thủ mới: ' + @updatedInfo
        END
END;
-- exec
SELECT * FROM CAUTHU;
UPDATE CAUTHU SET HOTEN = N'Nguyễn Vũ Phóng' WHERE MACT = 7;
SELECT * FROM CAUTHU;