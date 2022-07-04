unit OptMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, Db, ComCtrls, StdCtrls, Buttons, ExtCtrls, ADODB, XPMan;

type
  TOptMainForm = class(TForm)
    DataSource1: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid2: TDBGrid;
    TabSheet3: TTabSheet;
    DataSource2: TDataSource;
    DBGrid3: TDBGrid;
    DataSource3: TDataSource;
    DataSource4: TDataSource;
    TabSheet5: TTabSheet;
    DBGrid1: TDBGrid;
    DBGrid4: TDBGrid;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    Button2: TButton;
    Panel2: TPanel;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    Panel3: TPanel;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Panel4: TPanel;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    Panel5: TPanel;
    BitBtn1: TBitBtn;
    TabSheet4: TTabSheet;
    NotesMemo: TMemo;
    ADOConnection1: TADOConnection;
    Table4: TADOTable;
    Table4User: TWideStringField;
    Table4Initials: TWideStringField;
    Table4Password: TWideStringField;
    Table4Department: TSmallintField;
    Table4DepDesc: TStringField;
    Table1: TADOTable;
    Table1Category: TWideStringField;
    Table1Item: TSmallintField;
    Table1Description: TWideStringField;
    Table1UnitPrice: TFloatField;
    Table1Unit: TWideStringField;
    Table2: TADOTable;
    Table2Sort: TSmallintField;
    Table2Section: TWideStringField;
    Table2Description: TWideStringField;
    Table2B1: TFloatField;
    Table2B2: TFloatField;
    Table2Thick: TFloatField;
    Table2Cost: TFloatField;
    Table2Plate: TBooleanField;
    Table2ForSales: TBooleanField;
    Table2Radius: TFloatField;
    Table3: TADOTable;
    Table3Sort: TSmallintField;
    Table3Section: TWideStringField;
    Table3Description: TWideStringField;
    Table3Thick: TFloatField;
    Table3Cost: TFloatField;
    XPManifest1: TXPManifest;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKBtnClick(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid2DblClick(Sender: TObject);
    procedure DBGrid2KeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure DBGrid3KeyPress(Sender: TObject; var Key: Char);
    procedure DBGrid4DblClick(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Table4CalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OptMainForm: TOptMainForm;

implementation

uses Price, angles, rounds, password, SupPassw, NewPassw;

{$R *.DFM}

function mpass:shortstring; external 'comlib.dll';

procedure TOptMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     table4.close;
     table3.close;
     table2.close;
     table1.close;
     if NotesMemo.Modified then
     begin
        NotesMemo.Lines.SaveToFile('notes.txt');
     end;
end;

procedure TOptMainForm.OKBtnClick(Sender: TObject);
begin
     close;
end;

procedure TOptMainForm.DBGrid1KeyPress(Sender: TObject; var Key: Char);
begin
     if key=#13 then
       DBGrid1DblClick(Sender);
end;

procedure TOptMainForm.DBGrid2DblClick(Sender: TObject);
begin
     table2.edit;
     anglesform:=tanglesform.create(application);
     anglesform.showmodal;
     anglesform.free;
end;

procedure TOptMainForm.DBGrid2KeyPress(Sender: TObject; var Key: Char);
begin
     if key=#13 then
       DBGrid2DblClick(Sender);
end;

procedure TOptMainForm.BitBtn3Click(Sender: TObject);
var
   n:integer;
begin
     if Table2Sort.Value>1 then
     begin
          table2.Edit;
          n:=Table2Sort.Value;
          Table2Sort.Value:=Table2.RecordCount+1;
          table2.Locate('Sort', n-1, []);
          table2.edit;
          Table2Sort.Value:=n;
          table2.last;
          table2.edit;
          Table2Sort.Value:=n-1;
          table2.post;
     end;
end;

procedure TOptMainForm.BitBtn4Click(Sender: TObject);
var
   n:integer;
begin
     if Table2Sort.Value<Table2.RecordCount then
     begin
          table2.Edit;
          n:=Table2Sort.Value;
          Table2Sort.Value:=Table2.RecordCount+1;
          table2.Locate('Sort', n+1, []);
          table2.edit;
          Table2Sort.Value:=n;
          table2.last;
          table2.edit;
          Table2Sort.Value:=n+1;
          table2.post;
     end;
end;

procedure TOptMainForm.BitBtn5Click(Sender: TObject);
begin
     table2.Insert;
     Table2Sort.Value:=table2.RecordCount+1;
     Table2Plate.Value:=False;
     Table2ForSales.Value:=True;
     anglesform:=tanglesform.create(application);
     anglesform.showmodal;
     anglesform.free;
end;

procedure TOptMainForm.BitBtn6Click(Sender: TObject);
var
   n:integer;
begin
     if MessageDlg('Delete section '+Table2Section.Value+' from table?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     begin
          with table2 do
          begin
               DisableControls;
               n:=Table2Sort.Value;
               Delete;
               if n-1<recordcount then
               begin
                    while not eof do
                    begin
                         edit;
                         Table2Sort.Value:=Table2Sort.Value-1;
                         next;
                    end;
                    table2.Locate('Sort', n, []);
               end;
               EnableControls;
          end;
     end;
end;

procedure TOptMainForm.DBGrid1DblClick(Sender: TObject);
begin
     table1.edit;
     priceform:=tpriceform.create(application);
     priceform.showmodal;
     priceform.free;
end;

procedure TOptMainForm.DBGrid3DblClick(Sender: TObject);
begin
     table3.edit;
     roundsform:=troundsform.create(application);
     roundsform.showmodal;
     roundsform.free;
end;

procedure TOptMainForm.BitBtn8Click(Sender: TObject);
var
   n:integer;
begin
     if Table3Sort.Value>1 then
     begin
          table3.Edit;
          n:=Table3Sort.Value;
          Table3Sort.Value:=Table3.RecordCount+1;
          Table3.Locate('Sort', n-1, []);
          Table3.edit;
          Table3Sort.Value:=n;
          Table3.last;
          Table3.edit;
          Table3Sort.Value:=n-1;
          Table3.post;
     end;
end;

procedure TOptMainForm.BitBtn9Click(Sender: TObject);
var
   n:integer;
begin
     if Table3Sort.Value<Table3.RecordCount then
     begin
          Table3.Edit;
          n:=Table3Sort.Value;
          Table3Sort.Value:=Table3.RecordCount+1;
          Table3.Locate('Sort', n+1, []);
          Table3.edit;
          Table3Sort.Value:=n;
          Table3.last;
          Table3.edit;
          Table3Sort.Value:=n+1;
          Table3.post;
     end;
end;

procedure TOptMainForm.Table4CalcFields(DataSet: TDataSet);
begin
    case table4department.Value of
       0:Table4DepDesc.Value:='Sales';
       1:Table4DepDesc.Value:='Shoporders';
       2:Table4DepDesc.Value:='Approvals';
       3:Table4DepDesc.Value:='Supervisor';
     end;
end;

procedure TOptMainForm.BitBtn10Click(Sender: TObject);
begin
     Table3.Insert;
     Table3Sort.Value:=Table3.RecordCount+1;
     roundsform:=troundsform.create(application);
     roundsform.showmodal;
     roundsform.free;
end;

procedure TOptMainForm.BitBtn11Click(Sender: TObject);
var
   n:integer;
begin
     if MessageDlg('Delete section '+Table3Section.Value+' from table?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     begin
          with Table3 do
          begin
               DisableControls;
               n:=Table3Sort.Value;
               Delete;
               if n-1<recordcount then
               begin
                    while not eof do
                    begin
                         edit;
                         Table3Sort.Value:=Table3Sort.Value-1;
                         next;
                    end;
                    Table3.Locate('Sort', n, []);
               end;
               EnableControls;
          end;
     end;
end;

procedure TOptMainForm.DBGrid3KeyPress(Sender: TObject; var Key: Char);
begin
     if key=#13 then
       DBGrid3DblClick(Sender);
end;

procedure TOptMainForm.DBGrid4DblClick(Sender: TObject);
begin
     table4.edit;
     passwordform:=tpasswordform.create(application);
     passwordform.showmodal;
     passwordform.free;
end;

procedure TOptMainForm.BitBtn13Click(Sender: TObject);
begin
     table4.insert;
     Table4Department.Value:=0;
     DBGrid4DblClick(Sender);
end;

procedure TOptMainForm.BitBtn14Click(Sender: TObject);
begin
     if MessageDlg('Delete user '+Table4User.Value+'?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        table4.delete;
end;

procedure TOptMainForm.Button2Click(Sender: TObject);
begin
     newpasswform:=tnewpasswform.create(application);
     newpasswform.showmodal;
     if NewPasswForm.ModalResult=mrOk then
     begin
          try
          table4.DisableControls;
          table4.Filtered:=false;
          Table4.Locate('User', 'SUPERVISOR', []);
          table4.edit;
          Table4Password.Value:=uppercase(NewPasswForm.Edit1.Text);
          table4.post;
          finally
          table4.Filtered:=true;
          table4.EnableControls;
          end;
     end;
     newpasswform.free;
end;

procedure TOptMainForm.FormCreate(Sender: TObject);
begin
     try
     table4.open;
     suppasswform:=tsuppasswform.create(application);
     suppasswform.showmodal;
     if SupPasswForm.ModalResult<>mrOk then
     begin
        suppasswform.free;
        halt;
     end
     else
        suppasswform.free;
     table1.open;
     table2.open;
     table3.open;
     if fileexists('notes.txt') then
        NotesMemo.Lines.LoadFromFile('notes.txt')
     else
        NotesMemo.Clear;
     except
           MessageDlg('Unable to open database, check BDE.', mtError,[mbOk], 0);
           halt;
     end;
end;

end.
