unit Bridg2;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls, DB, Tabs,
  DBTables, DBLookup;

type
  TBridg2Form = class(TForm)
    DataSource1: TDataSource;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Joist: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    DBEdit1: TDBEdit;
    SectCombo: TComboBox;
    DBEdit2: TDBEdit;
    brdgtype: TComboBox;
    DBEdit3: TDBEdit;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label10: TLabel;
    Edit5: TEdit;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SectComboChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure valuppercase(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
  private
    { Private declarations }
    procedure fillsect;
  public
    { Public declarations }
    procedure newentry;
  end;

var
  Bridg2Form: TBridg2Form;

implementation

uses main;

{$R *.DFM}

function clength(x1,y1,x2,y2:single):single; external 'comlib.dll';
function findint(var x1,y1:single; x2,y2,x3,y3,x4,y4:single):boolean; external 'comlib.dll';
function dectoing(decn:single):shortstring; external 'comlib.dll';

procedure diagbridg(var a,b,c,d:single);
var
   x1,y1,x2,y2,x3,y3,x4,y4:single;
begin
     x1:=0;
     y1:=0;
     x2:=x1+a;
     y2:=y1+b+d;
     a:=clength(x1,y1,x2,y2);
     x3:=x1;
     x4:=x2;
     y3:=y1+b;
     y4:=y3-(c-d);
     findint(x1,y1,x2,y2,x3,y3,x4,y4);
     b:=clength(x1,y1,x2,y2);
     c:=clength(x3,y3,x4,y4);
     d:=clength(x1,y1,x3,y3);
end;

procedure TBridg2Form.newentry;
begin
     fillsect;
     sectcombo.itemindex:=0;
     angprop:=anglist.items[0];
     showmodal;
end;

procedure TBridg2Form.OKBtnClick(Sender: TObject);
begin
     Okbtn.setfocus;
end;

procedure TBridg2Form.fillsect;
var
   x:integer;
begin
     for x:=0 to anglist.count-1 do
     begin
          angprop:=anglist.items[x];
          sectcombo.items.add(angprop^.section+' = '+angprop^.description);
     end;
end;

procedure TBridg2Form.FormCreate(Sender: TObject);
begin
     datasource1.dataset:=mainform.bridg2;
end;

procedure TBridg2Form.SectComboChange(Sender: TObject);
begin
     angprop:=anglist.items[sectcombo.itemindex];
end;

procedure TBridg2Form.FormShow(Sender: TObject);
begin
     dbedit1.setfocus;
     brdgtype.itemindex:=2;
end;

procedure TBridg2Form.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   length:single;
   a,b,c,d:single;
   q:integer;
   det:string[2];
begin
     if bridg2form.modalresult=mrOk then
     begin
          length:=0;
          a:=strtofloat(edit1.text);
          b:=strtofloat(edit2.text);
          c:=strtofloat(edit3.text);
          d:=strtofloat(edit4.text);
          diagbridg(a,b,c,d);
          case brdgtype.itemindex of
          2:begin
                 length:=a-2.25;
            end;
          end;
          with mainform do
          begin
               bridg2section.value:=angprop^.section;
               bridg2length.value:=dectoing(length);
               bridg2weight.value:=(length/12)*angprop^.weight*bridg2quantity.value;
               bridg2runby.value:=runby;
               if (b<>c) or (d>0) then
               begin
                    det:=bridg2detail.value;
                    q:=trunc(bridg2quantity.value/2);
                    bridg2quantity.value:=q;
                    Bridg2StringField12H.value:=dectoing(b-1.125);
                    bridg2weight.value:=(length/12)*angprop^.weight*bridg2quantity.value;
                    bridg2.post;
                    bridg2.insert;
                    bridg2detail.value:=det;
                    bridg2quantity.value:=q;
                    bridg2mark.value:=edit5.text;
                    length:=c-2.25;
                    Bridg2StringField12H.value:=dectoing(d-1.125);
                    bridg2length.value:=dectoing(length);
                    bridg2section.value:=angprop^.section;
                    bridg2weight.value:=(length/12)*angprop^.weight*bridg2quantity.value;
                    bridg2runby.value:=runby;
               end;
               bridg2.post;
          end;
     end
     else
         mainform.bridg2.cancel;
end;

procedure TBridg2Form.valuppercase(Sender: TObject);
var
   temp:string;
begin
     temp:=mainform.bridg2.fieldbyname(tdbedit(sender).datafield).asstring;
     if temp<>uppercase(temp) then
        mainform.bridg2.fieldbyname(tdbedit(sender).datafield).asstring:=uppercase(temp);
end;

procedure TBridg2Form.Edit1Exit(Sender: TObject);
begin
     try
     tedit(sender).text:=format('%0.2f',[strtofloat(tedit(sender).text)]);
     except
           tedit(sender).setfocus;
           raise exception.create('Invalid input');
     end;
end;

end.
