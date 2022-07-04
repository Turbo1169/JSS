unit Entry;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Forms, Dialogs, StdCtrls,
  Buttons, DB, DBTables, Mask, DBCtrls, Grids, DBGrids, ComCtrls, Controls, ExtCtrls;

type
  TEntryForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Joist: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    Label20: TLabel;
    Label4: TLabel;
    Label18: TLabel;
    WorkLength: TLabel;
    DBEdit2: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit22: TDBEdit;
    brgspc: TEdit;
    brgsup: TCheckBox;
    Shape: TDBRadioGroup;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label19: TLabel;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit23: TDBEdit;
    DBComboBox1: TDBComboBox;
    GroupBox6: TGroupBox;
    Label31: TLabel;
    Label37: TLabel;
    PanelGrid: TStringGrid;
    PanelCheck: TCheckBox;
    DBEdit31: TDBEdit;
    DBEdit35: TDBEdit;
    LeftEnd: TGroupBox;
    Label7: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    DBEdit6: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit12: TDBEdit;
    RightEnd: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    DBEdit7: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit13: TDBEdit;
    Concentrated: TGroupBox;
    Label38: TLabel;
    Label5: TLabel;
    Label44: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    DBEdit32: TDBEdit;
    ConcGrid: TStringGrid;
    DBEdit5: TDBEdit;
    DBEdit39: TDBEdit;
    DBEdit25: TDBEdit;
    DBEdit26: TDBEdit;
    UniformLoads: TGroupBox;
    Label6: TLabel;
    Label43: TLabel;
    Label3: TLabel;
    DBEdit4: TDBEdit;
    DBEdit38: TDBEdit;
    DBEdit24: TDBEdit;
    Moments: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    DBEdit27: TDBEdit;
    DBEdit28: TDBEdit;
    GroupBox7: TGroupBox;
    Label24: TLabel;
    Label30: TLabel;
    DBEdit29: TDBEdit;
    DBEdit30: TDBEdit;
    GroupBox4: TGroupBox;
    Label42: TLabel;
    BCCombo: TComboBox;
    GroupBox5: TGroupBox;
    PartGrid: TStringGrid;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox8: TGroupBox;
    Label45: TLabel;
    Label46: TLabel;
    SuppL: TEdit;
    SuppR: TEdit;
    DBText1: TDBText;
    DBText2: TDBText;
    Label41: TLabel;
    TCCombo: TComboBox;
    GroupBox9: TGroupBox;
    Label48: TLabel;
    Label21: TLabel;
    Label39: TLabel;
    DBEdit19: TDBEdit;
    DBComboBox3: TDBComboBox;
    DBEdit3: TDBEdit;
    DBEdit11: TDBEdit;
    GroupBox1: TGroupBox;
    Label34: TLabel;
    Label47: TLabel;
    Label49: TLabel;
    DBEdit10: TDBEdit;
    DBComboBox2: TDBComboBox;
    DBEdit18: TDBEdit;
    DBEdit36: TDBEdit;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label40: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    Label80: TLabel;
    Label81: TLabel;
    Label28: TLabel;
    DBEdit20: TDBEdit;
    Label29: TLabel;
    DBEdit21: TDBEdit;
    Label82: TLabel;
    Label83: TLabel;
    Label35: TLabel;
    DBEdit33: TDBEdit;
    Label36: TLabel;
    DBEdit34: TDBEdit;
    ConsCheck: TDBCheckBox;
    Label86: TLabel;
    TonsLH: TEdit;
    Label84: TLabel;
    DBEdit17: TDBEdit;
    Label85: TLabel;
    Button1: TButton;
    GroupBox3: TGroupBox;
    SpecialGap: TCheckBox;
    GapValue: TEdit;
    Label87: TLabel;
    DBCheckBox1: TDBCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShapeClick(Sender: TObject);
    procedure DBComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure valdectoing(Sender: TObject);
    procedure ConcGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PanelCheckClick(Sender: TObject);
    procedure PanelGridDblClick(Sender: TObject);
    procedure brgsupClick(Sender: TObject);
    procedure brgspcExit(Sender: TObject);
    procedure EntryTabsChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure PartGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure SuppLExit(Sender: TObject);
    procedure SuppRExit(Sender: TObject);
    procedure valdectoinch(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpecialGapClick(Sender: TObject);
    procedure GapValueExit(Sender: TObject);
    procedure ConcGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure newentry;
    procedure modpanel;
    procedure chggeom;
    procedure fillridge;
    procedure fillsect;
    procedure updatejoist;
  end;

var
  EntryForm: TEntryForm;

implementation

uses Main, gpanel, concload, analysis, PanelTC, entry2, partial;

{$R *.DFM}

var
  newj:boolean;
  ctr:integer;

function rndprec(decn:single):single; external 'comlib.dll';
function dectoing(decn:single):shortstring; external 'comlib.dll';
function ingtodec(ing:shortstring):single; external 'comlib.dll';
function dectoinch(decn:single):shortstring; external 'comlib.dll';
function inchtodec(ing:shortstring):single; external 'comlib.dll';

procedure fillconc;
var
   c:integer;
   lastjoint:single;
begin
     with entryform.concgrid do
     begin
          cells[0,0]:='Position (ft)';
          cells[1,0]:='Load (lbs)';
          if conclist.count>0 then
          begin
               jointdata:=jointlist.items[jointlist.count-1];
               lastjoint:=jointdata^.coordx;
               rowcount:=conclist.count+1;
               c:=1;
               repeat
                    concdata:=conclist.items[c-1];
                    if ConcData^.Dist>lastjoint then
                    begin
                         dispose(concdata);
                         conclist.delete(c-1);
                         conclist.pack;
                    end
                    else
                    begin
                         ConcData^.position:=concdata^.chord+' @ '+dectoing(ConcData^.Dist);
                         if concdata^.vcb then
                            ConcData^.position:=ConcData^.position+' vcb';
                         if concdata^.Wind then
                            ConcData^.position:=ConcData^.position+' (+,-)';
                         cells[0,c]:=concdata^.position;
                         cells[1,c]:=format('%0.2n',[concdata^.Force]);
                         inc(c);
                    end;
               until c>conclist.count;
               if conclist.Count=0 then
                  rowcount:=2
               else
                   rowcount:=conclist.count+1;
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

procedure fillpart;
var
   c:integer;
   pos2:single;
begin
     with entryform.partgrid do
     begin
          cells[0,0]:='Position (ft)';
          cells[1,0]:='Load 1 (plf)';
          cells[2,0]:='Load 2 (plf)';
          if partlist.count>0 then
          begin
               rowcount:=partlist.count+1;
               c:=1;
               repeat
                    partdata:=partlist.items[c-1];
                    if (partdata^.Joint1>jointlist.count) or (partdata^.Joint2>jointlist.count) then
                    begin
                         dispose(partdata);
                         partlist.delete(c-1);
                         partlist.pack;
                    end
                    else
                    begin
                         jointdata:=jointlist.items[partdata^.Joint2-1];
                         pos2:=jointdata^.coordX;
                         jointdata:=jointlist.items[partdata^.Joint1-1];
                         PartData^.position:=jointdata^.position+' '+dectoing(jointdata^.coordX)+
                         ' to '+dectoing(pos2);
                         if PartData.uplift then
                                PartData^.position:=PartData^.position+' uplift';
                         cells[0,c]:=partdata^.position;
                         cells[1,c]:=format('%0.2n',[partdata^.Force]);
                         cells[2,c]:=format('%0.2n',[partdata^.Force2]);
                         inc(c)
                    end;
               until c>partlist.count;
               if partlist.Count=0 then
                  rowcount:=2
               else
                   rowcount:=partlist.count+1;
          end
          else
          begin
               cells[0,1]:='';
               cells[1,1]:='';
               cells[2,1]:='';
               rowcount:=2;
          end;
          ColWidths[0]:=clientwidth-130;
     end;
end;

procedure fillpanels;
var
   x:integer;
begin
     with entryform.panelgrid do
     begin
          if (panellist.count>0) and (entryform.panelcheck.checked) then
          begin
               rowcount:=panellist.count+1;
               for x:=1 to panellist.count do
               begin
                    tcpanel:=panellist.items[x-1];
                    cells[0,x]:=inttostr(x);
                    cells[1,x]:=dectoing(tcpanel^.length);
               end;
          end
          else
          begin
               cells[0,1]:='';
               cells[1,1]:='';
               rowcount:=2;
          end;
          ColWidths[1]:=clientwidth-66;
     end;
     if entryform.PageControl1.ActivePage.TabIndex>0 then
        mainform.JoistsFirstDiagLEValidate(mainform.JoistsFirstDiagLE);
end;

procedure TEntryForm.fillsect;
var
   x:integer;
begin
     entryform.tccombo.clear; entryform.bccombo.clear;
     entryform.tccombo.items.add('Use Optimal Material');
     entryform.bccombo.items.add('Use Optimal Material');
     entryform.tccombo.itemindex:=0;
     entryform.bccombo.itemindex:=0;
     for x:=0 to anglist.count-1 do
     begin
          angprop:=anglist.items[x];
          entryform.tccombo.items.add(angprop^.section+' = '+angprop^.description);
          if (mintc<>'') and (angprop^.section=mintc) then
             entryform.tccombo.itemindex:=x+1;
          entryform.bccombo.items.add(angprop^.section+' = '+angprop^.description);
          if (minbc<>'') and (angprop^.section=minbc) then
             entryform.bccombo.itemindex:=x+1;
     end;
end;

procedure TEntryForm.updatejoist;
var
        x:integer;
        d:single;
        tempmark:string;
begin
        with mainform do
        begin
             joistmemo.lines.beginupdate;
             joistmemo.clear;
             if (strtoint(suppl.Text)>1) or (strtoint(suppr.Text)<jointlist.count) then
             begin
                  joistmemo.lines.add('[SUPPORTS]');
                  joistmemo.lines.add(suppl.text);
                  joistmemo.lines.add(suppr.text);
             end;
             if (tccombo.itemindex>0) or (bccombo.itemindex>0) then
             begin
                  joistmemo.lines.add('[CHORDS]');
                  if tccombo.itemindex>0 then
                  begin
                     angprop:=anglist.items[tccombo.itemindex-1];
                     joistmemo.lines.add('TC,'+angprop^.section);
                  end;
                  if bccombo.itemindex>0 then
                  begin
                     angprop:=anglist.items[bccombo.itemindex-1];
                     joistmemo.lines.add('BC,'+angprop^.section);
                  end;
             end;
             if panelcheck.checked then
             begin
                  joistmemo.lines.add('[TCPANELS]');
                  for x:=1 to panellist.count do
                  begin
                       tcpanel:=panellist.items[x-1];
                       joistmemo.lines.add(format('%0.4f',[tcpanel^.length]));
                  end;
             end;
             if specialgap.checked then
             begin
                  joistmemo.lines.add('[GAP]');
                  joistmemo.lines.add(GapValue.text);
             end;
             if brgsup.checked then
             begin
                  joistmemo.lines.add('[BRGSUP]');
                  joistmemo.lines.add(brgspc.text);
             end;
             if partlist.count>0 then
             begin
                  joistmemo.lines.add('[PARTIAL]');
                  for x:=1 to partlist.count do
                  begin
                       partdata:=partlist.items[x-1];
                       joistmemo.lines.add(inttostr(partdata^.joint2)+','+inttostr(partdata^.joint1)+','+
                           format('%0.2f',[partdata^.force])+','+format('%0.2f',[partdata^.force2])+','+
                           inttostr(ord(partdata^.uplift)));
                  end;
             end;
             if conclist.count>0 then
             begin
                  joistmemo.lines.add('[CONCENTRATED]');
                  for x:=1 to conclist.count do
                  begin
                       concdata:=conclist.items[x-1];
                       joistmemo.lines.add(concdata^.chord+','+dectoing(concdata^.dist)+','+format('%0.2f',[concdata^.force])+
                                    ','+inttostr(ord(concdata^.vcb))+','+inttostr(ord(concdata^.wind)));
                  end;
             end
             else
                 joistmemo.lines.add('');
             joistmemo.lines.endupdate;
             joistsrunby.value:=runby;
             getchords;
             dorecalc;
             joistsweight.value:=weight;
             joistsmaterial.value:=material;
             {if radiobutton2.checked then
                joiststime.value:=manhrs
             else}
             begin
                  d:=strtofloat(tonslh.text);
                  if (jtype='K') or (jtype='C') then
                     joiststime.value:=(weight*ssman)/(2000*d)
                  else
                      joiststime.value:=(weight*lsman)/(2000*d);
             end;
             findangle(tcsection.section);
             if angprop^.plate>0 then
                findangle(angprop^.prevmat);
             joistschords.value:=angprop^.Section+'/';
             findangle(bcsection.section);
             if angprop^.plate>0 then
                findangle(angprop^.prevmat);
             joistschords.value:=joistschords.value+angprop^.Section;
             if tcxl.tcxtype<>'S' then
                   joistsseatlengthLE.value:=dectoing(tcxl.length);
             JoistsTCXLTY.Value:=tcxl.tcxtype;
             if tcxr.tcxtype<>'S' then
                   joistsseatlengthRE.value:=dectoing(tcxr.length);
             JoistsTCXRTY.Value:=tcxr.tcxtype;
             joists.post;
             tempmark:=JoistsMark.Value;
             if dept=0 then
             begin
                  jobinfo.edit;
                  jobinfostatus.value:='M';
                  jobinfo.post;
             end
             else
             begin
                 sequence.edit;
                 sequencestatus.value:='M';
                 sequence.post;
             end;
             Joists.Locate('Mark', tempmark, []);
        end;
end;


procedure TEntryForm.fillridge;
var
   x:integer;
   mindif:single;
begin
     x:=0; mindif:=bl;
     dbcombobox1.clear;
     while x<JointList.count do
     begin
          jointdata:=JointList.items[x];
          if jointdata^.position='TC' then
          begin
               dbcombobox1.items.add(dectoing(jointdata^.coordX));
               if abs(bl/2-jointdata^.coordx)<mindif then
               begin
                    ctr:=dbcombobox1.items.count-1;
                    mindif:=abs(bl/2-jointdata^.coordx);
               end;
          end;
          inc(x);
     end;
end;

procedure TEntryForm.newentry;
begin
     newj:=true;
     stseam:=false;
     sppanels:=false;
     worklength.caption:='';
     caption:='New Joist';
     with mainform do
     begin
          joistsquantity.value:=1;
          joistsTCXL.value:=dectoing(0);
          joistsTCXR.value:=dectoing(0);
          joistslldeflection.value:=240;
          joiststldeflection.value:=1;
          joistsconsolidate.Value:=false;
          JoistsTCXLTY.Value:='R';
          JoistsTCXRTY.Value:='R';
          JoistsLRFD.Value:=false;
     end;
     panelcheck.checked:=false;
     panelgrid.enabled:=false;
     shape.enabled:=false;
     getchords;
     if stseam then
     begin
          brgsup.checked:=true;
          brgspc.text:=format('%4.2f',[latsup]);
     end
     else
     begin
          brgsup.checked:=false;
          brgspc.text:='0.00';
     end;
     showmodal;
     shape.enabled:=true;
     newj:=false;
end;

procedure TEntryForm.modpanel;
begin
     with mainform do
     begin
          if joistsshape.value<>'S' then
          begin
               joistsdepthle.value:=depth;
               joistsdepthre.value:=depth;
               joistsRidgeposition.value:=dectoing(bl);
               joistsshape.value:='P';
               joistsscissoradd.value:=0;
               DBComboBox1.Enabled:=false;
          end;
          fillconc;
          fillpart;
          joistsconsolidate.Value:=false;
     end;
     supp1:=1;
     supp2:=jointlist.count;
     suppL.Text:=inttostr(supp1);
     suppR.Text:=inttostr(supp2);
end;

procedure TEntryForm.chggeom;
begin
     try
     newg:=true;
     if jtype in jtype2 then
        mainform.joistsconsolidate.Value:=false;
     if panelcheck.checked then
        panelcheck.checked:=false;
     dogeometry;
     fillridge;
     fillconc;
     fillpart;
     if not shape.enabled then
        shape.enabled:=true;
     if jtype in jtype2 then
        dbedit35.enabled:=true
     else
         dbedit35.enabled:=false;
     worklength.caption:=dectoing(wl);
     suppL.Text:=inttostr(supp1);
     suppR.Text:=inttostr(supp2);
     finally
     newg:=false;
     end;
end;

procedure TEntryForm.FormShow(Sender: TObject);
var
   d:single;
   b:integer;
begin
     if not newj then
     begin
          caption:='Joist Properties';
          worklength.caption:=dectoing(wl);
          if jtype in jtype1 then
           begin
              label63.caption:='lbs';
              Button1.Enabled:=true;
           end
           else
           begin
              label63.caption:='plf';
              Button1.Enabled:=false;
           end;
     end;
     if Shape.ItemIndex>1 then
        DBComboBox1.Enabled:=true;
     if Shape.ItemIndex>0 then
     begin
          dbedit14.enabled:=true;
          dbedit15.enabled:=true;
     end;
     if Shape.ItemIndex=3 then
        dbedit23.enabled:=true;
     suppL.Text:=inttostr(supp1);
     suppR.Text:=inttostr(supp2);
     with mainform do
     begin
          {if (joiststime.value=manhrs) and (not newj) then
             radiobutton2.checked:=true
          else}
          begin
              if newj then
                 d:=0
              else
              begin
              if (jtype='K') or (jtype='C') then
                 d:=(joistsweight.value/2000)/(joiststime.value/ssman)
              else
                  d:=(joistsweight.value/2000)/(joiststime.value/lsman);
              end;
              tonslh.text:=format('%0.2f',[d]);
          end;
     end;
     dbedit2.setfocus;
     fillsect;
     if sppanels then
        panelcheck.checked:=true;

     b:=findextra('GAP');
     if b>0 then
     begin
        SpecialGap.checked:=true;
        gapvalue.text:=joistmemo.Lines[b];
     end;

     if stseam then
     begin
          brgsup.checked:=true;
          brgspc.text:=format('%4.2f',[latsup]);
     end
     else
     begin
          brgsup.checked:=false;
          brgspc.text:='0.00';
     end;
     if jtype in jtype2 then
        dbedit35.enabled:=true
     else
         dbedit35.enabled:=false;
     if MainForm.JoistsLRFD.Value then
        Label3.Caption:='Gross Uplift';
     fillconc;
     fillpart;
end;

procedure insertload;
var
   dist,lv:single;
   vcb,w:boolean;
   chord:string;
begin
     lv:=0;
     dist:=bl/2;
     concloadform:=tconcloadform.create(application);
     concloadform.getload(chord,dist,lv,vcb,w);
     if concloadform.modalresult=mrOK then
     begin
          New(ConcData);
          ConcData^.Chord:=chord;
          ConcData^.Dist:=dist;
          ConcData^.Force:=lv;
          ConcData^.vcb:=vcb;
          concdata^.Wind:=w;
          ConcList.add(concdata);
          fillconc;
     end;
     concloadform.free;
end;

procedure insertpartial;
var
   jn1,jn2:integer;
   lv,lv2:single;
   wind:boolean;
begin
     jn1:=0;
     jn2:=0;
     lv:=0;
     partialform:=tpartialform.create(application);
     partialform.getload(jn1,jn2,lv,lv2,wind);
     if partialform.modalresult=mrOK then
     begin
          New(partdata);
          partdata^.Joint1:=jn1;
          partdata^.Joint2:=jn2;
          partdata^.Force:=lv;
          partdata^.Force2:=lv2;
          partdata^.Uplift:=wind;
          partlist.add(partdata);
          fillpart;
     end;
     partialform.free;
end;

procedure TEntryForm.FormCreate(Sender: TObject);
begin
     PageControl1.ActivePageIndex:=0;   
     newbcl:=false;
     with panelgrid do
     begin
          cells[0,0]:='Panel';
          cells[1,0]:='Length (ft)';
          cells[0,1]:='';
          cells[1,1]:='';
          rowcount:=2;
          ColWidths[1]:=clientwidth-66;
     end;
end;

procedure TEntryForm.ShapeClick(Sender: TObject);
begin
     with mainform do
     begin
          joistsdepthle.value:=depth;
          joistsdepthre.value:=depth;
          joistsRidgeposition.value:=dectoing(bl);
          joistsscissoradd.value:=0;
     end;
     case shape.itemindex of
          0:begin
                 dbedit14.enabled:=false;
                 dbedit15.enabled:=false;
                 dbcombobox1.enabled:=false;
                 dbedit23.enabled:=false;
            end;
          1:begin
                 dbedit14.enabled:=true;
                 dbedit15.enabled:=true;
                 dbcombobox1.enabled:=false;
                 dbedit23.enabled:=false;
                 with mainform do
                 begin
                      joistsdepthle.value:=depth-bl/192;
                      joistsDepthRE.value:=(((depth-JoistsDepthLE.value)/(bl/2))*bl)+JoistsDepthLE.value;
                 end;
            end;
          2:begin
                 dbedit14.enabled:=true;
                 dbedit15.enabled:=true;
                 dbcombobox1.enabled:=true;
                 dbedit23.enabled:=false;
                 mainform.joistsridgeposition.value:=DBComboBox1.Items[ctr];
            end;
          3:begin
                 dbedit14.enabled:=true;
                 dbedit15.enabled:=true;
                 dbedit23.enabled:=true;
                 dbcombobox1.enabled:=true;
                 with mainform do
                 begin
                      joistsscissoradd.value:=depth;
                      joistsridgeposition.value:=DBComboBox1.Items[ctr];
                 end;
            end;
     end;
     if shape.itemindex>0 then
        mainform.joistsconsolidate.Value:=false;
end;

procedure TEntryForm.DBComboBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
     if odSelected in state then
        dbcombobox1.canvas.font.color:=clwhite
     else
          if index=ctr then
             dbcombobox1.canvas.font.color:=clred
          else
              dbcombobox1.canvas.font.color:=clblack;
     dbcombobox1.canvas.fillrect(rect);
     dbcombobox1.canvas.textout(rect.left+2,rect.top+1,dbcombobox1.items[index]);
end;

procedure TEntryForm.FormClose(Sender: TObject; var Action: TCloseAction);
//var
//   d:single;
begin
     if modalresult=mrOk then
     begin
          OKBtn.setfocus;
          if not okbtn.focused then
             abort;
          {d:=depth*24;
          if (jtype='D') or (jtype='L') then
             d:=d+8;}
          //if rndprec(ingtodec(mainform.joistsbaselength.value))>d then
          if rndprec(wl)/depth>24 then
          begin
             if MessageDlg('The joist working length exceeds 24 times its depth', mtWarning, [mbOk, mbCancel], 0)=mrcancel then
                abort;
          end;
          mainform.casecombo.itemindex:=0;
          mainform.casedesc.items.clear;
          mainform.casedesc.items.add('Summary of All Cases');
          if mainform.joistsquantity.value<=0 then
             raise exception.create('Quantity must be greater than 0');
          updatejoist;
     end
     else
     begin
          newg:=false;
          mainform.joists.cancel;
          if (mainform.modulebook.pageindex=2) and (mainform.modulebook.showing) then
          begin
               joistgenerate;
               dorecalc;
               mainform.ListBox1Click(Sender);
          end;
     end;
end;

procedure TEntryForm.valdectoing(Sender:TObject);
var
   temp:string;
begin
     if not cancelbtn.focused then
     begin
          temp:=mainform.joists.fieldbyname(tdbedit(sender).datafield).asstring;
          if (tdbedit(sender).datafield='Base Length') and (temp='') then
             exit;
          if temp<>dectoing(ingtodec(temp)) then
          begin
               if temp='' then
                  mainform.joists.fieldbyname(tdbedit(sender).datafield).asstring:='0-0'
               else
               begin
                    mainform.joists.fieldbyname(tdbedit(sender).datafield).asstring:=dectoing(ingtodec(temp));
                    if mainform.joists.fieldbyname(tdbedit(sender).datafield).asstring='0-0' then
                    begin
                         mainform.joists.fieldbyname(tdbedit(sender).datafield).asstring:=temp;
                         tdbedit(sender).setfocus;
                         raise exception.create('Invalid input in field '+tdbedit(sender).datafield);
                    end;
               end;
          end;
     end;
end;

procedure TEntryForm.ConcGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
      with (Sender as TStringGrid).Canvas do
      begin
              Brush.Style := bsSolid;
              if (arow>0)  then
              begin
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
                      if ACol>0 then
                      begin
                        SetTextAlign(Handle, TA_RIGHT);
                        TextRect(Rect, Rect.RIGHT - 2, Rect.Top + 2, (Sender as TStringGrid).Cells[aCol, aRow]);
                      end
                      else
                      begin
                        SetTextAlign(Handle, TA_LEFT);
                        TextRect(Rect, Rect.Left + 2, Rect.Top + 2, (Sender as TStringGrid).Cells[aCol, aRow]);
                      end

              end;
              SetTextAlign(Handle, TA_LEFT);
      end;
end;

procedure TEntryForm.ConcGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (key=46) and (conclist.count>0) then
     begin
          concdata:=ConcList.items[concgrid.row-1];
          dispose(concdata);
          conclist.delete(concgrid.row-1);
          conclist.pack;
          fillconc;
     end;
     if key=45 then
        insertload;
end;

procedure TEntryForm.PanelCheckClick(Sender: TObject);
begin
     sppanels:=panelcheck.checked;
     fillpanels;
     panelgrid.enabled:=panelcheck.checked;
end;

procedure TEntryForm.PanelGridDblClick(Sender: TObject);
begin
     if panelcheck.checked then
     begin
          tcpanel:=panellist.items[panelgrid.row-1];
          paneltcform:=tpaneltcform.create(application);
          paneltcform.getpanel(tcpanel^.length,panelgrid.row);
          paneltcform.free;
          fillpanels;
     end;
end;

procedure TEntryForm.brgsupClick(Sender: TObject);
begin
     if brgsup.checked then
        brgspc.enabled:=true
     else
         brgspc.enabled:=false;
     brgspc.text:='0.00';
     stseam:=brgspc.enabled;
end;

procedure TEntryForm.brgspcExit(Sender: TObject);
begin
     if not cancelbtn.focused then
     begin
     try
     brgspc.text:=format('%0.2f',[strtofloat(brgspc.text)]);
     except
           brgspc.setfocus;
           raise exception.create('Invalid input');
     end;
     end;
end;

procedure TEntryForm.EntryTabsChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
     if (newtab>0) and (not shape.enabled) then
        raise exception.create('Incomplete Joist Information');
end;

procedure TEntryForm.PartGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (key=46) and (partlist.count>0) then
     begin
          partdata:=partList.items[partgrid.row-1];
          dispose(partdata);
          partlist.delete(partgrid.row-1);
          partlist.pack;
          fillpart;
     end;
     if key=45 then
        insertpartial;
end;

procedure TEntryForm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
     if not shape.enabled then
        allowchange:=false;
end;

procedure TEntryForm.SuppLExit(Sender: TObject);
begin
     try
     if tedit(sender).text='' then tedit(sender).text:='1';
     tedit(sender).text:=inttostr(strtoint(tedit(sender).text));
     except
           tedit(sender).setfocus;
           raise exception.create('Invalid input');
     end;
     if (strtoint(suppl.text)<1) or (strtoint(suppl.text)>=supp2) then
     begin
          tedit(sender).setfocus;
          raise exception.create('Invalid joint number');
     end;
     supp1:=strtoint(suppl.text);
end;

procedure TEntryForm.SuppRExit(Sender: TObject);
begin
     try
     if tedit(sender).text='' then tedit(sender).text:=inttostr(jointlist.count);
     tedit(sender).text:=inttostr(strtoint(tedit(sender).text));
     except
           tedit(sender).setfocus;
           raise exception.create('Invalid input');
     end;
     if (strtoint(suppr.text)>jointlist.count) or (strtoint(suppr.text)<=supp1) then
     begin
          tedit(sender).setfocus;
          raise exception.create('Invalid joint number');
     end;
     supp2:=strtoint(suppr.text);
end;

procedure TEntryForm.valdectoinch(Sender: TObject);
var
   temp:string;
begin
        temp:=mainform.joists.fieldbyname(tdbedit(sender).datafield).asstring;
        if temp<>dectoinch(ingtodec(temp)) then
        begin
             if temp='' then
                mainform.joists.fieldbyname(tdbedit(sender).datafield).asstring:='0'
             else
             begin
                  mainform.joists.fieldbyname(tdbedit(sender).datafield).asstring:=dectoinch(inchtodec(temp));
                  if mainform.joists.fieldbyname(tdbedit(sender).datafield).asstring='0' then
                  begin
                       mainform.joists.fieldbyname(tdbedit(sender).datafield).asstring:=temp;
                       tdbedit(sender).setfocus;
                       raise exception.create('Invalid input in field '+tdbedit(sender).datafield);
                  end;
             end;
        end;
end;

procedure TEntryForm.Button1Click(Sender: TObject);
begin
        gpanelform:=tgpanelform.create(application);
        gpanelForm.edit16.Text:=inttostr(sp-2);
        if jtype='G' then
        begin
           gpanelForm.edit15.Text:=mainform.JoistsFirstDiagLE.Value;
           gpanelForm.edit17.Text:=dectoing(bcl);
           gpanelForm.edit18.Text:=mainform.JoistsFirstDiagRE.Value;
        end;
        if jtype='B' then
        begin
           gpanelForm.edit15.Text:=mainform.JoistsTCPanelsLE.Value;
           gpanelForm.edit17.Text:=dectoing(bcl/2);
           gpanelForm.edit18.Text:=mainform.JoistsTCPanelsRE.Value;
        end;
        if jtype='V' then
        begin
           gpanelForm.edit15.Text:=mainform.JoistsTCPanelsLE.Value;
           gpanelForm.edit17.Text:=dectoing(bcl);
           gpanelForm.edit18.Text:=mainform.JoistsTCPanelsRE.Value;
        end;
        gpanelform.showmodal;
        if gpanelform.ModalResult=mrOK then
        with gpanelform do
        begin
               if jtype='G' then
               begin
                  MainForm.joistsbcpanel.Value:=edit17.Text;
                  mainform.JoistsBCPanelsLE.Value:=dectoing(ingtodec(edit15.Text)/2);
                  mainform.JoistsBCPanelsRE.Value:=dectoing(ingtodec(edit18.Text)/2);
                  mainform.JoistsTCPanelsLE.Value:=mainform.JoistsBCPanelsLE.Value;
                  mainform.JoistsTCPanelsRE.Value:=mainform.JoistsBCPanelsRE.Value;
                  mainform.JoistsFirstDiagLE.Value:=edit15.Text;
                  mainform.JoistsFirstDiagRE.Value:=edit18.Text;
               end;
               if jtype='B' then
               begin
                  MainForm.joistsbcpanel.Value:=dectoing(ingtodec(edit17.Text)*2);
                  mainform.JoistsBCPanelsLE.Value:=edit15.Text;
                  mainform.JoistsBCPanelsRE.Value:=edit18.Text;
                  mainform.JoistsTCPanelsLE.Value:=mainform.JoistsBCPanelsLE.Value;
                  mainform.JoistsTCPanelsRE.Value:=mainform.JoistsBCPanelsRE.Value;
                  if odd(sp) then
                        mainform.JoistsFirstDiagRE.Value:=mainform.JoistsBCPanelsRE.Value
                  else
                        mainform.JoistsFirstDiagRE.Value:=dectoing(ingtodec(edit18.Text)+ingtodec(edit17.Text));
               end;
               if jtype='V' then
               begin
                  MainForm.joistsbcpanel.Value:=edit17.Text;
                  mainform.JoistsBCPanelsLE.Value:=edit15.Text;
                  mainform.JoistsBCPanelsRE.Value:=edit18.Text;
                  mainform.JoistsTCPanelsLE.Value:=mainform.JoistsBCPanelsLE.Value;
                  mainform.JoistsTCPanelsRE.Value:=mainform.JoistsBCPanelsRE.Value;
                  mainform.JoistsFirstDiagLE.Value:=dectoing(ingtodec(edit15.Text)+ingtodec(edit17.Text)/2);
                  mainform.JoistsFirstDiagRE.Value:=dectoing(ingtodec(edit18.Text)+ingtodec(edit17.Text)/2);
               end;
        end;
        gpanelform.Free;
end;

procedure TEntryForm.SpecialGapClick(Sender: TObject);
begin
        if SpecialGap.checked then
                GapValue.enabled:=true
        else
                GapValue.enabled:=false;
        if SpecialGap.checked then
        begin
                if rndweb then
                        GapValue.text:='0.50'
                else
                        GapValue.text:='1.00';
        end
        else
        begin
                GapValue.text:='0.00';
        end;
end;

procedure TEntryForm.GapValueExit(Sender: TObject);
begin
     if not cancelbtn.focused then
     begin
     try
     GapValue.text:=format('%0.2f',[strtofloat(GapValue.text)]);
     except
           GapValue.setfocus;
           raise exception.create('Invalid input');
     end;
     end;
end;

end.

