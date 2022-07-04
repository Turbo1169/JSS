unit Tcexten;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, math,
  Forms, Dialogs, StdCtrls, Buttons, Grids, extload;

type
  TTCExtenForm = class(TForm)
    GroupBox1: TGroupBox;
    ConcGrid: TStringGrid;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Length: TEdit;
    TLUniform: TEdit;
    LLUniform: TEdit;
    TLDeflection: TEdit;
    LLDeflection: TEdit;
    Label8: TLabel;
    Depth: TEdit;
    SuppCheck: TCheckBox;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    Label9: TLabel;
    Label7: TLabel;
    Smtext: TLabel;
    Mitext: TLabel;
    Section: TLabel;
    OKBtn: TBitBtn;
    procedure ConcGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure valfloat(Sender: TObject);
    procedure valdectoing(Sender: TObject);
    procedure SuppCheckClick(Sender: TObject);
  private
         procedure calcext;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCExtenForm: TTCExtenForm;

implementation

{$R *.DFM}

uses main;

type
  PLoad=^TLoad;
  TLoad=Record
    Distance,Force:single;
  end;
var
   llist:Tlist;
   loadd:pload;

function dectoing(decn:single):shortstring; external 'comlib.dll';
function ingtodec(ing:shortstring):single; external 'comlib.dll';

procedure fillconc;
var
   x:integer;
begin
     with tcextenform.concgrid do
     begin
          cells[0,0]:='Distance';
          cells[1,0]:='Load';
          if llist.count>0 then
          begin
               rowcount:=llist.count+1;
               for x:=1 to llist.count do
               begin
                    loadd:=llist.items[x-1];
                    cells[0,x]:=dectoing(loadd^.distance);
                    cells[1,x]:=format('%0.2n',[loadd^.Force]);
               end;
          end
          else
          begin
               cells[0,1]:='';
               cells[1,1]:='';
               rowcount:=2;
          end;
          ColWidths[0]:=clientwidth-66;
     end;
end;

procedure insertload;
var
   d,l:single;
begin
     l:=0;
     extloadform:=textloadform.create(application);
     extloadform.getload(d,l);
     if extloadform.modalresult=mrOK then
     begin
          New(loadd);
          loadd^.Distance:=d;
          loadd^.Force:=l;
          lList.add(loadd);
     end;
     extloadform.free;
     fillconc;
end;

procedure TTCExtenForm.calcext;
var
   reqmitl,reqmill,m,reqsm,reqmi:single;
   yc,edc,ic,sm,b,tld,lld:single;
   x:integer;
begin
     try
     tld:=ingtodec(length.text)/strtofloat(tldeflection.text);
     lld:=ingtodec(length.text)/strtofloat(lldeflection.text);
     m:=0;
     if SuppCheck.checked then
     begin
          if llist.count>0 then
          for x:=1 to llist.count do
          begin
               loadd:=llist.items[x-1];
               m:=m+loadd^.force/2*(ingtodec(length.text)/12-loadd^.distance/12);
          end;
          m:=m+(strtofloat(TLUniform.text)*(sqr(ingtodec(length.text)/12))/8);
          reqmitl:=5*strtofloat(TLUniform.text)*(intpower(ingtodec(length.text)/12,4))/(384*E*1000*tld)*intpower(12,3);
          reqmill:=5*strtofloat(LLUniform.text)*(intpower(ingtodec(length.text)/12,4))/(384*E*1000*lld)*intpower(12,3);
          for x:=1 to llist.count do
          begin
               loadd:=llist.items[x-1];
               b:=ingtodec(length.text)/12-loadd^.distance/12;
               reqmitl:=reqmitl+loadd^.force*sqr(loadd^.distance/12)*
                        sqr(b)/(3*E*1000*tld*(ingtodec(length.text)/12))*intpower(12,3);
          end;
     end
     else
     begin
          for x:=1 to llist.count do
          begin
               loadd:=llist.items[x-1];
               m:=m+loadd^.force*loadd^.Distance/12;
          end;
          m:=m+(strtofloat(TLUniform.text)*(sqr(ingtodec(length.text)/12))/2);
          reqmitl:=strtofloat(TLUniform.text)*(intpower(ingtodec(length.text)/12,4))/(8*E*1000*tld)*intpower(12,3);
          reqmill:=strtofloat(LLUniform.text)*(intpower(ingtodec(length.text)/12,4))/(8*E*1000*lld)*intpower(12,3);
          for x:=1 to llist.count do
          begin
               loadd:=llist.items[x-1];
               reqmitl:=reqmitl+loadd^.force*sqr(loadd^.Distance/12)/(6*E*1000*tld)*
                   (3*ingtodec(length.text)/12-loadd^.Distance/12)*intpower(12,3);
          end;
     end;
     m:=m*12;
     reqsm:=m/30000;
     if reqmitl>reqmill then
        reqmi:=reqmitl
     else
         reqmi:=reqmill;
     ic:=0; sm:=0;
     for x:=1 to anglist.count do
     begin
          angprop:=anglist.items[x-1];
          yc:=strtofloat(depth.text)/2;
          edc:=strtofloat(depth.text)-angprop^.y*2;
          ic:=4*angprop^.ix+sqr(edc)*sqr(2*angprop^.area)/(4*angprop^.area);
          sm:=ic/yc;
          if (ic>=reqmi) and (sm>=reqsm) then
             break;
     end;
     smtext.caption:=format('%0.4n',[sm]);
     mitext.caption:=format('%0.4n',[ic]);
     section.caption:=angprop^.section;
     except
     smtext.caption:='';
     mitext.caption:='';
     section.caption:='';
     end;

end;

procedure TTCExtenForm.ConcGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (key=46) and (llist.count>0) then
     begin
          loadd:=LList.items[concgrid.row-1];
          dispose(loadd);
          llist.delete(concgrid.row-1);
          llist.pack;
          fillconc;
     end;
     if key=45 then
        insertload;
     calcext;
end;

procedure TTCExtenForm.FormShow(Sender: TObject);
begin
     llist:=tlist.create; llist.clear;
     fillconc;
end;

procedure TTCExtenForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   b:integer;
begin
     if llist.count>0 then
     begin
          for b:=0 to (llist.count-1) do
          begin
               loadd:=lList.items[b];
               dispose(loadd);
          end;
          lList.clear;
     end;
     llist.free;
end;

procedure TTCExtenForm.valfloat(Sender: TObject);
begin
     try
     tedit(sender).text:=format('%0.2f',[strtofloat(tedit(sender).text)]);
     except
           tedit(sender).setfocus;
           raise exception.create('Invalid input');
     end;
     calcext;
end;

procedure TTCExtenForm.valdectoing(Sender: TObject);
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

procedure TTCExtenForm.SuppCheckClick(Sender: TObject);
begin
     calcext;
end;

end.
