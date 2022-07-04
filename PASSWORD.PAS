unit password;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, Buttons;

type
  TPasswordForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    ComboBox1: TComboBox;
    DBEdit3: TDBEdit;
    OKBtn: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure valuppercase(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PasswordForm: TPasswordForm;

implementation

uses OptMain;

{$R *.DFM}

procedure TPasswordForm.FormShow(Sender: TObject);
begin
     ComboBox1.ItemIndex:=OptMainForm.Table4Department.Value;
end;

procedure TPasswordForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     OKBtn.SetFocus;
     if ModalResult=mrOK then
     begin
          OptMainForm.Table4Department.Value:=ComboBox1.ItemIndex;
          OptMainForm.Table4.Post;
     end
     else
         OptMainForm.Table4.cancel;
end;

procedure TPasswordForm.valuppercase(Sender: TObject);
var
   temp:string;
begin
     temp:=Optmainform.table4.fieldbyname(tdbedit(sender).datafield).asstring;
     if temp<>uppercase(temp) then
        Optmainform.table4.fieldbyname(tdbedit(sender).datafield).asstring:=uppercase(temp);
end;

end.
