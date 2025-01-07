create database Stage 
go

alter database Stage set recovery simple 
go
alter database Stage set auto_shrink off
go
alter database Stage set auto_create_statistics off
go
alter database Stage set auto_update_statistics off
go
use stage
go


if exists 
  (select * from sys.tables 
   where name = 'address_type')
drop table address_type
go

create table address_type
( address_type_code   char(2)
, address_type        varchar(10)
, description         varchar(30)
)
go

if exists 
  (select * from sys.tables 
   where name = 'artist')
drop table artist
go

create table artist
( artist_code          char(10) not null
, artist_name          varchar(100) not null
, genre                varchar(30)
, country              varchar(50)
, city                 varchar(50)
) 
go

if exists
( select * from sys.tables
  where name = 'country')
drop table language
go

create table country
( country_code        char(2)
, country_name        varchar(50)
)
go

if exists 
  (select * from sys.tables 
   where name = 'currency')
drop table currency
go

create table currency
( currency_code       char(3) 
, currency_name       varchar(30)
)
go

if exists 
  (select * from sys.tables 
   where name = 'currency_rate')
drop table currency_rate
go

create table currency_rate
( effective_date      datetime 
, currency_code       char(3)  
, currency_rate       decimal(18, 10)
, created             datetime
, last_updated        datetime
)
go

if exists 
  (select * from sys.tables 
   where name = 'customer')
drop table customer
go

create table customer
( customer_number      varchar(10) 
, account_number       int
, customer_type        char(1)
, name                 varchar(100)
, gender               char(1)
, email_address        varchar(200)
, date_of_birth        datetime
, address1             varchar(50)
, address2             varchar(50)
, address3             varchar(50)
, address4             varchar(50)
, city                 varchar(50)
, state                varchar(40)
, zipcode              varchar(10)
, country              varchar(50)
, phone_number         varchar(20)
, occupation           varchar(50)
, household_income     int
, date_registered      datetime
, status               varchar(3)
, permission           varchar(2)
, preferred_channel1   varchar(20)
, preferred_channel2   varchar(20)
, interest1            varchar(30)
, interest2            varchar(30)
, interest3            varchar(30)
, created              datetime
, last_update          datetime
) 
go

if exists 
  (select * from sys.tables 
   where name = 'customer_status')
drop table customer_status
go

create table customer_status
( customer_status_code   varchar(3)
, description            varchar(10)
)
go

if exists 
  (select * from sys.tables 
   where name = 'customer_type')
drop table customer_type
go

create table customer_type
( customer_type_code     char(3) not null unique
, description            varchar(30)
)
go

if exists 
  (select * from sys.tables 
   where name = 'division')
drop table division
go

create table division
( division_code       varchar(5) not null primary key
, division_name       varchar(50)
, source_system_code  int
, date_loaded         datetime default getdate()
)
go


if exists 
  (select * from sys.tables 
   where name = 'email_address_type')
drop table email_address_type
go

create table email_address_type
( email_address_type_code   char(2)
, email_address_type        varchar(10)
, description               varchar(30)
)
go


if exists 
  (select * from sys.tables 
   where name = 'format')
drop table format
go

-- Create the table:

create table format
( format             varchar(30) not null
, description        varchar(50)
, media              varchar(15)
) 
go


if exists 
  (select * from sys.tables 
   where name = 'household_income')
drop table household_income
go

create table household_income
( household_income_code  int 
, lower_limit            money
, upper_limit            money
, description            varchar(30)
)
go


if exists 
  (select * from sys.tables 
   where name = 'interest')
drop table interest
go

create table interest
( interest                 varchar(30) 
, description              varchar(50)
, interest_group           varchar(30)
, associated_product_type  varchar(15)
, related_interest         varchar(30)
)
go


if exists
( select * from sys.tables
  where name = 'language')
drop table language
go

create table language
( code      char(3)
, language  varchar(50)
)
go


if exists 
  (select * from sys.tables 
   where name = 'occupation')
drop table occupation
go

create table occupation
( occupation_code      varchar(10) not null primary key
, occupation           varchar(30)
, description          varchar(50)
, category             varchar(30)
)
go


create table order_detail
( order_id       int
, line_no        int
, product_code   varchar(10)
, qty            numeric(9,2)
, price          money
, unit_cost      money
)
go


if exists
( select * from sys.tables
  where name = 'order_header' )
drop table order_header
go

create table order_header
( order_id          int
, order_date        datetime
, customer_number   int
, store_number      int
, currency          char(3)
, created           datetime
, last_updated      datetime
)
go


if exists 
  (select * from sys.tables 
   where name = 'package')
drop table package
go

create table package
( name                  varchar(30) 
, description           varchar(100)
, package_type          varchar(5)
, package_price         money
, source_system_code    int
, date_loaded           datetime default getdate()
)
go

if exists 
  (select * from sys.tables 
   where name = 'package_type')
drop table package_type
go

create table package_type
( package_type_code     char(5) 
, package_type          varchar(15) 
, source_system_code    int
, date_loaded           datetime default getdate()
)
go

if exists 
  (select * from sys.tables 
   where name = 'permission')
drop table permission
go

create table permission
( permission_code       varchar(2) 
, description           varchar(30)
)
go


if exists 
  (select * from sys.tables 
   where name = 'phone_number_type')
drop table phone_number_type
go

create table phone_number_type
( phone_number_type_code   char(2)
, phone_number_type        varchar(10)
, description              varchar(30)
)
go


truncate table stage.dbo.order_header

update meta.dbo.data_flow set LSET = getdate()-2, CET = getdate()-1 where name = 'order_header'

select * from meta.dbo.data_flow

select * from jade.dbo.order_header 
where (created between getdate()-1 and getdate()) 
or (last_updated between getdate()-1 and getdate())

select * from meta.dbo.data_flow

select * from stage.dbo.order_header


if exists
  (select * from sys.tables 
   where name = 'product')
drop table product
go

create table product
( product_code         varchar(10) 
, name                 varchar(50) 
, description          varchar(100)
, title                varchar(100)
, artist_code          varchar(10)
, product_type_code    varchar(2)
, format               varchar(30)
, unit_price           smallmoney
, unit_cost            smallmoney
, status               varchar(15)
, created              datetime
, last_updated         datetime
) 
go


if exists 
  (select * from sys.tables 
   where name = 'product_category')
drop table product_category
go

create table product_category
( product_category      varchar(20) 
, description           varchar(50)
)
go


if exists 
  (select * from sys.tables 
   where name = 'product_status')
drop table product_status
go

create table product_status
( product_status_code     char(2) 
, product_status          varchar(15) 
)
go


if exists 
  (select * from sys.tables 
   where name = 'product_type')
drop table product_type
go

create table product_type
( product_type_code     char(2) 
, product_type          varchar(15) not null
, product_category      varchar(20)
)
go


if exists 
  (select * from sys.tables 
   where name = 'region')
drop table region
go

create table region
( region_code         varchar(5)   not null primary key
, region_name         varchar(50)
, division_code       varchar(5)
, source_system_code  int
, date_loaded         datetime default getdate()
)
go


if exists 
  (select * from sys.tables 
   where name = 'state')
drop table state
go

create table state
( state_code              varchar(2)  not null primary key
, state_name              varchar(50)
, formal_name             varchar(100)
, admission_to_statehood  datetime
, population              int
, capital                 varchar(50)
, largest_city            varchar(50)
, source_system_code      int
, date_loaded             datetime default getdate()
)
go

if exists 
  (select * from sys.tables 
   where name = 'store')
drop table store
go

create table store
( store_number         smallint    
, store_name           varchar(40)
, store_type           varchar(20)
, address1             varchar(50)
, address2             varchar(50)
, address3             varchar(50)
, address4             varchar(50)
, city                 varchar(50)
, state                varchar(40)
, zipcode              varchar(10)
, country              varchar(50)
, phone_number         varchar(20)
, web_site             varchar(100)
, region               varchar(30)
, division             varchar(30)
, created              datetime
, last_updated         datetime
)
go

truncate table order_header;

select * from order_header
where (created between getdate()-1 and getdate())
or (last_updated between getdate()-1 and getdate());


SELECT * 
FROM order_header;

