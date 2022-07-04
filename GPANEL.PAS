unit gpanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TGPanelForm = class(TForm)
    GroupBox1: TGroupBox;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure Edit15Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GPanelForm: TGPanelForm;

implementation

uses Main;

{$R *.DFM}

function dectoing(decn:single):shortstring; external 'comlib.dll';
function ingtodec(ing:shortstring):single; external 'comlib.dll';

procedure TGPanelForm.Edit15Exit(Sender: TObject);
var
   temp:string;
begin
     temp:=tedit(sender).text;
     if temp<>dectoing(ingtodec(temp)) then
     begin
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
     if (tedit(sender).name='Edit15') or (tedit(sender).name='Edit17') then
     begin
        edit18.Text:=dectoing(bl-ingtodec(edit15.text)-strtoint(edit16.text)*ingtodec(edit17.text));
     end;
     if (tedit(sender).name='Edit18') then
     begin
        edit15.Text:=dectoing(bl-ingtodec(edit18.text)-strtoint(edit16.text)*ingtodec(edit17.text));
     end;
     end;

end.
