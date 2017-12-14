
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
	    ModifiedDate datetime,
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
	   BusinessType  varchar (255) null,
	   Agency bit null,
	   Primary key (CompanyID),
	  constraint fk_BusinessTypes_Companies foreign key (BusinessType) references BusinessTypes(BusinessType)

)
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
	   Primary Key (ContactID),
	   constraint fk_Companies_Contacts foreign key (CompanyID) references Companies (CompanyID)
	  
)

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
	   AgencyID int  null,
	   ContactID int  null,
	   DocAttatchments varbinary(500) null,
	   SourceID int null,
	   Selected bit not null,
	   Primary Key (LeadID) ,

	   constraint fk_Contacts_Lead foreign key (ContactID) references Contacts(ContactID),
	   constraint fk_Companies_Lead foreign key (CompanyID) references Companies(CompanyID),
	   Constraint fk_Sources_Lead foreign key (SourceID) references Sources(SourceID),
	   Constraint Selected CHECK (Selected IN ('1','0')),
	   )
	 
GO
CREATE TABLE Activities

(      ActivityID int not null identity (100,1),   
       LeadID int not null, 
	   ActivityDate datetime not null,        
	   ActivityType varchar(25) not null,
	   ActivityDetails varchar(255) null,
	   Complete bit not null CONSTRAINT Complete CHECK (Complete IN ('Yes','No')),
	   ReferenceLink nvarchar(100) null,
	   ModifiedBY varchar(75) not null CONSTRAINT DF_ModifiedBY DEFAULT (original_login()),
	   ModifiedDate datetime not null CONSTRAINT DF_ModifiedDate DEFAULT (getdate ()),
	   Primary key (ActivityID),
	   constraint fk_Lead_Activities foreign key (LeadID) references Lead (LeadID)
)

GO

--INDEX

CREATE INDEX Companies_CompanyName_BusinessType
ON Companies (CompanyName ASC, BusinessType ASC)


CREATE INDEX Activities_ActivityType
ON Activities (ActivityType ASC)

CREATE INDEX Contacts_ContactFirstName_ContactLastName
ON Contacts (ContactFirstName ASC, ContactLastName ASC)

CREATE INDEX Sources_SourceName
ON Sources (SourceName ASC)




--INSERTS

INSERT INTO BusinessTypes (BusinessType)
VALUES 

('Accounting'),
('Advertising/Marketing'),
('Agriculture'),
('Architecture'),
('Arts/Entertainment'),
('Aviation'),
('Beauty/Fitness'),
('Business Services'),
('Communications'),
('Computer/Hardware'),
('Computer/Services'),
('Computer/Software'),
('Computer/Training'),
('Construction'),
('Consulting'),
('Crafts/Hobbies'),
('Education'),
('Electrical'),
('Electronics'),
('Employment'),
('Engineering'),
('Environmental'),
('Fashion'),
('Financial'),
('Food/Beverage'),
('Government'),
('Health/Medicine'),
('Home & Garden'),
('Immigration'),
('Import/Export'),
('Industrial'),
('Industrial Medicine'),
('Information Services'),
('Insurance'),
('Internet'),
('Legal & Law'),
('Logistics'),
('Manufacturing'),
('Mapping/Surveying'),
('Marine/Maritime'),
('Motor Vehicle'),
('Multimedia'),
('Network Marketing'),
('News & Weather'),
('Non-Profit'),
('Petrochemical'),
('Pharmaceutical'),
('Printing/Publishing'),
('Real Estate'),
('Restaurants'),
('Restaurants Services'),
('Service Clubs'),
('Service Industry'),
('Shopping/Retail'),
('Spiritual/Religious'),
('Sports/Recreation'),
('Storage/Warehousing'),
('Technologies'),
('Transportation'),
('Travel'),
('Utilities'),
('Venture Capital'),
('Wholesale')


INSERT INTO Companies (CompanyName,Address1,Address2,City,[State],Zip,Phone,Fax,Email,Website)
VALUES ('Embrey-Riddle Aeronautical University', null,null,'Daytona Beach','Fl', 32114,null,null,null,null)


INSERT INTO Lead (JobTitle,[Description],Location,Active,DocAttatchments, Selected)

VALUES ('Database Developer', 'Maintining and creating production and sales reports', 'Ocala, Florida',1, null,1),
       (' Data Analysis/Database Development', 'Analyze & document business & data requirements', 'Tampa, Florida',1,null,1),
	   (' SQL Developer', 'Collaborating with a team of  Engineers on back-end solutions', 'Boca Raton Florida', 1, null,1),
	   (' Campus Solution Sysmtem Analyst', 'Provide ongoing support and improvement of the university student', 'Daytona Beach Campus',1,null,1)

INSERT INTO Sources (SourceName,SourceType,SourceLink,[Description])

VALUES  ('Employ Florida','Online','www.employflorida.com/jobbanks/joblist.asp?session=jobsearch&geo',null)


INSERT INTO Contacts (CourtesyTitle,ContactFirstName,ContactLastName,Active)
	   
VALUES   ('Mr', 'Hegg', 'Flss',1),
         ('Ms','Glede', 'Stevena',1),
	     ('Mr', 'Huckster', 'Charlie',1),
		 ('Ms', 'Blyden', 'Clareta',1),
		 ('Ms', 'Ozanne', 'Andreana',1)
	   
	   


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