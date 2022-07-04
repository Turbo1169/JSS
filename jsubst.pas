unit jsubst;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Analysis,
  Forms, Dialogs, StdCtrls, Db, Mask, DBCtrls, Buttons, DBTables, math,
  printers, ADODB, variants;

type
  TJSubstForm = class(TForm)
    Joist: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label20: TLabel;
    Label5: TLabel;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit2: TDBEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    LL360: TLabel;
    Label6: TLabel;
    PrintCheck: TCheckBox;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    SubsTbl: TADOTable;
    SubsTblIndex: TSmallintField;
    SubsTblSpan: TSmallintField;
    SubsTblTotalLoad: TSmallintField;
    SubsTblLiveLoad: TSmallintField;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure valuppercase(Sender: TObject);
    procedure valdectoing(Sender: TObject);
  private
    { Private declarations }
    function findsubst:boolean;
    procedure calcprop;
    procedure Drawcalc(temppaint:TCanvas; scle,fontscle:single);
  public
    { Public declarations }
  end;

var
  JSubstForm: TJSubstForm;

implementation

uses Main, Output;

{$R *.DFM}

type
  Tsubst=Record
    fe,fa2,fa,m,fb:single;
  end;

const
     m:single=0.03;
     maxsing:string='24';
var
    x,area,ixx,iyy,y,jsdepth,rbl:single;
    subst:tsubst;
    rxx,ryy:single;
    h1,h2,klr:single;
    allowdef,actdef:single;
    prntscle:single;

function ingtodec(ing:shortstring):single; external 'comlib.dll';
function dectoing(decn:single):shortstring; external 'comlib.dll';

function dodescription:boolean;
var
   index,jdesc,temp:string;
   a,b,c,d,e:single;
   bl1,bl2:integer;
   r1,r2:integer;
begin
     jdesc:=uppercase(mainform.jsubstdescription.value);
     if pos('JS',jdesc)=0 then
     begin
          result:=false;
          exit;
     end;
     rbl:=ingtodec(mainform.jsubstbaselength.value)/12;
     bl1:=trunc(rbl);
     bl2:=bl1;
     if bl1<rbl then
        bl2:=bl1+1;
     jsdepth:=strtofloat(copy(jdesc,1,pos('JS',jdesc)-1));
     index:=copy(jdesc,pos('JS',jdesc)+2,length(jdesc)-pos('JS',jdesc)+2);
     if pos('/',index)>0 then
     begin
          temp:=copy(index,1,pos('/',index)-1);
          load:=strtoint(temp);
          delete(index,1,pos('/',index));
          livel:=strtoint(index);
          result:=true;
          jtype:='1'
     end
     else
     begin
          jtype:='1';
          {if strtoint(index)<4 then
             jtype:='1'
          else
              jtype:='2';}
          temp:=inttostr(bl1);
          if JSubstForm.SubsTbl.Locate('Index;Span',vararrayof([index,temp]),[]) then
          begin
               if bl1=bl2 then
               begin
                    load:=JSubstForm.SubsTblTotalLoad.value;
                    livel:=JSubstForm.SubsTblLiveLoad.value;
               end
               else
               begin
                    a:=bl1; b:=rbl; c:=bl2; d:=JSubstForm.SubsTblTotalLoad.value; bl1:=JSubstForm.SubsTblLiveLoad.value;
                    temp:=inttostr(bl2);
                    if JSubstForm.SubsTbl.Locate('Index;Span',vararrayof([index,temp]),[]) then
                    begin
                         e:=JSubstForm.SubsTblTotalLoad.value;
                         load:=d-((a-b)/(a-c))*(d-e);
                         d:=bl1; e:=JSubstForm.SubsTblLiveLoad.value;
                         livel:=d-((a-b)/(a-c))*(d-e);
                    end
                    else
                    begin
                         load:=d;
                         livel:=bl1;
                    end;
               end;
          end
          else
          begin
               JSubstForm.SubsTbl.first;
               r1:=JSubstForm.SubsTblindex.value;
               JSubstForm.SubsTbl.last;
               r2:=JSubstForm.SubsTblindex.value;
               load:=strtoint(index);
               livel:=0;
               if (load>=r1) and (load<=r2) then
               begin
                    with JSubstForm.SubsTbl do
                    begin
                         Filter:='[Index] = '+index;
                         Filtered:=true;
                         first;
                         if rbl>JSubstForm.Substblspan.value then
                            last;
                         load:=JSubstForm.SubsTblTotalLoad.value;
                         livel:=JSubstForm.SubsTblLiveLoad.value;
                         Filtered:=false;
                    end;
               end;
          end;
          result:=true;
     end;
     rbl:=ingtodec(mainform.jsubstbaselength.value);
end;

function dobox(tpaint:tcanvas; fontscle,scle,boxx,boxy,boxw:single; desc,tvalue:string):single;
var
   h1,h2:integer;
begin
     {if boxy>10.25 then
     begin
          result:=boxy;
          exit;
     end;}
     with tpaint do
     begin
          font.name:='Arial';
          font.size:=8;
          font.style:=[fsitalic];
          font.height:=round(-font.height*fontscle);
          h1:=font.height;
          font.size:=10;
          font.style:=[fsbold];
          font.height:=round(-font.height*fontscle);
          h2:=font.height;
          rectangle(trunc(boxx*scle),trunc(boxy*scle),trunc((boxw+boxx)*scle),trunc((boxy+m*1.5)*scle+h1+h2));
          font.name:='Arial';
          font.size:=8;
          font.style:=[fsitalic];
          font.height:=round(-font.height*fontscle);
          textout(trunc((boxx+m)*scle),trunc((boxy+m)*scle),desc);
          font.name:='Arial';
          font.size:=10;
          font.style:=[fsbold];
          font.height:=round(-font.height*fontscle);
          textout(trunc((boxx+m)*scle),trunc((boxy+m)*scle+h1),tvalue);
     end;
     result:=((boxy+m*1.5)*scle+h1+h2)/scle;
end;

function docell(tpaint:tcanvas; fontscle,scle,boxx,boxy,boxw:single; tvalue:string; al:char):single;
var
   h1,h2:integer;
begin
     {if boxy>10.5 then
     begin
          result:=boxy;
          exit;
     end;}
     with tpaint do
     begin
          font.name:='Arial';
          font.size:=10;
          font.style:=[];
          font.height:=round(-font.height*fontscle);
          h1:=font.height;
          h2:=trunc((boxw+boxx-m)*scle-textwidth(tvalue));
          case al of
            'C':h2:=trunc((boxw*scle-textwidth(tvalue))/2+boxx*scle);
            'L':h2:=trunc((boxx+m)*scle);
            'T':h2:=trunc((boxw+boxx-m)*scle-textwidth(tvalue));
            'S':h2:=trunc((boxw+boxx-m)*scle-textwidth(tvalue));
          end;
          if (al<>'T') and (al<>'S') then
             rectangle(trunc(boxx*scle),trunc(boxy*scle),trunc((boxw+boxx)*scle),trunc((boxy+m*1.5)*scle+h1));
          if al='S' then
          begin
               moveto(trunc(boxx*scle),trunc(boxy*scle));
               lineto(trunc((boxw+boxx)*scle),trunc(boxy*scle));
          end;
          textout(h2,trunc((boxy+m)*scle),tvalue);
     end;
     result:=((boxy+m*1.5)*scle+h1)/scle;
end;

procedure TJSubstForm.Drawcalc(temppaint:TCanvas; scle,fontscle:single);
var
  Line:single;
  temp:string;

  procedure title;
  begin
       with mainform,temppaint do
       begin
            drawlogo(temppaint,scle);
            font.name:='Arial';
            font.size:=12;
            font.height:=round(-font.height*fontscle);
            font.style:=[fsbold];
            textout(trunc(scle*4.0),trunc(scle*0.30),'JOIST SUBSTITUTE');
            dobox(temppaint,fontscle,scle,2,0.5,1,'Job Number:',jobjobnumber.value);
            if dept=0 then
               dobox(temppaint,fontscle,scle,3,0.5,4.2,'Job Name:',jobjobname.value+' - '+jobinfoDescription.value)
            else
                dobox(temppaint,fontscle,scle,3,0.5,4.2,'Job Name:',jobjobname.value+' - '+sequenceDescription.value);
            line:=dobox(temppaint,fontscle,scle,7.2,0.5,1,'Date Run:',datetostr(date));
            dobox(temppaint,fontscle,scle,2,line,2.5,'Location:',joblocation2.value);
            temp:=jsubstdescription.value;
            dobox(temppaint,fontscle,scle,4.5,line,3,'Description:',temp);
            dobox(temppaint,fontscle,scle,7.5,line,0.7,'Mark:',jsubstmark.value);
       end;
  end;

begin
     with mainform,temppaint do
     begin
          title;
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          textout(trunc(scle*0.3),trunc(scle*1.25),'Specifications');
          line:=1.25+font.height/scle;
          dobox(temppaint,fontscle,scle,0.3,line,1,'Length:',jsubstbaselength.value);
          dobox(temppaint,fontscle,scle,1.3,line,1,'Fy:',format('%0.2n',[Fy*1000]));
          dobox(temppaint,fontscle,scle,2.3,line,1,'Fb:',format('%0.2n',[Fb]));
          dobox(temppaint,fontscle,scle,3.3,line,1,'LL Deflection:',inttostr(jsubstdeflection.value));
          dobox(temppaint,fontscle,scle,4.3,line,1.25,'Live Load:',format('%0.2n',[livel]));
          dobox(temppaint,fontscle,scle,5.55,line,1.25,'Allow Deflection:',format('%0.4f',[allowdef]));
          line:=dobox(temppaint,fontscle,scle,6.8,line,1.4,'Actual Deflection:',format('%0.4f',[actdef]));
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          line:=line+font.height/scle;
          textout(trunc(scle*0.3),trunc(scle*line),'Properties');
          line:=line+font.height/scle;
          docell(temppaint,fontscle,scle,0.3,line,0.7,'Area','C');
          docell(temppaint,fontscle,scle,1,line,0.75,'X','C');
          docell(temppaint,fontscle,scle,1.75,line,0.75,'Y','C');
          docell(temppaint,fontscle,scle,2.5,line,0.75,'Ixx','C');
          docell(temppaint,fontscle,scle,3.25,line,0.75,'Iyy','C');
          docell(temppaint,fontscle,scle,4,line,0.75,'Rxx','C');
          docell(temppaint,fontscle,scle,4.75,line,0.75,'Ryy','C');
          docell(temppaint,fontscle,scle,5.5,line,0.75,'Qty','C');
          line:=docell(temppaint,fontscle,scle,6.25,line,1.95,'Material','C');
          docell(temppaint,fontscle,scle,0.3,line,0.7,format('%0.4f',[area]),'C');
          docell(temppaint,fontscle,scle,1,line,0.75,format('%0.4f',[x]),'C');
          docell(temppaint,fontscle,scle,1.75,line,0.75,format('%0.4f',[y]),'C');
          docell(temppaint,fontscle,scle,2.5,line,0.75,format('%0.4f',[ixx]),'C');
          docell(temppaint,fontscle,scle,3.25,line,0.75,format('%0.4f',[iyy]),'C');
          docell(temppaint,fontscle,scle,4,line,0.75,format('%0.4f',[rxx]),'C');
          docell(temppaint,fontscle,scle,4.75,line,0.75,format('%0.4f',[ryy]),'C');
          if jtype='1' then
             temp:='2'
          else
              temp:='4';
          docell(temppaint,fontscle,scle,5.5,line,0.75,temp,'C');
          line:=docell(temppaint,fontscle,scle,6.25,line,1.95,angprop^.section+' = '+angprop^.description,'L');
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          line:=line+font.height/scle;
          textout(trunc(scle*0.3),trunc(scle*line),'Axial and Bending Analysis');
          line:=line+font.height/scle;
          docell(temppaint,fontscle,scle,0.3,line,1.7,'Total Load','L');
          line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%0.2n',[load]),'R');
          docell(temppaint,fontscle,scle,0.3,line,1.7,'Axial Load','L');
          line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%0.2n',[jsubstaxialload.value]),'R');
          docell(temppaint,fontscle,scle,0.3,line,1.7,'Moment @ Midspan','L');
          line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%6.2f',[subst.m]),'R');
          docell(temppaint,fontscle,scle,0.3,line,1.7,'fb','L');
          line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%6.2f',[subst.fb]),'R');
          docell(temppaint,fontscle,scle,0.3,line,1.7,'fa','L');
          line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%6.2f',[subst.fa]),'R');
          docell(temppaint,fontscle,scle,0.3,line,1.7,'Maximum K L/r','L');
          line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%6.2f',[klr]),'R');
          docell(temppaint,fontscle,scle,0.3,line,1.7,'Fa','L');
          line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%6.2f',[subst.Fa2]),'R');
          docell(temppaint,fontscle,scle,0.3,line,1.7,'F''e','L');
          line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%6.2f',[subst.Fe]),'R');
          docell(temppaint,fontscle,scle,0.3,line,1.7,'fa/Fa','L');
          line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%6.2f',[subst.fa/subst.Fa2]),'R');
          if subst.fa/subst.Fa2>0.15 then
          begin
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Combined Stress (H1-1)','L');
               line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%0.4f',[h1]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Combined Stress (H1-2)','L');
               line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%0.4f',[h2]),'R');
          end
          else
          begin
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Combined Stress (H1-3)','L');
               line:=docell(temppaint,fontscle,scle,2,line,0.95,format('%0.4f',[h1]),'R');
          end;
     end;
end;

procedure TJSubstForm.FormShow(Sender: TObject);
begin
     dbedit1.SetFocus;
end;

procedure TJSubstForm.calcprop;
var
   a1,a2,a3,a4:single;
begin
     gap:=0;
     if jtype='1' then
     begin
          a1:=angprop^.b*angprop^.t;
          a2:=(angprop^.b-angprop^.t)*angprop^.t;
          a3:=(angprop^.b-angprop^.t)*angprop^.t;
          a4:=angprop^.b*angprop^.t;
          area:=a1+a2+a3+a4;
          y:=a1*(angprop^.b/2)+a2*(angprop^.t+(angprop^.b-angprop^.t)/2)+
             a3*(jsdepth-angprop^.t-(angprop^.b-angprop^.t)/2)+a4*(jsdepth-angprop^.b/2);
          y:=y/area;
          x:=a1*(angprop^.b/2)+a2*(angprop^.t/2)+a3*(angprop^.t+angprop^.t/2)+
             a4*(angprop^.b/2+angprop^.t);
          x:=x/area;
          ixx:=2*(angprop^.ix+angprop^.area*sqr(y-angprop^.y));
          iyy:=2*(angprop^.iy+angprop^.area*sqr(x-angprop^.y));
          rxx:=sqrt(ixx/area);
          ryy:=sqrt(iyy/area);
     end
     else
     begin
          a1:=angprop^.b*angprop^.t;
          a2:=(angprop^.b-angprop^.t)*angprop^.t;
          a3:=(angprop^.b-angprop^.t)*angprop^.t;
          a4:=angprop^.b*angprop^.t;
          area:=2*(a1+a2+a3+a4);
          y:=2*(a1*(angprop^.b/2)+a2*(angprop^.t+(angprop^.b-angprop^.t)/2)+
             a3*(jsdepth-angprop^.t-(angprop^.b-angprop^.t)/2)+a4*(jsdepth-angprop^.b/2));
          y:=y/area;
          x:=0;
          x:=x/area;
          ixx:=4*(angprop^.ix+angprop^.area*sqr(y-angprop^.y));
          iyy:=2*(angprop^.iy+angprop^.area*sqr(gap/2+angprop^.t+angprop^.y))+
               2*(angprop^.iy+angprop^.area*sqr(gap/2+angprop^.y));
          rxx:=sqrt(ixx/area);
          ryy:=sqrt(iyy/area);
     end;
end;

procedure TJSubstForm.FormCreate(Sender: TObject);
begin
     SubsTbl.open;
end;

function TJSubstForm.findsubst:boolean;
const
     cm:single=0.85;
var
   found:boolean;
   b:integer;
begin
     found:=false;
     b:=1;
     angprop:=anglist.items[0];
     while angprop^.b*2<=jsdepth do
     begin
          inc(b);
          angprop:=anglist.items[b-1];
     end;
     subst.m:=((load/12)*sqr(rbl))/8;
     while (not found) and (b<anglist.count) and (angprop^.b<jsdepth) do
     begin
          calcprop;
          subst.fb:=subst.m*(jsdepth-Y)/ixx;
          subst.fa:=mainform.jsubstAxialLoad.value/area;
          klr:=rbl/rxx;
          if klr<rbl/ryy then
             klr:=rbl/ryy;
          subst.fa2:=fa(klr,angprop^.q);
          subst.fe:=12*sqr(pi)*E*1000/(23*sqr(klr));
          if subst.fa/Subst.fa2>0.15 then
          begin
               h1:=subst.fa/subst.fa2+cm*subst.fb/((1-subst.fa/subst.fe)*Fb);
               if h1<=1 then
               begin
                    h2:=subst.fa/(0.6*Fy*1000)+subst.fb/Fb;
                    if h2<=1 then
                       found:=true;
               end;
          end
          else
          begin
               h1:=subst.fa/subst.fa2+subst.fb/Fb;
               if h1<=1 then
                  found:=true;
          end;
          allowdef:=rbl/mainform.jsubstdeflection.value;
          actdef:=5*(livel/12)*intpower(rbl,4)/(384*E*1000*ixx);
          if found and (actdef>allowdef) then
             found:=false;
          if not found then
          begin
               inc(b);
               angprop:=anglist.items[b-1];
          end;
          if (angprop^.b>=jsdepth) and (jtype='1') then
          begin
               jtype:='2';
               b:=1;
               angprop:=anglist.items[0];
               while angprop^.b*2<=jsdepth do
               begin
                    inc(b);
                    angprop:=anglist.items[b-1];
               end;
          end;
     end;
     result:=found;
end;

procedure TJSubstForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     OKBtn.SetFocus;
     if JSubstForm.ModalResult=mrOk then
     begin
          if dodescription and findsubst then
          begin
               MainForm.jsubstSection.Value:=angprop^.section;
               if PrintCheck.Checked then
               begin
                    prntscle:=printer.pagewidth/8.5;
                    Printer.Orientation:=poPortrait;
                    Printer.Title:='Job '+MainForm.JobJobNumber.value;
                    Printer.BeginDoc;
                    drawcalc(printer.canvas,prntscle,1);
                    Printer.EndDoc;
               end;
               MainForm.jsubsttype.value:=jtype;
               MainForm.jsubstrunby.value:=runby;
               if jtype='1' then
                  MainForm.jsubstweight.value:=rbl/12*angprop^.weight*2
               else
                   MainForm.jsubstweight.value:=rbl/12*angprop^.weight*4;
               MainForm.jsubstmaterial.value:=(MainForm.jsubstweight.value/2000)*angprop^.cost;
               MainForm.jsubst.Post;
               with mainform do
               begin
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
               end;
          end
          else
              raise exception.create('Unable to design substitute');
     end
     else
     begin
          MainForm.jsubst.cancel;
     end;
     SubsTbl.close;
end;

procedure TJSubstForm.valuppercase(Sender: TObject);
var
   temp:string;
begin
     temp:=mainform.jsubst.fieldbyname(tdbedit(sender).datafield).asstring;
     if temp<>uppercase(temp) then
        mainform.jsubst.fieldbyname(tdbedit(sender).datafield).asstring:=uppercase(temp);
end;

procedure TJSubstForm.valdectoing(Sender: TObject);
var
   temp:string;
begin
     if not cancelbtn.focused then
     begin
          temp:=mainform.jsubst.fieldbyname(tdbedit(sender).datafield).asstring;
          if (tdbedit(sender).datafield='Base Length') and (temp='') then
             exit;
          if temp<>dectoing(ingtodec(temp)) then
          begin
               if temp='' then
                  mainform.jsubst.fieldbyname(tdbedit(sender).datafield).asstring:='0-0'
               else
               begin
                    mainform.jsubst.fieldbyname(tdbedit(sender).datafield).asstring:=dectoing(ingtodec(temp));
                    if mainform.jsubst.fieldbyname(tdbedit(sender).datafield).asstring='0-0' then
                    begin
                         mainform.jsubst.fieldbyname(tdbedit(sender).datafield).asstring:=temp;
                         tdbedit(sender).setfocus;
                         raise exception.create('Invalid input in field '+tdbedit(sender).datafield);
                    end;
               end;
          end;
     end;
end;

end.


