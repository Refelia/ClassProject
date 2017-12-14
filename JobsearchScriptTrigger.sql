
USE MASTER 
IF (Select count(*) FROM sys.databases where name = 'Jobsearch')>0

BEGIN
DROP database Jobsearch
END

CREATE database Jobsearch
GO

USE Jobsearch
GO
CREATE TABLE BusinessTypes
(
       BusinessType varchar (255) not null, 
	    ModifiedDate datetime Default getdate(),
	   Primary Key (BusinessType),
	   constraint ModifiedDate check (ModifiedDate <=  getdate())
	   
)
GO
CREATE TABLE Companies
(
       CompanyID int not null Identity (100,1), 
	   CompanyName varchar (75) not null,
	   Address1 varchar (75) null,
	   Address2 varchar (75) null, 
	   City     varchar (50) null,
	   [State] varchar (2)  null,
 	   Zip     varchar(10) null,
	   Phone varchar (14)  null,
	   Fax    nvarchar(14) null,
	   Email nvarchar(50) null,
	   Website nvarchar (255) null,
	   [Description] varchar(255) null,
	   BusinessType  varchar (255)  null,
	   Agency bit null,
	   Primary key (CompanyID)
)

go
create trigger trgInsertCompanies
on Companies
after insert,update
as 
begin
 
if exists (select *
    from  inserted i
    where i.BusinessType not in (select BusinessType from BusinessTypes))
begin 
	Raiserror ('Businesstype does not exist in Companies',15,1)
	rollback transaction 
end
    else
	Print 'Added!'
end
GO



CREATE TABLE Sources
(
       SourceID int not null identity (1,1),
	   SourceName nvarchar(35) null,
	   SourceType nvarchar(75) null,
	   SourceLink nvarchar(355) null,
	   [Description] varchar(255) null,
	   Primary Key (SourceID),

)
GO
CREATE TABLE Contacts
(
       ContactID int not null Identity(100,1),
	   CompanyID int  null,
	   CourtesyTitle varchar(25) null,
	   ContactFirstName varchar(50) null,
	   ContactLastName  varchar(50) null,
	   Title varchar(50) DEFAULT null,
	   Phone varchar (14) DEFAULT null,
	   Extension varchar(10) DEFAULT null,
	   Fax varchar (14) DEFAULT null,
	   Email varchar (50) DEFAULT null,
	   Comments varchar(255) DEFAULT null,
	   Active bit constraint DF_Active DEFAULT (1),
	   Primary Key (ContactID)
	  
)
go
create trigger trgInsertContacts
on Contacts
after insert,update 
as 
begin

if exists (select *
    from  inserted i
    where i.CompanyID not in (select CompanyID from Companies))
	begin Raiserror ('CompanyID does not exist', 15,1)
	rollback transaction 
	end
	else 
	print 'Added!'
	
end
GO


GO
CREATE TABLE Lead
(
       LeadID int not null Identity (100,1),
	   RecordDate datetime not null Default (getdate()),
	   JobTitle varchar(75) not null,
	   [Description] varchar(255) null,
	   EmploymentType varchar(25) null constraint EmploymentType check (EmploymentType IN ('Full time', 'Part time', 'Seasonal')),
	   Location varchar(50) null,
	   Active bit not null Constraint Active CHECK ( Active IN (1,0)),
	   CompanyID int null,
	   AgencyID int null,
	   ContactID int null,
	   DocAttatchments varbinary(500) null,
	   SourceID int  null,
	   Selected bit  null,
	   Primary Key (LeadID) 


	   )
--go --trg lead - contacts
--create trigger trgInsertLead
--on Lead
--after insert,update,delete 
--as 
--begin
 
--if exists (select *
--    from  inserted i
--    where i.ContactID not in (select ContactID from Contacts))
--	begin Raiserror ('STOP!!!LeadID not found', 16,2)
--	rollback transaction 
--	end
	
--end
--GO

GO --trg lead - companies
create trigger trgLead_Companies
on Lead
after insert,update 
as 
begin
if exists (select *
    from  inserted i
    where i.CompanyID not in (select CompanyID from companies)) 
begin
  Raiserror ('The CompanyID does not exist in Lead',15,1)
    rollback transaction 
   end  
else
  print  'Added!'
end
GO

GO --trg lead - sources
create trigger trgLead_Sources
on Lead
after insert,update 
as 
begin
if exists (select *
    from Sources, inserted i
    where Sources.SourceID not in (select SourceID from Sources)) 
begin
  Raiserror ('The SourceID does not exist in Lead',15,1)
    rollback transaction 
   end  
else
  print  'Added!'
end
GO




CREATE TABLE Activities

(      ActivityID int not null identity (100,1),   
       LeadID int not null, 
	   ActivityDate datetime not null DEFAULT getdate(),        
	   ActivityType varchar(25) not null,
	   ActivityDetails varchar(255) null,
	   Complete bit not null default 0,
	   ReferenceLink nvarchar(100) null,
	   ModifiedBY varchar(75) not null CONSTRAINT DF_ModifiedBY DEFAULT (original_login()),
	   ModifiedDate datetime not null CONSTRAINT DF_ModifiedDate DEFAULT (getdate ()),
	   Primary key (ActivityID)
)
GO -- trgActivities - Lead
create trigger trgActivities
on Activities
after insert,update 
as 
begin
if exists (select *
    from  inserted i
    where i.LeadID not in (select LeadID from Lead)) 
begin
  Raiserror ('The LeadID does not exist in Lead',15,1)
    rollback transaction  
   end  
else
  print  'Added!'
end
GO




------INSERTS
INSERT INTO BusinessTypes (BusinessType)
VALUES 
       ('Advertising/Marketing'),
	   ('Agriculture'),('Architecture'),('Arts/Entertainment'),('Aviation'),('Beauty/Fitness'),
       ('Business Services'),('Communications'),('Computer/Hardware'),('Computer/Services'),('Computer/Software'),('Computer/Training'),
       ('Construction'),('Consulting'),('Crafts/Hobbies'),('Education'),('Electrical'),('Electronics'),('Employment'),('Engineering'),
       ('Environmental'),('Fashion'),('Financial'),('Food/Beverage'),('Government'),('Health/Medicine'),('Home & Garden'),('Immigration'),
       ('Import/Export'),('Industrial'),('Industrial Medicine'),('Information Services'),('Insurance'),('Internet'),('Legal & Law'),('Logistics'),
       ('Manufacturing'),('Mapping/Surveying'),('Marine/Maritime'),('Motor Vehicle'),('Multimedia'),('Network Marketing'),('News & Weather'),
       ('Non-Profit'),('Petrochemical'),('Pharmaceutical'),('Printing/Publishing'),('Real Estate'),('Restaurants'),('Restaurants Services'),
       ('Service Clubs'),('Service Industry'),('Shopping/Retail'),('Sports/Recreation'),('Storage/Warehousing'),('Technologies'),('Transportation'),
       ('Travel'),('Utilities'),('Venture Capital'),('Wholesale'),('Accounting')

--select * from Companies
INSERT INTO Companies (CompanyName,City,[State],Zip)
VALUES 
       ('Embrey-Riddle Aeronautical University','Daytona Beach','Fl', 32114),
	   ('Ebrey Riddle','Tampa','Fl',23414)



INSERT INTO Sources (SourceName,SourceType,SourceLink,[Description])
VALUES  
        ('Employ Florida','Online','www.employflorida.com/jobbanks/joblist.asp?session=jobsearch&geo',null)

--select * from Companies
INSERT INTO Contacts (CourtesyTitle,ContactFirstName,ContactLastName,Active)
	   
VALUES   ('Mr', 'Hegg', 'Flss',1),
         ('Ms','Glede', 'Stevena',1),
	     ('Mr', 'Huckster', 'Charlie',1),
		 ('Ms', 'Blyden', 'Clareta',1),
		 ('Ms', 'Ozanne', 'Andreana',1)

INSERT INTO Lead (JobTitle,[Description],Location,Active, Selected)
VALUES
       ('Database Developer', 'Maintining and creating production and sales reports', 'Ocala Florida',1,1),
       (' Data Analysis/Database Development', 'Analyze & document business & data requirements', 'Tampa, Florida',1,1),
	   (' SQL Developer', 'Collaborating with a team of  Engineers on back-end solutions', 'Boca Raton Florida', 1,1),
	   (' Campus Solution Sysmtem Analyst', 'Provide ongoing support and improvement of the university student', 'Daytona Beach Campus',1,1)



INSERT INTO Activities (LeadID, ActivityType,ActivityDetails,ReferenceLink)
     
 VALUES     (102,'test', 'testtest','www.www'),
            (103,'sample','testsample','http wwww.www')
	   

--INDEX

CREATE INDEX Companies_CompanyName_BusinessType
ON Companies (CompanyName ASC, BusinessType ASC)


CREATE INDEX Activities_ActivityType
ON Activities (ActivityType ASC)

CREATE INDEX Contacts_ContactFirstName_ContactLastName
ON Contacts (ContactFirstName ASC, ContactLastName ASC)

--TRIGGER
go
 Create trigger trgRecordUpdate
 ON Lead 
 AFTER INSERT 
 AS
 BEGIN
     INSERT INTO LEAD (RecordDate)
	 VALUES (GETDATE ())
 END
 GO
 
 create trigger trgActivityUpdate
on Activities
after update
as
begin
update Activities
set ActivityDate= (getdate())
	end
	go

create trigger trgActivityDateUpdate
 on Activities
 after update
 as 
 begin
 update Activities 
 set ActivityDate = getdate()
 from Activities 
 inner join inserted i
 on i.ActivityID= Activities.ActivityID
 end
 GO

 --trigger delete
 go
 create trigger trgLead_delete --LEAD
 ON Lead 
 After delete
 As
 Begin
     If exists ( select * from Activities s
	             join deleted d
				 on d.LeadID =s.LeadID)
Begin
        Raiserror ('Cannot delete Activities table referencing the LeadID from Lead', 15,2)
		rollback transaction
end
        ELSE
		PRINT 'Deleted'
end
go

GO
create trigger trgBusinesstypes_delete  ---BusinessTypes
ON BusinessTypes
After delete
as
Begin
       If exists (select * from Companies c
       join deleted d
	   on c.BusinessType = d.BusinessType)
Begin 
       Raiserror ('Cannot delete BusinessTypes, Companies Table referencing the BusinessType',16,3)
	   rollback transaction
end
end
GO

GO
create trigger trgCompanies_delete    --Companies
ON Companies
After delete
AS
BEGIN
     If exists (select * from Contacts c
	 Join deleted d
	 on c.CompanyID = d.CompanyID)
BEGIN
     Raiserror ('delete is not allowed!',16,3)
	 rollback transaction
end
end
GO

delete from Companies where CompanyID = 100
GO 
create trigger trgSources_delete   ---SOURCES
ON Sources
after delete
AS
Begin 
     If exists ( select * from Lead l
	 Join deleted d
	 on l.SourceID = d.SourceID)
BEGIN
     Raiserror ('Sorry, delete is not allowed',15,3)
	 Rollback transaction
end
end
GO

GO
CREATE TRIGGER trgContacts_delete   --Contacts
ON Contacts
AFTER delete 
AS
BEGIN
     If exists(select *  from Lead l
	 join deleted d
	 on l.ContactID = d.ContactID)
BEGIN 
     Raiserror ('STOP! check your child row',16,1)
	 Rollback transaction
end
     ELSE
PRINT 'Deleted'
end
GO



