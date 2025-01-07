-- Extracting Data Using SSIS

restore database Jade from disk = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\Backup\jade.bak'
with move 'Jade_fg1' to 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\DATA\Jade_fg1.mdf', 
     move 'Jade_log' to 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER01\MSSQL\LOG\Jade_log.ldf'



-- Tạo login ETL
create login ETL with password = '[pwd]', default_database = stage;
go

drop login ETL;

-- Chuyển sang cơ sở dữ liệu Jade
use Jade;
go

-- Tạo user ETL cho login ETL trong cơ sở dữ liệu Jade
create user ETL for login ETL;
go

-- Cấp quyền db_owner cho user ETL trong cơ sở dữ liệu Jade
sp_addrolemember 'db_owner', 'ETL';
go

-- Chuyển sang cơ sở dữ liệu Stage
use Stage;
go

-- Tạo user ETL cho login ETL trong cơ sở dữ liệu Stage
create user ETL for login ETL;
go

-- Cấp quyền db_owner cho user ETL trong cơ sở dữ liệu Stage
sp_addrolemember 'db_owner', 'ETL';
go

-- Tạo user ETL cho login ETL trong cơ sở dữ liệu Meta
CREATE USER ETL FOR LOGIN ETL;
GO

-- Cấp quyền db_owner cho user ETL trong cơ sở dữ liệu Meta
EXEC sp_addrolemember 'db_owner', 'ETL';
GO


SELECT name
FROM sys.databases
WHERE name = 'Meta';

select * from order_header
where (created > '2007-12-01 03:00:00'
and created <= '2007-12-02 03:00:00')
or (last_updated > '2007-12-01 03:00:00'
and last_updated <= '2007-12-02 03:00:00')

drop table order_header;



SELECT 
    COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'order_header';


SELECT 
    MIN(created) AS MinCreated, 
    MAX(created) AS MaxCreated,
    MIN(last_updated) AS MinLastUpdated,
    MAX(last_updated) AS MaxLastUpdated
FROM Jade.dbo.order_header;

SELECT COUNT(*) AS TotalRows
FROM Jade.dbo.order_header;

SELECT * 
FROM Jade.dbo.order_header
WHERE (created BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE())
   OR (last_updated BETWEEN DATEADD(DAY, -7, GETDATE()) AND GETDATE());

SELECT TOP 10 created, last_updated
FROM Jade.dbo.order_header
ORDER BY created DESC;

-- Kiểm tra chỉ cột created
SELECT * 
FROM Jade.dbo.order_header
WHERE created BETWEEN GETDATE()-1 AND GETDATE();

-- Kiểm tra chỉ cột last_updated
SELECT * 
FROM Jade.dbo.order_header
WHERE last_updated BETWEEN GETDATE()-1 AND GETDATE();


