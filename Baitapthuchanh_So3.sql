
-- a. Xử lý chuỗi, ngày giờ
-- 1. Cho biết NGAYTD, TENCLB1, TENCLB2, KETQUA các trận đấu diễn ra vào
-- tháng 3 trên sân nhà mà không bị thủng lưới
SELECT NGAYTD, clb1.TENCLB AS [TENCLB1], clb2.TENCLB AS [TENCLB2], KETQUA
FROM TRANDAU td INNER JOIN CAULACBO clb1 ON td.MACLB1 = clb1.MACLB
                INNER JOIN CAULACBO clb2 ON td.MACLB2 = clb2.MACLB
WHERE MONTH(NGAYTD) = 3
    AND (td.MASAN = clb1.MASAN AND SUBSTRING(KETQUA, 1, 1) = 0 )
   OR (td.MASAN = clb2.MASAN AND SUBSTRING(KETQUA, 3, 1) = 0);

-- 2. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ lót là “Công”
SELECT MACT, HOTEN, NGAYSINH
FROM CAUTHU
WHERE HOTEN LIKE N'%_Công_%';

-- 3. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ không phải là họ "Nguyễn"
SELECT MACT, HOTEN, NGAYSINH
FROM CAUTHU
WHERE HOTEN NOT LIKE N'Nguyễn%';

-- 4. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ
-- của những huấn luyện viên Việt Nam có tuổi nằm trong khoảng 35-40
SELECT MAHLV, TENHLV, NGAYSINH, DIACHI
FROM HUANLUYENVIEN hlv, QUOCGIA	qg
WHERE hlv.MAQG = qg.MAQG
  AND TENQG = N'Việt Nam'
  AND DATEPART(YEAR, GETDATE()) - DATEPART(YEAR, NGAYSINH) BETWEEN 35 AND 40;

-- 5. Cho biết tên câu lạc bộ có huấn luyện viên trưởng sinh vào ngày 20 tháng 8 năm 2019
SELECT TENCLB
FROM CAULACBO clb, HUANLUYENVIEN hlv, HLV_CLB
WHERE clb.MACLB = HLV_CLB.MACLB
  AND HLV_CLB.MAHLV = hlv.MAHLV
  AND VAITRO = N'HLV Chính'
  AND MONTH(NGAYSINH) = 8 AND DAY(NGAYSINH) = 20 AND YEAR(NGAYSINH) = 2019;

-- 6. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng
-- có số bàn thắng nhiều nhất tính đến hết vòng 3 năm 2009
SELECT TENCLB, TENTINH
FROM CAULACBO clb INNER JOIN TINH ON clb.MATINH = TINH.MATINH
                  INNER JOIN BANGXH bxh ON clb.MACLB = bxh.MACLB
WHERE bxh.HIEUSO = (SELECT TOP 1 HIEUSO FROM BANGXH
                    WHERE BANGXH.NAM = 2009 AND BANGXH.VONG = 3
                    ORDER BY (CONVERT(INT, SUBSTRING(HIEUSO, 1, 1))) DESC);



-- b. Truy vấn con
-- 1. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ
-- và số lượng cầu thủ nước ngoài (Có quốc tịch khác “Việt Nam”)
-- tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài
SELECT clb.MACLB, TENCLB, TENSAN, svd.DIACHI, COUNT(MACT) AS [Số lượng cầu thủ nước ngoài]
FROM CAULACBO clb, SANVD svd, CAUTHU ct, QUOCGIA qg
WHERE clb.MASAN = svd.MASAN
  AND clb.MACLB = ct.MACLB
  AND ct.MAQG = qg.MAQG
  AND TENQG <> N'Việt Nam'
GROUP BY clb.MACLB, TENCLB, TENSAN, svd.DIACHI
HAVING COUNT(MACT) > 2;

-- 2. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có hiệu số bàn thắng bại cao nhất năm 2009
SELECT DISTINCT TENCLB, TENTINH
FROM CAULACBO clb INNER JOIN TINH ON clb.MATINH = TINH.MATINH
                  INNER JOIN BANGXH bxh ON clb.MACLB = bxh.MACLB
WHERE clb.MACLB = (SELECT TOP 1 MACLB FROM BANGXH WHERE NAM = 2009
                   ORDER BY (CONVERT(INT, SUBSTRING(HIEUSO, 1, 1)) - CONVERT(INT, SUBSTRING(HIEUSO, 3, 1))) DESC);

-- 3. Cho biết danh sách các trận đấu ( NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của
-- câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009
SELECT NGAYTD, TENSAN, clb1.TENCLB AS [TENCLB1], clb2.TENCLB AS [TENCLB2], KETQUA
FROM TRANDAU td, SANVD svd, CAULACBO clb1, CAULACBO clb2
WHERE td.MACLB1 = clb1.MACLB AND td.MACLB2 = clb2.MACLB
  AND td.MASAN = svd.MASAN
  AND (MACLB1 = (SELECT TOP 1 MACLB FROM BANGXH bxh WHERE VONG = 3 AND NAM = 2009 ORDER BY DIEM)
    OR MACLB2 = (SELECT TOP 1 MACLB FROM BANGXH bxh WHERE VONG = 3 AND NAM = 2009 ORDER BY DIEM)
    );

-- 4. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại
-- (kể cả sân nhà và sân khách) trong mùa giải năm 2009
SELECT DISTINCT MACLB, TENCLB
FROM CAULACBO c
WHERE NOT EXISTS (SELECT MACLB FROM CAULACBO c1 WHERE c.MACLB <> c1.MACLB
                  EXCEPT ((SELECT MACLB1 FROM TRANDAU td1 WHERE c.MACLB = td1.MACLB2)
                          UNION (SELECT MACLB2 FROM TRANDAU td2 WHERE c.MACLB = td2.MACLB2))
);

-- 5. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại
-- (chỉ tính sân nhà) trong mùa giải năm 2009
SELECT DISTINCT MACLB1 AS [Mã câu lạc bộ], TENCLB AS [Tên câu lạc bộ]
FROM TRANDAU td1 INNER JOIN CAULACBO c ON td1.MACLB1 = c.MACLB
WHERE NOT EXISTS (SELECT MACLB FROM CAULACBO clb1
    EXCEPT ((SELECT MACLB2 FROM TRANDAU td2 WHERE td1.MACLB1 = td2.MACLB1)
    UNION (SELECT MACLB FROM CAULACBO clb2 WHERE MACLB = td1.MACLB1))
    );



-- c. Bài tập về Rule
-- 1. Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cầu thủ chỉ thuộc một trong
-- các vị trí sau: Thủ môn, tiền đạo, tiền vệ, trung vệ, hậu vệ
ALTER TABLE CAUTHU
    ADD CONSTRAINT CHK_VITRI CHECK(VITRI IN (N'Thủ môn', N'Tiền đạo', N'Tiền vệ', N'Trung vệ', N'Hậu vệ'));
GO

-- 2. Khi phân công huấn luyện viên, kiểm tra vai trò của huấn luyện viên chỉ thuộc một trong
-- các vai trò sau: HLV chính, HLV phụ, HLV thể lực, HLV thủ môn
ALTER TABLE HLV_CLB
    ADD CONSTRAINT CHK_VAITRO CHECK(VAITRO IN(N'HLV Chính', N'HLV phụ', N'HLV thể lực', N'HLV thủ môn'));
GO

-- 3. Khi thêm cầu thủ mới, kiểm tra cầu thủ đó có tuổi phải đủ 18 trở lên (chỉ tính năm sinh)
ALTER TABLE CAUTHU
    ADD CONSTRAINT CHK_TUOI CHECK(YEAR(GETDATE()) - YEAR(NGAYSINH) >= 18);
GO

-- 4. Kiểm tra kết quả trận đấu có dạng số_bàn_thắng - số_bàn_thua
ALTER TABLE TRANDAU
    ADD CONSTRAINT CHK_KETQUA CHECK(KETQUA LIKE '%-%');
GO



-- d. Bài tập về View
-- 1. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ
-- thuộc đội bóng “SHB Đà Nẵng” có quốc tịch “Bra-xin”
CREATE VIEW v1
AS
SELECT MACT, HOTEN, NGAYSINH, DIACHI, VITRI
FROM CAUTHU ct, CAULACBO clb, QUOCGIA qg
WHERE ct.MACLB = clb.MACLB AND TENCLB = N'SHB Đà Nẵng'
  AND ct.MAQG = qg.MAQG AND TENQG = N'Bra-xin';

SELECT * FROM v1;

-- 2. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận
-- đấu vòng 3 của mùa bóng năm 2009
CREATE VIEW v2
AS
SELECT MATRAN, NGAYTD, svd.TENSAN, clb1.TENCLB AS [TENCLB1], clb2.TENCLB AS [TENCLB2], KETQUA
FROM TRANDAU td, SANVD svd, CAULACBO clb1, CAULACBO clb2
WHERE clb1.MACLB = td.MACLB1 AND clb2.MACLB = td.MACLB2
  AND svd.MASAN = td.MASAN
  AND VONG = 3 and NAM = 2009;

SELECT * FROM v2;

-- 3. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc
-- của các huấn luyện viên có quốc tịch “Việt Nam”
CREATE VIEW v3
AS
SELECT hlv.MAHLV, TENHLV, NGAYSINH, DIACHI, VAITRO, TENCLB
FROM HUANLUYENVIEN hlv, HLV_CLB, CAULACBO clb, QUOCGIA qg
WHERE hlv.MAHLV = HLV_CLB.MAHLV
  AND HLV_CLB.MACLB = clb.MACLB
  AND hlv.MAQG = qg.MAQG AND TENQG = N'Việt Nam';

SELECT * FROM v3;

-- 4. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ
-- nước ngoài (có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ nhiều hơn
-- 2 cầu thủ nước ngoài
CREATE VIEW v4
AS
SELECT clb.MACLB, TENCLB, TENSAN, svd.DIACHI, COUNT(MACT) AS [Số lượng cầu thủ nước ngoài]
FROM CAULACBO clb, SANVD svd, CAUTHU ct, QUOCGIA qg
WHERE clb.MASAN = svd.MASAN
AND clb.MACLB = ct.MACLB
AND ct.MAQG = qg.MAQG
AND TENQG <> N'Việt Nam'
GROUP BY clb.MACLB, TENCLB, TENSAN, svd.DIACHI
HAVING COUNT(MACT) > 2;

SELECT * FROM v4;

-- 5. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc
-- bộ thuộc địa bàn tỉnh đó quản lý
CREATE VIEW v5
AS
SELECT TENTINH, COUNT(MACT) AS [Số lượng cầu thủ đang thi đấu ở vị trí tiền đạo]
FROM TINH, CAULACBO clb, CAUTHU ct
WHERE TINH.MATINH = clb.MATINH
AND clb.MACLB = ct.MACLB
AND VITRI = N'Tiền đạo'
GROUP BY TENTINH;

SELECT * FROM v5;

-- 6. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất
-- của bảng xếp hạng của vòng 3 năm 2009
CREATE VIEW v6
AS
SELECT TOP 1 TENCLB, TENTINH
FROM CAULACBO clb, TINH, BANGXH bxh
WHERE bxh.MACLB = clb.MACLB
  AND clb.MATINH = TINH.MATINH
  AND VONG = 3 AND NAM = 2009;

SELECT * FROM v6;

-- 7. Cho biết tên huấn luyện viên đang nắm giữ một vị trí
-- trong 1 câu lạc bộ mà chưa có số điện thoại
CREATE VIEW v7
AS
SELECT TENHLV
FROM HUANLUYENVIEN hlv,HLV_CLB
WHERE hlv.MAHLV = HLV_CLB.MAHLV
  AND HLV_CLB.VAITRO IS NOT NULL
  AND hlv.DIENTHOAI IS NULL;

SELECT * FROM v7;

-- 8. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện
-- tại bất kỳ một câu lạc bộ
CREATE VIEW v8
AS
SELECT TENHLV
FROM HUANLUYENVIEN hlv, HLV_CLB, QUOCGIA qg
WHERE hlv.MAHLV = HLV_CLB.MACLB
  AND hlv.MAQG = qg.MAQG
  AND qg.TENQG = N'Việt Nam'
  AND HLV_CLB.MACLB IS NULL
  AND HLV_CLB.VAITRO IS NULL;

SELECT * FROM v8;

-- 9. Cho biết kết quả các trận đấu đã diễn ra (MACLB1, MACLB2, NAM, VONG, SOBANTHANG, SOBANTHUA)
CREATE VIEW v9
AS
SELECT MACLB1, MACLB2, NAM, VONG,
       SUBSTRING(KETQUA, 1, CHARINDEX('-',KETQUA,1)-1) AS [Số bàn thắng của CLB1],
	   SUBSTRING(KETQUA, CHARINDEX('-',KETQUA,1)+1, LEN(KETQUA)) AS [Số bàn thua của CLB1]
FROM TRANDAU;

SELECT * FROM v9;

-- 10. Cho biết kết quả các trận đấu trên sân nhà (MACLB, NAM, VONG, SOBANTHANG, SOBANTHUA)
CREATE VIEW v10
AS
SELECT MACLB1 AS [MA CLB], NAM, VONG,
	   SUBSTRING(KETQUA, 1, CHARINDEX('-',KETQUA,1)-1) AS [SOBANTHANG],
	   SUBSTRING(KETQUA, CHARINDEX('-', KETQUA,1) + 1, LEN(KETQUA)) AS [SOBANTHUA]
FROM TRANDAU;

SELECT * FROM v10;

-- 11. Cho biết kết quả các trận đấu trên sân khách (MACLB, NAM, VONG, SOBANTHANG, SOBANTHUA)
CREATE VIEW v11
AS
SELECT MACLB2 AS [MA CLB], NAM, VONG,
	SUBSTRING(KETQUA, CHARINDEX('-',KETQUA,1) + 1, LEN(KETQUA)) AS [SOBANTHANG],
	   SUBSTRING(KETQUA, 1, CHARINDEX('-',KETQUA,1)-1) AS [SOBANTHUA]
FROM TRANDAU;

SELECT * FROM v11;

-- 12. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA)
-- của câu lạc bộ CLB đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009
CREATE VIEW v12
AS
SELECT NGAYTD, TENSAN, clb1.TENCLB AS [TENCLB1], clb2.TENCLB AS [TENCLB2], KETQUA
FROM TRANDAU td INNER JOIN SANVD svd ON td.MASAN = svd.MASAN
                INNER JOIN CAULACBO clb1 ON td.MACLB1 = clb1.MACLB
                INNER JOIN CAULACBO clb2 ON td.MACLB2 = clb2.MACLB
WHERE td.MACLB1 = (SELECT TOP 1 MACLB FROM BANGXH
                   ORDER BY DIEM DESC)
   OR td.MACLB2 = (SELECT TOP 1 MACLB FROM BANGXH
                   ORDER BY DIEM DESC);

SELECT * FROM v12;

-- 13. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA)
-- của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009
CREATE VIEW v13
AS
SELECT NGAYTD, TENSAN, clb1.TENCLB AS [TENCLB1], clb2.TENCLB AS [TENCLB2], KETQUA
FROM TRANDAU td INNER JOIN SANVD svd ON td.MASAN = svd.MASAN
                INNER JOIN CAULACBO clb1 ON td.MACLB1 = clb1.MACLB
                INNER JOIN CAULACBO clb2 ON td.MACLB2 = clb2.MACLB
WHERE td.MACLB1 = (SELECT TOP 1 MACLB FROM BANGXH
                   ORDER BY DIEM)
   OR td.MACLB2 = (SELECT TOP 1 MACLB FROM BANGXH
                   ORDER BY DIEM);

SELECT * FROM v13;
























