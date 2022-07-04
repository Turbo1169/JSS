unit Output2;

interface

uses Windows, sysutils, graphics, printers, classes, stdctrls, Math;

procedure FreshMember;
procedure freshJoint;
procedure FreshStress;
procedure FreshChords;
procedure FreshWebs;
procedure fillbatch;
procedure fillshop;
procedure fillshop2;
procedure DrawShop;
procedure Drawmatprop(temppaint:TCanvas; scle,fontscle:single);
procedure Drawmatreq(temppaint:TCanvas; scle,fontscle:single);

implementation

uses main;

const
     m:single=0.03;

function dectoing(decn:single):shortstring; external 'comlib.dll';
function ingtodec(ing:shortstring):single; external 'comlib.dll';
procedure addstr(var temp2:shortstring; news:shortstring; spos:integer); external 'comlib.dll';
function cangle(x1,y1,x2,y2:single):single; external 'comlib.dll';
function clength(x1,y1,x2,y2:single):single; external 'comlib.dll';


function dobox(tpaint:tcanvas; fontscle,scle,boxx,boxy,boxw:single; desc,tvalue:string):single;
var
   h1,h2:integer;
begin
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

procedure FreshMember;
var
   x:integer;
begin
     with mainform do
     begin
     enggrid.parent:=membpanel;
     enggrid.rowcount:=MemberList.count+1;
     enggrid.colcount:=10;
     for x:=0 to 9 do
     begin
          enggrid.ColWidths[x]:=64;
     end;
     enggrid.ColWidths[0]:=32;
     enggrid.ColWidths[5]:=85;
     enggrid.ColWidths[6]:=85;
     enggrid.cells[0,0]:='';
     enggrid.cells[1,0]:='Position';
     enggrid.cells[2,0]:='Material';
     enggrid.cells[3,0]:='Angle';
     enggrid.cells[4,0]:='Length';
     enggrid.cells[5,0]:='Max Comp';
     enggrid.cells[6,0]:='Max Tension';
     enggrid.cells[7,0]:='Weld';
     enggrid.cells[8,0]:='Thick';
     enggrid.cells[9,0]:='Csc';
     for x:=1 to MemberList.count do
     begin
          membdata:=MemberList.items[x-1];
          enggrid.cells[0,x]:=inttostr(x);
          enggrid.cells[1,x]:=membdata^.position;
          enggrid.cells[2,x]:=membdata^.material+'-'+membdata^.section;
          enggrid.cells[3,x]:=format('%8.2f',[membdata^.angle/pi*180]);
          enggrid.cells[4,x]:=format('%8.2f',[membdata^.length]);
          enggrid.cells[5,x]:=format('%8.3f',[membdata^.maxc]);
          enggrid.cells[6,x]:=format('%8.3f',[membdata^.maxt]);
          enggrid.cells[7,x]:=format('%8.2f',[membdata^.weld]);
          enggrid.cells[8,x]:=format('%8.3f',[membdata^.Thick]);
          enggrid.cells[9,x]:=format('%8.3f',[membdata^.csc]);
     end;
     end;
end;

procedure FreshWebs;
var
   y,v1max,v2max,c,x:integer;
   v1,v2:boolean;
   maxcv1,maxtv1,allowtv1,allowtv2:single;
   temp:string;
begin
     v1max:=0; v2max:=0;
     with mainform do
     begin
          enggrid.parent:=webpanel;
          enggrid.colcount:=8;
          enggrid.rowcount:=2;
          for x:=0 to 7 do
          begin
               enggrid.ColWidths[x]:=85;
          end;
          enggrid.ColWidths[0]:=36;
          enggrid.ColWidths[6]:=32;
          enggrid.ColWidths[7]:=150;
          enggrid.cells[0,0]:='Memb';
          enggrid.cells[1,0]:='Web Tension';
          enggrid.cells[2,0]:='Allow Tension';
          enggrid.cells[3,0]:='Web Comp';
          enggrid.cells[4,0]:='Allow Comp';
          enggrid.cells[5,0]:='Weld';
          enggrid.cells[6,0]:='Qty';
          enggrid.cells[7,0]:='Material';
          c:=0;
          v1:=false; v2:=false;
          allowtv1:=0;
          allowtv2:=0;
          maxcv1:=0;
          maxtv1:=0;
          for x:=1 to memberlist.count do
          begin
               membdata:=MemberList.items[x-1];
               if (copy(membdata^.position,1,1)='W') or (rndweb and (membdata^.position='V1S')) then
               begin
                    {if membdata^.overst>0 then
                       docell(temppaint,fontscle,scle,0.3,line,0.7,'* '+membdata^.position+' *','C')
                    else
                        docell(temppaint,fontscle,scle,0.3,line,0.7,membdata^.position,'C');}
                    inc(c);
                    enggrid.cells[0,c]:=membdata^.position;
                    enggrid.cells[1,c]:=format('%0.2n',[membdata^.maxt]);
                    enggrid.cells[2,c]:=format('%0.2n',[membdata^.allowt]);
                    enggrid.cells[3,c]:=format('%0.2n',[membdata^.maxc]);
                    enggrid.cells[4,c]:=format('%0.2n',[membdata^.allowc]);
                    temp:=format('%0.1f',[membdata^.weld])+' x '+format('%0.3f',[membdata^.thick]);
                    enggrid.cells[5,c]:=temp;
                    if membdata^.material='D' then
                       enggrid.cells[6,c]:='2'
                    else
                        enggrid.cells[6,c]:='1';
                    if membdata^.material='R' then
                    begin
                         findrnd(membdata^.section);
                         enggrid.cells[7,c]:=rndprop^.section+' = '+rndprop^.description;
                    end
                    else
                    begin
                         findangle(membdata^.section);
                         enggrid.cells[7,c]:=angprop^.section+' = '+angprop^.description;
                    end;
               end
               else
               begin
                    if membdata^.position='V1S' then
                    begin
                         v1:=true;
                         if membdata^.allowt>allowtv1 then
                         begin
                              allowtv1:=membdata^.allowt;
                              v1max:=x;
                         end;
                         if maxcv1<membdata^.maxc then
                            maxcv1:=membdata^.maxc;
                         if maxtv1<membdata^.maxt then
                            maxtv1:=membdata^.maxt;
                    end;
                    if membdata^.position='V2' then
                    begin
                         v2:=true;
                         if membdata^.allowt>allowtv2 then
                         begin
                              allowtv2:=membdata^.allowt;
                              v2max:=x;
                         end;
                    end;
               end;
          end;
          y:=2;
          if (v1=false) or (v2=false) then
             y:=1;
          if (not rndweb) and (v1 or v2) then
          for x:=1 to y do
          begin
               if y=2 then
               case x of
                    1:membdata:=memberlist.items[v1max-1];
                    2:membdata:=memberlist.items[v2max-1];
               end
               else
               begin
                    if v1 then
                       membdata:=memberlist.items[v1max-1];
                    if v2 then
                       membdata:=memberlist.items[v2max-1];
               end;
               inc(c);
               enggrid.cells[0,c]:=copy(membdata^.position,1,2);
               enggrid.cells[2,c]:=format('%0.2n',[membdata^.allowt]);
               enggrid.cells[4,c]:=format('%0.2n',[membdata^.allowc]);
               temp:=format('%0.1f',[membdata^.weld])+' x '+format('%0.3f',[membdata^.thick]);
               enggrid.cells[5,c]:=temp;
               if membdata^.material='D' then
                  enggrid.cells[6,c]:='2'
               else
                   enggrid.cells[6,c]:='1';
               if membdata^.material='R' then
               begin
                    findrnd(membdata^.section);
                    enggrid.cells[7,c]:=rndprop^.section+' = '+rndprop^.description;
               end
               else
               begin
                    findangle(membdata^.section);
                    enggrid.cells[7,c]:=angprop^.section+' = '+angprop^.description;
               end;
               if membdata^.position='V1S' then
               begin
                    enggrid.cells[1,c]:=format('%0.2n',[maxtv1]);
                    enggrid.cells[3,c]:=format('%0.2n',[maxcv1]);
               end
               else
               begin
                    enggrid.cells[1,c]:=format('%0.2n',[maxtv2]);
                    enggrid.cells[3,c]:=format('%0.2n',[maxcv2]);
               end;
          end;
          enggrid.rowcount:=c+1;
     end;
end;

procedure FreshStress;
var
   c,x:integer;
   temp:string;
   maxcv1,maxtv1,maxv1l,maxv2l,bcf,bcf2,tcf,tcf2:single;
   maxv2c,maxv2t:single;
   v1v:boolean;
begin
     with mainform do
     begin
     enggrid.parent:=panel9;
     enggrid.rowcount:=1; c:=1;
     enggrid.colcount:=9;
     enggrid.ColWidths[0]:=36;
     for x:=1 to 6 do
         enggrid.ColWidths[x]:=80;
     enggrid.ColWidths[7]:=64;
     enggrid.ColWidths[8]:=66;
     enggrid.cells[0,0]:='Memb';
     enggrid.cells[1,0]:='TC Tension';
     enggrid.cells[2,0]:='TC Comp';
     enggrid.cells[3,0]:='BC Tension';
     enggrid.cells[4,0]:='BC Comp';
     enggrid.cells[5,0]:='Web Tension';
     enggrid.cells[6,0]:='Web Comp';
     enggrid.cells[7,0]:='Web Len';
     enggrid.cells[8,0]:='PP Dist';
     tcf:=0; bcf:=0; maxv2l:=0; maxcv1:=0; maxv1l:=0;
     tcf2:=0; bcf2:=0; maxtv1:=0; v1v:=false; maxv2c:=0; maxv2t:=0;
     for x:=1 to MemberList.count do
     begin
          membdata:=MemberList.items[x-1];
          temp:=membdata^.position;
          if (temp='TC') or (temp='EP') or (temp='NP') or (temp='BC') then
          begin
             if temp='BC' then
             begin
                if casecombo.itemindex=0 then
                begin
                     bcf:=membdata^.maxt;
                     bcf2:=membdata^.maxc;
                end
                else
                    bcf:=membdata^.force;
             end
             else
             begin
                  if casecombo.itemindex=0 then
                  begin
                       tcf:=membdata^.maxt;
                       tcf2:=membdata^.maxc;
                  end
                  else
                      tcf:=membdata^.force;
             end;
          end
          else
          begin
               if membdata^.position='V2' then
               begin
                    if casecombo.itemindex>0 then
                    begin
                         if membdata^.force<0 then
                         begin
                              if maxv2c<abs(membdata^.force) then
                                 maxv2c:=abs(membdata^.force);
                         end
                         else
                         begin
                              if maxv2t<membdata^.force then
                                 maxv2t:=membdata^.force;
                         end;
                    end;
                    if maxv2l<membdata^.length then
                       maxv2l:=membdata^.length;
               end
               else
               begin
                    if membdata^.position='V1S' then
                    begin
                         bcf:=0;
                         bcf2:=0;
                    end;
                    if (membdata^.position='V1S') and (round(membdata^.angle/pi*180)=90) then
                    begin
                         if casecombo.itemindex>0 then
                         begin
                              if membdata^.force<0 then
                              begin
                                   if maxcv1<abs(membdata^.force) then
                                      maxcv1:=abs(membdata^.force);
                              end
                              else
                              begin
                                   if maxtv1<membdata^.force then
                                      maxtv1:=membdata^.force;
                              end;
                         end
                         else
                         begin
                              if maxcv1<membdata^.maxc then
                                 maxcv1:=membdata^.maxc;
                              if maxtv1<membdata^.maxt then
                                 maxtv1:=membdata^.maxt;
                         end;
                         if maxv1l<membdata^.length then
                            maxv1l:=membdata^.length;
                         v1v:=true;
                    end
                    else
                    begin
                    enggrid.cells[0,c]:=membdata^.position;
                    if casecombo.itemindex=0 then
                    begin
                         enggrid.cells[1,c]:=format('%0.2n',[tcf]);
                         enggrid.cells[2,c]:=format('%0.2n',[tcf2]);
                         enggrid.cells[3,c]:=format('%0.2n',[bcf]);
                         enggrid.cells[4,c]:=format('%0.2n',[bcf2]);
                         enggrid.cells[5,c]:=format('%0.2n',[membdata^.maxt]);
                         enggrid.cells[6,c]:=format('%0.2n',[membdata^.maxc]);
                    end
                    else
                    begin
                         if tcf<0 then
                         begin
                              enggrid.cells[1,c]:=format('%0.2n',[0.00]);
                              enggrid.cells[2,c]:=format('%0.2n',[abs(tcf)]);
                         end
                         else
                         begin
                              enggrid.cells[1,c]:=format('%0.2n',[tcf]);
                              enggrid.cells[2,c]:=format('%0.2n',[0.00]);
                         end;
                         if bcf<0 then
                         begin
                              enggrid.cells[3,c]:=format('%0.2n',[0.00]);
                              enggrid.cells[4,c]:=format('%0.2n',[abs(bcf)]);
                         end
                         else
                         begin
                              enggrid.cells[3,c]:=format('%0.2n',[bcf]);
                              enggrid.cells[4,c]:=format('%0.2n',[0.00]);
                         end;
                         if membdata^.force<0 then
                         begin
                              enggrid.cells[5,c]:=format('%0.2n',[0.00]);
                              enggrid.cells[6,c]:=format('%0.2n',[abs(membdata^.force)]);
                         end
                         else
                         begin
                              enggrid.cells[6,c]:=format('%0.2n',[0.00]);
                              enggrid.cells[5,c]:=format('%0.2n',[abs(membdata^.force)]);
                         end;
                    end;
                    enggrid.cells[7,c]:=format('%0.2f',[membdata^.length]);
                    jointdata:=JointList.items[membdata^.Joint1-1];
                    enggrid.cells[8,c]:=dectoing(jointdata^.coordX);
                    inc(c)
                    end;
               end;
          end;
     end;
     if not rndweb then
     begin
          if v1v then
          begin
               for x:=1 to 4 do
                   enggrid.cells[x,c]:='';
               enggrid.cells[8,c]:='';
               enggrid.cells[0,c]:='V1';
               enggrid.cells[5,c]:=format('%0.2n',[maxtv1]);
               enggrid.cells[6,c]:=format('%0.2n',[maxcv1]);
               enggrid.cells[7,c]:=format('%0.2f',[maxv1l]);
               inc(c);
          end;
          if casecombo.itemindex=0 then
          begin
               maxv2t:=maxtv2;
               maxv2c:=maxcv2;
          end;
          for x:=1 to 4 do
              enggrid.cells[x,c]:='';
          enggrid.cells[8,c]:='';
          enggrid.cells[0,c]:='V2';
          enggrid.cells[5,c]:=format('%0.2n',[maxv2t]);
          enggrid.cells[6,c]:=format('%0.2n',[maxv2c]);
          enggrid.cells[7,c]:=format('%0.2f',[maxv2l]);
          inc(c);
     end;
     enggrid.rowcount:=c;
     mainform.enggrid.fixedrows:=1;
     end;
end;

procedure labelcolor(mlabel:Tlabel; value1,value2:single);
begin
     if value1>value2 then
        mlabel.font.color:=clred
     else
         mlabel.font.color:=clblack;
end;

procedure freshchords;
var
   x:integer;

  procedure docolumn(endp:endptype; title:string; Tcol:integer);
  var
     z:integer;
  begin
       with mainform.enggrid do
       begin
            cells[tcol,0]:=title;
            cells[tcol,1]:=format('%6.2f',[endp.l]);
            if (endp.f<>0) or (endp.bending<>0)  then
            begin
                 cells[tcol,2]:=format('%6.2n',[endp.bending]);
                 cells[tcol,3]:=format('%6.2n',[endp.f]);
                 cells[tcol,4]:=format('%6.2n',[endp.fa2]);
                 cells[tcol,5]:=format('%6.2f',[endp.lr]);
                 cells[tcol,6]:=format('%6.2n',[endp.fcr]);
                 cells[tcol,7]:=format('%6.2n',[endp.fa]);
                 cells[tcol,8]:=format('%6.2n',[endp.fe]);
                 cells[tcol,9]:=format('%6.4f',[endp.cm]);
                 cells[tcol,10]:=format('%6.2f',[endp.me]);
                 cells[tcol,11]:=format('%6.2f',[endp.mi]);
                 cells[tcol,12]:=format('%6.2f',[endp.ppfb]);
                 cells[tcol,13]:=format('%6.2f',[endp.mpfb]);
                 cells[tcol,14]:=inttostr(endp.fillers);
                 cells[tcol,15]:=format('%11.2n',[endp.fa2+endp.ppfb]);
                 cells[tcol,16]:=format('%6.4n',[endp.bratio+endp.fa2/endp.fa]);
            end
            else
                 for z:=2 to 16 do
                      cells[tcol,z]:='';
       end;
  end;

begin
     with mainform do
     begin
          enggrid.parent:=panel13;
          enggrid.rowcount:=17;
          enggrid.colcount:=6;
          for x:=0 to 5 do
          begin
               enggrid.ColWidths[x]:=85;
          end;
          enggrid.ColWidths[0]:=150;
          enggrid.cells[0,0]:='Top Chord Check';
          enggrid.cells[3,0]:='Interior Panel';
          enggrid.cells[0,1]:='Length';
          enggrid.cells[3,1]:=format('%6.2f',[TCSection.maxintp]);
          enggrid.cells[0,2]:='Bending Load';
          enggrid.cells[3,2]:=format('%6.2f',[TCSection.bending]);
          enggrid.cells[0,3]:='Axial Load';
          enggrid.cells[3,3]:=format('%6.2n',[abs(TCSection.maxforce)]);
          enggrid.cells[0,4]:='fa';
          enggrid.cells[3,4]:=format('%6.2n',[abs(TCSection.fa2)]);
          enggrid.cells[0,5]:='Maximum K L/r';
          enggrid.cells[3,5]:=format('%6.2f',[abs(TCSection.lrmax)]);

          enggrid.cells[0,6]:='Fcr';
          enggrid.cells[3,6]:=format('%6.2n',[abs(TCSection.fcr)]);

          enggrid.cells[0,7]:='Fa';
          enggrid.cells[3,7]:=format('%6.2n',[abs(TCSection.fa)]);
          enggrid.cells[0,8]:='F''e';
          enggrid.cells[3,8]:=format('%6.2n',[abs(TCSection.fe)]);
          enggrid.cells[0,9]:='Cm';
          enggrid.cells[3,9]:=format('%6.4f',[abs(TCSection.cm)]);
          enggrid.cells[0,10]:='Panel Point Moment';
          enggrid.cells[3,10]:=format('%6.2f',[abs(TCSection.ppmom)]);
          enggrid.cells[0,11]:='Mid Panel Moment';
          enggrid.cells[3,11]:=format('%6.2f',[abs(TCSection.mpmom)]);
          enggrid.cells[0,12]:='Panel Point fb';
          enggrid.cells[3,12]:=format('%6.2f',[abs(TCSection.ppfb)]);
          enggrid.cells[0,13]:='Mid Panel fb';
          enggrid.cells[3,13]:=format('%6.2f',[abs(TCSection.mpfb)]);
          enggrid.cells[0,14]:='Fillers';
          enggrid.cells[3,14]:=inttostr(TCSection.fillers);
          enggrid.cells[0,15]:='Panel Point Stress';
          enggrid.cells[3,15]:=format('%12.2n',[abs(TCSection.Fa2+TCSection.ppfb)]);
          enggrid.cells[0,16]:='Mid Panel Stress';
          enggrid.cells[3,16]:=format('%12.4n',[abs(TCSection.Fa2/TCSection.Fa)+TCSection.bratio]);
          docolumn(endpl,'End Panel LE',1);
          docolumn(firstpl,'First Panel LE',2);
          docolumn(firstpr,'First Panel RE',4);
          docolumn(endpr,'End Panel RE',5);
          findangle(TCSection.section);
          chlabel1.caption:=format('%0.4f',[angprop^.area]);
          chlabel3.caption:=format('%0.4f',[angprop^.Rx]);
          chlabel5.caption:=format('%0.4f',[angprop^.Rz]);
          chlabel7.caption:=format('%0.4f',[TCSection.Ryy]);
          chlabel9.caption:=format('%0.4f',[angprop^.Y]);
          chlabel11.caption:=format('%0.4f',[angprop^.Ix]);
          chlabel13.caption:=format('%0.4f',[angprop^.Q]);
          chlabel15.caption:=angprop^.section+' = '+angprop^.description;
          tclabel1.caption:=dectoing(latsup);
          tclabel2.caption:=format('%0.2n',[TCSection.mlf]);
          tclabel3.caption:=format('%0.2n',[TCSection.mlnf]);
          if jtype in jtype1 then
             labelcolor(tclabel4,wl/TCSection.Ryy,575);
          tclabel4.caption:=format('%0.4n',[wl/TCSection.Ryy]);
          labelcolor(tclabel5,tcsection.tenst,fb);
          tclabel5.caption:=format('%0.2n',[TCSection.tenst]);
          labelcolor(tclabel6,TCSection.shrcap,0.4*fy*1000);
          tclabel6.caption:=format('%0.2n',[TCSection.shrcap]);
          tclabel7.caption:=format('%0.4f',[TCSection.weld]);
          tclabel8.caption:=format('%0.2n',[gap]);
          findangle(BCSection.section);
          chlabel2.caption:=format('%0.4f',[angprop^.area]);
          chlabel4.caption:=format('%0.4f',[angprop^.Rx]);
          chlabel6.caption:=format('%0.4f',[angprop^.Rz]);
          chlabel8.caption:=format('%0.4f',[BCSection.Ryy]);
          chlabel10.caption:=format('%0.4f',[angprop^.Y]);
          chlabel12.caption:=format('%0.4f',[angprop^.Ix]);
          chlabel14.caption:=format('%0.4f',[angprop^.Q]);
          chlabel16.caption:=angprop^.section+' = '+angprop^.description;
          bclabel1.caption:=dectoing(latsup2);
          bclabel4.caption:=format('%0.4n',[BCSection.maxintp/angprop^.Rz]);
          labelcolor(bclabel5,bcsection.tenst,fb);
          bclabel5.caption:=format('%0.2n',[BCSection.tenst]);
          labelcolor(bclabel6,BCSection.shrcap,0.4*fy*1000);
          bclabel6.caption:=format('%0.2n',[BCSection.shrcap]);
          if bcsection.maxforce2>0 then
          begin
               labelcolor(bclabel7,abs(BCSection.Fa2+BCSection.ppfb),fb);
               labelcolor(bclabel8,abs(BCSection.Fa2/BCSection.Fa)+BCSection.bratio,overst);
               bclabel2.caption:=format('%0.2n',[BCSection.mlf]);
               bclabel3.caption:=format('%0.2n',[BCSection.mlnf]);
               bclabel7.caption:=format('%12.2n',[abs(BCSection.Fa2+BCSection.ppfb)]);
               bclabel8.caption:=format('%12.4n',[abs(BCSection.Fa2/BCSection.Fa)+BCSection.bratio]);
          end
          else
          begin
               bclabel7.font.color:=clblack;
               bclabel8.font.color:=clblack;
               bclabel2.caption:='0.00';
               bclabel3.caption:='0.00';
               bclabel7.caption:='0.00';
               bclabel8.caption:='0.00';
          end;
     end;
end;

procedure freshJoint;
var
   x:integer;
begin
     with mainform do
     begin
     enggrid.parent:=jointpanel;
     enggrid.rowcount:=jointlist.count+1;
     enggrid.colcount:=8;
     for x:=0 to 7 do
     begin
          enggrid.ColWidths[x]:=64;
     end;
     enggrid.ColWidths[0]:=32;
     enggrid.ColWidths[4]:=85;
     enggrid.ColWidths[5]:=85;
     enggrid.cells[0,0]:='';
     enggrid.cells[1,0]:='Position';
     enggrid.cells[2,0]:='Coord X';
     enggrid.cells[3,0]:='Coord Y';
     enggrid.cells[4,0]:='Force X';
     enggrid.cells[5,0]:='Force Y';
     enggrid.cells[6,0]:='Delta X';
     enggrid.cells[7,0]:='Delta Y';
     for x:=1 to jointlist.count do
     begin
          jointdata:=jointlist.items[x-1];
          enggrid.cells[0,x]:=inttostr(x);
          enggrid.cells[1,x]:=JointData^.position;
          enggrid.cells[2,x]:=format('%8.2f',[JointData^.coordX]);
          enggrid.cells[3,x]:=format('%8.2f',[JointData^.coordY]);
          enggrid.cells[4,x]:=format('%11.2f',[JointData^.forceX]);
          enggrid.cells[5,x]:=format('%11.2f',[JointData^.forceY]);
          enggrid.cells[6,x]:=format('%11.2f',[JointData^.DeltaX]);
          enggrid.cells[7,x]:=format('%11.2f',[JointData^.DeltaY]);
     end;
     end;
end;

procedure newline(var temp:shortstring; nl:integer);
var
   x:integer;
begin
     temp:='';
     if nl>0 then
        for x:=1 to nl do
            mainform.Engmemo.lines.add('');
end;

procedure fillbatch;
var
   temp:shortstring;
begin
     with mainform do
     begin
          engmemo.lines.beginupdate;
          engmemo.clear;
          newline(temp,0);
          if SequenceIndex.value='' then
             addstr(temp,jobjobnumber.value,0)
          else
              addstr(temp,jobjobnumber.value+'-'+SequenceIndex.value,0);
          addstr(temp,jobjobname.value,3);
          addstr(temp,joblocation.value+', '+jobstate.value,9);
          addstr(temp,datetostr(shoporderdate.value),16);
          EngMemo.lines.add(temp);
          newline(temp,1);
          addstr(temp,'LISTA # '+inttostr(shoporderlistnumber.value),0);
          addstr(temp,'" '+uppercase(shopordertype.value)+' "',7);
          addstr(temp,sequencepaint.value,16);
          EngMemo.lines.add(temp);
          newline(temp,2);
          addstr(temp,'MARCA',0);
          addstr(temp,'CANT',2);
          addstr(temp,'TIPO JOIST',4);
          addstr(temp,'LONGITUD',7);
          addstr(temp,'  TONS',10);
          addstr(temp,'UNIT',12);
          addstr(temp,' TIEMPO',14);
          addstr(temp,' CUERDAS',16);
          EngMemo.lines.add(temp);
          EngMemo.lines.add('');
          shopordlist.first;
          while not shopordlist.eof do
          begin
               joists.Locate('Mark', shopordlistmark.value, []);
               newline(temp,0);
               addstr(temp,shopordlistmark.value,0);
               addstr(temp,format('%4d',[shopordlistquantity.value]),2);
               addstr(temp,shopordlistdescription.value,4);
               addstr(temp,shopordlistlength.value,7);
               addstr(temp,format('%6.2f',[shopordlisttons.value]),10);
               addstr(temp,format('%4.0f',[shopordlistweight.value]),12);
               addstr(temp,format('%7.3f',[shopordlisttime.value]),14);
               addstr(temp,joistschords.value,16);
               EngMemo.lines.add(temp);
               shopordlist.next;
          end;
          newline(temp,1);
          addstr(temp,format('%4d',[shoporderquantity.value]),2);
          addstr(temp,format('%6.2f',[shopordertons.value]),10);
          addstr(temp,format('%7.3f',[shopordertime.value]),14);
          EngMemo.lines.add(temp);
          engmemo.lines.endupdate;
     end;
end;

procedure fillersTC(var fillext,fillint:integer);
var
   f1,f2,x,x2,y:integer;
   alone:boolean;
begin
     fillext:=EndPL.fillers+EndPR.fillers;
     if ((jtype='K') or (jtype='C')) and (depth<18) then
        x:=mainform.joistsbcp.value-1
     else
         x:=(mainform.joistsbcp.value-1)*2;
     if halfple then
     begin
          fillext:=fillext+firstpl.fillers;
          inc(x);
          if (fillext<3) and (firstpl.fillers>0) then
             fillext:=3;
     end;
     if halfpre then
     begin
          fillext:=fillext+firstpr.fillers;
          inc(x);
          if (fillext<3) and (firstpr.fillers>0) then
             fillext:=3;
     end;
     x:=x+2;
     if odd(fillext) then
        inc(fillext);
     f1:=0;
     f2:=0;
     X2:=0;
     alone:=false;
     for y:=1 to memberlist.count do
     begin
          membdata:=memberlist.items[y-1];
          if (membdata^.position='TC') or (membdata^.position='EP') or (membdata^.position='NP') then
          begin
               inc(x2);
               if (membdata^.weld=1) and (membdata^.position='TC') then
               begin
                    if (odd(x)) and (x2=trunc(x/2)+1) then
                       alone:=true
                    else
                    begin
                         if x2<=trunc(x/2) then
                         begin
                              if f1=0 then
                                 f1:=trunc(x/2)-x2+1;
                         end
                         else
                         begin
                              if odd(x) then
                                 f2:=x2-trunc(x/2)-1
                              else
                                  f2:=x2-trunc(x/2);
                         end;
                    end;
               end;
          end;
     end;
     if f1>f2 then
        fillint:=f1*2
     else
         fillint:=f2*2;
     if ((odd(x)) and (fillint>0)) or alone then
        inc(fillint);
end;

function fillersBC:integer;
var
   fillint,f1,f2,x,x2,y:integer;
   alone:boolean;
begin
     x:=mainform.joistsbcp.value;
     f1:=0;
     f2:=0;
     X2:=0;
     alone:=false;
     for y:=1 to memberlist.count do
     begin
          membdata:=memberlist.items[y-1];
          if (membdata^.position='BC') then
          begin
               inc(x2);
               if (membdata^.weld=1) then
               begin
                    if (odd(x)) and (x2=trunc(x/2)+1) then
                       alone:=true
                    else
                    begin
                         if x2<=trunc(x/2) then
                         begin
                              if f1=0 then
                                 f1:=trunc(x/2)-x2+1;
                         end
                         else
                         begin
                              if odd(x) then
                                 f2:=x2-trunc(x/2)-1
                              else
                                  f2:=x2-trunc(x/2);
                         end;
                    end;
               end;
          end;
     end;
     if f1>f2 then
        fillint:=f1*2
     else
         fillint:=f2*2;
     if ((odd(x)) and (fillint>0)) or alone then
        inc(fillint);
     result:=fillint;
end;

procedure fillshop;
var
   joint1,joint2,pl,fillext,fillint,m,currq,nextq,a,c,x,y:integer;
   tmark,temp,temp2:shortstring;
   x1,y1,x2,y2,mangle,prevm,nextm,da,ytc,ybc,l:single;
   bmat,tempx1,tempx2:single;
   platetc,platebc:boolean;

   procedure lenTC;
   begin
        with mainform do
        begin
             if ingtodec(joistsridgeposition.value)<bl then
             begin
                  mangle:=cangle(0,joistsdepthle.value,ingtodec(joistsridgeposition.value),depth);
                  if jointdata^.coordX>ingtodec(joistsridgeposition.value) then
                  begin
                       l:=(ingtodec(joistsridgeposition.value)+ingtodec(joiststcxl.value))/cos(mangle);
                       mangle:=cangle(bl,joistsdepthre.value,ingtodec(joistsridgeposition.value),depth);
                       l:=l+(jointdata^.coordX-ingtodec(joistsridgeposition.value))/cos(mangle);
                  end
                  else
                  begin
                       l:=(jointdata^.coordX+ingtodec(joiststcxl.value))/cos(mangle);
                  end;
             end
             else
             begin
                  mangle:=cangle(0,joistsdepthle.value,bl,joistsdepthre.value);
                  l:=(ingtodec(joiststcxl.value)+jointdata^.coordX)/cos(mangle);
             end;
        end;
   end;

begin
     with mainform do
     begin
          engmemo.lines.beginupdate;
          engmemo.clear;
          newline(temp,0);
          if SequenceIndex.value='' then
             addstr(temp,jobjobnumber.value,0)
          else
              addstr(temp,jobjobnumber.value+'-'+SequenceIndex.value,0);
          addstr(temp,jobjobname.value,3);
          addstr(temp,joblocation.value+', '+jobstate.value,9);
          addstr(temp,joistsrunby.value,14);
          addstr(temp,datetostr(now),16);
          EngMemo.lines.add(temp);
          newline(temp,1);
          addstr(temp,'CANTIDAD',0);
          addstr(temp,'TIPO JOIST',3);
          addstr(temp,'MARCA NO',7);
          addstr(temp,'PINTURA',12);
          addstr(temp,'TIEMPO (M-hrs)',16);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value),0);
          addstr(temp,joistsdescription.value,3);
          addstr(temp,joistsmark.value,7);
          addstr(temp,sequencepaint.value,12);
          addstr(temp,format('%0.2n',[joiststime.value*joistsquantity.value]),16);
          EngMemo.lines.add(temp);

          if joverst then
          begin
               newline(temp,1);
               addstr(temp,'*** JOIST IS OVERSTRESSED ***',0);
               EngMemo.lines.add(temp);
          end;

          newline(temp,1);
          addstr(temp,'EXTREMO',4);
          addstr(temp,'LINEA',8);
          addstr(temp,'EXTREMO',12);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,'PROFUNDIDAD',0);
          addstr(temp,'IZQUIERDO',4);
          addstr(temp,'DE CABALLETE',8);
          addstr(temp,'DERECHO',12);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,dectoing(joistsdepthLE.value),4);
          addstr(temp,dectoing(depth),8);
          addstr(temp,dectoing(joistsdepthRE.value),12);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,'LONGITUD TOTAL',0);
          addstr(temp,'EXTENCION',4);
          addstr(temp,'LONG DE BASE',8);
          addstr(temp,'EXTENCION',12);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,dectoing(ingtodec(joiststcxl.value)+ingtodec(joistsbaselength.value)+ingtodec(joiststcxr.value)),0);
          addstr(temp,joiststcxl.value,4);
          addstr(temp,joistsbaselength.value,8);
          addstr(temp,joiststcxr.value,12);
          EngMemo.lines.add(temp);
          fillersTC(fillext,fillint);
          newline(temp,1);
          addstr(temp,'FILLERS: '+inttostr(fillext)+' en el ULTIMO PANEL '+
                inttostr(fillint)+' las INTERIORES',0);
          EngMemo.lines.add(temp);
          if bcsection.fillers>0 then
          begin
               newline(temp,0);
               addstr(temp,'*** CUERDA INFERIOR REQUERE '+inttostr(fillersBC)+' FILLERS ***',0);
               EngMemo.lines.add(temp);
          end;
          newline(temp,1);
          addstr(temp,'CUERDA INFERIOR PANELS (OAL) LE= '+dectoing(ingtodec(joistsbcpanelsLE.value)+
                ingtodec(joiststcxl.value)),0);
          addstr(temp,inttostr(joistsbcp.value)+' AT ESPECIAL',9);
          addstr(temp,'RE= '+dectoing(ingtodec(joistsbcpanelsRE.value)+ingtodec(joiststcxr.value)),14);
          EngMemo.lines.add(temp);
          newline(temp,1);
          addstr(temp,'CUERDA INFERIOR PANELS LONGITUD',6);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,'PNL',0);
          addstr(temp,'LONGITUD',1);
          addstr(temp,'PNL',4);
          addstr(temp,'LONGITUD',5);
          addstr(temp,'PNL',8);
          addstr(temp,'LONGITUD',9);
          addstr(temp,'PNL',12);
          addstr(temp,'LONGITUD',13);
          addstr(temp,'PNL',16);
          addstr(temp,'LONGITUD',17);
          EngMemo.lines.add(temp);
          c:=1; a:=0;
          for x:=1 to memberlist.count do
          begin
               membdata:=memberlist.items[x-1];
               if membdata^.position='BC' then
               begin
                    if c=6 then
                    begin
                       c:=1; inc(a);
                    end;
                    if c=1 then
                       newline(temp,0);
                    addstr(temp,inttostr(c+(5*a)),(c-1)*4);
                    addstr(temp,dectoing(membdata^.length),(c-1)*4+1);
                    inc(c);
                    if c=6 then
                       EngMemo.lines.add(temp);
               end;
          end;
          if c<6 then
             EngMemo.lines.add(temp);
          newline(temp,1);
          addstr(temp,'PANEL VARIABLE: LE #1= '+joistsfirsthalfle.value+' + '+dectoing(ingtodec(joistsbcpanel.value)/2),0);
          addstr(temp,'RE #'+inttostr(joistsbcp.value)+'= '+dectoing(ingtodec(joistsbcpanel.value)/2)+
                ' + '+joistsfirsthalfre.value,9);
          EngMemo.lines.add(temp);
          newline(temp,1);
          addstr(temp,'CUERDA INFERIOR REDUCCION LONGITUD DE LARGO TOTAL',4);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,'IZQUIERDO= '+joistsbcxl.value,0);
          addstr(temp,'DERECHO= '+joistsbcxr.value,6);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,'BARRENO',12);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,'CANTIDAD',0);
          addstr(temp,'MARCA',2);
          addstr(temp,'TAMAÑO',4);
          addstr(temp,'LONGITUD',6);
          addstr(temp,'TIPO',8);
          addstr(temp,'PROFUNDIDAD',9);
          addstr(temp,'REDUCCION',12);
          addstr(temp,'TAMAÑO',15);
          addstr(temp,'GA',17);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value*2),0);
          addstr(temp,'TC',2);
          findangle(tcsection.section);
          if angprop^.plate>0 then
             addstr(temp,angprop^.prevmat,4)
          else
              addstr(temp,tcsection.section,4);
          addstr(temp,dectoing(tcsection.length),6);
          EngMemo.lines.add(temp);
          if angprop^.plate>0 then
          begin
               newline(temp,0);
               addstr(temp,'*** UTILIZAR PLACA DE '+inttostr(angprop^.plate)+'x1 EN TC DONDE SE INDICA ***',1);
               EngMemo.lines.add(temp);
          end;
          if joistsshape.value='D' then
          begin
               newline(temp,0);
               mangle:=cangle(0,mainform.joistsdepthle.value,ingtodec(mainform.joistsridgeposition.value),depth);
               l:=(ingtodec(mainform.joistsridgeposition.value)+ingtodec(mainform.joiststcxl.value))/cos(mangle);
               addstr(temp,'LINEA DE CABALLETE= '+dectoing(l),0);
               EngMemo.lines.add(temp);
          end;
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value*2),0);
          addstr(temp,'BC',2);
          findangle(bcsection.section);
          if angprop^.plate>0 then
             addstr(temp,angprop^.prevmat,4)
          else
              addstr(temp,bcsection.section,4);
          addstr(temp,dectoing(bcsection.length),6);
          addstr(temp,'_________',12);
          addstr(temp,'______',15);
          addstr(temp,'__',17);
          EngMemo.lines.add(temp);
          if angprop^.plate>0 then
          begin
               newline(temp,0);
               addstr(temp,'*** UTILIZAR PLACA DE '+inttostr(angprop^.plate)+'x1 EN BC DONDE SE INDICA ***',1);
               EngMemo.lines.add(temp);
          end;
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value*2),0);
          addstr(temp,'BPL-L',2);
          addstr(temp,tcxl.section,4);
          addstr(temp,joistsSeatLengthLE.value,6);
          addstr(temp,JoistsTCXLTY.Value,8);
          addstr(temp,joistsseatsbdl.value,9);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value*2),0);
          addstr(temp,'BPL-R',2);
          addstr(temp,tcxr.section,4);
          addstr(temp,joistsSeatLengthRE.value,6);
          addstr(temp,JoistsTCXRTY.Value,8);
          addstr(temp,joistsseatsbdr.value,9);
          addstr(temp,'_________',12);
          addstr(temp,'______',15);
          addstr(temp,'__',17);
          EngMemo.lines.add(temp);
          newline(temp,1);
          addstr(temp,'NUMERO',0);
          addstr(temp,'TAMAÑO',2);
          addstr(temp,'MARCA',4);
          addstr(temp,'CANT',6);
          addstr(temp,'LONGITUD',8);
          addstr(temp,'SOLD',11);
          addstr(temp,'TC',13);
          addstr(temp,'BC',16);
          EngMemo.lines.add(temp);
          findangle(bcsection.section);
          ybc:=angprop^.y;
          da:=angprop^.t;
          findangle(tcsection.section);
          ytc:=angprop^.y;
          da:=da+angprop^.t;
          prevm:=0;
          if joistsconsolidate.Value then
             m:=middle
          else
              m:=memberlist.count;
          tmark:=joistsmark.value;
          if not halfple then
          begin
               findmemb('W3','L');
               membdata^.position:='V1S';
          end;
          if not halfpre then
          begin
               findmemb('W3','R');
               membdata^.position:='V1S';
          end;
          for x:=1 to m do
          begin
               membdata:=memberlist.items[x-1];
               temp:=membdata^.position;
               if (copy(temp,1,1)='W') or (copy(temp,1,1)='V') then
               begin
                    platetc:=false;
                    platebc:=false;
                    joint1:=membdata^.Joint1;
                    joint2:=membdata^.Joint2;
                    for pl:=1 to memberlist.Count do
                    begin
                         membdata:=memberlist.items[pl-1];
                         if (copy(membdata^.position,1,1)<>'V') and (copy(membdata^.position,1,1)<>'W') and (membdata^.overst=2) then
                         begin
                              if (membdata^.Joint1=joint1) or (membdata^.Joint1=joint2) or
                                 (membdata^.Joint2=joint1) or (membdata^.Joint2=joint2) then
                              begin
                                   if membdata^.Position='BC' then
                                      platebc:=true
                                   else
                                       platetc:=true;
                              end;
                         end;
                    end;
                    membdata:=memberlist.items[x-1];
                    if membdata^.material='D' then
                       currq:=2
                    else
                        currq:=1;
                    newline(temp,0);
                    if membdata^.material='D' then
                    begin
                         if (joistsconsolidate.Value) and not ((copy(membdata^.position,1,1)='V') and (x=m)) then
                            addstr(temp,inttostr(joistsquantity.value*4),0)
                         else
                             addstr(temp,inttostr(joistsquantity.value*2),0);
                    end
                    else
                    begin
                         if (joistsconsolidate.Value) and not ((copy(membdata^.position,1,1)='V') and (x=m)) then
                            addstr(temp,inttostr(joistsquantity.value*2),0)
                         else
                             addstr(temp,inttostr(joistsquantity.value),0);
                    end;
                    addstr(temp,membdata^.section,2);
                    if copy(membdata^.position,1,1)='V' then
                    begin
                         if (x>middle) and (not halfpre) and (membdata^.position='V1S') then
                            addstr(temp,'W3R',4)
                         else
                             if (x<=middle) and (not halfple) and (membdata^.position='V1S') then
                                addstr(temp,'W3L',4)
                             else
                                 addstr(temp,'  '+membdata^.position,4);
                    end
                    else
                    begin
                         if x>middle then
                            addstr(temp,membdata^.position+'R',4)
                         else
                             addstr(temp,membdata^.position+'L',4)
                    end;
                    temp2:=temp;
                    if membdata^.material='D' then
                       addstr(temp,'2',6)
                    else
                        addstr(temp,'1',6);
                    y:=x+1;
                    if y<=memberlist.count then
                    repeat
                          membdata:=memberlist.items[y-1];
                          inc(y);
                    until (copy(membdata^.position,1,1)='W') or (copy(membdata^.position,1,1)='V') or (y>memberlist.count);
                    nextm:=0;
                    if membdata^.material='D' then
                       nextq:=2
                    else
                        nextq:=1;
                    y:=x+1;
                    if (copy(membdata^.position,1,1)='V') and (nextq=currq) then
                    begin
                         if membdata^.material='R' then
                         begin
                              findrnd(membdata^.section);
                              nextm:=(rndprop^.d/2)*sin(membdata^.angle);
                         end
                         else
                         begin
                              findangle(membdata^.section);
                              if nextq=1 then
                                 nextm:=((angprop^.d-0.25)/2)*sin(membdata^.angle)
                              else
                                  nextm:=(angprop^.d/2)*sin(membdata^.angle);
                         end;
                    end;
                    if y>memberlist.count then
                    begin
                         nextq:=0;
                         nextm:=0;
                    end;
                    membdata:=memberlist.items[x-1];
                    if membdata^.material='R' then
                       findrnd(membdata^.section)
                    else
                        findangle(membdata^.section);
                    jointdata:=jointlist.items[membdata^.joint1-1];
                    x1:=jointdata^.coordx;
                    y1:=jointdata^.coordy;
                    jointdata:=jointlist.items[membdata^.joint2-1];
                    x2:=jointdata^.coordx;
                    y2:=jointdata^.coordy;

                    if membdata^.material='R' then
                       bmat:=rndprop^.d
                    else
                       if currq=1 then
                          bmat:=angprop^.d-0.25
                       else
                           bmat:=angprop^.d;
                    mangle:=cangle(x1,y1,x2,y2);
                    l:=clength(x1,y1,x2,y2);
                    l:=ybc/sin(mangle)+ytc/sin(mangle)-0.5/sin(mangle);
                    if membdata^.material='D' then
                       l:=l-da/sin(mangle);
                    l:=l-bmat/tan(mangle);
                    tempx1:=cos(mangle)*(l/2)+sin(mangle)*(bmat/2);
                    tempx1:=tempx1+0.25;
                    tempx2:=tempx1;
                    if copy(membdata^.position,1,1)='W' then
                    begin
                         if x1<x2 then
                         begin
                              tempx1:=prevm+tempx1;
                              x1:=x1+tempx1;
                              tempx2:=nextm+tempx2;
                              x2:=x2-tempx2;
                         end
                         else
                         begin
                              tempx1:=prevm+tempx1;
                              x1:=x1-tempx1;
                              tempx2:=nextm+tempx2;
                              x2:=x2+tempx2;
                         end;
                    end;
                    prevm:=0;
                    if (copy(membdata^.position,1,1)='V') and (currq=nextq) then
                       prevm:=(bmat/2)*sin(membdata^.angle);
                    l:=clength(x1,y1,x2,y2);
                    mangle:=cangle(x1,y1,x2,y2);
                    l:=l+ybc/sin(mangle)+ytc/sin(mangle);
                    l:=l-0.5/sin(mangle);
                    if membdata^.material='D' then
                       l:=l-da/sin(mangle);
                    l:=l-bmat/tan(mangle);
                    addstr(temp,dectoing(l),8);
                    addstr(temp2,dectoing(l),6);
                    addstr(tmark,temp2,3);
                    {webstr.add(tmark);}
                    if tmark<>'' then
                       tmark:='';
                    addstr(temp,format('%0.1n',[membdata^.weld]),11);

                    {addstr(temp,format('%0.4n',[tempx1]),13);
                    addstr(temp,format('%0.4n',[tempx2]),16);}

                    jointdata:=jointlist.items[membdata^.joint1-1];
                    if platetc then
                       addstr(temp,'   |',12);
                    if jointdata^.position='TC' then
                    begin
                         lenTC;
                         addstr(temp,dectoing(l),13);
                         jointdata:=jointlist.items[membdata^.joint2-1];
                         if platebc then
                            addstr(temp,'   |',15);
                         addstr(temp,dectoing(jointdata^.coordX+ingtodec(joiststcxl.value)),16);
                    end
                    else
                    begin
                         temp2:=dectoing(jointdata^.coordX+ingtodec(joiststcxl.value));
                         jointdata:=jointlist.items[membdata^.joint2-1];
                         lenTC;
                         addstr(temp,dectoing(l),13);
                         if platebc then
                            addstr(temp,'   |',15);
                         addstr(temp,temp2,16);
                    end;
                    EngMemo.lines.add(temp);
               end;
          end;
          if not halfple then
          begin
               findmemb('V1S','L');
               membdata^.position:='W3';
          end;
          if not halfpre then
          begin
               findmemb('V1S','R');
               membdata^.position:='W3';
          end;
          if jtype in jtype1 then
          begin
               newline(temp,2);
               addstr(temp,'TC',1);
               addstr(temp,'_________',2);
               addstr(temp,'_______',5);
               addstr(temp,'__',7);
               addstr(temp,'_________',9);
               addstr(temp,'_______',12);
               addstr(temp,'__',14);
               EngMemo.lines.add(temp);
               newline(temp,0);
               addstr(temp,'REDUCCION',2);
               addstr(temp,'BARRENO',5);
               addstr(temp,'GA',7);
               addstr(temp,'REDUCCION',9);
               addstr(temp,'BARRENO',12);
               addstr(temp,'GA',14);
               EngMemo.lines.add(temp);
               newline(temp,0);
               addstr(temp,'L.IZQUIERDO',2);
               addstr(temp,'L.DERECHO',9);
               EngMemo.lines.add(temp);
          end;
          newline(temp,1);
          addstr(temp,'PESO JOIST: '+format('%0.2f',[mainform.joistsweight.value])+' LBS',0);
          EngMemo.lines.add(temp);
          engmemo.lines.endupdate;
     end;
end;

procedure fillshop2;
var
   fillext,fillint:integer;
   temp:shortstring;
   mangle,ybc,ytc,l:single;
   x1,y1,x2,y2:single;
begin
     with mainform do
     begin
          engmemo.lines.beginupdate;
          engmemo.clear;
          newline(temp,0);
          if SequenceIndex.value='' then
             addstr(temp,jobjobnumber.value,0)
          else
              addstr(temp,jobjobnumber.value+'-'+SequenceIndex.value,0);
          addstr(temp,jobjobname.value,3);
          addstr(temp,joblocation.value+', '+jobstate.value,9);
          addstr(temp,joistsrunby.value,14);
          addstr(temp,datetostr(now),16);
          EngMemo.lines.add(temp);
          newline(temp,1);
          addstr(temp,'CANTIDAD',0);
          addstr(temp,'TIPO JOIST',3);
          addstr(temp,'MARCA NO',7);
          addstr(temp,'PINTURA',12);
          addstr(temp,'TIEMPO (M-hrs)',16);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value),0);
          addstr(temp,joistsdescription.value,3);
          addstr(temp,joistsmark.value,7);
          addstr(temp,sequencepaint.value,12);
          addstr(temp,format('%0.2n',[joiststime.value*joistsquantity.value]),16);
          EngMemo.lines.add(temp);
          if joverst then
          begin
               newline(temp,1);
               addstr(temp,'*** JOIST IS OVERSTRESSED ***',0);
               EngMemo.lines.add(temp);
          end;
          newline(temp,1);
          addstr(temp,'LONGITUD TOTAL',0);
          addstr(temp,'EXTENCION',4);
          addstr(temp,'LONG DE BASE',8);
          addstr(temp,'EXTENCION',12);
          addstr(temp,'PROFUNDIDAD',16);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,dectoing(ingtodec(joiststcxl.value)+ingtodec(joistsbaselength.value)+ingtodec(joiststcxr.value)),0);
          addstr(temp,joiststcxl.value,4);
          addstr(temp,joistsbaselength.value,8);
          addstr(temp,joiststcxr.value,12);
          addstr(temp,dectoing(depth),16);
          EngMemo.lines.add(temp);
          newline(temp,1);
          addstr(temp,'***** CUERDA INFERIOR PANELS REDUCCION LONGITUD DE LARGO TOTAL *****',2);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,'CU SUPERIOR',0);
          addstr(temp,'CUERDA INFERIOR PANEL',4);
          addstr(temp,'REDUCCION',12);
          addstr(temp,'REDUCCION',16);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,'INTERIOR PNLS',0);
          addstr(temp,'IZQUIERDO',4);
          addstr(temp,'DERECHO',8);
          addstr(temp,'IZQUIERDO',12);
          addstr(temp,'DERECHO',16);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,inttostr(joistsbcp.value+1)+' @ '+joistsbcpanel.value,0);
          addstr(temp,dectoing(ingtodec(joistsbcpanelsLE.value)+ingtodec(joiststcxl.value)),4);
          addstr(temp,dectoing(ingtodec(joistsbcpanelsRE.value)+ingtodec(joiststcxr.value)),8);
          addstr(temp,joistsbcxl.value,12);
          addstr(temp,joistsbcxr.value,16);
          EngMemo.lines.add(temp);
          newline(temp,1);
          addstr(temp,'CANTIDAD',0);
          addstr(temp,'MARCA',2);
          addstr(temp,'TAMAÑO',4);
          addstr(temp,'LONGITUD',6);
          addstr(temp,'TIPO',8);
          addstr(temp,'PROFUNDIDAD',9);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value*2),0);
          addstr(temp,'TC',2);
          addstr(temp,tcsection.section,4);
          addstr(temp,dectoing(tcsection.length),6);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value*2),0);
          addstr(temp,'BC',2);
          addstr(temp,bcsection.section,4);
          addstr(temp,dectoing(bcsection.length),6);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value*2),0);
          addstr(temp,'BPL-L',2);
          addstr(temp,tcxl.section,4);
          addstr(temp,joistsSeatLengthLE.value,6);
          addstr(temp,JoistsTCXLTY.Value,8);
          addstr(temp,joistsseatsbdl.value,9);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value*2),0);
          addstr(temp,'BPL-R',2);
          addstr(temp,tcxr.section,4);
          addstr(temp,joistsSeatLengthRE.value,6);
          addstr(temp,JoistsTCXRTY.Value,8);
          addstr(temp,joistsseatsbdr.value,9);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,inttostr(joistsquantity.value*2),0);
          addstr(temp,'END BAR',2);
          addstr(temp,rw1.section,4);
          findangle(bcsection.section);
          ybc:=angprop^.y;
          findangle(tcsection.section);
          ytc:=angprop^.y;
          findmemb('W2','R');
          findrnd(membdata^.section);
          jointdata:=jointlist.items[membdata^.joint1-1];
          x1:=jointdata^.coordx;
          y1:=jointdata^.coordy;
          jointdata:=jointlist.items[membdata^.joint2-1];
          x2:=jointdata^.coordx;
          y2:=jointdata^.coordy;
          if x1<x2 then
             x1:=x1+rndprop^.d*sin(membdata^.angle)+1
          else
              x1:=x1-rndprop^.d*sin(membdata^.angle)-1;
          l:=clength(x1,y1,x2,y2);
          mangle:=cangle(x1,y1,x2,y2);
          l:=l+ybc/sin(mangle)+ytc/sin(mangle);
          l:=l-0.5/sin(mangle);
          if cos(mangle)<>0 then
             l:=l-rndprop^.d/(sin(mangle)/cos(mangle));
          addstr(temp,dectoing(l),6);
          EngMemo.lines.add(temp);
          fillersTC(fillext,fillint);
          newline(temp,1);
          addstr(temp,'FILLERS: '+inttostr(fillext)+' en el ULTIMO PANEL '+
                inttostr(fillint)+' las INTERIORES',0);
          EngMemo.lines.add(temp);
          if bcsection.fillers>0 then
          begin
               newline(temp,0);
               addstr(temp,'*** CUERDA INFERIOR REQUERE '+inttostr(fillersBC)+' FILLERS ***',0);
               EngMemo.lines.add(temp);
          end;
          newline(temp,1);
          addstr(temp,'CELOSIA',0);
          addstr(temp,' NUMERO DE',3);
          addstr(temp,'CELOSIA',6);
          addstr(temp,' NUMERO DE',9);
          addstr(temp,'CELOSIA',12);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,'  W1',0);
          addstr(temp,'CELOSIA W2',3);
          addstr(temp,'  W2',6);
          addstr(temp,'CELOSIA W3',9);
          addstr(temp,'  W3',12);
          EngMemo.lines.add(temp);
          newline(temp,0);
          addstr(temp,'  '+rw1.section,0);
          if rw2l.qty+rw2r.qty>0 then
          begin
               addstr(temp,inttostr(rw2l.qty)+'/'+inttostr(rw2r.qty)+'   ('+inttostr(rw2l.qty+rw2r.qty)+')',3);
               if rw2l.section=rw2r.section then
                  addstr(temp,'  '+rw2l.section,6)
               else
                   addstr(temp,rw2l.section+'/'+rw2r.section,6);
          end;
          addstr(temp,'    '+inttostr(rw3.qty),9);
          addstr(temp,'  '+rw3.section,12);
          EngMemo.lines.add(temp);
          newline(temp,1);
          addstr(temp,'PESO JOIST: '+format('%0.2f',[mainform.joistsweight.value])+' LBS',0);
          EngMemo.lines.add(temp);
          engmemo.lines.endupdate;
     end;
end;

procedure DrawShop;
var
   x,y:integer;
   {F:TextFile;}
   line:single;
begin
     {try
        AssignFile(F,'LPT1');
        Rewrite(F);
        for x:=0 to mainform.engmemo.lines.count-1 do
        begin
             Writeln(F,mainform.engmemo.Lines[x]);
        end;
        Writeln(F,#12);
     finally
        CloseFile(F);
     end;}
     Printer.Orientation:=poPortrait;
     Printer.Title:='Job '+MainForm.JobJobNumber.value;
     Printer.BeginDoc;
     line:=0;
     printer.canvas.font:=mainform.engmemo.font;
     printer.canvas.font.style:=[fsbold];
     for x:=0 to mainform.engmemo.lines.count-1 do
     begin
          printer.canvas.textout(0,trunc(line),mainform.engmemo.Lines[x]);
          line:=line+(printer.canvas.Font.Size*printer.canvas.Font.PixelsPerInch/72)*1.25;
          if line+(printer.canvas.Font.Size*printer.canvas.Font.PixelsPerInch/72)>printer.pageheight then
          begin
               line:=0;
               printer.newpage;
               printer.canvas.font:=mainform.engmemo.font;
               printer.canvas.font.style:=[fsbold];
               for y:=0 to 4 do
               begin
                    printer.canvas.textout(0,trunc(line),mainform.engmemo.Lines[y]);
                    line:=line+(printer.canvas.Font.Size*printer.canvas.Font.PixelsPerInch/72)*1.25;
               end;
               printer.canvas.textout(0,trunc(line),'CONT...');
               line:=line+(printer.canvas.Font.Size*printer.canvas.Font.PixelsPerInch/72)*1.25;
          end;
     end;
     Printer.EndDoc;
end;

procedure Drawmatprop(temppaint:TCanvas; scle,fontscle:single);
var
  Line:single;
  x:integer;
begin
     with mainform,temppaint do
     begin
          font.name:='Arial';
          font.size:=12;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          textout(trunc(scle*3.25),trunc(scle*0.30),'MATERIAL PROPERTIES');
          textout(trunc(scle*7),trunc(scle*0.30),datetostr(now));
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          textout(trunc(scle*0.3),trunc(scle*0.75),'Angles');
          line:=0.75+font.height/scle;
          docell(temppaint,fontscle,scle,0.3,line,0.7,'Section','C');
          docell(temppaint,fontscle,scle,1,line,1.95,'Description','C');
          docell(temppaint,fontscle,scle,2.95,line,0.75,'Area','C');
          docell(temppaint,fontscle,scle,3.7,line,0.75,'Weight','C');
          docell(temppaint,fontscle,scle,4.45,line,0.75,'Rx','C');
          docell(temppaint,fontscle,scle,5.2,line,0.75,'Rz','C');
          docell(temppaint,fontscle,scle,5.95,line,0.75,'Y','C');
          docell(temppaint,fontscle,scle,6.7,line,0.75,'Ix','C');
          line:=docell(temppaint,fontscle,scle,7.45,line,0.75,'Q','C');
          for x:=1 to anglist.count do
          begin
               angprop:=anglist.items[x-1];
               docell(temppaint,fontscle,scle,0.3,line,0.7,angprop^.section,'C');
               docell(temppaint,fontscle,scle,1,line,1.95,angprop^.description,'L');
               docell(temppaint,fontscle,scle,2.95,line,0.75,format('%6.4f',[angprop^.area]),'R');
               docell(temppaint,fontscle,scle,3.7,line,0.75,format('%6.4f',[489.75/144*angprop^.area]),'R');
               docell(temppaint,fontscle,scle,4.45,line,0.75,format('%6.4f',[angprop^.Rx]),'R');
               docell(temppaint,fontscle,scle,5.2,line,0.75,format('%6.4f',[angprop^.Rz]),'R');
               docell(temppaint,fontscle,scle,5.95,line,0.75,format('%6.4f',[angprop^.Y]),'R');
               docell(temppaint,fontscle,scle,6.7,line,0.75,format('%6.4f',[angprop^.ix]),'R');
               line:=docell(temppaint,fontscle,scle,7.45,line,0.75,format('%6.4f',[angprop^.q]),'R');
          end;
          line:=line+font.height/scle;
          font.name:='Arial';
          font.style:=[fsbold];
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          textout(trunc(scle*0.3),trunc(scle*line),'Rounds');
          line:=line+font.height/scle;
          docell(temppaint,fontscle,scle,0.3,line,0.7,'Section','C');
          docell(temppaint,fontscle,scle,1,line,1.95,'Description','C');
          docell(temppaint,fontscle,scle,2.95,line,0.75,'Diam','C');
          docell(temppaint,fontscle,scle,3.7,line,0.75,'Area','C');
          docell(temppaint,fontscle,scle,4.45,line,0.75,'Weight','C');
          docell(temppaint,fontscle,scle,5.2,line,0.75,'R (in)','C');
          line:=docell(temppaint,fontscle,scle,5.95,line,0.75,'Mom of I','C');
          for x:=1 to rndlist.count do
          begin
               rndprop:=rndlist.items[x-1];
               docell(temppaint,fontscle,scle,0.3,line,0.7,rndprop^.section,'C');
               docell(temppaint,fontscle,scle,1,line,1.95,rndprop^.description,'L');
               docell(temppaint,fontscle,scle,2.95,line,0.75,format('%6.4f',[rndprop^.d]),'R');
               docell(temppaint,fontscle,scle,3.7,line,0.75,format('%6.4f',[rndprop^.area]),'R');
               docell(temppaint,fontscle,scle,4.45,line,0.75,format('%6.4f',[rndprop^.weight]),'R');
               docell(temppaint,fontscle,scle,5.2,line,0.75,format('%6.4f',[rndprop^.R]),'R');
               line:=docell(temppaint,fontscle,scle,5.95,line,0.75,format('%6.4f',[rndprop^.I]),'R');
          end;
     end;
end;

procedure Drawmatreq(temppaint:TCanvas; scle,fontscle:single);
var
  Totaltons,Line:single;
  x:integer;
  cost,totalcost:currency;
begin
     totaltons:=0;
     totalcost:=0;
     with mainform,temppaint do
     begin
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          if dept=0 then
             textout(trunc(scle*0.3),trunc(scle*0.30),'Material Requirements: '+
                 jobjobname.value+' ['+jobjobnumber.value+'] - '+jobinfodescription.value)
          else
              textout(trunc(scle*0.3),trunc(scle*0.30),'Material Requirements: '+
                 jobjobname.value+' ['+jobjobnumber.value+'] - '+sequencedescription.value);
          textout(trunc(scle*7.5),trunc(scle*0.30),datetostr(now));
          textout(trunc(scle*0.3),trunc(scle*0.75),'Angles');
          line:=0.75+font.height/scle;
          docell(temppaint,fontscle,scle,0.3,line,0.7,'Section','C');
          docell(temppaint,fontscle,scle,1,line,1.95,'Description','C');
          if dept=0 then
          begin
               docell(temppaint,fontscle,scle,2.95,line,0.75,'Tons','C');
               docell(temppaint,fontscle,scle,3.7,line,0.75,'Cost/Ton','C');
               line:=docell(temppaint,fontscle,scle,4.45,line,1,'Cost','C');
          end
          else
              line:=docell(temppaint,fontscle,scle,2.95,line,0.75,'Tons','C');
          for x:=1 to anglist.count do
          begin
               angprop:=anglist.items[x-1];
               if angprop^.Tons>0 then
               begin
                    docell(temppaint,fontscle,scle,0.3,line,0.7,angprop^.section,'C');
                    docell(temppaint,fontscle,scle,1,line,1.95,angprop^.description,'L');
                    if dept=0 then
                    begin
                         docell(temppaint,fontscle,scle,2.95,line,0.75,format('%0.2f',[angprop^.tons/2000]),'R');
                         docell(temppaint,fontscle,scle,3.7,line,0.75,format('%0.2f',[angprop^.cost]),'R');
                         cost:=angprop^.tons/2000*angprop^.cost;
                         line:=docell(temppaint,fontscle,scle,4.45,line,1,format('%0.2m',[cost]),'R');
                         totalcost:=totalcost+cost;
                    end
                    else
                        line:=docell(temppaint,fontscle,scle,2.95,line,0.75,format('%0.2f',[angprop^.tons/2000]),'R');
                    totaltons:=totaltons+angprop^.tons/2000;
               end;
          end;
          line:=line+font.height/scle;
          font.name:='Arial';
          font.style:=[fsbold];
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          textout(trunc(scle*0.3),trunc(scle*line),'Rounds');
          line:=line+font.height/scle;
          docell(temppaint,fontscle,scle,0.3,line,0.7,'Section','C');
          docell(temppaint,fontscle,scle,1,line,1.95,'Description','C');
          if dept=0 then
          begin
               docell(temppaint,fontscle,scle,2.95,line,0.75,'Tons','C');
               docell(temppaint,fontscle,scle,3.7,line,0.75,'Cost/Ton','C');
               line:=docell(temppaint,fontscle,scle,4.45,line,1,'Cost','C');
          end
          else
              line:=docell(temppaint,fontscle,scle,2.95,line,0.75,'Tons','C');
          for x:=1 to rndlist.count do
          begin
               rndprop:=rndlist.items[x-1];
               if rndprop^.tons>0 then
               begin
                    docell(temppaint,fontscle,scle,0.3,line,0.7,rndprop^.section,'C');
                    docell(temppaint,fontscle,scle,1,line,1.95,rndprop^.description,'L');
                    if dept=0 then
                    begin
                         docell(temppaint,fontscle,scle,2.95,line,0.75,format('%0.2f',[rndprop^.tons/2000]),'R');
                         docell(temppaint,fontscle,scle,3.7,line,0.75,format('%0.2f',[rndprop^.cost]),'R');
                         cost:=rndprop^.tons/2000*rndprop^.cost;
                         line:=docell(temppaint,fontscle,scle,4.45,line,1,format('%0.2m',[cost]),'R');
                         totalcost:=totalcost+cost;
                    end
                    else
                        line:=docell(temppaint,fontscle,scle,2.95,line,0.75,format('%0.2f',[rndprop^.tons/2000]),'R');
                    totaltons:=totaltons+rndprop^.tons/2000;
               end;
          end;
          line:=line+font.height/scle;
          docell(temppaint,fontscle,scle,1,line,1.95,'Total:','T');
          docell(temppaint,fontscle,scle,2.95,line,0.75,format('%0.2f',[totaltons]),'T');
          if dept=0 then
          begin
               line:=docell(temppaint,fontscle,scle,4.45,line,1,format('%0.2m',[totalcost]),'T');
               line:=line+font.height/scle;
               docell(temppaint,fontscle,scle,1,line,1.95,'Total with bump ('+format('%0.2f',[JobInfoOverweight.value])+'%):','T');
               docell(temppaint,fontscle,scle,2.95,line,0.75,format('%0.2f',[(JobInfoOverweight.value/100+1)*totaltons]),'T');
               docell(temppaint,fontscle,scle,4.45,line,1,format('%0.2m',[(JobInfoOverweight.value/100+1)*totalcost]),'T');
          end;
     end;
end;

{procedure genbatch;
var
   chordstr:tstringlist;
   temp:shortstring;
   l,mangle:single;
   x:integer;
begin
     webstr:=tstringlist.create;
     chordstr:=tstringlist.create;
     chordstr.clear;
     webstr.clear;
     with mainform do
     begin
          fillbatch;
          drawshop;
          Shopordlist.first;
          while not Shopordlist.eof do
          begin
               joists.findkey([sequencejobnumber.value,sequencepage.value,shopordlistmark.value]);
               recalcjoist;
               temp:='';
               addstr(temp,'MARCA NO',0);
               addstr(temp,'CANTIDAD',3);
               addstr(temp,'MARCA',5);
               addstr(temp,'TAMAÑO',7);
               addstr(temp,'LONGITUD',9);
               addstr(temp,'PROFUNDIDAD',12);
               chordstr.add(temp);
               temp:='';
               addstr(temp,joistsmark.value,0);
               addstr(temp,inttostr(joistsquantity.value*2),3);
               addstr(temp,'TC',5);
               addstr(temp,tcsection.section,7);
               addstr(temp,dectoing(tcsection.length),9);
               chordstr.add(temp);
               if joistsshape.value='D' then
               begin
                    temp:='';
                    mangle:=cangle(0,mainform.joistsdepthle.value,ingtodec(mainform.joistsridgeposition.value),depth);
                    l:=(ingtodec(mainform.joistsridgeposition.value)+ingtodec(mainform.joiststcxl.value))/cos(mangle);
                    addstr(temp,'LINEA DE CABALLETE= '+dectoing(l),3);
                    chordstr.add(temp);
               end;
               temp:='';
               addstr(temp,inttostr(joistsquantity.value*2),3);
               addstr(temp,'BC',5);
               addstr(temp,bcsection.section,7);
               addstr(temp,dectoing(bcsection.length),9);
               chordstr.add(temp);
               temp:='';
               addstr(temp,inttostr(joistsquantity.value*2),3);
               addstr(temp,'BPL-L',5);
               addstr(temp,tcsection.section,7);
               addstr(temp,dectoing(ingtodec(joistsSeatLengthLE.value)+ingtodec(joiststcxl.value)),9);
               addstr(temp,joistsseatsbdl.value,12);
               chordstr.add(temp);
               temp:='';
               addstr(temp,inttostr(joistsquantity.value*2),3);
               addstr(temp,'BPL-R',5);
               addstr(temp,tcsection.section,7);
               addstr(temp,dectoing(ingtodec(joistsSeatLengthRE.value)+ingtodec(joiststcxr.value)),9);
               addstr(temp,joistsseatsbdr.value,12);
               chordstr.add(temp);
               temp:='';
               addstr(temp,'MARCA NO',0);
               addstr(temp,'NUMERO',3);
               addstr(temp,'TAMAÑO',5);
               addstr(temp,'MARCA',7);
               addstr(temp,'LONGITUD',9);
               webstr.add(temp);
               if rndweb then
                  fillshop2
               else
                   fillshop;
               drawshop;
               Shopordlist.next;
               if not Shopordlist.eof then
               begin
                    chordstr.add('');
                    webstr.add('');
               end;
          end;
          temp:='';
          if sequenceindex.value='' then
             addstr(temp,jobjobnumber.value,0)
          else
              addstr(temp,jobjobnumber.value+'-'+sequenceindex.value,0);
          addstr(temp,jobjobname.value,3);
          addstr(temp,joblocation.value+', '+jobstate.value,9);
          addstr(temp,datetostr(now),16);
          engmemo.lines.beginupdate;
          engmemo.clear;
          EngMemo.lines.add(temp);
          EngMemo.lines.add(' ');
          for x:=1 to chordstr.count do
              EngMemo.lines.add(chordstr.strings[x-1]);
          engmemo.lines.endupdate;
          drawshop;
          engmemo.lines.beginupdate;
          engmemo.clear;
          EngMemo.lines.add(temp);
          newline(temp,1);
          for x:=1 to webstr.count do
              EngMemo.lines.add(webstr.strings[x-1]);
          engmemo.lines.endupdate;
          drawshop;
     end;
     chordstr.free;
     webstr.free;
end;}

end.
