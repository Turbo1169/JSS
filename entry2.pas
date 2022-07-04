unit Entry2;

interface

uses sysutils, controls, forms, analysis, math, dialogs, variants;

function findextra(section:string):integer;
procedure getchords;
function dogeometry:boolean;
function JoistGenerate:boolean;
procedure dorecalc;
function dodescription:boolean;
procedure fillloads;
procedure getbrgsup;
function defaultseat:single;
function bearingcap:single;
function checkplate(n1,n2,m:integer):boolean;

implementation

uses main;

var
   bcp:integer;
   index,jdesc:string;
   fdle,fdre,tcple,tcpre,bcple,bcpre:single;
   tcarea,lastx,cp,deple,depre,fhl,fhr:single;

function dectoing(decn:single):shortstring; external 'comlib.dll';
function rndprec(decn:single):single; external 'comlib.dll';
function ingtodec(ing:shortstring):single; external 'comlib.dll';
function cangle(x1,y1,x2,y2:single):single; external 'comlib.dll';
function inchtodec(ing:shortstring):single; external 'comlib.dll';

function checkplate(n1,n2,m:integer):boolean;
var
   x:integer;
   inplate:boolean;
begin
     inplate:=false;
     for x:=1 to memberlist.count do
     begin
          membdata:=memberlist.items[x-1];
          if (membdata^.overst=2) and ((membdata^.position='EP') or (membdata^.position='NP') or
             (membdata^.position='TC') or (membdata^.position='BC')) then
          begin
               if (membdata^.Joint1=n1) or (membdata^.Joint2=n1) or (membdata^.Joint1=n2) or (membdata^.Joint2=n2) then
               begin
                    inplate:=true;
                    break;
               end;
          end;
     end;
     membdata:=memberlist.items[m-1];
     result:=inplate;
end;

function bearingcap:single;
var
        fac,g,pp,k,pp2:single;
begin
        fac:=EndPL.fa2;
        if FirstPL.fa2>fac then
                fac:=FirstPL.fa2;
        if FirstPR.fa2>fac then
                fac:=FirstPR.fa2;
        if EndPR.fa2>fac then
                fac:=EndPR.fa2;
        if tcsection.fa2>fac then
                fac:=tcsection.fa2;
        k:=angprop^.t+angprop^.Radius;
        g:=5;
        pp:=sqr(angprop^.t)*Fy/(2*(angprop^.b-k))*(g+5.66*(angprop^.b-k));
        if LRFD then
        begin
          pp:=pp*0.9;
          pp2:=pp*(1.6-(fac/1000)/(0.9*angprop^.q*Fy));
        end
        else
        begin
          pp:=pp*0.6;
          pp2:=pp*(1.6-(fac/1000)/(0.6*angprop^.q*Fy));
        end;
        if pp<pp2 then
                result:=pp
        else
                result:=pp2;
end;

{function GirderBearingCapacity:single;
var
        cap1,cap2,pp:single;
begin
        pp:=(sqr(angprop^.t)*Fy)/(2*(angprop^.b-angprop^.K))*(5+5.66*(angprop^.b-angprop^.K));
        if loadcomb=2 then
        begin
                cap1:=0.9*pp;
                cap2:=0.9*pp*(1.6-TCSection.fa2/(0.9*angprop^.Q*Fy*1000));
        end
        else
        begin
                cap1:=0.6*pp;
                cap2:=0.6*pp*(1.6-TCSection.fa2/(0.6*angprop^.Q*Fy*1000));
        end;
        if cap1<cap2 then
                result:=cap1*1000
        else
                result:=cap2*1000;
end;}

function defaultseat:single;
var
        seatl:single;
begin
        case jtype of
            'K':seatl:=4;
            'C':seatl:=4;
            'L':seatl:=6;
            'D':seatl:=6;
            else
                seatl:=6;
          end;
          result:=seatl
end;

function findextra(section:string):integer;
var
   x:integer;
   found:boolean;
begin
     found:=false;
     section:='['+section+']';
     for x:=0 to joistmemo.lines.count-1 do
     begin
          if section=joistmemo.Lines[x] then
          begin
               found:=true;
               break;
          end;
     end;
     if found then
        result:=x+1
     else
         result:=0;
end;

procedure getpartloads;
var
   b,b2:integer;
   temp,temp2:string;
   pos2:single;
begin
     if partlist.count>0 then
     begin
          for b:=0 to (partlist.count-1) do
          begin
               partdata:=partList.items[b];
               dispose(partdata);
          end;
          partList.clear;
     end;
     b:=findextra('PARTIAL');
     if b>0 then
     begin
          b2:=findextra('CONCENTRATED');
          if b2=0 then
             b2:=joistmemo.lines.count-1
          else
              b2:=b2-1;
          while (b<b2) do
          begin
               temp:=joistmemo.Lines[b];
               inc(b);
               temp2:=copy(temp,1,pos(',',temp)-1);
               delete(temp,1,length(temp2)+1);
               if strtoint(temp2)<=jointlist.count then
               begin
                    New(PartData);
                    PartData^.Joint2:=strtoint(temp2);
                    jointdata:=jointlist.items[PartData^.Joint2-1];
                    pos2:=jointdata^.coordX;
                    temp2:=copy(temp,1,pos(',',temp)-1);
                    PartData^.Joint1:=strtoint(temp2);
                    jointdata:=jointlist.items[PartData^.Joint1-1];
                    delete(temp,1,length(temp2)+1);
                    if pos(',',temp)=0 then
                    begin
                        PartData^.Force:=strtofloat(temp);
                        PartData^.Force2:=strtofloat(temp);
                        partdata^.uplift:=False;
                    end
                    else
                    begin
                        temp2:=copy(temp,1,pos(',',temp)-1);
                        PartData^.Force:=strtofloat(temp2);
                        delete(temp,1,length(temp2)+1);
                        temp2:=copy(temp,1,pos(',',temp)-1);
                        PartData^.Force2:=strtofloat(temp2);
                        delete(temp,1,length(temp2)+1);
                        partdata^.uplift:=(temp='1');
                    end;
                    PartData^.position:=jointdata^.position+' '+dectoing(jointdata^.coordX)+
                       ' to '+dectoing(pos2);
                    if partdata^.uplift then
                        partdata^.Position:=partdata^.Position+' uplift';
                    PartList.add(partdata);
               end;
          end;
     end;
end;

procedure getconcloads;
var
   b:integer;
   chord,temp,temp2:string;
begin
     if Conclist.count>0 then
     begin
          for b:=0 to (Conclist.count-1) do
          begin
               Concdata:=ConcList.items[b];
               dispose(Concdata);
          end;
          ConcList.clear;
     end;
     b:=findextra('CONCENTRATED');
     if b>0 then
     begin
          while (b<joistmemo.lines.count) do
          begin
               temp:=joistmemo.Lines[b];
               inc(b);
               temp2:=copy(temp,1,pos(',',temp)-1);
               if (temp2<>'TC') and (temp2<>'BC') then
               begin
                       delete(temp,1,length(temp2)+1);
                       if strtoint(temp2)<=jointlist.count then
                       begin
                            New(ConcData);
                            jointdata:=jointlist.items[strtoint(temp2)-1];
                            ConcData^.chord:=jointdata^.position;
                            ConcData^.Dist:=jointdata^.CoordX;
                            temp2:=copy(temp,1,pos(',',temp)-1);
                            ConcData^.Force:=strtofloat(temp2);
                            delete(temp,1,length(temp2)+1);
                            ConcData^.position:=jointdata^.position+' @ '+dectoing(ConcData^.Dist);
                            ConcData^.wind:=(temp='True');
                            ConcData^.vcb:=false;
                            if concdata^.vcb then
                               ConcData^.position:=ConcData^.position+' vcb';
                            if concdata^.wind then
                               ConcData^.position:=ConcData^.position+' (+,-)';
                            ConcList.add(concdata);
                       end;
               end
               else
               begin
                       chord:=temp2;
                       delete(temp,1,length(temp2)+1);
                       temp2:=copy(temp,1,pos(',',temp)-1);
                       if ingtodec(temp2)<=wl+2 then
                       begin
                            New(ConcData);
                            ConcData^.chord:=chord;
                            ConcData^.Dist:=ingtodec(temp2);
                            delete(temp,1,length(temp2)+1);
                            temp2:=copy(temp,1,pos(',',temp)-1);
                            ConcData^.Force:=strtofloat(temp2);
                            delete(temp,1,length(temp2)+1);
                            temp2:=copy(temp,1,pos(',',temp)-1);
                            ConcData^.position:=ConcData^.chord+' @ '+dectoing(ConcData^.Dist);
                            ConcData^.vcb:=(temp2='1');
                            delete(temp,1,length(temp2)+1);
                            ConcData^.wind:=(temp='1');
                            if concdata^.vcb then
                               ConcData^.position:=ConcData^.position+' vcb';
                            if concdata^.wind then
                               ConcData^.position:=ConcData^.position+' (+,-)';
                            ConcList.add(concdata);
                       end;
               end;
          end;
     end;
     getpartloads;
end;

procedure getsupports;
var
   b:integer;
begin
     b:=findextra('SUPPORTS');
     if (b>0) and (not newg) then
     begin
          supp1:=strtoint(joistmemo.Lines[b]);
          supp2:=strtoint(joistmemo.Lines[b+1]);
     end
     else
     begin
          supp1:=1;
          supp2:=jointlist.count;
     end;
end;

procedure getbrgsup;
var
   b:integer;
begin
     stseam:=false;
     b:=findextra('BRGSUP');
     if b>0 then
     begin
          latsup:=strtofloat(joistmemo.Lines[b]);
          stseam:=true;
     end
     else
     begin
        if jtype in jtype2 then
                latsup:=36;
     end;
     b:=findextra('GAP');
     if b>0 then
     begin
                gap:=strtofloat(joistmemo.Lines[b]);
     end
     else
     begin
        if rndweb then
                gap:=0.5
        else
                gap:=1;
     end;
end;

procedure getchords;
var
   b:integer;
   temp,temp2:string;
begin
     mintc:=''; minbc:='';
     b:=findextra('CHORDS');
     if b>0 then
     begin
          while (b<joistmemo.lines.count) do
          begin
               temp:=joistmemo.Lines[b];
               if (copy(temp,1,1)='[') or (temp='') then break;
               inc(b);
               temp2:=copy(temp,1,pos(',',temp)-1);
               delete(temp,1,length(temp2)+1);
               if temp2='TC' then
                  mintc:=temp;
               if temp2='BC' then
                  minbc:=temp;
          end;
     end;
     getbrgsup;
     getconcloads;
end;

procedure getpanels;
var
   b,x:integer;
   temp:string;
begin
     b:=findextra('TCPANELS');
     if b>0 then
     begin
          sppanels:=true;
          if panellist.count>0 then
          begin
               for x:=0 to (panellist.count-1) do
               begin
                    tcpanel:=panelList.items[x];
                    dispose(tcpanel);
               end;
               panelList.clear;
          end;
          while (b<joistmemo.lines.count) do
          begin
               temp:=joistmemo.Lines[b];
               if (copy(temp,1,1)='[') or (temp='') then break;
               inc(b);
               New(tcpanel);
               tcpanel^.length:=strtofloat(temp);
               panelList.add(tcpanel);
          end;
     end
     else
         sppanels:=false;
end;

procedure rounds;
type
    web=record
      allowc,allowt,r:single;
      sect:string[2];
    end;
var
   c,wn,x,y:integer;
   allowc,allowt,max,r:single;
   w:array[1..60] of web;
   sect:string[2];
begin
     allowc:=0; allowt:=0;
     y:=1; wn:=0;
     while y<memberlist.count do
     begin
          membdata:=memberlist.items[y-1];
          if membdata^.position<>'W2' then
          begin
          if (copy(membdata^.position,1,1)='W') or (copy(membdata^.position,1,1)='V') then
          begin
               mainform.findrnd(membdata^.section);
               sect:=membdata^.section;
               allowc:=membdata^.allowc;
               allowt:=membdata^.allowt;
               r:=rndprop^.r;
               repeat
                     inc(y);
                     membdata:=memberlist.items[y-1];
               until (copy(membdata^.position,1,1)='W') or (copy(membdata^.position,1,1)='V');
               mainform.findrnd(membdata^.section);
               inc(wn);
               if rndprop^.r>r then
               begin
                    w[wn].r:=rndprop^.r;
                    w[wn].sect:=membdata^.section;
                    w[wn].allowc:=membdata^.allowc;
                    w[wn].allowt:=membdata^.allowt;
               end
               else
               begin
                   w[wn].r:=r;
                   w[wn].sect:=sect;
                   w[wn].allowc:=allowc;
                   w[wn].allowt:=allowt;
               end;
          end;
          end
          else
          begin
               rw1.section:=membdata^.section;
          end;
          inc(y);
     end;
     rw3.qty:=0;
     y:=trunc(wn/2)+1;
     rw3.section:=w[y].sect;
     r:=w[y].r; max:=0; c:=0;
     for x:=y to wn do
     begin
          if (r<w[x].r) or (c>0) then
          begin
               if c=0 then
                  c:=x;
               if w[x].r>max then
               begin
                    max:=w[x].r;
                    sect:=w[x].sect;
                    allowc:=w[x].allowc;
                    allowt:=w[x].allowt;
               end;
          end
          else
              inc(rw3.qty);
     end;
     rw2r.qty:=0;
     if c>0 then
     for x:=c to wn do
     begin
         inc(rw2r.qty);
         rw2r.section:=sect;
         w[x].r:=max;
         w[x].sect:=sect;
         w[x].allowc:=allowc;
         w[x].allowt:=allowt;
     end;
     y:=trunc(wn/2);
     if trunc(wn/2)<>wn/2 then
     begin
        y:=y+1;
        dec(rw3.qty);
     end;
     max:=0; c:=0;
     for x:=y downto 1 do
     begin
          if (r<w[x].r) or (c>0) then
          begin
               if c=0 then
                  c:=x;
               if w[x].r>max then
               begin
                    max:=w[x].r;
                    sect:=w[x].sect;
                    allowc:=w[x].allowc;
                    allowt:=w[x].allowt;
               end;
          end
          else
              inc(rw3.qty);
     end;
     rw2l.qty:=0;
     if c>0 then
     for x:=c downto 1 do
     begin
         inc(rw2l.qty);
         rw2l.section:=sect;
         w[x].r:=max;
         w[x].sect:=sect;
         w[x].allowc:=allowc;
         w[x].allowt:=allowt;
     end;
     x:=2;
     for y:=1 to memberlist.count do
     begin
          membdata:=memberlist.items[y-1];
          if membdata^.position<>'W2' then
          if (copy(membdata^.position,1,1)='W') or (copy(membdata^.position,1,1)='V') then
          begin
               membdata^.section:=w[trunc(x/2)].sect;
               membdata^.allowc:=w[trunc(x/2)].allowc;
               membdata^.allowt:=w[trunc(x/2)].allowt;
               inc(x);
          end;
     end;
end;

procedure selweb(var membweight:single);
var
   found:boolean;
   gap2:single;
   lc,c:integer;
   mat:string;
begin
     if (membdata^.position='V2') and (mainform.joistsconsolidate.Value) then
     begin
          membdata^.maxc:=maxcv2;
          membdata^.maxt:=maxtv2;
     end;
     mat:=membdata^.material;

     c:=0;
     found:=false;
     if (mat='A') or (mat='D') then
        lc:=anglist.count-1
     else
     begin
        lc:=Rndlist.count-1;
        if gap=1 then
        begin
             Rndprop:=Rndlist.items[c];
             while rndprop^.section<>'RH' do {mimimum round in 1" gap}
             begin
                  inc(c);
                  Rndprop:=Rndlist.items[c];
             end;
        end;
     end;

     mainform.findangle(BCSection.section);
     gap2:=gap+angprop^.t*2;
     while (c<=lc) and (not found) do
     begin
          if (mat='A') or (mat='D') then
          begin
               angprop:=anglist.items[c];
               while angprop^.plate>0 do
               begin
                    inc(c);
                    angprop:=anglist.items[c];
               end;
          end
          else
          begin
               Rndprop:=Rndlist.items[c];
          end;

          found:=checkweb(gap2);

          if found then
          begin
              if (mat='A') or (mat='D') then
              begin
                   membweight:=(membdata^.length/12)*angprop^.weight;
                   membdata^.section:=angprop^.section;
                   if membdata^.material='D' then
                      membweight:=membweight*2;
              end
              else
              begin
                   membweight:=(membdata^.length/12)*rndprop^.weight;
                   membdata^.section:=Rndprop^.section;
              end;
          end
          else
          begin
               if (mat='A') and (angprop^.section='29') then {minimum single angle}
                  c:=lc;
               inc(c);
               membdata^.section:='EE'
          end;
     end;
end;

procedure Webs;
var
   x:integer;
   found:boolean;
   membweight:single;
begin
     for x:=1 to MemberList.count do
     begin
          membdata:=MemberList.items[x-1];
          found:=false;
          if (copy(membdata^.position,1,1)='W') or (copy(membdata^.position,1,1)='V') then
          begin
               while not found do
               begin
                    if checkplate(membdata^.joint1,membdata^.joint2,x) then
                    begin
                         membdata^.Material:='D';
                    end;
                    selweb(membweight);
                    if membdata^.section='EE' then
                    begin
                       if membdata^.material='D' then
                          found:=true
                       else
                           membdata^.material:='D'
                    end
                    else
                        found:=true;
               end;
               if membdata^.section='EE' then
                  raise exception.create('Unable to find material for member '+membdata^.position);
               weight:=weight+membweight;
               if membdata^.material='R' then
               begin
                    material:=material+(membweight/2000)*rndprop^.cost;
                    rndprop^.total:=rndprop^.total+membweight*mainform.joistsquantity.value;
               end
               else
               begin
                    material:=material+(membweight/2000)*angprop^.cost;
                    angprop^.total:=angprop^.total+membweight*mainform.joistsquantity.value;
               end;
               {if membdata^.position='V1S' then
               begin
                    if membdata^.length>maxl1 then
                       maxl1:=membdata^.length;
                    if membdata^.maxc>maxc1 then
                       maxc1:=membdata^.maxc;
                    if membdata^.maxt>maxt1 then
                       maxt1:=membdata^.maxt;
               end;
               if membdata^.position='V2' then
               begin
                    if membdata^.length>maxl2 then
                       maxl2:=membdata^.length;
                    if membdata^.maxc>maxc2 then
                       maxc2:=membdata^.maxc;
                    if membdata^.maxt>maxt2 then
                       maxt2:=membdata^.maxt;
               end;}
          end
          else
          begin
               if membdata^.position='BC' then
                    membdata^.section:=BCSection.section
               else
                   membdata^.section:=TCSection.section;
          end;
     end;
     if rndweb then
        rounds;
end;

procedure selectTC(minsize:string);
var
   c:integer;
   chordweight:single;
   minchord,found:boolean;

begin
     chordweight:=0;
     if (jtype='L') or (jtype='D') then
        k:=0.75
     else
        k:=1;
     found:=false; c:=0; minchord:=false;
     while not minchord do
     begin
          angprop:=anglist.items[c];
          if angprop^.section=minsize then
             minchord:=true
          else
              inc(c);
     end;
     while (c<=anglist.count-1) and not found do
     begin
          tcsection.tenst:=0;
          angprop:=anglist.items[c];
          TCSection.section:=angprop^.section;
          chordweight:=(TCSection.Length/12)*angprop^.weight*2;

          //DONE -oArturo:Replace TCCheck with common procedure
          found:=CheckTC;

          if (jtype in jtype1) and (bearingcap*1000<load/2) then
              found:=false;

          if not found then
              inc(c);
     end;

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

     if found then
     begin
          plate:=0;
          if angprop^.plate>0 then
          begin
               plate:=angprop^.plate;
               plateweight:=0;
               mainform.findangle(angprop^.prevmat);
               checkTC;
               mainform.findangle(TCSection.Section);
               plate:=0;
               checkTC(True);
               chordweight:=chordweight+plateweight+plate*1*3.4*12/12;
          end;
          tcsection.tenst:=tcsection.tenst*fb;
          weight:=weight+chordweight;
          material:=material+(chordweight/2000)*angprop^.cost;
          angprop^.total:=angprop^.total+chordweight*mainform.joistsquantity.value;
     end
     else
         raise exception.create('TC overstressed, section not found');
end;

procedure selectBC(minsize:string);
var
   c:integer;
   chordweight:single;
   minchord,found:boolean;
begin
     k:=1;
     c:=0;
     chordweight:=0;
     minchord:=false;
     found:=false;
     while not minchord do
     begin
          angprop:=anglist.items[c];
          if angprop^.section=minsize then
             minchord:=true
          else
              inc(c);
     end;
     while (c<=anglist.count-1) and not found do
     begin
          bcsection.tenst:=0;
          angprop:=anglist.items[c];
          bcsection.fillers:=0;
          BCSection.section:=angprop^.section;
          chordweight:=(BCSection.Length/12)*angprop^.weight*2;

          //DONE -oArturo:Replace BCheck with common procedure
          found:=checkBC;

          if not found then
             inc(c);
     end;
     if found then
     begin
          plate:=0;
          if angprop^.plate>0 then
          begin
               plate:=angprop^.plate;
               plateweight:=0;
               mainform.findangle(angprop^.prevmat);
               checkBC;
               mainform.findangle(BCSection.Section);
               plate:=0;
               checkBC(True);
               chordweight:=chordweight+plateweight+plate*1*3.4*12/12;
          end;
          bcsection.tenst:=bcsection.tenst*fb;

          weight:=weight+chordweight;
          material:=material+(chordweight/2000)*angprop^.cost;
          angprop^.total:=angprop^.total+chordweight*mainform.joistsquantity.value;
     end
     else
         raise exception.create('BC overstressed, section not found');
end;

function reqdmig(wl,l,v:single):single;
begin
     result:=(1.15*5*(wl/1000/12)*intpower(l,4)*v)/(384*E*L);
end;

function reqdmi(wl,l,v:single):single;
begin
     if jtype='C' then
        result:=livel
     else
         result:=intpower(l/12,3)*(wl*v/360)*26.767*1e-6;
end;

procedure designTCX(var tcx:tcexten);
var
   m,reqsm,reqmi:single;
   ixtc,ytc,yc,ic,sm,tld:single;
   x:integer;
   sametc,found:boolean;
begin
     reqsm:=0;
     reqmi:=0;   
     if tcx.length>0 then
     begin
         tld:=tcx.length/tcx.def;
         m:=0;
         {if tcx.supported then
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
         else}
         begin
              {for x:=1 to llist.count do
              begin
                   loadd:=llist.items[x-1];
                   m:=m+loadd^.force*loadd^.Distance/12;
              end;}
              m:=m+(tcx.load*(sqr(tcx.length/12))/2);
              reqmi:=tcx.load*(intpower(tcx.length/12,4))/(8*E*1000*tld)*intpower(12,3);
              {for x:=1 to llist.count do
              begin
                   loadd:=llist.items[x-1];
                   reqmitl:=reqmitl+loadd^.force*sqr(loadd^.Distance/12)/(6*E*1000*tld)*
                       (3*ingtodec(length.text)/12-loadd^.Distance/12)*intpower(12,3);
              end;}
         end;
         m:=m*12;
         reqsm:=m/30000;
     end;
     mainform.findangle(TCSection.Section);
     ytc:=angprop^.Y;
     ixtc:=angprop^.Ix;
     //btc:=angprop^.b;
     found:=false;
     while not found do
     begin
         sametc:=false;
         for x:=1 to anglist.count do
         begin
              angprop:=anglist.items[x-1];
              //if angprop^.Section=TCSection.Section then
              if angprop^.Section=TCSection.Section then
                sametc:=true;
              if not sametc then
                continue;
              //if btc+angprop^.b-1.5<tcx.depth then
              //      continue;
              if tcx.length>0 then
              begin
                  if tcx.tcxtype='RD' then
                  begin
                        yc:=(tcarea*(tcx.depth-ytc)+angprop^.Area*angprop^.Y*2)/(tcarea+angprop^.Area*2);
                        ic:=(ixtc+tcarea/2*sqr(tcx.depth-yc-ytc))*2+(angprop^.ix+angprop^.Area*sqr(yc-angprop^.y))*2;
                  end
                  else
                  begin
                        yc:=ytc;
                        ic:=ixtc*2;
                  end;
                  sm:=ic/yc;
                  if (ic>=reqmi) and (sm>=reqsm) then
                  begin
                    found:=true;
                    break;
                  end;
              end
              else
              begin
                found:=true;
                break;
              end;
         end;
         if (not found) and (tcx.tcxtype='RD') then
         begin
                found:=true;
                ShowMessage('Unable to design TCX.');
         end;
         if (not found) and (tcx.tcxtype='S') then
                tcx.tcxtype:='R';
         if (not found) and (tcx.tcxtype='R') then
                tcx.tcxtype:='RD';
     end;
     tcx.section:=angprop^.Section;
end;

function matselect:boolean;
var
   found,assumed:boolean;
   seatwt,momill,momitl,ib,ab,edvar:single;
   tempsize:string[2];
   x,c,z:integer;
begin
     result:=true;
     try
     screen.cursor:=crhourglass;
     if mintc='' then
     begin
          if jtype in jtype1 then {minimum chord sizes TC}
             mintc:='2A'
          else
             if rndweb then
                mintc:='1C'
             else
                 mintc:='1C';
     end;
     if minbc='' then
     begin
          if jtype in jtype1 then {minimum chord sizes BC}
             minbc:='20'
          else
              if rndweb then
                 minbc:='18'
              else
                  minbc:='1C';
     end;
     assumed:=true; edvar:=0; realed:=ed; z:=0;
     while (edvar>depthvar) or assumed do {porcentaje de variacion ed}
     begin
          if not assumed then
          begin
             ed:=realed;
             dogeometry;
          end;
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
          c:=0; found:=false;
          while not found do
          begin
               for x:=1 to anglist.count do
               begin
                    angprop:=anglist.items[x-1];
                    angprop^.total:=0;
               end;
               for x:=1 to rndlist.count do
               begin
                    rndprop:=rndlist.items[x-1];
                    rndprop^.total:=0;
               end;
               weight:=0; material:=0;
               selectBC(minbc);
               realed:=depth-angprop^.y;
               ib:=angprop^.ix; ab:=angprop^.area*2;
               selectTC(mintc);
               tcarea:=angprop^.area*2;
               realed:=realed-angprop^.y;
               momi:=angprop^.ix+ib+sqr(realed)*(angprop^.area*2)*ab/(angprop^.area*2+ab);
               if jtype in jtype1 then
               begin
                  livel:=((maxr1+maxr2)/(wl/12))*0.6;
                  momill:=reqdmig(livel,wl,mainform.joistslldeflection.value);
               end
               else
                   momill:=reqdmi(livel,wl,mainform.joistslldeflection.value);
               if jtype in jtype1 then
                  momitl:=reqdmig((maxr1+maxr2)/(wl/12),wl,mainform.joiststldeflection.value)
               else
                   momitl:=reqdmi((maxr1+maxr2)/(wl/12),wl,mainform.joiststldeflection.value);
               inc(z);
               if (z>2) or (momi<momill) or (momi<momitl) then
               begin
                    minbc:=BCSection.section;
                    mintc:=TCSection.section;
               end;
               if (momi<momill) or (momi<momitl) then
               begin
                    if odd(c) then
                    begin
                       minbc:=mainform.nextsection(minbc);
                    end
                    else
                    begin
                         tempsize:=mintc;
                         mintc:=mainform.nextsection(mintc);
                         if mintc='EE' then
                            mintc:=tempsize;
                    end;
                   inc(c);
                   if minbc='EE' then
                      raise exception.create('Unable to design joist due to deflection');
               end
               else
                   found:=true;
          end;
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
          assumed:=false;
          edvar:=(abs(realed-ed)/ed)*100;
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
//TODO -oArturo: Fix TCX Design
     tcxl.length:=ingtodec(mainform.joiststcxl.value);
     tcxl.tcxtype:=mainform.JoistsTCXLTY.Value;
     if livel=0 then
     begin
        tcxl.def:=120;
        tcxl.load:=load;
     end
     else
     begin
        tcxl.def:=180;
        tcxl.load:=livel;
     end;
     tcxl.depth:=inchtodec(MainForm.JoistsSeatsBDL.value);
     designTCX(tcxl);
     if tcxl.tcxtype='S' then
            tcxl.length:=ingtodec(MainForm.joistsseatlengthLE.value);
     if tcxl.tcxtype='R' then
            tcxl.length:=defaultseat+tcxl.length;
     if tcxl.tcxtype='RD' then
            tcxl.length:=tcxl.length+ingtodec(mainform.JoistsTCPanelsLE.value)+6;
     seatwt:=(tcxl.length/12)*angprop^.weight*2;
     weight:=weight+seatwt;
     material:=material+(seatwt/2000)*angprop^.cost;
     angprop^.total:=angprop^.total+seatwt*mainform.joistsquantity.value;
     tcxr.length:=ingtodec(mainform.joiststcxr.value);
     tcxr.tcxtype:=mainform.JoiststcxrTY.Value;
     if livel=0 then
     begin
        tcxr.def:=120;
        tcxr.load:=load;
     end
     else
     begin
        tcxr.def:=180;
        tcxr.load:=livel;
     end;
     tcxr.depth:=inchtodec(MainForm.JoistsSeatsBDR.value);
     designTCX(tcxr);
     if tcxr.tcxtype='S' then
            tcxr.length:=ingtodec(MainForm.joistsseatlengthRE.value);
     if tcxr.tcxtype='R' then
            tcxr.length:=defaultseat+tcxr.length;
     if tcxr.tcxtype='RD' then
            tcxr.length:=tcxr.length+ingtodec(mainform.JoistsTCPanelsRE.value)+6;
     seatwt:=(tcxr.length/12)*angprop^.weight*2;
     weight:=weight+seatwt;
     material:=material+(seatwt/2000)*angprop^.cost;
     angprop^.total:=angprop^.total+seatwt*mainform.joistsquantity.value;
     Webs;
     {if not eccent('L') then
        MessageDlg('Eccentricity no good.', mtInformation,[mbOk], 0);}
     for x:=1 to anglist.count do
     begin
          angprop:=anglist.items[x-1];
          angprop^.tons:=angprop^.tons+angprop^.total;
     end;
     for x:=1 to rndlist.count do
     begin
          rndprop:=rndlist.items[x-1];
          rndprop^.tons:=rndprop^.tons+rndprop^.total;
     end;
     finally
     screen.cursor:=crdefault;
     end;
end;

procedure addjoint(x,y:single; p:string);
var
   stp1,stp2,add,angle:single;
begin
     if mainform.joistsshape.value='T' then
     begin
          stp1:=0;
          stp2:=0;
          add:=mainform.joistsscissoradd.value;
          if p='TC' then
          begin
             add:=add+ed;
             stp1:=depre;
             stp2:=deple;
          end;
          if x>cp then
          begin
             angle:=-cangle(cp,add,bl,stp1);
             y:=add+(x-cp)/cos(angle)*sin(angle);
          end
          else
          begin
              angle:=cangle(0,stp2,cp,add);
              y:=stp2+x/cos(angle)*sin(angle);
          end;
     end
     else
     if p='TC' then
     begin
          if x>cp then
          begin
             angle:=-cangle(cp,center,bl,depre);
             y:=center+(x-cp)/cos(angle)*sin(angle);
          end
          else
          begin
              angle:=cangle(0,deple,cp,center);
              if (depre<deple) and (cp=bl) then
                 y:=deple-x/cos(angle)*sin(angle)
              else
                  y:=deple+x/cos(angle)*sin(angle);
          end;
     end;
     New(JointData);
     JointList.add(jointdata);
     jointdata^.coordX:=x;
     jointdata^.coordY:=y;
     jointdata^.DeltaX:=0;
     jointdata^.DeltaY:=0;
     jointdata^.position:=p;
     lastx:=x;
end;

procedure addmember(j1,j2:integer; p:string);
begin
     New(membData);
     membdata^.force:=0;
     {membdata^.maxc:=0;
     membdata^.maxt:=0;
     membdata^.overst:=0;}
     MemberList.add(membdata);
     membdata^.joint1:=j1;
     membdata^.joint2:=j2;
     membdata^.position:=p;
     if (p='TC') or (p='BC') or (p='EP') or (p='NP') then
        membdata^.material:='D'
     else
         if rndweb then
            membdata^.material:='R'
         else
         begin
              if (p='W2') and not(jtype in jtype1) then
                 membdata^.material:='R'
              else
                  membdata^.material:='A';
         end;
end;

procedure calcBCL;
var
   d:single;
begin
     if not newBCL then
     begin
          if (jtype='K') or (jtype='C') then
          begin
               if depth<18 then
                  bcl:=19
               else
                   bcl:=48;
          end
          else
          begin
               d:=depth;
               if d>=72 then bcl:=144;
               if d<72 then bcl:=136;
               if d<68 then bcl:=128;
               if d<64 then bcl:=120;
               if d<60 then bcl:=112;
               if d<56 then bcl:=104;
               if d<52 then bcl:=96;
               if d<48 then bcl:=88;
               if d<44 then bcl:=80;
               if d<40 then bcl:=72;
               if d<36 then bcl:=64;
               if d<32 then bcl:=56;
               if d<28 then bcl:=48;
               if d<24 then bcl:=40;
               if d<20 then bcl:=36;
          end;
          if (bl/depth<5) and not rndweb then
          begin
               Bcl:=bcl/(depth/bl*10);
          end;
     end
     else
         bcl:=ingtodec(mainform.joistsbcpanel.value);
end;

function dogeometry:boolean;
var
   orsp,pp,w,x:integer;
   nconfig,intvert:boolean;
   Joisttype:string;
begin
     result:=false;
     if ingtodec(mainform.joistsbaselength.value)=0 then
        exit;
     try
     intvert:=true;
     halfpLE:=true; halfpRE:=true;
     nconfig:=false;
     joisttype:='';
     lastx:=0;
     //gap:=1;
     if not newg then
     with mainform do
     begin
          bcp:=joistsbcp.value;
          bcl:=ingtodec(mainform.joistsbcpanel.value);
          bcple:=ingtodec(joistsbcpanelsle.value);
          bcpre:=ingtodec(joistsbcpanelsre.value);
          tcple:=ingtodec(joiststcpanelsle.value);
          tcpre:=ingtodec(joiststcpanelsre.value);
          fdle:=ingtodec(joistsfirstdiagle.value);
          fdre:=ingtodec(joistsfirstdiagre.value);
          fhl:=fdle-bcple;
          fhr:=fdre-bcpre;
          deple:=joistsdepthle.value-(depth-ed);
          depre:=joistsdepthre.value-(depth-ed);
          cp:=ingtodec(joistsRidgeposition.value);
          if joistsshape.value='S' then
             center:=depre
          else
              center:=ed;
     end;
     mainform.closefile;
     bl:=ingtodec(mainform.joistsbaselength.value); wl:=bl-4;
     if newg then
     begin
          bcple:=0; bcpre:=0; tcple:=0; tcpre:=0;
          fhl:=0; fhr:=0; fdle:=0; fdre:=0;
          deple:=ed; depre:=ed; center:=ed;
          cp:=bl;
     end;
     if jtype in jtype2 then
     begin
          if (jtype='K') or (jtype='C') then
          begin
               if rndweb then
               begin
                  intvert:=false;
                  //gap:=0.5;
                  joisttype:='L1';
               end
               else
               begin
                    joisttype:='L2';
                    if depth<18 then
                       intvert:=false;
               end;
          end
          else
               joisttype:='LS';
          if newg then
          begin
               calcBCL;
               if rndweb then
               begin
                    if trunc(bl/bcl)<3 then
                       bcple:=rndprec(bl-bcl)/2
                    else
                        bcple:=rndprec(bl-(trunc(bl/bcl)-2)*bcl)/2;
                    tcple:=rndprec(bcple-bcl/2);
                    tcpre:=tcple;
               end
               else
               begin
                    if (jtype='K') or (jtype='C') then
                       bcple:=2*depth
                    else
                        bcple:=bcl/2*2.5;
               end;
               bcpre:=bcple;
               if rndweb then
               begin
                    if trunc(bl/bcl)<3 then
                       bcp:=1
                    else
                        bcp:=trunc(bl/bcl)-2;
               end
               else
               if trunc((bl-bcpre-bcple)/bcl)=((bl-bcpre-bcple)/bcl) then
                  bcp:=trunc((bl-bcpre-bcple)/bcl)
               else
                   bcp:=trunc((bl-bcpre-bcple)/bcl)+1;
               fhl:=rndprec(((bl-bcpre-bcple)-(bcl*(bcp-1)))/2); fhr:=fhl;
               fdle:=bcple+fhl; fdre:=bcpre+fhr;
               if not rndweb then
               begin
                    tcple:=rndprec(fdle/2)+1;
                    if (bcple-tcple)>bcl/2 then
                       tcple:=rndprec(bcple-bcl/2);
                    tcpre:=tcple;
               end;
          end;
     end
     else
     begin
          joisttype:='JG';
          if jtype='N' then
          begin
             nconfig:=true;
             jtype:='V';
          end;
          if newg then
          begin
               orsp:=sp;
               if jtype='V' then
                  sp:=sp-1;
               if jtype='B' then
               begin
                    if odd(sp) then
                    begin
                         sp:=trunc(sp/2)+1;
                         halfpRE:=false;
                    end
                    else
                        sp:=trunc(sp/2);
               end;
               if jtype='V' then
                  fdle:=rndprec(bl/(sp+1)*3/2)
               else
               begin
                   if halfpRE then
                       fdle:=rndprec(bl/sp)
                   else
                        fdle:=rndprec(bl/(sp*2-1)*2)
               end;
               if halfpRE then
                   fdre:=fdle
               else
                   fdre:=fdle/2;
               if sp=2 then
                  bcl:=bl-fdle
               else
                   bcl:=(bl-fdle-fdre)/(sp-2);
               if jtype='V' then
                    tcple:=rndprec(bl/(sp+1))
               else
                    tcple:=rndprec(bcl/2);
               tcpre:=tcple;
               bcple:=tcple; bcpre:=bcple;
               if halfpRE then
               begin
                    fhl:=fdle-tcple;
                    fhr:=fdre-tcpre;
               end
               else
               begin
                   fhl:=tcple;
                   fhr:=0;
                   fdre:=tcpre;
               end;
               bcp:=sp-1;
               sp:=orsp;
          end;
     end;
     if (fhr=0) and (bcpre=tcpre) then
        halfpRE:=false;
     if (fhl=0) and (bcple=tcple) then
        halfpLE:=false;
     w:=4;
     if bcp=1 then
        middle:=6
     else
         middle:=0;
     pp:=trunc(bcp*2+5);
     if bcp<1 then
        abort; {raise exception.create('Minimum of 1 BC Panels Required');}
     if (Panellist.count>0) and (not sppanels) then
     begin
          for x:=0 to (Panellist.count-1) do
          begin
               TCPanel:=PanelList.items[x];
               dispose(TCPanel);
          end;
          PanelList.clear;
     end;
     for x:=1 to pp do
     begin
          if x=1 then
             addjoint(2,ed,'TC');
          if x=2 then
          begin
               if halfpLE then
               begin
                  addjoint(tcple,ed,'TC');
                  addmember(JointList.count-1,JointList.count,'EP');
               end
               else
               begin
                    addmember(JointList.count,JointList.count+2,'EP');
               end;
          end;
          if x=3 then
          begin
               addjoint(bcple,0,'BC');
               if halfpLE then
                  addmember(JointList.count-2,JointList.count,'W2')
               else
                   addmember(JointList.count-1,JointList.count,'W2')
          end;
          if x=4 then
          begin
             if nconfig then
                lastx:=lastx+fhl
             else
                 addjoint(lastx+fhl,ed,'TC');
             if nconfig then
             begin
                  addmember(JointList.count-1,JointList.count+2,'NP');
                  addmember(JointList.count-1,JointList.count,'V1S');
             end
             else
             begin
                  if halfpLE then
                  begin
                       if bcp=1 then
                          addmember(JointList.count-2,JointList.count,'TC')
                       else
                           addmember(JointList.count-2,JointList.count,'NP');
                       addmember(JointList.count-2,JointList.count-1,'V1S');
                  end;
             end;
             if nconfig then
             begin
                addmember(JointList.count,JointList.count+1,'BC');
                addmember(JointList.count-1,JointList.count+1,'W3');
             end
             else
             begin
                  if halfpLE then
                  begin
                       addmember(JointList.count-1,JointList.count+1,'BC');
                       addmember(JointList.count-1,JointList.count,'W3');
                  end
                  else
                  begin
                       addmember(JointList.count-1,JointList.count+1,'BC');
                       addmember(JointList.count-1,JointList.count,'W3');
                  end;
             end
          end;
          if (x>4) and (x<pp-2) then
          begin
               if not sppanels then
               begin
                    New(tcpanel);
                    tcpanel^.length:=bcl/2;
                    panelList.add(tcpanel);
               end
               else
               begin
                    tcpanel:=panellist.items[x-5];
                    bcl:=tcpanel^.length*2;
               end;
               if odd(x) then
               begin
                    addjoint(lastx+(bcl/2),0,'BC');
                    if intvert then
                    begin
                         addjoint(lastx,ed,'TC');
                         if nconfig then
                         begin
                            if x>5 then
                            begin
                               addmember(JointList.count-2,JointList.count,'TC');
                               if x<round(pp/2)+2 then
                               begin
                                  addmember(JointList.count-2,JointList.count-1,'W'+inttostr(w));
                                  inc(w);
                               end
                               else
                               begin
                                    dec(w);
                                    if middle=0 then
                                    begin
                                         middle:=memberlist.count;
                                         if odd(sp) then
                                            dec(w);
                                    end;
                                    addmember(JointList.count-3,JointList.count,'W'+inttostr(w));
                               end;
                            end;
                            addmember(JointList.count-1,JointList.count+1,'BC');
                         end
                         else
                         begin
                              {if x=23 then
                              begin
                                   addmember(JointList.count-3,JointList.count,'TC');
                                   addmember(JointList.count-3,JointList.count-1,'W'+inttostr(w));
                              end
                              else}
                              begin
                                   addmember(JointList.count-2,JointList.count,'TC');
                                   addmember(JointList.count-2,JointList.count-1,'W'+inttostr(w));
                              end;
                         end;
                         addmember(JointList.count-1,JointList.count,'V2');
                    end
                    else
                    begin
                         addmember(JointList.count-1,JointList.count+1,'TC');
                         addmember(JointList.count-1,JointList.count,'W'+inttostr(w));
                    end;
               end
               else
               begin
                    if nconfig then
                       lastx:=lastx+(bcl/2)
                    else
                        addjoint(lastx+(bcl/2),ed,'TC');
                    if intvert then
                    begin
                         if not nconfig then
                         begin
                              addmember(JointList.count-2,JointList.count+1,'BC');
                              addmember(JointList.count-1,JointList.count,'TC');
                              addmember(JointList.count-2,JointList.count,'W'+inttostr(w));
                         end;
                    end
                    else
                    begin
                         addmember(JointList.count-1,JointList.count+1,'BC');
                         addmember(JointList.count-1,JointList.count,'W'+inttostr(w));
                    end;
                    {if x=22 then
                    begin
                         addjoint(1204.75,0,'BC');
                         membdata:=memberlist.items[57];
                         membdata^.joint2:=jointlist.count;
                         addmember(jointlist.count,jointlist.count+1,'BC');
                         addmember(jointlist.count-1,jointlist.count,'V2');
                    end;}
               end;
               if not nconfig then
               begin
                    if x<=trunc(pp/2)+1 then
                       inc(w);
                    if x>trunc(pp/2) then
                    begin
                       dec(w);
                       if middle=0 then
                          middle:=memberlist.count;
                    end;
               end;
          end;
          if x=pp-2 then
          begin
             addjoint(lastx+fhr,0,'BC');
             if halfpRE then
             begin
                  if bcp=1 then
                     addmember(JointList.count-1,JointList.count+1,'TC')
                  else
                      addmember(JointList.count-1,JointList.count+1,'NP');
                  if nconfig then
                     addmember(JointList.count-2,JointList.count+1,'W3')
                  else
                      addmember(JointList.count-1,JointList.count,'W3');
             end;
          end;
          if x=pp-1 then
          begin
             if halfpRE then
             begin
                  addjoint(bl-tcpre,ed,'TC');
                  addmember(JointList.count,JointList.count-1,'V1S');
             end;
          end;
          if x=pp then
          begin
             addjoint(bl-2,ed,'TC');
             if halfpRE then
             begin
                  addmember(JointList.count-1,JointList.count,'EP');
                  addmember(JointList.count-2,JointList.count,'W2');
             end
             else
             begin
                  addmember(JointList.count-1,JointList.count-2,'W3');
                  addmember(JointList.count-2,JointList.count,'EP');
                  addmember(JointList.count-1,JointList.count,'W2');
             end;
          end;
     end;
     getsupports;
     if bcp=1 then
     begin
          halfple:=false;
          halfpre:=false;
     end;
     if nconfig then
        jtype:='N';
     if JointList.count>nodes then
        abort;
     if newg then
     with mainform do
     begin
          if not newbcl then
             joistsbcpanel.value:=dectoing(bcl);
          joistsbcpanelsle.value:=dectoing(bcple);
          joistsbcpanelsre.value:=dectoing(bcpre);
          joiststcpanelsle.value:=dectoing(tcple);
          joiststcpanelsre.value:=dectoing(tcpre);
          joistsfirstdiagle.value:=dectoing(fdle);
          joistsfirstdiagre.value:=dectoing(fdre);
          joistsdepthle.value:=depth;
          joistsdepthre.value:=depth;
          joistsRidgeposition.value:=dectoing(bl);
          joistsshape.value:='P';
          joistsscissoradd.value:=0;
          joistsjoisttype.value:=joisttype;
          joistsbcp.value:=bcp;
          newg:=false;
     end;
     if (jtype='K') or (jtype='C') then
        joisttype:='K'
     else
         joisttype:='L';
     {if timestds.findkey([joisttype,index,bcp]) then
        manhrs:=timestdshours.value
     else
         manhrs:=0;}
     result:=true;
     except
           raise exception.create('Can''t do geometry');
     end;
end;

function dodescription:boolean;
var
   cc:integer;
   temp,temp2:string;
   found:boolean;
   rbl,a,b,c,d,e:single;
   bl1,bl2:integer;
begin
     result:=false;
     cc:=0; sp:=0; depth:=0; load:=0; livel:=0; index:='';
     jdesc:=uppercase(mainform.joistsdescription.value);
     rbl:=ingtodec(mainform.joistsbaselength.value)/12;
     bl1:=trunc(rbl);
     if bl1<rbl then
        bl2:=bl1+1
     else
         bl2:=bl1;
     temp:='0';
     while (temp<='9') and (temp>='0') and (cc<length(jdesc)) do
     begin
          inc(cc);
          temp:=copy(jdesc,cc,1);
     end;
     index:=copy(jdesc,1,cc-1);
     depth:=strtoint(index); delete(jdesc,1,cc-1); cc:=1;
     ed:=depth*0.965;
     while (temp<='Z') and (temp>='A') and (cc<length(jdesc)) do
     begin
          inc(cc);
          temp:=copy(jdesc,cc,1);
     end;
     temp2:=copy(jdesc,1,cc-1); delete(jdesc,1,cc-1); cc:=1;
     jtype:=' ';
     rndweb:=false;
     if (temp2='K') or (temp2='KCS') then
     begin
          jtype:='K';
          if depth<18 then
             rndweb:=true;
     end;
     if temp2='KA' then jtype:='K';
     if temp2='KCS' then jtype:='C';
     if temp2='LH' then jtype:='L';
     if temp2='DLH' then jtype:='D';
     if temp2='G' then jtype:='G';
     if temp2='BG' then jtype:='B';
     if temp2='VG' then jtype:='V';
     if temp2='NG' then jtype:='N';
     if temp2<>'K' then
        temp2:='L';
     if ((jtype='D') and (depth<52)) or ((jtype='L') and (depth>=52)) then
        exit;
     if jtype=' ' then exit;
     if jtype in jtype1 then
     begin
          while (temp<>'N') and (cc<length(jdesc)) do
          begin
               inc(cc);
               temp:=copy(jdesc,cc,1);
          end;
          sp:=strtoint(copy(jdesc,1,cc-1)); delete(jdesc,1,cc); cc:=1;
          while (temp<>'K') and (cc<length(jdesc)) do
          begin
               inc(cc);
               temp:=copy(jdesc,cc,1);
          end;
          load:=strtofloat(copy(jdesc,1,cc-1))*1000;
          livel:=20*(ingtodec(mainform.joistsbaselength.value)/12);
     end
     else
     begin
          while (temp<>'/') and (cc<length(jdesc)) do
          begin
               inc(cc);
               temp:=copy(jdesc,cc,1);
          end;
          if temp='/' then
          begin
             load:=strtofloat(copy(jdesc,1,cc-1));
             delete(jdesc,1,cc); cc:=1;
             livel:=strtofloat(jdesc);
          end
          else
              load:=strtofloat(copy(jdesc,1,cc));
          delete(jdesc,1,cc);
     end;
     if jtype='C' then
     begin
          with mainform do
          begin
               temp:=inttostr(trunc(load));
               //if not KCSJoists.findkey([index,temp]) then
               if not KCSJoists.Locate('Depth;Index',vararrayof([index,temp]),[]) then
                   exit;
               //load:=kcsjoistsmoment.value;
               livel:=kcsjoistsinertia.value;
               //minshr:=kcsjoistsshear.value;
               if LRFD then
               begin
                   load:=kcsjoistsmoment.value*1.5;
                   minshr:=kcsjoistsshear.value*1.5;
               end
               else
               begin
                   load:=kcsjoistsmoment.value;
                   minshr:=kcsjoistsshear.value;
               end;
          end
     end
     else
     begin
          if load<20 then
             temp:=inttostr(strtoint(index)*100+trunc(load))
          else
              temp:='0';
          //if mainform.SJICatlg.findkey([temp2,bl1,temp]) then
          if mainform.SJICatlg.Locate('Type;Span;Index',vararrayof([temp2,bl1,temp]),[]) then
          begin
               if bl1=bl2 then
               begin
                    load:=mainform.SJICatlgTotalLoad.value;
                    livel:=mainform.SJICatlgLiveLoad.value;
               end
               else
               begin
                    a:=bl1; b:=rbl; c:=bl2; d:=mainform.SJICatlgTotalLoad.value; bl1:=mainform.SJICatlgLiveLoad.value;
                    //if mainform.SJICatlg.findkey([temp2,bl2,temp]) then
                    if mainform.SJICatlg.Locate('Type;Span;Index',vararrayof([temp2,bl2,temp]),[]) then
                    begin
                         e:=mainform.SJICatlgTotalLoad.value;
                         load:=d-((a-b)/(a-c))*(d-e);
                         d:=bl1; e:=mainform.SJICatlgLiveLoad.value;
                         livel:=d-((a-b)/(a-c))*(d-e);
                    end
                    else
                    begin
                         load:=d;
                         livel:=bl1;
                    end;
               end;
               index:=temp;
          end
          else
          begin
               if load<20 then
               begin
                    //mainform.sjicatlg.IndexFieldNames:='Type;Index;Span';
                    //mainform.sjicatlg.setrange([temp2,temp,0],[temp2,temp,999]);
                    MainForm.SJICatlg.filter:='type = '''+temp2+''' and index = '''+temp+'''';
                    MainForm.SJICatlg.Filtered:=true;
                    if mainform.sjicatlg.RecordCount=0 then
                    begin
                         //mainform.sjicatlg.cancelrange;
                         MainForm.SJICatlg.Filtered:=false;
                         mainform.sjicatlg.IndexFieldNames:='Type;Span;Index';
                         exit;
                    end;
                    mainform.sjicatlg.First;
                    if bl2>mainform.sjicatlgspan.Value then
                       mainform.sjicatlg.last;
                    load:=mainform.SJICatlgTotalLoad.value;
                    livel:=mainform.SJICatlgLiveLoad.value;
                    //mainform.sjicatlg.cancelrange;
                    MainForm.SJICatlg.Filtered:=false;

                    mainform.sjicatlg.IndexFieldNames:='Type;Span;Index';
               end;
               //mainform.sjicatlg.setrange([temp2,bl2,index+'00'],[temp2,bl2,index+'99']);
               MainForm.SJICatlg.filter:='type = '''+temp2+''' and Span = '+inttostr(bl2)+' and index > '''+index+'00'' and index < '''+index+'99''';
               MainForm.SJICatlg.Filtered:=true;

               mainform.SjiCatlg.First; found:=false;
               while (not mainform.SJICatlg.eof) and (not found) do
               begin
                    if mainform.sjicatlgtotalload.value>=load then
                       found:=true
                    else
                        mainform.SJICatlg.next;
               end;
               index:=inttostr(mainform.sjicatlgindex.value);
               if livel=0 then
                  livel:=mainform.sjicatlgliveload.value;
               //mainform.sjicatlg.cancelrange;
               MainForm.SJICatlg.Filtered:=false;
          end;
     end;
     result:=true;
end;

procedure fillloads;
var
   temp:string;
   x:integer;

   procedure addload(desc:string; load,load2:single);
   begin
        New(loads);
        loadList.add(loads);
        loads^.desc:=desc;
        loads^.load:=load;
        loads^.load2:=load2;
   end;

begin
     if jtype in jtype2 then
     begin
          if jtype='C' then
          begin
             addload('Moment Capacity (inch-kips)',load,-1);
             addload('Gross Moment of Inertia (in^4)',livel,-1);
          end
          else
          begin
              if LRFD then
              begin
                //addload('Uniform Load in TC (plf)',1.4*(load-livel)+1.6*livel+mainform.joistsTCUniformLoad.value,-1);
                addload('Uniform Load in TC (plf)',1.5*(load)+mainform.joistsTCUniformLoad.value,-1);
                addload('Live Load (plf)',1.6*livel,-1);
              end
              else
              begin
                addload('Uniform Load in TC (plf)',load+mainform.joistsTCUniformLoad.value,-1);
                addload('Live Load (plf)',livel,-1);
              end;
          end;
     end
     else
     begin
          case jtype of
            'G':temp:='Load at Diagonals (lbs)';
            'B':temp:='Load at All (lbs)';
            'V':temp:='Load at Verticals (lbs)';
            'N':temp:='Load at All (lbs)';
          end;
          addload('Point '+temp,load,-1);
          if mainform.joistsTCUniformLoad.value>0 then
             addload('Uniform Load in TC (plf)',mainform.joistsTCUniformLoad.value,-1)
     end;
     if MainForm.JoistsAddLoad.Value>0 then
        addload('Add Load any PP (lbs)',MainForm.JoistsAddLoad.Value,-1);
     if mainform.joistsBCUniformLoad.value>0 then
        addload('Uniform Load in BC (plf)',mainform.joistsBCUniformLoad.value,-1);
     for x:=1 to partlist.count do
     begin
          partdata:=partlist.items[x-1];
          addload('Uniform in '+partdata^.position+' (plf)',partdata^.force,partdata^.force2);
     end;
     for x:=1 to conclist.count do
     begin
          concdata:=conclist.items[x-1];
          addload('Conc. Load '+concdata^.position+' (lbs)',concdata^.force,-1);
     end;
     with mainform do
     begin
          if joistsanypanel.value>0 then
             addload('Additional Shear in Webs',joistsanypanel.value,-1);
          if joistsnetuplift.value>0 then
          begin
               if LRFD then
               begin
                if jtype in jtype1 then
                    addload('Gross Uplift '+temp,joistsnetuplift.value,-1)
                 else
                     addload('Gross Uplift (plf)',joistsnetuplift.value,-1);
               end
               else
               begin
                 if jtype in jtype1 then
                    addload('Uplift '+temp,joistsnetuplift.value,-1)
                 else
                     addload('Net Uplift (plf)',joistsnetuplift.value,-1);
               end;
          end;
          if joistsanywhereTC.value>0 then
             addload('Additional Bending in TC (lbs)',joistsanywhereTC.value,-1);
          if joistsanywhereBC.value>0 then
             addload('Additional Bending in BC (lbs)',joistsanywhereBC.value,-1);
          if joistsTCAxialLoad.value>0 then
             addload('TC Axial Load (lbs)',joistsTCAxialLoad.value,-1);
          if joistsBCAxialLoad.value>0 then
             addload('BC Axial Load (lbs)',joistsBCAxialLoad.value,-1);
          if joistsfixedmomentLE.value>0 then
             addload('Fixed Moment LE (ft-lbs)',joistsfixedmomentLE.value,-1);
          if joistsfixedmomentRE.value>0 then
             addload('Fixed Moment RE (ft-lbs)',joistsfixedmomentRE.value,-1);
          if joistslateralmomentLE.value>0 then
             addload('Lateral Moment LE (ft-lbs)',joistslateralmomentLE.value,-1);
          if joistslateralmomentRE.value>0 then
             addload('Lateral Moment RE (ft-lbs)',joistslateralmomentRE.value,-1);
     end;
end;

procedure dorecalc;
begin
     mainform.casecombo.itemindex:=0;
     mainform.casedesc.items.clear;
     mainform.casedesc.items.add('Summary of All Cases');
     matselect;
     if jtype<>'C' then
        deflection;
     mainform.geometry.refresh;
     fillloads;
     joverst:=false;
end;

function JoistGenerate:boolean;
begin
     getpanels;
     if dodescription and dogeometry then
        result:=true
     else
         result:=false;
     getchords;
end;

end.
