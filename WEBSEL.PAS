unit Websel;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TWebSelForm = class(TForm)
    MatGroup: TRadioGroup;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    WebCombo: TComboBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    procedure FormShow(Sender: TObject);
    procedure MatGroupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebSelForm: TWebSelForm;

implementation

{$R *.DFM}

uses main, fixes;

procedure fillsect;
var
   x:integer;
   found:boolean;
begin
     found:=false;
     webselform.webcombo.clear;
     webselform.webcombo.items.add('Use Optimal Material');
     if webselform.MatGroup.itemindex=0 then
     begin
          for x:=0 to rndlist.count-1 do
          begin
               rndprop:=rndlist.items[x];
               webselform.webcombo.items.add(rndprop^.section+' = '+rndprop^.description);
               if rndprop^.section=membdata^.section then
               begin
                    found:=true;
                    webselform.webcombo.itemindex:=x+1;
               end;
          end;
     end
     else
     begin
          for x:=0 to anglist.count-1 do
          begin
               angprop:=anglist.items[x];
               if angprop^.plate>0 then
                  continue;
               webselform.webcombo.items.add(angprop^.section+' = '+angprop^.description);
               if angprop^.section=matdata^.section then
               begin
                    found:=true;
                    webselform.webcombo.itemindex:=webselform.webcombo.items.count-1;
               end;
          end;
     end;
     if not found then
        webselform.webcombo.itemindex:=0;
end;

procedure TWebSelForm.FormShow(Sender: TObject);
begin
     case matdata^.material of
     'R':MatGroup.itemindex:=0;
     'A':MatGroup.itemindex:=1;
     'D':MatGroup.itemindex:=2;
     end;
     edit1.text:=floattostr(matdata^.fy);
end;

procedure TWebSelForm.MatGroupClick(Sender: TObject);
begin
     fillsect;
end;

procedure TWebSelForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
   x,mp:integer;
begin
     if WebSelForm.modalresult=mrOK then
     begin
          case matgroup.itemindex of
          0:matdata^.material:='R';
          1:matdata^.material:='A';
          2:matdata^.material:='D';
          end;
          if webselform.webcombo.itemindex=0 then
             matdata^.section:=''
          else
          begin
               if membdata^.material='R' then
               begin
                    rndprop:=rndlist.items[webselform.webcombo.itemindex-1];
                    matdata^.section:=rndprop^.section;
               end
               else
               begin
                    mp:=0;
                    for x:=1 to anglist.Count do
                    begin
                         angprop:=anglist.items[x-1];
                         if (angprop^.plate>0) and (x<webselform.webcombo.itemindex+mp+1) then
                            inc(mp);
                    end;
                    angprop:=anglist.items[webselform.webcombo.itemindex-1+mp];
                    matdata^.section:=angprop^.section;
               end;
          end;
          matdata^.fy:=strtofloat(edit1.text);
     end;
end;

end.
