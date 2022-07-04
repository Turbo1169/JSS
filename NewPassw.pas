unit NewPassw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TNewPasswForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    OKBtn: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewPasswForm: TNewPasswForm;

implementation

{$R *.DFM}

procedure TNewPasswForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     if ModalResult=mrOk then
        if uppercase(Edit1.text)<>uppercase(Edit2.text) then
           raise exception.Create('Passwords don''t match');
end;

end.
