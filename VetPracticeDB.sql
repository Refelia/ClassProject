
USE master
IF (select count(*)
FROM sys.databases WHERE NAME = 'VetPractice')>0
BEGIN
     DROP DATABASE VetPractice
END

     CREATE DATABASE VetPractice

      USE VetPractice
GO

/*
 create table
 
 */

CREATE TABLE Clients   
( ClientID int identity(1,1),
  FirstName varchar(25) not null,
  LastName varchar(25) not  null,
  MiddleName varchar (25) null,
  CreateDate date not null DEFAULT Getdate(),
  Primary Key (ClientID)
   
)

CREATE TABLE ClientContacts 
( AddressID int identity (1,1),
  ClientID int not null,
   AddressType int not null Constraint AddressType CHECK ( AddressType IN (1 , 2 )),
   AddressLine1 varchar(50) not null,
   AddressLine2 varchar(50) null,
   City varchar(35) not null,
   StateProvince varchar(25) not null,
   PostalCode varchar(15) not null,
   Phone varchar(15) not null,
   AltPhone varchar(15) not null,
   Email varchar(35),
   Primary Key (AddressID),
   Constraint fk_ClientContacts_Clients foreign key (ClientID) references Clients (ClientID)
   
)

CREATE TABLE Patients
( PatientID int identity(1,1),
  ClientID int not null,
  PetName varchar(35) not null,
  AnimalType int not null,
  Color varchar(25) null,
  Gender varchar(2) not null,
  BirthYear varchar(4) null,
  Weight decimal(2) not null,
  Description varchar(1024) null,
  GeneralNotes varchar(2048) not null,
  Chipped bit not null DEFAULT 0,
  Rabiesvacc datetime null,
  Primary Key (PatientID),
  Constraint fk_Patients_Clients foreign key (ClientID) references Clients (ClientID)
 
)

CREATE TABLE AnimalTypeReference
( AnimalTypeID int not null,
  Species varchar(35) not null,
  Breed varchar(35) not null,
  Primary Key (AnimalTypeID)
)

CREATE TABLE Employees
(  EmployeeID int identity (1,1),
   LastName varchar(25) not null,
   FirstName varchar(25) not null,
   MiddleName varchar(25) not null,
   HireDate date not null DEFAULT Getdate(),
   Title varchar(50) not null
   Primary Key (EmployeeID)
 )

CREATE TABLE EmployeeContactInfo
(  AddressID int identity (1,1),
   AddressType int not null,
   AddressLine1 varchar(50) not null,
   AddressLine2 varchar(50)  null,
   City varchar(35) not null,
   StateProvince varchar(25) not null,
   PorstalCode varchar(15) not null,
   Phone       varchar(15) not null,
   AltPhone varchar(15) not null,
   EmployeeID int not null,
   Primary Key (AddressID),
   Constraint fk_EmployeeContactInfo_Employees foreign key (EmployeeID) references Employees (EmployeeID)
)

CREATE TABLE Visits
(  VisitID int identity(1,1),
   StartTime datetime not null,
   EndTime datetime not null , 
   Appointment bit not null DEFAULT 0,
   DiagnosisCode varchar(12) not null,
   ProcedureCode varchar(12) not null,
   VisitNotes varchar(2048) not null,
   PatientID int not null,
   EmployeeID int not null,
   Primary Key ( VisitID),
   Constraint fk_Visits_Patients foreign key (PatientID) references Patients (PatientID),
   Constraint fk_Visits_Employees foreign key (EmployeeID) references Employees (EmployeeID),
   CONSTRAINT CHK_DATE CHECK (EndTime >= StartTime)
   
) 



CREATE TABLE Billing
( BillID int identity(1,1),
  BillDate date not null ,
  ClientID int not null,
  VisitID int not null,
  Amount decimal not null,
  Primary Key (BillID),
  Constraint fk_Billing_Clients foreign key (ClientID) references Clients (ClientID),
  Constraint fk_Billing_Visits foreign key (VisitID) references Visits (VisitID),
  Constraint BillDate CHECK (BillDate <= Getdate())
  
)

CREATE TABLE Payments
( PaymentID int identity(1,1),
  PaymentDate date not null,
  BillID int null,
  Notes varchar(2048) null,
  Amount decimal not null,
  Primary  key (PaymentID),
  Constraint fk_Payments_Billing foreign key (BillID) references Billing (BillID),
  CONSTRAINT PaymentDate CHECK (PaymentDate <= Getdate())
)
/*
    Inserting data into the Clients table

*/
INSERT INTO Clients 
       ([FirstName],[LastName],[MiddleName])
VALUES  ('Halsy',	'Duce',	'Addie'),('Dorisa',	'Mulhall',	'Zia'),('Brittan',	'Mattiessen',	'Dehlia'),
        ('Ester',	'Cavee',	'Marjie'),('Chloris',	'Pauley',	'Vincent'),('Ulrich',	'Baribal',	'Andre')




/* 
     Inserting data to Patients table

*/
INSERT INTO Patients
         ([ClientID],[PetName],[AnimalType],[Color],[Gender],[Weight],[GeneralNotes])
VALUES   (1, 'Sha-sha', 1, 'Orange', 'F', 6.0,'samples'), (2, 'Maggie',2, 'Brown','M',11,'sample'),
         (3, 'Daisy', 2, 'Black and White', 'F', 12, 'sampe'), (4, 'Rocky', 1, 'White', 'M', 6, 'sample'),
		 (5, 'Buddy', 3, 'White', 'M',7, 'sample'), (2, 'Peter', 3, 'Brown', 'M', 5, 'sample'),(1, 'Roger', 2, 'Black', 'M', 12, 'sample')




/* 
    Inserting data to Employees table

*/
INSERT INTO Employees
         ([LastName],[FirstName],[MiddleName],[Title])
VALUES   ('Barrie', 'Evonne',	'Solan', 'Veterinarian'),('Vinnie',	'Brannigan','Engelbert','Internist, veterinary'),
         ('Doget', 'Ev','Matthew', 'Veterinarian'),('Jemima','Cellone','Abigale','pathologist, animal'), 
		 ('Byrth', 'Gilberta',	'Rosbrough','animal pathologist'),('Max', 'Gravell','Rosalia','Inspector, veterinary'),
		 ('Gross','Tadeas',	'Hedgeley','Radiologist, veterinary')


/* 
    Inserting data to EmployeeContactInfo table

*/
INSERT INTO EmployeeContactInfo
         ([AddressType],[AddressLine1],[City],[StateProvince],[PorstalCode], [Phone],[AltPhone], EmployeeID)
VALUES   (1,'8545 Farwell Way','Wilmington', 'D', '19805','201-628-0177','201-628-7868',1),
         (2,'3 Quincy Pass', 'Columbia', 'SC', '29240','955-669-2051','955-677-5980',2),
         (1,'195 Union Trail', 'Des Moines', 'I', '50393','741-270-2272','741-890-8888',3),
         (2,'7337 Loomis Park', 'Sparks', 'N', '89436','196-932-6696','196-4421-1232',4),
         (1,'18864 Esch Place', 'Nashville', 'T', '37205','429-765-6967','429-675-2341',5),
         (2,'92261 Southtwood Avenue', 'Houston', 'Tx', '77035','851-933-3011','851-7655-6084',6),
         (1,'6415 Cordelia St', 'Salem', 'O', '97312','470-427-9598','470-123-7866',7)



/* 
        Inserting data to AnimalTypeReference table

*/
INSERT INTO AnimalTypeReference
        ([AnimalTypeID],[Species],[Breed])
VALUES  (1, 'Rabbit', 'Argente Flopper'), (2,'Dog','Australian Shepperd'), (3, 'Cat','American Curl')





/* 
    Inserting data to Visits table
	 
   */

INSERT INTO Visits
        ([StartTime], [EndTime], [DiagnosisCode],[ProcedureCode],[VisitNotes],[PatientID],[EmployeeID])
VALUES   (GETDATE(), DATEADD(minute,45,GETDATE()), 'wqlk', '3453', 'testing', 3, 2),
         (GETDATE(), DATEADD(minute,30,GETDATE()), 'abcd', '1111','test',1,1),
         (GETDATE(), DATEADD(minute,25,GETDATE()),'lmkn', '3333',' test', 2,4),   
		 (GETDATE(), DATEADD(hour,1, GETDATE()), 'dfcg','5678', 'test', 4,3),
		 (GETDATE(), DATEADD(minute, 65, GETDATE()), 'dfry', '4865', 'testing',5,5)
		



/* 
        Inserting data to ClientsContact table

*/
INSERT INTO ClientContacts
        ([ClientID],[AddressType],[AddressLine1],[City],[StateProvince],[PostalCode],[Phone],[AltPhone],[Email])
VALUES  (1,2,'92261 Eastwood Avenue', 'Houston', 'Tx', '77035','851-933-3011','851-938-3045','dmccabe0@seesaa.net'),
        (2,1,'6415 Cordelia Court', 'Salem', 'O', '97312','470-427-9598','470-489-9794','jsiddell1@google.com.br'),
        (3,1,'071 Pearson Terrace', 'Houston', 'Tx', '77266','730-601-7096','730-6978-7761','mouthwaite2@alexa.com'),
        (4,2,'7 3rd Avenue', 'Hot Springs National Park', 'Ak', '71914','552-250-1816','552-290-1867','bmengue4@deviantart.com'),
        (5,1,'8642 Emmet Place', 'Houston', 'Tx', '77015','552-365-4017','552-390-7865','abartolomeazzi3@sciencedirect.com')
         



 /*
 Creating log in  and user 
   account for Vet manager
  */

 IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'VetmanagerUser')
    CREATE LOGIN [VetManagerUser] WITH PASSWORD= 'abcd', 
	DEFAULT_DATABASE=[VetPractice], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
 
  CREATE USER VetManagerUser FOR LOGIN VetManagerUser
  GO

  ALTER ROLE DB_datareader ADD MEMBER [VetManagerUser]
  ALTER ROLE DB_datawriter ADD MEMBER [VetManagerUser]

 
 
 
 /*
 Create log in and User account 
    for Vet Clerk

  */

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'VetClerkUser')
    CREATE LOGIN [VetClerkUser] WITH PASSWORD= '1234', 
	DEFAULT_DATABASE=[VetPractice], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO

  CREATE USER VetClerkUser FOR LOGIN VetClerkUser

  ALTER ROLE DB_datareader ADD MEMBER [VetClerkUSer]

  DENY SELECT ON dbo.EmployeeContactInfo TO VetClerkUser
  DENY SELECT ON dbo.ClientContacts TO VetClerkUser

  
  
  
  /*
        Create a stored procedure
        for a specific Species 
  
  */
GO
  CREATE PROC Species
AS
BEGIN
       SELECT c.FirstName, c.LastName,p.PetName, Species ,cc.AddressLine1,cc.City,cc.StateProvince,cc.PostalCode,cc.Phone
       FROM Clients c
       INNER JOIN Patients p
       ON p.ClientID = c.ClientID
       INNER JOIN AnimalTypeReference ar
       ON ar.AnimalTypeID = p.PatientID
       INNER JOIN ClientContacts cc
       ON cc.ClientID = p.ClientID
	   --WHERE Species = 'Dog'
END
GO
GRANT EXECUTE ON Species TO VetClerkUser  --grant permission to VetClerkUser  

--EXECUTE Species



/*
   stored procedure for specific breed

 */
GO
CREATE PROC Breed
AS
BEGIN
       SELECT c.FirstName, c.LastName,p.PetName, Breed ,cc.AddressLine1,cc.City,cc.StateProvince,cc.PostalCode,cc.Phone
       FROM Clients c
       INNER JOIN Patients p
       ON p.ClientID = c.ClientID
       INNER JOIN AnimalTypeReference ar
       ON ar.AnimalTypeID = p.PatientID
       INNER JOIN ClientContacts cc
       ON cc.ClientID = p.ClientID
END
GO
GRANT EXECUTE ON Breed TO VetClerkUser  --grant permission to VetClerkUser  

--EXECUTE Breed


/*

Creating procedure for
 employees mailing list

 */
GO
CREATE PROC EmployeesMailingList
AS
BEGIN
        SELECT  e.EmployeeID, CONCAT(e.LastName,' ', e.FirstName) AS [Employee], 
                CONCAT(AddressLine1,',',City,' ',StateProvince,'.',PorstalCode)
                AS [Mailing Address], Phone AS [Primary Phone]
        FROM       Employees e
        INNER JOIN EmployeeContactInfo eci
ON             eci.EmployeeID = e.EmployeeID
END
GO
GRANT EXECUTE ON EmployeesMailingList TO VetClerkUser   --grant permission to VetClerkUser 

--EXECUTE EmployeesMailingList



/*
Creating stored procedure for
 clients payment information 

 */
GO
CREATE  PROC PaymentInformation
AS
BEGIN
      SELECT b.ClientID, p.PaymentDate, v.StartTime AS [Visit Date],p.Amount 
      FROM Billing b
      INNER JOIN Payments p
      ON p.BillID = b.BillID
      INNER JOIN Visits v
      ON v.VisitID = b.VisitID
END
GO
GRANT EXECUTE ON PaymentInformation TO VetClerkUser  --grant permission to VetClerkUser 

--EXECUTE PaymentInformation


/*
  create procedure to insert new client and return
  a new clientID as an output variable

  */
GO
CREATE PROC InsertNewClient
           
		    @ClientID int  output,
		    @FirstName varchar(25),
		    @LastName varchar(25),
		    @MiddleName varchar(25),
		    @CreateDate date,
	        @AddressID int,
		    @AddresType int,
		    @AddresLine1 varchar(50),
		    @AddressLine2 varchar(50),
		    @City varchar(35),
		    @StateProvince varchar(25),
		    @PostalCode varchar(15),
		    @Phone varchar(15),
		    @AltPhone varchar(15),
		    @Email varchar(35)
AS
BEGIN 
     DECLARE @Newid table ( ClientID int)
	

     INSERT INTO dbo.Clients
	            ([FirstName],[LastName],[MiddleName],[CreateDate])
	
	OUTPUT       SCOPE_IDENTITY() INTO @Newid( ClientID)
	
	VALUES      (@FirstName,@LastName,@MiddleName,@CreateDate)


	INSERT INTO  dbo.ClientContacts
	            ([AddressID], [ClientID],[AddressType],[AddressLine1],[AddressLine2],[City],[StateProvince],[PostalCode],
				[Phone],[AltPhone],[Email])
    SELECT       @AddressID, @ClientID,  @AddresType, @AddresLine1, @AddressLine2, @City,@StateProvince, @PostalCode, @Phone,@AltPhone,@Email
	FROM         @Newid

END



/* 
Create procedure to insert new employee and return the 
new employeeID
*/

GO
CREATE PROC InsertNewEmployee
      
	        @EmployeeID int OUTPUT,
			@LastName varchar(25),
			@FirstName varchar(25),
			@MiddleName varchar (25),
			@HireDate date,
			@Title varchar(50),
			@AddressID int,
			@AddressType int,
			@AddressLine1 varchar(50),
			@AddressLine2 varchar(50),
			@City varchar(35),
			@StateProvince varchar(25),
			@PostalCode varchar(15),
			@Phone varchar(15),
			@AltPhone varchar(15)
AS
BEGIN
            DECLARE @NewEmpID TABLE (EmployeeID int)
			
			 INSERT INTO dbo.Employees
			    ([EmployeeID],[LastName],[FirstName],[MiddleName],[HireDate],[Title] )
               
			   OUTPUT SCOPE_IDENTITY() INTO @NewEmpID(EmployeeID)

VALUES       ( @EmployeeID, @LastName,@FirstName, @MiddleName, @HireDate, @Title)
	

	INSERT INTO dbo.EmployeeContactInfo
	           ([AddressID],[AddressType],[AddressLine1],[AddressLine2],[City],[StateProvince],[PorstalCode],[Phone],[AltPhone], [EmployeeID] )
	SELECT      @AddressID, @AddressType, @AddressLine1, @AddressLine2, @City, @StateProvince, @PostalCode, @Phone, @AltPhone ,@EmployeeID
	FROM        @NewEmpID

	return 
END




