-- Quản lý bán hàng cho 1 công ty kinh doanh thiết bị máy tính
-- Tạo cơ sở dữ liệu
CREATE DATABASE GSHT;
GO

-- Sử dụng cơ sở dữ liệu
USE GSHT;
GO

-- Tạo bảng tài khoản
CREATE TABLE TaiKhoan
(
 sUserName VARCHAR(20) PRIMARY KEY,
 sPassWord VARCHAR(20) NOT NULL,
 sLevel VARCHAR(20) NOT NULL
);

GO

-- Tạo bảng thông tin tài xế
CREATE TABLE TaiXe
(
 MaRFID	 VARCHAR(20) PRIMARY KEY,
 TenTX NVARCHAR(20) NOT NULL,
 GioiTinh VARCHAR(10) NOT NULL,
 NgaySinh Datetime NOT NULL,
 DiaChi NVARCHAR(30) NOT NULL,
 DienThoai VARCHAR(12) NOT NULL
);
GO

--Tạo bảng thông tin xe
CREATE TABLE Xe
(
 BienSoXe VARCHAR(10) PRIMARY KEY,
 GiayPhep VARCHAR(20) NOT NULL,
 MaRFID	 VARCHAR(20) NOT NULL,
 sUserName VARCHAR(20) 
);
GO
--Tạo khóa phụ cho bảng thông tin xe
ALTER TABLE xe ADD CONSTRAINT FK_xe_taixe FOREIGN KEY (MaRFID) REFERENCES TaiXe (MaRFID),
CONSTRAINT FK_xe_taikhoan FOREIGN KEY (sUserName) REFERENCES TaiKhoan (sUserName);
GO

-- Tạo bảng định vị
CREATE TABLE DinhVi
(
 STT int PRIMARY KEY,
 Ngay Datetime NOT NULL,
 Gio VARCHAR(20) NOT NULL,
 Lat VARCHAR(20) NOT NULL,
 Long VARCHAR(20) NOT NULL,
 BienSoXe VARCHAR(10) NOT NULL
);
GO
--Tạo khóa phụ cho bảng định vị
ALTER TABLE DinhVi ADD CONSTRAINT FK_dinhvi_xe FOREIGN KEY (BienSoXe) REFERENCES Xe (BienSoXe);
GO

-- Truy vấn dữ liệu bảng tài khoản
-- Tạo View
CREATE VIEW v_TaiKhoan
AS
SELECT sUserName AS [UserName],
       sPassWord AS [PassWord],
	   sLevel AS [Level]
FROM TaiKhoan
GO

-- Tạo PROC tìm kiếm theo UserName
CREATE PROC PROC_SelectTK
@sUserName VARCHAR(20)
AS 
BEGIN
	SELECT * FROM TaiKhoan WHERE sUserName = @sUserName
END
GO

-- Tạo PROC thêm dữ liệu vào bảng Tài khoản
CREATE PROC PROC_InsertTK
@sUserName VARCHAR(20),
@sPassWord VARCHAR(20),
@sLevel VARCHAR(20)
AS
BEGIN
INSERT INTO TaiKhoan(sUserName, sPassWord, sLevel)
VALUES (@sUserName, @sPassWord, @sLevel)
END
GO

-- Tạo PROC sửa dữ liệu vào bảng tài khoản
CREATE PROC PROC_UpdateTK
@sUserName VARCHAR(20),
@sPassWord VARCHAR(20),
@sLevel VARCHAR(20)
AS
BEGIN
	UPDATE TaiKhoan
	SET sPassWord = @sPassWord, sLevel = @sLevel
	WHERE sUserName = @sUserName
END
GO

-- Tạo PROC xóa dữ liệu vào bảng tài khoản
CREATE PROC PROC_DeleteTK
@sUserName VARCHAR(20)
AS
BEGIN
	DELETE FROM TaiKhoan
	WHERE sUserName = @sUserName
END
GO

-- Truy vấn bảng Tài xế
-- Tạo View
CREATE VIEW v_TaiXe
AS
SELECT MaRFID AS [Mã thẻ RFID],
       TenTX AS [Tên tài xế],
	   GioiTinh AS [Giới tính],
	   NgaySinh AS [Ngày Sinh],
	   DiaChi AS [Địa chỉ],
	   DienThoai AS [Điện thoại]
FROM TaiXe
GO

-- Tạo PROC tìm kiếm theo mã
CREATE PROC PROC_SelectTX
@MaRFID VARCHAR(20)
AS 
BEGIN
	SELECT * FROM TaiXe WHERE MaRFID = @MaRFID
END
GO

-- Tạo PROC thêm dữ liệu vào bảng Tài xế
CREATE PROC PROC_InsertTX
@MaRFID VARCHAR(20),
@TenTX NVARCHAR(20),
@GT VARCHAR(10),
@NS Datetime,
@DiaChi VARCHAR(15),
@DienThoai VARCHAR(12)
AS
BEGIN
INSERT INTO TaiXe(MaRFID, TenTX, GioiTinh, NgaySinh, DiaChi, DienThoai)
VALUES (@MaRFID, @TenTX, @GT, @NS, @DiaChi, @DienThoai)
END
GO

-- Tạo PROC sửa dữ liệu vào bảng Tài Xế
CREATE PROC PROC_UpdateTX
@MaRFID VARCHAR(20),
@TenTX NVARCHAR(20),
@GT VARCHAR(10),
@NS Datetime,
@DiaChi VARCHAR(15),
@DienThoai VARCHAR(12)
AS
BEGIN
	UPDATE TaiXe
	SET TenTX = @TenTX, GioiTinh = @GT, NgaySinh = @NS, DiaChi = @DiaChi, DienThoai = @DienThoai
	WHERE MaRFID = @MaRFID
END
GO

-- Tạo PROC xóa dữ liệu ra khỏi bảng Tài xế
CREATE PROC PROC_DeleteKH
@MaRFID VARCHAR(20)
AS
BEGIN
	DELETE FROM TaiXe
	WHERE MaRFID = @MaRFID
END
GO

-- Truy vấn bảng Xe
-- Tạo View
CREATE VIEW v_Xe
AS
SELECT BienSoXe AS [Biển số xe],
       GiayPhep AS [Giấy phép],
	   TX.MaRFID AS [Mã thẻ RFID],
	   TK.sUserName AS [UserName]
FROM Xe AS Xe, TaiXe AS TX, TaiKhoan AS TK
WHERE Xe.MaRFID = TX.MaRFID AND Xe.sUserName = TK.sUserName
GO 

-- Tạo PROC tìm kiếm theo biển số xe
CREATE PROC PROC_SelectHXe
@BSX VARCHAR(10)
AS 
BEGIN
	SELECT * FROM Xe WHERE BienSoXe = @BSX
END
GO

-- Tạo PROC thêm dữ liệu vào bảng Xe
CREATE PROC PROC_InsertHXe
@BSX VARCHAR(10),
@GiayPhep VARCHAR(20),
@MaRFID VARCHAR(20),
@sUserName VARCHAR(20)
AS
BEGIN
INSERT INTO Xe(BienSoXe, GiayPhep, MaRFID, sUserName)
VALUES (@BSX, @GiayPhep, @MaRFID, @sUserName)
END
GO

-- Tạo PROC sửa dữ liệu vào Xe
CREATE PROC PROC_UpdateXe
@BSX VARCHAR(10),
@GiayPhep VARCHAR(20),
@MaRFID VARCHAR(20),
@sUserName VARCHAR(20)
AS
BEGIN
	UPDATE Xe
	SET  GiayPhep = @GiayPhep, MaRFID = @MaRFID, sUserName = @sUserName
	WHERE BienSoXe = @BSX 
END
GO

-- Tạo PROC xóa dữ liệu ra khỏi bảng Xe
CREATE PROC PROC_DeleteXe
@BSX VARCHAR(10)
AS
BEGIN
	DELETE FROM Xe
	WHERE BienSoXe = @BSX 
END
GO

-- Truy vấn bảng Định Vị
-- Tạo View
CREATE VIEW v_DinhVi
AS
SELECT STT AS [Số Thứ Tự],
       Ngay AS [Ngày],
	   Gio AS [Giờ],
	   Lat AS [Vĩ độ],
	   Long AS [Kinh Độ],
	   Xe.BienSoXe AS [Biển số xe]
FROM DinhVi AS DV, Xe AS Xe
WHERE DV.BienSoXe = Xe.BienSoXe
GO

-- Tạo PROC tìm kiếm theo Biển số xe
CREATE PROC PROC_SelectDinhVi
@BSX VARCHAR(10)
AS 
BEGIN
	SELECT * FROM DinhVi WHERE BienSoXe = @BSX
END
GO

-- Tạo PROC thêm dữ liệu vào bảng Định vị
CREATE PROC PROC_InsertDinhVi
@STT int,
@Ngay Datetime,
@Gio VARCHAR(20),
@Lat VARCHAR(20),
@Long VARCHAR(20),
@BSX VARCHAR(10)
AS
BEGIN
INSERT INTO DinhVi(STT, Ngay, Gio, Lat, Long, BienSoXe)
VALUES (@STT, @Ngay, @Gio, @Lat, @Long, @BSX)
END
GO


-- Tạo PROC xóa dữ liệu ra khỏi bảng Dịnh Vị
CREATE PROC PROC_DeleteDinhVi
@BSX VARCHAR(10)
AS
BEGIN
	DELETE FROM DinhVi
	WHERE BienSoXe = @BSX
END
GO

-- View báo cáo
CREATE VIEW v_BaoCao
AS
SELECT DV.Ngay AS [Ngày],
       DV.Gio AS [Giờ],
	   DV.Lat AS [Vĩ độ],
	   DV.Long AS [Kinh độ],
	   TX.TenTX AS [Tên tài xế],
	   TX.MaRFID AS [Giá bán],
	   Xe.BienSoXe AS [Số lượng]
FROM DinhVi AS DV, Xe AS Xe, TaiXe AS TX
WHERE DV.BienSoXe = Xe.BienSoXe AND TX.MaRFID = Xe.MaRFID