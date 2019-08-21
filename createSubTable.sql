create table subscriptions(
	SubscriptionGuid nvarchar(400) primary key,
	SubscriptionName nvarchar(max) not null,
	Currency nvarchar(max) not null
)