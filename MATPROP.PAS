unit Matprop;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TMatPropForm = class(TForm)
    Panel1: TPanel;
    MaterialTab: TTabControl;
    PropGrid: TStringGrid;
    Panel2: TPanel;
    CancelBtn: TBitBtn;
    OKBtn: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure PropGridDrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure MaterialTabChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MatPropForm: TMatPropForm;

implementation

uses main;

{$R *.DFM}

procedure TMatPropForm.FormShow(Sender: TObject);
begin
     MaterialTabChange(Sender);
end;

procedure TMatPropForm.PropGridDrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
begin
     if col>1 then
     with PropGrid.Canvas do
     begin
       SetTextAlign(Handle, TA_RIGHT);
       FillRect(Rect);
       TextRect(Rect, Rect.RIGHT - 2, Rect.Top + 2, PropGrid.Cells[Col, Row]);
       SetTextAlign(Handle, TA_LEFT);
     end;
end;

procedure TMatPropForm.MaterialTabChange(Sender: TObject);
var
   x:integer;
begin
     case materialtab.tabindex of
     0:begin
     propgrid.rowcount:=anglist.count+1;
     if dept=0 then
        propgrid.colcount:=12
     else
         propgrid.colcount:=11;
     propgrid.ColWidths[0]:=32;
     propgrid.ColWidths[1]:=105;
     propgrid.cells[0,0]:='Sect';
     propgrid.cells[1,0]:='Description';
     propgrid.cells[2,0]:='Area';
     propgrid.cells[3,0]:='Weight';
     propgrid.cells[4,0]:='Rx';
     propgrid.cells[5,0]:='Rz';
     propgrid.cells[6,0]:='Y';
     propgrid.cells[7,0]:='X';
     propgrid.cells[8,0]:='Ix';
     propgrid.cells[9,0]:='Iy';
     propgrid.cells[10,0]:='Q';
     if dept=0 then
        propgrid.cells[11,0]:='Cost/Ton';
     for x:=1 to anglist.count do
     begin
          angprop:=anglist.items[x-1];
          propgrid.cells[0,x]:=angprop^.section;
          propgrid.cells[1,x]:=angprop^.description;
          propgrid.cells[2,x]:=format('%6.4f',[angprop^.area]);
          propgrid.cells[3,x]:=format('%6.4f',[489.75/144*angprop^.area]);
          propgrid.cells[4,x]:=format('%6.4f',[angprop^.Rx]);
          propgrid.cells[5,x]:=format('%6.4f',[angprop^.Rz]);
          propgrid.cells[6,x]:=format('%6.4f',[angprop^.y]);
          propgrid.cells[7,x]:=format('%6.4f',[angprop^.x]);
          propgrid.cells[8,x]:=format('%6.4f',[angprop^.ix]);
          propgrid.cells[9,x]:=format('%6.4f',[angprop^.iy]);
          propgrid.cells[10,x]:=format('%6.4f',[angprop^.q]);
          if dept=0 then
             propgrid.cells[11,x]:=format('%0.2m',[angprop^.cost]);
     end;
     end;
     1:begin
     propgrid.rowcount:=rndlist.count+1;
     if dept=0 then
        propgrid.colcount:=8
     else
         propgrid.colcount:=7;
     propgrid.ColWidths[0]:=32;
     propgrid.ColWidths[1]:=105;
     propgrid.cells[0,0]:='Sect';
     propgrid.cells[1,0]:='Description';
     propgrid.cells[2,0]:='Diam';
     propgrid.cells[3,0]:='Area';
     propgrid.cells[4,0]:='Weight';
     propgrid.cells[5,0]:='R (in)';
     propgrid.cells[6,0]:='M of I';
     if dept=0 then
        propgrid.cells[7,0]:='Cost/Ton';
     for x:=1 to rndlist.count do
     begin
          rndprop:=rndlist.items[x-1];
          propgrid.cells[0,x]:=rndprop^.section;
          propgrid.cells[1,x]:=rndprop^.description;
          propgrid.cells[2,x]:=format('%6.4f',[rndprop^.d]);
          propgrid.cells[3,x]:=format('%6.4f',[rndprop^.area]);
          propgrid.cells[4,x]:=format('%6.4f',[rndprop^.weight]);
          propgrid.cells[5,x]:=format('%6.4f',[rndprop^.R]);
          propgrid.cells[6,x]:=format('%6.4f',[rndprop^.I]);
          if dept=0 then
             propgrid.cells[7,x]:=format('%0.2m',[rndprop^.cost]);
     end;
     end;
     end;
end;

end.
