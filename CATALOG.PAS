unit Catalog;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids, DB, DBTables, ComCtrls;

type
  TCatalogForm = class(TForm)
    Panel1: TPanel;
    OKBtn: TBitBtn;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    StringGrid1: TStringGrid;
    TabSheet2: TTabSheet;
    StringGrid2: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CatalogForm: TCatalogForm;

implementation

uses Main;

{$R *.DFM}

procedure TCatalogForm.FormShow(Sender: TObject);
var
   temp:string;
   cnum,rnum,cnum2:integer;
   x,y:integer;
   K_Start,LH_Start:integer;
begin
     MainForm.SJICatlg.indexfieldnames:='Type;Index;Span';
     MainForm.SJICatlg.first;
     cnum:=1;
     stringgrid1.cells[0,0]:='Span';
     cnum2:=1;
     stringgrid2.cells[0,0]:='Span';
     K_Start:=0;
     LH_Start:=0;
     while not MainForm.SJICatlg.eof do
     begin
          if MainForm.SJICatlgtype.value='K' then
          begin
               if K_Start=0 then
                  K_Start:=MainForm.SJICatlgspan.value-1; //smallest span (row start)
               stringgrid1.colcount:=stringgrid1.colcount+1;
               temp:=inttostr(MainForm.SJICatlgindex.value);
               stringgrid1.cells[cnum,0]:=copy(temp,1,length(temp)-2)+'K'+
                 inttostr(strtoint(copy(temp,length(temp)-1,2)));
               while (temp=inttostr(MainForm.SJICatlgindex.value)) and (not MainForm.SJICatlg.eof) do
               begin
                    rnum:=MainForm.SJICatlgspan.value-K_Start;
                    stringgrid1.cells[cnum,rnum]:=MainForm.SJICatlgtotalload.asstring+'/'+MainForm.SJICatlgliveload.asstring;
                    {if MainForm.SJICatlgXBRequired.Value=1 then
                        stringgrid1.cells[cnum,rnum]:='*'+stringgrid1.cells[cnum,rnum];}
                    stringgrid1.cells[0,rnum]:=MainForm.SJICatlgspan.asstring;
                    MainForm.SJICatlg.next;
               end;
               inc(cnum);
          end
          else
          begin
               if LH_Start=0 then
                  LH_Start:=MainForm.SJICatlgspan.value-1; //smallest span (row start)
               stringgrid2.colcount:=stringgrid2.colcount+1;
               temp:=inttostr(MainForm.SJICatlgindex.value);
               if strtoint(copy(temp,1,length(temp)-2))<52 then
                  stringgrid2.cells[cnum2,0]:=copy(temp,1,length(temp)-2)+'LH'+copy(temp,length(temp)-1,2)
               else
                  stringgrid2.cells[cnum2,0]:=copy(temp,1,length(temp)-2)+'DLH'+copy(temp,length(temp)-1,2);
               while (temp=inttostr(MainForm.SJICatlgindex.value)) and (not MainForm.SJICatlg.eof) do
               begin
                    rnum:=MainForm.SJICatlgspan.value-LH_Start;
                    stringgrid2.cells[cnum2,rnum]:=MainForm.SJICatlgtotalload.asstring+'/'+MainForm.SJICatlgliveload.asstring;
                    {if MainForm.SJICatlgXBRequired.Value=1 then
                        stringgrid2.cells[cnum2,rnum]:='*'+stringgrid2.cells[cnum2,rnum];
                    if MainForm.SJICatlgXBRequired.Value=2 then
                        stringgrid2.cells[cnum2,rnum]:='**'+stringgrid2.cells[cnum2,rnum];}
                    stringgrid2.cells[0,rnum]:=MainForm.SJICatlgspan.asstring;
                    MainForm.SJICatlg.next;
               end;
               inc(cnum2);
          end;
     end;
     stringgrid1.fixedcols:=1;
     StringGrid1.ColWidths[0]:=40;
     stringgrid2.fixedcols:=1;
     stringgrid2.ColWidths[0]:=40;
     MainForm.SJICatlg.indexfieldnames:='Type;Span;Index';
     rnum:=1;
     while rnum<StringGrid2.RowCount do
     begin
        if stringgrid2.cells[0,rnum]='' then
        begin
                for y := rnum+1 to StringGrid2.RowCount do
                begin
                        for x := 0 to StringGrid2.ColCount do
                        begin
                                stringgrid2.cells[x,y-1]:=stringgrid2.cells[x,y];
                        end;
                end;
                StringGrid2.RowCount:=StringGrid2.RowCount-1;
        end
        else
                inc(rnum);
     end;
end;

procedure TCatalogForm.StringGrid2DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  prevhighlightcolor:integer;
begin
        with (Sender as TStringGrid).Canvas do
        begin
            prevhighlightcolor:=Brush.Color;
            Brush.Style:=bsSolid;
            if (acol=0) and (arow>0) then
            begin
                SetTextAlign(Handle, TA_CENTER);
                FillRect(Rect);
                TextRect(Rect,TRUNC((Rect.RIGHT-RECT.LEFT)/2), Rect.Top + 2, (Sender as TStringGrid).Cells[aCol, aRow]);
                SetTextAlign(Handle, TA_LEFT);
            end;
            if copy((Sender as TStringGrid).cells[acol,arow],1,2)='**' then
            begin
                    font.color:=clblue;
                    if State <> [] then
                      Brush.Color:=prevhighlightcolor;
                    fillrect(rect);
                    textout(rect.left+2,rect.top+1,copy((Sender as TStringGrid).cells[acol,arow],3,length((Sender as TStringGrid).cells[acol,arow])-2));
            end
            else
            if copy((Sender as TStringGrid).cells[acol,arow],1,1)='*' then
            begin
                    font.color:=clred;
                    if State <> [] then
                      Brush.Color:=prevhighlightcolor;
                    fillrect(rect);
                    textout(rect.left+2,rect.top+1,copy((Sender as TStringGrid).cells[acol,arow],2,length((Sender as TStringGrid).cells[acol,arow])-1));
            end;
        end;
end;

end.
