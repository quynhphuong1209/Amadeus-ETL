create database Meta
go

use meta
go

if exists
( select * from sys.tables where name = 'data_flow' )
drop table data_flow 
go
 


create table data_flow
( id	int	not null identity(1,1)
, name	varchar(20) not null
, status int
, LSET	datetime
, CET	datetime
, constraint pk_data_flow primary key clustered (id)
)
go


create index data_flow_name on data_flow(name)
go

declare @LSET datetime, @CET datetime set @LSET = '2007-12-01 03:00:00'
set @CET = '2007-12-02 03:00:00'
insert into data_flow (name, status, LSET, CET) values ('order_header', 0, @LSET, @CET)
insert into data_flow (name, status, LSET, CET) values ('order_detail', 0, @LSET, @CET)
insert into data_flow (name, status, LSET, CET) values ('customer', 0, @LSET, @CET)
insert into data_flow (name, status, LSET, CET) values ('product', 0, @LSET, @CET)
go

select * from data_flow;

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'data_flow';
SELECT * FROM data_flow WHERE name = 'order_header';

EXEC sp_help 'data_flow';

SELECT LSET, CET 
FROM data_flow
WHERE name = 'order_header';



update data_flow
set LSET = getdate() - 2, CET = getdate() - 1
where name = 'order_header';



UPDATE data_flow
SET status = 1, CET = GETDATE()  -- Cập nhật trạng thái thành công và thời gian kết thúc
WHERE name = 'order_header';

-- Cập nhật thông tin cho 'order_detail'
update data_flow
set status = 1, -- Trạng thái thành công

    CET = GETDATE() -- Thời gian thực thi hiện tại
where name = 'order_detail';

-- Cập nhật thông tin cho 'customer'
update data_flow
set status = 1,
    CET = GETDATE()
where name = 'customer';

-- Cập nhật thông tin cho 'product'
update data_flow
set status = 1,

    CET = GETDATE()
where name = 'product';

