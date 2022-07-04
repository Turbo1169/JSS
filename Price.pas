unit Price;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, StdCtrls, Buttons, DBCtrls, Mask;

type
  TPriceForm = class(TForm)
    OKBtn: TBitBtn;
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBText2: TDBText;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PriceForm: TPriceForm;

implementation

uses OptMain;

{$R *.DFM}

procedure TPriceForm.FormCreate(Sender: TObject);
begin
     GroupBox1.Caption:=OptMainForm.Table1Description.Value;
end;

procedure TPriceForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     OKBtn.SetFocus;
     if ModalResult=mrOK then
        OptMainForm.Table1.Post
     else
         OptMainForm.Table1.cancel;
end;

end.
