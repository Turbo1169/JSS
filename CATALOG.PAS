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
    procedure StringGrid1DrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
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
begin
     mainform.sjicatlg.Filtered:=false;
     MainForm.SJICatlg.indexfieldnames:='Type;Index;Span';
     mainform.sjicatlg.First;
     cnum:=1;
     stringgrid1.cells[0,0]:='Span';
     cnum2:=1;
     stringgrid2.cells[0,0]:='Span';
     while not mainform.sjicatlg.eof do
     begin
          if mainform.sjicatlgtype.value='K' then
          begin
               stringgrid1.colcount:=stringgrid1.colcount+1;
               temp:=inttostr(mainform.sjicatlgindex.value);
               stringgrid1.cells[cnum,0]:=copy(temp,1,length(temp)-2)+'K'+
                 inttostr(strtoint(copy(temp,length(temp)-1,2)));
               while (temp=inttostr(mainform.sjicatlgindex.value)) and (not mainform.sjicatlg.eof) do
               begin
                    rnum:=mainform.sjicatlgspan.value-7;
                    stringgrid1.cells[cnum,rnum]:=mainform.sjicatlgtotalload.asstring+'/'+mainform.sjicatlgliveload.asstring;
                    stringgrid1.cells[0,rnum]:=mainform.sjicatlgspan.asstring;
                    mainform.sjicatlg.next;
               end;
               inc(cnum);
          end
          else
          begin
               stringgrid2.colcount:=stringgrid2.colcount+1;
               temp:=inttostr(mainform.sjicatlgindex.value);
               if strtoint(copy(temp,1,length(temp)-2))<52 then
                stringgrid2.cells[cnum2,0]:=copy(temp,1,length(temp)-2)+'LH'+copy(temp,length(temp)-1,2)
               else
                stringgrid2.cells[cnum2,0]:=copy(temp,1,length(temp)-2)+'DLH'+copy(temp,length(temp)-1,2);
               while (temp=inttostr(mainform.sjicatlgindex.value)) and (not mainform.sjicatlg.eof) do
               begin
                    rnum:=mainform.sjicatlgspan.value-20;
                    stringgrid2.cells[cnum2,rnum]:=mainform.sjicatlgtotalload.asstring+'/'+mainform.sjicatlgliveload.asstring;
                    stringgrid2.cells[0,rnum]:=mainform.sjicatlgspan.asstring;
                    mainform.sjicatlg.next;
               end;
               inc(cnum2);
          end;
     end;
     stringgrid1.fixedcols:=1;
     StringGrid1.ColWidths[0]:=40;
     stringgrid2.fixedcols:=1;
     stringgrid2.ColWidths[0]:=40;
end;

procedure TCatalogForm.StringGrid1DrawCell(Sender: TObject; Col,
  Row: Longint; Rect: TRect; State: TGridDrawState);
begin
        if col=0 then
        with StringGrid1.Canvas do
        begin
                SetTextAlign(Handle, TA_CENTER);
                FillRect(Rect);
                TextRect(Rect,TRUNC((Rect.RIGHT-RECT.LEFT)/2), Rect.Top + 2, StringGrid1.Cells[Col, Row]);
                SetTextAlign(Handle, TA_LEFT);
        end;
     {stringgrid1.canvas.font.color:=clred;
     stringgrid1.canvas.fillrect(rect);
     stringgrid1.canvas.textout(rect.left+2,rect.top+1,stringgrid1.cells[col,row]);}
end;

procedure TCatalogForm.StringGrid2DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
        if acol=0 then
        with StringGrid2.Canvas do
        begin
                SetTextAlign(Handle, TA_CENTER);
                FillRect(Rect);
                TextRect(Rect,TRUNC((Rect.RIGHT-RECT.LEFT)/2), Rect.Top + 2, StringGrid2.Cells[aCol, aRow]);
                SetTextAlign(Handle, TA_LEFT);
        end;
end;

end.
