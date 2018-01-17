--First solution
 DECLARE Statuscursor cursor 
 FOR SELECT TOP 1000 [Status] 
 FROM Sales.SalesOrderHeader
 
 OPEN Statuscursor
      --FETCH  next from Statuscursor
     
		
	  WHILE @@FETCH_STATUS = 0
	 
	      
	       BEGIN

		     FETCH next FROM Statuscursor
			UPDATE Sales.SalesOrderHeader
			SET [Status] = (SELECT CEILING (RAND() *3))
			where current of Statuscursor
			

			   
			END 

CLOSE Statuscursor
DEALLOCATE Statuscursor


select Status from Sales.SalesOrderHeader where Status = 5

---update statement second solution

UPDATE Sales.SalesOrderHeader
    SET [Status] = (ABS(CHECKSUM(NewId())) % 3) + 1
	WHERE Status = 5

 --update Sales.SalesOrderHeader
 --set Status =5            
    

----Write two functions to determine the quantity on hand for a specific product. 
--One will accept the ProductID as a parameter and the other will accept the ProductNumber. 
--(See the Production.Product table for these fields.)
	
	
	
	--Product id Function solution # 1
	
GO
	CREATE FUNCTION  fnProducTotal
	(
	    @ProductID as int
	)
RETURNS INT
AS
BEGIN
       DECLARE @Quantity int
	   SET @Quantity = (select sum(Quantity) FROM Production.ProductInventory WHERE ProductID = @ProductID GROUP BY ProductID )
	   
		RETURN @Quantity
END
GO

select  [dbo].[fnProducTotal]('ProductID') 


-- create function solution #2
GO
CREATE function fnProductNumber
(
    @ProductNumber as varchar(max)
)
RETURNS varchar(max)
AS
BEGIN
     DECLARE @QtyOnHand int
	 

	 SET @QtyOnHand =(select sum(Quantity) FROM Production.ProductInventory i INNER JOIN Production.Product p ON i.ProductID = p.ProductID
	            Where ProductNumber= @ProductNumber GROUP BY p.ProductNumber)

	RETURN @QtyOnHand

END
GO


select  [dbo].[fnProductNumber]('BE-2349')


--select pp.ProductNumber,ppi.Quantity,dbo.[fnProductNumber]('BE-2349')
--FROM Production.Product pp
--INNER JOIN Production.ProductInventory ppi
--ON ppi.ProductID = pp.ProductID
--WHERE ProductNumber = 'BE-2349'


