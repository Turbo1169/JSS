unit Sprink;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, Buttons, ExtCtrls;

type
  TSprinkForm = class(TForm)
    Panel2: TPanel;
    OKBtn: TBitBtn;
    Notebook1: TNotebook;
    StringGrid1: TStringGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    AddBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure AddBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure valdectoing(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SprinkForm: TSprinkForm;

implementation

uses
    main;

{$R *.DFM}

function dectoing(decn:single):shortstring; external 'comlib.dll';
function ingtodec(ing:shortstring):single; external 'comlib.dll';

procedure fillgrid;
var
   x:integer;
begin
     with sprinkform.stringgrid1 do
     begin
          for x:=1 to sprinklist.count do
          begin
               Sprinkler:=SprinkList.items[x-1];
               cells[0,x]:=dectoing(sprinkler^.x);
               cells[1,x]:=dectoing(sprinkler^.y);
               cells[2,x]:=format('%0.2f',[sprinkler^.d]);
          end;

          if sprinklist.count>0 then
             rowcount:=sprinklist.count+1
          else
          begin
              rowcount:=2;
              cells[0,1]:='';
              cells[1,1]:='';
              cells[2,1]:='';
          end;
          fixedrows:=1;
     end;
end;

procedure TSprinkForm.FormShow(Sender: TObject);
begin
     stringgrid1.cells[0,0]:='Dist LE';
     stringgrid1.cells[1,0]:='Dist TC';
     stringgrid1.cells[2,0]:='Diameter';
     fillgrid;
     stringgrid1.setfocus;
end;

procedure TSprinkForm.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (key=46) and (sprinklist.count>0) then
     begin
          Sprinkler:=SprinkList.items[stringgrid1.row-1];
          dispose(sprinkler);
          Sprinklist.delete(stringgrid1.row-1);
          sprinklist.pack;
          fillgrid;
     end;
     if key=45 then
     begin
          AddBtnClick(Sender);
     end;
end;

procedure TSprinkForm.AddBtnClick(Sender: TObject);
begin
     if notebook1.pageindex=0 then
     begin
          okbtn.cancel:=false;
          okbtn.modalresult:=mrnone;
          addbtn.cancel:=true;
          addbtn.caption:='Cancel';
          notebook1.pageindex:=1;
          edit1.setfocus;
     end
     else
     begin
          okbtn.cancel:=true;
          okbtn.modalresult:=mrOk;
          addbtn.cancel:=false;
          addbtn.caption:='Add';
          notebook1.pageindex:=0;
          stringgrid1.setfocus;
     end;
end;

procedure TSprinkForm.FormCreate(Sender: TObject);
begin
     notebook1.pageindex:=0;
end;

procedure TSprinkForm.OKBtnClick(Sender: TObject);
begin
     if notebook1.pageindex=1 then
     begin
          New(Sprinkler);
          SprinkList.add(Sprinkler);
          Sprinkler^.x:=ingtodec(edit1.text);
          Sprinkler^.y:=ingtodec(edit2.text);
          Sprinkler^.d:=strtofloat(edit3.text);
          fillgrid;
          AddBtnClick(Sender);
     end;
end;

procedure TSprinkForm.valdectoing(Sender: TObject);
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

procedure TSprinkForm.Edit3Exit(Sender: TObject);
begin
     try
     if edit3.text='' then edit3.text:='0';
     edit3.text:=format('%0.2f',[strtofloat(edit3.text)]);
     except
           edit3.setfocus;
           raise exception.create('Invalid input');
     end;
end;

end.
