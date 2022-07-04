unit SupPassw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TSupPasswForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    OKBtn: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SupPasswForm: TSupPasswForm;

implementation

uses OptMain;

{$R *.DFM}

procedure TSupPasswForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
        if modalresult=mrOK then
        begin
                with OptMainForm do
                begin
                        try
                        table4.DisableControls;
                        table4.Filtered:=false;
                        Table4.Locate('User', 'SUPERVISOR', []);
                        if not (uppercase(SupPasswForm.Edit1.Text)=Table4Password.Value) then
                        begin
                              MessageDlg('Incorrect password', mterror, [mbOk], 0);
                              Edit1.SetFocus;
                              abort;
                        end;
                        finally
                        table4.Filtered:=true;
                        table4.EnableControls;
                        end;
                end;
        end;
end;

end.
