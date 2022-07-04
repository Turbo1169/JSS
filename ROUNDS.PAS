unit rounds;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Db, Mask, DBCtrls;

type
  TRoundsForm = class(TForm)
    GroupBox1: TGroupBox;
    OKBtn: TBitBtn;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    DBEdit6: TDBEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure valuppercase(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RoundsForm: TRoundsForm;

implementation

uses OptMain;

{$R *.DFM}

procedure TRoundsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     okbtn.SetFocus;
     if ModalResult=mrOk then
        OptMainForm.Table3.Post
     else
         OptMainForm.Table3.cancel;
end;

procedure TRoundsForm.valuppercase(Sender: TObject);
var
   temp:string;
begin
     temp:=Optmainform.table3.fieldbyname(tdbedit(sender).datafield).asstring;
     if temp<>uppercase(temp) then
        Optmainform.table3.fieldbyname(tdbedit(sender).datafield).asstring:=uppercase(temp);
end;

end.
