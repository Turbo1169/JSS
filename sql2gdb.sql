/* MS SQL to InterBase Wizard Script */
/* Generation moment: 3/11/2002 8:36:02 AM */
/* The following section allows the wizard to
 *  reload all the migration information later on.
 *  Do not modify by hand, unless you *know* what
 *  doing. */
/* WIZARD INFORMATION STARTS HERE
CreateGUIDDomain=True
CharSet=
DefaultValues=
DeleteExisting=True
IBFileName=\\littlebertha\d:\interbase\JDSData.gdb
IBPassword=masterkey
IBUserName=sysdba
InterruptOnErrors=False
NameMap=,,"Angprop=Angprop,Bridg=Bridg,Bridg2=Bridg2,Customer=Customer,JobInfo=JobInfo,JobMisc=JobMisc,Joists=Joists,Joists2=Joists2,Jsubst=Jsubst,Jsubst2=Jsubst2,KCSTbl=KCSTbl,Pricetbl=Pricetbl,Quotes=Quotes,Rndprop=Rndprop,Seqreq=Seqreq,Sequence=Sequence,ShopList=ShopList,Shopord=Shopord,SJICatlg=SJICatlg,SReqList=SReqList,Substbl=Substbl,TimeStds=TimeStds,Userlist=Userlist","Angprop=Angprop,Bridg=Bridg,Bridg2=Bridg2,Customer=Customer,JobInfo=JobInfo,JobMisc=JobMisc,Joists=Joists,Joists2=Joists2,Jsubst=Jsubst,Jsubst2=Jsubst2,KCSTbl=KCSTbl,Pricetbl=Pricetbl,Quotes=Quotes,Rndprop=Rndprop,Seqreq=Seqreq,Sequence=Sequence,ShopList=ShopList,Shopord=Shopord,SJICatlg=SJICatlg,SReqList=SReqList,Substbl=Substbl,TimeStds=TimeStds,Userlist=Userlist"
MapMethods=[mmUseQuoted]
MigrateAutoNumber=True
OutputFileName=
OutputType=otIB
RestrictToTables=
Libraries=
SkipMetadata=False
SourceConnectionString="Provider=Microsoft.Jet.OLEDB.4.0;Password="""";Data Source=C:\projects\ISP Joist Design\JDSData.mdb;Persist Security Info=True"
UseDialect3=True
UseExisting=False
WIZARD INFORMATION STOPS HERE */

/* DOMAIN: GUID */
CREATE DOMAIN GUID CHAR(38)
;

/* TABLE: "Angprop" */
CREATE TABLE "Angprop" (
  "Sort" SMALLINT NOT NULL,
  "Section" VARCHAR(2),
  "Description" VARCHAR(20),
  "B1" DOUBLE PRECISION,
  "B2" DOUBLE PRECISION,
  "Thick" DOUBLE PRECISION,
  "Cost" DOUBLE PRECISION,
  "Plate" CHAR(1) NOT NULL,
  "For Sales" CHAR(1) NOT NULL,
  "Radius" DOUBLE PRECISION
)
;

/* TABLE: "Bridg" */
CREATE TABLE "Bridg" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Mark" VARCHAR(6) NOT NULL,
  "Plan Feet" INTEGER,
  "Type" VARCHAR(2),
  "Run By" VARCHAR(3),
  "Weight" DOUBLE PRECISION,
  "Material" DOUBLE PRECISION,
  "Section" VARCHAR(2)
)
;

/* TABLE: "Bridg2" */
CREATE TABLE "Bridg2" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Mark" VARCHAR(6) NOT NULL,
  "Quantity" SMALLINT,
  "Section" VARCHAR(2),
  "Length" VARCHAR(10),
  "H-H" VARCHAR(10),
  "1/2-H" VARCHAR(10),
  "Detail" VARCHAR(2),
  "Weight" DOUBLE PRECISION,
  "Run By" VARCHAR(3)
)
;

/* TABLE: "Customer" */
CREATE TABLE "Customer" (
  "Customer" VARCHAR(30) NOT NULL,
  "Address" VARCHAR(40),
  "City" VARCHAR(15),
  "State" VARCHAR(5),
  "Zip" VARCHAR(10),
  "Telephone" VARCHAR(14),
  "Fax" VARCHAR(14),
  "E-Mail" VARCHAR(20),
  "Contact" VARCHAR(30)
)
;

/* TABLE: "JobInfo" */
CREATE TABLE "JobInfo" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Job Name" VARCHAR(40),
  "Location" VARCHAR(30),
  "State" VARCHAR(5),
  "Miles" SMALLINT,
  "Customer" VARCHAR(30),
  "Bill Address" VARCHAR(40),
  "Bill City" VARCHAR(15),
  "Bill State" VARCHAR(5),
  "Bill Zip" VARCHAR(10),
  "Sold" CHAR(1) NOT NULL,
  "Century" SMALLINT
)
;

/* TABLE: "JobMisc" */
CREATE TABLE "JobMisc" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Category" VARCHAR(10) NOT NULL,
  "Item" SMALLINT NOT NULL,
  "Quantity" INTEGER,
  "Unit Price" DOUBLE PRECISION,
  "Value" DOUBLE PRECISION
)
;

/* TABLE: "Joists" */
CREATE TABLE "Joists" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Mark" VARCHAR(6) NOT NULL,
  "Quantity" SMALLINT,
  "Description" VARCHAR(14),
  "Run By" VARCHAR(3),
  "Shape" VARCHAR(1),
  "Joist Type" VARCHAR(2),
  "Base Length" VARCHAR(10),
  "Seats BDL" VARCHAR(10),
  "Seat Length LE" VARCHAR(10),
  "Seats BDR" VARCHAR(10),
  "Seat Length RE" VARCHAR(10),
  "TCXL" VARCHAR(10),
  "TCXLTY" VARCHAR(2),
  "TCXR" VARCHAR(10),
  "TCXRTY" VARCHAR(2),
  "BCXL" VARCHAR(10),
  "BCXLTY" VARCHAR(1),
  "BCXR" VARCHAR(10),
  "BCXRTY" VARCHAR(1),
  "TC Uniform Load" DOUBLE PRECISION,
  "BC Uniform Load" DOUBLE PRECISION,
  "Net Uplift" DOUBLE PRECISION,
  "Any Panel" DOUBLE PRECISION,
  "TC Axial Load" DOUBLE PRECISION,
  "BC Axial Load" DOUBLE PRECISION,
  "Fixed Moment LE" DOUBLE PRECISION,
  "Fixed Moment RE" DOUBLE PRECISION,
  "Lateral Moment LE" DOUBLE PRECISION,
  "Lateral Moment RE" DOUBLE PRECISION,
  "BC Panels LE" VARCHAR(10),
  "BC Panels RE" VARCHAR(10),
  "TC Panels LE" VARCHAR(10),
  "TC Panels RE" VARCHAR(10),
  "First Diag LE" VARCHAR(10),
  "First Diag RE" VARCHAR(10),
  "BC Panel" VARCHAR(10),
  "BCP" SMALLINT,
  "Depth LE" DOUBLE PRECISION,
  "Ridge Position" VARCHAR(10),
  "Depth RE" DOUBLE PRECISION,
  "Scissor Add" DOUBLE PRECISION,
  "Time" DOUBLE PRECISION,
  "Weight" DOUBLE PRECISION,
  "Material" DOUBLE PRECISION,
  "Chords" VARCHAR(5),
  "LL Deflection" SMALLINT,
  "TL Deflection" SMALLINT,
  "Anywhere TC" DOUBLE PRECISION,
  "Anywhere BC" DOUBLE PRECISION,
  "Extras" BLOB SUB_TYPE TEXT,
  "Consolidate" CHAR(1) NOT NULL,
  "Add Load" DOUBLE PRECISION
)
;

/* TABLE: "Joists2" */
CREATE TABLE "Joists2" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Mark" VARCHAR(6) NOT NULL,
  "Quantity" SMALLINT,
  "Description" VARCHAR(14),
  "Run By" VARCHAR(3),
  "Shape" VARCHAR(1),
  "Joist Type" VARCHAR(2),
  "Base Length" VARCHAR(10),
  "Seats BDL" VARCHAR(10),
  "Seat Length LE" VARCHAR(10),
  "Seats BDR" VARCHAR(10),
  "Seat Length RE" VARCHAR(10),
  "TCXL" VARCHAR(10),
  "TCXLTY" VARCHAR(2),
  "TCXR" VARCHAR(10),
  "TCXRTY" VARCHAR(2),
  "BCXL" VARCHAR(10),
  "BCXLTY" VARCHAR(1),
  "BCXR" VARCHAR(10),
  "BCXRTY" VARCHAR(1),
  "TC Uniform Load" DOUBLE PRECISION,
  "BC Uniform Load" DOUBLE PRECISION,
  "Net Uplift" DOUBLE PRECISION,
  "Any Panel" DOUBLE PRECISION,
  "TC Axial Load" DOUBLE PRECISION,
  "BC Axial Load" DOUBLE PRECISION,
  "Fixed Moment LE" DOUBLE PRECISION,
  "Fixed Moment RE" DOUBLE PRECISION,
  "Lateral Moment LE" DOUBLE PRECISION,
  "Lateral Moment RE" DOUBLE PRECISION,
  "BC Panels LE" VARCHAR(10),
  "BC Panels RE" VARCHAR(10),
  "TC Panels LE" VARCHAR(10),
  "TC Panels RE" VARCHAR(10),
  "First Diag LE" VARCHAR(10),
  "First Diag RE" VARCHAR(10),
  "BC Panel" VARCHAR(10),
  "BCP" SMALLINT,
  "Depth LE" DOUBLE PRECISION,
  "Ridge Position" VARCHAR(10),
  "Depth RE" DOUBLE PRECISION,
  "Scissor Add" DOUBLE PRECISION,
  "Time" DOUBLE PRECISION,
  "Weight" DOUBLE PRECISION,
  "Material" DOUBLE PRECISION,
  "Chords" VARCHAR(5),
  "LL Deflection" SMALLINT,
  "TL Deflection" SMALLINT,
  "Anywhere TC" DOUBLE PRECISION,
  "Anywhere BC" DOUBLE PRECISION,
  "Extras" BLOB SUB_TYPE TEXT,
  "Consolidate" CHAR(1) NOT NULL,
  "Add Load" DOUBLE PRECISION
)
;

/* TABLE: "Jsubst" */
CREATE TABLE "Jsubst" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Mark" VARCHAR(6) NOT NULL,
  "Quantity" SMALLINT,
  "Description" VARCHAR(14),
  "Type" VARCHAR(1),
  "Base Length" VARCHAR(10),
  "Run By" VARCHAR(3),
  "Weight" DOUBLE PRECISION,
  "Material" DOUBLE PRECISION,
  "Section" VARCHAR(2),
  "Axial Load" DOUBLE PRECISION,
  "Deflection" SMALLINT
)
;

/* TABLE: "Jsubst2" */
CREATE TABLE "Jsubst2" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Mark" VARCHAR(6) NOT NULL,
  "Quantity" SMALLINT,
  "Description" VARCHAR(14),
  "Type" VARCHAR(1),
  "Base Length" VARCHAR(10),
  "Run By" VARCHAR(3),
  "Weight" DOUBLE PRECISION,
  "Material" DOUBLE PRECISION,
  "Section" VARCHAR(2),
  "Axial Load" DOUBLE PRECISION,
  "Deflection" SMALLINT
)
;

/* TABLE: "KCSTbl" */
CREATE TABLE "KCSTbl" (
  "Depth" SMALLINT NOT NULL,
  "Index" SMALLINT NOT NULL,
  "Moment" DOUBLE PRECISION,
  "Shear" DOUBLE PRECISION,
  "Inertia" DOUBLE PRECISION
)
;

/* TABLE: "Pricetbl" */
CREATE TABLE "Pricetbl" (
  "Category" VARCHAR(10) NOT NULL,
  "Item" SMALLINT NOT NULL,
  "Description" VARCHAR(20),
  "Unit Price" DOUBLE PRECISION,
  "Unit" VARCHAR(10)
)
;

/* TABLE: "Quotes" */
CREATE TABLE "Quotes" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Description" VARCHAR(40),
  "Date Quoted" TIMESTAMP,
  "L1 Pieces" SMALLINT,
  "L1 Tons" DOUBLE PRECISION,
  "L1 Material" DOUBLE PRECISION,
  "L1 Line Hrs" DOUBLE PRECISION,
  "L2 Pieces" SMALLINT,
  "L2 Tons" DOUBLE PRECISION,
  "L2 Material" DOUBLE PRECISION,
  "L2 Line Hrs" DOUBLE PRECISION,
  "LS Pieces" SMALLINT,
  "LS Tons" DOUBLE PRECISION,
  "LS Material" DOUBLE PRECISION,
  "LS Line Hrs" DOUBLE PRECISION,
  "JG Pieces" SMALLINT,
  "JG Tons" DOUBLE PRECISION,
  "JG Material" DOUBLE PRECISION,
  "JG Line Hrs" DOUBLE PRECISION,
  "HB Pieces" INTEGER,
  "HB Tons" DOUBLE PRECISION,
  "HB Material" DOUBLE PRECISION,
  "XB Pieces" INTEGER,
  "XB Tons" DOUBLE PRECISION,
  "XB Material" DOUBLE PRECISION,
  "KB Pieces" INTEGER,
  "KB Tons" DOUBLE PRECISION,
  "KB Material" DOUBLE PRECISION,
  "JS Pieces" INTEGER,
  "JS Tons" DOUBLE PRECISION,
  "JS Material" DOUBLE PRECISION,
  "Profit LH" DOUBLE PRECISION,
  "Total Paint" DOUBLE PRECISION,
  "Total Misc" DOUBLE PRECISION,
  "Total Fees" DOUBLE PRECISION,
  "Total Freight" DOUBLE PRECISION,
  "Commission" DOUBLE PRECISION,
  "Extras" DOUBLE PRECISION,
  "Detail" SMALLINT,
  "Approval" SMALLINT,
  "Fabrication" SMALLINT,
  "List" SMALLINT,
  "SS Line Hour" DOUBLE PRECISION,
  "LS Line Hour" DOUBLE PRECISION,
  "Overweight" DOUBLE PRECISION,
  "HB Labor Cost" DOUBLE PRECISION,
  "XB Labor Cost" DOUBLE PRECISION,
  "KB Labor Cost" DOUBLE PRECISION,
  "JS Labor Cost" DOUBLE PRECISION,
  "Status" VARCHAR(1),
  "Notes" BLOB SUB_TYPE TEXT
)
;

/* TABLE: "Rndprop" */
CREATE TABLE "Rndprop" (
  "Sort" SMALLINT NOT NULL,
  "Section" VARCHAR(2),
  "Description" VARCHAR(20),
  "Thick" DOUBLE PRECISION,
  "Cost" DOUBLE PRECISION
)
;

/* TABLE: "Seqreq" */
CREATE TABLE "Seqreq" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Description" VARCHAR(40)
)
;

/* TABLE: "Sequence" */
CREATE TABLE "Sequence" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Description" VARCHAR(40),
  "Index" VARCHAR(3),
  "Paint" VARCHAR(10),
  "Department" SMALLINT,
  "L1 Pieces" SMALLINT,
  "L1 Tons" DOUBLE PRECISION,
  "L1 Material" DOUBLE PRECISION,
  "L1 Line Hrs" DOUBLE PRECISION,
  "L2 Pieces" SMALLINT,
  "L2 Tons" DOUBLE PRECISION,
  "L2 Material" DOUBLE PRECISION,
  "L2 Line Hrs" DOUBLE PRECISION,
  "LS Pieces" SMALLINT,
  "LS Tons" DOUBLE PRECISION,
  "LS Material" DOUBLE PRECISION,
  "LS Line Hrs" DOUBLE PRECISION,
  "JG Pieces" SMALLINT,
  "JG Tons" DOUBLE PRECISION,
  "JG Material" DOUBLE PRECISION,
  "JG Line Hrs" DOUBLE PRECISION,
  "HB Pieces" INTEGER,
  "HB Tons" DOUBLE PRECISION,
  "HB Material" DOUBLE PRECISION,
  "XB Pieces" INTEGER,
  "XB Tons" DOUBLE PRECISION,
  "XB Material" DOUBLE PRECISION,
  "KB Pieces" INTEGER,
  "KB Tons" DOUBLE PRECISION,
  "KB Material" DOUBLE PRECISION,
  "Profit LH" DOUBLE PRECISION,
  "Total Paint" DOUBLE PRECISION,
  "Total Misc" DOUBLE PRECISION,
  "Total Fees" DOUBLE PRECISION,
  "Total Freight" DOUBLE PRECISION,
  "Commission" DOUBLE PRECISION,
  "Extras" DOUBLE PRECISION,
  "Detail" SMALLINT,
  "Approval" SMALLINT,
  "Fabrication" SMALLINT,
  "List" SMALLINT,
  "SS Line Hour" DOUBLE PRECISION,
  "LS Line Hour" DOUBLE PRECISION,
  "Overweight" DOUBLE PRECISION,
  "HB Labor Cost" DOUBLE PRECISION,
  "XB Labor Cost" DOUBLE PRECISION,
  "KB Labor Cost" DOUBLE PRECISION,
  "Status" VARCHAR(1),
  "Notes" BLOB SUB_TYPE TEXT
)
;

/* TABLE: "ShopList" */
CREATE TABLE "ShopList" (
  "List Number" INTEGER NOT NULL,
  "Sort" SMALLINT NOT NULL,
  "Job Number" VARCHAR(12),
  "Mark" VARCHAR(6),
  "Quantity" SMALLINT,
  "Description" VARCHAR(14),
  "Length" VARCHAR(10),
  "Weight" DOUBLE PRECISION,
  "Time" DOUBLE PRECISION
)
;

/* TABLE: "Shopord" */
CREATE TABLE "Shopord" (
  "List Number" INTEGER NOT NULL,
  "Date" TIMESTAMP,
  "Job Number" VARCHAR(8),
  "Page" SMALLINT,
  "List Type" VARCHAR(2),
  "Quantity" SMALLINT,
  "Tons" DOUBLE PRECISION,
  "Time" DOUBLE PRECISION
)
;

/* TABLE: "SJICatlg" */
CREATE TABLE "SJICatlg" (
  "Type" VARCHAR(1) NOT NULL,
  "Index" SMALLINT NOT NULL,
  "Span" SMALLINT NOT NULL,
  "Total Load" SMALLINT,
  "Live Load" SMALLINT
)
;

/* TABLE: "SReqList" */
CREATE TABLE "SReqList" (
  "Job Number" VARCHAR(8) NOT NULL,
  "Page" SMALLINT NOT NULL,
  "Section" VARCHAR(2) NOT NULL,
  "Tons" DOUBLE PRECISION
)
;

/* TABLE: "Substbl" */
CREATE TABLE "Substbl" (
  "Index" SMALLINT NOT NULL,
  "Span" SMALLINT NOT NULL,
  "Total Load" SMALLINT,
  "Live Load" SMALLINT
)
;

/* TABLE: "TimeStds" */
CREATE TABLE "TimeStds" (
  "Type" VARCHAR(1) NOT NULL,
  "Index" SMALLINT NOT NULL,
  "Panels" SMALLINT NOT NULL,
  "Hours" DOUBLE PRECISION
)
;

/* TABLE: "Userlist" */
CREATE TABLE "Userlist" (
  "User" VARCHAR(20) NOT NULL,
  "Initials" VARCHAR(3),
  "Password" VARCHAR(8),
  "Department" SMALLINT
)
;

/* PUMP: (Angprop) */
INSERT INTO "Angprop" (
  "B1",
  "B2",
  "Cost",
  "Description",
  "For Sales",
  "Plate",
  "Radius",
  "Section",
  "Sort",
  "Thick"
) VALUES (
  :"B1",
  :"B2",
  :"Cost",
  :"Description",
  :"For Sales",
  :"Plate",
  :"Radius",
  :"Section",
  :"Sort",
  :"Thick"
)
;

/* PUMP: (Bridg) */
INSERT INTO "Bridg" (
  "Job Number",
  "Mark",
  "Material",
  "Page",
  "Plan Feet",
  "Run By",
  "Section",
  "Type",
  "Weight"
) VALUES (
  :"Job Number",
  :"Mark",
  :"Material",
  :"Page",
  :"Plan Feet",
  :"Run By",
  :"Section",
  :"Type",
  :"Weight"
)
;

/* PUMP: (Bridg2) */
INSERT INTO "Bridg2" (
  "1/2-H",
  "Detail",
  "H-H",
  "Job Number",
  "Length",
  "Mark",
  "Page",
  "Quantity",
  "Run By",
  "Section",
  "Weight"
) VALUES (
  :"1/2-H",
  :"Detail",
  :"H-H",
  :"Job Number",
  :"Length",
  :"Mark",
  :"Page",
  :"Quantity",
  :"Run By",
  :"Section",
  :"Weight"
)
;

/* PUMP: (Customer) */
INSERT INTO "Customer" (
  "Address",
  "City",
  "Contact",
  "Customer",
  "E-Mail",
  "Fax",
  "State",
  "Telephone",
  "Zip"
) VALUES (
  :"Address",
  :"City",
  :"Contact",
  :"Customer",
  :"E-Mail",
  :"Fax",
  :"State",
  :"Telephone",
  :"Zip"
)
;

/* PUMP: (JobInfo) */
INSERT INTO "JobInfo" (
  "Bill Address",
  "Bill City",
  "Bill State",
  "Bill Zip",
  "Century",
  "Customer",
  "Job Name",
  "Job Number",
  "Location",
  "Miles",
  "Sold",
  "State"
) VALUES (
  :"Bill Address",
  :"Bill City",
  :"Bill State",
  :"Bill Zip",
  :"Century",
  :"Customer",
  :"Job Name",
  :"Job Number",
  :"Location",
  :"Miles",
  :"Sold",
  :"State"
)
;

/* PUMP: (JobMisc) */
INSERT INTO "JobMisc" (
  "Category",
  "Item",
  "Job Number",
  "Page",
  "Quantity",
  "Unit Price",
  "Value"
) VALUES (
  :"Category",
  :"Item",
  :"Job Number",
  :"Page",
  :"Quantity",
  :"Unit Price",
  :"Value"
)
;

/* PUMP: (Joists) */
INSERT INTO "Joists" (
  "Add Load",
  "Any Panel",
  "Anywhere BC",
  "Anywhere TC",
  "Base Length",
  "BC Axial Load",
  "BC Panel",
  "BC Panels LE",
  "BC Panels RE",
  "BC Uniform Load",
  "BCP",
  "BCXL",
  "BCXLTY",
  "BCXR",
  "BCXRTY",
  "Chords",
  "Consolidate",
  "Depth LE",
  "Depth RE",
  "Description",
  "Extras",
  "First Diag LE",
  "First Diag RE",
  "Fixed Moment LE",
  "Fixed Moment RE",
  "Job Number",
  "Joist Type",
  "Lateral Moment LE",
  "Lateral Moment RE",
  "LL Deflection",
  "Mark",
  "Material",
  "Net Uplift",
  "Page",
  "Quantity",
  "Ridge Position",
  "Run By",
  "Scissor Add",
  "Seat Length LE",
  "Seat Length RE",
  "Seats BDL",
  "Seats BDR",
  "Shape",
  "TC Axial Load",
  "TC Panels LE",
  "TC Panels RE",
  "TC Uniform Load",
  "TCXL",
  "TCXLTY",
  "TCXR",
  "TCXRTY",
  "Time",
  "TL Deflection",
  "Weight"
) VALUES (
  :"Add Load",
  :"Any Panel",
  :"Anywhere BC",
  :"Anywhere TC",
  :"Base Length",
  :"BC Axial Load",
  :"BC Panel",
  :"BC Panels LE",
  :"BC Panels RE",
  :"BC Uniform Load",
  :"BCP",
  :"BCXL",
  :"BCXLTY",
  :"BCXR",
  :"BCXRTY",
  :"Chords",
  :"Consolidate",
  :"Depth LE",
  :"Depth RE",
  :"Description",
  :"Extras",
  :"First Diag LE",
  :"First Diag RE",
  :"Fixed Moment LE",
  :"Fixed Moment RE",
  :"Job Number",
  :"Joist Type",
  :"Lateral Moment LE",
  :"Lateral Moment RE",
  :"LL Deflection",
  :"Mark",
  :"Material",
  :"Net Uplift",
  :"Page",
  :"Quantity",
  :"Ridge Position",
  :"Run By",
  :"Scissor Add",
  :"Seat Length LE",
  :"Seat Length RE",
  :"Seats BDL",
  :"Seats BDR",
  :"Shape",
  :"TC Axial Load",
  :"TC Panels LE",
  :"TC Panels RE",
  :"TC Uniform Load",
  :"TCXL",
  :"TCXLTY",
  :"TCXR",
  :"TCXRTY",
  :"Time",
  :"TL Deflection",
  :"Weight"
)
;

/* PUMP: (Joists2) */
INSERT INTO "Joists2" (
  "Add Load",
  "Any Panel",
  "Anywhere BC",
  "Anywhere TC",
  "Base Length",
  "BC Axial Load",
  "BC Panel",
  "BC Panels LE",
  "BC Panels RE",
  "BC Uniform Load",
  "BCP",
  "BCXL",
  "BCXLTY",
  "BCXR",
  "BCXRTY",
  "Chords",
  "Consolidate",
  "Depth LE",
  "Depth RE",
  "Description",
  "Extras",
  "First Diag LE",
  "First Diag RE",
  "Fixed Moment LE",
  "Fixed Moment RE",
  "Job Number",
  "Joist Type",
  "Lateral Moment LE",
  "Lateral Moment RE",
  "LL Deflection",
  "Mark",
  "Material",
  "Net Uplift",
  "Page",
  "Quantity",
  "Ridge Position",
  "Run By",
  "Scissor Add",
  "Seat Length LE",
  "Seat Length RE",
  "Seats BDL",
  "Seats BDR",
  "Shape",
  "TC Axial Load",
  "TC Panels LE",
  "TC Panels RE",
  "TC Uniform Load",
  "TCXL",
  "TCXLTY",
  "TCXR",
  "TCXRTY",
  "Time",
  "TL Deflection",
  "Weight"
) VALUES (
  :"Add Load",
  :"Any Panel",
  :"Anywhere BC",
  :"Anywhere TC",
  :"Base Length",
  :"BC Axial Load",
  :"BC Panel",
  :"BC Panels LE",
  :"BC Panels RE",
  :"BC Uniform Load",
  :"BCP",
  :"BCXL",
  :"BCXLTY",
  :"BCXR",
  :"BCXRTY",
  :"Chords",
  :"Consolidate",
  :"Depth LE",
  :"Depth RE",
  :"Description",
  :"Extras",
  :"First Diag LE",
  :"First Diag RE",
  :"Fixed Moment LE",
  :"Fixed Moment RE",
  :"Job Number",
  :"Joist Type",
  :"Lateral Moment LE",
  :"Lateral Moment RE",
  :"LL Deflection",
  :"Mark",
  :"Material",
  :"Net Uplift",
  :"Page",
  :"Quantity",
  :"Ridge Position",
  :"Run By",
  :"Scissor Add",
  :"Seat Length LE",
  :"Seat Length RE",
  :"Seats BDL",
  :"Seats BDR",
  :"Shape",
  :"TC Axial Load",
  :"TC Panels LE",
  :"TC Panels RE",
  :"TC Uniform Load",
  :"TCXL",
  :"TCXLTY",
  :"TCXR",
  :"TCXRTY",
  :"Time",
  :"TL Deflection",
  :"Weight"
)
;

/* PUMP: (Jsubst) */
INSERT INTO "Jsubst" (
  "Axial Load",
  "Base Length",
  "Deflection",
  "Description",
  "Job Number",
  "Mark",
  "Material",
  "Page",
  "Quantity",
  "Run By",
  "Section",
  "Type",
  "Weight"
) VALUES (
  :"Axial Load",
  :"Base Length",
  :"Deflection",
  :"Description",
  :"Job Number",
  :"Mark",
  :"Material",
  :"Page",
  :"Quantity",
  :"Run By",
  :"Section",
  :"Type",
  :"Weight"
)
;

/* PUMP: (Jsubst2) */
INSERT INTO "Jsubst2" (
  "Axial Load",
  "Base Length",
  "Deflection",
  "Description",
  "Job Number",
  "Mark",
  "Material",
  "Page",
  "Quantity",
  "Run By",
  "Section",
  "Type",
  "Weight"
) VALUES (
  :"Axial Load",
  :"Base Length",
  :"Deflection",
  :"Description",
  :"Job Number",
  :"Mark",
  :"Material",
  :"Page",
  :"Quantity",
  :"Run By",
  :"Section",
  :"Type",
  :"Weight"
)
;

/* PUMP: (KCSTbl) */
INSERT INTO "KCSTbl" (
  "Depth",
  "Index",
  "Inertia",
  "Moment",
  "Shear"
) VALUES (
  :"Depth",
  :"Index",
  :"Inertia",
  :"Moment",
  :"Shear"
)
;

/* PUMP: (Pricetbl) */
INSERT INTO "Pricetbl" (
  "Category",
  "Description",
  "Item",
  "Unit",
  "Unit Price"
) VALUES (
  :"Category",
  :"Description",
  :"Item",
  :"Unit",
  :"Unit Price"
)
;

/* PUMP: (Quotes) */
INSERT INTO "Quotes" (
  "Approval",
  "Commission",
  "Date Quoted",
  "Description",
  "Detail",
  "Extras",
  "Fabrication",
  "HB Labor Cost",
  "HB Material",
  "HB Pieces",
  "HB Tons",
  "JG Line Hrs",
  "JG Material",
  "JG Pieces",
  "JG Tons",
  "Job Number",
  "JS Labor Cost",
  "JS Material",
  "JS Pieces",
  "JS Tons",
  "KB Labor Cost",
  "KB Material",
  "KB Pieces",
  "KB Tons",
  "L1 Line Hrs",
  "L1 Material",
  "L1 Pieces",
  "L1 Tons",
  "L2 Line Hrs",
  "L2 Material",
  "L2 Pieces",
  "L2 Tons",
  "List",
  "LS Line Hour",
  "LS Line Hrs",
  "LS Material",
  "LS Pieces",
  "LS Tons",
  "Notes",
  "Overweight",
  "Page",
  "Profit LH",
  "SS Line Hour",
  "Status",
  "Total Fees",
  "Total Freight",
  "Total Misc",
  "Total Paint",
  "XB Labor Cost",
  "XB Material",
  "XB Pieces",
  "XB Tons"
) VALUES (
  :"Approval",
  :"Commission",
  :"Date Quoted",
  :"Description",
  :"Detail",
  :"Extras",
  :"Fabrication",
  :"HB Labor Cost",
  :"HB Material",
  :"HB Pieces",
  :"HB Tons",
  :"JG Line Hrs",
  :"JG Material",
  :"JG Pieces",
  :"JG Tons",
  :"Job Number",
  :"JS Labor Cost",
  :"JS Material",
  :"JS Pieces",
  :"JS Tons",
  :"KB Labor Cost",
  :"KB Material",
  :"KB Pieces",
  :"KB Tons",
  :"L1 Line Hrs",
  :"L1 Material",
  :"L1 Pieces",
  :"L1 Tons",
  :"L2 Line Hrs",
  :"L2 Material",
  :"L2 Pieces",
  :"L2 Tons",
  :"List",
  :"LS Line Hour",
  :"LS Line Hrs",
  :"LS Material",
  :"LS Pieces",
  :"LS Tons",
  :"Notes",
  :"Overweight",
  :"Page",
  :"Profit LH",
  :"SS Line Hour",
  :"Status",
  :"Total Fees",
  :"Total Freight",
  :"Total Misc",
  :"Total Paint",
  :"XB Labor Cost",
  :"XB Material",
  :"XB Pieces",
  :"XB Tons"
)
;

/* PUMP: (Rndprop) */
INSERT INTO "Rndprop" (
  "Cost",
  "Description",
  "Section",
  "Sort",
  "Thick"
) VALUES (
  :"Cost",
  :"Description",
  :"Section",
  :"Sort",
  :"Thick"
)
;

/* PUMP: (Seqreq) */
INSERT INTO "Seqreq" (
  "Description",
  "Job Number",
  "Page"
) VALUES (
  :"Description",
  :"Job Number",
  :"Page"
)
;

/* PUMP: (Sequence) */
INSERT INTO "Sequence" (
  "Approval",
  "Commission",
  "Department",
  "Description",
  "Detail",
  "Extras",
  "Fabrication",
  "HB Labor Cost",
  "HB Material",
  "HB Pieces",
  "HB Tons",
  "Index",
  "JG Line Hrs",
  "JG Material",
  "JG Pieces",
  "JG Tons",
  "Job Number",
  "KB Labor Cost",
  "KB Material",
  "KB Pieces",
  "KB Tons",
  "L1 Line Hrs",
  "L1 Material",
  "L1 Pieces",
  "L1 Tons",
  "L2 Line Hrs",
  "L2 Material",
  "L2 Pieces",
  "L2 Tons",
  "List",
  "LS Line Hour",
  "LS Line Hrs",
  "LS Material",
  "LS Pieces",
  "LS Tons",
  "Notes",
  "Overweight",
  "Page",
  "Paint",
  "Profit LH",
  "SS Line Hour",
  "Status",
  "Total Fees",
  "Total Freight",
  "Total Misc",
  "Total Paint",
  "XB Labor Cost",
  "XB Material",
  "XB Pieces",
  "XB Tons"
) VALUES (
  :"Approval",
  :"Commission",
  :"Department",
  :"Description",
  :"Detail",
  :"Extras",
  :"Fabrication",
  :"HB Labor Cost",
  :"HB Material",
  :"HB Pieces",
  :"HB Tons",
  :"Index",
  :"JG Line Hrs",
  :"JG Material",
  :"JG Pieces",
  :"JG Tons",
  :"Job Number",
  :"KB Labor Cost",
  :"KB Material",
  :"KB Pieces",
  :"KB Tons",
  :"L1 Line Hrs",
  :"L1 Material",
  :"L1 Pieces",
  :"L1 Tons",
  :"L2 Line Hrs",
  :"L2 Material",
  :"L2 Pieces",
  :"L2 Tons",
  :"List",
  :"LS Line Hour",
  :"LS Line Hrs",
  :"LS Material",
  :"LS Pieces",
  :"LS Tons",
  :"Notes",
  :"Overweight",
  :"Page",
  :"Paint",
  :"Profit LH",
  :"SS Line Hour",
  :"Status",
  :"Total Fees",
  :"Total Freight",
  :"Total Misc",
  :"Total Paint",
  :"XB Labor Cost",
  :"XB Material",
  :"XB Pieces",
  :"XB Tons"
)
;

/* PUMP: (ShopList) */
INSERT INTO "ShopList" (
  "Description",
  "Job Number",
  "Length",
  "List Number",
  "Mark",
  "Quantity",
  "Sort",
  "Time",
  "Weight"
) VALUES (
  :"Description",
  :"Job Number",
  :"Length",
  :"List Number",
  :"Mark",
  :"Quantity",
  :"Sort",
  :"Time",
  :"Weight"
)
;

/* PUMP: (Shopord) */
INSERT INTO "Shopord" (
  "Date",
  "Job Number",
  "List Number",
  "List Type",
  "Page",
  "Quantity",
  "Time",
  "Tons"
) VALUES (
  :"Date",
  :"Job Number",
  :"List Number",
  :"List Type",
  :"Page",
  :"Quantity",
  :"Time",
  :"Tons"
)
;

/* PUMP: (SJICatlg) */
INSERT INTO "SJICatlg" (
  "Index",
  "Live Load",
  "Span",
  "Total Load",
  "Type"
) VALUES (
  :"Index",
  :"Live Load",
  :"Span",
  :"Total Load",
  :"Type"
)
;

/* PUMP: (SReqList) */
INSERT INTO "SReqList" (
  "Job Number",
  "Page",
  "Section",
  "Tons"
) VALUES (
  :"Job Number",
  :"Page",
  :"Section",
  :"Tons"
)
;

/* PUMP: (Substbl) */
INSERT INTO "Substbl" (
  "Index",
  "Live Load",
  "Span",
  "Total Load"
) VALUES (
  :"Index",
  :"Live Load",
  :"Span",
  :"Total Load"
)
;

/* PUMP: (TimeStds) */
INSERT INTO "TimeStds" (
  "Hours",
  "Index",
  "Panels",
  "Type"
) VALUES (
  :"Hours",
  :"Index",
  :"Panels",
  :"Type"
)
;

/* PUMP: (Userlist) */
INSERT INTO "Userlist" (
  "Department",
  "Initials",
  "Password",
  "User"
) VALUES (
  :"Department",
  :"Initials",
  :"Password",
  :"User"
)
;

/* INDEX ("Angprop"): Angprop#PX */
ALTER TABLE "Angprop"
ADD PRIMARY KEY (
  "Sort"
)
;

/* INDEX ("Bridg"): BRIDG#PX */
ALTER TABLE "Bridg"
ADD PRIMARY KEY (
  "Job Number",
  "Page",
  "Mark"
)
;

/* INDEX ("Customer"): Customer#PX */
ALTER TABLE "Customer"
ADD PRIMARY KEY (
  "Customer"
)
;

/* INDEX ("JobInfo"): JOBINFO#PX */
ALTER TABLE "JobInfo"
ADD PRIMARY KEY (
  "Job Number"
)
;

/* INDEX ("JobInfo"): NAME */
CREATE INDEX NAME1
ON "JobInfo"(
  "Job Name"
)
;

/* INDEX ("JobInfo"): SORT */
CREATE INDEX SORT2
ON "JobInfo"(
  "Century",
  "Job Number"
)
;

/* INDEX ("JobMisc"): JOBMISC#PX */
ALTER TABLE "JobMisc"
ADD PRIMARY KEY (
  "Job Number",
  "Page",
  "Category",
  "Item"
)
;

/* INDEX ("JobMisc"): PRICETBL */
CREATE INDEX PRICETBL3
ON "JobMisc"(
  "Category",
  "Item"
)
;

/* INDEX ("Joists"): JOISTS#PX */
ALTER TABLE "Joists"
ADD PRIMARY KEY (
  "Job Number",
  "Page",
  "Mark"
)
;

/* INDEX ("KCSTbl"): KCSTBL#PX */
ALTER TABLE "KCSTbl"
ADD PRIMARY KEY (
  "Depth",
  "Index"
)
;

/* INDEX ("Pricetbl"): Pricetbl#PX */
ALTER TABLE "Pricetbl"
ADD PRIMARY KEY (
  "Category",
  "Item"
)
;

/* INDEX ("Quotes"): Quotes#PX */
ALTER TABLE "Quotes"
ADD PRIMARY KEY (
  "Job Number",
  "Page"
)
;

/* INDEX ("Rndprop"): Rndprop#PX */
ALTER TABLE "Rndprop"
ADD PRIMARY KEY (
  "Sort"
)
;

/* INDEX ("Seqreq"): Seqreq#PX */
ALTER TABLE "Seqreq"
ADD PRIMARY KEY (
  "Job Number",
  "Page"
)
;

/* INDEX ("ShopList"): SHOPLIST#PX */
ALTER TABLE "ShopList"
ADD PRIMARY KEY (
  "List Number",
  "Sort"
)
;

/* INDEX ("ShopList"): SEQUENCE */
CREATE INDEX SEQUENCE4
ON "ShopList"(
  "Job Number",
  "Mark"
)
;

/* INDEX ("Shopord"): SHOPORD#PX */
ALTER TABLE "Shopord"
ADD PRIMARY KEY (
  "List Number"
)
;

/* INDEX ("Shopord"): SEQUENCE */
CREATE INDEX SEQUENCE5
ON "Shopord"(
  "Job Number",
  "Page"
)
;

/* INDEX ("SJICatlg"): SJICATLG#PX */
ALTER TABLE "SJICatlg"
ADD PRIMARY KEY (
  "Type",
  "Index",
  "Span"
)
;

/* INDEX ("SJICatlg"): BYSPAN */
CREATE INDEX BYSPAN6
ON "SJICatlg"(
  "Type",
  "Span",
  "Index"
)
;

/* INDEX ("SReqList"): SREQLIST#PX */
ALTER TABLE "SReqList"
ADD PRIMARY KEY (
  "Job Number",
  "Page",
  "Section"
)
;

/* INDEX ("Substbl"): Substbl#PX */
ALTER TABLE "Substbl"
ADD PRIMARY KEY (
  "Index",
  "Span"
)
;

/* INDEX ("TimeStds"): TIMESTDS#PX */
ALTER TABLE "TimeStds"
ADD PRIMARY KEY (
  "Type",
  "Index",
  "Panels"
)
;

/* INDEX ("Userlist"): Userlist#PX */
ALTER TABLE "Userlist"
ADD PRIMARY KEY (
  "User"
)
;
