create table meterMapping(
	MeterId nvarchar(400) primary key,
	MeterCategory nvarchar(max) not null,
	MeterSubCategory nvarchar(max),
	MeterName nvarchar(max) not null,
	Unit nvarchar(max) not null
)