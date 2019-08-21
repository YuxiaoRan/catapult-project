alter TRIGGER dbo.rawDataTrigger
ON dbo.rawData
AFTER INSERT, UPDATE
AS
BEGIN
	SELECT * INTO #Inserted FROM INSERTED
	EXEC dbo.dataModel
END