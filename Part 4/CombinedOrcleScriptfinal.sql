--Rays Rental database desgin

DROP SEQUENCE ENQUIRY_SEQUENCE;
DROP SEQUENCE PARTSORDERED_SEQUENCE;
DROP SEQUENCE Bike_Sequence;
DROP SEQUENCE Cust_Sequence;
DROP SEQUENCE Main_Sequence;
DROP SEQUENCE RESERVATION_SEQUENCE;

DROP TABLE RR_MAINTENANCE;
DROP TABLE RR_ORDERDETAILS;
DROP TABLE RR_PARTSORDERED;
DROP TABLE RR_PARTS;
DROP TABLE RR_RESERVATION;
DROP TABLE RR_ENQUIRY;
DROP TABLE RR_SELL;
DROP TABLE RR_BIKES;
DROP TABLE RR_STAFF;
DROP TABLE RR_LOCALDEALER;
DROP TABLE RR_SUPPLIERS;
DROP TABLE RR_MANUFACTURER;
DROP TABLE RR_DEPARTMENT;
DROP TABLE RR_CUSTOMER;



create table RR_CUSTOMER(
CustId NUMBER(10) Constraint CustIDPK PRIMARY KEY,
CustName Varchar2(25) Constraint CustNmNN NOT NULL,  
CustAddress Varchar2(60) Constraint CustAdrNN NOT NULL,
CustPostCode Varchar2(15) Constraint CustPCNN NOT NULL,
CustPhone Varchar2 (14) Constraint CustPhNN NOT NULL,
CustEmail VARCHAR2(40)
);

create table RR_DEPARTMENT(
DeptName VARCHAR2(30) constraint DeptNmPK PRIMARY KEY,
DeptManager VARCHAR2(30)
);

Create table RR_MANUFACTURER(
ManId VARCHAR2(3) Constraint ManIdPK PRIMARY KEY,
ManName VARCHAR2(25) Constraint ManNameNN NOT NULL,
ManAddress VARCHAR2(80) Constraint ManAddNN NOT NULL,
ManPostCode VARCHAR2(15) Constraint ManPCNN NOT NULL,
ManPhone VARCHAR2(20),
ManEmail VARCHAR2(40),
ManWebsite VARCHAR2(30)
);

Create table RR_SUPPLIERS(
SuppId NUMBER(3) Constraint SuppIdPK PRIMARY KEY,
SuppName VARCHAR2(25) Constraint SuppNmNN NOT NULL,
SuppAddress VARCHAR2(80) Constraint SuppAdrNN NOT NULL,
SuppPostcode VARCHAR2 (15) Constraint SuppPCNN NOT NULL,
SuppPhone VARCHAR2(14) Constraint SuppPhNNUQ NOT NULL UNIQUE 
);

Create table RR_LOCALDEALER(
LocalDealerId VARCHAR2(10) Constraint LocalDealerIdPK PRIMARY KEY,
LDName VARCHAR2(25) Constraint LDNmNN NOT NULL,
LDAddress VARCHAR2(60) Constraint LDAdrNN NOT NULL,
LDPostCode VARCHAR2(15) Constraint LDPCNN NOT NULL,
LDPhone VARCHAR2(14) Constraint LDPhone NOT NULL
);

create table RR_BIKES(
BikeId NUMBER(6) Constraint BikeIdPK PRIMARY KEY,
BikeModel VARCHAR2(20) Constraint BikeModelNNChk NOT NULL,
BikeClassification VARCHAR2(10) Constraint BikeClassChk CHECK(BikeClassification in('Mountain','Road','Tandem')),
BikeSize VARCHAR2(15) CONSTRAINT BikeSizeChk CHECK(BikeSize IN ('large male','standard male','small male','standard female','child')),
BikeDOP DATE Constraint BikeDOPNN NOT NULL,
BikeCost NUMBER(6,2) Constraint BikeCstChk check(BikeCost>0),
BikeRentCost NUMBER(4,2) NOT NULL,
LocalDealerId VARCHAR2(10), foreign key (LocalDealerId) references RR_LOCALDEALER (LocalDealerId),
ManId VARCHAR2(3),  foreign key (ManId) references RR_MANUFACTURER(ManId)
);

Create table RR_SELL(
BikeId NUMBER(6),
LocalDealerId VARCHAR2(10),  
SaleAmount NUMBER(6,2) Constraint SellSAmtChk CHECK (SaleAmount>=0),
SaleDate DATE,
PRIMARY KEY(BikeId,LocalDealerId)
);

create table RR_STAFF(
StaffId NUMBER(5) constraint StfIdPK PRIMARY KEY,
StaffName VARCHAR2(30) constraint StfNmNN NOT NULL,
StaffAddress VARCHAR2(60) constraint StfAdrsNN NOT NULL,
StaffPostCode VARCHAR2(15) constraint StfPCNN NOT NULL, 
StaffPhone VARCHAR2(20) constraint StfPhNN NOT NULL,
HireDate DATE constraint StfHDtNN NOT NULL,
DeptName Varchar(30), FOREIGN KEY(DeptName) REFERENCES RR_DEPARTMENT(DeptName)
);

create table RR_ENQUIRY(
EnquiryId NUMBER(10) Constraint EnqIDPK PRIMARY KEY,
EnquiryDateNTime DATE Constraint EnqDtNN NOT NULL ,
EnquiryPeriod NUMBER(1) Constraint EnqPrdNN NOT NULL,
StaffId Number(5), FOREIGN KEY(StaffId) References RR_Staff(StaffId),
CustId Number (10),  FOREIGN KEY(CustId) References RR_Customer(CustId)
);

create table RR_RESERVATION(
BikeId NUMBER(6),FOREIGN KEY (BikeId)REFERENCES RR_BIKES(BikeId),
RentDateAndTime DATE,
TimeBackDue DATE, 
TimeBackActual DATE,
RentPeriod NUMBER(2)  DEFAULT '1' constraint ResrvRntPrdNN NOT NULL,
RentPaid CHAR (1) DEFAULT 'N' CONSTRAINT ResrvRntPdCk CHECK (RentPaid IN('Y','N')),
PaymentType VARCHAR2 (15) CONSTRAINT InvPyTypChk Check (paymentType in('Cash','card', 'cheque')),
PaymentRefNo NUMBER(10),
StaffId NUMBER(5 ),FOREIGN KEY (StaffId)REFERENCES RR_STAFF(StaffId),
CustId NUMBER(10), FOREIGN KEY(CustId) REFERENCES RR_CUSTOMER(CustId),
PRIMARY KEY(BikeId, RentDateAndTime) 
);

create table RR_PARTS(
PartId NUMBER(4) Constraint PartIdPK PRIMARY KEY,
PartName VARCHAR2(25) Constraint PartNmNN NOT NULL, 
PartDescription VARCHAR2(60), 
PartCost NUMBER(6,2) Constraint PartCostChk check(PartCost>0),
StockLevel NUMBER(3),
ReOrderLevel NUMBER(2),
UnitsOnOrder NUMBER(3),
SuppId NUMBER(3), FOREIGN KEY (SuppId) REFERENCES RR_SUPPLIERS (SuppId), 
ManId Varchar2(3), FOREIGN KEY(ManId) REFERENCES RR_MANUFACTURER (ManId)
);

create table RR_PARTSORDERED(
OrderNo NUMBER(10) Constraint PartsOrderNoPK PRIMARY KEY, 
OrderDate DATE,
DeliveryExpectedDate DATE,
SuppId NUMBER(3), FOREIGN KEY(SuppId) REFERENCES RR_SUPPLIERS (SuppId),
ManId Varchar2(3),FOREIGN KEY(ManId) REFERENCES RR_MANUFACTURER (ManId)
);

create table RR_ORDERDETAILS(
OrderNo NUMBER(10), FOREIGN KEY(OrderNo) REFERENCES RR_PARTSORDERED (OrderNo),
PartId NUMBER(3), FOREIGN KEY(PartId) REFERENCES RR_PARTS (PartId),
OrderQuantity NUMBER(3) Constraint OrderDetQtyChk CHECK(OrderQuantity > 0),  
ReceivedQuantity NUMBER(3),
OrderReceivedDate DATE,
DeliveryNo VARCHAR2(15),
Comments VARCHAR(50),
PRIMARY KEY(OrderNo, PartId)
);

create table RR_MAINTENANCE(
MaintenanceId NUMBER(10) PRIMARY KEY,
BikeFault VARCHAR2(30),
DateReported DATE, 
DateActioned DATE,
ActionTaken VARCHAR2(30),
PartQuantity NUMBER(2),
PartId NUMBER(4),foreign key (PartId) references RR_Parts(PartId),
BikeId NUMBER(6),Foreign key(BikeId) references RR_Bikes(BikeId) 
);



CREATE SEQUENCE Cust_Sequence START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000000;

INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Omar Alobaidi', '3 Harrow Avenue, Hollinwood, Oldham','OL8 4HZ','0161 6285698', 'oalobaidi@yahoo.com');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Martyn Amos', '116 Oxford Road, Werneth, Oldham','OL9 7SJ','0161 624 9700', 'm.amos@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Andrew Attwood', '70 Delamere Road, Levenshulme, Manchester','M19 3WR','0161 2256748', 'a.attwood@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Marie Carroll', '92 Harrow Avenue, Hollinwood, Oldham','OL8 4HZ','0161 6285698', 'm.carroll@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Nicholas Costen', '3 Ford Lane, Wythenshawe, Manchester, UK','M22 4WE','0161 6276436', 'n.costen@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Alan Crispin', '19 Stamford Road, Manchester, Manchester, UK','M13 0SE','0161 2256749', 'a.crispin@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Matthew Crossley', '12-14 Lodge Street, Middleton, Manchester, UK','M24 6AL','0161 2242770', 'm.crossley@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Slivester Czanner', '4 Harling Road, Wythenshawe, Manchester, UK','M22 4UZ','0161 2252785', 's.czanner@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'John Darby', '19 Lansdowne Avenue, Audenshaw, Manchester, UK','M34 5SZ','0161 2265834', 'j.darby@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Luciano Gerber', '4 Victory Grove, Audenshaw, Manchester, UK','M34 5XA','0161 2269432', 'l.gerber@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Huw Lloyd', '19 Granada Road, Denton, Manchester, UK','M34 2LL','0161 226723', 'huw.lloyd@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'David McLean', '22A Stoneyside Avenue, Worsley, Manchester, UK','M28 3PE','0161 2274572', 'd.mclean@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Ruth Meyer', '72 Market Street, Manchester, Manchester, UK','M25 9TE','0161 2287872', 'r.meyer@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Maybin Muyeba', '212 River View Close, Prestwich, Manchester, UK','M20 1PL','0161 22965872', 'm.muyeba@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Kevin Tan', '62 Rudheath Avenue, Manchester, Manchester, UK','M21 7NE','0161 22454872', 'k.tan@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Leigh Travis', '15 Grindley Avenue, Manchester, Manchester, UK','M23 9DW','0161 2269872', 'l.travis@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Brian Wendl', '16 Stansfield Road, Failsworth, Manchester, UK','M35 9EA','0161 4685564', 'b.wendl@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Moi-Hoon Yap', '36 Ascot Road, Manchester, Manchester, UK','M40 2TZ','0161 9723412', 'm.yap@mmu.ac.uk');
INSERT INTO RR_Customer VALUES (
Cust_Sequence.nextval, 'Keith Yates', '9 Melton Street, Radcliffe, Manchester, UK','M26 4BJ','0161 5678123', 'k.yates@mmu.ac.uk');


INSERT INTO RR_Department
VALUES ('Boss', 'Ray');
INSERT INTO RR_Department
VALUES ('Hirings', 'Pete');
INSERT INTO RR_Department
VALUES ('Maintenence', 'Alf');
INSERT INTO RR_Department
VALUES ('Parts', 'Paul');


INSERT INTO RR_Manufacturer
VALUES ('101', 'Merida', 'Unit 13 Nott`m Sth. Wilford Ind. Est. Ruddigton Lane Wilford Nottingham', 'NG11 7EP',  '+44(0)1159817788', 'merida@meridauk.com', 'www.merida-bikes.com');
INSERT INTO RR_Manufacturer
VALUES ('102', 'Raleigh', ' ', ' ', '01773 532600', 'info@raleigh.co.uk', 'http://www.raleigh.co.uk/');
INSERT INTO RR_Manufacturer
VALUES ('103', 'Giant', 'Charnwood Edge, Syston Road, Cossington, Leicester', 'LE7 4UZ', '0844 245 9030', 'info@giant-bicycles.com/', 'http://www.giant-bicycles.com/');
INSERT INTO RR_Manufacturer
VALUES ('104', 'Tandem Group PLC', '35 Tameside Drive, Castle Bromwich, Birmingham', 'B35 7AG', '+44 (0)121 748 8075', 'info@tandemgroup.co.uk', 'http://tandemgroupplc.co.uk/');
INSERT INTO RR_Manufacturer
VALUES ('105', 'Pashley Cycles', 'Stratford-Upon-Avon, Warwickshire', 'CV37 9NL', '+44 (0)1789 292 263', 'hello@pashley.co.uk', 'http://www.pashley.co.uk/');
INSERT INTO RR_Manufacturer
VALUES ('106', 'Genesis', ' ', ' ', ' ', 'http://www.genesisbikes.co.uk/contact', 'http://www.genesisbikes.co.uk');


INSERT INTO RR_SUPPLIERS 
VALUES (101, 'M + J DISTRIBUTORS LTD', 'UNIT A, HANIX BUILDINGS , WINDMILL LANE, DENTON , MANCHESTER', 'M34 3SP',  '0161 337 9600');
INSERT INTO RR_SUPPLIERS
VALUES (102, 'Reece Cycles', '100 Alcester Street Birmingham', 'B12 0QB', '0121 622 0180');
INSERT INTO RR_SUPPLIERS
VALUES (103, 'Cycle Division Ltd', 'Unit 27 Gatehouse Enterprise Centre, Albert Street, Lockwood Huddersfield', 'HD1 3QD', '0845 0508 500');
INSERT INTO RR_SUPPLIERS
VALUES (104, 'Ison Distribution Ltd', '201 Lancaster Way, Business Park, Ely, Cambridgeshire.', 'CB6 3NX', '0845 0507 500');
INSERT INTO RR_SUPPLIERS
VALUES (105, 'Hykeham Wholesale Ltd', 'Unit 7, Earlsfield Close, Sadler Road, Lincoln', 'LN6 3RT', '01522 801550');
INSERT INTO RR_SUPPLIERS
VALUES (106, 'Haven Distribution ', '2 Red Kiln Close, Horsham, West Sussex Manchester ', 'RH13 5Q', '07827 797044');


INSERT INTO RR_LocalDealer 
VALUES ('BCH1001M4', 'Bishopthorpe Cycle Hire', 'Unit 3 Manchester Road, Newton Health, Manchester', 'M40 2EP',  '0161 912 8300');
INSERT INTO RR_LocalDealer
VALUES ('GCH1001M21', 'Grimsby Cycle Hub', '68-70 Dickenson Road, Manchester ', 'M21 7LA', '0161 224 1303');
INSERT INTO RR_LocalDealer
VALUES ('SC1001M16', 'Snowdonia Cycles', '26 Burton Road, Manchester', 'M16 5LW', '0161 4453492');
INSERT INTO RR_LocalDealer
VALUES ('CBH1001M20', 'Cheltenham Bike Hire', '5 Lane End Road, Manchester', 'M20 1AL', '0161 431 0777');
INSERT INTO RR_LocalDealer
VALUES ('BC1001SK5', 'Bourton Cycles', '201 Houldsworth Mill Waterhouse Way, Reddish, Stockport', 'SK5 9NL', '07940 859672');
INSERT INTO RR_LocalDealer
VALUES ('KCH100M14', 'Kool Cycle Hire ', '7 Wilmslow Road Manchester ', 'M14 5LW ', '0161 2573897');


CREATE SEQUENCE Bike_Sequence START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000000;


INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Big.Nine 300', 'Mountain', 'large male', '12-Apr-11', 250.00, 5,'BCH1001M4', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Big.Nine 300', 'Mountain', 'large male', '12-Apr-11', 250.00, 5,'GCH1001M21', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Big.Nine 300', 'Mountain', 'large male', '12-Apr-11', 250.00, 5,'BC1001SK5', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Big.Nine 300', 'Mountain', 'large male', '12-Apr-11', 250.00, 5,'SC1001M16', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Big.Nine 300', 'Mountain', 'large male', '12-Apr-11', 250.00, 5,'CBH1001M20', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Reacto 400', 'Road', 'large male', '15-May-11', 300.00, 5,'GCH1001M21', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Reacto 400', 'Road', 'large male', '15-May-11', 300.00, 5,'KCH100M14', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Reacto 400', 'Road', 'large male', '15-May-11', 300.00, 5,'GCH1001M21', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Misceao 2.0', 'Mountain', 'standard male', '26-Mar-12', 200.00, 5, 'SC1001M16', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Misceao 2.0', 'Mountain', 'standard male', '26-Mar-12', 200.00, 5, 'CBH1001M20', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Misceao 2.0', 'Mountain', 'standard male', '26-Mar-12', 200.00, 5, 'KCH100M14', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Misceao 2.0', 'Mountain', 'standard male', '26-Mar-12', 200.00, 5, 'CBH1001M20', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Misceao 2.0', 'Mountain', 'standard male', '26-Mar-12', 200.00, 5, 'GCH1001M21', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Big.Nine 300', 'Mountain', 'large male', '12-Apr-13', 250.00, 5,'', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Big.Nine 300', 'Mountain', 'large male', '12-Apr-13', 250.00, 5,'', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Big.Nine 300', 'Mountain', 'large male', '12-Apr-13', 250.00, 5,'', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Big.Nine 300', 'Mountain', 'standard male', '12-Apr-13', 250.00, 5,'', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Big.Nine 300', 'Mountain', 'large male', '12-Apr-13', 250.00, 5,'', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Duet Twin', 'Tandem', '', '10-May-13', 800.00, 8, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Duet Twin', 'Tandem', '', '10-May-13', 800.00, 8, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Duet Twin', 'Tandem', '', '10-May-13', 800.00, 8, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Duet Twin', 'Tandem', '', '10-May-13', 800.00, 8, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Duet Twin', 'Tandem', '', '10-May-13', 800.00, 8, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Reacto 400', 'Road', 'large male', '15-May-13', 300.00, 5,'', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Reacto 400', 'Road', 'large male', '15-May-13', 300.00, 5,'', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Reacto 400', 'Road', 'large male', '15-May-13', 300.00, 5,'', '101');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Royal', 'Road', 'standard male', '10-Jun-13', 400.00, 6, '', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Royal', 'Road', 'standard male', '10-Jun-13', 400.00, 6, '', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Royal', 'Road', 'standard male', '10-Jun-13', 400.00, 6, '', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Sonnet Bliss', 'Road', 'standard female', '02-Aug-13', 500.00, 5, '', '105');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Sonnet Bliss', 'Road', 'standard female', '02-Aug-13', 500.00, 5, '', '105');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Sonnet Bliss', 'Road', 'standard female', '02-Aug-13', 500.00, 5, '', '105');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Lightning Boys', 'Mountain', 'child', '08-Mar-14', 170.00, 3, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Lightning Boys', 'Mountain', 'child', '08-Mar-14', 170.00, 3, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Lightning Boys', 'Mountain', 'child', '08-Mar-14', 170.00, 3, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Venus Girls', 'Mountain', 'child', '08-Mar-14', 170.00, 3, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Venus Girls', 'Mountain', 'child', '08-Mar-14', 170.00, 3, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Dawes Venus Girls', 'Mountain', 'child', '08-Mar-14', 170.00, 3, '', '104');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Misceao 2.0', 'Mountain', 'standard male', '26-Mar-14', 200.00, 5, '', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Misceao 2.0', 'Mountain', 'standard male', '26-Mar-14', 200.00, 5, '', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Misceao 2.0', 'Mountain', 'standard male', '26-Mar-14', 200.00, 5, '', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Misceao 2.0', 'Mountain', 'standard male', '26-Mar-14', 200.00, 5, '', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Misceao 2.0', 'Mountain', 'standard male', '26-Mar-14', 200.00, 5, '', '102');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Core 10', 'Mountain', 'small male', '17-Apr-14', 550.00, 5, '', '106');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Core 10', 'Mountain', 'small male', '17-Apr-14', 550.00, 5, '', '106');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Core 10', 'Mountain', 'small male', '17-Apr-14', 550.00, 5, '', '106');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Core 10', 'Mountain', 'small male', '17-Apr-14', 550.00, 5, '', '106');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Core 10', 'Mountain', 'small male', '17-Apr-14', 550.00, 5, '', '106');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Cypress W', 'Road', 'standard female', '05-May-14', 370.00, 5, '', '103');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Cypress W', 'Road', 'standard female', '05-May-14', 370.00, 5, '', '103');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Cypress W', 'Road', 'standard female', '05-May-14', 370.00, 5, '', '103');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Cypress W', 'Road', 'standard female', '07-May-14', 370.00, 5, '', '103');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Cypress', 'Road', 'small male', '05-Jul-14', 370.00, 5, '', '103');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Cypress', 'Road', 'small male', '05-Jul-14', 370.00, 5, '', '103');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Cypress', 'Road', 'small male', '05-Jul-14', 370.00, 5, '', '103');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Cypress', 'Road', 'small male', '05-Jul-14', 370.00, 5, '', '103');
INSERT INTO RR_Bikes
VALUES (Bike_Sequence.nextval, 'Cypress', 'Road', 'small male', '05-Jul-14', 370.00, 5, '', '103');





INSERT INTO RR_SELL
VALUES (1,'BCH1001M4',78.50,'30-APR-13');
INSERT INTO RR_SELL
VALUES (2,'BCH1001M4',63.50,'30-APR-13');
INSERT INTO RR_SELL
VALUES (3,'GCH1001M21',48.50,'03-APR-13');
INSERT INTO RR_SELL
VALUES (4,'SC1001M16',38.50,'30-APR-13');
INSERT INTO RR_SELL
VALUES (5,'CBH1001M20',63.50,'12-APR-13');
INSERT INTO RR_SELL
VALUES (6,'BC1001SK5',48.50,'03-MAY-13');
INSERT INTO RR_SELL
VALUES (7,'KCH100M14',28.50,'30-MAY-13');
INSERT INTO RR_SELL
VALUES (8,'BCH1001M4',53.50,'13-JUN-13');
INSERT INTO RR_SELL
VALUES (9,'GCH1001M21',48.50,'21-JUN-14');
INSERT INTO RR_SELL
VALUES (10,'SC1001M16',36.00,'30-JUN-14');
INSERT INTO RR_SELL
VALUES (11,'CBH1001M20',43.50,'30-JUN-14');



INSERT INTO RR_Staff
VALUES (10001, 'Ray', '12 Broadfield Road, Manchester, Manchester', 'M14 4WF', '0161 5564679', '12-Jun-99', 'Boss');
INSERT INTO RR_Staff
VALUES (10002, 'Pete', '22 Bransby Avenue, Manchester, Manchester', 'M9 6JN', '0161 469733', '17-Jun-03', 'Hirings');
INSERT INTO RR_Staff
VALUES (10003, 'Sheila', '12 Wharfside Avenue, Eccles, Manchester', 'M30 0BW', '0161 118524','24-May-05', 'Hirings');
INSERT INTO RR_Staff
VALUES (10004, 'Megan', '16 Caldy Road, Salford, Salford', 'M6 7FU', '0161 876412', '18-Jul-13', 'Hirings');
INSERT INTO RR_Staff
VALUES (10005, 'Alf', '89 Oscar Street, Manchester, Manchester', 'M40 9EG', '0161 895623', '15-Aug-01', 'Maintenence');
INSERT INTO RR_Staff
VALUES (10006, 'Bert', '56 Egerton Street, Prestwich, Manchester', 'M25 1FH', '0161 784512', '21-Apr-05', 'Maintenence');
INSERT INTO RR_Staff
VALUES (10007, 'Paul', '214 Wilbraham Road, Manchester, Manchester', 'M16, UK', '0161 794613', '15-Mar-05', 'Parts');


INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,SuppId)
VALUES (101,'Inner Tubes','FWE 700c Presta Valve Inner Tube',4.99,20,5,10,101);
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,SuppId)
VALUES (102,'Tyres','Continental Gatorskin 700C Duraskin Wired Road Tyre',29.95,10,4,8,101);
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (103,'Wheels','Shimano Ultegra 6800 Tubeless Ready Wheelset',263.20,20,5,10,'101');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,SuppId)
VALUES (104,'Wheels','Mavic Aksium One Disc 700C Front Road Wheel',67.50,10,5,10,101);
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,SuppId)
VALUES (105,'Inner Tubes','FWE 700c Presta Valve Inner Tube',4.99,20,5,10,101);
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,SuppId)
VALUES (106,'Pedals ','Shimano R540 SPD SL Road Pedals (OE)',21.99,20,5,10,101);
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,SuppId)
VALUES (107,'Pedals','Look Keo Grip Cleats OE',11.99,20,5,10,101);
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (108,'Cassettes + Freewheels','Shimano Ultegra 6700 10-speed Cassette',38.39,30,5,10,'101');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (109,'Cassettes + Freewheels','Campagnolo Veloce 10spd Cassette',33.5,3,1,10,'101');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (110,'Chains','Shimano Dura-Ace 7900 10 Speed Chain',34.99,5,3,1,'102');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (111,'Chains','KMC X11L 11-speed Gold Chain',35.99,20,5,10,'101');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (112,'Chainrings','Shimano FC-M590 Deore 4-Arm Chainring',11.49,10,4,3,'103');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,SuppId)
VALUES (113,'Saddles','Fizik Vesta Kium Women''s Saddle',62.99,20,5,10,104);
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,SuppId)
VALUES (114,'Saddles','Adamo by ISM Prologue Saddle',103.99,20,5,10,103);
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,SuppId)
VALUES (115,'Brakes','SRAM Force Brake Set',84.90,5,2,1,105);
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (116,'Brakes','Jagwire V-Brake Blocks',2.15,30,5,10,'101');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (117,'Cables','Clarks Pre-Lube Universal Brake Inner Cable - 2100mm',6.49,3,1,10,'101');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (118,'Cables','FWE Campagnolo Inner Brake Cable',4.99,5,3,1,'102');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,SuppId)
VALUES (119,'Rims','Stans No Tubes ZTR Alpha 400 Disc Rim',81.00,5,2,1,'102');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (120,'Brakes','DT Swiss TK 540 700c Touring Rim',38.39,30,5,10,'101');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (121,'Groupsets ','SRAM Force 22 Groupset',299.49,3,1,10,'101');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (122,'Groupsets ','SRAM Red 22 Groupset',678.99,5,3,1,'102');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (123,'Headsets ','FSA Orbit CE Headset',23.99,5,3,1,'102');
INSERT INTO RR_PARTS(PartId,PartName,PartDescription,PartCost,StockLevel,ReOrderLevel,UnitsOnOrder,ManId)
VALUES (124,'Gear Cable','Jagwire gear cable',1.25,5,3,1,'102');


CREATE SEQUENCE PARTSORDERED_SEQUENCE
START WITH 1 MINVALUE 1 MAXVALUE 10000000 INCREMENT BY 1;

INSERT INTO RR_PARTSORDERED
VALUES(PARTSORDERED_SEQUENCE.NEXTVAL,'06-JUN-14', '10-JUN-14',103,'104');
INSERT INTO RR_PARTSORDERED
VALUES(PARTSORDERED_SEQUENCE.NEXTVAL,'01-JUL-14', '10-JUL-14',102,'103');
INSERT INTO RR_PARTSORDERED
VALUES(PARTSORDERED_SEQUENCE.NEXTVAL,'03-AUG-14', '05-AUG-14',101,'101');
INSERT INTO RR_PARTSORDERED
VALUES(PARTSORDERED_SEQUENCE.NEXTVAL,'07-SEP-14', '09-SEP-14',105,'105');
INSERT INTO RR_PARTSORDERED
VALUES(PARTSORDERED_SEQUENCE.NEXTVAL,'11-SEP-14', '16-SEP-14',106,'102');
INSERT INTO RR_PARTSORDERED
VALUES(PARTSORDERED_SEQUENCE.NEXTVAL,'12-OCT-14', '15-OCT-14',105,'104');
INSERT INTO RR_PARTSORDERED
VALUES(PARTSORDERED_SEQUENCE.NEXTVAL,'13-DEC-14', '20-DEC-14',102,'106');
INSERT INTO RR_PARTSORDERED
VALUES(PARTSORDERED_SEQUENCE.NEXTVAL,'30-DEC-14', '04-JAN-15',106,'105');
INSERT INTO RR_PARTSORDERED
VALUES(PARTSORDERED_SEQUENCE.NEXTVAL,'06-JAN-15', '11-JAN-15',103,'103');
INSERT INTO RR_PARTSORDERED
VALUES(PARTSORDERED_SEQUENCE.NEXTVAL,'25-JAN-15', '30-JAN-15',102,'106');



INSERT INTO RR_ORDERDETAILS 
VALUES(1, 101 , 2, 2,  '9-JUN-14' ,'D687' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(2, 103, 7, 6,  '11-JUL-14' ,'D234' , 'ONE WHEEL HAS VALVE MISSING');
INSERT INTO RR_ORDERDETAILS
VALUES(3, 104, 1, 1,  '05-AUG-14' ,'D543' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(4, 102, 19, 19,  '09-SEP-14' ,'D111' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(5, 105, 10, 10,  '18-SEP-14' ,'D233' , 'SENT 9 60MM VALVES AND 1 48MM VALVES');
INSERT INTO RR_ORDERDETAILS
VALUES(6, 106, 12, 11,  '14-OCT-14' ,'D656' , 'ONE SET OF PEDALS SHORT');
INSERT INTO RR_ORDERDETAILS
VALUES(7, 109, 3, 3,  '21-DEC-14' ,'D645' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(8, 107, 9, 9,  '3-JAN-15' ,'D666' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(9, 110, 4, 4,  '12-JAN-15' ,'D976' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(10, 111, 12, 12,  '31-JAN-15' ,'D956' , 'ALL PARTS RECIEVED');
/*INSERT INTO RR_ORDERDETAILS
VALUES(11, 112, 5, 5,  '12-FEB-13' ,'D999' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(12, 114, 7, 7,  '21-FEB-13' ,'D456' , 'ONE ITEM BROKEN');
INSERT INTO RR_ORDERDETAILS
VALUES(13, 115, 6, 6,  '26-FEB-13' ,'D343' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(14, 108, 4, 5,  '12-OCT-14' ,'D933' , 'RECIEVED EXTRA ITEM');
INSERT INTO RR_ORDERDETAILS
VALUES(15, 116, 4, 4,  '12-DEC-14' ,'D923' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(16, 118, 1, 1,  '26-DEC-14' ,'D936' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(17, 119, 8, 8,  '30-DEC-14' ,'D977' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(18, 120, 4, 4,  '12-JAN-15','D944' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(19, 121, 4, 4, '22-JAN-15' ,'D346' , 'ALL PARTS RECIEVED');
INSERT INTO RR_ORDERDETAILS
VALUES(20, 122, 1, 1,  '26-JAN-15','D976' , 'ALL PARTS RECIEVED');*/



CREATE SEQUENCE Main_Sequence START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000000;

INSERT INTO RR_Maintenance
VALUES (Main_Sequence.nextval, 'Puncture repair', '15-Feb-14', '16-Feb-14', 'New inner tube', 1, 101, 10);
INSERT INTO RR_Maintenance(maintenanceid, bikefault, datereported, dateactioned, actiontaken, partquantity, bikeid)
VALUES (Main_Sequence.nextval, 'Tyre repair', '18-Feb-14', '19-Feb-14', 'Pumped tyre', 2, 16);
INSERT INTO RR_Maintenance
VALUES (Main_Sequence.nextval, 'brake repair', '25-Feb-14', '26-Feb-14', 'New brakes', 1, 116, 14);
INSERT INTO RR_Maintenance
VALUES (Main_Sequence.nextval, 'Saddle repair', '01-Mar-14', '02-Mar-14', 'Fitted new saddle', 1, 113, 12);
INSERT INTO RR_Maintenance(maintenanceid, bikefault, datereported, dateactioned, actiontaken, partquantity, bikeid)
VALUES (Main_Sequence.nextval, 'Chain repair', '15-Mar-14', '16-Mar-14', 'Corrected chain', 1, 21);
INSERT INTO RR_Maintenance
VALUES (Main_Sequence.nextval, 'Headset repair', '10-May-14', '12-May-14', 'New Headset', 1, 123, 15);
INSERT INTO RR_Maintenance
VALUES (Main_Sequence.nextval, 'Pedals repair', '15-May-14', '16-May-14', 'Fixed pedals',2, 106, 17);
INSERT INTO RR_Maintenance
VALUES (Main_Sequence.nextval, 'Framewheel repair', '20-June-14', '21-June-14', 'New framewheel', 1, 103, 35);
INSERT INTO RR_Maintenance
VALUES (Main_Sequence.nextval, 'Gear cable repair', '15-July-14', '16-July-14', 'New Gear cable', 1, 124, 11);
INSERT INTO RR_Maintenance
VALUES (Main_Sequence.nextval, 'Seat tube repair', '21-August-14', '22-August-14', 'New seat tube', 1, 114, 40);
INSERT INTO RR_Maintenance
VALUES (Main_Sequence.nextval, 'Headset repair', '30-August-14', '31-August-14', 'New Headset', 1, 123, 22);
INSERT INTO RR_Maintenance
VALUES (Main_Sequence.nextval, 'Framewheel repair', '31-August-14', '01-September-14', 'New framewheel', 1, 103, 9);


CREATE SEQUENCE RESERVATION_SEQUENCE
start with 1 minvalue 1 maxvalue 9999999999 nocycle increment by 1;

INSERT INTO RR_RESERVATION 
VALUES(23,to_date('15-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('15-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('15-AUG-14 12:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,10); -- customer 1 to 19  staff 10002,3 and 4
INSERT INTO RR_RESERVATION 
VALUES(24,to_date('15-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('15-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('15-AUG-14 12:55:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,1);
INSERT INTO RR_RESERVATION 
VALUES(25,to_date('15-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('15-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('15-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,12);
INSERT INTO RR_RESERVATION 
VALUES(33,to_date('16-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('16-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('16-AUG-14 12:50:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,4);
INSERT INTO RR_RESERVATION 
VALUES(40,to_date('16-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('16-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('16-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10002,19);
INSERT INTO RR_RESERVATION 
VALUES(37,to_date('17-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('17-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('17-AUG-14 16:55:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10004,15);
INSERT INTO RR_RESERVATION 
VALUES(25,to_date('17-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('17-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('17-AUG-14 16:50:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,4);
INSERT INTO RR_RESERVATION 
VALUES(27,to_date('17-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('17-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('17-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,7);
INSERT INTO RR_RESERVATION 
VALUES(28,to_date('18-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('18-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('18-AUG-14 12:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,15);
INSERT INTO RR_RESERVATION 
VALUES(38,to_date('18-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('19-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('19-AUG-14 16:55:30','dd-mon-yy HH24:MI:SS'),4,'Y','Cash',reservation_sequence.nextval,10004,18);
INSERT INTO RR_RESERVATION 
VALUES(39,to_date('19-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('19-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('19-AUG-14 12:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,19);
INSERT INTO RR_RESERVATION 
VALUES(32,to_date('19-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('19-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('19-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10002,16);
INSERT INTO RR_RESERVATION 
VALUES(34,to_date('19-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('20-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('20-AUG-14 16:55:30','dd-mon-yy HH24:MI:SS'),3,'Y','Cash',reservation_sequence.nextval,10003,6);
INSERT INTO RR_RESERVATION 
VALUES(37,to_date('20-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('20-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('20-AUG-14 12:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,8);
INSERT INTO RR_RESERVATION 
VALUES(41,to_date('20-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('20-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('20-AUG-14 16:50:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,12);
INSERT INTO RR_RESERVATION 
VALUES(42,to_date('20-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('20-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('20-AUG-14 16:50:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10004,11);
INSERT INTO RR_RESERVATION 
VALUES(33,to_date('21-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('21-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('21-AUG-14 12:50:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,10);
INSERT INTO RR_RESERVATION 
VALUES(36,to_date('21-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('21-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('21-AUG-14 12:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,9);
INSERT INTO RR_RESERVATION 
VALUES(37,to_date('21-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('21-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('21-AUG-14 12:55:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,2);
INSERT INTO RR_RESERVATION 
VALUES(40,to_date('21-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('22-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('22-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),3,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(31,to_date('22-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('22-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('22-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,14);
INSERT INTO RR_RESERVATION 
VALUES(24,to_date('22-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('22-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('22-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(23,to_date('23-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('23-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('23-AUG-14 12:55:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,1);
INSERT INTO RR_RESERVATION 
VALUES(36,to_date('24-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('24-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('24-AUG-14 12:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,9);
INSERT INTO RR_RESERVATION 
VALUES(37,to_date('24-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('24-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('24-AUG-14 12:55:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,2);
INSERT INTO RR_RESERVATION 
VALUES(40,to_date('24-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('24-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('24-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(31,to_date('25-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('25-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('25-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,14);
INSERT INTO RR_RESERVATION 
VALUES(24,to_date('25-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('25-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('25-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(28,to_date('26-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('26-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('26-AUG-14 12:55:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,1);
INSERT INTO RR_RESERVATION 
VALUES(36,to_date('26-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('27-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('26-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),4,'Y','Cash',reservation_sequence.nextval,10002,9);
INSERT INTO RR_RESERVATION 
VALUES(37,to_date('27-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('27-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('27-AUG-14 12:55:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,2);
INSERT INTO RR_RESERVATION 
VALUES(40,to_date('27-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('27-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('27-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(31,to_date('28-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('28-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('28-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,14);
INSERT INTO RR_RESERVATION 
VALUES(22,to_date('28-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('28-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('28-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(23,to_date('29-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('29-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('29-AUG-14 12:55:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,1);
INSERT INTO RR_RESERVATION 
VALUES(15,to_date('30-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('30-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('30-AUG-14 12:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,9);
INSERT INTO RR_RESERVATION 
VALUES(37,to_date('30-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('31-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('31-AUG-14 16:55:30','dd-mon-yy HH24:MI:SS'),4,'Y','Cash',reservation_sequence.nextval,10003,2);
INSERT INTO RR_RESERVATION 
VALUES(40,to_date('31-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('31-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('31-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(31,to_date('31-AUG-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('31-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('31-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,14);
INSERT INTO RR_RESERVATION 
VALUES(24,to_date('31-AUG-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('31-AUG-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('31-AUG-14 16:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(23,to_date('01-SEP-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('01-SEP-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('01-SEP-14 12:55:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,1);
INSERT INTO RR_RESERVATION 
VALUES(36,to_date('02-SEP-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('02-SEP-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('02-SEP-14 12:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,9);
INSERT INTO RR_RESERVATION 
VALUES(39,to_date('02-SEP-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('03-SEP-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('02-SEP-14 12:55:30','dd-mon-yy HH24:MI:SS'),4,'Y','Cash',reservation_sequence.nextval,10003,2);
INSERT INTO RR_RESERVATION 
VALUES(40,to_date('03-SEP-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('04-SEP-14 9:00:00','dd-mon-yy HH24:MI:SS'), to_date('04-SEP-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(31,to_date('04-SEP-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('03-SEP-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('03-SEP-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,14);
INSERT INTO RR_RESERVATION 
VALUES(25,to_date('04-SEP-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('04-SEP-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('04-SEP-14 16:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(23,to_date('04-SEP-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('04-SEP-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('04-SEP-14 12:55:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10002,1);
INSERT INTO RR_RESERVATION 
VALUES(18,to_date('04-SEP-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('05-SEP-14 13:00:00','dd-mon-yy HH24:MI:SS'), to_date('05-SEP-14 12:45:30','dd-mon-yy HH24:MI:SS'),3,'Y','Cash',reservation_sequence.nextval,10002,9);
INSERT INTO RR_RESERVATION 
VALUES(38,to_date('05-SEP-14 12:00:00','dd-mon-yy HH24:MI:SS'),to_date('05-SEP-14 14:00:00','dd-mon-yy HH24:MI:SS'), to_date('05-SEP-14 13:55:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,2);
INSERT INTO RR_RESERVATION 
VALUES(40,to_date('05-SEP-14 15:00:00','dd-mon-yy HH24:MI:SS'),to_date('05-SEP-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('05-SEP-14 16:45:30','dd-mon-yy HH24:MI:SS'),1,'Y','Cash',reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(31,to_date('06-SEP-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('06-SEP-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('06-SEP-14 16:45:30','dd-mon-yy HH24:MI:SS'),2,'Y','Cash',reservation_sequence.nextval,10003,14);
INSERT INTO RR_RESERVATION 
VALUES(24,to_date('06-SEP-14 13:00:00','dd-mon-yy HH24:MI:SS'),to_date('07-SEP-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('07-SEP-14 16:45:30','dd-mon-yy HH24:MI:SS'),3,'N',null,reservation_sequence.nextval,10003,3);
INSERT INTO RR_RESERVATION 
VALUES(40,to_date('07-SEP-14 9:00:00','dd-mon-yy HH24:MI:SS'),to_date('07-SEP-14 17:00:00','dd-mon-yy HH24:MI:SS'), to_date('07-SEP-14 16:55:30','dd-mon-yy HH24:MI:SS'),2,'N',null,reservation_sequence.nextval,10002,1);



CREATE SEQUENCE ENQUIRY_SEQUENCE
START WITH 1 MINVALUE 1 MAXVALUE 9999999999
NOCYCLE INCREMENT BY 1;


INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 9:10:00','DD-MON-YY HH24:MI:SS'),1,10002,1);  --customer from 1 to 19 staff 1002-4
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 9:10:00','DD-MON-YY HH24:MI:SS'),1,10002,1);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 9:30:20','DD-MON-YY HH24:MI:SS'),2,10003,4);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 9:40:05','DD-MON-YY HH24:MI:SS'),2,10002,6);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 10:10:03','DD-MON-YY HH24:MI:SS'),1,10004,7);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 10:12:00','DD-MON-YY HH24:MI:SS'),2,10003,11);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 10:50:06','DD-MON-YY HH24:MI:SS'),2,10002,13);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 11:11:00','DD-MON-YY HH24:MI:SS'),2,10002,12);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 12:00:00','DD-MON-YY HH24:MI:SS'),2,10004,3);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 12:40:00','DD-MON-YY HH24:MI:SS'),1,10002,5);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 12:50:50','DD-MON-YY HH24:MI:SS'),1,10003,8);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 13:10:00','DD-MON-YY HH24:MI:SS'),1,10002,9);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 14:20:40','DD-MON-YY HH24:MI:SS'),2,10002,10);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('02-FEB-15 15:07:03','DD-MON-YY HH24:MI:SS'),2,10004,11);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('03-FEB-15 9:10:00','DD-MON-YY HH24:MI:SS'),2,10002,1);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('03-FEB-15 9:20:05','DD-MON-YY HH24:MI:SS'),1,10003,11);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('03-FEB-15 10:30:10','DD-MON-YY HH24:MI:SS'),1,10002,16);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('03-FEB-15 10:10:20','DD-MON-YY HH24:MI:SS'),2,10004,17);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('03-FEB-15 11:10:00','DD-MON-YY HH24:MI:SS'),2,10004,18);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('04-FEB-15 11:10:00','DD-MON-YY HH24:MI:SS'),2,10002,18);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('04-FEB-15 11:10:00','DD-MON-YY HH24:MI:SS'),1,10004,19);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('04-FEB-15 11:10:00','DD-MON-YY HH24:MI:SS'),2,10004,1);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('05-FEB-15 11:10:00','DD-MON-YY HH24:MI:SS'),1,10004,2);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('05-FEB-15 10:10:00','DD-MON-YY HH24:MI:SS'),2,10002,8);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('06-FEB-15 11:10:00','DD-MON-YY HH24:MI:SS'),1,10004,7);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('06-FEB-15 12:10:00','DD-MON-YY HH24:MI:SS'),1,10004,8);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('06-FEB-15 13:10:00','DD-MON-YY HH24:MI:SS'),2,10002,9);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('06-FEB-15 14:10:00','DD-MON-YY HH24:MI:SS'),2,10004,10);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('07-FEB-15 09:10:00','DD-MON-YY HH24:MI:SS'),2,10004,11);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('07-FEB-15 09:10:00','DD-MON-YY HH24:MI:SS'),2,10002,12);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('08-FEB-15 10:10:00','DD-MON-YY HH24:MI:SS'),2,10004,13);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('09-FEB-15 10:10:00','DD-MON-YY HH24:MI:SS'),2,10002,14);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('10-FEB-15 10:10:00','DD-MON-YY HH24:MI:SS'),2,10004,15);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('11-FEB-15 10:10:00','DD-MON-YY HH24:MI:SS'),2,10002,16);
INSERT INTO RR_ENQUIRY VALUES(
Enquiry_sequence.nextval,To_date('12-FEB-15 11:10:00','DD-MON-YY HH24:MI:SS'),2,10004,19);

--Queries and Management Reports

--Maryam Elgahmi 12009935--
--Shows bike faults by manufacturer (natural join 2 tables, order by, column alias)
select bikeid, bikemodel"Model", bikedop"Date of Purchase", bikefault"Fault", manname"Manufacturer"
from rr_bikes natural join rr_maintenance natural join rr_manufacturer
order by manid, bikefault;

--Shows all reservations by particular customer (natural join 3 tables, column alias, arithmetic expression, comparison operator)
select custname"Customer Name", bikemodel"Bike Model", bikesize"Size", bikeclassification"Classification", 
bikerentcost"Rental cost per half day", rentdateandtime"Rental date", rentperiod"# of half days", bikerentcost*rentperiod "Total Rent Cost"
from rr_bikes natural join rr_customer natural join rr_reservation
where custid = 14;

--Shows Total rental income for the selected week (functions, column alias, natural join 2 tables, logical operator)
select sum(rentperiod*bikerentcost) as "Income for w/e 22 August 2014"
from rr_reservation natural join rr_bikes
where rentdateandtime between '15-Aug-14' and '22-Aug-14';

--Shows popularity of each bike model (functions, natural join 2 tables, group by, order by, column alias)
select distinct(bikemodel)"Bike Model", count(bikemodel)"# of reservations"
from rr_bikes natural join rr_reservation 
group by bikemodel
order by count(bikemodel) desc;

--Total spent on each classification in 2013 (Column alias, logical operator, function, group by)
SELECT bikeclassification"Classification", sum(bikecost)"Total spent in 2013"
FROM rr_bikes
WHERE bikedop between '1-jan-13' and '31-dec-13' 
group by  bikeclassification;

--Display all the departments name and the count of departments if the department names count is more than Hiring Department
--(Group by, function, comparison operator,sub query, Having clause)
select deptname,count(deptname) from rr_staff
group by deptname
having count(deptname)>=
(select count(deptname) from rr_staff where
deptname='Hirings');

--Display all the age of Bikes in years if they have purchased on or before 31 december 2012
select bikeid,bikeclassification,bikemodel,bikedop,trunc(months_between(sysdate,bikedop)/12,0)
"Bike Age"
from RR_bikes
where bikedop<= '01-Jan-13';

--Mark Bellingham--14032098
--Check orders and order details (Column alias, equi join 3 tables, comparison operator, order by)
select orderdate"Order Date", deliveryexpecteddate"Expected Delivery Date", orderreceiveddate"Date Received",  
ORDERQUANTITY"Quantity", receivedquantity"Received Quantity", partname"Part Name", partdescription"Description", comments"Comments"
from rr_partsordered join rr_orderdetails on rr_partsordered.orderno = rr_orderdetails.orderno
join rr_parts on rr_orderdetails.partid = rr_parts.partid
order by orderdate;

--Bikes which have not been sold after 2 years (Column alias, Comparison operator, left outer join, months between, sysdate)
select rr_bikes.bikeid"Bike ID", bikemodel"Bike Model", manid"Manufacturer ID", bikedop"Bike Date of Purchase"
from rr_bikes left outer join rr_sell on rr_bikes.bikeid = rr_sell.bikeid
where months_between(sysdate,bikedop)>24 and rr_sell.bikeid is null;

--Shows income by customer for the second half of 2014 (equi join to join 3 tables, column alias, function, arithmetic operator, table alias, logical operator, group by, order by)
select custname" Customer Name",custaddress" Customer Address",custpostcode" Customer PostCode",custphone" Customer Telephone",custemail" Customer Email Id",
rentpaid" Paid Y/N " ,sum(bikerentcost*rentperiod) "Total Invoice Amount",paymenttype
from RR_customer c,RR_reservation r,RR_bikes b  
where c.custid=r.custid and b.bikeid=r.bikeid and rentdateandtime between '1-jul-14' and '31-dec-14'
group by custname, custaddress, custpostcode, custphone, custemail, rentpaid, paymenttype
order by custname;

--Display staff details who works in the same department where Bert and Pete works(Subquery, order by, logical operator, comparison operator)
select staffname,deptname from RR_staff where deptname=
(select deptname from RR_staff where staffname='Pete')
or deptname like
(select deptname from RR_staff where staffname='Bert')
order by staffname,deptname;

--Find bike rentals created by a particular member of staff (Join four tables, column alias, order by, comparison operator, arithmetic operator)
SELECT bikemodel"Bike Model", bikeclassification"Bike Classification", bikesize"Bike Size", custname"Customer Name", 
rentdateandtime"Rental Date", bikerentcost*rentperiod"Rental Cost", staffname"Staff Name"
FROM rr_bikes b, rr_reservation r, rr_customer c, rr_staff s
WHERE b.bikeid = r.bikeid and c.custid = r.custid and s.staffid = r.staffid and s.staffid = 10002
ORDER BY rentdateandtime;



--Janet D'Souza--14059185
--Displays customers who have rented bikes where the cost of the bike is more than average (comparison operator, function, logical operator, subquery, table alias, equi join 3 tables)
select custname, bikerentcost, bikecost, b.bikeid, bikeclassification, bikemodel
from rr_customer c, rr_bikes b, rr_reservation r
where b.bikeid = r.bikeid and c.custid = r.custid and bikecost>(select avg(bikecost)
from rr_bikes );

--Display how much total money been spent to purchase all Mountain bikes in the year 2014 (Column alias, functions (sum and count), arithmetic operator, logical operator, group by)
select bikeclassification, count(bikeclassification)"Quantity Purchased",sum(bikecost)"Total Amount Spent",count(bikeclassification)*sum(bikecost)"Sum of Amount Spent"
from RR_bikes 
where bikeclassification like 'Mountain' and bikedop between '1-jan-14' and '31-dec-14' 
group by bikeclassification;

--Shows the most expensive bike by type where cost is greater then Â£500 (Column alias, group by, comparison operator, function, having clause)
select bikemodel"Bikes costing more than £500", bikeclassification"Bike Classification", max(bikecost)"Highest Price"
from rr_bikes
group by bikeclassification, bikemodel
having max(bikecost)>500;


--Display the exact age of the bike in years months and days(concatenation operator, arithmatic operator, functions, sysdate)
select 'Bike bought on '||to_char(bikedop,'FMMonth DD YYYY') || ' and the bike is '|| trunc(months_between(sysdate,bikedop)/12) || 'year(s) ' 
||trunc(mod((months_between(sysdate,bikedop)),12))||' month(s) ' ||(trunc(sysdate)-add_months(bikedop,
(months_between(sysdate,bikedop))))||' day(s) old.'"Age of the Bike" from RR_bikes;

--Invoice details of all the customers who hired and not paid for the bikes (Equi Join to join 3 tables, Column alias, table alias, to_char, decode, logical operator, order by)
select custname" Customer Name",custaddress" Customer Address",custpostcode" Customer PostCode",custphone" Customer Telephone",custemail" Customer Email Id",
to_char(Rentdateandtime,'DD/MM/YYYY')"Rent Date", to_char(rentdateandtime,'hh:mi:ss AM')"Rent Time", 
decode(rentperiod, 1,'Half Day', 2,'Full Day', 3,'Day and half', 4,'Two days')"Rent Period",
rentpaid" Paid Y/N " ,bikerentcost*rentperiod "Invoice Amount",paymenttype
from RR_customer c,RR_reservation r,RR_bikes b  
where c.custid=r.custid and b.bikeid=r.bikeid and rentpaid like 'N'
order by custname, rentdateandtime;




--End of Queries