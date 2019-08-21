alter table dbo.usageData
drop column MeterCategory
alter table dbo.usageData
add foreign key(MeterId) references dbo.meterMapping(MeterId)
alter table dbo.usageData
add foreign key(SubscriptionGuid) references dbo.subscriptions(SubscriptionGuid)