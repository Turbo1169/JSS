unit Fixes;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, math,
  Forms, Dialogs, Grids, StdCtrls, Buttons, analysis, websel, entry2;

type
  PMatData=^TMatData;
  TMatData=Record
    Material:char;
    Section:string[2];
    Fy:single;
  end;
  TFixesForm = class(TForm)
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    TCCombo: TComboBox;
    Label3: TLabel;
    BCCombo: TComboBox;
    GroupBox2: TGroupBox;
    FixesGrid: TStringGrid;
    PlateCheck: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FixesGridDblClick(Sender: TObject);
    procedure FixesGridDrawCell(Sender: TObject; Col, Row: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure PlateCheckClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   FixesForm: TFixesForm;
   MatData:PMatData;
   Matdlist:tlist;

implementation

{$R *.DFM}

uses main;

function rndprec(decn:single):single; external 'comlib.dll';

procedure fillsect;
var
   x:integer;
begin
     fixesform.tccombo.clear; fixesform.bccombo.clear;
     for x:=0 to anglist.count-1 do
     begin
          angprop:=anglist.items[x];
          fixesform.tccombo.items.add(angprop^.section+' = '+angprop^.description);
          if angprop^.section=tcsection.section then
             fixesform.tccombo.itemindex:=x;
          fixesform.bccombo.items.add(angprop^.section+' = '+angprop^.description);
          if angprop^.section=bcsection.section then
             fixesform.bccombo.itemindex:=x;
     end;
end;

procedure FreshWebs;
var
   c,x:integer;
   l:single;
begin
     with fixesform,mainform do
     begin
     FixesGrid.rowcount:=2;
     fixesgrid.colcount:=4;
     fixesgrid.ColWidths[0]:=36;
     fixesgrid.ColWidths[1]:=32;
     fixesgrid.cells[0,0]:='';
     fixesgrid.cells[1,0]:='Qty';
     fixesgrid.cells[2,0]:='Material';
     fixesgrid.cells[3,0]:='Length';
     c:=0;
     for x:=1 to MemberList.count do
     begin
          membdata:=MemberList.items[x-1];
          if (copy(membdata^.position,1,1)='W') or (copy(membdata^.position,1,1)='V') then
          begin
               New(matData);
               l:=membdata^.length;

               {if (membdata^.angle>0) and ((jtype='K') or (jtype='C')) then
               begin
                  mainform.findangle(TCsection.section);
                  l:=l-((angprop^.d-angprop^.Y)/sin(membdata^.angle));
                  mainform.findangle(BCsection.section);
                  l:=l-((angprop^.d-angprop^.Y)/sin(membdata^.angle));
               end;}
               
               matdata^.material:=membdata^.material;
               if PlateCheck.Checked then
                  matdata^.section:=''
               else
                   matdata^.section:=membdata^.section;
               matdata^.Fy:=Fy;
               MatdList.add(matData);
               inc(c);
               if copy(membdata^.position,1,1)='W' then
               begin
                    if x>middle then
                       fixesgrid.cells[0,c]:=membdata^.position+'R'
                    else
                        fixesgrid.cells[0,c]:=membdata^.position+'L';
               end
               else
                   fixesgrid.cells[0,c]:=' '+membdata^.position;
               case membdata^.material of
               'D':fixesgrid.cells[1,c]:='2';
               else
                   fixesgrid.cells[1,c]:='1';
               end;
               if matdata^.section='' then
                  fixesgrid.cells[2,c]:='Use Optimal Material'
               else
               begin
                    if membdata^.material='R' then
                    begin
                         mainform.findrnd(membdata^.section);
                         fixesgrid.cells[2,c]:=rndprop^.section+' = '+rndprop^.description;
                    end
                    else
                    begin
                         mainform.findangle(membdata^.section);
                         fixesgrid.cells[2,c]:=angprop^.section+' = '+angprop^.description;
                    end;
               end;
               fixesgrid.cells[3,c]:=format('%0.2f',[l]);
          end;
     end;
     FixesGrid.rowcount:=c+1;
     fixesgrid.ColWidths[2]:=fixesgrid.clientwidth-136;
     end;
end;

procedure TFixesForm.FormShow(Sender: TObject);
begin
     MatdList:=TList.Create; MatdList.clear;
     fillsect;
     freshwebs;
end;

procedure fixwebs;
var
   opt,found:boolean;
   gap2:single;
   lc,c,mc,x:integer;
   mat:string;
begin
     c:=0;
     for x:=1 to memberlist.count do
     begin
          membdata:=memberlist.items[x-1];
          if (copy(membdata^.position,1,1)='W') or (copy(membdata^.position,1,1)='V') then
          begin
               matdata:=matdlist.items[c];
               if fixesform.platecheck.checked then
               begin
                    matdata^.section:='';
                    if checkplate(membdata^.joint1,membdata^.joint2,x) then
                    begin
                         matdata^.Material:='D';
                    end;
               end;
               membdata^.material:=matdata^.material;
               membdata^.section:=matdata^.section;
               inc(c);
               mat:=membdata^.material;

               found:=false;

               mainform.findangle(BCSection.section);
               gap2:=gap+angprop^.t*2;
               mc:=0;
               opt:=false;
               lc:=0;
               if membdata^.section='' then
               begin
                    opt:=true;
                    if (mat='A') or (mat='D') then
                       lc:=anglist.count-1
                    else
                    begin
                         lc:=Rndlist.count-1;
                         if gap=1 then
                         begin
                              Rndprop:=Rndlist.items[mc];
                              while rndprop^.section<>'RH' do {mimimum round in 1" gap}
                              begin
                                   inc(mc);
                                   Rndprop:=Rndlist.items[mc];
                              end;
                         end;
                    end;
               end;
               while (mc<=lc) and (not found) do
               begin
                    if (mat='A') or (mat='D') then
                    begin
                         if opt then
                         begin
                              angprop:=anglist.items[mc];
                              while angprop^.plate>0 do
                              begin
                                   inc(mc);
                                   angprop:=anglist.items[mc];
                              end;
                              membdata^.section:=angprop^.section;
                         end
                         else
                             mainform.findangle(membdata^.section);
                    end
                    else
                    begin
                         if opt then
                         begin
                              Rndprop:=Rndlist.items[mc];
                              membdata^.section:=rndprop^.section;
                         end
                         else
                             mainform.findrnd(membdata^.section);
                    end;

                    found:=checkweb(gap2);

                    if not found then
                       inc(mc);
                    if not opt then
                    begin
                         if not found then
                         begin
                              membdata^.overst:=1;
                              found:=true;
                         end;
                    end;
               end;
          end
          else
          begin
               if membdata^.position='BC' then
                    membdata^.section:=BCSection.section
               else
                   membdata^.section:=TCSection.section;
          end;
     end;
end;

procedure TFixesForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
   ib,ab,tcy:single;
   b:integer;
begin
     if modalresult=mrOk then
     begin
          angprop:=anglist.items[tccombo.itemindex];
          tcy:=angprop^.y;
          angprop:=anglist.items[bccombo.itemindex];
          ed:=depth-tcy-angprop^.y;
          dogeometry;
          solvesyst;
          if jtype='C' then
             bending:=0
          else
          begin
               if jtype in jtype2 then
                  bending:=load+mainform.joistsTCUniformLoad.value
               else
                  bending:=mainform.joistsTCUniformLoad.value;

               if LRFD then
                  bending:=bending*1.5;
          end;
          angprop:=anglist.items[FixesForm.bccombo.itemindex];
          BCSection.section:=angprop^.section;
          plate:=0;
          if angprop^.plate>0 then
          begin
               plate:=angprop^.plate;
               mainform.findangle(angprop^.prevmat);
               checkBC;
               mainform.findangle(BCSection.Section);
               plate:=0;
               checkBC(True);
          end
          else
            checkbc;

          bcsection.tenst:=bcsection.tenst*fb;

          realed:=depth-angprop^.y;
          ib:=angprop^.ix; ab:=angprop^.area*2;
          getbrgsup;
          angprop:=anglist.items[FixesForm.tccombo.itemindex];
          TCSection.section:=angprop^.section;
          if angprop^.plate>0 then
          begin
               plate:=angprop^.plate;
               mainform.findangle(angprop^.prevmat);
               checkTC;
               mainform.findangle(TCSection.Section);
               plate:=0;
               checkTC(True);
          end
          else
            checktc;
          if jtype in jtype1 then
          begin
                   mainform.label54.Caption:=format('%0.2n',[bearingcap*1000]);
                   mainform.label53.Visible:=true;
                   mainform.label54.Visible:=true;
          end
          else
          begin
                   mainform.label53.Visible:=false;
                   mainform.label54.Visible:=false;
          end;

          if stseam and (jtype in jtype2) then
             latsup:=findlen(tcsection.ryy,tcsection.maxforce,angprop^.area*2,angprop^.q,12000)
          else
          begin
               //from sji 43rd edition
               latsup:=MinValue([170, 124+0.67*depth+28*(depth/bl*12)])*TCSection.Ryy;
               {if jtype='K' then
                  latsup:=TCSection.Ryy*145
               else
                   latsup:=TCSection.Ryy*170;}

          end;
          tcsection.tenst:=tcsection.tenst*fb;

          realed:=ed;
          momi:=angprop^.ix+ib+sqr(ed)*(angprop^.area*2)*ab/(angprop^.area*2+ab);
          ll360:=momi/(26.767*intpower(wl/12,3)*1e-6);
          ll240:=ll360*1.5;
          if mainform.joistslldeflection.value>1 then
             ll360:=ll360*(360/mainform.joistslldeflection.value);
          if mainform.joiststldeflection.value>1 then
          begin
               if mainform.joistslldeflection.value>1 then
                  ll240:=ll360*(mainform.joistslldeflection.value/mainform.joiststldeflection.value)
               else
                   ll240:=ll360*(360/mainform.joiststldeflection.value)
          end;
          fixwebs;
     end;
     for b:=0 to (MatdList.count-1) do
     begin
          matdata:=MatdList.items[b];
          dispose(matdata);
     end;
     MatdList.clear; MatdList.free;
end;

procedure TFixesForm.FixesGridDblClick(Sender: TObject);
var
   x,c:integer;
begin
     if PlateCheck.Checked then
        exit;
     x:=0; c:=0;
     repeat
           membdata:=MemberList.items[x];
           if (copy(membdata^.position,1,1)='W') or (copy(membdata^.position,1,1)='V') then
              inc(c);
           inc(x);
     until c=fixesgrid.row;
     matdata:=matdlist.items[c-1];
     webselform:=twebselform.create(application);
     webselform.showmodal;
     if webselform.modalresult=mrOK then
     begin
          case matdata^.material of
          'D':fixesgrid.cells[1,c]:='2';
          else
              fixesgrid.cells[1,c]:='1';
          end;
          if matdata^.section='' then
             fixesgrid.cells[2,c]:='Use Optimal Material'
          else
          begin
               if matdata^.material='R' then
               begin
                    mainform.findrnd(matdata^.section);
                    fixesgrid.cells[2,c]:=rndprop^.section+' = '+rndprop^.description;
               end
               else
               begin
                    mainform.findangle(matdata^.section);
                    fixesgrid.cells[2,c]:=angprop^.section+' = '+angprop^.description;
               end;
          end;
     end;
     webselform.free;
end;

procedure TFixesForm.FixesGridDrawCell(Sender: TObject; Col, Row: Integer;
  Rect: TRect; State: TGridDrawState);
begin
    if col>2 then
    with fixesgrid.Canvas do
    begin
      SetTextAlign(Handle, TA_RIGHT);
      FillRect(Rect);
      TextRect(Rect, Rect.RIGHT - 2, Rect.Top + 2, fixesgrid.Cells[Col, Row]);
      SetTextAlign(Handle, TA_LEFT);
    end;
end;

procedure TFixesForm.PlateCheckClick(Sender: TObject);
begin
     freshwebs;
end;

end.
