ALTER PROCEDURE dbo.dataModel
AS
-- Add to Subscriptions
INSERT INTO dbo.subscriptions
SELECT tbl.SubscriptionGuid, tbl.SubscriptionName, tbl.Currency
FROM #Inserted tbl
WHERE NOT EXISTS(
	SELECT SubscriptionGuid
	FROM dbo.subscriptions
	WHERE dbo.subscriptions.SubscriptionGuid = tbl.SubscriptionGuid
)
GROUP BY tbl.SubscriptionGuid, tbl.SubscriptionName, tbl.Currency
-- Add to MeterMapping
INSERT INTO dbo.meterMapping
SELECT tbl.MeterId, tbl.MeterCategory, tbl.MeterSubCategory, tbl.MeterName, tbl.Unit
FROM #Inserted tbl
WHERE NOT EXISTS(
	SELECT MeterId
	FROM dbo.meterMapping
	WHERE dbo.meterMapping.MeterId = tbl.MeterId
)
GROUP BY tbl.MeterId, tbl.MeterCategory, tbl.MeterSubCategory, tbl.MeterName, tbl.Unit
-- Get modified data
INSERT INTO dbo.tempTable
SELECT tbl.ConsumedService, tbl.InstanceId, tbl.InstanceName, tbl.MeterLocation,
	tbl.MeterId, tbl.Name, SUM(tbl.PretaxCost) AS PretaxCost, tbl.SubscriptionGuid, tbl.UsageStart, SUM(tbl.UsageQuantity) AS UsageQuantity
FROM #Inserted tbl
GROUP BY tbl.Name, tbl.ConsumedService, tbl.InstanceId, tbl.InstanceName, tbl.MeterLocation,
	tbl.MeterId, tbl.SubscriptionGuid, tbl.UsageStart
-- Store into final table
INSERT INTO dbo.usageData
SELECT tbl.ConsumedService, tbl.InstanceId, tbl.InstanceName, tbl.MeterLocation,
	tbl.MeterId, tbl.Name, SUM(tbl.PretaxCost) AS PretaxCost, tbl.SubscriptionGuid, convert(date, tbl.UsageStart) AS UsageDate, SUM(tbl.UsageQuantity) AS UsageQuantity
FROM dbo.tempTable tbl
GROUP BY tbl.Name, tbl.ConsumedService, tbl.InstanceId, tbl.InstanceName, tbl.MeterLocation,
	tbl.MeterId, tbl.SubscriptionGuid, tbl.UsageStart
-- Delete temp table
DELETE FROM dbo.tempTable