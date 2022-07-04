unit Customer;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, DB, Grids, DBGrids, Tabs, StdCtrls, Buttons,
  ExtCtrls, Mask, DBCtrls, ADODB;

type
  TCustomerForm = class(TForm)
    DataSource1: TDataSource;
    OKBtn: TBitBtn;
    AddBtn: TBitBtn;
    Notebook1: TNotebook;
    GroupBox1: TGroupBox;
    Locate: TLabel;
    edit1: TEdit;
    CustGrid: TDBGrid;
    GroupBox2: TGroupBox;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label6: TLabel;
    DBEdit5: TDBEdit;
    Table1: TADOTable;
    Table1Customer: TWideStringField;
    Table1Address: TWideStringField;
    Table1City: TWideStringField;
    Table1State: TWideStringField;
    Table1Zip: TWideStringField;
    Table1Telephone: TWideStringField;
    Table1Fax: TWideStringField;
    Table1EMail: TWideStringField;
    Table1Contact: TWideStringField;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CustGridDblClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CustomerForm: TCustomerForm;

implementation

{$R *.DFM}

uses main;

procedure TCustomerForm.FormShow(Sender: TObject);
begin
     notebook1.pageindex:=0;
     table1.open;
     edit1.text:='';
     edit1.setfocus;
end;

procedure TCustomerForm.FormHide(Sender: TObject);
begin
     table1.close;
end;

procedure TCustomerForm.edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if edit1.text<>'' then
     begin
          try
          table1.disablecontrols;
          table1.first;
          Table1.Locate('customer',uppercase(edit1.text),[loPartialKey]);
          finally
          table1.enablecontrols;
          end;
     end;
end;

procedure TCustomerForm.AddBtnClick(Sender: TObject);
begin
     if notebook1.pageindex=0 then
     begin
          okbtn.cancel:=false;
          addbtn.cancel:=true;
          table1.insert;
          addbtn.caption:='Cancel';
          notebook1.pageindex:=1;
          addbtn.modalresult:=mrcancel;
          dbedit1.setfocus;
     end;
end;

procedure TCustomerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     if Table1.State<>dsbrowse then
     begin
          if modalresult=mrOk then
             table1.post
          else
              table1.cancel;
     end;
end;

procedure TCustomerForm.CustGridDblClick(Sender: TObject);
begin
     okbtn.cancel:=false;
     addbtn.cancel:=true;
     addbtn.caption:='Cancel';
     notebook1.pageindex:=1;
     addbtn.modalresult:=mrcancel;
     dbedit1.setfocus;
end;

procedure TCustomerForm.OKBtnClick(Sender: TObject);
begin
     Okbtn.setfocus;
end;

end.
