?
 TJOBINFOFORM 0N  TPF0TJobInfoFormJobInfoFormLeft?Top%BorderStylebsDialogCaptionJob InformationClientHeightDClientWidthyColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height?	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PositionpoScreenCenterOnClose	FormCloseOnCreate
FormCreateOnShowFormShowPixelsPerInch`
TextHeight TPageControlPageControl1LeftTopWidthqHeight
ActivePage	TabSheet1TabOrder  	TTabSheet	TabSheet1CaptionGeneralExplicitLeft ExplicitTop ExplicitWidth ExplicitHeight  	TGroupBox	GroupBox1LeftTopWidthYHeightuCaptionJob InformationTabOrder  TLabelLabel2LeftTop,Width3HeightCaption	Job Name:  TLabelLabel6LeftTopWidth<HeightCaptionJob Number:  TLabelLabel1LeftTopDWidth,HeightCaption	Location:  TLabelLabel3Left? TopDWidthHeightCaptionState:  TLabelLabel4Left? Top\WidthKHeightCaptionMiles to Jobsite:  TDBEditDBEdit2LeftXTop(Width? HeightCharCaseecUpperCase	DataFieldJob Name
DataSourceMainForm.DataSource3TabOrder  TDBEditDBEdit1LeftXTopWidth=Height	DataField
Job Number
DataSourceMainForm.DataSource3TabOrder   TDBEditDBEdit3LeftXTop@Width? HeightCharCaseecUpperCase	DataFieldLocation
DataSourceMainForm.DataSource3TabOrder  TDBEditDBEdit4LeftTop@Width=HeightCharCaseecUpperCase	DataFieldState
DataSourceMainForm.DataSource3TabOrder  TDBEditDBEdit5LeftTopXWidth=Height	DataFieldMiles
DataSourceMainForm.DataSource3TabOrder   	TGroupBox	GroupBox2LeftTop? WidthYHeightuCaptionCustomer InformationTabOrder TLabelLabel24LeftTopWidth/HeightCaption	Customer:  TLabelLabel5LeftTop,Width)HeightCaptionAddress:  TLabelLabel7Left? TopDWidthHeightCaptionState:  TLabelLabel8LeftTopDWidth,HeightCaption	Location:  TLabelLabel9LeftTop\Width.HeightCaption	Zip Code:  TDBEditDBEdit7LeftXTop(Width? HeightCharCaseecUpperCase	DataFieldBill Address
DataSourceMainForm.DataSource3TabOrder  TDBEditDBEdit8LeftXTop@Width? HeightCharCaseecUpperCase	DataField	Bill City
DataSourceMainForm.DataSource3TabOrder  TDBEditDBEdit9LeftTop@Width=HeightCharCaseecUpperCase	DataField
Bill State
DataSourceMainForm.DataSource3TabOrder  TDBEditDBEdit10LeftXTopXWidthaHeight	DataFieldBill Zip
DataSourceMainForm.DataSource3TabOrder  TDBLookupComboBoxDBLookupComboBox1LeftXTopWidth? Height	DataFieldCustomer
DataSourceMainForm.DataSource3KeyFieldCustomer	ListFieldCustomer
ListSourceDataSource2TabOrder     	TTabSheet	TabSheet2CaptionQuotesExplicitLeft ExplicitTop ExplicitWidth ExplicitHeight  	TGroupBox	GroupBox3LeftTopWidthYHeight? CaptionQuotesTabOrder  TDBGridDBGrid1LeftTopWidthIHeighthOptionsdgTitlesdgColumnResize
dgColLines
dgRowLinesdgTabsdgRowSelectdgAlwaysShowSelectiondgConfirmDeletedgCancelOnExit ReadOnly	TabOrder TitleFont.CharsetDEFAULT_CHARSETTitleFont.ColorclBlackTitleFont.Height?TitleFont.NameMS Sans SerifTitleFont.Style    	TGroupBox	GroupBox6LeftTop? Width? HeightaCaption
Quote InfoTabOrder TDBTextDBText1LefthTopWidthaHeight	AlignmenttaRightJustify	DataField	Tons SoldFont.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height?	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel14LeftTopWidthBHeightCaptionTotal Tons:Font.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height?	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel16LeftTop,WidthLHeightCaptionSelling Price:Font.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height?	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TDBTextDBText2LefthTop,WidthaHeight	AlignmenttaRightJustify	DataFieldSelling PriceFont.CharsetDEFAULT_CHARSET
Font.ColorclNavyFont.Height?	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont     TBitBtnOKBtnLeft? Top$WidthKHeightCaptionOKDefault	ModalResultTabOrderOnClick
OKBtnClickStylebsNew  TBitBtn	CancelBtnLeft*Top$WidthKHeightCancel	CaptionCancelModalResultTabOrderStylebsNew  TDataSourceDataSource2DataSetCustomerLeft Top?   	TADOTableCustomer
ConnectionMainForm.ADOConnection1
CursorTypectStaticLockType
ltReadOnlyIndexFieldNamesCustomer	TableNameCustomerLeft? Top?  TWideStringFieldCustomerCustomer	FieldNameCustomerSize  TWideStringFieldCustomerAddress	FieldNameAddressSize(  TWideStringFieldCustomerCity	FieldNameCitySize  TWideStringFieldCustomerState	FieldNameStateSize  TWideStringFieldCustomerZip	FieldNameZipSize
   	TADOQueryLastJobNumber
ConnectionMainForm.ADOConnection1
CursorTypectStatic
Parameters SQL.StringsSELECT TOP 5 [Job Number]        FROM [JobInfo]*  order by Century DESC, [Job Number] DESC Left? Top?  TWideStringFieldLastJobNumberJobNumber	FieldName
Job NumberSize    