unit Bridging;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls, DB, Tabs,
  DBTables, DBLookup;

type
  TBridgingForm = class(TForm)
    Joist: TGroupBox;
    Label2: TLabel;
    Label20: TLabel;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    DBEdit1: TDBEdit;
    SectCombo: TComboBox;
    BrdgType: TRadioGroup;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SectComboChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure fillsect;
  public
    { Public declarations }
    procedure newentry;
  end;

var
  BridgingForm: TBridgingForm;

implementation

uses main;

{$R *.DFM}

var
   newent:boolean;

procedure TBridgingForm.newentry;
begin
     newent:=true;
     fillsect;
     sectcombo.itemindex:=0;
     angprop:=anglist.items[0];
     BrdgType.itemindex:=0;
     showmodal;
end;

procedure TBridgingForm.OKBtnClick(Sender: TObject);
begin
     Okbtn.setfocus;
end;

procedure TBridgingForm.fillsect;
var
   x:integer;
begin
     for x:=0 to anglist.count-1 do
     begin
          angprop:=anglist.items[x];
          sectcombo.items.add(angprop^.section+' = '+angprop^.description);
          if (not newent) and (angprop^.section=mainform.bridgsection.value) then
             sectcombo.itemindex:=x;
     end;
     if not newent then
        angprop:=anglist.items[sectcombo.itemindex];
end;

procedure TBridgingForm.FormCreate(Sender: TObject);
begin
     newent:=false;
end;

procedure TBridgingForm.SectComboChange(Sender: TObject);
begin
     angprop:=anglist.items[sectcombo.itemindex];
end;

procedure TBridgingForm.FormShow(Sender: TObject);
begin
     dbedit1.setfocus;
     if not newent then
     begin
          fillsect;
          if mainform.bridgtype.value='HB' then
             brdgtype.itemindex:=0
          else
              brdgtype.itemindex:=1;
     end;
end;

procedure TBridgingForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   length:single;
begin
     if bridgingform.modalresult=mrOk then
     begin
          with mainform do
          begin
          length:=bridgplanfeet.value*2;
          if brdgtype.itemindex=0 then
          begin
             bridgtype.value:='HB';
             length:=length*(1+100/1900);
          end
          else
          begin
              bridgtype.value:='XB';
              length:=length*(1.30);
          end;
          bridgsection.value:=angprop^.section;
          bridgweight.value:=length*angprop^.weight;
          bridgmaterial.value:=(bridgweight.value/2000)*angprop^.cost;
          bridgrunby.value:=runby;
          bridg.post;
          if dept=0 then
          begin
               jobinfo.edit;
               jobinfostatus.value:='M';
               jobinfo.post;
          end;
          end;
     end
     else
         mainform.bridg.cancel;
end;

end.
