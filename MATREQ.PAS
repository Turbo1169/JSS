unit Matreq;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, StdCtrls, Buttons, Db, DBTables, ComCtrls;

type
  woodt=record
    size,feet:single;
  end;
  TMatReqForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Button1: TButton;
    Table1: TTable;
    Table1JobNumber: TStringField;
    Table1Page: TSmallintField;
    Table1Description: TStringField;
    Table2: TTable;
    DataSource1: TDataSource;
    Table2JobNumber: TStringField;
    Table2Page: TSmallintField;
    Table2Section: TStringField;
    Table2Tons: TFloatField;
    PageControl1: TPageControl;
    Steel: TTabSheet;
    Wood: TTabSheet;
    PropGrid: TStringGrid;
    Label2: TLabel;
    Label1: TLabel;
    WoodGrid: TStringGrid;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure PropGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WoodGridDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    procedure Sort(var A: array of woodt);
  public
    { Public declarations }
  end;

var
  MatReqForm: TMatReqForm;
  wood:array[1..9] of woodt;
  wt:integer;

implementation

{$R *.DFM}

uses main;

procedure totalsections;
var
   x,y:integer;
   tchord:string;
   cgap:single;
   wtexists:boolean;
begin
     with mainform do
     begin
          for x:=1 to anglist.count do
          begin
               angprop:=anglist.items[x-1];
               angprop^.tons:=0;
          end;
          for x:=1 to rndlist.count do
          begin
               rndprop:=rndlist.items[x-1];
               rndprop^.tons:=0;
          end;
          with mainform.joists do
          begin
               first;
               while not eof do
               begin
                    mainform.recalcjoist;
                    if jtype in jtype2 then
                    begin
                         tchord:=copy(JoistsChords.Value,1,2);
                         if JoistsJoistType.Value='L1' then
                            cgap:=0.5
                         else
                             cgap:=1;
                         findangle(tchord);
                         cgap:=cgap+angprop^.b*2;
                         wtexists:=false;
                         for y:=1 to wt do
                         begin
                              if wood[y].size=cgap then
                              begin
                                   wtexists:=true;
                              end;
                              if wtexists then
                                 break;
                         end;
                         if not wtexists then
                         begin
                              inc(wt);
                              wood[wt].size:=cgap;
                              y:=wt;
                              wood[y].feet:=0;
                         end;
                         wood[y].feet:=wood[y].feet+(bl/12*joistsquantity.value);
                    end;
                    next;
               end;
          end;
          if dept=0 then
          begin
               with mainform.Bridg do
               begin
                    first;
                    while not eof do
                    begin
                         MainForm.findangle(mainform.BridgSection.Value);
                         angprop^.tons:=angprop^.tons+MainForm.BridgWeight.Value;
                         next;
                    end;
               end;
               with mainform.jsubst do
               begin
                    first;
                    while not eof do
                    begin
                         MainForm.findangle(mainform.jsubstSection.Value);
                         angprop^.tons:=angprop^.tons+MainForm.jsubstWeight.Value*MainForm.jsubstQuantity.Value;
                         next;
                    end;
               end;
               MainForm.findangle('20');
               angprop^.tons:=angprop^.tons+MainForm.jobinfoKBpieces.value*5*angprop^.weight;
          end;
     end;
end;

procedure TMatReqForm.Sort(var A: array of woodt);

  procedure QuickSort(var A: array of woodt; iLo, iHi: Integer);
  var
    Lo, Hi: Integer;
    T: woodt;
    Mid: single;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := A[(Lo + Hi) div 2].size;
    repeat
      while A[Lo].size < Mid do Inc(Lo);
      while A[Hi].size > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;

begin
  QuickSort(A, 0, wt-1);
end;

procedure TMatReqForm.FormShow(Sender: TObject);
var
   x,y:integer;
   tot:single;
   crecord:TBookmark;
begin
     wt:=0;
     with mainform do
     begin
          crecord:=joists.GetBookmark;
          totalsections;
          joists.gotobookmark(crecord);
          joists.freebookmark(crecord);
     end;
     propgrid.rowcount:=anglist.count+rndlist.count+1;
     propgrid.colcount:=3;
     propgrid.ColWidths[0]:=32;
     propgrid.ColWidths[1]:=105;
     propgrid.cells[0,0]:='Sect';
     propgrid.cells[1,0]:='Description';
     propgrid.cells[2,0]:='Tons';
     y:=0; tot:=0;
     for x:=1 to anglist.count do
     begin
          angprop:=anglist.items[x-1];
          if angprop^.Tons>0 then
          begin
               inc(y);
               propgrid.rowcount:=propgrid.rowcount+1;
               propgrid.cells[0,y]:=angprop^.section;
               propgrid.cells[1,y]:=angprop^.description;
               propgrid.cells[2,y]:=format('%7.2f',[angprop^.Tons/2000]);
               tot:=tot+angprop^.tons/2000;
          end;
     end;
     for x:=1 to rndlist.count do
     begin
          rndprop:=rndlist.items[x-1];
          if rndprop^.tons>0 then
          begin
               inc(y);
               propgrid.rowcount:=propgrid.rowcount+1;
               propgrid.cells[0,y]:=rndprop^.section;
               propgrid.cells[1,y]:=rndprop^.description;
               propgrid.cells[2,y]:=format('%7.2f',[rndprop^.Tons/2000]);
               tot:=tot+rndprop^.tons/2000;
          end;
     end;
     if y>0 then
        propgrid.rowcount:=y+1
     else
         propgrid.rowcount:=2;
     label1.caption:=format('%7.2f',[tot]);
     propgrid.ColWidths[1]:=propgrid.clientwidth-98;
     if wt=0 then
        woodgrid.rowcount:=2
     else
         woodgrid.rowcount:=wt+1;
     woodgrid.colcount:=2;
     woodgrid.ColWidths[1]:=64;
     woodgrid.cells[0,0]:='Size';
     woodgrid.cells[1,0]:='Linear Feet';
     tot:=0;
     if wt>0 then
     begin
          sort(matreq.wood);
          for x:=1 to wt do
          begin
               tot:=tot+matreq.wood[x].feet;
               woodgrid.cells[0,x]:=floattostr(matreq.wood[x].size)+'" Wood';
               woodgrid.cells[1,x]:=format('%7.2f',[matreq.wood[x].feet]);
          end;
     end;
     label4.caption:=format('%7.2f',[tot]);
     woodgrid.ColWidths[0]:=woodgrid.clientwidth-66;
end;

procedure TMatReqForm.PropGridDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
begin
     if (col=2) and (row>0) then
     with PropGrid.Canvas do
     begin
       Brush.Style := bsSolid;
       if State = [] then
       begin
         Font.Color:=clWindowText;
         Brush.Color:=clWindow;
       end
       else
       begin
         Font.Color := clHighlightText;
         Brush.Color:=clHighlight;
       end;
       SetTextAlign(Handle, TA_RIGHT);
       TextRect(Rect, Rect.RIGHT - 2, Rect.Top + 2, PropGrid.Cells[Col, Row]);
       SetTextAlign(Handle, TA_LEFT);
     end;
end;

procedure TMatReqForm.Button1Click(Sender: TObject);
var
   x:integer;
begin
     table1.open;
     table2.open;
     table1.insert;
     Table1JobNumber.value:=MainForm.SequenceJobNumber.value;
     Table1Page.value:=MainForm.SequencePage.value;
     Table1Description.value:=MainForm.SequenceDescription.Value;
     table1.post;
     for x:=1 to anglist.count do
     begin
          angprop:=anglist.items[x-1];
          if angprop^.Tons>0 then
          begin
               table2.insert;
               Table2Section.value:=angprop^.section;
               Table2Tons.Value:=angprop^.Tons/2000;
               table2.post;
          end;
     end;
     for x:=1 to rndlist.count do
     begin
          rndprop:=rndlist.items[x-1];
          if rndprop^.tons>0 then
          begin
               table2.insert;
               Table2Section.value:=rndprop^.section;
               Table2Tons.Value:=rndprop^.Tons/2000;
               table2.post;
          end;
     end;
     table2.close;
     table1.close;
end;

procedure TMatReqForm.FormCreate(Sender: TObject);
begin
     if dept=0 then
        Button1.Visible:=false;
end;

procedure TMatReqForm.WoodGridDrawCell(Sender: TObject; Col,
  Row: Integer; Rect: TRect; State: TGridDrawState);
begin
     if (col=1) and (row>0) then
     with woodgrid.Canvas do
     begin
       Brush.Style := bsSolid;
       if State = [] then
       begin
         Font.Color:=clWindowText;
         Brush.Color:=clWindow;
       end
       else
       begin
         Font.Color := clHighlightText;
         Brush.Color:=clHighlight;
       end;
       SetTextAlign(Handle, TA_RIGHT);
       TextRect(Rect, Rect.RIGHT - 2, Rect.Top + 2, woodgrid.Cells[Col, Row]);
       SetTextAlign(Handle, TA_LEFT);
     end;
end;

end.
