unit angles;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, StdCtrls, Buttons, Mask, DBCtrls;

type
  TAnglesForm = class(TForm)
    OKBtn: TBitBtn;
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    DBCheckBox1: TDBCheckBox;
    DBCheckBox2: TDBCheckBox;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure valuppercase(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AnglesForm: TAnglesForm;

implementation

uses OptMain;

{$R *.DFM}

procedure TAnglesForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     okbtn.SetFocus;
     if ModalResult=mrOk then
        OptMainForm.Table2.Post
     else
         OptMainForm.Table2.cancel;
end;

procedure TAnglesForm.valuppercase(Sender: TObject);
var
   temp:string;
begin
     temp:=Optmainform.table2.fieldbyname(tdbedit(sender).datafield).asstring;
     if temp<>uppercase(temp) then
        Optmainform.table2.fieldbyname(tdbedit(sender).datafield).asstring:=uppercase(temp);
end;

end.
