unit Extload;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TExtLoadForm = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label2: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    Edit2: TEdit;
    procedure valdectoing(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure getload(var Dist,Load:single);
  end;

var
  ExtLoadForm: TExtLoadForm;


implementation

{$R *.DFM}

uses main,entry;

function ingtodec(ing:shortstring):single; external 'comlib.dll';
function dectoing(decn:single):shortstring; external 'comlib.dll';

procedure TExtLoadForm.getload(var Dist,Load:single);
begin
     edit1.text:=floattostr(load);
     showmodal;
     load:=strtofloat(edit1.text);
     dist:=ingtodec(edit2.text);
end;

procedure TExtLoadForm.valdectoing(Sender: TObject);
var
   temp:string;
begin
     temp:=tedit(sender).text;
     if temp<>dectoing(ingtodec(temp)) then
     if temp='' then
        tedit(sender).text:='0-0'
     else
     begin
          tedit(sender).text:=dectoing(ingtodec(temp));
          if tedit(sender).text='0-0' then
          begin
               tedit(sender).text:=temp;
               tedit(sender).setfocus;
               raise exception.create('Invalid input in field');
          end;
     end;
end;

procedure TExtLoadForm.Edit1Exit(Sender: TObject);
begin
     try
     tedit(sender).text:=format('%0.2f',[strtofloat(tedit(sender).text)]);
     except
           tedit(sender).setfocus;
           raise exception.create('Invalid input');
     end;
end;

end.
