-- a. Truy vấn cơ bản
-- 1. Cho biết thông tin (mã cầu thủ, họ tên, số áo, vị trí, ngày sinh, địa chỉ) của tất cả các cầu thủ’.
SELECT mact, hoten, so, vitri, ngaysinh, diachi
FROM cauthu;

-- 2. Hiển thị thông tin tất cả các cầu thủ có số áo là 7 chơi ở vị trí Tiền vệ.
SELECT *
FROM cauthu
WHERE so = 7
  AND vitri = 'Tiền vệ';

-- 3. Cho biết tên, ngày sinh, địa chỉ, điện thoại của tất cả các huấn luyện viên.
SELECT tenhlv, ngaysinh, diachi, dienthoai
FROM huanluyenvien;

-- 4. Hiển thi thông tin tất cả các cầu thủ có quốc tịch Việt Nam thuộc câu lạc bộ Becamex Bình Dương.
SELECT ct.*
FROM cauthu ct,
     caulacbo clb,
     quocgia qg
WHERE ct.maclb = clb.maclb
  AND clb.maclb = 'BBD'
  AND ct.maqg = qg.maqg
  AND qg.maqg = 'VN';

-- 5. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng ‘SHB Đà Nẵng’ có quốc tịch
SELECT ct.mact, ct.hoten, ct.ngaysinh, ct.diachi, ct.vitri
FROM cauthu ct,
     caulacbo clb
WHERE ct.maclb = clb.maclb
  AND clb.maclb = 'SDN'
  AND ct.maqg NOTNULL;

-- 6. Hiển thị thông tin tất cả các cầu thủ đang thi đấu trong câu lạc bộ có sân nhà là “Long An”.
SELECT ct.*
FROM cauthu ct,
     caulacbo clb,
     sanvd svd
WHERE ct.maclb = clb.maclb
  AND clb.masan = svd.masan
  AND svd.masan = 'LA';

-- 7. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận đấu vòng 2 của mùa bóng năm 2009.
SELECT matran, ngaytd, tensan, clb1.tenclb clb1, clb2.tenclb clb2, ketqua
FROM trandau td,
     sanvd svd,
     caulacbo clb1,
     caulacbo clb2
WHERE td.masan = svd.masan
  AND td.maclb1 = clb1.maclb
  AND td.maclb2 = clb2.maclb
  AND td.vong = 2
  AND td.nam = 2009;

-- 8. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc của các huấn luyện viên có quốc tịch “Việt Nam”.
SELECT hlv_clb.mahlv, hlv.tenhlv, hlv.ngaysinh, hlv.diachi, hlv_clb.vaitro, clb.tenclb, quocgia qg
FROM huanluyenvien hlv,
     hlv_clb,
     caulacbo clb
WHERE hlv_clb.maclb = clb.maclb
  AND hlv_clb.mahlv = hlv.mahlv
  AND hlv.maqg = qg.maqg
  AND qg.maqg = 'VN';

-- 9. Lấy tên 3 câu lạc bộ có điểm cao nhất sau vòng 3 năm 2009.
SELECT clb.tenclb
FROM caulacbo clb,
     bangxh bxh
WHERE clb.maclb = bxh.maclb
  AND bxh.vong = 3
  AND bxh.nam = 2009
ORDER BY bxh.diem DESC
LIMIT 3;

-- 10. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc mà câu lạc bộ đó đóng ở tỉnh Binh Dương.
SELECT hlv.mahlv, hlv.tenhlv, hlv.ngaysinh, hlv.diachi, hlv_clb.vaitro, clb.tenclb
FROM huanluyenvien hlv,
     hlv_clb,
     caulacbo clb,
     tinh
WHERE hlv_clb.maclb = clb.maclb
  AND hlv_clb.mahlv = hlv.mahlv
  AND clb.matinh = tinh.matinh
  AND tinh.matinh = 'BD';

-- b. Các phép toán trên nhóm
-- 1. Thống kê số lượng cầu thủ của mỗi câu lạc bộ.
SELECT clb.tenclb, COUNT(ct.mact) AS soluongcauthu
FROM caulacbo clb,
     cauthu ct
WHERE clb.maclb = ct.maclb
GROUP BY clb.tenclb;

-- 2. Thống kê số lượng cầu thủ nước ngoài (có quốc tịch khác Việt Nam) của mỗi câu lạc bộ
SELECT clb.tenclb, COUNT(ct.mact) AS soluongcauthunuocngoai
FROM caulacbo clb,
     cauthu ct,
     quocgia qg
WHERE clb.maclb = ct.maclb
  AND ct.maqg = qg.maqg
  AND qg.maqg <> 'VN'
GROUP BY clb.tenclb;

-- 3. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu
-- thủ nước ngoài (có quốc tịch khác Việt Nam) tương ứng của các câu lạc bộ có nhiều
-- hơn 2 cầu thủ nước ngoài.
SELECT clb.maclb, clb.tenclb, svd.tensan, svd.diachi, COUNT(ct.mact) AS soluongcauthunuocngoai
FROM caulacbo clb,
     cauthu ct,
     sanvd svd,
     quocgia qg
WHERE clb.maclb = ct.maclb
  AND clb.masan = svd.masan
  AND ct.maqg = qg.maqg
  AND qg.maqg <> 'VN'
GROUP BY clb.maclb, clb.maclb, clb.tenclb, svd.tensan, svd.diachi
HAVING COUNT(ct.mact) > 2;

-- 4. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc
-- bộ thuộc địa bàn tỉnh đó quản lý.
SELECT tinh.tentinh, COUNT(ct.mact) AS soluongcauthu
FROM tinh,
     caulacbo clb,
     cauthu ct
WHERE tinh.matinh = clb.matinh
  AND clb.maclb = ct.maclb
  AND ct.vitri = 'Tiền đạo'
GROUP BY tinh.tentinh;

-- 5. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng
-- xếp hạng vòng 3, năm 2009.
SELECT clb.tenclb, tinh.tentinh
FROM caulacbo clb,
     tinh,
     bangxh bxh
WHERE clb.maclb = bxh.maclb
  AND clb.matinh = tinh.matinh
  AND bxh.vong = 3
  AND bxh.nam = 2009
ORDER BY bxh.hang
LIMIT 1;

-- c. Các toán tử nâng cao
-- 1. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ
-- mà chưa có số điện thoại.
SELECT hlv.tenhlv
FROM huanluyenvien hlv,
     hlv_clb
WHERE hlv.mahlv = hlv_clb.mahlv
  AND hlv.dienthoai ISNULL;

-- 2. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện
-- tại bất kỳ một câu lạc bộ nào.
-- Cách 1
SELECT DISTINCT hlv.tenhlv
FROM huanluyenvien hlv,
     hlv_clb,
     quocgia qg
WHERE hlv.maqg = qg.maqg
  AND qg.maqg = 'VN'
  AND hlv.mahlv NOT IN (SELECT mahlv FROM hlv_clb);

-- Cách 2
SELECT hlv.tenhlv
FROM huanluyenvien hlv
         LEFT JOIN quocgia qg ON hlv.maqg = qg.maqg
         LEFT JOIN hlv_clb ON hlv.mahlv = hlv_clb.mahlv
WHERE qg.maqg = 'VN'
  AND hlv_clb.mahlv IS NULL;

-- 3. Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ có thứ hạng ở vòng 3 năm 2009
-- lớn hơn 6 hoặc nhỏ hơn 3.
SELECT ct.*
FROM cauthu ct,
     caulacbo clb,
     bangxh bxh
WHERE ct.maclb = clb.maclb
  AND clb.maclb = bxh.maclb
  AND bxh.vong = 3
  AND bxh.nam = 2009
  AND (bxh.hang > 6 OR bxh.hang < 3);

-- 4. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA)
-- của câu lạc bộ (CLB) đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009.
SELECT td.ngaytd, svd.tensan, clb1.tenclb clb1, clb2.tenclb clb2, td.ketqua
FROM trandau td,
     caulacbo clb1,
     caulacbo clb2,
     sanvd svd
WHERE td.maclb1 = clb1.maclb
  AND td.maclb2 = clb2.maclb
  AND td.masan = svd.masan
  AND (
    clb1.maclb = (SELECT maclb FROM bangxh WHERE vong = 3 AND nam = 2009 AND hang = 1)
        OR
    clb2.maclb = (SELECT maclb FROM bangxh WHERE vong = 3 AND nam = 2009 AND hang = 1)
    );
