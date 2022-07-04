unit Paneltc;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TPanelTCForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Bevel1: TBevel;
    Label1: TLabel;
    Edit1: TEdit;
    procedure valdectoing(Sender: TObject);
  private
    { Private declarations }
  public
        procedure getpanel(var length:single; panel:integer);
    { Public declarations }
  end;

var
  PanelTCForm: TPanelTCForm;

implementation

{$R *.DFM}

function dectoing(decn:single):shortstring; external 'comlib.dll';
function ingtodec(ing:shortstring):single; external 'comlib.dll';

procedure TPanelTCForm.getpanel(var length:single; panel:integer);
begin
     edit1.text:=dectoing(length);
     caption:='TC Panel '+inttostr(panel);
     showmodal;
     if modalresult=mrOK then
        length:=ingtodec(edit1.text)
end;

procedure TPanelTCForm.valdectoing(Sender: TObject);
var
   temp:string;
begin
     temp:=tedit(sender).text;
     if temp<>dectoing(ingtodec(temp)) then
     if temp='' then
        edit1.text:='0-0'
     else
     begin
          edit1.text:=dectoing(ingtodec(temp));
          if edit1.text='0-0' then
          begin
               edit1.text:=temp;
               edit1.setfocus;
               raise exception.create('Invalid input in field');
          end;
     end;
end;

end.
