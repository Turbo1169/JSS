unit Main;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, Buttons, StdCtrls, DBGrids, DBCtrls, Grids, DB, DBLookup, Mask,
  ComCtrls, Registry, about, math, ImgList, ToolWin, netsec, activeX,
  comobj, variants, midaslib, WideStrings, ADODB, XPMan, Provider, DBClient;

type
  tcexten=record
    depth,length,load:single;
    tcxtype,section:string[3];
    def:integer;
    supported:boolean;
  end;
  roundw=record
    section:string[2];
    qty:integer;
  end;
  Jtypes=set of char;
  PConcLoad=^TConcLoad;
  TConcLoad=Record
    Chord:String[2];
    Position:String[20];
    Dist,Force:single;
    vcb,Wind:Boolean;
  end;
  PPartLoad=^TPArtLoad;
  TPartLoad=Record
    Joint1,Joint2:integer;
    Position:String[25];
    Force,Force2:single;
    uplift:boolean;
  end;
  PPanels=^TPanels;
  TPanels=Record
    Length:single;
  end;
  Ploadrec=^loadrec;
  loadrec=Record
    Desc:string[40];
    Load,Load2:single;
  end;
  PSprink=^SprinkRec;
  SprinkRec=Record
    x,y,d:single;
  end;
  PMembData=^TMembData;
  TMembData=Record
    Joint1,Joint2:integer;
    Position:String[3];
    Material:char;
    Section:string[2];
    force,weld,thick,angle,csc,shear,Length:single;
    overst,maxc,maxt,allowt,allowc:single;
  end;
  PJointData=^TJointData;
  TJointData=Record
    CoordX,CoordY,ForceX,ForceY,DeltaX,DeltaY:single;
    Position:String[2];
  end;
  PAngProp=^TAngProp;
  TAngProp=Record
    prevmat,Section:String[2];
    Description:String[20];
    Radius,Total,Tons,Cost,Q,b,d,t,Area,Weight,Rx,Rz,Y,X,Ix,Iy:single;
    plate:integer;
  end;
  PRndProp=^TRndProp;
  TRndProp=Record
    Section:String[2];
    Description:String[20];
    Total,Tons,Cost,d,Area,Weight,R,I:single;
  end;
  EndPType=Record
    bending,me,mi,lr,l,f,fa,fa2,fe,ppfb,mpfb,cm,bratio,fcr:single;
    fillers:integer;
  end;
  Chordprop=Record
    Section:string[2];
    tenst,shrcap,fe,fa,lrmax,lrz,lrx,lryy,sl,ss,maxintp,maxforce,length,Ryy:single;
    fcr,bending,maxforce2,weld,cm,fa2,mlf,mlnf,bratio,mpmom,ppmom,mpfb,ppfb:single;
    fillers:integer;
  end;
  TMainForm = class(TForm)
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    PrintDialog1: TPrintDialog;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    DataSource5: TDataSource;
    DataSource3: TDataSource;
    Image1: TImage;
    DataSource4: TDataSource;
    DataSource6: TDataSource;
    DataSource7: TDataSource;
    DataSource8: TDataSource;
    DataSource9: TDataSource;
    JobOpen: TNotebook;
    PrevScroll: TPanel;
    PrevScroll2: TScrollBox;
    PreviewBar: TPanel;
    NextPage: TBitBtn;
    PrevPage: TBitBtn;
    Zoom: TBitBtn;
    PrevPrint: TBitBtn;
    PrevClose: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    TitleBar: TPanel;
    PaintBox1: TPaintBox;
    Hint: TStatusBar;
    BitBtn1: TBitBtn;
    ImageList1: TImageList;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    NewJob: TToolButton;
    OpenJob: TToolButton;
    jobinfobtn: TToolButton;
    ToolButton4: TToolButton;
    Print: TToolButton;
    PreviewBtn: TToolButton;
    Engineering: TToolButton;
    ToolButton8: TToolButton;
    Previous: TToolButton;
    Next: TToolButton;
    RefreshBtn: TToolButton;
    ToolButton13: TToolButton;
    AddEntry: TToolButton;
    DelEntry: TToolButton;
    Properties: TToolButton;
    ToolButton17: TToolButton;
    Sprinklers: TToolButton;
    Extensions: TToolButton;
    SJICatalog: TToolButton;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    Info1: TMenuItem;
    Delete2: TMenuItem;
    N4: TMenuItem;
    PrintPreview1: TMenuItem;
    Print1: TMenuItem;
    N3: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    Properties2: TMenuItem;
    View1: TMenuItem;
    engineering1: TMenuItem;
    N2: TMenuItem;
    Previous1: TMenuItem;
    Next1: TMenuItem;
    Refresh1: TMenuItem;
    Settings1: TMenuItem;
    MaterialProperties1: TMenuItem;
    PriceTable1: TMenuItem;
    SJICatalog1: TMenuItem;
    CustomerList1: TMenuItem;
    N9: TMenuItem;
    MatReq: TMenuItem;
    UpdateFile1: TMenuItem;
    Tools1: TMenuItem;
    Sprinklers1: TMenuItem;
    TCExtensions1: TMenuItem;
    MatSubst: TMenuItem;
    ViewDeflection1: TMenuItem;
    ExportJoist: TMenuItem;
    Help1: TMenuItem;
    ISPJoistHelp1: TMenuItem;
    Contents1: TMenuItem;
    N6: TMenuItem;
    About1: TMenuItem;
    ModuleBook: TNotebook;
    JobBook: TNotebook;
    ScrollBox1: TScrollBox;
    Label41: TLabel;
    DBText85: TDBText;
    Label42: TLabel;
    DBText86: TDBText;
    Label44: TLabel;
    DBText88: TDBText;
    Label45: TLabel;
    DBText89: TDBText;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    DBText90: TDBText;
    extrastabs: TTabControl;
    Memo1: TDBMemo;
    DBGrid1: TDBGrid;
    Panel5: TPanel;
    DBText2: TDBText;
    Label7: TLabel;
    Label8: TLabel;
    DBText3: TDBText;
    DBText4: TDBText;
    DBText5: TDBText;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    DBText6: TDBText;
    Label12: TLabel;
    DBText7: TDBText;
    DBText8: TDBText;
    DBText9: TDBText;
    Label13: TLabel;
    DBText10: TDBText;
    DBText11: TDBText;
    DBText12: TDBText;
    DBText13: TDBText;
    Label14: TLabel;
    DBText14: TDBText;
    Label15: TLabel;
    DBText15: TDBText;
    DBText16: TDBText;
    DBText17: TDBText;
    DBText18: TDBText;
    DBText19: TDBText;
    Label16: TLabel;
    DBText20: TDBText;
    DBText21: TDBText;
    DBText22: TDBText;
    DBText23: TDBText;
    Label17: TLabel;
    DBText24: TDBText;
    DBText25: TDBText;
    DBText26: TDBText;
    DBText27: TDBText;
    Label18: TLabel;
    DBText28: TDBText;
    DBText29: TDBText;
    DBText30: TDBText;
    DBText31: TDBText;
    DBText32: TDBText;
    DBText33: TDBText;
    Label19: TLabel;
    DBText34: TDBText;
    DBText35: TDBText;
    DBText36: TDBText;
    DBText37: TDBText;
    DBText38: TDBText;
    DBText39: TDBText;
    Label23: TLabel;
    DBText46: TDBText;
    DBText47: TDBText;
    DBText48: TDBText;
    DBText49: TDBText;
    DBText50: TDBText;
    DBText51: TDBText;
    DBText44: TDBText;
    DBText45: TDBText;
    DBText52: TDBText;
    DBText53: TDBText;
    DBText55: TDBText;
    DBText56: TDBText;
    DBText57: TDBText;
    DBText58: TDBText;
    DBText54: TDBText;
    Label21: TLabel;
    DBText40: TDBText;
    DBText41: TDBText;
    DBText42: TDBText;
    DBText43: TDBText;
    Label1: TLabel;
    Label22: TLabel;
    DBText65: TDBText;
    DBText66: TDBText;
    DBText67: TDBText;
    DBText68: TDBText;
    DBText70: TDBText;
    DBText69: TDBText;
    Label108: TLabel;
    DBText123: TDBText;
    DBText134: TDBText;
    DBText136: TDBText;
    DBText137: TDBText;
    DBText138: TDBText;
    DBText139: TDBText;
    Panel8: TPanel;
    Label25: TLabel;
    DBText59: TDBText;
    Label2: TLabel;
    DBText1: TDBText;
    Label3: TLabel;
    DBText60: TDBText;
    Label4: TLabel;
    DBText61: TDBText;
    Label5: TLabel;
    DBText62: TDBText;
    Label6: TLabel;
    DBText63: TDBText;
    Label20: TLabel;
    DBText64: TDBText;
    Label40: TLabel;
    DBText84: TDBText;
    Label51: TLabel;
    DBText91: TDBText;
    Label43: TLabel;
    DBText87: TDBText;
    JoistsPnl: TPanel;
    JobGrid: TDBGrid;
    BridgPnl: TPanel;
    SubstPnl: TPanel;
    ShopBook: TNotebook;
    DBText92: TDBText;
    Label92: TLabel;
    Label94: TLabel;
    DBText93: TDBText;
    DBText94: TDBText;
    DBText114: TDBText;
    Label100: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    DBText115: TDBText;
    Label106: TLabel;
    DBText116: TDBText;
    DBText117: TDBText;
    DBText118: TDBText;
    Label110: TLabel;
    DBText128: TDBText;
    DBText129: TDBText;
    DBText130: TDBText;
    DBText131: TDBText;
    DBText119: TDBText;
    DBText121: TDBText;
    DBText122: TDBText;
    DBGrid3: TDBGrid;
    DBGrid2: TDBGrid;
    JoistsPnl2: TPanel;
    BridgPnl2: TPanel;
    SubstPnl2: TPanel;
    EngineeringBook: TNotebook;
    Panel10: TPanel;
    Geometry: TPanel;
    Panel11: TPanel;
    GroupBox1: TGroupBox;
    Label24: TLabel;
    DBText71: TDBText;
    Label26: TLabel;
    WorkLen: TLabel;
    Label27: TLabel;
    JDepth: TLabel;
    Label29: TLabel;
    EffDepth: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    DBText72: TDBText;
    DBText73: TDBText;
    DBText75: TDBText;
    DBText76: TDBText;
    DBText77: TDBText;
    DBText79: TDBText;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    DBText80: TDBText;
    DBText81: TDBText;
    BCPanels: TLabel;
    Label37: TLabel;
    jshape: TLabel;
    Label36: TLabel;
    DBText82: TDBText;
    Label38: TLabel;
    DBText83: TDBText;
    jdesc: TLabel;
    DBText74: TDBText;
    DBText78: TDBText;
    GroupBox2: TGroupBox;
    LoadGrid: TStringGrid;
    GroupBox9: TGroupBox;
    Label95: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Klbl: TLabel;
    Fylbl: TLabel;
    Fblbl: TLabel;
    GroupBox10: TGroupBox;
    llvallbl: TLabel;
    Label52: TLabel;
    momilbl: TLabel;
    lllbl: TLabel;
    TLlbl: TLabel;
    tlvallbl: TLabel;
    Panel9: TPanel;
    Panel12: TPanel;
    GroupBox6: TGroupBox;
    Label70: TLabel;
    Label74: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label76: TLabel;
    Label72: TLabel;
    maxpanbc: TLabel;
    reactionre: TLabel;
    maxbctension: TLabel;
    intpantc: TLabel;
    reactionle: TLabel;
    minshear: TLabel;
    maxtccomp: TLabel;
    GroupBox7: TGroupBox;
    Label39: TLabel;
    CaseDesc: TListBox;
    CaseCombo: TComboBox;
    EngGrid: TStringGrid;
    Panel13: TPanel;
    Panel14: TPanel;
    GroupBox8: TGroupBox;
    Label80: TLabel;
    Label81: TLabel;
    chlabel1: TLabel;
    chlabel2: TLabel;
    Label84: TLabel;
    chlabel3: TLabel;
    chlabel4: TLabel;
    Label87: TLabel;
    chlabel5: TLabel;
    chlabel6: TLabel;
    Label90: TLabel;
    chlabel7: TLabel;
    chlabel8: TLabel;
    Label93: TLabel;
    chlabel9: TLabel;
    chlabel10: TLabel;
    Label96: TLabel;
    chlabel11: TLabel;
    chlabel12: TLabel;
    Label99: TLabel;
    chlabel13: TLabel;
    chlabel14: TLabel;
    Label102: TLabel;
    chlabel15: TLabel;
    chlabel16: TLabel;
    Label105: TLabel;
    GroupBox11: TGroupBox;
    Label91: TLabel;
    tclabel1: TLabel;
    Label82: TLabel;
    tclabel2: TLabel;
    Label85: TLabel;
    tclabel3: TLabel;
    Label88: TLabel;
    tclabel5: TLabel;
    Label101: TLabel;
    tclabel6: TLabel;
    Label117: TLabel;
    tclabel4: TLabel;
    Label83: TLabel;
    tclabel7: TLabel;
    Label86: TLabel;
    tclabel8: TLabel;
    GroupBox12: TGroupBox;
    Label89: TLabel;
    bclabel1: TLabel;
    Label107: TLabel;
    bclabel7: TLabel;
    Label109: TLabel;
    bclabel8: TLabel;
    Label111: TLabel;
    bclabel5: TLabel;
    Label113: TLabel;
    bclabel6: TLabel;
    Label119: TLabel;
    bclabel2: TLabel;
    Label121: TLabel;
    bclabel3: TLabel;
    Label115: TLabel;
    bclabel4: TLabel;
    WebPanel: TPanel;
    JointPanel: TPanel;
    MembPanel: TPanel;
    EngMemo: TMemo;
    Panel3: TPanel;
    ListBox1: TListBox;
    Export1: TMenuItem;
    N10: TMenuItem;
    Import1: TMenuItem;
    ImportJoists: TMenuItem;
    N5: TMenuItem;
    OpenDialog1: TOpenDialog;
    Label53: TLabel;
    Label54: TLabel;
    DrawAutoCAD: TMenuItem;
    ADOConnection1: TADOConnection;
    SJICatlg: TADOTable;
    SJICatlgType: TWideStringField;
    SJICatlgIndex: TSmallintField;
    SJICatlgSpan: TSmallintField;
    SJICatlgTotalLoad: TSmallintField;
    SJICatlgLiveLoad: TSmallintField;
    KCSJoists: TADOTable;
    KCSJoistsDepth: TSmallintField;
    KCSJoistsIndex: TSmallintField;
    KCSJoistsMoment: TFloatField;
    KCSJoistsShear: TFloatField;
    KCSJoistsInertia: TFloatField;
    TimeStds: TADOTable;
    Users: TADOTable;
    UsersUser: TWideStringField;
    UsersInitials: TWideStringField;
    UsersPassword: TWideStringField;
    UsersDepartment: TSmallintField;
    TimeStdsType: TWideStringField;
    TimeStdsIndex: TSmallintField;
    TimeStdsPanels: TSmallintField;
    TimeStdsHours: TFloatField;
    PriceTbl: TADOTable;
    PriceTblCategory: TWideStringField;
    PriceTblItem: TSmallintField;
    PriceTblDescription: TWideStringField;
    PriceTblUnitPrice: TFloatField;
    PriceTblUnit: TWideStringField;
    Job: TADOQuery;
    JobJobNumber: TWideStringField;
    JobJobName: TWideStringField;
    JobLocation: TWideStringField;
    JobState: TWideStringField;
    JobMiles: TSmallintField;
    JobCustomer: TWideStringField;
    JobBillAddress: TWideStringField;
    JobBillCity: TWideStringField;
    JobBillState: TWideStringField;
    JobBillZip: TWideStringField;
    JobSold: TBooleanField;
    JobCentury: TSmallintField;
    JobLocation2: TWideStringField;
    JobInfo: TADOQuery;
    JobInfoJobNumber: TWideStringField;
    JobInfoPage: TSmallintField;
    JobInfoDescription: TWideStringField;
    JobInfoDateQuoted: TDateTimeField;
    JobInfoL1Pieces: TSmallintField;
    JobInfoL1Tons: TFloatField;
    JobInfoL1Material: TFloatField;
    JobInfoL1LineHrs: TFloatField;
    JobInfoL2Pieces: TSmallintField;
    JobInfoL2Tons: TFloatField;
    JobInfoL2Material: TFloatField;
    JobInfoL2LineHrs: TFloatField;
    JobInfoLSPieces: TSmallintField;
    JobInfoLSTons: TFloatField;
    JobInfoLSMaterial: TFloatField;
    JobInfoLSLineHrs: TFloatField;
    JobInfoJGPieces: TSmallintField;
    JobInfoJGTons: TFloatField;
    JobInfoJGMaterial: TFloatField;
    JobInfoJGLineHrs: TFloatField;
    JobInfoHBPieces: TIntegerField;
    JobInfoHBTons: TFloatField;
    JobInfoHBMaterial: TFloatField;
    JobInfoXBPieces: TIntegerField;
    JobInfoXBTons: TFloatField;
    JobInfoXBMaterial: TFloatField;
    JobInfoKBPieces: TIntegerField;
    JobInfoKBTons: TFloatField;
    JobInfoKBMaterial: TFloatField;
    JobInfoJSPieces: TIntegerField;
    JobInfoJSTons: TFloatField;
    JobInfoJSMaterial: TFloatField;
    JobInfoProfitLH: TFloatField;
    JobInfoTotalPaint: TFloatField;
    JobInfoTotalMisc: TFloatField;
    JobInfoTotalFees: TFloatField;
    JobInfoTotalFreight: TFloatField;
    JobInfoCommission: TFloatField;
    JobInfoExtras: TFloatField;
    JobInfoDetail: TSmallintField;
    JobInfoApproval: TSmallintField;
    JobInfoFabrication: TSmallintField;
    JobInfoList: TSmallintField;
    JobInfoSSLineHour: TFloatField;
    JobInfoLSLineHour: TFloatField;
    JobInfoOverweight: TFloatField;
    JobInfoHBLaborCost: TFloatField;
    JobInfoXBLaborCost: TFloatField;
    JobInfoKBLaborCost: TFloatField;
    JobInfoJSLaborCost: TFloatField;
    JobInfoStatus: TWideStringField;
    JobInfoTonsSold: TFloatField;
    JobInfoSubTotal1: TCurrencyField;
    JobInfoSubTotal2: TCurrencyField;
    JobInfoSellingPrice: TCurrencyField;
    JobInfoTotalProfit: TCurrencyField;
    JobInfoL1TonLH: TFloatField;
    JobInfoL2TonLH: TFloatField;
    JobInfoLSTonLH: TFloatField;
    JobInfoJGTonLH: TFloatField;
    JobInfoL1Labor: TCurrencyField;
    JobInfoL2Labor: TCurrencyField;
    JobInfoJGLabor: TCurrencyField;
    JobInfoLSLabor: TCurrencyField;
    JobInfoHBLabor: TCurrencyField;
    JobInfoXBLabor: TCurrencyField;
    JobInfoKBLabor: TCurrencyField;
    JobInfoJSLabor: TCurrencyField;
    JobInfoL1Cost: TCurrencyField;
    JobInfoL2Cost: TCurrencyField;
    JobInfoLSCost: TCurrencyField;
    JobInfoJGCost: TCurrencyField;
    JobInfoHBCost: TCurrencyField;
    JobInfoXBCost: TCurrencyField;
    JobInfoKBCost: TCurrencyField;
    JobInfoJSCost: TCurrencyField;
    JobInfoL1TotalProfit: TCurrencyField;
    JobInfoL2TotalProfit: TCurrencyField;
    JobInfoLSTotalProfit: TCurrencyField;
    JobInfoJGTotalProfit: TCurrencyField;
    JobInfoL1PriceProfit: TCurrencyField;
    JobInfoL2PriceProfit: TCurrencyField;
    JobInfoLSPriceProfit: TCurrencyField;
    JobInfoJGPriceProfit: TCurrencyField;
    JobInfoTotalPieces: TIntegerField;
    JobInfoTotalMaterial: TCurrencyField;
    JobInfoTotalTons: TFloatField;
    JobInfoTotalLH: TFloatField;
    JobInfoTotalLabor: TCurrencyField;
    JobInfoTonsLH: TFloatField;
    JobInfoTotalCost: TCurrencyField;
    JobInfoTotalPrice: TCurrencyField;
    JobInfototdet: TIntegerField;
    JobInfoprojlist: TDateTimeField;
    JobInfoprojdet: TDateTimeField;
    JobInfoValidUntil: TDateTimeField;
    JobInfoNotes: TWideMemoField;
    JobMisc: TADOQuery;
    JobMiscJobNumber: TWideStringField;
    JobMiscPage: TSmallintField;
    JobMiscCategory: TWideStringField;
    JobMiscItem: TSmallintField;
    JobMiscQuantity: TIntegerField;
    JobMiscUnitPrice: TFloatField;
    JobMiscValue: TFloatField;
    JobMiscDescription: TStringField;
    JobMiscUnit: TStringField;
    JobMiscTotalPrice: TCurrencyField;
    Joists: TADOQuery;
    JoistsJobNumber: TWideStringField;
    JoistsPage: TSmallintField;
    JoistsMark: TWideStringField;
    JoistsQuantity: TSmallintField;
    JoistsDescription: TWideStringField;
    JoistsRunBy: TWideStringField;
    JoistsShape: TWideStringField;
    JoistsJoistType: TWideStringField;
    JoistsBaseLength: TWideStringField;
    JoistsSeatsBDL: TWideStringField;
    JoistsSeatLengthLE: TWideStringField;
    JoistsSeatsBDR: TWideStringField;
    JoistsSeatLengthRE: TWideStringField;
    JoistsTCXL: TWideStringField;
    JoistsTCXLTY: TWideStringField;
    JoistsTCXR: TWideStringField;
    JoistsTCXRTY: TWideStringField;
    JoistsBCXL: TWideStringField;
    JoistsBCXLTY: TWideStringField;
    JoistsBCXR: TWideStringField;
    JoistsBCXRTY: TWideStringField;
    JoistsTCUniformLoad: TFloatField;
    JoistsBCUniformLoad: TFloatField;
    JoistsNetUplift: TFloatField;
    JoistsAnyPanel: TFloatField;
    JoistsTCAxialLoad: TFloatField;
    JoistsBCAxialLoad: TFloatField;
    JoistsFixedMomentLE: TFloatField;
    JoistsFixedMomentRE: TFloatField;
    JoistsLateralMomentLE: TFloatField;
    JoistsLateralMomentRE: TFloatField;
    JoistsBCPanelsLE: TWideStringField;
    JoistsBCPanelsRE: TWideStringField;
    JoistsTCPanelsLE: TWideStringField;
    JoistsTCPanelsRE: TWideStringField;
    JoistsFirstDiagLE: TWideStringField;
    JoistsFirstDiagRE: TWideStringField;
    JoistsBCPanel: TWideStringField;
    JoistsBCP: TSmallintField;
    JoistsDepthLE: TFloatField;
    JoistsRidgePosition: TWideStringField;
    JoistsDepthRE: TFloatField;
    JoistsScissorAdd: TFloatField;
    JoistsTime: TFloatField;
    JoistsWeight: TFloatField;
    JoistsMaterial: TFloatField;
    JoistsChords: TWideStringField;
    JoistsLLDeflection: TSmallintField;
    JoistsTLDeflection: TSmallintField;
    JoistsAnywhereTC: TFloatField;
    JoistsAnywhereBC: TFloatField;
    JoistsExtras: TMemoField;
    JoistsConsolidate: TBooleanField;
    JoistsAddLoad: TFloatField;
    Joistsfirsthalfle: TStringField;
    Joistsfirsthalfre: TStringField;
    JoistsShape2: TStringField;
    Bridg: TADOQuery;
    BridgJobNumber: TWideStringField;
    BridgPage: TSmallintField;
    BridgMark: TWideStringField;
    BridgPlanFeet: TIntegerField;
    BridgType: TWideStringField;
    BridgRunBy: TWideStringField;
    BridgWeight: TFloatField;
    BridgMaterial: TFloatField;
    BridgSection: TWideStringField;
    BridgDescription: TStringField;
    Sequence: TADOQuery;
    SequenceJobNumber: TWideStringField;
    SequencePage: TSmallintField;
    SequenceDescription: TWideStringField;
    SequenceIndex: TWideStringField;
    SequencePaint: TWideStringField;
    SequenceDepartment: TSmallintField;
    SequenceL1Pieces: TSmallintField;
    SequenceL1Tons: TFloatField;
    SequenceL1Material: TFloatField;
    SequenceL1LineHrs: TFloatField;
    SequenceL2Pieces: TSmallintField;
    SequenceL2Tons: TFloatField;
    SequenceL2Material: TFloatField;
    SequenceL2LineHrs: TFloatField;
    SequenceLSPieces: TSmallintField;
    SequenceLSTons: TFloatField;
    SequenceLSMaterial: TFloatField;
    SequenceLSLineHrs: TFloatField;
    SequenceJGPieces: TSmallintField;
    SequenceJGTons: TFloatField;
    SequenceJGMaterial: TFloatField;
    SequenceJGLineHrs: TFloatField;
    SequenceHBPieces: TIntegerField;
    SequenceHBTons: TFloatField;
    SequenceHBMaterial: TFloatField;
    SequenceXBPieces: TIntegerField;
    SequenceXBTons: TFloatField;
    SequenceXBMaterial: TFloatField;
    SequenceKBPieces: TIntegerField;
    SequenceKBTons: TFloatField;
    SequenceKBMaterial: TFloatField;
    SequenceProfitLH: TFloatField;
    SequenceTotalPaint: TFloatField;
    SequenceTotalMisc: TFloatField;
    SequenceTotalFees: TFloatField;
    SequenceTotalFreight: TFloatField;
    SequenceCommission: TFloatField;
    SequenceExtras: TFloatField;
    SequenceDetail: TSmallintField;
    SequenceApproval: TSmallintField;
    SequenceFabrication: TSmallintField;
    SequenceList: TSmallintField;
    SequenceSSLineHour: TFloatField;
    SequenceLSLineHour: TFloatField;
    SequenceOverweight: TFloatField;
    SequenceHBLaborCost: TFloatField;
    SequenceXBLaborCost: TFloatField;
    SequenceKBLaborCost: TFloatField;
    SequenceStatus: TWideStringField;
    SequenceNotes: TWideMemoField;
    SequenceTotalPieces: TIntegerField;
    SequenceTotalTons: TFloatField;
    SequenceTotalLH: TFloatField;
    Shoporder: TADOQuery;
    ShoporderListNumber: TIntegerField;
    ShoporderDate: TDateTimeField;
    ShoporderJobNumber: TWideStringField;
    ShoporderPage: TSmallintField;
    ShoporderListType: TWideStringField;
    ShoporderQuantity: TSmallintField;
    ShoporderTons: TFloatField;
    ShoporderTime: TFloatField;
    ShoporderType: TStringField;
    ShopordList: TADOQuery;
    ShopordListListNumber: TIntegerField;
    ShopordListSort: TSmallintField;
    ShopordListJobNumber: TWideStringField;
    ShopordListMark: TWideStringField;
    ShopordListQuantity: TSmallintField;
    ShopordListDescription: TWideStringField;
    ShopordListLength: TWideStringField;
    ShopordListWeight: TFloatField;
    ShopordListTime: TFloatField;
    ShopordListTons: TFloatField;
    Bridg2: TADOQuery;
    Bridg2JobNumber: TWideStringField;
    Bridg2Page: TSmallintField;
    Bridg2Mark: TWideStringField;
    Bridg2Quantity: TSmallintField;
    Bridg2Section: TWideStringField;
    Bridg2Length: TWideStringField;
    Bridg2HH: TWideStringField;
    Bridg2StringField12H: TWideStringField;
    Bridg2Detail: TWideStringField;
    Bridg2Weight: TFloatField;
    Bridg2RunBy: TWideStringField;
    JSubst: TADOQuery;
    JSubstJobNumber: TWideStringField;
    JSubstPage: TSmallintField;
    JSubstMark: TWideStringField;
    JSubstQuantity: TSmallintField;
    JSubstDescription: TWideStringField;
    JSubstType: TWideStringField;
    JSubstBaseLength: TWideStringField;
    JSubstRunBy: TWideStringField;
    JSubstWeight: TFloatField;
    JSubstMaterial: TFloatField;
    JSubstSection: TWideStringField;
    JSubstAxialLoad: TFloatField;
    JSubstDeflection: TSmallintField;
    JSubstConfiguration: TStringField;
    JoistsLRFD: TBooleanField;
    BatchedJoists: TADOQuery;
    BatchedJoistsMark: TWideStringField;
    BatchedJoistsListNumber: TIntegerField;
    Splitter1: TSplitter;
    XPManifest1: TXPManifest;
    procedure Exit1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddEntryClick(Sender: TObject);
    procedure DelEntryClick(Sender: TObject);
    procedure DataSource2DataChange(Sender: TObject; Field: TField);
    procedure Close1Click(Sender: TObject);
    procedure JobGridKeyPress(Sender: TObject; var Key: Char);
    procedure SJICatalog1Click(Sender: TObject);
    procedure PrintClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Engineering1Click(Sender: TObject);
    procedure PriceTable1Click(Sender: TObject);
    procedure PrintPreview1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure OpenJobClick(Sender: TObject);
    procedure ModuleBookPageChanged(Sender: TObject);
    procedure PropertiesClick(Sender: TObject);
    procedure ExportJoistClick(Sender: TObject);
    procedure NextPageClick(Sender: TObject);
    procedure PrevPageClick(Sender: TObject);
    procedure ZoomClick(Sender: TObject);
    procedure PrevCloseClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure PreviousClick(Sender: TObject);
    procedure MaterialProperties1Click(Sender: TObject);
    procedure NewJobClick(Sender: TObject);
    procedure Delete2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EngGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure LoadGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure CustomerList1Click(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure SprinklersClick(Sender: TObject);
    procedure ExtensionsClick(Sender: TObject);
    procedure CaseComboChange(Sender: TObject);
    procedure MatReqClick(Sender: TObject);
    procedure MatSubstClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure extrastabsChange(Sender: TObject);
    procedure DBGrid4KeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ISPJoistHelp1Click(Sender: TObject);
    procedure UpdateFile1Click(Sender: TObject);
    procedure ViewDeflection1Click(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure ImportJoistsClick(Sender: TObject);
    procedure DrawAutoCADClick(Sender: TObject);
    procedure JobCalcFields(DataSet: TDataSet);
    procedure JobInfoCalcFields(DataSet: TDataSet);
    procedure JobMiscCalcFields(DataSet: TDataSet);
    procedure JoistsTCXLValidate(Sender: TField);
    procedure JoistsTCXRValidate(Sender: TField);
    procedure JoistsTCXLTYValidate(Sender: TField);
    procedure JoistsFirstDiagLEValidate(Sender: TField);
    procedure JoistsFirstDiagREValidate(Sender: TField);
    procedure JoistsDescriptionValidate(Sender: TField);
    procedure JoistsBCPanelsLEValidate(Sender: TField);
    procedure JoistsBCPanelsREValidate(Sender: TField);
    procedure JoistsTCPanelsLEValidate(Sender: TField);
    procedure JoistsBCPanelValidate(Sender: TField);
    procedure JoistsBCPValidate(Sender: TField);
    procedure JoistsDepthLEValidate(Sender: TField);
    procedure JoistsDepthREValidate(Sender: TField);
    procedure JoistsCalcFields(DataSet: TDataSet);
    procedure BridgCalcFields(DataSet: TDataSet);
    procedure SequenceCalcFields(DataSet: TDataSet);
    procedure ShoporderCalcFields(DataSet: TDataSet);
    procedure ShopordListCalcFields(DataSet: TDataSet);
    procedure JSubstCalcFields(DataSet: TDataSet);
    procedure JSubstDeflectionValidate(Sender: TField);
    procedure DataSource6DataChange(Sender: TObject; Field: TField);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure JobMiscAfterInsert(DataSet: TDataSet);
    procedure PriceTblAfterInsert(DataSet: TDataSet);
    procedure JobCustomerValidate(Sender: TField);
    procedure SequenceAfterOpen(DataSet: TDataSet);
    procedure SequenceBeforeClose(DataSet: TDataSet);
    procedure JoistsLRFDValidate(Sender: TField);
  private
    { Private declarations }
    procedure showhint(Sender:Tobject);
    procedure Dojobopen;
    procedure login;
    procedure previewpaint;
    procedure FillCaseCombo;
  public
    { Public declarations }
    procedure closefile;
    function nextsection(section:string):string;
    procedure findangle(section:string);
    procedure findrnd(section:string);
    function findmemb(pos:string; rol:char):boolean;
    procedure findjoint(pos:string; rol:char);
    procedure doextras(cat:smallint);
    procedure recalcjoist;
    function solvefa(fa:single; chord:chordprop):single;
    function chkshear(var Chord:Chordprop):boolean;
    procedure joistpaint;
    function findsupmemb:single;
  end;

const
     jtype1:jtypes=['G','B','V','N'];
     jtype2:jtypes=['K','C','L','D'];
     SSMan:integer=26;
     LSMan:integer=24;
     E:single=29000;
     Fy:single=50;
     overst:single=1.00; {allowed overstress in design}
     depthvar:single=0; {allowed percent of variation between assumed and single depth}
     nodes:integer=90;
     AWeld:single=21; //Allowable weld stress ksi

var
  MainForm: TMainForm;
  PanelList,ConcList,SprinkList,loadList,RndList,AngList,JointList,MemberList:TList;
  PartList:Tlist;
  ConcData:PConcLoad;
  PartData:PPartLoad;
  TCPanel:PPanels;
  AngProp:PAngProp;
  RndProp:PRndProp;
  MembData:PMembData;
  JointData:PJointData;
  loads:Ploadrec;
  Sprinkler:PSprink;
  EndPL,EndPR,FirstPL,FirstPR:EndPType;
  BCSection,TCSection:Chordprop;
  sppanels,stseam,joverst,halfpRE,halfpLE,newbcl,rndweb,newg,fileopen:boolean;
  plate,supp1,supp2,dept,reportn,prevpages,currpage,middle:integer;
  momi,latsup,minshr,r1,r2,r3,realed,gap,depth,center,bcl,ed,wl,bl,load:single;
  latsup2,maxr1,maxr2,bending,maxshr,maxtsh,fb,k,livel,ll360,ll240:single;
  deltascle,plateweight,maxcv2,maxtv2,material,weight:single;
  jtype:char;
  joistmemo:tdbmemo;
  rw1,rw2l,rw2r,rw3:roundw;
  runby:string[3];
  mintc,minbc:string[2];
  tcxl,tcxr:tcexten;
  sp:integer;
  LRFD:boolean;

implementation

uses joistrep, Import, PSI, exportjobs, joblook, entry, catalog, jobprop, customer,
  pricetbl, analysis, output, output2, login, main2, matprop, jobinfo, bridging,
  sprink, tcexten, jsubst, seqprop, batch, matreq, fixes, entry2, bridg2;

{$R *.DFM}
{$R EXTRAS.RES}

const
   SECTION='ISP Joist Design';

var
   prevzoom:integer;
   finifile:TRegIniFile;
   JoistDraw,Preview:TImage;

function dectoing(decn:single):shortstring; external 'comlib.dll';
function dectoinch(decn:single):shortstring; external 'comlib.dll';
function ingtodec(ing:shortstring):single; external 'comlib.dll';
function mpass:shortstring; external 'comlib.dll';
function verifyreg:boolean; external 'comlib.dll';

function TemplateGetUser: string;
var
  name: PChar;
  size: Cardinal;
begin
  size := 255;
  name := StrAlloc( size);
  GetUserName( name, size);
  result := name;
  StrDispose( name)
end;

procedure CalcAng;
var
   temp,a1,iz,a,c:single;
begin
     a:=angprop^.b-angprop^.t; c:=angprop^.d-angprop^.t;
     angprop^.area:=(angprop^.b+c)*angprop^.t;
     angprop^.x:=(intpower(angprop^.b,2)+c*angprop^.t)/(2*(angprop^.b+c));
     angprop^.y:=(intpower(angprop^.d,2)+a*angprop^.t)/(2*(angprop^.b+c));
     angprop^.Ix:=angprop^.t*intpower((angprop^.d-angprop^.y),3)+angprop^.b*intpower(angprop^.y,3);
     angprop^.Ix:=(angprop^.Ix-a*intpower((angprop^.y-angprop^.t),3))/3;
     angprop^.Iy:=angprop^.t*intpower((angprop^.b-angprop^.x),3)+angprop^.d*intpower(angprop^.x,3);
     angprop^.Iy:=(angprop^.Iy-c*intpower((angprop^.x-angprop^.t),3))/3;
     angprop^.Rx:=sqrt(angprop^.Ix/angprop^.area);
     a1:=((angprop^.d-angprop^.t)*angprop^.t)*(angprop^.t/2-angprop^.x)*((angprop^.d-angprop^.t)/2+angprop^.t-angprop^.y);
     a1:=a1+((angprop^.b*angprop^.t)*(angprop^.b/2-angprop^.x)*(angprop^.t/2-angprop^.y));
     iz:=(angprop^.Ix+angprop^.Iy)/2-sqrt(intpower((angprop^.Ix-angprop^.Iy)/2,2)+intpower(a1,2));
     angprop^.rz:=sqrt(iz/angprop^.area);
     angprop^.weight:=489.75/144*angprop^.area;
     if angprop^.b>angprop^.d then
        temp:=angprop^.b
     else
         temp:=angprop^.d;
     temp:=temp/angprop^.t;
     if temp<=76/sqrt(Fy) then
        angprop^.Q:=1;
     if (76/sqrt(Fy)<temp) and (temp<155/sqrt(Fy)) then
        angprop^.Q:=1.34-0.00447*temp*sqrt(Fy);
     if temp>=155/sqrt(Fy) then
        angprop^.Q:=15500/(Fy*intpower(temp,2));
end;

procedure CalcRnd;
begin
     RndProp^.area:=pi*sqr(rndprop^.d/2);
     RndProp^.R:=RndProp^.d/4;
     RndProp^.I:=pi*intpower(RndProp^.d/2,4)/4;
     Rndprop^.weight:=489.75/144*Rndprop^.area;
end;

procedure CalcAngProp;
const
     combgap:single=1;
var
   table1:TADOTable;
   pc,x:integer;
   tempwt,tempx,tempy,tempix,tempiy,a1,a2,a3,d1,d2,d3:single;
   usesect:boolean;
begin
     table1:=TADOTable.create(application);
     table1.Connection:=Mainform.ADOConnection1;
     table1.tablename:='angprop';
     table1.indexfieldnames:='sort';
     table1.open; table1.first;
     pc:=0;
     while not table1.eof do
     begin
          New(AngProp); anglist.add(AngProp);
          angprop^.section:=table1.fieldbyname('section').asstring;
          angprop^.description:=table1.fieldbyname('Description').asstring;
          angprop^.b:=table1.fieldbyname('b1').asfloat;
          angprop^.d:=table1.fieldbyname('b2').asfloat;
          angprop^.t:=table1.fieldbyname('Thick').asfloat;
          angprop^.cost:=table1.fieldbyname('Cost').asfloat;
          angprop^.radius:=table1.fieldbyname('Radius').asfloat;
          angprop^.plate:=0;
          angprop^.prevmat:='';
          CalcAng;
          usesect:=true;
          if (dept=0) and (not table1.fieldbyname('for sales').AsBoolean) then
             usesect:=false;
          if (table1.fieldbyname('plate').AsBoolean) and usesect then
          begin
               tempix:=angprop^.Ix;
               tempiy:=angprop^.Iy;
               tempy:=angprop^.y;
               tempx:=angprop^.x;
               tempwt:=angprop^.weight;
               for x:=1 to 4 do
               begin
                    inc(pc);
                    New(AngProp); anglist.add(AngProp);
                    angprop^.b:=table1.fieldbyname('b1').asfloat;
                    angprop^.d:=table1.fieldbyname('b2').asfloat;
                    angprop^.t:=table1.fieldbyname('Thick').asfloat;
                    angprop^.cost:=table1.fieldbyname('Cost').asfloat;
                    angprop^.prevmat:=table1.fieldbyname('section').asstring;
                    case x of
                      1:begin
                             angprop^.plate:=2;
                        end;
                      2:begin
                             angprop^.plate:=4;
                        end;
                      3:begin
                             angprop^.plate:=6;
                        end;
                      4:begin
                             angprop^.plate:=8;
                        end;
                    end;
                    if pc<10 then
                       angprop^.Section:='P'+inttostr(pc)
                    else
                        angprop^.Section:='P'+chr(pc+55);
                    angprop^.description:=floattostr(angprop^.b)+' x '+format('%0.3f',[angprop^.t])+
                      ' w '+inttostr(angprop^.plate)+' PL';
                    angprop^.x:=0;
                    a1:=angprop^.t*angprop^.b;
                    a2:=angprop^.t*(angprop^.d-angprop^.t);
                    a3:=angprop^.plate*combgap;
                    d1:=angprop^.t/2;
                    d2:=(angprop^.d-angprop^.t)/2+angprop^.t;
                    d3:=angprop^.plate/2+0.25;
                    angprop^.area:=((a1+a2)*2+a3)/2;
                    angprop^.y:=((a1*d1+a2*d2)*2+a3*d3)/(2*(a1+a2)+a3);
                    angprop^.Ix:=(tempix+(a1+a2)*sqr(angprop^.y-tempy))*2;
                    angprop^.Ix:=angprop^.ix+combgap*intpower(angprop^.plate,3)/12+(combgap*angprop^.plate)*sqr(angprop^.y-d3);
                    angprop^.Ix:=angprop^.Ix/2;
                    angprop^.Rx:=sqrt(angprop^.ix/angprop^.area);
                    angprop^.Iy:=(tempiy+(a1+a2)*sqr(tempx+combgap/2))*2+angprop^.plate*intpower(combgap,3)/12;
                    angprop^.Rz:=angprop^.Rx;
                    angprop^.Weight:=tempwt;
                    angprop^.area:=((a1+a2)*2+a3)/2;
                    angprop^.q:=1;

               end;
          end;
          table1.next;
     end;
     table1.close;
     table1.free;
end;

procedure CalcRndProp;
var
   table1:TADOTable;
begin
     table1:=TADOTable.create(application);
     table1.Connection:=Mainform.ADOConnection1;
     table1.tablename:='rndprop';
     table1.indexfieldnames:='sort';
     table1.open; table1.first;
     while not table1.eof do
     begin
          New(RndProp); rndlist.add(RndProp);
          Rndprop^.Section:=table1.fieldbyname('section').asstring;
          rndprop^.description:=table1.fieldbyname('Description').asstring;
          RndProp^.d:=table1.fieldbyname('Thick').asfloat;
          RndProp^.cost:=table1.fieldbyname('cost').asfloat;
          CalcRnd;
          table1.next;
     end;
     table1.close;
     table1.free;
end;

function TMainForm.findsupmemb:single;
var
   found:boolean;
   x1,x2:single;
   c:integer;
   chord:string;
begin
     c:=0;
     found:=false;
     x1:=0;
     x2:=0;
     while (c<=memberlist.count-1) and not found do
     begin
          membdata:=MemberList.items[c];
          jointdata:=JointList.Items[membdata^.joint1-1];
          chord:=jointdata^.Position;
          x1:=jointdata^.CoordX;
          jointdata:=JointList.Items[membdata^.joint2-1];
          x2:=jointdata^.CoordX;
          if (jointdata^.Position=ConcData^.Chord) and (ConcData^.Chord=chord) and (concdata^.Dist>=x1) and (concdata^.Dist<=x2) then
             found:=true
          else
              inc(c);
     end;
     if found then
        result:=1-(concdata^.dist-x1)/(x2-x1)
     else
        result:=0;
end;

procedure TMainForm.joistpaint;
var
   temprect:trect;
begin
     with joistdraw.Canvas do
     begin
          pen.color:=clwhite;
          brush.color:=clwhite;
          brush.style:=bssolid;
          rectangle(0,0,width,height);
     end;
     temprect:=joistdraw.clientrect;
     drawjoist(joistdraw.canvas,temprect);
end;

procedure TMainForm.previewpaint;
begin
     preview.Hide;
     preview.top:=4;
     preview.height:=(prevscroll2.clientheight-8)*prevzoom;
     preview.width:=trunc((preview.height/11)*8.5);
     if prevscroll2.clientwidth>(preview.width)+8 then
        preview.left:=trunc((prevscroll2.clientwidth-preview.width)/2)
     else
     begin
         preview.left:=0;
         preview.top:=0;
     end;
     with preview.Canvas do
     begin
          pen.color:=clwhite;
          brush.color:=clwhite;
          brush.style:=bssolid;
          rectangle(0,0,width,height);
     end;
     preview.show;
     if modulebook.pageindex=2 then
     begin
          prevpages:=2;
          drawstress(preview.canvas,preview.height/11,(preview.width/8.5)/screen.pixelsperinch,currpage);
     end;
     if (modulebook.pageindex=0) and (jobbook.pageindex=0) then
     begin
          prevpages:=2;
          if currpage=1 then
             drawbid(preview.canvas,preview.height/11,(preview.width/8.5)/screen.pixelsperinch);
          if currpage=2 then
             drawconf(preview.canvas,preview.height/11,(preview.width/8.5)/screen.pixelsperinch);
     end;
     if currpage=prevpages then
        nextpage.enabled:=false
     else
         nextpage.enabled:=true;
     if currpage=1 then
        prevpage.enabled:=false
     else
         prevpage.enabled:=true;
     hint.Panels.Items[0].text:='Preview: Page '+inttostr(currpage)+' of '+inttostr(prevpages);
end;

procedure readonly;
begin
     exit;
     if dept=0 then
     begin
          mainform.jobinfo.refresh;
          if mainform.jobinfostatus.value='R' then
             raise exception.create('Quote has been sent out and is read only, can''t modify');
     end
     else
     begin
          if mainform.sequencedepartment.value<>dept then
             raise exception.create('Sequence used by another department, can''t modify');
     end;
end;

procedure inbatch;
begin
     with mainform do
     begin
          BatchedJoists.Requery();
          if BatchedJoists.Locate('Mark', joistsmark.value, []) then
             raise exception.create('Joist in list '+inttostr(BatchedJoistslistnumber.value)+', can''t modify');
     end;
end;

function TMainForm.nextsection(section:string):string;
var
   found:boolean;
   c:integer;
begin
     c:=0; found:=false;
     while (c<=anglist.count-1) and not found do
     begin
          angprop:=anglist.items[c];
          if angprop^.section=section then
             found:=true;
          inc(c);
     end;
     if c>anglist.count-1 then
        result:='EE'
     else
     begin
          angprop:=anglist.items[c];
          result:=angprop^.section;
     end;
end;

function TMainForm.solvefa(fa:single; chord:chordprop):single;
var
   q7,q8,q9:single;
begin
     q7:=-fb*angprop^.Q*overst/chord.fe;
     q8:=fb*angprop^.Q*overst-0.4*chord.mpfb*fa*overst/chord.fe+fa*overst*overst*angprop^.Q*fb/chord.fe;
     q9:=chord.mpfb*fa*overst-fa*overst*overst*fb*angprop^.Q;
     q7:=(-q8+sqrt(sqr(q8)-4*q7*q9))/2/q7;
     {if q7<fb-chord.ppfb then
        result:=q7
     else
         result:=fb*overst-chord.ppfb;}
     result:=q7;
end;

function TMainForm.chkshear(var Chord:Chordprop):boolean;
var
   fv,ft:single;
begin
     fv:=maxshr/(2*angprop^.t*angprop^.d);
     ft:=maxtsh/(2*angprop^.area);
     chord.shrcap:=sqrt(sqr(ft)+4*sqr(fv))/2;
     //if chord.shrcap<0.4*fy*1000 then
     if ((chord.shrcap<0.4*fy*1000*overst) and (not LRFD)) or ((chord.shrcap<0.6*fy*1000*overst) and LRFD) then
        result:=true
     else
         result:=false;
end;

procedure TMainForm.recalcjoist;
begin
     joistgenerate;
     dorecalc;
end;

procedure TMainForm.findangle(section:string);
var
   found:boolean;
   c:integer;
begin
     c:=0; found:=false;
     while (c<=anglist.count-1) and not found do
     begin
          angprop:=anglist.items[c];
          if angprop^.section=section then
             found:=true
          else
              inc(c);
     end;
end;

procedure TMainForm.findrnd(section:string);
var
   found:boolean;
   c:integer;
begin
     c:=0; found:=false;
     while (c<=rndlist.count-1) and not found do
     begin
          rndprop:=rndlist.items[c];
          if rndprop^.section=section then
             found:=true
          else
              inc(c);
     end;
end;

function TMainForm.findmemb(pos:string; rol:char):boolean;
var
   x:integer;
   foundep:boolean;
begin
  x:=0;
  if rol='R' then
     x:=memberlist.count-1;
  foundep:=false;
  while (not foundep) and (x<memberlist.count) and (x>=0) do
  begin
       membdata:=MemberList.items[x];
       if membdata^.position=pos then
          foundep:=true
       else
       case rol of
         'L':inc(x);
         'R':dec(x);
       end;
  end;
  if not foundep then
     result:=false
  else
      result:=true;
end;

procedure TMainForm.findjoint(pos:string; rol:char);
var
   x:integer;
   foundep:boolean;
begin
  x:=0;
  if rol='R' then
     x:=jointlist.count-1;
  foundep:=false;
  while not foundep do
  begin
       jointdata:=jointList.items[x];
       if jointdata^.position=pos then
          foundep:=true
       else
       case rol of
         'L':inc(x);
         'R':dec(x);
       end;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  NewItem: TMenuItem;
  i:integer;
  temp:string;
begin
     hint.Panels.Items[0].Width:=Hint.ClientWidth-80;
     joistmemo:=tdbmemo.create(mainform);
     joistmemo.datasource:=datasource2;
     joistmemo.datafield:='Extras';
     joistmemo.parent:=PrevScroll2;
     joistmemo.TabStop:=False;
     iconcreate;
     Application.Onhint:=showhint;
     prevzoom:=1; reportn:=0;
     panellist:=tlist.create; panellist.clear;
     ConcList:=TList.Create; ConcList.clear;
     PartList:=TList.Create; PartList.clear;
     AngList:=TList.Create; AngList.clear;
     RndList:=TList.Create; RndList.clear;
     JointList:=TList.Create; JointList.clear;
     MemberList:=TList.Create; MemberList.clear;
     loadList:=TList.Create; loadlist.clear;
     SprinkList:=TList.Create; Sprinklist.clear;
     if LRFD then
        fb:=0.9*Fy*1000
     else
        fb:=0.6*Fy*1000;
     deltascle:=0;
     CalcAngProp;
     CalcRndProp;
     close1click(Sender);
     for i:=0 to edit1.count-1 do
     begin
          NewItem := TMenuItem.Create(popupmenu1);
          NewItem.caption:=edit1.items[i].caption;
          NewItem.onclick:=edit1.items[i].onclick;
          popupmenu1.items.insert(i,NewItem);
     end;
     temp:=finifile.ReadString(SECTION,'Job','');
     Job.Parameters[0].Value:=temp;
     Job.open;
     if dept=0 then
        PriceTbl.Open;
     if job.RecordCount>0 then
     begin
          if not fileopen then
          begin
               JobOpen.show;
               if dept>0 then
                  sequence.open
               else
                  Jobinfo.open;
          end;
          dojobopen;
     end
     else
         job.close;
end;

procedure TMainform.closefile;
var
   b:integer;
begin
     if Jointlist.count>0 then
     begin
          for b:=0 to (Jointlist.count-1) do
          begin
               jointdata:=JointList.items[b];
               dispose(jointdata);
          end;
          for b:=0 to (MemberList.count-1) do
          begin
               membdata:=MemberList.items[b];
               dispose(membdata);
          end;
          JointList.clear; MemberList.clear;
     end;
     if loadlist.count>0 then
     begin
          for b:=0 to (loadlist.count-1) do
          begin
               loads:=loadList.items[b];
               dispose(loads);
          end;
          loadList.clear;
     end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
     close;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
   b:integer;
begin
     if fileopen then
        Close1Click(Sender);
     for b:=0 to (anglist.count-1) do
     begin
          angprop:=anglist.items[b];
          dispose(angprop);
     end;
     for b:=0 to (Rndlist.count-1) do
     begin
          Rndprop:=Rndlist.items[b];
          dispose(Rndprop);
     end;
     if sprinklist.count>0 then
     begin
          for b:=0 to (sprinklist.count-1) do
          begin
               Sprinkler:=SprinkList.items[b];
               dispose(Sprinkler);
          end;
     end;
     if Conclist.count>0 then
     begin
          for b:=0 to (Conclist.count-1) do
          begin
               Concdata:=ConcList.items[b];
               dispose(Concdata);
          end;
          ConcList.clear;
     end;
     if Partlist.count>0 then
     begin
          for b:=0 to (Partlist.count-1) do
          begin
               Partdata:=PartList.items[b];
               dispose(Partdata);
          end;
          PartList.clear;
     end;
     if Panellist.count>0 then
     begin
          for b:=0 to (Panellist.count-1) do
          begin
               TCPanel:=PanelList.items[b];
               dispose(TCPanel);
          end;
          PanelList.clear;
     end;
     joistmemo.free;
     conclist.free;
     Partlist.free;
     panellist.free;
     anglist.free;
     RndList.free;
     JointList.free;
     MemberList.free;
     loadlist.free;
     sprinklist.free;
     iconfree;
//TODO -oArturo:Enable Hardware Lock Close
     //closekey;
end;

procedure TMainForm.showhint(Sender:Tobject);
begin
     if (jobopen.pageindex=0) or (not fileopen) then
        hint.Panels.Items[0].text:=application.hint;
end;

procedure TMainForm.PrintClick(Sender: TObject);
begin
     if ((ModuleBook.PageIndex=0) and (JobBook.PageIndex=1)) or ((ModuleBook.PageIndex=1) and (shopbook.PageIndex=2)) then
     begin
          joistrepform:=tjoistrepform.create(application);
          if dept=0 then
             joistrepForm.QRLabel9.Caption:='Joist Report: '+
                 jobjobname.value+' ['+jobjobnumber.value+'] - '+jobinfodescription.value
          else
              joistrepForm.QRLabel9.Caption:='Joist Report: '+
                 jobjobname.value+' ['+jobjobnumber.value+'] - '+sequencedescription.value;
          joistrepform.QuickRep1.print;
          joistrepform.free;
          exit;
     end;
     try
     printdialog1.printrange:=prselection;
     printdialog1.copies:=1;
     if (sender=print1) and (not PrintDialog1.Execute) then
        exit;
     if (sender=print1) or (sender=print) then
     begin
          if (modulebook.pageindex=1) and (shopbook.pageindex=1) then
          begin
               fillbatch;
               drawshop;
               {genbatch;}
               exit;
          end;
          if (modulebook.pageindex=2) and (engineeringbook.pageindex=6) then
          begin
               if joverst then
                  raise exception.Create('Joist is overstressed, can''t print shoporder');
               drawshop;
               exit;
          end;
          if (modulebook.pageindex=0) and (jobinfostatus.value='Q') then
          begin
              jobinfo.edit;
              jobinfostatus.value:='R';
              jobinfo.post;
          end;
     end;
     if jobopen.pageindex=1 then
        PrevCloseClick(Sender);
     printprog;
     finally
     print.down:=false;
     end;
end;

procedure TMainForm.PrintPreview1Click(Sender: TObject);
begin
     if ((ModuleBook.PageIndex=0) and (JobBook.PageIndex=1)) or ((ModuleBook.PageIndex=1) and (shopbook.PageIndex=2)) then
     begin
          joistrepform:=tjoistrepform.create(application);
          if dept=0 then
             joistrepForm.QRLabel9.Caption:='Joist Report: '+
                 jobjobname.value+' ['+jobjobnumber.value+'] - '+jobinfodescription.value
          else
              joistrepForm.QRLabel9.Caption:='Joist Report: '+
                 jobjobname.value+' ['+jobjobnumber.value+'] - '+sequencedescription.value;
          joistrepform.QuickRep1.PreviewModal;
          joistrepform.free;
          exit;
     end;
     currpage:=1;
     LockWindowUpdate(mainform.handle);
     coolbar1.hide;
     MainForm.Menu:=nil;
     joistmemo.parent:=jobopen;
     jobopen.pageindex:=1;
     preview:=timage.Create(mainform);
     preview.parent:=PrevScroll2;
     previewpaint;
     LockWindowUpdate(0);
end;

procedure TMainForm.Close1Click(Sender: TObject);
var
   i:integer;
begin
     for i:=0 to edit1.count-1 do
          edit1.items[i].enabled:=false;
     for i:=0 to view1.count-1 do
          view1.items[i].enabled:=false;
     exportjoist.enabled:=false;
     drawAutoCAD.enabled:=false;
     matsubst.enabled:=false;
     previous.enabled:=false;
     next.enabled:=false;
     addentry.enabled:=false;
     delentry.enabled:=false;
     properties.enabled:=false;
     print1.enabled:=false;
     print.enabled:=false;
     printpreview1.enabled:=false;
     previewbtn.enabled:=false;
     close1.enabled:=false;
     matreq.enabled:=false;
     delete2.enabled:=false;
     info1.enabled:=false;
     jobinfobtn.enabled:=false;
     refreshbtn.enabled:=false;
     engineering.down:=false;
     engineering.enabled:=false;
     JobOpen.hide;
     closefile;
     caption:='ISP Joist Design';
     joists.close;
     jsubst.close;
     if dept=0 then
     begin
          bridg.close;
          JobMisc.close;
          JobInfo.close;
          pricetbl.close;
     end
     else
     begin
          bridg2.close;
          shoporder.close;
          shopordlist.close;
          sequence.close;
     end;
     job.close;
     sjicatlg.close;
     kcsjoists.close;
     timestds.close;
     if fileopen then
     begin
          fileopen:=false;
     end;
end;

procedure TMainForm.Dojobopen;
var
   i:integer;
begin
     if not fileopen then
     begin
          if dept>0 then
          begin
               shoporder.open;
               shopordlist.open;
               bridg2.open;
          end
          else
          begin
               //pricetbl.open;
               doextras(extrastabs.TabIndex);
               JobMisc.open;
               bridg.open;
          end;
          joists.open;
          jsubst.open;
          sjicatlg.open;
          kcsjoists.open;
          timestds.open;
          fileopen:=true;
          for i:=0 to edit1.count-1 do
              edit1.items[i].enabled:=true;
          for i:=0 to view1.count-1 do
              view1.items[i].enabled:=true;
     end;
     engineeringbook.pageindex:=0;
     if dept=0 then
        jobbook.pageindex:=0
     else
         shopbook.pageindex:=0;
     listbox1.itemindex:=0;
     if dept>0 then
     begin
          if modulebook.pageindex<>1 then
             modulebook.pageindex:=1
          else
              ModuleBookPageChanged(nil);
     end
     else
     begin
          if modulebook.pageindex>0 then
             modulebook.pageindex:=0
          else
              ModuleBookPageChanged(nil);
     end;
     caption:='ISP Joist Design - '+jobjobname.value+' ['+jobjobnumber.value+']';
     close1.enabled:=true;
     matreq.enabled:=true;
     delete2.enabled:=true;
     info1.enabled:=true;
     jobinfobtn.enabled:=true;
     refreshbtn.enabled:=true;
     engineering.enabled:=true;
     previous.enabled:=true;
     next.enabled:=true;
     addentry.enabled:=true;
     delentry.enabled:=true;
     properties.enabled:=true;
end;

procedure TMainForm.AddEntryClick(Sender: TObject);
var
   temp:integer;
begin
     try
     addEntry.down:=true;
     case modulebook.pageindex of
     0:if (jobbook.pageindex=0) then
         begin
              if jobinfo.recordcount>99 then
                 raise exception.create('Limit of 100 alternatives per job');
              jobpropform:=tjobpropform.create(application);
              jobpropform.newjob;
              jobpropform.free;
         end
         else
         begin
              readonly;
              case jobbook.pageindex of
              1:begin
                     joists.insert;
                     entryform:=tentryform.create(application);
                     entryform.newentry;
                     entryform.free;
                end;
              2:begin
                     bridg.insert;
                     bridgingform:=tbridgingform.create(application);
                     bridgingform.newentry;
                     bridgingform.free;
                end;
              3:begin
                     jsubst.insert;
                     jsubstdeflection.value:=360;
                     jsubstform:=tjsubstform.create(application);
                     jsubstform.showmodal;
                     jsubstform.free;
                end;
              end;
         end;
       1:if (shopbook.pageindex=0) then
         begin
              temp:=SequencePage.value;
              seqpropform:=tseqpropform.create(application);
              seqpropform.newjob;
              sequence.Locate('Page', temp, []);
              seqpropform.free;
         end
         else
         begin
              readonly;
              case shopbook.pageindex of
              1:begin
                     joists.disablecontrols;
                     batchform:=tbatchform.create(application);
                     batchform.showmodal;
                     if batchform.modalresult=mrOK then
                     begin
                          shoporder.refresh;
                          shoporder.last;
                     end;
                     batchform.free;
                     joists.enablecontrols;
                end;
              2:begin
                     joists.insert;
                     entryform:=tentryform.create(application);
                     entryform.newentry;
                     entryform.free;
                end;
              3:begin
                     bridg2.insert;
                     bridg2form:=tbridg2form.create(application);
                     bridg2form.newentry;
                     bridg2form.free;
                end;
              4:begin
                     jsubst.insert;
                     jsubstdeflection.value:=360;
                     jsubstform:=tjsubstform.create(application);
                     jsubstform.showmodal;
                     jsubstform.free;
                end;
              end;
         end;
     2:begin
            readonly;
            joists.insert;
            entryform:=tentryform.create(application);
            entryform.newentry;
            if entryform.modalresult=mrok then
            begin
                 ListBox1Click(Sender);
            end;
            entryform.free;
       end;
     end;
     finally
     addEntry.down:=false;
     end;
end;

procedure TMainForm.JSubstCalcFields(DataSet: TDataSet);
begin
    if jsubstType.Value='1' then
        jsubstConfiguration.Value:='2 Angles';
     if jsubstType.Value='2' then
         jsubstConfiguration.Value:='4 Angles';
end;

procedure TMainForm.JSubstDeflectionValidate(Sender: TField);
begin
    if jsubstDeflection.Value<=0 then
        raise exception.create('Value must be greater than 0');
end;

procedure TMainForm.ShopordListCalcFields(DataSet: TDataSet);
begin
    shopordlisttons.value:=shopordlistweight.value*shopordlistquantity.value/2000;
end;

procedure TMainForm.ShoporderCalcFields(DataSet: TDataSet);
begin
    if shoporderlisttype.value='L1' then
        shopordertype.value:='Short Span Rounds';
     if shoporderlisttype.value='L2' then
        shopordertype.value:='Short Span Crimps';
     if shoporderlisttype.value='LS' then
        shopordertype.value:='Long Span Joists';
     if shoporderlisttype.value='JG' then
        shopordertype.value:='Joist Girders';
end;

procedure TMainForm.SequenceAfterOpen(DataSet: TDataSet);
begin
    BatchedJoists.Open;
end;

procedure TMainForm.SequenceBeforeClose(DataSet: TDataSet);
begin
    BatchedJoists.Close;
end;

procedure TMainForm.SequenceCalcFields(DataSet: TDataSet);
begin
     sequencetotalpieces.value:=sequenceL1Pieces.value+sequenceL2Pieces.value+sequenceLSPieces.value
        +sequenceJGPieces.value;
     sequencetotalTons.value:=sequenceL1Tons.value+sequenceL2Tons.value+sequenceLSTons.value
        +sequenceJGTons.value;
     sequencetotalLH.value:=sequenceL1LineHrs.value+sequenceL2LineHrs.value+sequenceLSLineHrs.value
        +sequenceJGLineHrs.value;
end;

procedure deljoist;
begin
     with mainform do
     begin
          joists.delete;
          if ModuleBook.PageIndex=2 then
              ModuleBookPageChanged(nil);
     end;
end;

procedure deljsubst;
begin
     with mainform do
     begin
          jsubst.delete;
     end;
end;

procedure delquote;
var
   x:integer;
begin
     with mainform do
     begin
          while joists.recordcount>0 do
                deljoist;
          while bridg.recordcount>0 do
                bridg.delete;
          while jsubst.recordcount>0 do
                jsubst.delete;
          for x:=0 to 3 do
          begin
               doextras(x);
               while jobmisc.recordcount>0 do
                     jobmisc.delete;
          end;
          jobinfo.delete;
     end;
end;

procedure delbatch;
begin
     with mainform do
     begin
          while shopordlist.recordcount>0 do
                shopordlist.delete;
          shoporder.delete;
     end;
end;

procedure delseq;
begin
     with mainform do
     begin
          while shoporder.recordcount>0 do
                delbatch;
          while joists.recordcount>0 do
                deljoist;
          while bridg2.recordcount>0 do
                bridg2.delete;
          sequence.delete;
     end;
end;

procedure TMainForm.DelEntryClick(Sender: TObject);
begin
     try
     readonly;
     delEntry.down:=true;
     if (modulebook.pageindex=0) and (jobbook.pageindex=0) then
     begin
          if messagedlg('Do you want to delete '+jobinfodescription.value+'?',mtConfirmation,mbOkCancel,0)=mrCancel then
             exit;
          delquote;
     end;
     if (modulebook.pageindex=1) and (shopbook.pageindex=0) then
     begin
          if messagedlg('Do you want to delete '+sequencedescription.value+'?',mtConfirmation,mbOkCancel,0)=mrCancel then
             exit;
          delseq;
     end;
     if ((modulebook.pageindex=0) and (jobbook.pageindex=1)) or ((modulebook.pageindex=1) and (shopbook.pageindex=2)) or
        (modulebook.pageindex=2) then
     begin
          if dept>0 then
             inbatch;
          if messagedlg('Do you want to delete '+joistsmark.value+'?',mtConfirmation,mbOkCancel,0)=mrCancel then
             exit;
          deljoist;
          if dept=0 then
          begin
               jobinfo.edit;
               jobinfostatus.value:='M';
               jobinfo.post;
          end
          else
          begin
              sequence.edit;
              sequencestatus.value:='M';
              sequence.post;
          end;
     end;
     if ((modulebook.pageindex=0) and (jobbook.pageindex=3)) or ((modulebook.pageindex=1) and (shopbook.pageindex=4)) then
     begin
          if messagedlg('Do you want to delete '+jsubstmark.value+'?',mtConfirmation,mbOkCancel,0)=mrCancel then
             exit;
          deljsubst;
          if dept=0 then
          begin
               jobinfo.edit;
               jobinfostatus.value:='M';
               jobinfo.post;
          end;
     end;
     if (modulebook.pageindex=0) and (jobbook.pageindex=2) then
     begin
          if messagedlg('Do you want to delete '+bridgmark.value+'?',mtConfirmation,mbOkCancel,0)=mrCancel then
             exit;
          bridg.delete;
          jobinfo.edit;
          jobinfostatus.value:='M';
          jobinfo.post;
     end;
     if (modulebook.pageindex=1) and (shopbook.pageindex=3) then
     begin
          if messagedlg('Do you want to delete '+bridg2mark.value+'?',mtConfirmation,mbOkCancel,0)=mrCancel then
             exit;
          bridg2.delete;
     end;
     if (modulebook.pageindex=1) and (shopbook.pageindex=1) then
     begin
          if messagedlg('Do you want to delete list '+inttostr(shoporderlistnumber.value)+
               '?',mtConfirmation,mbOkCancel,0)=mrCancel then
             exit;
          delbatch;
     end;
     finally
     delEntry.down:=false;
     end;
end;

procedure TMainForm.DataSource1DataChange(Sender: TObject; Field: TField);
begin
  if (JobMisc.Parameters[0].Value<>JobInfoJobNumber.Value) or (JobMisc.Parameters[1].Value<>JobInfoPage.Value) then
  begin
    JobMisc.Close;
    JobMisc.Parameters[0].Value:=JobInfoJobNumber.Value;
    JobMisc.Parameters[1].Value:=JobInfoPage.Value;
    JobMisc.Open;
  end;
end;

procedure TMainForm.DataSource2DataChange(Sender: TObject; Field: TField);
begin
     {if (joists.recordcount=0) and (modulebook.visible) and (modulebook.pageindex=2) then
     begin
          ContentsClick(Sender);
     end;}
     LRFD:=JoistsLRFD.Value;
end;

procedure TMainForm.DataSource6DataChange(Sender: TObject; Field: TField);
begin
    Shoporder.Close;
    Shoporder.Parameters[0].Value:=SequenceJobNumber.Value;
    Shoporder.Open;
    Shoporder.Filter:='[Page] = '+inttostr(SequencePage.Value);
    Shoporder.Filtered:=true;
end;

procedure TMainForm.JobCalcFields(DataSet: TDataSet);
begin
     joblocation2.value:=joblocation.value+', '+jobstate.value;
end;

procedure TMainForm.JobCustomerValidate(Sender: TField);
begin
    jobbilladdress.value:=JobInfoForm.customeraddress.value;
    jobbillcity.value:=JobInfoForm.customercity.value;
    jobbillstate.value:=JobInfoForm.customerstate.value;
    jobbillzip.value:=JobInfoForm.customerzip.value;
end;

procedure TMainForm.JobGridKeyPress(Sender: TObject; var Key: Char);
begin
     if key=#13 then
       PropertiesClick(Sender);
end;

procedure TMainForm.SJICatalog1Click(Sender: TObject);
begin
     catalogform:=tcatalogform.create(application);
     catalogform.showmodal;
     catalogform.free;
     SJICatalog.down:=false;
end;

procedure TMainForm.PopupMenu1Popup(Sender: TObject);
var
  i:integer;
begin
     for i:=0 to edit1.count-1 do
          popupmenu1.items[i].enabled:=edit1.items[i].enabled;
end;

procedure TMainForm.Engineering1Click(Sender: TObject);
begin
     if not engineering1.checked then
     begin
          engineering.down:=true;
          modulebook.pageindex:=2;
     end
     else
     begin
          if dept=0 then
            modulebook.pageindex:=0
         else
            modulebook.pageindex:=1;
     end;
end;

procedure TMainForm.PriceTable1Click(Sender: TObject);
begin
     if not fileopen then
        pricetbl.open;
     pricetblform:=tpricetblform.create(application);
     pricetblform.showmodal;
     pricetblform.free;
     if not fileopen then
        pricetbl.close;
end;

procedure TMainForm.PriceTblAfterInsert(DataSet: TDataSet);
begin
    pricetblcategory.value:=pricetblform.tabset1.tabs.strings[pricetblform.tabset1.tabindex];
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
     if fileopen then
     begin
        JoistDraw.free;
        JoistDraw:=timage.Create(mainform);
        JoistDraw.parent:=Geometry;
        JoistDraw.Align:=alclient;
        if (ModuleBook.PageIndex=2) and (coolbar1.visible) and (jobopen.pageindex=0) then
           joistpaint;
        if (JobOpen.PageIndex=1) and (not coolbar1.visible) then
        begin
             preview.free;
             preview:=timage.Create(mainform);
             preview.parent:=PrevScroll2;
             previewpaint;
        end;
     end;
     hint.Panels.Items[0].Width:=Hint.ClientWidth-80;
end;

procedure TMainForm.OpenJobClick(Sender: TObject);
var
   temp:string;
begin
     joblookform:=tjoblookform.create(application);
     if fileopen then
        temp:=jobjobnumber.value
     else
         temp:=finifile.ReadString(SECTION,'Job','');
     temp:=joblookform.joblocate(temp);
     if joblookform.modalresult=mrOk then
     begin
          lockwindowupdate(mainform.handle);
          Job.Parameters[0].Value:=temp;
          if dept=0 then
            PriceTbl.Open;
          if not fileopen then
          begin
               JobOpen.show;
               job.open;
               if dept>0 then
                  sequence.open
               else
                  Jobinfo.open;
          end
          else
              Job.Requery;
          dojobopen;
          finifile.WriteString(SECTION,'Job',temp);
          lockwindowupdate(0);
     end;
     joblookform.free;
     openjob.down:=false;
end;

procedure TMainForm.ModuleBookPageChanged(Sender: TObject);
begin
     if fileopen then
     begin
          listbox1.clear;
          if modulebook.pageindex<2 then
          begin
               engineering1.checked:=false;
               engineering.down:=false;
          end;
          listbox1.helpcontext:=modulebook.pageindex+1;
          modulebook.HelpContext:=listbox1.helpcontext;
          if modulebook.pageindex=2 then
          begin
             optionfill(engineeringbook);
             engineering1.checked:=true;
             if Joists.RecordCount>0 then
                recalcjoist;
          end;
          if modulebook.pageindex=1 then
          begin
             optionfill(Shopbook);
             engineering1.checked:=false;
          end;
          if modulebook.pageindex=0 then
          begin
             optionfill(Jobbook);
             engineering1.checked:=false;
          end;
          ListBox1Click(Sender);
          //paintbox1.invalidate;
     end;
end;

procedure TMainForm.PropertiesClick(Sender: TObject);
begin
     try
     properties.down:=true;
     readonly;
     if (modulebook.pageindex=0) and (jobbook.pageindex=0) then
     begin
          try
          JobInfo.Edit;
          jobpropform:=tjobpropform.create(application);
          jobpropform.ShowModal;
          if jobpropform.modalresult=mrOk then
          begin
             ListBox1Click(Sender);
          end;
          finally
          jobpropform.free;
          end;
     end;
     if ((modulebook.pageindex=0) and (jobbook.pageindex=1)) or
        ((modulebook.pageindex=1) and (shopbook.pageindex=2)) or (modulebook.pageindex=2) then
     if joists.recordcount>0 then
     begin
          if dept>0 then
             inbatch;
          entryform:=tentryform.create(application);
          with entryform do
          begin
               joistgenerate;
               entryform.fillridge;
               joists.edit;
               showmodal;
               if entryform.modalresult=mrok then
               begin
                    if modulebook.pageindex=2 then
                    begin
                         paintbox1.refresh;
                         ListBox1Click(Sender);
                    end;
               end;
          end;
          entryform.free;
     end;
     if ((modulebook.pageindex=0) and (jobbook.pageindex=3)) or
        ((modulebook.pageindex=1) and (shopbook.pageindex=4)) then
     if jsubst.recordcount>0 then
     begin
          jsubst.edit;
          jsubstform:=tjsubstform.create(application);
          jsubstform.showmodal;
          jsubstform.free;
     end;
     if (modulebook.pageindex=1) and (shopbook.pageindex=0) then
     if sequence.recordcount>0 then
     begin
          sequence.edit;
          seqpropform:=tseqpropform.create(application);
          sequence.edit;
          seqpropform.modprop;

          if seqpropform.modalresult=mrOK then
          begin
               paintbox1.refresh;
          end;
          seqpropform.free;
     end;
     if (modulebook.pageindex=0) and (jobbook.pageindex=2) then
     if bridg.recordcount>0 then
     begin
          bridg.edit;
          bridgingform:=tbridgingform.create(application);
          bridgingform.showmodal;
          bridgingform.free;
     end;
     finally
     properties.down:=false;
     end;
end;

procedure TMainForm.ExportJoistClick(Sender: TObject);
var
   x:integer;
   sx,sy,fy:string;
   joiststr:Tstringlist;
begin
     savedialog1.filename:=joistsmark.value;
     if savedialog1.execute then
     begin
          casecombo.itemindex:=3;
          CaseComboChange(Sender);
          joiststr:=tstringlist.create;
          if dept=0 then
             joiststr.add('STAAD TRUSS '+joistsmark.value+' - '+jobinfodescription.value)
          else
              joiststr.add('STAAD TRUSS '+joistsmark.value+' - '+sequencedescription.value);
          joiststr.add('INPUT WIDTH 79');
          joiststr.add('UNIT INCHES POUND');
          joiststr.add('JOINT COORDINATES');
          for x:=1 to JointList.count do
          begin
               jointdata:=JointList[x-1];
               str(jointdata^.coordX:0:3,sx);
               str(jointdata^.coordY:0:3,sy);
               joiststr.add(inttostr(x)+' '+sx+' '+sy+' '+'0.000');
          end;
          joiststr.add('MEMBER INCIDENCES');
          for x:=1 to MemberList.count do
          begin
               membdata:=MemberList[x-1];
               str(membdata^.joint1,sx);
               str(membdata^.joint2,sy);
               joiststr.add(inttostr(x)+' '+sx+' '+sy);
          end;
          joiststr.add('MEMBER PROPERTY AMERICAN');
          joiststr.add('1 TO '+inttostr(MemberList.count)+' ASSIGN ANGLE');
          joiststr.add('CONSTANTS');
          joiststr.add('E STEEL ALL');
          joiststr.add('SUPPORTS');
          joiststr.add(inttostr(SUPP1)+' PINNED');
          joiststr.add(inttostr(SUPP2)+' FIXED BUT FX MZ');
          joiststr.add('LOAD 1 CASE1');
          joiststr.add('JOINT LOAD');
          for x:=1 to JointList.count do
          begin
               jointdata:=JointList[x-1];
               if jointdata^.forceY<>0 then
               begin
                    str(jointdata^.forceY:0:3,fy);
                    joiststr.add(inttostr(x)+' FY '+fy);
               end;
          end;
          joiststr.add('PERFORM ANALYSIS');
          joiststr.add('PRINT MEMBER FORCES ALL');
          joiststr.add('PRINT SUPPORT REACTIONS');
          joiststr.add('FINISH');
          joiststr.savetofile(savedialog1.filename);
          joiststr.free;
     end;
end;

procedure TMainForm.doextras(cat:smallint);
begin
    {with jobmisc do
     begin
          EditRangeStart;
          FieldByName('Job Number').AsString:=jobinfojobnumber.value;
          FieldByName('Page').Asinteger:=jobinfopage.value;
          FieldByName('Category').AsString:=extrastabs.Tabs.Strings[cat];
          FieldByName('Item').Asinteger:=1;
          EditRangeEnd;
          FieldByName('Job Number').AsString:=jobinfojobnumber.value;
          FieldByName('Page').Asinteger:=jobinfopage.value;
          FieldByName('Category').AsString:=extrastabs.Tabs.Strings[cat];
          FieldByName('Item').Asinteger:=1000;
          ApplyRange;
     end;}
     //JobMisc.Close;
     //while JobMisc.DataSet.CommandText.
                //JobMisc.DataSet.CommandText.Delete(2);
     //JobMisc.SQL.Add('and category = '''+extrastabs.Tabs.Strings[cat]+'''');
     //JobMisc.open;
     JobMisc.Filter:='Category = '''+extrastabs.Tabs.Strings[cat]+'''';
     JobMisc.Filtered:=true;
end;

procedure TMainForm.NextPageClick(Sender: TObject);
begin
     if nextpage.enabled then
     begin
        inc(currpage);
        Previewpaint;
     end;
end;

procedure TMainForm.PrevPageClick(Sender: TObject);
begin
     if prevpage.enabled then
     begin
        dec(currpage);
        Previewpaint;
     end;
end;

procedure TMainForm.ZoomClick(Sender: TObject);
begin
     preview.free;
     if prevzoom=1 then
        prevzoom:=2
     else
         prevzoom:=1;
     preview:=timage.Create(mainform);
     preview.parent:=PrevScroll2;
     previewpaint;
end;

procedure TMainForm.PrevCloseClick(Sender: TObject);
begin
     LockWindowUpdate(mainform.handle);
     coolbar1.show;
     hint.Panels.Items[0].text:='';
     MainForm.Menu:=mainmenu;
     jobopen.pageindex:=0;
     preview.free;
     LockWindowUpdate(0);
     if ModuleBook.PageIndex=2 then
        joistpaint;
end;

procedure TMainForm.ListBox1Click(Sender: TObject);
var
   temp:string;
   line3:single;
   x:integer;
begin
//TODO -oArturo:Enable Hardware Lock Check
     {if softwarelock<>0 then
     begin
          close;
          exit;
     end;}
     //listbox1.setfocus;
     exportjoist.enabled:=false;
     drawAutoCAD.enabled:=false;
     matsubst.enabled:=false;
     MatReq.Enabled:=false;
     case modulebook.pageindex of
          0:begin
                 JobBook.PageIndex:=ListBox1.ItemIndex;
            end;
          1:begin
                 if (dept=2) and (listbox1.itemindex>0) then
                    shopbook.pageindex:=listbox1.itemindex+1
                 else
                 Shopbook.PageIndex:=listbox1.itemindex;
            end;
          2:begin
                 engineeringbook.PageIndex:=listbox1.itemindex;
            end;
     end;
     if modulebook.visible then
     begin
     if modulebook.pageindex=0 then
     begin
          if jobbook.PageIndex<2 then
          begin
               if not print.enabled then
               begin
                    print.enabled:=true;
                    printpreview1.enabled:=true;
                    print1.enabled:=true;
                    previewbtn.enabled:=true;
               end;
          end;
          if jobbook.pageindex=0 then
          begin
             totaljob;
             MatReq.Enabled:=true;
             label43.caption:='Tons Sold ('+format('%0.2f',[jobinfooverweight.value])+'%):';
             if jobinfotonssold.value>0 then
             begin
                label47.caption:=format('%0.2m',[jobinfosubtotal2.value/jobinfotonssold.value]);
                label49.caption:=format('%0.2m',[jobinfosellingprice.value/jobinfotonssold.value]);
             end
             else
             begin
                 label47.caption:=format('%0.2m',[0.00]);
                 label49.caption:=label47.caption;
             end;
             if jobinfosellingprice.value>0 then
                label50.caption:='Total Profit ('+
                     format('%0.2f',[jobinfototalprofit.value/jobinfosellingprice.value*100])+'%):'
             else
                 label50.caption:=format('%0.2m',[0.00]);
          end
          else
          begin
               if (print.enabled) and (jobbook.PageIndex>1) then
               begin
                    print.enabled:=false;
                    printpreview1.enabled:=false;
                    print1.enabled:=false;
                    previewbtn.enabled:=false;
               end;
          end;
          case jobbook.pageindex of
               1:begin
                      jobgrid.datasource:=datasource2;
                      jobgrid.parent:=joistsPnl;
                 end;
               2:begin
                      jobgrid.datasource:=datasource4;
                      jobgrid.parent:=BridgPnl;
                 end;
               3:begin
                      jobgrid.datasource:=datasource7;
                      jobgrid.parent:=SubstPnl;
                 end;
          end;
     end;
     if modulebook.pageindex=1 then
     begin
          if print.enabled then
          begin
               print.enabled:=false;
               printpreview1.enabled:=false;
               print1.enabled:=false;
               previewbtn.enabled:=false;
          end;
          case shopbook.pageindex of
          0:begin
                 totalseq;
                 MatReq.Enabled:=true;
            end;
          1:begin
                 print.enabled:=true;
                 print1.enabled:=true;
            end;
          2:begin
                  if not print.enabled then
                  begin
                       print.enabled:=true;
                       printpreview1.enabled:=true;
                       print1.enabled:=true;
                       previewbtn.enabled:=true;
                  end;
                 jobgrid.datasource:=datasource2;
                 jobgrid.parent:=joistsPnl2;
            end;
          3:begin
                 jobgrid.datasource:=datasource4;
                 jobgrid.parent:=BridgPnl2;
            end;
          4:begin
                 jobgrid.datasource:=datasource7;
                 jobgrid.parent:=SubstPnl2;
            end;
          end;
     end;
     if modulebook.pageindex=2 then
     begin
          case jtype of
               'G':jdesc.caption:='Girder Load @ Diag';
               'N':jdesc.caption:='Girder N-Web @ All';
               'B':jdesc.caption:='Girder Load @ All';
               'V':jdesc.caption:='Girder Load @ Vert';
               'K':begin
                     if rndweb then
                        jdesc.caption:='Short Span Round'
                     else
                         jdesc.caption:='Short Span Crimp';
                   end;
               'C':begin
                     if rndweb then
                        jdesc.caption:='KCS Round'
                     else
                         jdesc.caption:='KCS Crimp';
                   end;
               'L':jdesc.caption:='Long Span';
               'D':jdesc.caption:='Deep Long Span';
          end;
          if not print.enabled then
          begin
               print.enabled:=true;
               print1.enabled:=true;
          end;
          exportjoist.enabled:=true;
          drawAutoCAD.enabled:=true;
          matsubst.enabled:=true;
          if sppanels then
             bcpanels.caption:=inttostr(joistsbcp.value)+' Special'
          else
              bcpanels.caption:=inttostr(joistsbcp.value)+' @ '+joistsbcpanel.value;
          temp:='Parallel Chords';
          if joistsshape.value='S' then
          begin
               line3:=1/(abs(joistsdepthre.value-joistsdepthle.value)/(bl/12));
               temp:='Single Pitch with 1:'+inttostr(round(12*line3))+' Slope';
          end;
          if joistsshape.value='D' then temp:='Double Pitch';
          if joistsshape.value='T' then temp:='Scissor';
          if (joistsshape.value='D') or (joistsshape.value='T') then
          begin
               temp:=temp+' with Ridge @ '+joistsridgeposition.value;
          end;
          jshape.caption:=temp;
          if engineeringbook.pageindex=0 then
          begin
               joistpaint;
               klbl.caption:=format('%0.2f',[k]);
               fylbl.caption:=format('%0.2n',[fy*1000]);
               fblbl.caption:=format('%0.2n',[fb]);
               momilbl.caption:=format('%0.2n',[momi]);
               if joistslldeflection.value>1 then
                  lllbl.caption:='LL '+inttostr(joistslldeflection.value)+':'
               else
                   lllbl.caption:='LL 360:';
               if joiststldeflection.value>1 then
                  tllbl.caption:='TL '+inttostr(joiststldeflection.value)+':'
               else
                   tllbl.caption:='LL 240:';
               llvallbl.caption:=format('%0.2n',[ll360]);
               tlvallbl.caption:=format('%0.2n',[ll240]);
               worklen.caption:=dectoing(wl);
               jdepth.caption:=format('%0.2f',[depth]);
               effdepth.caption:=format('%0.2f',[ed]);
               with loadgrid do
               begin
                    ColWidths[1]:=1;
                    cells[0,0]:='Description';
                    cells[1,0]:='Load';
                    for x:=1 to loadlist.count do
                    begin
                         loads:=loadlist.items[x-1];
                         cells[0,x]:=loads^.desc;
                         if (loads^.Load2>=0) and (loads^.load<>loads^.load2) then
                                cells[1,x]:=format('%0.2n',[loads^.load])+'-'+format('%0.2n',[loads^.load2])
                         else
                                cells[1,x]:=format('%0.2n',[loads^.load]);
                         if ColWidths[1]<canvas.TextWidth(cells[1,x])+4 then
                                ColWidths[1]:=canvas.TextWidth(cells[1,x])+4;
                    end;
                    rowcount:=loadlist.count+1;
                    ColWidths[0]:=clientwidth-ColWidths[1]-2;
               end;
          end;
          if engineeringbook.pageindex=1 then
          begin
               //fill combobox according to Load Combination
               FillCaseCombo;

               Freshstress;
               intpantc.caption:=format('%0.2n',[TCSection.maxintp]);
               maxpanbc.caption:=format('%0.2n',[BCSection.maxintp]);
               reactionle.caption:=format('%0.2n',[maxr1]);
               reactionre.caption:=format('%0.2n',[maxr2]);
               if jtype='C' then
                  minshear.caption:=format('%0.2n',[minshr])
               else
                   if maxr1>maxr2 then
                      minshear.caption:=format('%0.2n',[maxr1/4])
                   else
                       minshear.caption:=format('%0.2n',[maxr2/4]);
               maxtccomp.caption:=format('%0.2n',[abs(TCSection.maxforce)]);
               maxbctension.caption:=format('%0.2n',[BCSection.maxforce]);
          end;
          if engineeringbook.pageindex=2 then
          begin
               EngGrid.RowCount:=2;
               Freshchords;
          end;
          if engineeringbook.pageindex=3 then
          begin
               FreshWebs;
          end;
          if engineeringbook.pageindex=4 then
          begin
             freshjoint;
          end;
          if engineeringbook.pageindex=5 then
          begin
             freshMember;
          end;
          if engineeringbook.pageindex=6 then
          begin
               printpreview1.enabled:=false;
               previewbtn.enabled:=false;
               if rndweb then
                  fillshop2
               else
                   fillshop;
          end
          else
          begin
               printpreview1.enabled:=true;
               previewbtn.enabled:=true;
          end;
     end;
     PaintBox1.Refresh;
     end;
end;

procedure TMainForm.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Bitmap: TBitmap;
begin
  with (Control as TListBox).Canvas do
  begin
    FillRect(Rect);
    Bitmap:=TBitmap(ListBox1.Items.Objects[Index]);
    if Bitmap <> nil then
    begin
         BrushCopy(Bounds(trunc(Rect.Left+(listbox1.width-32)/2),Rect.Top+2,bitmap.width,bitmap.height),
           Bitmap,Bounds(0,0,bitmap.width,bitmap.height), clNavy);
    end;
    TextOut(trunc(rect.left+(listbox1.width-textwidth(Listbox1.Items[Index]))/2),
      Rect.Top+bitmap.height+4, Listbox1.Items[Index]);
  end;
end;

procedure TMainForm.PaintBox1Paint(Sender: TObject);
var
   x,y:integer;
   temp:string;
begin
      if joists.Datasource=nil then
        exit;
      with paintbox1.canvas do
      begin
           temp:=modulebook.activepage+': ';
           if joists.Datasource=Datasource1 then
              temp:=temp+jobinfodescription.value
           else
               temp:=temp+sequencedescription.value;
           if ModuleBook.PageIndex=2 then
              temp:=temp+' - '+JoistsMark.Value;
           font:=titlebar.font;
           x:=4;
           y:=trunc((titlebar.height-textheight(temp))/2);
           textout(x,y,temp);
           brush.color:=clwhite;
           brush.style:=bssolid;
           pen.color:=clwhite;
           x:=x+textwidth(temp)+6;
           y:=y+textheight(temp)-4;
           moveto(x,y);
           lineto(x-4,y-4);
           lineto(x+4,y-4);
           lineto(x,y);
           floodfill(x,y-2,clwhite,fsborder);
           //SelectCombo.Left:=x;
      end;
end;

procedure TMainForm.Contents1Click(Sender: TObject);
begin
     Application.HelpCommand(HELP_FINDER,0);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
     if jobopen.PageIndex=1 then
        preview.free;
     joistdraw.free;
     finifile.free;
     ADOConnection1.Close;
     Application.HelpCommand(HELP_QUIT,0);
end;

procedure TMainform.login;
var
   temp:string;
begin
     temp:=finifile.ReadString(SECTION,'User','');
     users.open;
     users.Requery;
     users.first;
     loginform:=tloginform.create(application);
     loginform.UserList.clear;
     while not users.eof do
     begin
          loginform.UserList.items.add(usersuser.value);
          if usersuser.value=temp then
             loginform.UserList.ItemIndex:=loginform.UserList.Items.Count-1;
          users.next;
     end;
     loginform.showmodal;
     if loginform.modalresult=mrOK then
     begin
          dept:=usersdepartment.value;
          hint.Panels.Items[1].text:=usersuser.value;
          if not (temp=usersuser.value) then
          begin
               finifile.WriteString(SECTION,'User',usersuser.value);
               finifile.WriteString(SECTION,'Job','');
          end;
          runby:=usersinitials.value;
     end
     else
        Application.Terminate;
     loginform.free;
     users.close;

     //TODO -oArturo: Bypass login screen
     {if (TemplateGetUser<>'JSS') and (TemplateGetUser<>'Arturo')  then
       Application.Terminate;
     dept:=1;
     hint.Panels.Items[1].text:='SUPERVISOR';
     runby:='SUP';
     job.open;
     job.close;}
end;

procedure TMainForm.NextClick(Sender: TObject);
begin
case modulebook.pageindex of
     0:if jobinfo.recordcount>0 then
       begin
                jobinfo.Next;
       end;
     1:if sequence.recordcount>0 then
       begin
                sequence.Next;
       end;
     2:if joists.recordcount>0 then
       begin
                joists.Next;
                recalcjoist;
       end;
     end;
     ListBox1Click(Sender);
end;

procedure TMainForm.PreviousClick(Sender: TObject);
begin
     case modulebook.pageindex of
     0:if jobinfo.recordcount>0 then
       begin
                jobinfo.Prior;
       end;
     1:if sequence.recordcount>0 then
       begin
                sequence.Prior;
       end;
     2:if joists.recordcount>0 then
       begin
                joists.Prior;
                recalcjoist;
       end;
     end;
     ListBox1Click(Sender);
end;

procedure TMainForm.MaterialProperties1Click(Sender: TObject);
begin
     matpropform:=tmatpropform.create(application);
     matpropform.showmodal;
     if matpropform.modalresult=mrYes then
     begin
          reportn:=1;
          PrintClick(Sender);
          reportn:=0;
     end;
     matpropform.free;
end;

procedure TMainForm.NewJobClick(Sender: TObject);
var
   temp:string;
begin
     jobinfoform:=tjobinfoform.create(application);
     temp:=jobinfoform.newjob;
     if jobinfoform.modalresult=mrOk then
     begin
          lockwindowupdate(mainform.handle);
          if not fileopen then
          begin
               JobOpen.show;
               job.open;
               if dept>0 then
                  sequence.open
               else
                   Jobinfo.open;
          end;
          Job.Parameters[0].Value:=temp;
          dojobopen;
          lockwindowupdate(0);
     end;
     jobinfoform.free;
     newjob.down:=false;
     finifile.WriteString(SECTION,'Job',temp);
end;

procedure TMainForm.Delete2Click(Sender: TObject);
begin
     if MessageDlg('Delete Job '+jobjobnumber.value, mtWarning, [mbYes, mbNo], 0) = mrNo then
        exit;
     while jobinfo.recordcount>0 do
     begin
          if jobinfostatus.value='R' then
          begin
               jobinfo.edit;
               jobinfostatus.value:='Q';
               jobinfo.post;
          end;
          delquote;
     end;
     job.delete;
     Close1Click(Sender);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
//TODO -oArturo:Enable Hardware Lock Check
     {if (openkey<>0) or (softwarelock<>0) then
     begin
          halt;
     end;}
     finifile:=TRegIniFile.Create('Software');
     {if screen.Width>800 then
     begin
        Self.Width:=804;
        Self.Height:=604;
        Self.Position:=poScreenCenter;
        Self.WindowState:=wsNormal;
     end;}
     modulebook.pageindex:=0;
     jobopen.PageIndex:=0;
     hint.Panels.Items[1].text:='';
     try
     login;
     if hint.Panels.Items[1].text='' then
     begin
//TODO -oArturo:Enable Hardware Lock Close
        //closekey;
        //halt;
        abort;
     end;
     if dept>0 then
     begin
          joists.DataSource:=Datasource6;
          joists.SQL.Clear;
          joists.SQL.Add('select * from joists2');
          joists.SQL.Add('where [job number]=:''job number'' and page=:''page'' order by mark');
          datasource4.dataset:=bridg2;
          jsubst.DataSource:=Datasource6;
          jsubst.SQL.Clear;
          jsubst.SQL.Add('select * from jsubst2 where [job number]=:''job number'' and page=:''page'' order by mark');
          customerlist1.enabled:=false;
          n10.Visible:=false;
          import1.Visible:=false;
          export1.Visible:=false;
          pricetable1.enabled:=false;
          jobgrid.parent:=joistsPnl2;
          jobbook.free;
          datasource1.free;
          jobinfo.free;
          datasource5.free;
          jobmisc.free;
          pricetbl.free;
          bridg.free;
     end
     else
     begin
          shopbook.free;
          datasource6.free;
          sequence.free;
          datasource8.free;
          shoporder.free;
          datasource9.free;
          shopordlist.free;
          bridg2.free;
     end;
     JoistDraw:=timage.Create(mainform);
     JoistDraw.parent:=Geometry;
     JoistDraw.Align:=alclient;
     except
//TODO -oArturo:Enable Hardware Lock Close
           //closekey;
           MessageDlg('Unable to open database, check settings.', mtError,[mbOk], 0);
           //halt;
           Application.Terminate;
     end;
end;

procedure TMainForm.EngGridDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
   temp:single;
begin
    if col>0 then
    with enggrid.Canvas do
    begin
         SetTextAlign(Handle, TA_RIGHT);
         FillRect(Rect);
         if (engineeringbook.pageindex=2) and (col>0) and (enggrid.Cells[Col, Row]<>'') then
         begin
              temp:=0;
              if row=14 then
              begin
                   case col of
                   1:begin
                          temp:=endpl.fa2+endpl.ppfb;
                          if (jtype='K') or (jtype='C') then
                             temp:=temp/0.9;
                     end;
                   2:temp:=firstpl.fa2+firstpl.ppfb;
                   3:temp:=abs(TCSection.Fa2+TCSection.ppfb);
                   4:temp:=firstpr.fa2+firstpr.ppfb;
                   5:begin
                          temp:=endpr.fa2+endpr.ppfb;
                          if (jtype='K') or (jtype='C') then
                             temp:=temp/0.9;
                     end;
                   end;
                   if temp>fb then
                      font.color:=clred;
              end;
              if row=15 then
              begin
                   case col of
                   5:begin
                          temp:=endpr.bratio+endpr.fa2/endpr.fa;
                          if (jtype='K') or (jtype='C') then
                             temp:=temp/0.9;
                     end;
                   4:temp:=firstpr.bratio+firstpr.fa2/firstpr.fa;
                   3:temp:=abs(TCSection.Fa2/TCSection.Fa)+TCSection.bratio;
                   2:temp:=firstpl.bratio+firstpl.fa2/firstpl.fa;
                   1:begin
                          temp:=endpl.bratio+endpl.fa2/endpl.fa;
                          if (jtype='K') or (jtype='C') then
                             temp:=temp/0.9;
                     end;
                   end;
                   if temp>overst then
                      font.color:=clred;
              end;
         end;
         TextRect(Rect, Rect.RIGHT - 2, Rect.Top + 2, enggrid.Cells[Col, Row]);
         SetTextAlign(Handle, TA_LEFT);
    end
    else
    begin
         if engineeringbook.pageindex<>2 then
         with enggrid.Canvas do
         begin
              SetTextAlign(Handle, TA_CENTER);
              FillRect(Rect);
              TextRect(Rect,TRUNC((Rect.RIGHT-RECT.LEFT)/2), Rect.Top + 2, enggrid.Cells[Col, Row]);
              SetTextAlign(Handle, TA_LEFT);
         end;
    end;
end;

procedure TMainForm.LoadGridDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
begin
    if col>0 then
    with loadgrid.Canvas do
    begin
      SetTextAlign(Handle, TA_RIGHT);
      FillRect(Rect);
      TextRect(Rect, Rect.RIGHT - 2, Rect.Top + 2, loadgrid.Cells[Col, Row]);
      SetTextAlign(Handle, TA_LEFT);
    end;
end;

procedure TMainForm.CustomerList1Click(Sender: TObject);
begin
     customerform:=tcustomerform.create(application);
     customerform.showmodal;
     customerform.free;
     if fileopen then
        job.refresh;
end;

procedure TMainForm.Info1Click(Sender: TObject);
var
   pn:integer;
   mn:string;
begin
     mn:=JoistsMark.Value;
     if dept=0 then
        pn:=JobInfoPage.Value
     else
         pn:=SequencePage.Value;
     jobinfoform:=tjobinfoform.create(application);
     jobinfoform.modprop(jobjobnumber.value);
     job.refresh;
     if jobinfoform.modalresult=mrOk then
     begin
          if dept=0 then
          begin
               with jobinfo do
               begin
                    disablecontrols;
                    first;
                    while not eof do
                    begin
                         edit;
                         if jobinfostatus.value='Q' then
                            jobinfostatus.value:='M';
                         next;
                    end;
                    enablecontrols;
               end;
               if jobinfostatus.value<>'R' then
                  totaljob;
          end;
          caption:='ISP Joist Design - '+jobjobname.value+' ['+jobjobnumber.value+']';
     end;
     if dept=0 then
     begin
          jobinfo.Locate('Page', pn, []);
          //joists.findkey([jobinfojobnumber.value,pn,mn]);
     end
     else
     begin
          sequence.Locate('Page', pn, []);
          //joists.findkey([sequencejobnumber.value,pn,mn]);
     end;
     Joists.Locate('Mark',mn, []);
     Refresh1Click(Sender);
     jobinfoform.free;
     jobinfobtn.down:=false;
end;

procedure TMainForm.Refresh1Click(Sender: TObject);
begin
     LockWindowUpdate(mainform.handle);
     ModuleBookPageChanged(Sender);
     LockWindowUpdate(0);
end;

procedure TMainForm.SprinklersClick(Sender: TObject);
begin
     sprinkform:=tsprinkform.create(application);
     sprinkform.showmodal;
     sprinkform.free;
     if modulebook.pageindex=2 then
        geometry.refresh;
     sprinklers.down:=false;
     if (ModuleBook.PageIndex=2) and (ModuleBook.Visible) and (fileopen)then
        joistpaint;
end;

procedure TMainForm.ExtensionsClick(Sender: TObject);
begin
     tcextenform:=ttcextenform.create(application);
     tcextenform.showmodal;
     tcextenform.free;
     extensions.down:=false;
end;

procedure TMainForm.CaseComboChange(Sender: TObject);
var
   temp:single;

  procedure case1;
  begin
       casedesc.items.add('Uniform Loads');
       casedesc.items.add('Concentrated Loads from Gravity');
       casedesc.items.add('Positive Concentrated Loads (+,-)');
  end;

begin
     temp:=tcsection.maxforce;
     tcsection.maxforce:=0;
     casedesc.items.clear;

     if JoistsLRFD.Value then
     begin
       case CaseCombo.itemindex of
       0:casedesc.items.add('Summary of All Cases');
       1:begin
          docase1LRFD;
          casedesc.items.add('Uniform DL (1.4)');
          casedesc.items.add('Girder Concentrated DL (1.4)');
         end;
       2:begin
          docase2aLRFD;
          casedesc.items.add('Uniform DL (1.2)');
          casedesc.items.add('Girder Concentrated DL (1.2)');
          casedesc.items.add('Uniform LL (1.6)');
          casedesc.items.add('Girder Concentrated LL (1.6)');
         end;
       3:begin
          docase2bLRFD;
          casedesc.items.add('Uniform DL (1.2)');
          casedesc.items.add('Girder Concentrated DL (1.2)');
          casedesc.items.add('Uniform LL (1.6)');
          casedesc.items.add('Girder Concentrated LL (1.6)');
          casedesc.items.add('Axial Load (1.6)');
         end;
       4:begin
          docase3aLRFD;
          casedesc.items.add('Uniform DL (1.2)');
          casedesc.items.add('Girder Concentrated DL (1.2)');
          casedesc.items.add('Uniform LL (1.0)');
          casedesc.items.add('Girder Concentrated LL (1.0)');
          casedesc.items.add('Wind Loads (1.0)');
          casedesc.items.add('Positive Lateral Moment (1.0)');
         end;
       5:begin
          docase3bLRFD;
          casedesc.items.add('Uniform DL (1.2)');
          casedesc.items.add('Girder Concentrated DL (1.2)');
          casedesc.items.add('Uniform LL (1.0)');
          casedesc.items.add('Girder Concentrated LL (1.0)');
          casedesc.items.add('Wind Loads (1.0)');
          casedesc.items.add('Negative Lateral Moment (1.0)');
         end;
       6:begin
          docase4aLRFD;
          casedesc.items.add('Uniform DL (1.2)');
          casedesc.items.add('Girder Concentrated DL (1.2)');
          casedesc.items.add('Uniform LL (1.0)');
          casedesc.items.add('Girder Concentrated LL (1.0)');
          casedesc.items.add('Positive Fixed Moment (1.0)');
         end;
       7:begin
          docase4bLRFD;
          casedesc.items.add('Uniform DL (1.2)');
          casedesc.items.add('Girder Concentrated DL (1.2)');
          casedesc.items.add('Uniform LL (1.0)');
          casedesc.items.add('Girder Concentrated LL (1.0)');
          casedesc.items.add('Negative Fixed Moment (1.0)');
         end;
       8:begin
          docase5aLRFD;
          casedesc.items.add('Uniform DL (0.9)');
          casedesc.items.add('Girder Concentrated DL (0.9)');
          casedesc.items.add('Wind Loads (1.0)');
          casedesc.items.add('Positive Lateral Moment (1.0)');
         end;
       9:begin
          docase5bLRFD;
          casedesc.items.add('Uniform DL (0.9)');
          casedesc.items.add('Girder Concentrated DL (0.9)');
          casedesc.items.add('Wind Loads (1.0)');
          casedesc.items.add('Negative Lateral Moment (1.0)');
         end;
       10:begin
          docase6aLRFD;
          casedesc.items.add('Uniform DL (0.9)');
          casedesc.items.add('Girder Concentrated DL (0.9)');
          casedesc.items.add('Positive Fixed Moment (1.0)');
         end;
       11:begin
          docase6bLRFD;
          casedesc.items.add('Uniform DL (0.9)');
          casedesc.items.add('Girder Concentrated DL (0.9)');
          casedesc.items.add('Negative Fixed Moment (1.0)');
         end;
       end;
     end
     else
     begin
       case CaseCombo.itemindex of
       0:casedesc.items.add('Summary of All Cases');
       1:begin
              docase1;
              case1;
         end;
       2:begin
              docase2;
              case1;
         end;
       3:begin
              docase3(1);
              case1;
         end;
       4:begin
              docase4;
              case1;
              casedesc.items.add('Axial Loads');
         end;
       5:begin
              docase5;
              casedesc.items.add('Net Uplift');
              casedesc.items.add('Negative Concentrated Loads (+,-)');
              casedesc.items.add('Positive Lateral Moments');
         end;
       6:begin
              docase6;
              casedesc.items.add('Net Uplift');
              casedesc.items.add('Negative Concentrated Loads (+,-)');
              casedesc.items.add('Negative Lateral Moments');
         end;
       7:begin
              docase7;
              case1;
              casedesc.items.add('Fixed + Positive Lateral Moments');
         end;
       8:begin
              docase8;
              case1;
              casedesc.items.add('Fixed + Negative Lateral Moments');
         end;
       end;
       if CaseCombo.itemindex>3 then
          casedesc.items.add('* All Loads Reduced by 25%');
     end;

     FreshStress;
     tcsection.maxforce:=temp;
     deflection;
end;

procedure TMainForm.MatReqClick(Sender: TObject);
begin
     matreqform:=tmatreqform.create(application);
     matreqform.showmodal;
     if matreqform.modalresult=mrYes then
     begin
          reportn:=2;
          PrintClick(Sender);
          reportn:=0;
     end;
     matreqform.free;
     refresh1click(sender);
end;

procedure TMainForm.MatSubstClick(Sender: TObject);
begin
     fixesform:=tfixesform.create(application);
     fixesform.showmodal;
     if fixesform.modalresult=mrOk then
     begin
          fillloads;
          if listbox1.itemindex>0 then
             listbox1.itemindex:=0;
          ListBox1Click(Sender);
     end;
     fixesform.free;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
     aboutform:=taboutform.create(application);
     aboutform.showmodal;
     aboutform.free;
end;

procedure TMainForm.extrastabsChange(Sender: TObject);
begin
     if extrastabs.TabIndex<4 then
     begin
        doextras(extrastabs.TabIndex);
        memo1.hide;
        dbgrid1.show;
     end
     else
     begin
          dbgrid1.hide;
          memo1.show;
     end;
end;

procedure TMainForm.FillCaseCombo;
begin
  with CaseCombo do
  begin
    Clear;
    if JoistsLRFD.Value then
    begin
      GroupBox7.Caption:='Load Cases (LRFD)';
      Items.Add('Summary or Envelope');
      Items.Add('Case 1: 1.4(DL)');
      Items.Add('Case 2a: 1.2(DL)+1.6(LL)+1.6(TL)');
      Items.Add('Case 2b: 1.2(DL)+1.6(LL+AX)+1.6(TL)');
      Items.Add('Case 3a: 1.2(DL)+1.0(WL+LL+LM)+1.6(TL)');
      Items.Add('Case 3b: 1.2(DL)+1.0(WL+LL-LM)+1.6(TL)');
      Items.Add('Case 4a: 1.2(DL)+1.0(LL+EQ)+1.6(TL)');
      Items.Add('Case 4b: 1.2(DL)+1.0(LL-EQ)+1.6(TL)');
      Items.Add('Case 5a: 0.9(DL)+1.0(WL+LM)');
      Items.Add('Case 5b: 0.9(DL)+1.0(WL-LM)');
      Items.Add('Case 6a: 0.9(DL)+1.0(EQ)');
      Items.Add('Case 6b: 0.9(DL)-1.0(EQ)');
    end
    else
    begin
      GroupBox7.Caption:='Load Cases (ASD)';
      Items.Add('Summary or Envelope');
      Items.Add('Case 1: DL');
      Items.Add('Case 2: LL');
      Items.Add('Case 3: DL+LL');
      Items.Add('Case 4: 0.75 (DL+LL+AXIAL)');
      Items.Add('Case 5: 0.75 (WIND+Pve.LEM)');
      Items.Add('Case 6: 0.75 (WIND+Neg.LEM)');
      Items.Add('Case 7: 0.75 (DL+LL+FEM+Pve.LEM)');
      Items.Add('Case 8: 0.75 (DL+LL+FEM+Neg.LEM)');
    end;
    ItemIndex:=0;
  end;
end;

procedure TMainForm.DBGrid4KeyPress(Sender: TObject; var Key: Char);
begin
     if key=#13 then
       PropertiesClick(Sender);
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
     if modulebook.PageIndex=0 then
        savedialog1.filename:=jobjobnumber.value+'_'+inttostr(currpage)
     else
         savedialog1.filename:=joistsmark.value+'_'+inttostr(currpage);
     SaveDialog1.Filter:='Bitmap File (*.bmp)|*.bmp';
     SaveDialog1.DefaultExt:='bmp';
     if savedialog1.execute then
        Preview.Picture.SaveToFile(SaveDialog1.FileName);
     SaveDialog1.Filter:='STAAD III File (*.std)|*.std';
     SaveDialog1.DefaultExt:='std';
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
     Close1Click(Sender);
end;

procedure TMainForm.ISPJoistHelp1Click(Sender: TObject);
begin
     Application.HelpContext(modulebook.HelpContext);
end;

procedure TMainForm.UpdateFile1Click(Sender: TObject);
var
   x:integer;
   length:real;
begin
     if sender<>nil then
     if MessageDlg('Update entire file and overwrite old one?',mtWarning,[mbOk, mbCancel],0)=mrCancel then
        exit;
     joists.first;
     while not joists.eof do
     begin
          recalcjoist;
          joists.edit;
          joistsweight.value:=weight;
          joistsmaterial.value:=material;
          findangle(tcsection.section);
          if angprop^.plate>0 then
             findangle(angprop^.prevmat);
          joistschords.value:=angprop^.Section+'/';
          findangle(bcsection.section);
          if angprop^.plate>0 then
             findangle(angprop^.prevmat);
          joistschords.value:=joistschords.value+angprop^.Section;
          joists.post;
          joists.next;
     end;
     jsubst.first;
     while not jsubst.eof do
     begin
          jsubst.edit;
          length:=ingtodec(jsubstBaseLength.value);
          findangle(jsubstsection.value);
          if jsubsttype.value='1' then
             jsubstweight.value:=length/12*angprop^.weight*2
          else
              jsubstweight.value:=length/12*angprop^.weight*4;
          jsubstmaterial.value:=(MainForm.jsubstweight.value/2000)*angprop^.cost;
          jsubst.post;
          jsubst.Next;
     end;
     if dept=0 then
     begin
          bridg.first;
          while not bridg.eof do
          begin
               bridg.edit;
               length:=bridgplanfeet.value*2;
               if bridgtype.value='HB' then
                  length:=length*(1+100/1900)
               else
                   length:=length*(1.30);
               findangle(bridgsection.value);
               bridgweight.value:=length*angprop^.weight;
               bridgmaterial.value:=(bridgweight.value/2000)*angprop^.cost;
               bridg.post;
               bridg.Next;
          end;
          if sender<>nil then
          begin
               jobpropform:=tjobpropform.create(application);
               {jobpropform.table1.findkey([jobinfojobnumber.value,jobinfopage.value]);
               jobpropform.Table1.edit;
               jobpropform.table1datequoted.value:=date;}
               JobInfo.Edit;
               JobInfoDateQuoted.Value:=date;
               jobpropform.recalcquote;
               jobpropform.free;
               jobmisc.disablecontrols;
               for x:=0 to 3 do
               begin
                    doextras(x);
                    jobmisc.first;
                    while not JobMisc.eof do
                    begin
                         if pricetbl.Locate('category;item',vararrayof([jobmisccategory.value,jobmiscitem.value]),[]) then
                         begin
                              jobmisc.edit;
                              JobMiscUnitPrice.Value:=pricetblunitprice.value;
                              jobmisc.post;
                         end;
                         jobmisc.next;
                    end;
               end;
               //JobMisc.ApplyUpdates(0);
               jobmisc.enablecontrols;
               doextras(extrastabs.TabIndex);
          end
          else
          begin
               JobInfo.edit;
               JobInfoDateQuoted.Value:=date;
               jobinfo.post;
          end;
     end
     else
     begin
         sequence.edit;
         sequencestatus.value:='M';
         sequence.post;
     end;
     Refresh1Click(Sender);
end;

procedure TMainForm.ViewDeflection1Click(Sender: TObject);
begin
        deltascle:=strtofloat(inputbox('View Deflection', 'Delta Y Scale:', floattostr(deltascle)));
     if (ModuleBook.PageIndex=2) and (coolbar1.visible) and (jobopen.pageindex=0) then
           joistpaint;
end;

procedure TMainForm.Export1Click(Sender: TObject);
begin
        exportjobsform:=texportjobsform.create(application);
        exportjobsform.showmodal;
        exportjobsform.free;
        if not fileopen then
        begin
                job.open;
                job.close;
        end;
end;

procedure TMainForm.Import1Click(Sender: TObject);
begin
        importform:=timportform.create(application);
        importform.showmodal;
        importform.free;
        Refresh1Click(Sender);
        if not fileopen then
        begin
                job.open;
                job.close;
        end;
end;

procedure TMainForm.ImportJoistsClick(Sender: TObject);
begin
        if (dept=0) and ((not fileopen) or (JobInfo.RecordCount=0)) then
        begin
                MessageDlg('You need to create a Bid Sheet to add the joists.', mtInformation, [mbOk], 0);
                abort;
        end;
        if (dept>0) and ((not fileopen) or (sequence.RecordCount=0)) then
        begin
                MessageDlg('You need to create a Bid Sheet to add the joists.', mtInformation, [mbOk], 0);
                abort;
        end;
        if OpenDialog1.Execute then
        begin
                psiform:=tpsiform.create(application);
                psiform.Memo1.Lines.LoadFromFile(opendialog1.FileName);
                psiform.Caption:=psiform.Caption+' - '+opendialog1.FileName;
                psiform.showmodal;
                if psiform.ModalResult=mrOk then
                        Refresh1Click(Sender);
                psiform.free;
        end;
end;

procedure TMainForm.DrawAutoCADClick(Sender: TObject);
var
 p1, p2, p3: OleVariant; // start & end points of line
 Mspace, Acad : OleVariant;
 x:integer;
begin
  // Create variant arrays to hold coordinates
  // VT_R8 = 5; { 8 byte real defined in /Source/RTL/Win/ActiveX.Pas }
  p1 := VarArrayCreate([0, 2], VT_R8);
  p2 := VarArrayCreate([0, 2], VT_R8);
  p3 := VarArrayCreate([0, 2], VT_R8);
  // Assign values to array elements
  p1[0] := 2.0; p1[1] := 4.0; p1[2] := 0.0;// from 2,4,0
  p2[0] := 12.0; p2[1] := 14.0; p2[2] := 0.0; // to 12,14,0
  p3[0] := 7.0; p3[1] := 8.0; p3[2] := 0.0;
  // Get Application and ModelSpace objects:
  try
    // see if AutoCAD is already running
    Acad := GetActiveOleObject('AutoCad.Application');
  except
    // if it is not running - start it up
    Acad:= CreateOleObject('AutoCad.Application');
  end;
  // bring AutoCAD to the windows desktop
  Acad.visible:= True;
  Mspace := Acad.ActiveDocument.ModelSpace;
  // use AutoCAD methods to draw a line and 3 circles
  {Mspace.AddLine(VarArrayRef(p1), VarArrayRef(p2)).Update;
  MSpace.AddCircle(VarArrayRef(p1), 1.5).Update;
  MSpace.AddCircle(VarArrayRef(p2), 1).Update;
  MSpace.AddCircle(VarArrayRef(p3), 2.0).Update;
  // use AutoCAD methods to draw other shapes and text
  MSpace.AddArc(VarArrayRef(p3), 1.2, 1, 2).Update;
  MSpace.AddBox(VarArrayRef(p2), 5, 3, 2).Update;
  MSpace.AddCone(VarArrayRef(p1), 1.3, 2).Update;
  MSpace.AddCylinder(VarArrayRef(p3), 1.7, 1.5).Update;
  MSpace.AddMtext(VarArrayRef(p3), 10, 'Delphi 3 Rocks!!!').update;}
   for x:=1 to memberlist.count do
   begin
          membdata:=memberlist.items[x-1];
          jointdata:=jointlist.items[membdata^.joint1-1];
          p1[0] := jointdata^.coordx;
          p1[1] := jointdata^.coordy;
          p1[2] := 0.0;
          jointdata:=jointlist.items[membdata^.joint2-1];
          p2[0] := jointdata^.coordx;
          p2[1] := jointdata^.coordy;
          p2[2] := 0.0;
          Mspace.AddLine(VarArrayRef(p1), VarArrayRef(p2)).Update;
   end;
   showmessage('Joist '+JoistsMark.value+' has been drawn in AutoCAD, all lines are center-lines');

end;

procedure TMainForm.JobInfoCalcFields(DataSet: TDataSet);
begin
  JobInfoCalc;
end;

procedure TMainForm.JobMiscAfterInsert(DataSet: TDataSet);
begin
  JobMiscJobNumber.Value:=JobInfoJobNumber.Value;
  JobMiscPage.Value:=JobInfoPage.Value;
end;

procedure TMainForm.JobMiscCalcFields(DataSet: TDataSet);
begin
  JobMiscCalc
end;

procedure TMainForm.JoistsBCPanelsLEValidate(Sender: TField);
begin
    if not newg then
     begin
          if ingtodec(joistsbcpanelsle.value)<ingtodec(joiststcpanelsle.value) then
          begin
               newg:=true;
               joiststcpanelsle.value:=joistsbcpanelsle.value;
               newg:=false;
          end;
          dogeometry;
          entryform.modpanel;
          entryform.fillridge;
     end;
     JoistsTCXLValidate(Sender);
end;

procedure TMainForm.JoistsBCPanelsREValidate(Sender: TField);
begin
    if not newg then
     begin
          if ingtodec(joistsbcpanelsre.value)<ingtodec(joiststcpanelsre.value) then
          begin
               newg:=true;
               joiststcpanelsre.value:=joistsbcpanelsre.value;
               newg:=false;
          end;
          dogeometry;
          entryform.modpanel;
          entryform.fillridge;
     end;
     JoistsTCXRValidate(Sender);
end;

procedure TMainForm.JoistsBCPanelValidate(Sender: TField);
begin
    newbcl:=true;
     if not newg then
        entryform.chggeom;
     newbcl:=false;
     if jtype in jtype1 then
        JoistsFirstDiagLEValidate(sender);
end;

procedure TMainForm.JoistsBCPValidate(Sender: TField);
begin
    entryform.panelcheck.checked:=false;
     JoistsFirstDiagLEValidate(mainform.JoistsFirstDiagLE);
end;

procedure TMainForm.JoistsCalcFields(DataSet: TDataSet);
begin
    if joistsjoisttype.value='L1' then
        joistsshape2.value:='Short Span Round';
     if joistsjoisttype.value='L2' then
        joistsshape2.value:='Short Span Crimp';
     if joistsjoisttype.value='LS' then
        joistsshape2.value:='Long Span Joist';
     if joistsjoisttype.value='JG' then
        joistsshape2.value:='Joist Girder';
     joistsfirsthalfle.value:=dectoing(ingtodec(JoistsFirstDiagLE.Value)-ingtodec(JoistsBCPanelsLE.Value));
     joistsfirsthalfre.value:=dectoing(ingtodec(JoistsFirstDiagRE.Value)-ingtodec(JoistsBCPanelsRE.Value));
end;

procedure TMainForm.JoistsDepthLEValidate(Sender: TField);
var
   temp:single;
begin
     if joistsshape.value='S' then
     if not newg then
     begin
          newg:=true;
          temp:=(((depth-JoistsDepthLE.value)/(bl/2))*bl)+JoistsDepthLE.value;
          JoistsDepthRE.value:=temp;
          newg:=false;
     end;
end;

procedure TMainForm.JoistsDescriptionValidate(Sender: TField);
var
   d:single;
begin
     if joistsbaselength.value='' then exit;
     if not dodescription then
        raise exception.create('Invalid Joist Type');
     case jtype of
     'K':if depth<=16 then d:=1.5 else d:=2.5;
     'C':if depth<=16 then d:=1.5 else d:=2.5;
     else
         d:=2.5;
     end;
     entryform.tonslh.text:=format('%0.2f',[d]);
     if jtype in jtype1 then
     begin
        entryform.label63.caption:='lbs';
        entryform.Button1.Enabled:=true;
     end
     else
     begin
        entryform.label63.caption:='plf';
        entryform.Button1.Enabled:=false;
     end;
     with mainform do
     begin
          case jtype of
            'K':begin
                     joistsseatsbdl.value:=dectoinch(2.5);
                end;
            'C':begin
                     joistsseatsbdl.value:=dectoinch(2.5);
                end;
            'L':begin
                     joistsseatsbdl.value:=dectoinch(5);
                end;
            'D':begin
                     joistsseatsbdl.value:=dectoinch(5);
                end;
            else
            begin
                 joistsseatsbdl.value:=dectoinch(6);
            end;
          end;
          joistsseatsbdr.value:=joistsseatsbdl.value;
     end;
     entryform.chggeom;
end;

procedure TMainForm.JoistsFirstDiagLEValidate(Sender: TField);
var
   dsum:single;
   x:integer;
begin
     if not newg then
     begin
          newg:=true;
          dsum:=ingtodec(joistsfirsthalfle.value);
          if not (dsum>0) then
          begin
             JoistsBCPanelsLE.value:=dectoing(ingtodec(joistsfirstdiagLE.value));
             if ingtodec(JoistsTCPanelsLE.value)>ingtodec(JoistsBCPanelsLE.value) then
                JoistsTCPanelsLE.value:=JoistsBCPanelsLE.value;
          end;
          if sppanels then
          begin
               dsum:=0;
               for x:=1 to panellist.count do
               begin
                    tcpanel:=panellist.items[x-1];
                    dsum:=dsum+tcpanel^.length;
               end;
               joistsfirstdiagRE.value:=dectoing(bl-ingtodec(joistsfirstdiagLE.value)-dsum);
          end
          else
              joistsfirstdiagRE.value:=dectoing(bl-ingtodec(joistsfirstdiagLE.value)-
                 (joistsbcp.value-1)*ingtodec(joistsbcpanel.value));
          dsum:=ingtodec(joistsfirsthalfre.value);
          if not (dsum>0) then
          begin
               JoistsBCPanelsRE.value:=joistsfirstdiagRE.value;
               if ingtodec(JoistsTCPanelsRE.value)>ingtodec(JoistsBCPanelsRE.value) then
                  JoistsTCPanelsRE.value:=JoistsBCPanelsRE.value;
          end;
          newg:=false;
          dogeometry;
          entryform.modpanel;
          entryform.fillridge;
     end;
end;

procedure TMainForm.JoistsFirstDiagREValidate(Sender: TField);
var
   dsum:single;
   x:integer;
begin
     if not newg then
     begin
          newg:=true;
          dsum:=ingtodec(joistsfirsthalfre.value);
          if not (dsum>0) then
          begin
             JoistsBCPanelsRE.value:=joistsfirstdiagRE.value;
             if ingtodec(JoistsTCPanelsRE.value)>ingtodec(JoistsBCPanelsRE.value) then
                JoistsTCPanelsRE.value:=JoistsBCPanelsRE.value;
          end;
          if sppanels then
          begin
               dsum:=0;
               for x:=1 to panellist.count do
               begin
                    tcpanel:=panellist.items[x-1];
                    dsum:=dsum+tcpanel^.length;
               end;
               joistsfirstdiagLE.value:=dectoing(bl-ingtodec(joistsfirstdiagRE.value)-dsum);
          end
          else
              joistsfirstdiagLE.value:=dectoing(bl-ingtodec(joistsfirstdiagRE.value)-
                (joistsbcp.value-1)*ingtodec(joistsbcpanel.value));
          dsum:=ingtodec(joistsfirsthalfle.value);
          if not (dsum>0) then
          begin
               JoistsBCPanelsLE.value:=joistsfirstdiagLE.value;
               if ingtodec(JoistsTCPanelsLE.value)>ingtodec(JoistsBCPanelsLE.value) then
                  JoistsTCPanelsLE.value:=JoistsBCPanelsLE.value;
          end;
          newg:=false;
          dogeometry;
          entryform.modpanel;
          entryform.fillridge;
     end;
end;

procedure TMainForm.JoistsLRFDValidate(Sender: TField);
begin
  if JoistsLRFD.Value then
    EntryForm.Label3.Caption:='Gross Uplift'
  else
    EntryForm.Label3.Caption:='Net Uplift';
end;

procedure TMainForm.JoistsTCPanelsLEValidate(Sender: TField);
var
   accept:boolean;
begin
     if not newg then
     begin
          accept:=true;
          if tfield(sender)=joiststcpanelsle then
          begin
             if ingtodec(joiststcpanelsle.value)>ingtodec(joistsbcpanelsle.value) then
                accept:=false;
          end
          else
          begin
               if ingtodec(joiststcpanelsre.value)>ingtodec(joistsbcpanelsre.value) then
                  accept:=false;
          end;
          if not accept then
             raise exception.create('TC Panel greater than BC Panel');
          dogeometry;
          entryform.modpanel;
          entryform.fillridge;
     end;
end;

procedure TMainForm.JoistsTCXLTYValidate(Sender: TField);
begin
    if JoistsTCXLTY.Value='S' then
                joistsseatlengthLE.value:=dectoing(defaultseat);
end;

procedure TMainForm.JoistsTCXLValidate(Sender: TField);
begin
     if rndweb then
        joistsbcxl.value:=dectoing(ingtodec(joistsbcpanelsle.value)+ingtodec(joiststcxl.value)-5)
     else
     begin
          if jtype in jtype1 then
          begin
                joistsbcxl.value:=joiststcxl.value;
          end
          else
              joistsbcxl.value:=dectoing(ingtodec(joistsbcpanelsle.value)+ingtodec(joiststcxl.value)-6);
     end;
     if ingtodec(joiststcxl.value)=0 then
        JoistsTCXLTY.Value:='R';
     if JoistsTCXLTY.Value='R' then
        joistsseatlengthLE.value:=dectoing(defaultseat+ingtodec(joiststcxl.value))
     else
        joistsseatlengthLE.value:=dectoing(defaultseat);
end;

procedure TMainForm.JoistsTCXRValidate(Sender: TField);
begin
    if rndweb then
        joistsbcxr.value:=dectoing(ingtodec(joistsbcpanelsre.value)+ingtodec(joiststcxr.value)-5)
     else
     begin
          if jtype in jtype1 then
          begin
                joistsbcxr.value:=joiststcxr.value;
          end
          else
              joistsbcxr.value:=dectoing(ingtodec(joistsbcpanelsre.value)+ingtodec(joiststcxr.value)-6);
     end;
     if ingtodec(joiststcxr.value)=0 then
        JoistsTCXRTY.Value:='R';
     if JoistsTCXRTY.Value='R' then
        joistsseatlengthRE.value:=dectoing(defaultseat+ingtodec(joiststcxr.value))
     else
        joistsseatlengthRE.value:=dectoing(defaultseat);
end;

procedure TMainForm.BridgCalcFields(DataSet: TDataSet);
begin
     bridgdescription.value:='';
     if bridgtype.value='HB' then
        bridgdescription.value:='Horizontal Bridging';
     if bridgtype.value='XB' then
        bridgdescription.value:='Diagonal Bridging';
end;

procedure TMainForm.JoistsDepthREValidate(Sender: TField);
var
   temp:single;
begin
     If joistsshape.value='S' then
     if not newg then
     begin
          newg:=true;
          temp:=JoistsDepthRE.value-(((JoistsDepthRE.value-depth)/(bl/2))*bl);
          JoistsDepthLE.value:=temp;
          newg:=false;
     end;
end;

end.
