use master
if (select count(*) from sys.databases where name = 'Public Library') = 0
DROP Database PublicLibrary

CREATE database PublicLibrary

USE PublicLibrary
GO


CREATE TABLE Genre
(
       GenreID int not null identity (1,1),
	   [Name] varchar(20),
	   Primary key (GenreID)
)

CREATE TABLE LibraryInventory
(
       TypeID int not null identity (1000,1),
	   Item varchar (75) not null,
	   Qty  int not null,
	   [Location] varchar(25) null,
	   ModifiedDate datetime not null  DEFAULT (getdate()),
	   Primary key (TypeID) 
)

CREATE TABLE Person
(
       PersonID int not null identity(501,1),
	   LastName varchar (35)  null,
	   FirstName varchar(35)  null,
	   MI varchar(35) null,
	   Birthdate datetime null,
	   ModifiedDate datetime  DEFAULT (getdate()),
	   Primary Key (PersonID)

)
CREATE TABLE Address
(
       AddressID int not null identity (167,1),
	   PersonID int null,
	   AddressLine1 varchar (25) null,
	   AddressLine2 varchar (25) null,
	   City varchar (45) null,
	   [State] varchar(45) null,
	   Zip varchar (10),
	   Primary Key (AddressID),
	   CONSTRAINT fk_Address_Person foreign key (PersonID) References Person (PersonID) 

)
CREATE TABLE Author
(
       AuthorID int not null identity (605,1),
	   PersonID int null,
	   AddressID int null,
	   Primary Key (AuthorID),
	   CONSTRAINT fk_Author_Person foreign key (PersonID) References Person (PersonID)
)

CREATE TABLE LibraryItem
(
       ItemID int not null identity (120,1),
	   TypeID int null,
	   Title varchar(75) null,
	   AuthorID int null,
	   GenreID int null,
	   PublicationDate datetime null,
	   PublishingHouse varchar(35) null,
	   ModifiedDate datetime not null  DEFAULT (getdate()),
	   Primary key (ItemID),
	   CONSTRAINT fk_LibraryItem_LibraryInventory foreign key (TypeID) references LibraryInventory (TypeID),
	   CONSTRAINT fk_LibraryItem_Author foreign key (AuthorID) references Author (AuthorID),
	   CONSTRAINT fk_LibraryItem_Genre foreign key (GenreID) references Genre (GenreID)
)

CREATE TABLE DisposedItem
(
       DisposedID int not null identity(229,1),
	   ItemID int null,
	  -- [Name] varchar(75) not null,
	   DisposedDate datetime not null DEFAULT (getdate()),
	   Reason Varchar (255),
	   Primary Key (DisposedID),
	   CONSTRAINT fk_DisposedItem_LibraryItem foreign key (ItemID) References LibraryItem (ItemID)
) 

CREATE TABLE DamageTypes
(
       DamageType int not null identity (999,1),
	   [Description] varchar(20) null,
	   Fee money null,
	   Primary Key (DamageType)
)
CREATE TABLE LibraryFeePolicy
(
       PolicyID int not null identity (332,1),
	   TypeID int null,
	   OverdueFeePerDay money null,
	   Lost varchar (20),
	   DamageType int null,
	   ModifiedDate datetime not null DEFAULT (getdate()),
	   Primary Key (PolicyID),
	   CONSTRAINT fk_LibraryFeePolicy_LibraryInventory foreign key (TypeID) references LibraryInventory (TypeID),
	   CONSTRAINT fk_LibraryFeePolicy_DamageTypes foreign key (DamageType) references DamageTypes (DamageType)
)

CREATE TABLE PhoneType
(
       PhoneTypeID int not null identity (1,1),
	   [Type] varchar (10) null,
	   Primary Key (PhoneTypeID)
)
CREATE TABLE Phone
( 
       PhoneNumber varchar(15) null,
	   PersonID int null,
	   PhoneTypeID int null,
	   CONSTRAINT fk_Phone_PhoneType foreign key (PhoneTypeID) References PhoneType (PhoneTypeID),
	   CONSTRAINT fk_Phone_Person foreign key (PersonID) References Person (PersonID)
)
CREATE TABLE EmailAddress
(
       EmailAddressID int not null identity (32,1),
	   PersonID int null,
	   EmailAddress varchar(45),
	   Primary Key (EmailAddressID),
	   CONSTRAINT fk_EmailAddress_Person foreign key (PersonID) References Person (PersonID)
)
CREATE TABLE Employee
(
       EmployeeID int not null identity (678,1),
	   PersonID int null,
	   AddressID int null,
	   HireDate datetime null,
	   EndDate datetime null,
	   Primary key (EmployeeID),
	   CONSTRAINT fk_Employee_Person foreign key (PersonID) References Person (PersonID),
	   CONSTRAINT fk_Employee_Address foreign key (AddressID) References [Address] (AddressID),
)
CREATE TABLE Borrower
(
       BorrowerID int not null identity (788,1),
	   PersonID int null,
	   AddressID int null
	   Primary Key (BorrowerID),
	   CONSTRAINT fk_Borrower_Person foreign key (PersonID) References Person (PersonID),
	   CONSTRAINT fk_Borrower_Address foreign key (AddressID) References [Address] (AddressID)
)
CREATE TABLE BorrowerHistory
(
       HistoryID int not null identity (89,1),
	   EmployeeID int null,
	   BorrowerID int null,
	   CheckOutDate datetime null,
	   TypeID int null,
	   ItemID int null,
	   DateDue datetime,
	   returnedDate datetime,
	   Primary Key (HistoryID),
	   CONSTRAINT fk_BorrowerHistory_Employee foreign key (EmployeeID) References Employee (EmployeeID),
	   CONSTRAINT fk_BorrowerHistory_Borrower foreign key (BorrowerID) References Borrower (BorrowerID),
	   CONSTRAINT fk_BorrowerHistory_LibraryInventory foreign key (TypeID) References LibraryInventory (TypeID),
	   CONSTRAINT fk_BorrowerHistory_LibraryItem foreign key (ItemID) References LibraryItem (ItemID)
)
CREATE TABLE LostDamageItem
(
       LostDamageID int not null identity (890,1),
	   DamageType int null,
	   BorrowerID int null,
	   [Status] varchar(15) null,
	   Penalty money null
	   Primary Key (lostDamageID)
	   CONSTRAINT fk_LostDamageID_DamageTypes foreign key (DamageType) References Damagetypes (DamageType), 
	   CONSTRAINT fk_LostDamageID_Borrower foreign key (BorrowerID) References Borrower (BorrowerID), 

)
CREATE TABLE OverdueItem
(
       OverdueID int not null identity (345,1),
	   BorrowerID int null,
	   TypeID int null,
	   ItemID int null,
	   Overdue bit null,
	   NumberOfdays int null,
	   FeesCollected money null,
	   Primary Key (OverdueID),
	   CONSTRAINT fk_OverdueItem_Borrower foreign key (BorrowerID) References Borrower (BorrowerID),
	   CONSTRAINT fk_OverdueItem_LibraryInventory foreign key (TypeID) References LibraryInventory (TypeID),
	   CONSTRAINT fk_OverdueItem_LibraryItem foreign key (ItemID) References LibraryItem (ItemID)

)

--creating trigger
GO
create trigger trgInsertPersonID
on Person
after insert, update,delete
as begin 
        declare @PersonID int
		select @PersonID=PersonID from inserted 
		
		insert into Author (PersonID)
		values (@PersonID)
	end
	GO
--creating trigger on Address table 
GO	  
create trigger trginsertAddressid
on [Address]
after insert, update,delete
as begin 
        declare @AddressID int
		select @AddressID=AddressID from inserted 
		
		insert into Author (AddressID)
		values (@AddressID)
	end
	GO
--creating trigger on Person after insert update address person personID column
GO
create trigger trgUpdatePersonID
on Person
after insert, update,delete
as begin 
        declare @PersonID int
		select @PersonID=PersonID from inserted 
		
		update  Address 
		set PersonID = @PersonID
	end
	GO



--inserting data into Genre table
Insert Into Genre ([Name] )
VALUES             
           ( 'Science Fiction'), ('Childrens'), ('History'),('Sciences'),('Encyclopedia'),('Dictionary'),('Travel'),('Drama'),('Horror'),('Health')
		   
--inserting data into Library inventory table

Insert Into LibraryInventory (Item ,Qty)
VALUES  
           ('Book', 400), ('Newspaper', 200),('Magazine',300),('Childrens Books', 500),('Best Seller',300),('DVD',400),('Music',700)

--inserting data into Address table

INSERT INTO [Address] (	 AddressLine1,City,[State],Zip)
VALUES
            ('73329 Longview Point','Melbourne', 'Florida','32941'),('14399 Fairfield Street', 'Washington', 'District of Columbia', '20420'),
			('5696 Grover Drive', 'Scranton', 'Pennsylvania', '18505'),( '7433 Bultman Parkway', 'Maple Plain', 'Minnesota', '55572'),
			('901 Lighthouse Bay Circle', 'Bronx', 'New York', '10464'),('89 Anhalt Road', 'Baton Rouge', 'Louisiana', '70883'),
			('979 Mendota Plaza', 'Tampa', 'Florida', '33605'),('108 Westend Park', 'Columbus', 'Georgia', '31998'),
			('80266 Loomis Park', 'Lancaster', 'California', '93584'), ('18 Shopko Park', 'Santa Monica', 'California', '90410'),('5244 Carpenter Junction', 'Iowa City', 'Iowa', '52245'),
            ('4 Welch Street', 'San Diego', 'California', '92176'),('87 Mayfield Hill', 'El Paso', 'Texas', '88584'),
            ('389 Bayside Road', 'Washington', 'District of Columbia', '20205'),('4500 4th Center', 'Sacramento', 'California', '95852'),
            ('6 Cottonwood Drive', 'Roanoke', 'Virginia', '24024'),('9 Pine View Alley', 'Reading', 'Pennsylvania', '19605'),
            ('83 Annamark Road', 'Saint Paul', 'Minnesota', '55188'),('1426 Holy Cross Plaza', 'Washington', 'District of Columbia', '20210'),
            ('562 Farmco Park', 'Santa Barbara', 'California', '93150'),('5168 Trailsway Lane', 'Newark', 'New Jersey', '07112'),
            ('0 Shelley Avenue', 'Detroit', 'Michigan', '48211'),('199 Anniversary Alley', 'Indianapolis', 'Indiana', '46266'),
            ('5178 Veith Court', 'Wichita', 'Kansas', '67210'),('57446 Texas Hill', 'Nashville', 'Tennessee', '37250'),
            ('9 Bonner Way', 'Memphis', 'Tennessee', '38114'),('982 Crest Line Terrace', 'Colorado Springs', 'Colorado', '80920'),
            ('089 Mandrake Alley', 'Spokane', 'Washington', '99252'),('8 Lerdahl Point', 'Santa Ana', 'California', '92725'),
            ('9 Gulseth Circle', 'Lexington', 'Kentucky', '40581')

	--inserting data into Person table
			
INSERT INTO Person (  LastName,FirstName,MI,Birthdate)
VALUES    
        ( 'Bradbury', 'Emma', 'A', '7/5/2017'),( 'Hegg', 'Flss', 'L', '4/21/2017'),( 'Glede', 'Stevena', 'N', '7/12/2017'),
        ( 'Blyden', 'Clareta', 'B', '7/14/2017'),( 'O''Halleghane', 'Tabina', 'A', '9/10/2017'),
        ( 'Ozanne', 'Andreana', 'A', '6/26/2017'),( 'Buzzing', 'Catlee', 'B', '8/3/2017'),
        ( 'Adanet', 'Christiane', 'P', '3/3/2017'),( 'Asp', 'Marrilee', 'T', '5/8/2017'),( 'Huckster', 'Charlie', 'A', '8/6/2017')

--inserting data into LibraryItem table
				    
INSERT INTO  LibraryItem (Title,PublicationDate,PublishingHouse)
 VALUES
        ('A History of Ancient Rome by Mary Beard',	'4/21/2010','Ink Smith Publisher')	  

--inserting dat into DisposedItem table

INSERT INTO  DisposedItem (Reason)	
VALUES
        ('Out of Date'),('Severly Damage')

--inserting data into DamageTypes table

INSERT INTO  DamageTypes (Description, Fee)
VALUES   
        ('Torn dust jacket', 6.00),('Distortion',20.00),('Torn leaves (paper)',9.00),('Ingrained stains',5.00)

	--inserting data into LibraryFeePolicy table

INSERT INTO LibraryFeePolicy (OverdueFeePerDay)
VALUES
        (1.00),(.50),(2.00),(1.50),(1.25),(2.50),(1.75)

		--inserting dat into phonetype table

INSERT INTO PhoneType (Type)
VALUES
         ('Cell'),('Home'),('Work')

		 --inserting data into phone table
INSERT INTO Phone (PhoneNumber)
VALUES 
         ('356-987-3356')




--creating a non clustered index on city and state column from address table

Create index Address_City_State
ON Address (City Asc,[State]desc)

--creating index lastname, firstname, and birthdate from person table 

create index Person_LastName_FirstName_BirthDate
ON   Person (LastName asc,FirstName asc,BirthDate desc)

--creating index on title, publication date, and publishing house from Library item table

create index LibraryItem_Title_PublicatioDate_PublishingHouse
ON LibraryItem(Title asc, PublicationDate desc,PublishingHouse asc)

--creating index on disposed date from disposed item table

create index DisposedItem_DisposedDate
ON DisposedItem (DisposedDate desc)

--creating index on email address from email address table
create index EmailAddress_EmailAddress
ON EmailAddress (EmailAddress asc)