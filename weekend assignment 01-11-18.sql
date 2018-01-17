--First solution
 DECLARE Statuscursor cursor scroll
 FOR SELECT TOP 1000 [Status] 
 FROM Sales.SalesOrderHeader
 
 OPEN Statuscursor
      FETCH  first from Statuscursor
     
		
	 
	 WHILE @@FETCH_STATUS = 0
	      
	       BEGIN

		    FETCH NEXT FROM Statuscursor
			UPDATE Sales.SalesOrderHeader
			SET [Status] = (SELECT CEILING (RAND() *3))
			where current of Statuscursor

			   
			END 

CLOSE Statuscursor
DEALLOCATE Statuscursor


select Status from Sales.SalesOrderHeader where Status = 5


--update sales.SalesOrderHeader 
--SET Status = 5

--select 31465 - 30466

---update statement second solution
UPDATE Sales.SalesOrderHeader
    SET [Status] = (ABS(CHECKSUM(NewId())) % 3) + 1


	--second solution
DECLARE @OrderID INT
SET @OrderID = 
(SELECT TOP 1 SalesOrderID 
FROM Sales.SalesOrderHeader WHERE Status = 5)

WHILE @OrderID IS NOT NULL
BEGIN

    UPDATE Sales.SalesOrderHeader
    SET [Status] = (SELECT CEILING (RAND() *3)) 
    WHERE SalesOrderID = @OrderID

    SET @OrderID = 
    (SELECT TOP 1 SalesOrderID 
    FROM Sales.SalesOrderHeader WHERE Status = 5)
END