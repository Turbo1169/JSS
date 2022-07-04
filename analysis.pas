unit Analysis;

interface

uses classes, dialogs, math, sysutils;

procedure solvesyst;
function fa(klr,Q:single):single;
function fcr(klr,Q:single):single;
function weld(p:single):single;
procedure docase1;
procedure docase2;
procedure docase3(f:single);
procedure docase4;
procedure docase5;
procedure docase6;
procedure docase7;
procedure docase8;
procedure docase1LRFD;
procedure docase2aLRFD;
procedure docase2bLRFD;
procedure docase3aLRFD;
procedure docase3bLRFD;
procedure docase4aLRFD;
procedure docase4bLRFD;
procedure docase5aLRFD;
procedure docase5bLRFD;
procedure docase6aLRFD;
procedure docase6bLRFD;
function weldlen(ang,d:single):single;
function findlen(r,p,a,q,l:single):single;
function checkTC(HasPlate:boolean=false):boolean;
function checkBC(HasPlate:boolean=false):boolean;
function eccent(side:char):boolean;
procedure deflection;
function addbending(uplift:boolean):single;
function addvcb:single;
function checkweb(gap2:single):boolean;

implementation

uses main;

var
   memb:integer;
   addshear:single;
   matrix:array[1..360,1..180] of single;
   matrix2:array[1..180] of single;

function ingtodec(ing:shortstring):single; external 'comlib.dll';
function cangle(x1,y1,x2,y2:single):single; external 'comlib.dll';
function clength(x1,y1,x2,y2:single):single; external 'comlib.dll';
function rndprec(decn:single):single; external 'comlib.dll';
function findint(var x1,y1:single; x2,y2,x3,y3,x4,y4:single):boolean; external 'comlib.dll';

procedure dooverst(var FunctReturn:boolean);
begin
     if plate>0 then
     begin
          plateweight:=plateweight+plate*1*3.4*membdata^.Length/12;
          membdata^.overst:=2;
     end
     else
         membdata^.overst:=1;

     // Common fail result return
     if FunctReturn then
        FunctReturn:=false;
end;

function addvcb:single;
var
        addbend,x1,x2:single;
        x:integer;
begin
     addbend:=0;
     jointdata:=jointlist.items[membdata.joint1-1];
     x1:=jointdata^.coordX;
     jointdata:=jointlist.items[membdata.joint2-1];
     x2:=jointdata^.coordX;
     for x:=1 to ConcList.Count do
     begin
        ConcData:=ConcList.Items[x-1];
        if ConcData^.Chord=JointData^.Position then
        if (ConcData^.Dist>x1) and (ConcData^.Dist<x2) and (concdata^.vcb) then
        begin
                addbend:=addbend+1.5*concdata^.Force/membdata^.Length*12;
        end;
     end;
     result:=addbend;
end;

function addbending(uplift:boolean):single;
var
   x:integer;
   xn1,x1,x2,wl,angle,addbend:single;
   chord:String[2];
begin
     addbend:=0;
     jointdata:=jointlist.items[membdata^.joint1-1];
     chord:=jointdata^.position;
     for x:=1 to partlist.count do
     begin
          partdata:=partlist.items[x-1];
          jointdata:=jointlist.items[partdata.joint1-1];
          x1:=jointdata^.coordX;
          jointdata:=jointlist.items[partdata.joint2-1];
          x2:=jointdata^.coordX;
          angle:=arctan(abs(partdata.Force-partdata.Force2)/(x2-x1));
          if partdata.Force<partdata.Force2 then
            xn1:=x1
          else
            xn1:=x2;
          jointdata:=jointlist.items[membdata^.joint2-1];
          x2:=jointdata^.coordX;
          jointdata:=jointlist.items[membdata^.joint1-1];
          x1:=jointdata^.coordX;
          if PartData.uplift=uplift then
          begin
                jointdata:=jointlist.items[partdata^.joint1-1];
                if jointdata^.position=chord then
                begin
                     if (membdata^.joint2<=partdata^.joint2) and (membdata^.joint1>=partdata^.joint1) then
                     begin
                        if partdata.Force<>partdata.Force2 then
                        begin
                              if partdata.Force>partdata.Force2 then
                              begin
                                      wl:=partdata.Force2;
                                      wl:=wl+tan(angle)*abs(x1-xn1);
                              end
                              else
                              begin
                                      wl:=partdata.Force;
                                      wl:=wl+tan(angle)*abs(x2-xn1);
                              end;
                        end
                        else
                              wl:=partdata.Force;
                        addbend:=addbend+wl
                     end;

                end;
          end;
     end;
     result:=addbend;
end;

function checkweb(gap2:single):boolean;
var
  mat:string;
  Ry,l,area,maxlr,tempc,tempt,Q:single;
  slend:boolean;
  mu,fbu,fau:single;
  fe,fez,fcrz,fcrx,tt:single;
  Ky:single;
  StressRatio:single;
  TensControlled:Boolean;
  ki,ls,klrym:single;
begin
    mat:=membdata^.Material;
    l:=membdata^.length;

    //re-calculate web length to clear length
    {if (membdata^.angle>0) and ((jtype='K') or (jtype='C')) then
    begin
       mainform.findangle(TCsection.section);
       l:=l-((angprop^.d-angprop^.Y)/sin(membdata^.angle));
       mainform.findangle(BCsection.section);
       l:=l-((angprop^.d-angprop^.Y)/sin(membdata^.angle));
    end;}

    //removed to meed new 43rd SJI specifications
    {if (membdata^.position='W3') and (mat='A') then
       k:=1.2;}

    if (jtype in jtype2) and (mat<>'D') then
    begin
        //single component members
        if (membdata^.position='W2') then
          Ky:=0.8
        else
          Ky:=0.9;
    end
    else
      Ky:=1;

    if (mat='A') or (mat='D') then
    begin
         //sji 43rd edition W3 Q value calculation
         if (mat='A') and ((membdata^.position='W3') or (membdata^.position='V1S')) then
         begin
            Q:=(5.25/(angprop^.b/angprop^.t))+angprop^.t;
            if Q>1 then
              Q:=1;
         end
         else
            Q:=angprop^.Q;

         area:=angprop^.area;
         if mat='D' then
         begin
            area:=area*2;
            maxlr:=l/angprop^.Rx*k;

            //Ry:=sqrt(((angprop^.Iy+angprop^.area*sqr(((gap2)/2)+angprop^.y))*2)/(angprop^.area*2));
            Ry:=sqrt((angprop^.Iy*2+area*sqr((gap2/2)+angprop^.y))/(angprop^.area*2));

            //modified 44th edition slenderness check
            if jtype in jtype1 then
              Ki:=1
            else
              Ki:=0.5;
            if l>96 then
              ls:=l/3
            else
              ls:=l/2;
            if (ls/angprop^.rz>40) then
            begin
              klrym:=Sqrt(Sqr(l/ry)+Sqr((Ki*ls)/angprop^.rz));
              if klrym>maxlr then
                maxlr:=klrym;
            end
            else
            begin
              //old slenderness check
              if Ky*l/ry>maxlr then
                maxlr:=Ky*l/ry;
            end;

            if ls/angprop^.rz>maxlr then
              maxlr:=ls/angprop^.rz;
         end
         else
         begin
              maxlr:=Ky*l/angprop^.Rx;
              if l/angprop^.rz*k>maxlr then
                 maxlr:=l/angprop^.rz*k;
         end;
    end
    else
    begin
         maxlr:=l/RndProp^.R;
         Q:=1;
         area:=rndprop^.area;
    end;
    slend:=false;

    if LRFD then
            tempc:=0.9*fcr(maxlr,Q)*area*overst
    else
            tempc:=0.6*fcr(maxlr,Q)*area*overst;


    if maxlr<=240 then
       slend:=true;
    tempt:=area*fb*overst;
    if ((jtype='K') or (jtype='C')) and (membdata^.position='W2') and (membdata^.material<>'D') then
    begin
         tempt:=tempt*0.9;
    end;
    if membdata^.maxc>0 then
    begin
         slend:=false;
         if maxlr<=200 then
            slend:=true
    end;
    
    membdata^.allowc:=tempc;
    membdata^.allowt:=tempt;

    StressRatio:=membdata^.maxt/tempt; //tension stress ratio
    if membdata^.maxc/tempc>StressRatio then
    begin
      StressRatio:=membdata^.maxc/tempc; //compression stress ratio
      TensControlled:=false;
    end
    else
      TensControlled:=true;

    if membdata^.maxt>membdata^.maxc then
       tempc:=membdata^.maxt
    else
        tempc:=membdata^.maxc;

    if (mat='A') or (mat='D') then
    begin
         membdata^.section:=angprop^.section;
         if angprop^.t>3/8 then
            membdata^.thick:=5/16;
         if angprop^.t>1/4 then
            membdata^.thick:=angprop^.t-1/16;
         if angprop^.t>3/16 then
            membdata^.thick:=3/16;
         if angprop^.t<=3/16 then
            membdata^.thick:=angprop^.t;
         tempt:=weldlen(membdata^.angle,angprop^.d)*2;
         mainform.findangle(membdata^.section);
    end
    else
    begin
         membdata^.section:=Rndprop^.section;
         membdata^.thick:=0.12*Rndprop^.d+0.11;
         tempt:=weldlen(membdata^.angle,rndprop^.d)*2;
         mainform.findrnd(membdata^.section);
    end;

    //modify tempc to be at least 50% of the controlling force web capacity
    if (TensControlled) and (tempc<membdata^.allowt*0.5) then
        tempc:=membdata^.allowt*0.5;
    if (not TensControlled) and (tempc<membdata^.allowc*0.5) then
        tempc:=membdata^.allowc*0.5;

    if LRFD then
        membdata^.weld:=tempc/(0.75*IfThen((mat='R'), 1.0, cos(pi/4))*2*AWeld*1000*membdata^.thick)
    else
        membdata^.weld:=tempc/(IfThen((mat='R'), 1.0, cos(pi/4))*AWeld*1000*membdata^.thick);

    if membdata^.weld<2 then
    begin
         membdata^.weld:=2;
         if mat='R' then
         begin
            if LRFD then
               membdata^.thick:=tempc/(0.75*cos(pi/4)*2*AWeld*1000*membdata^.weld)
            else
               membdata^.thick:=tempc/(cos(pi/4)*AWeld*1000*membdata^.weld);
         end
         else
             membdata^.thick:=angprop^.t;
    end;
    if tempt>membdata^.weld then
       result:=true
    else
    begin
        membdata^.thick:=angprop^.t;
        if LRFD then
           membdata^.weld:=tempc/(0.75*cos(pi/4)*2*AWeld*1000*membdata^.thick)
        else
           membdata^.weld:=tempc/(cos(pi/4)*AWeld*1000*membdata^.thick);
        if tempt>membdata^.weld then
           result:=true
        else
            result:=false;
    end;

    if (membdata^.allowc<membdata^.maxc) or (membdata^.allowt<membdata^.maxt) or (not slend) then
      result:=false;

    if (membdata^.maxt>0) and (membdata^.allowc<0.25*membdata^.maxt) and (jtype in jtype1) then
      result:=false;

    // Start new single member 1" check
    if (mat='A') and ((AngProp^.b=1) or (AngProp^.d=1)) then
    begin
      // tension check
      Mu:=0.5*membdata^.maxt*(gap/2-angprop^.Y);
      fbu:=Mu/(angprop^.Ix/angprop^.Y);
      fau:=membdata^.maxt/area;
      if (LRFD and (fau+fbu>0.9*Fy*1000)) or ((not LRFD) and (fau+fbu>0.6*Fy*1000)) then
        result:=false;

      // pp compression check
      fau:=membdata^.maxc/area;
      Mu:=0.5*membdata^.maxc*(gap/2-angprop^.Y);
      fbu:=Mu/(angprop^.Ix/angprop^.Y);
      if (LRFD and (fau+fbu>0.9*Fy*1000)) or ((not LRFD) and (fau+fbu>0.6*Fy*1000)) then
        result:=false;

      // mid-length check
      fe:=(sqr(pi)*E)/sqr(0.75*membdata^.Length/angprop^.Rx);
      fez:=(sqr(pi)*E)/sqr(membdata^.Length/angprop^.Rz);
      fcrz:=fcr(membdata^.Length/angprop^.Rz,angprop^.Q);
      fcrx:=fcr(0.75*membdata^.Length/angprop^.Rx,Q);
      if LRFD then
      begin
        if fau/(0.9*fcrz)>1 then
          result:=false;
        if fau/(0.9*fcrx)>=0.2 then
          tt:=fau/(0.9*fcrx)+8/9*((1.0*fbu/1000)/((1-(fau/1000/(0.9*fe)))*angprop^.Q*0.9*Fy))
        else
          tt:=fau/(2*0.9*fcrx)+((1.0*fbu/1000)/((1-(fau/1000/(0.9*fe)))*angprop^.Q*0.9*Fy));
        if tt>1 then
          result:=false;
      end
      else
      begin
        if fau/fcrz>1 then
          result:=false;
        if fau/fcrx>=0.2 then
          tt:=fau/fcrx+8/9*((1.0*fbu/1000)/((1-(1.67*fau/1000/fe))*angprop^.Q*Fy))
        else
          tt:=fau/(2*0.9*fcrx)+((1.0*fbu/1000)/((1-(1.67*fau/1000/fe))*angprop^.Q*Fy));
        if tt>1 then
          result:=false;
      end;
    end;
    // End new single member 1" check

    {if (membdata^.position='W3') and (mat='A') then
    begin
         if (jtype='L') or (jtype='D') then
            k:=0.75
         else
             k:=1;
    end;}
end;

function checkTC(HasPlate:boolean=false):boolean;
var
   bcbend,fbpp,fbmp,area:single;
   slend,found:boolean;
   y:integer;

   function Firstpanel(var EndP:endptype; rol:char):boolean;
   var
      l,k2:array[1..5] of single;
      m1,k1:array[1..5,1..2] of single;
      j:integer;
      e1,e2,e3,e4,e5,j1:single;
      panel:string;
   begin
        panel:='NP';
        if (rol='L') and (not halfpLE) then
           panel:='TC';
        if (rol='R') and (not halfpRE) then
           panel:='TC';
        mainform.findmemb('EP',rol);
        l[1]:=membdata^.length;
        mainform.findmemb(panel,rol);
        if angprop^.plate=0 then
           membdata^.weld:=0;
        endp.l:=membdata^.length;

        if not HasPlate then
          MembData^.overst:=0;

         if jtype='C' then
        begin
           if LRFD then
              endp.bending:=825
           else
              endp.bending:=550;
        end
        else
          endp.bending:=0;

        if (1.5*mainform.joistsanywhereTC.value/endp.l*12+addvcb) > endp.bending then
              endp.bending:=1.5*mainform.joistsanywhereTC.value/endp.l*12+addvcb;
        
        //if ((rndprec(membdata^.length)<=24) and ((jtype='K') or (jtype='C')) and (endp.bending=0)) or (panel='TC') then
        if (panel='TC') then
        begin
           endp.f:=0;
           result:=true;
           exit;
        end;
        endp.bending:=endp.bending+bending+addbending(false);
        l[2]:=membdata^.length;
        endp.f:=abs(membdata^.maxc/((realed-angprop^.y)/ed));
        endp.fa2:=endp.f/area;

        //endp.fe:=12*sqr(pi)*E*1000/(23*sqr(endp.l/angprop^.rx));
        endp.fe:=(sqr(pi)*(E*1000))/(sqr(endp.l/angprop^.rx));

        if angprop^.plate=0 then
           endp.fillers:=0;
        mainform.findmemb('TC',rol);
        l[3]:=membdata^.length;
        l[4]:=l[3]; l[5]:=l[3];
        for j:=1 to 5 do
        begin
          case j of
            1:k2[j]:=0.75/l[j];
          else
              k2[j]:=1/l[j];
          end;
        end;
        for j:=2 to 5 do
        begin
          j1:=k2[j-1]+k2[j];
          k1[j-1,2]:=k2[j-1]/j1;
          k1[j,1]:=k2[j]/j1;
        end;
        k1[1,1]:=-1;
        k1[5,2]:=0;
        for j:=1 to 5 do
        begin
          m1[j,2]:=endp.bending/12*sqr(l[j])/12;
          m1[j,1]:=-m1[j,2];
        end;
        m1[1,2]:=-m1[1,1]/2+m1[1,2];
        repeat
        for j:=2 to 5 do
        begin
          e2:=m1[j-1,2];
          e3:=m1[j,1];
          e1:=-(e2+e3);
          e4:=e1*k1[j-1,2];
          e5:=e1*k1[j,1];
          m1[j-1,1]:=m1[j-1,1]+e4/2;
          m1[j,2]:=m1[j,2]+e5/2;
          m1[j-1,2]:=e2+e4;
          m1[j,1]:=e3+e5;
        end;
        until (m1[5,1]=0) or (abs(e5/m1[5,1])<=0.000001);
        if endp.bending=0 then
        begin
             endp.mi:=0;
             endp.me:=0;
        end
        else
        begin
             endp.mi:=abs(sqr(endp.bending*l[2]/24-(m1[2,1]+m1[2,2])/l[2])/(endp.bending/12)/2+m1[2,1]);
             endp.me:=abs(m1[2,1]);
        end;
        endp.mpfb:=endp.mi*angprop^.y/(angprop^.ix*2);
        endp.ppfb:=endp.me*(angprop^.d-angprop^.y)/(angprop^.ix*2);
        endp.cm:=1-0.3*endp.fa2/endp.fe;

        if LRFD then
          endp.bratio:=(endp.cm*endp.mpfb)/((1-endp.fa2/endp.fe)*angprop^.Q*(Fy*0.9*1000))
        else
          endp.bratio:=(endp.cm*endp.mpfb)/((1-endp.fa2/endp.fe)*angprop^.Q*(Fy*0.6*1000));


        endp.lr:=endp.l/angprop^.rz;
        endp.fcr:=fcr(endp.lr,angprop^.q);
        if LRFD then
                endp.fa:=0.9*endp.fcr
        else
                endp.fa:=0.6*endp.fcr;

        if (endp.bratio+endp.fa2/endp.fa<=1*overst) and (endp.fa2+endp.ppfb<=fb*overst) and (endp.lr<120) then
           result:=true
        else
        begin
             endp.lr:=endp.l/angprop^.rx;
             endp.fcr:=fcr(endp.lr,angprop^.Q);
             if LRFD then
                endp.fa:=0.9*endp.fcr
             else
                endp.fa:=0.6*endp.fcr;

             mainform.findmemb('NP',rol);
             membdata^.weld:=1;
             endp.fillers:=1;
             if (endp.bratio+endp.fa2/endp.fa<=1*overst) and (endp.fa2+endp.ppfb<=fb*overst) and (endp.lr<120) then
                result:=true
             else
                 result:=false;
        end;
   end;

   function endpanel(var EndP:endptype; rol:char):boolean;
   var
      rfact,npl,intpl:single;
      panel:string;
   begin
        panel:='NP';
        if (rol='L') and (not halfpLE) then
           panel:='TC';
        if (rol='R') and (not halfpRE) then
           panel:='TC';
        mainform.findmemb(panel,rol); npl:=membdata^.length;
        if panel='TC' then
           membdata^.position:='TT';
        mainform.findmemb('TC',rol); intpl:=membdata^.length;
        if panel='TC' then
        begin
             mainform.findmemb('TT',rol);
             membdata^.position:=panel;
        end;
        mainform.findmemb('EP',rol);
        endp.l:=membdata^.length;

        if not HasPlate then
          MembData^.overst:=0;

        if jtype='C' then
        begin
           if LRFD then
              endp.bending:=825
           else
              endp.bending:=550;
        end
        else
          endp.bending:=0;

        if (bending+addbending(false)+1.5*mainform.joistsanywhereTC.value/endp.l*12+addvcb) > endp.bending then
            endp.bending:=bending+addbending(false)+1.5*mainform.joistsanywhereTC.value/endp.l*12+addvcb;

        endp.f:=abs(membdata^.maxc/((realed-angprop^.y)/ed));
        endp.fa2:=endp.f/area;
        
        //endp.fe:=12*sqr(pi)*E*1000/(23*sqr(endp.l/angprop^.rx));
        endp.fe:=(sqr(pi)*(E*1000))/(sqr(endp.l/angprop^.rx));

        if angprop^.plate=0 then
           endp.fillers:=0;
        if endp.bending=0 then
        begin
             endp.me:=0; endp.mi:=0;
        end
        else
        if npl<>intpl then
        begin
             endp.me:=endp.bending/12*sqr(endp.l)/4*((14*npl/endp.l+12*intpl/endp.l+
                 7*intpower(npl/endp.l,4)+12*intpl/endp.l*intpower(npl/endp.l,3)-
                 4*intpower(intpl/endp.l,3)*npl/endp.l)/(28*npl/endp.l+24*intpl/endp.l+
                 21*sqr(npl/endp.l)+24*npl/endp.l*intpl/endp.l));
             if endp.me>=endp.bending*sqr(endp.l)/24 then
                endp.mi:=0
             else
                 endp.mi:=endp.bending/12*sqr(endp.l)/8*sqr(1-24*endp.me/(endp.bending*sqr(endp.l)));
        end
        else
        begin
             endp.me:=endp.bending*sqr(endp.l)/96*((1+0.577*intpower(intpl/endp.l,3))/(1+0.865*(intpl/endp.l)));
             if intpl>2.803*endp.l then
                endp.mi:=0
             else
                 endp.mi:=endp.bending*sqr(endp.l)/96*sqr(1-24*endp.me/(endp.bending*sqr(endp.l)));
        end;
        endp.mpfb:=endp.mi*angprop^.y/(angprop^.ix*2);
        endp.ppfb:=endp.me*(angprop^.d-angprop^.y)/(angprop^.ix*2);
        endp.cm:=1-0.3*endp.fa2/endp.fe;

        if LRFD then
        begin
          endp.bratio:=(endp.cm*endp.mpfb)/((1-endp.fa2/endp.fe)*angprop^.Q*(Fy*0.9*1000));
        end
        else
        begin
          endp.bratio:=(endp.cm*endp.mpfb)/((1-endp.fa2/endp.fe)*angprop^.Q*(Fy*0.6*1000));
        end;

        endp.lr:=endp.l/angprop^.rz;
        rfact:=1;
        if (jtype='K') or (jtype='C') then
           rfact:=1/0.9;
        endp.fcr:=fcr(endp.lr,angprop^.Q);
        if LRFD then
                endp.fa:=0.9*endp.fcr
        else
                endp.fa:=0.6*endp.fcr;

        if angprop^.plate=0 then
           membdata^.weld:=0;
        if (endp.bratio+endp.fa2/endp.fa<=1/rfact*overst) and (endp.fa2+endp.ppfb<=fb/rfact*overst)
           and (endp.lr<120) then
           result:=true
        else
        begin
             endp.lr:=endp.l/angprop^.rx;
             endp.fcr:=fcr(endp.lr,angprop^.Q);
             if LRFD then
                endp.fa:=0.9*endp.fcr
             else
                endp.fa:=0.6*endp.fcr;

             if angprop^.plate=0 then
                membdata^.weld:=1;
             endp.fillers:=1;
             if (endp.bratio+endp.fa2/endp.fa<=1/rfact*overst) and (endp.fa2+endp.ppfb<=fb/rfact*overst)
                and (endp.lr<120) then
                result:=true
             else
                 result:=false;
        end;
   end;

   procedure intpcheck;
   var
      maxmp:single;
      maxp,x:integer;
      KCS_MomCap,KCS_w1,KCS_w2:single;
      c:integer;

      procedure docheck;
      var
         minlryy,actryy,stpctpp,stpctmp:single;
      begin
           if (membdata^.weld=1) and (angprop^.plate=0) then
              dec(TCSection.fillers);

           membdata^.weld:=0;

           TCsection.bending:=1.5*mainform.joistsanywhereTC.value/membdata^.length*12+addvcb;
           //if not ((rndprec(membdata^.length)<=24) and ((jtype='K') or (jtype='C'))) then
           TCsection.bending:=TCsection.bending+bending+addbending(false);

           //check bending in interior panels for KCS joists added in 44th edition
           if (jtype='C') then
           begin
              //use smaller of 2 calculated moments
              KCS_MomCap:=load*(1000/12);
              KCS_w1:=(8*KCS_MomCap)/Sqr((bl-4)/12);
              KCS_w2:=(2*minshr)/((bl-4)/12);
              if TCsection.bending<MinValue([KCS_w1,KCS_w2]) then
                  TCsection.bending:=MinValue([KCS_w1,KCS_w2]);
           end;

           if angprop^.plate>0 then
              c:=1
           else
              c:=0;

           found:=false;
           while (not found) and (c<=1) do
           begin

               TCSection.lrx:=membdata^.length/angprop^.Rx*k;

               TCSection.lrz:=(membdata^.length/2)/angprop^.Rz*k;

               if c=0 then
                       TCSection.lrz:=(membdata^.length)/angprop^.Rz*k
               else
                       TCSection.lrz:=(membdata^.length/2)/angprop^.Rz;

               TCSection.lrmax:=TCSection.lrx;
               if TCSection.lryy>TCSection.lrmax then
                  TCSection.lrmax:=TCSection.lryy;
               if TCSection.lrz>TCSection.lrmax then
                  TCSection.lrmax:=TCSection.lrz;
               TCSection.ppmom:=TCsection.bending*sqr(membdata^.length/12);
               TCSection.ppfb:=(TCSection.ppmom*(angprop^.d-angprop^.y))/(angprop^.Ix*2);
               TCSection.mpmom:=((TCsection.bending*sqr(membdata^.length/12))/24)*12;
               TCSection.mpfb:=(TCSection.mpmom*angprop^.y)/(angprop^.Ix*2);
               TCSection.fcr:=fcr(TCSection.lrmax,angprop^.Q);
               if LRFD then
                  TCSection.fa:=0.9*TCSection.fcr
               else
                  TCSection.fa:=0.6*TCSection.fcr;
                  
               if jtype in jtype1 then
               begin
                    minlryy:=575;
                    actryy:=wl/TCSection.ryy;
               end
               else
               begin
                    //from sji 43rd edition
                    minlryy:=MinValue([170, 124+0.67*depth+28*(depth/bl*12)]);
                    actryy:=TCSection.lryy;
               end;
               if (TCSection.lrmax<=90) and (actryy<minlryy) then
                  slend:=true
               else
                   slend:=false;
               TCSection.fa2:=abs(membdata^.maxc/area);
               TCSection.weld:=weld(membdata^.maxc);

               //TCSection.fe:=(12*sqr(pi)*(E*1000))/(23*sqr(TCSection.lrx));
               TCSection.fe:=(sqr(pi)*(E*1000))/(sqr(TCSection.lrx));

               TCSection.cm:=1-(0.4*TCSection.fa2)/TCSection.fe;
               if LRFD then
                  TCSection.bratio:=(TCSection.cm*TCSection.mpfb)/((1-TCSection.fa2/TCSection.fe)*angprop^.Q*(Fy*0.9*1000))
               else
                  TCSection.bratio:=(TCSection.cm*TCSection.mpfb)/((1-TCSection.fa2/TCSection.fe)*angprop^.Q*(Fy*0.6*1000));

               if tcsection.bending>0 then
               begin
                    if LRFD then
                    begin
                       TCSection.mlf:=mainform.solvefa(0.9*fcr(TCSection.lrmax,angprop^.Q),TCsection)*area;
                       TCSection.mlnf:=mainform.solvefa(0.9*fcr(membdata^.length/angprop^.Rz*k,angprop^.Q),TCsection)*area;
                    end
                    else
                    begin
                       TCSection.mlf:=mainform.solvefa(0.6*fcr(TCSection.lrmax,angprop^.Q),TCsection)*area;
                       TCSection.mlnf:=mainform.solvefa(0.6*fcr(membdata^.length/angprop^.Rz*k,angprop^.Q),TCsection)*area;
                    end;
               end
               else
               begin
                    if LRFD then
                     begin
                        tcsection.mlf:=0.9*fcr(TCSection.lrmax,angprop^.Q)*area;
                        tcsection.mlnf:=0.9*fcr(membdata^.length/angprop^.Rz*k,angprop^.Q)*area;
                     end
                     else
                     begin
                        tcsection.mlf:=0.6*fcr(TCSection.lrmax,angprop^.Q)*area;
                        tcsection.mlnf:=0.6*fcr(membdata^.length/angprop^.Rz*k,angprop^.Q)*area;
                     end;
               end;
               if angprop^.plate>0 then
                  tcsection.mlnf:=tcsection.mlf;

               // ASD modification
               if slend and (abs(TCSection.Fa2+TCSection.ppfb)<=fb*overst) then
               begin
                       if (TCSection.fa2/TCSection.fa)>=0.2 then
                          found:=((TCSection.fa2/TCSection.fa)+(8/9)*TCSection.bratio<=1*overst)
                       else
                          found:=((TCSection.fa2/(2*TCSection.fa))+TCSection.bratio<=1*overst);
               end;

               if not found then
                    inc(c);
           end;

           stpctpp:=(abs(TCSection.Fa2+TCSection.ppfb))/(fb*overst);
           stpctmp:=(abs(TCSection.Fa2/TCSection.Fa)+TCSection.bratio)/overst;
           if stpctpp<stpctmp then
              stpctpp:=stpctmp;

           {if ((stpctpp>=maxmp) or ((c>0) and (TCSection.fillers=0)) or (angprop^.plate>0) ) and (not ((c=0) and (TCSection.fillers>0))) then
           begin
                maxmp:=stpctpp;
                maxp:=x;
           end;
           if (c>0) and (membdata^.weld=0) and (angprop^.plate=0) then
           begin
                membdata^.weld:=1;
                inc(TCSection.fillers);
           end;}

           if stpctpp>=maxmp then
           begin
                maxmp:=stpctpp;
                maxp:=x;
           end;
           if (membdata^.maxc>tcsection.mlnf) then
           begin
                membdata^.weld:=1;
                inc(TCSection.fillers);
           end;
      end;

   begin
        if angprop^.plate=0 then
           TCSection.fillers:=0;
        TCSection.sl:=angprop^.ix/angprop^.y;
        TCSection.ss:=angprop^.ix/(angprop^.d-angprop^.y);
        TCSection.lryy:=ifThen((jtype in jtype2),0.94,1)*latsup/TCSection.Ryy;
        maxmp:=0; maxp:=0;
        for x:=1 to memberlist.count do
        begin
           membdata:=memberlist.items[x-1];
           if membdata^.position='TC' then
           begin
                found:=true;

                if not HasPlate then
                  MembData^.overst:=0;

                if angprop^.plate=0 then
                   membdata^.weld:=0;
                docheck;
                if not found then
                   dooverst(result);
           end;
        end;
        membdata:=memberlist.items[maxp-1];
        found:=true;
        docheck;
        if not found then
           dooverst(result);
        tcsection.maxintp:=membdata^.length;
        tcsection.maxforce:=membdata^.maxc;
   end;

begin
     //if (jtype='L') or (jtype='D') then
     if jtype in jtype2 then
        k:=0.75
     else
        k:=1;
     tcsection.tenst:=0;
     area:=angprop^.area*2;
     if angprop^.plate=0 then
        TCSection.Ryy:=sqrt(((angprop^.Iy+angprop^.area*sqr((gap/2)+angprop^.x))*2)/area)
     else
     begin
          tcsection.Ryy:=sqrt(angprop^.iy/area);
          area:=area-angprop^.plate*(1-36/50);
     end;

     result:=mainform.chkshear(TCSection, 'TC');
     intpcheck;

     if not endpanel(endPL,'L') then
        dooverst(result);
     if not endpanel(endPR,'R') then
        dooverst(result);
     if not firstpanel(firstPL,'L') then
        dooverst(result);
     if not firstpanel(firstPR,'R') then
        dooverst(result);

     if (jtype in jtype1) and (MainForm.GirderBearingCapacity<maxPointLoad/2) then
        result:=false;

     if TCSection.maxforce2>0 then
     begin
          for y:=1 to memberlist.count do
          begin
               membdata:=memberlist.items[y-1];
               if (membdata^.position='TC') or (membdata^.position='EP') or (membdata^.position='NP') then
               begin
                    found:=false;
                     bcbend:=bending+addbending(false)+mainform.joiststcuniformload.value+
                      1.5*mainform.joistsanywhereTC.value/membdata^.length*12+addvcb;
                    fbmp:=(bcbend*sqr(membdata^.length/12)/2);
                    fbpp:=(bcbend*sqr(membdata^.length/12));
                    fbmp:=fbmp*(angprop^.y/(angprop^.ix*2))/fb;
                    fbpp:=fbpp*((angprop^.d-angprop^.y)/(angprop^.ix*2))/fb;
                    if (membdata^.maxt/area)/fb+fbpp>tcsection.tenst then
                       tcsection.tenst:=(membdata^.maxt/area)/fb+fbpp;
                    if (membdata^.maxt/area)/fb+fbmp>tcsection.tenst then
                       tcsection.tenst:=(membdata^.maxt/area)/fb+fbmp;
                    if ((membdata^.maxt/area)/fb+fbpp<=1*overst) and
                       ((membdata^.maxt/area)/fb+fbmp<=1*overst) then
                       found:=true;
                    if not found then
                       dooverst(result);
               end;
          end;
     end;
end;

function checkBC(HasPlate:boolean=false):boolean;
var
   maxmp,fbpp,fbmp,sl,area:single;
   maxp,x:integer;
   slend,found:boolean;

   procedure docheck;
   var
      stpctpp,stpctmp:single;
   begin
        if (membdata^.weld=1) and (angprop^.plate=0) then
           dec(BCSection.fillers);
        bcsection.bending:=mainform.joistsbcuniformload.value+addbending(false)+
                 1.5*mainform.joistsanywhereBC.value/membdata^.length*12+addvcb;
        if (mainform.joistsnetuplift.value>bcsection.bending) and (jtype in jtype2) then
              bcsection.bending:=mainform.joistsnetuplift.value*0.75;
        bcsection.lrx:=membdata^.length/angprop^.Rx*k;
        bcsection.lrz:=(membdata^.length/2)/angprop^.Rz;
        bcsection.ppmom:=bcsection.bending*sqr(membdata^.length/12);
        bcsection.ppfb:=(bcsection.ppmom*(angprop^.d-angprop^.y))/(angprop^.Ix*2);
        bcsection.mpmom:=((bcsection.bending*sqr(membdata^.length/12))/24)*12;
        bcsection.mpfb:=(bcsection.mpmom*angprop^.y)/(angprop^.Ix*2);
        bcsection.lrmax:=bcsection.lrx;
        if bcsection.lryy>bcsection.lrmax then
           bcsection.lrmax:=bcsection.lryy;
        if bcsection.lrz>bcsection.lrmax then
           bcsection.lrmax:=bcsection.lrz;

        bcsection.fcr:=fcr(bcsection.lrmax,angprop^.Q);
        if LRFD then
           bcsection.fa:=0.9*bcsection.fcr
        else
           bcsection.fa:=0.6*bcsection.fcr;

        if (bcsection.lrmax<=200) then
           slend:=true
        else
            slend:=false;
        bcsection.fa2:=abs(membdata^.maxc/area);
        bcsection.weld:=weld(membdata^.maxc);

        //bcsection.fe:=(12*sqr(pi)*(E*1000))/(23*sqr(k*bcsection.lrx));
        bcsection.fe:=(sqr(pi)*(E*1000))/(sqr(bcsection.lrx));

        bcsection.cm:=1-(0.4*bcsection.fa2)/bcsection.fe;

        if LRFD then
          bcsection.bratio:=(bcsection.cm*bcsection.mpfb)/((1-bcsection.fa2/bcsection.fe)*angprop^.Q*(Fy*0.9*1000))
        else
          bcsection.bratio:=(bcsection.cm*bcsection.mpfb)/((1-bcsection.fa2/bcsection.fe)*angprop^.Q*(Fy*0.6*1000));

        if bcsection.bending>0 then
        begin
          if LRFD then
          begin
             bcsection.mlf:=mainform.solvefa(0.9*fcr(bcsection.lrmax,angprop^.Q),bcsection)*area;
             bcsection.mlnf:=mainform.solvefa(0.9*fcr(membdata^.length/angprop^.Rz*k,angprop^.Q),bcsection)*area;
          end
          else
          begin
             bcsection.mlf:=mainform.solvefa(0.6*fcr(bcsection.lrmax,angprop^.Q),bcsection)*area;
             bcsection.mlnf:=mainform.solvefa(0.6*fcr(membdata^.length/angprop^.Rz*k,angprop^.Q),bcsection)*area;
          end;
        end
        else
        begin
          if LRFD then
          begin
             bcsection.mlf:=0.9*fcr(bcsection.lrmax,angprop^.Q)*area;
             bcsection.mlnf:=0.9*fcr(membdata^.length/angprop^.Rz*k,angprop^.Q)*area;
          end
          else
          begin
             bcsection.mlf:=0.6*fcr(bcsection.lrmax,angprop^.Q)*area;
             bcsection.mlnf:=0.6*fcr(membdata^.length/angprop^.Rz*k,angprop^.Q)*area;
          end;
        end;

        if angprop^.plate>0 then
           bcsection.mlnf:=bcsection.mlf;
        if (bcsection.mlf>=membdata^.maxc) and slend and (abs(BCSection.Fa2+BCSection.ppfb)<=fb*overst) then
        begin
           if (bcsection.bending>0) and ((bcsection.fa2/bcsection.fa)+bcsection.bratio>1*overst) then
              found:=false;
        end
        else
            found:=false;
        stpctpp:=(abs(BCSection.Fa2+BCSection.ppfb))/(fb*overst);
        stpctmp:=(abs(BCSection.Fa2/BCSection.Fa)+BCSection.bratio)/overst;
        if stpctpp<stpctmp then
           stpctpp:=stpctmp;
        if stpctpp>=maxmp then
        begin
             maxmp:=stpctpp;
             maxp:=x;
        end;
        if membdata^.maxc>bcsection.mlnf then
        begin
             membdata^.weld:=1;
             inc(bcsection.fillers);
        end;
   end;

begin
    if jtype in jtype2 then
        k:=0.9
     else
        k:=1;

     result:=true;
     bcsection.tenst:=0;
     if angprop^.plate=0 then
        bcsection.fillers:=0;
     area:=angprop^.area*2;
     if angprop^.plate=0 then
        bcsection.Ryy:=sqrt(((angprop^.Iy+angprop^.area*sqr((gap/2)+angprop^.x))*2)/area)
     else
     begin
         bcsection.Ryy:=sqrt(angprop^.iy/area);
         area:=area-angprop^.plate*(1-36/50);
     end;
     bcsection.sl:=angprop^.ix/angprop^.y;
     bcsection.ss:=angprop^.ix/(angprop^.d-angprop^.y);
     maxmp:=0; maxp:=0;

     result:=mainform.chkshear(BCsection, 'BC');

     for x:=1 to memberlist.count do
     begin
          found:=true;
          membdata:=memberlist.items[x-1];
          if membdata^.position='BC' then
          begin
               if not HasPlate then
                  MembData^.overst:=0;

               sl:=membdata^.length/angprop^.Rx;
               if sl<=240 then
                  slend:=true
               else
                   slend:=false;
               bcsection.bending:=mainform.joistsbcuniformload.value+addbending(false)+
                        1.5*mainform.joistsanywhereBC.value/membdata^.length*12+addvcb;
               fbmp:=(bcsection.bending*sqr(membdata^.length/12)/2);
               fbpp:=(bcsection.bending*sqr(membdata^.length/12));
               fbmp:=fbmp*(angprop^.y/(angprop^.ix*2))/fb;
               fbpp:=fbpp*((angprop^.d-angprop^.y)/(angprop^.ix*2))/fb;
               if (membdata^.maxt/area)/fb+fbpp>bcsection.tenst then
                  bcsection.tenst:=(membdata^.maxt/area)/fb+fbpp;
               if (membdata^.maxt/area)/fb+fbmp>bcsection.tenst then
                  bcsection.tenst:=(membdata^.maxt/area)/fb+fbmp;
               if ((membdata^.maxt/area)/fb+fbpp<=1*overst) and ((membdata^.maxt/area)/fb+fbmp<=1*overst) and
                  slend then
               begin
                    latsup2:=120;
                    if BCSection.Ryy<=latsup2/240 then
                       found:=false;
               end
               else
                   found:=false;

               //bcsection.lryy:=latsup2/bcsection.Ryy;
               BCSection.lryy:=ifThen((jtype in jtype2),0.94,1)*latsup2/bcsection.Ryy;

               if not found then
                  dooverst(result);
               if membdata^.maxc>0 then
               begin
                    if angprop^.plate=0 then
                       membdata^.weld:=0;
                    docheck;
               end;

               if not found then
                  dooverst(result);
          end;
     end;

     if bcsection.maxforce2>0 then
     begin
          membdata:=memberlist.items[maxp-1];
          found:=true;
          docheck;
          if not found then
             dooverst(result);
          bcsection.maxintp:=membdata^.length;
          bcsection.maxforce2:=membdata^.maxc;

          latsup2:=findlen(bcsection.ryy,bcsection.maxforce2,area,angprop^.q,12000);
          if BCSection.Ryy*240<latsup2 then
            latsup2:=BCSection.Ryy*240;

     end
     else
        latsup2:=BCSection.Ryy*240;
end;

function findlen(r,p,a,q,l:single):single;
var
   l1,z1,z2:single;
begin
     l1:=0; z1:=1; z2:=1;
     while (abs(z1)>0.01) and (abs(z2)>0.01) and ((l>0) or (l1>0)) do
     begin
          z1:=fa(l1/r,q)-p/a;
          z2:=fa(l/r,q)-p/a;
          if abs(z1)<abs(z2) then
          begin
               if ((z1<0) and (z2<0)) or ((z1>0) and (z2>0)) then
               begin
                  if z1<0 then
                     l:=l1-abs(l1-l)/2
                  else
                      l:=l1+abs(l1-l)/2;
               end
               else
               if l>l1 then
                  l:=l-(l-l1)/2
               else
                   l:=l+(l1-l)/2;
          end
          else
          begin
               if ((z1<0) and (z2<0)) or ((z1>0) and (z2>0)) then
               begin
                    if z1<0 then
                       l1:=l-abs(l1-l)/2
                    else
                        l1:=l+abs(l1-l)/2
               end
               else
               if l1>l then
                  l1:=l1-(l1-l)/2
               else
                   l1:=l1+(l-l1)/2;
          end;
          if l1<0 then
             l1:=0;
          if l<0 then
             l:=0;
     end;
     if abs(z1)>abs(z2) then
        result:=l
     else
         result:=l1;
end;

function findecc(node:integer):single;
type
    membt=record
      angle,q,x1,y1,x2,y2:single;
      Material:string[1];
      Section:string[2];
    end;
var
   x,c:integer;
   tvert,vert:single;
   memb:array[1..3] of membt;
begin
     c:=0;
     for x:=1 to memberlist.count do
     begin
          membdata:=memberlist.items[x-1];
          if ((membdata^.joint1=node) or (membdata^.joint2=node)) and
             ((copy(membdata^.position,1,1)='W') or (copy(membdata^.position,1,1)='V')) then
          begin
               inc(c);
               memb[c].material:=membdata^.material;
               memb[c].section:=membdata^.section;
               memb[c].angle:=membdata^.angle;
               if membdata^.material='D' then
                  memb[c].q:=2
               else
                   memb[c].q:=1;
               jointdata:=jointlist.items[membdata^.joint1-1];
               memb[c].x1:=jointdata^.coordx;
               memb[c].y1:=jointdata^.coordy;
               jointdata:=jointlist.items[membdata^.joint2-1];
               memb[c].x2:=jointdata^.coordx;
               memb[c].y2:=jointdata^.coordy;
          end;
     end;
     if memb[2].material='R' then
     begin
          mainform.findrnd(memb[2].section);
          vert:=(rndprop^.d/2)*sin(memb[2].angle);
     end
     else
     begin
          mainform.findangle(memb[2].section);
          vert:=(angprop^.d/2)*sin(memb[2].angle);
     end;
     tvert:=vert;
     if memb[2].q<>memb[1].q then
        vert:=0;
     if memb[1].material='R' then
     begin
          mainform.findrnd(memb[1].section);
          if memb[1].x1<memb[1].x2 then
             memb[1].x2:=memb[1].x2-vert-(rndprop^.d/2)*sin(memb[1].angle)
          else
              memb[1].x2:=memb[1].x2+vert+(rndprop^.d/2)*sin(memb[1].angle);
     end
     else
     begin
          mainform.findangle(memb[1].section);
          if memb[1].x1<memb[1].x2 then
             memb[1].x2:=memb[1].x2-vert-(angprop^.d/2)*sin(memb[1].angle)
          else
              memb[1].x2:=memb[1].x2+vert+(angprop^.d/2)*sin(memb[1].angle);
     end;
     memb[1].angle:=cangle(memb[1].x1,memb[1].y1,memb[1].x2,memb[1].y2);
     vert:=tvert;
     if memb[2].q<>memb[3].q then
        vert:=0;
     if memb[3].material='R' then
     begin
          mainform.findrnd(memb[3].section);
          if memb[3].x1<memb[3].x2 then
             memb[3].x1:=memb[3].x1+vert+(rndprop^.d/2)*sin(memb[3].angle)
          else
              memb[3].x1:=memb[3].x1-vert-(rndprop^.d/2)*sin(memb[3].angle);
     end
     else
     begin
          mainform.findangle(memb[3].section);
          if memb[3].x1<memb[3].x2 then
             memb[3].x1:=memb[3].x1+vert+(angprop^.d/2)*sin(memb[3].angle)
          else
              memb[3].x1:=memb[3].x1-vert-(angprop^.d/2)*sin(memb[3].angle);
     end;
     memb[3].angle:=cangle(memb[3].x1,memb[3].y1,memb[3].x2,memb[3].y2);
     findint(memb[1].x1,memb[1].y1,memb[1].x2,memb[1].y2,memb[3].x1,memb[3].y1,memb[3].x2,memb[3].y2);
     result:=abs(memb[1].y1);
end;

function eccent(side:char):boolean;
type
    ecct=record
      section,position:string[3];
      result,il,mom,ix,force,angle,length:single;
    end;
var
   jointn,c,c1,x:integer;
   m:array[1..5] of ecct;
   fa2,fe,ecc,fb2,ma,e1,e2,ab:single;
begin
     result:=false;
     ecc:=findecc(3);
     mainform.findangle(bcsection.section);
     if rndweb then
     begin
          if ecc<angprop^.b*0.75 then
          begin
               result:=true;
               exit;
          end;
     end
     else
     begin
          if ecc<angprop^.y then
          begin
               result:=true;
               exit;
          end;
     end;
     case side of
     'L':c:=0;
     else
       c:=jointlist.count-1;
     end;
     jointdata:=jointList.items[c];
     while not (jointdata^.position='BC') do
     begin
          case side of
          'L':inc(c)
            else
            dec(c);
          end;
          jointdata:=jointList.items[c];
     end;
     jointn:=c+1; c:=0; c1:=0;
     for x:=0 to memberlist.count-1 do
     begin
          case side of
               'L':membdata:=MemberList.items[x];
          else
              membdata:=MemberList.items[memberlist.count-1-x];
          end;
          if (membdata^.joint1=jointn) or (membdata^.joint2=jointn) then
          begin
               if membdata^.position<>'BC' then
               begin
                    if c1=0 then
                    begin
                         inc(c1);
                         m[c1].length:=jointdata^.coordx-ingtodec(mainform.joistsbcxl.value);
                         m[c1].force:=0;
                         m[c1].position:='BC';
                         m[c1].angle:=0;
                         m[c1].Section:=BCSection.section;
                    end;
                    inc(c);
                    m[c+2].length:=membdata^.length;
                    m[c+2].angle:=pi/2-membdata^.angle;
                    m[c+2].position:=membdata^.position;
                    if c>1 then
                       m[c+2].force:=-membdata^.maxc
                    else
                        m[c+2].force:=membdata^.maxt;
                    m[c+2].section:=membdata^.section;
                    if membdata^.material='R' then
                    begin
                         mainform.findrnd(membdata^.section);
                         m[c+2].ix:=angprop^.ix;
                    end
                    else
                    begin
                         mainform.findangle(membdata^.section);
                         if membdata^.material='D' then
                            m[c+2].ix:=angprop^.ix*2
                         else
                             m[c+2].ix:=sqr(angprop^.rz)*angprop^.area;
                    end;
               end
               else
               begin
                   inc(c1);
                   m[c1].length:=membdata^.length;
                   m[c1].angle:=pi/2-membdata^.angle;
                   m[c1].position:=membdata^.position;
                   m[c1].force:=membdata^.maxt;
                   m[c1].section:=BCSection.section;
               end;
          end;
     end;
     mainform.findangle(BCSection.section);
     m[1].ix:=angprop^.ix*2;
     m[2].ix:=m[1].ix;
     e1:=ecc*cos(m[4].angle)*(tan(m[5].angle)+tan(m[4].angle));
     e2:=ecc*cos(m[3].angle)*(tan(m[5].angle)+tan(m[3].angle));
     ma:=m[3].force*e2+m[4].force*e1;
     ab:=0;
     for x:=1 to 5 do
     begin
          m[x].il:=m[x].ix/m[x].length;
          ab:=ab+m[x].il;
     end;
     for x:=1 to 5 do
     begin
          m[x].il:=m[x].il/ab;
          m[x].mom:=ma*m[x].il;
          if x=1 then
          begin
               fb2:=m[x].mom*(angprop^.y)/(2*angprop^.ix);
               m[x].result:=fb2;
          end;
          if x=2 then
          begin
               fb2:=m[x].force/(2*angprop^.area)+m[x].mom*(angprop^.b-angprop^.y)/(2*angprop^.ix);
               m[x].result:=fb2;
          end;
          if x>2 then
          begin
               mainform.findmemb(m[x].position,'L');
               if m[x].force>0 then
               begin
                    if membdata^.material='R' then
                    begin
                         mainform.findrnd(m[x].section);
                         fb2:=m[x].force/(rndprop^.area)+m[x].mom*(rndprop^.d/2)/(rndprop^.i);
                    end
                    else
                    begin
                         mainform.findangle(m[x].section);
                         if membdata^.material='D' then
                            fb2:=m[x].force/(2*angprop^.area)+m[x].mom*(angprop^.b-angprop^.y)/(2*angprop^.ix)
                         else
                             fb2:=m[x].force/(angprop^.area)+m[x].mom*(angprop^.b-angprop^.y)/(angprop^.ix);
                    end;
                    m[x].result:=fb2;
               end
               else
               begin
                    m[x].force:=abs(m[x].force);
                    if membdata^.material='D' then
                    begin
                         mainform.findangle(m[x].section);
                         fa2:=fa(k*m[x].length/2/angprop^.rx,angprop^.Q);
                         fe:=(12*sqr(pi)*(E*1000))/(23*sqr(k*m[x].length/2/angprop^.rx));
                         fb2:=m[x].mom*(angprop^.b-angprop^.y)/(2*angprop^.ix);
                         fb2:=m[x].force/(angprop^.area*2)/fa2+
                              0.6*fb2/((1-m[x].force/(angprop^.area*2)/fe)*angprop^.q*fb);
                    end
                    else
                    begin
                         if membdata^.material='A' then
                         begin
                              mainform.findangle(m[x].section);
                              fa2:=fa(k*m[x].length/angprop^.rz,angprop^.Q);
                              fe:=(12*sqr(pi)*(E*1000))/(23*sqr(k*m[x].length/(sqr(angprop^.rz)*angprop^.area)));
                              fb2:=m[x].mom*sqrt(2*sqr(angprop^.y))/(sqr(angprop^.rz)*angprop^.area);
                              fb2:=m[x].force/(angprop^.area)/fa2+
                                   0.6*fb2/((1-m[x].force/(angprop^.area)/fe)*angprop^.q*fb);
                         end
                         else
                         begin
                              mainform.findrnd(m[x].section);
                              fa2:=k*m[x].length/rndprop^.r;
                              if (fa2>=0) and (fa2<112) then
                                 fa2:=25750-1.108*sqr(fa2)-7845*ecc-461*sqr(ecc)+60*ecc*fa2;
                              if (fa2>=112) and (fa2<127) then
                                 fa2:=18540-0.574*sqr(fa2)-6940*ecc-408*sqr(ecc)+53*ecc*fa2;
                              if (fa2>=127) and (fa2<200) then
                                 fa2:=149000000/sqr(fa2)-380*sqr(ecc)-180*ecc;
                              fe:=(12*sqr(pi)*(E*1000))/(23*sqr(k*m[x].length/rndprop^.r));
                              fb2:=m[x].mom*(rndprop^.d/2)/rndprop^.i;
                              fb2:=m[x].force/(rndprop^.area)/fa2+
                                   0.6*fb2/((1-m[x].force/(rndprop^.area)/fe)*fb);
                         end;

                    end;
                    m[x].result:=fb2;
               end;
          end;
     end;
     for x:=1 to 5 do
     begin
          if x<4 then
          begin
               if m[x].result>fb then
                  exit;
          end
          else
          begin
               if m[x].result>1 then
                  exit;
          end;
     end;
     result:=true;
end;

procedure consolidate;
var
   membn,tcn,bcn,x,y:integer;
   maxc,maxt:single;
   com,ten:boolean;
   temp:string[2];
begin
     tcn:=0; bcn:=0;
     for x:=1 to middle do
     begin
          membdata:=memberlist.items[x-1];
          if membdata^.position<>'V2' then
          begin
               maxc:=membdata^.maxc;
               maxt:=membdata^.maxt;
               if (copy(membdata^.position,1,1)='W') or (membdata^.position='V1S') then
                  mainform.findmemb(membdata^.position,'R')
               else
               begin
                    if membdata^.position='BC' then
                    begin
                         temp:='BC';
                         inc(bcn);
                    end
                    else
                    begin
                        temp:='TC';
                        inc(tcn);
                    end;
                    membn:=0; y:=memberlist.count;
                    repeat
                          membdata:=memberlist.items[y-1];
                          if (membdata^.position='BC') and (temp='BC') then
                             inc(membn);
                          if ((membdata^.position='TC') or (membdata^.position='EP') or
                             (membdata^.position='NP')) and (temp='TC') then
                             inc(membn);
                          dec(y);
                    until ((membn=bcn) and (temp='BC')) or ((membn=tcn) and (temp='TC'));
               end;
               com:=false; ten:=false;
               if membdata^.maxc<maxc then
                  membdata^.maxc:=maxc
               else
               begin
                    com:=true;
                    maxc:=membdata^.maxc;
               end;
               if membdata^.maxt<maxt then
                  membdata^.maxt:=maxt
               else
               begin
                    ten:=true;
                    maxt:=membdata^.maxt;
               end;
               if com or ten then
               begin
                    membdata:=memberlist.items[x-1];
                    if com then
                       membdata^.maxc:=maxc;
                    if ten then
                       membdata^.maxt:=maxt;
               end;
          end;
     end;
end;

function weldlen(ang,d:single):single;
var
   b,temp,temp2,tot:single;
   a:single;
begin
     mainform.findangle(TCSection.section);
     b:=angprop^.d;
     mainform.findangle(BCSection.section);
     if angprop^.d>b then
        mainform.findangle(TCSection.section);
     temp:=angprop^.t; temp2:=angprop^.d;
     tot:=(angprop^.d-angprop^.t-0.25)/sin(ang);
     a:=d*sin(pi/2-ang)+0.25+temp;
     if a>=temp2 then
        tot:=tot+(temp2-0.25-temp)/sin(pi/2-ang)
     else
         tot:=tot+d+(temp2-(sin(pi/2-ang)*d+0.25+temp))/sin(ang);
     result:=tot;
end;

function weld(p:single):single;
var
   a,t:single;
begin
     a:=sqrt(2);
     if jtype in jtype1 then
          t:=3/16
     else
     begin
          t:=1/8;
          if (jtype='K') or (jtype='C') then
             a:=1;
     end;
     a:=abs(a*((p*0.02)/(21000*t)));
     if ((jtype='K') or (jtype='C')) and (a<3/8) then
        a:=3/8;
     if ((jtype<>'K') or (jtype<>'C')) and (a<4*t) then
        a:=4*t;
     result:=a;
end;

function fcr(klr,Q:single):single;
var
   temp,feCr:single;
begin
     feCr:=(sqr(pi)*(E*1000))/(sqr(klr));
     if klr<=4.71*sqrt(E/(Q*Fy)) then
     begin
          temp:=power(0.658,(Q*Fy*1000)/feCr);
          temp:=temp*Q*Fy*1000;
     end
     else
          temp:=0.877*feCr;
    fcr:=temp;
end;

function fa(klr,Q:single):single;
var
   cc,temp:single;
begin
     cc:=sqrt((2*sqr(pi)*E)/(Q*Fy));
     if klr<cc then
     begin
          temp:=(1-sqr(klr)/(2*sqr(cc)))*(Q*Fy*1000);
          temp:=temp/((5/3)+((3/8)*(klr/cc))-((1/8)*intpower((klr/cc),3)));
     end
     else
         temp:=(12*sqr(pi)*(E*1000))/(23*sqr(klr));
    fa:=temp;
end;

procedure uniformload(l:single; chord:string);
var
   tc1,tc2,na,y:integer;
   last,first,next,found:boolean;
   x1,x2,x3:single;
begin
     na:=0; y:=0; jointdata:=JointList.first;
     first:=true; tc1:=0; tc2:=0; last:=false;
     while not last do
     begin
          found:=false;
          while (y<JointList.count) and (not found) do
          begin
               jointdata:=JointList.items[y];
               if jointdata^.position=chord then
               begin
                  if first then
                  begin
                     first:=false;
                     tc1:=y;
                  end;
                  found:=true;
                  na:=y; next:=false;
                  while (y<JointList.count-1) and (not next) do
                  begin
                       inc(y);
                       jointdata:=JointList.items[y];
                       if jointdata^.position=chord then
                       begin
                            next:=true;
                            tc2:=y;
                       end;
                  end;
                  if not next then
                     last:=true;
               end
               else
                   inc(y);
          end;
          jointdata:=JointList.items[tc1];
          x1:=jointdata^.coordX;
          jointdata:=JointList.items[tc2];
          x3:=jointdata^.coordX;
          jointdata:=JointList.items[na];
          x2:=jointdata^.coordX;
          jointdata^.forceY:=jointdata^.forceY-((x2-x1)/2+(x3-x2)/2)/12*l;
          tc1:=na;
          na:=tc2; y:=na;
     end;
end;

procedure partialuniform(n1,n2:integer; l,l2:single);
var
   tc1,tc2,na,y:integer;
   last,first,next,found:boolean;
   wl,xn1,angle,x1,x2,x3:single;
   chord:string;
begin
     jointdata:=JointList.items[n2-1];
     x2:=jointdata^.coordX;
     na:=0; y:=n1-1;
     jointdata:=JointList.items[n1-1];
     x1:=jointdata^.coordX;
     if l<l2 then
        xn1:=x1
     else
        xn1:=x2;
     angle:=arctan(abs(l-l2)/(x2-x1));
     chord:=jointdata^.position;
     first:=true; tc1:=0; tc2:=0; last:=false;
     while not last do
     begin
          found:=false;
          while (y<n2) and (not found) do
          begin
               jointdata:=JointList.items[y];
               if jointdata^.position=chord then
               begin
                  if first then
                  begin
                     first:=false;
                     tc1:=y;
                  end;
                  found:=true;
                  na:=y; next:=false;
                  while (y<n2-1) and (not next) do
                  begin
                       inc(y);
                       jointdata:=JointList.items[y];
                       if jointdata^.position=chord then
                       begin
                            next:=true;
                            tc2:=y;
                       end;
                  end;
                  if not next then
                     last:=true;
               end
               else
                   inc(y);
          end;
          jointdata:=JointList.items[tc1];
          x1:=jointdata^.coordX;
          jointdata:=JointList.items[tc2];
          x3:=jointdata^.coordX;
          jointdata:=JointList.items[na];
          x2:=jointdata^.coordX;
          if l<>l2 then
          begin
                if l>l2 then
                begin
                        wl:=l2;
                        wl:=wl+tan(angle)*abs(x1-xn1);
                end
                else
                begin
                        wl:=l;
                        wl:=wl+tan(angle)*abs(x3-xn1);
                end;
          end
          else
                wl:=l;
          jointdata^.forceY:=jointdata^.forceY-((x2-x1)/2+(x3-x2)/2)/12*wl;
          tc1:=na;
          na:=tc2; y:=na;
     end;
end;

procedure loadgirder(p:single);
var
   c,y:integer;
   last,max:single;

   procedure chklat;
   begin
        if jointdata^.coordX-last>=max then
           max:=jointdata^.coordX-last;
        last:=jointdata^.coordX;
   end;

begin
     with mainform do
     begin
          y:=0; max:=0; last:=0;
          if jtype='G' then
             c:=1
          else
              c:=0;
          while y<JointList.count do
          begin
               jointdata:=JointList.items[y];
               if jointdata^.position='TC' then
               begin
                    if (y=0) or (y=JointList.count-1) then
                    begin
                       jointdata^.forceY:=jointdata^.forceY-(p/2);
                       chklat;
                    end
                    else
                    if (jtype='V') or (jtype='G') then
                    begin
                         if ingtodec(joistsfirsthalfle.value)=0 then
                         begin
                              if not odd(c) then
                              begin
                                   jointdata^.forceY:=jointdata^.forceY-p;
                                   chklat;
                              end;
                         end
                         else
                         begin
                              if odd(c) then
                              begin
                                   jointdata^.forceY:=jointdata^.forceY-p;
                                   chklat;
                              end;
                         end;
                    end
                    else
                    begin
                       jointdata^.forceY:=jointdata^.forceY-p;
                       chklat;
                    end;
                    inc(c);
               end;
               inc(y);
          end;
          if not stseam then
                latsup:=max;
     end;
end;

procedure doaddload(f,load:single);
var
   pct:single;
begin
        New(ConcData);
        ConcData^.Chord:='TC';
        ConcData^.Dist:=bl/2;
        ConcData^.Force:=load;
        ConcData^.vcb:=false;
        concdata^.Wind:=false;
        ConcList.add(concdata);
        pct:=mainform.findsupmemb;
        jointdata:=JointList.items[membdata^.joint1-1];
        jointdata^.forceY:=jointdata^.forceY-concdata^.force*f*pct;
        jointdata:=JointList.items[membdata^.joint2-1];
        jointdata^.forceY:=jointdata^.forceY-concdata^.force*f*(1-pct);
        dispose(concdata);
        conclist.delete(conclist.Count-1);
        conclist.pack;
        addshear:=addshear+load/2;
end;


procedure doconcloads(f:single; lcase:integer); {0-Normal, 1-Wind +, 2-Wind -}
var
   x:integer;
   pct:single;
begin
     with mainform do
     begin
          for x:=1 to conclist.count do
          begin
               concdata:=conclist[x-1];
               pct:=findsupmemb;
               case lcase of
               0:begin
                      if not concdata^.wind then
                      begin
                           jointdata:=JointList.items[membdata^.joint1-1];
                           jointdata^.forceY:=jointdata^.forceY-concdata^.force*f*pct;
                           jointdata:=JointList.items[membdata^.joint2-1];
                           jointdata^.forceY:=jointdata^.forceY-concdata^.force*f*(1-pct);
                      end;
                 end;
               1:begin
                      if concdata^.wind then
                      begin
                           jointdata:=JointList.items[membdata^.joint1-1];
                           jointdata^.forceY:=jointdata^.forceY-concdata^.force*f*pct;
                           jointdata:=JointList.items[membdata^.joint2-1];
                           jointdata^.forceY:=jointdata^.forceY-concdata^.force*f*(1-pct);
                      end;
                 end;
               2:begin
                      if concdata^.wind then
                      begin
                           jointdata:=JointList.items[membdata^.joint1-1];
                           jointdata^.forceY:=jointdata^.forceY+concdata^.force*f*pct;
                           jointdata:=JointList.items[membdata^.joint2-1];
                           jointdata^.forceY:=jointdata^.forceY+concdata^.force*f*(1-pct);
                      end;
                 end;
               end;
          end;
     end;
end;

procedure dopartloads(f:single; uplift:boolean);
var
   x:integer;
begin
     with mainform do
     begin
          for x:=1 to partlist.count do
          begin
               partdata:=partlist[x-1];
               if PartData.uplift=uplift then
               begin
                   if uplift then
                        partialuniform(partdata^.joint1,partdata^.joint2,-partdata^.force*f,-partdata^.force2*f)
                   else
                        partialuniform(partdata^.joint1,partdata^.joint2,partdata^.force*f,partdata^.force2*f)
               end;
          end;
     end;
end;

procedure accmax(temp:single);
begin
     if temp<0 then
     begin
          if membdata^.maxc<abs(temp) then
             membdata^.maxc:=abs(temp);
          if (membdata^.position='TC') or (membdata^.position='EP') or (membdata^.position='NP') then
          begin
               if abs(membdata^.force)>TCSection.maxforce then
                  TCSection.maxforce:=abs(membdata^.force);
          end;
          if membdata^.position='BC' then
          begin
               if abs(membdata^.force)>BCSection.maxforce2 then
                 BCSection.maxforce2:=abs(membdata^.force);
          end;
     end
     else
     begin
         if membdata^.maxt<temp then
             membdata^.maxt:=temp;
         if (membdata^.position='TC') or (membdata^.position='EP') or (membdata^.position='NP') then
         begin
              if membdata^.force>TCSection.maxforce2 then
                 TCSection.maxforce2:=membdata^.force;
         end;
         if membdata^.position='BC' then
         begin
              if membdata^.force>BCSection.maxforce then
                 BCSection.maxforce:=membdata^.force;
         end;
     end;
end;

procedure dosubst;
var
   sig,x:integer;
begin
     if jtype<>'C' then
     begin
          if abs(r1)>abs(r2) then
             minshr:=abs(r1/4)
          else
              minshr:=abs(r2/4);
     end;
     for x:=1 to MemberList.count do
     begin
          membdata:=MemberList.items[x-1];
          if membdata^.csc>0 then
          begin
               membdata^.shear:=abs(membdata^.force/membdata^.csc);
               if membdata^.shear>maxshr then
               begin
                    maxshr:=membdata^.shear;
                    maxtsh:=membdata^.shear*(cos(membdata^.angle)/sin(membdata^.angle));
               end;
          end
          else
          begin
              membdata^.shear:=0;
          end;
          if (copy(membdata^.position,1,1)<>'W') and (copy(membdata^.position,1,1)<>'V') then
             continue;
          if copy(membdata^.position,1,1)='V' then
          begin
               if jtype in jtype2 then
                  membdata^.force:=membdata^.force-abs(TCSection.maxforce*0.01/2)
               else
                   if abs(membdata^.force)<1 then
                      membdata^.force:=membdata^.force-abs(TCSection.maxforce*0.02);
          end;
          sig:=1;
          if membdata^.force<0 then
             sig:=-1;
          if jtype<>'C' then
             membdata^.force:=(abs(membdata^.force)+addshear*membdata^.csc)*sig;
          if ((abs(membdata^.force/membdata^.csc)<minshr) and (copy(membdata^.position,1,1)<>'V')) or (jtype='C') then
             membdata^.force:=minshr*membdata^.csc*sig;
          accmax(membdata^.force);
          if jtype='C' then
          begin
               if membdata^.position='W2' then
                  membdata^.maxc:=0
               else
               begin
                    if membdata^.maxt>membdata^.maxc then
                       membdata^.maxc:=membdata^.maxt
                    else
                        membdata^.maxt:=membdata^.maxc;
               end;
          end;
     end;
end;

procedure calcsummary;
var
   x:integer;
   ang:single;
begin
     TCSection.maxintp:=0; BCSection.maxintp:=0;
     maxtv2:=0; maxcv2:=0;
     for x:=1 to memberlist.count do
     begin
          membdata:=MemberList.items[x-1];
          if (membdata^.position='TC') or (membdata^.position='EP') or (membdata^.position='NP') then
          begin
               if (membdata^.length>TCSection.maxintp) and (membdata^.position='TC') then
                  TCSection.maxintp:=membdata^.length;
          end;
          if membdata^.position='BC' then
          begin
               if membdata^.length>BCSection.maxintp then
                  BCSection.maxintp:=membdata^.length;
          end;
          membdata^.weld:=0;
          membdata^.thick:=0;
          if membdata^.position='V2' then
          begin
               if membdata^.maxt>maxtv2 then
                  maxtv2:=membdata^.maxt;
               if membdata^.maxc>maxcv2 then
                  maxcv2:=membdata^.maxc;
          end;
     end;
     if ingtodec(mainform.joistsridgeposition.value)<bl then
     begin
          ang:=cangle(0,mainform.joistsdepthle.value,ingtodec(mainform.joistsridgeposition.value),depth);
          TCSection.Length:=(ingtodec(mainform.joistsridgeposition.value)+ingtodec(mainform.joiststcxl.value))/cos(ang);
          ang:=cangle(bl,mainform.joistsdepthre.value,ingtodec(mainform.joistsridgeposition.value),depth);
          TCSection.Length:=TCSection.length+(bl-ingtodec(mainform.joistsridgeposition.value)+
               ingtodec(mainform.joiststcxr.value))/cos(ang);
     end
     else
     begin
          ang:=cangle(0,mainform.joistsdepthle.value,bl,mainform.joistsdepthre.value);
          TCSection.Length:=(bl+ingtodec(mainform.joiststcxl.value)+ingtodec(mainform.joiststcxr.value))/cos(ang);
     end;
     BCSection.Length:=bl+ingtodec(mainform.joiststcxl.value)+ingtodec(mainform.joiststcxr.value)-
          ingtodec(mainform.joistsbcxl.value)-ingtodec(mainform.joistsbcxr.value);
end;

procedure calcforces;
var
   x,y:integer;
   temp:single;
begin
     for x:=1 to JointList.count do
     begin
          jointdata:=JointList.items[x-1];
          matrix2[2*x-1]:=-jointdata^.forceX;
          matrix2[2*x]:=-jointdata^.forceY;
          if (jtype in jtype1) and (JointData^.Position='TC') then
          begin
                if abs(jointdata^.forceY)>maxPointLoad then
                        maxPointLoad:=abs(jointdata^.forceY);
          end;
     end;
     for x:=1 to memb do
     begin
          temp:=0;
          for y:=memb+1 to memb*2 do
          begin
               temp:=temp+(matrix[y,x]*matrix2[y-memb]);
          end;
          matrix[x,1]:=temp;
          {temp:=rnddec(temp,4);}
          if x<memb then
          begin
               case x of
                    1:r3:=temp;
                    2:r1:=temp;
                    else
                    begin
                         membdata:=MemberList.items[x-3];
                         membdata^.force:=temp;
                         accmax(temp);
                    end;
               end;
          end
          else
              r2:=temp;
     end;
     dosubst;
     if abs(r1)>abs(maxr1) then
        maxr1:=r1;
     if abs(r2)>abs(maxr2) then
        maxr2:=r2;
end;

procedure deflection;
var
   c,x,y:integer;
   valft,tot,marea:single;
begin
     for x:=1 to memb do
     begin
          matrix2[x]:=matrix[x,1];
          if (x<3) or (x=memb) then
             valft:=0
          else
          begin
               membdata:=memberList.items[x-3];
               if membdata^.Material='R' then
               begin
                    Mainform.findrnd(membdata^.Section);
                    marea:=rndprop^.Area;
               end
               else
               begin
                    MainForm.findangle(membdata^.Section);
                    marea:=angprop^.Area;
                    if membdata^.Material='D' then
                       marea:=marea*2;
               end;
               valft:=membdata^.Length/(marea*E*1000);
          end;
          for y:=1 to memb do
          begin
               tot:=0;
               for c:=1 to memb do
               begin
                    if c=x then
                       tot:=tot+valft*matrix[y+memb,c];
               end;
               matrix[x,y]:=tot;
          end;

     end;
     for x:=1 to memb do
     begin
          tot:=0;
          for y:=1 to memb do
          begin
               tot:=tot+(matrix[y,x]*matrix2[y]);
          end;
          if odd(x) then
          begin
               jointdata:=JointList.items[trunc((x+1)/2-1)];
               jointdata^.deltaX:=-tot;
          end
          else
              jointdata^.deltaY:=-tot;
     end;
end;

procedure solveinv;
var
   c,x,y,maxr:integer;
   max,temp:single;
begin
     for x:=1 to memb do
     begin
          max:=abs(matrix[x,x]); maxr:=x;
          for y:=x+1 to memb do
          begin
               if abs(matrix[x,y])>max then
               begin
                    max:=abs(matrix[x,y]);
                    maxr:=y;
               end;
          end;
          if maxr<>x then
          for c:=x to memb*2 do
          begin
               temp:=matrix[c,x];
               matrix[c,x]:=matrix[c,maxr];
               matrix[c,maxr]:=temp;
          end;
          if max<>0 then
          begin
               temp:=1/matrix[x,x];
               for c:=x to memb*2 do
                   matrix[c,x]:=matrix[c,x]*temp;
          end
          else
              exit;
          for y:=x+1 to memb do
          begin
               if matrix[x,y]<>0 then
               begin
                    temp:=matrix[x,y];
                    for c:=x to memb*2 do
                        matrix[c,y]:=matrix[c,y]-matrix[c,x]*temp;
               end;
          end;
     end;
     for x:=memb downto 2 do
     begin
          for y:=x-1 downto 1 do
          begin
               if matrix[x,y]<>0 then
               begin
                    temp:=matrix[x,y];
                    for c:=x to memb*2 do
                        matrix[c,y]:=matrix[c,y]-matrix[c,x]*temp;
               end;
          end;
     end;
end;

procedure clearjoints;
var
   x:integer;
begin
     for x:=1 to JointList.count do
     begin
          jointdata:=JointList.items[x-1];
          jointdata^.forceX:=0;
          jointdata^.forceY:=0;
     end;
end;

procedure domoment(mom:single; side:string);
begin
     mom:=mom*12;
     if side='L' then
     begin
          mainform.findjoint('BC','L');
          jointdata^.forceX:=jointdata^.forceX-(mom/ed);
     end
     else
     begin
          jointdata:=JointList.items[jointlist.count-1];
          jointdata^.forceX:=jointdata^.forceX+(mom/ed);
          mainform.findjoint('BC','R');
          jointdata^.forceX:=jointdata^.forceX-(mom/ed);
     end;
end;

procedure case1kcs; {Fixed Moment}
var
   n,x:integer;
begin
     clearjoints;
     with mainform do
     begin
          domoment(load*1000/12,'L');
          domoment(-load*1000/12,'R');
     end;
     calcforces;
     mainform.findmemb('EP','L');
     membdata^.maxc:=0;
     mainform.findmemb('EP','R');
     membdata^.maxc:=0;
     clearjoints;
     n:=2; x:=0;
     repeat
           inc(x);
           jointdata:=jointlist.items[x-1];
           if jointdata^.position='TC' then
              dec(n);
     until n=0;
     jointdata^.forceY:=jointdata^.forceY-minshr;
     n:=2; x:=jointlist.count+1;
     repeat
           dec(x);
           jointdata:=jointlist.items[x-1];
           if jointdata^.position='TC' then
              dec(n);
     until n=0;
     jointdata^.forceY:=jointdata^.forceY-minshr;
     calcforces;
end;

procedure docase1; {Dead Load}
begin
     clearjoints;
     if jtype in jtype1 then
         loadgirder(load*0.4)
     else
         uniformload(load-livel,'TC');
     calcforces;
end;

procedure docase2; {Live Load}
begin
     clearjoints;
     if jtype in jtype1 then
         loadgirder(load*0.6)
     else
         uniformload(livel,'TC');
     calcforces;
end;

procedure docase3(f:single); {Total Load}
begin
     clearjoints;
     addshear:=mainform.joistsanypanel.value*f;
     if jtype in jtype1 then
         uniformload(mainform.joiststcuniformload.value*f,'TC')
     else
         uniformload((mainform.joiststcuniformload.value+load)*f,'TC');
     uniformload(mainform.joistsbcuniformload.value*f,'BC');
     doconcloads(f,0);
     if MainForm.JoistsAddLoad.Value>0 then
        doaddload(f,MainForm.JoistsAddLoad.Value);
     doconcloads(f,1);
     dopartloads(f,false);
     if jtype in jtype1 then
        loadgirder(load*f);
     calcforces;
end;

procedure docase4; {Case1 + Axial Loads, all reduced 75%}
var
   f:single;
begin
     f:=0.75;
     clearjoints;
     docase3(f);
     with mainform do
     begin
          jointdata:=JointList.items[jointlist.count-1];
          jointdata^.forceX:=jointdata^.forceX-joiststcaxialload.value*f;
          findjoint('BC','L');
          jointdata^.forceX:=jointdata^.forceX+joistsbcaxialload.value*f;
          findjoint('BC','R');
          jointdata^.forceX:=jointdata^.forceX-joistsbcaxialload.value*f;
     end;
     calcforces;
end;

procedure docase5; {Net Uplift, Positive Lateral Moment all reduced 75%}
var
   f:single;
begin
     f:=0.75;
     clearjoints;
     addshear:=0;
     if mainform.joistsnetuplift.value>0 then
     begin
          if jtype in jtype2 then
             uniformload(-mainform.joistsnetuplift.value*f,'TC')
          else
              loadgirder(-mainform.joistsnetuplift.value*f);
     end;
     doconcloads(f,2);
     dopartloads(f,true);
     with mainform do
     begin
          if joistslateralmomentLE.value>0 then
          begin
               domoment(joistslateralmomentLE.value*f,'L');
          end;
          if joistslateralmomentRE.value>0 then
          begin
               domoment(joistslateralmomentRE.value*f,'R');
          end;
     end;
     calcforces;
end;

procedure docase6; {Net Uplift, Negative Lateral Moment all reduced 75%}
var
   f:single;
begin
     f:=0.75;
     clearjoints;
     addshear:=0;
     if jtype in jtype2 then
        uniformload(-mainform.joistsnetuplift.value*f,'TC')
     else
         loadgirder(-mainform.joistsnetuplift.value*f);
     doconcloads(f,2);
     dopartloads(f,true);
     with mainform do
     begin
          if joistslateralmomentLE.value>0 then
          begin
               domoment(-joistslateralmomentLE.value*f,'L');
          end;
          if joistslateralmomentRE.value>0 then
          begin
               domoment(-joistslateralmomentRE.value*f,'R');
          end;
     end;
     calcforces;
end;

procedure docase7; {Case1 with Fixed + Positive Lateral Moment, all reduced 75%}
var
   f,ml,mr:single;
begin
     f:=0.75;
     clearjoints;
     docase3(f);
     with mainform do
     begin
          ml:=-joistsfixedmomentLE.value+joistslateralmomentLE.value;
          mr:=joistsfixedmomentRE.value+joistslateralmomentRE.value;
          if joistsfixedmomentLE.value>0 then
             domoment(ml*f,'L');
          if joistsfixedmomentRE.value>0 then
             domoment(mr*f,'R');
     end;
     calcforces;
end;

procedure docase8; {Case1 with Fixed + Negative Lateral Moment, all reduced 75%}
var
   f,ml,mr:single;
begin
     f:=0.75;
     clearjoints;
     docase3(f);
     with mainform do
     begin
          ml:=-joistsfixedmomentLE.value-joistslateralmomentLE.value;
          mr:=joistsfixedmomentRE.value-joistslateralmomentRE.value;
          if joistsfixedmomentLE.value>0 then
             domoment(ml*f,'L');
          if joistsfixedmomentRE.value>0 then
             domoment(mr*f,'R');
     end;
     calcforces;
end;

procedure docaseTL_LRFD(f:single); {Total Load LRFD}
begin
     clearjoints;
     addshear:=mainform.joistsanypanel.value*f;
     if jtype in jtype1 then
         uniformload(mainform.joiststcuniformload.value*f,'TC')
     else
         uniformload((mainform.joiststcuniformload.value)*f,'TC');
     uniformload(mainform.joistsbcuniformload.value*f,'BC');
     doconcloads(f,0);
     if MainForm.JoistsAddLoad.Value>0 then
        doaddload(f,MainForm.JoistsAddLoad.Value);
     doconcloads(f,1);
     dopartloads(f,false);

     {if jtype in jtype1 then
        loadgirder(load*f);}

     calcforces;
end;


procedure docase1LRFD; // 1.4DL
begin
     clearjoints;

     //using unfactored loads instead
     //Dead Load
     if jtype in jtype1 then
     begin
          if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.4)
          else
            loadgirder(1.4*load*0.4);
     end
     else
         uniformload(1.4*((1.5*load-1.6*livel)/1.2),'TC');

     calcforces;
end;

procedure docase2aLRFD; // 1.2DL+1.6LL +1.6TL
begin
     clearjoints;

     //Total Load
     docaseTL_LRFD(1.6); //Total Load * 1.6

     {if jtype in jtype2 then
     begin
        uniformload(1.2*((1.5*load-1.6*livel)/1.2),'TC');
        uniformload(1.6*livel,'TC');
     end;}

     //Dead Load
     if jtype in jtype1 then
     begin
         if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.4)
         else
            loadgirder(1.2*load*0.4);
     end
     else
         uniformload(1.2*((1.5*load-1.6*livel)/1.2),'TC');
         
     //Live Load
     if jtype in jtype1 then
     begin
          if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.6)
          else
            loadgirder(1.6*load*0.6);
     end
     else
         uniformload(1.6*livel,'TC');

     calcforces;
end;

procedure docase2bLRFD; // 1.2DL+1.6LL+1.6AX +1.6TL
begin
     clearjoints;

     //Total Load
     docaseTL_LRFD(1.6); //Total Load * 1.6

     {if jtype in jtype1 then
     begin
        uniformload(1.2*((1.5*load-1.6*livel)/1.2),'TC');
        uniformload(1.6*livel,'TC');
     end;}

     //Dead Load
     if jtype in jtype1 then
     begin
         if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.4)
         else
            loadgirder(1.2*load*0.4);
     end
     else
         uniformload(1.2*((1.5*load-1.6*livel)/1.2),'TC');
         
     //Live Load
     if jtype in jtype1 then
     begin
          if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.6)
          else
            loadgirder(1.6*load*0.6);
     end
     else
         uniformload(1.6*livel,'TC');

     //Axial Load
     with mainform do
     begin
          jointdata:=JointList.items[jointlist.count-1];
          jointdata^.forceX:=jointdata^.forceX-joiststcaxialload.value*1.6;
          findjoint('BC','L');
          jointdata^.forceX:=jointdata^.forceX+joistsbcaxialload.value*1.6;
          findjoint('BC','R');
          jointdata^.forceX:=jointdata^.forceX-joistsbcaxialload.value*1.6;
     end;

     calcforces;
end;

procedure docase3aLRFD; // 1.2DL+1.0WL+1.0LM+1.0LL +1.6TL
begin
     clearjoints;

     //Total Load
     docaseTL_LRFD(1.6); //Total Load * 1.6

     //Dead Load
     if jtype in jtype1 then
     begin
         if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.4)
         else
            loadgirder(1.2*load*0.4);
     end
     else
         uniformload(1.2*((1.5*load-1.6*livel)/1.2),'TC');

     //Uplift loads
     if mainform.joistsnetuplift.value>0 then
     begin
          if jtype in jtype2 then
             uniformload(-mainform.joistsnetuplift.value*1.0,'TC')
          else
              loadgirder(-mainform.joistsnetuplift.value*1.0);
     end;
     doconcloads(1.0,2);
     dopartloads(1.0,true);
     with mainform do
     begin
          if joistslateralmomentLE.value>0 then
          begin
               domoment(joistslateralmomentLE.value*1.0,'L');
          end;
          if joistslateralmomentRE.value>0 then
          begin
               domoment(joistslateralmomentRE.value*1.0,'R');
          end;
     end;

     //Live Load
     if jtype in jtype1 then
     begin
          if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.6)
          else
            loadgirder(1.0*load*0.6);
     end
     else
         uniformload(1.0*livel,'TC');

     calcforces;
end;

procedure docase3bLRFD; // 1.2DL+1.0WL-1.0LM+1.0LL +1.6TL
begin
     clearjoints;

     //Total Load
     docaseTL_LRFD(1.6); //Total Load * 1.6

     //Dead Load
     if jtype in jtype1 then
     begin
         if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.4)
         else
            loadgirder(1.2*load*0.4);
     end
     else
         uniformload(1.2*((1.5*load-1.6*livel)/1.2),'TC');

     //Uplift loads
     if mainform.joistsnetuplift.value>0 then
     begin
          if jtype in jtype2 then
             uniformload(-mainform.joistsnetuplift.value*1.0,'TC')
          else
              loadgirder(-mainform.joistsnetuplift.value*1.0);
     end;
     doconcloads(1.0,2);
     dopartloads(1.0,true);
     with mainform do
     begin
          if joistslateralmomentLE.value>0 then
          begin
               domoment(-joistslateralmomentLE.value*1.0,'L');
          end;
          if joistslateralmomentRE.value>0 then
          begin
               domoment(-joistslateralmomentRE.value*1.0,'R');
          end;
     end;

     //Live Load
     if jtype in jtype1 then
     begin
          if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.6)
          else
            loadgirder(1.0*load*0.6);
     end
     else
         uniformload(1.0*livel,'TC');

     calcforces;
end;

procedure docase4aLRFD; // 1.2DL+1.0EQ+1.0LL +1.6TL
var
  ml,mr:single;
begin
     clearjoints;

     //Total Load
     docaseTL_LRFD(1.6); //Total Load * 1.6

     //Dead Load
     if jtype in jtype1 then
     begin
         if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.4)
         else
            loadgirder(1.2*load*0.4);
     end
     else
         uniformload(1.2*((1.5*load-1.6*livel)/1.2),'TC');

     //Live Load
     if jtype in jtype1 then
     begin
          if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.6)
          else
            loadgirder(1.0*load*0.6);
     end
     else
         uniformload(1.0*livel,'TC');

     //positive fixed moments
     with mainform do
     begin
          ml:=-joistsfixedmomentLE.value+joistslateralmomentLE.value;
          mr:=joistsfixedmomentRE.value+joistslateralmomentRE.value;
          if joistsfixedmomentLE.value>0 then
             domoment(ml*1.0,'L');
          if joistsfixedmomentRE.value>0 then
             domoment(mr*1.0,'R');
     end;

     calcforces;
end;

procedure docase4bLRFD; // 1.2DL-1.0EQ+1.0LL +1.6TL
var
  ml,mr:single;
begin
     clearjoints;

     //Total Load
     docaseTL_LRFD(1.6); //Total Load * 1.6

     //Dead Load
     if jtype in jtype1 then
     begin
         if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.4)
         else
            loadgirder(1.2*load*0.4);
     end
     else
         uniformload(1.2*((1.5*load-1.6*livel)/1.2),'TC');

     //Live Load
     if jtype in jtype1 then
     begin
          if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder(load*0.6)
          else
            loadgirder(1.0*load*0.6);
     end
     else
         uniformload(1.0*livel,'TC');

     //negative fixed moments
     with mainform do
     begin
          ml:=-joistsfixedmomentLE.value-joistslateralmomentLE.value;
          mr:=joistsfixedmomentRE.value-joistslateralmomentRE.value;
          if joistsfixedmomentLE.value>0 then
             domoment(ml*1.0,'L');
          if joistsfixedmomentRE.value>0 then
             domoment(mr*1.0,'R');
     end;

     calcforces;
end;

procedure docase5aLRFD; // 0.9DL+1.0WL+1.0LM
begin
     clearjoints;

     //Dead Load
     if jtype in jtype1 then
     begin
         if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder((0.9/1.2)*load*0.4)
         else
            loadgirder(0.9*load*0.4);
     end
     else
         uniformload(0.9*((1.5*load-1.6*livel)/1.2),'TC');

     //Uplift loads
     if mainform.joistsnetuplift.value>0 then
     begin
          if jtype in jtype2 then
             uniformload(-mainform.joistsnetuplift.value*1.0,'TC')
          else
              loadgirder(-mainform.joistsnetuplift.value*1.0);
     end;
     doconcloads(1.0,2);
     dopartloads(1.0,true);
     with mainform do
     begin
          if joistslateralmomentLE.value>0 then
          begin
               domoment(joistslateralmomentLE.value*1.0,'L');
          end;
          if joistslateralmomentRE.value>0 then
          begin
               domoment(joistslateralmomentRE.value*1.0,'R');
          end;
     end;

     calcforces;
end;

procedure docase5bLRFD; // 0.9DL+1.0WL-1.0LM
begin
     clearjoints;

     //Dead Load
     if jtype in jtype1 then
     begin
         if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder((0.9/1.2)*load*0.4)
         else
            loadgirder(0.9*load*0.4);
     end
     else
         uniformload(0.9*((1.5*load-1.6*livel)/1.2),'TC');

     //Uplift loads
     if mainform.joistsnetuplift.value>0 then
     begin
          if jtype in jtype2 then
             uniformload(-mainform.joistsnetuplift.value*1.0,'TC')
          else
              loadgirder(-mainform.joistsnetuplift.value*1.0);
     end;
     doconcloads(1.0,2);
     dopartloads(1.0,true);
     with mainform do
     begin
          if joistslateralmomentLE.value>0 then
          begin
               domoment(-joistslateralmomentLE.value*1.0,'L');
          end;
          if joistslateralmomentRE.value>0 then
          begin
               domoment(-joistslateralmomentRE.value*1.0,'R');
          end;
     end;

     calcforces;
end;

procedure docase6aLRFD; // 0.9DL+1.0EQ
var
  ml,mr:single;
begin
     clearjoints;

     //Dead Load
     if jtype in jtype1 then
     begin
         if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder((0.9/1.2)*load*0.4)
         else
            loadgirder(0.9*load*0.4);
     end
     else
         uniformload(0.9*((1.5*load-1.6*livel)/1.2),'TC');

     //positive fixed moments
     with mainform do
     begin
          ml:=-joistsfixedmomentLE.value+joistslateralmomentLE.value;
          mr:=joistsfixedmomentRE.value+joistslateralmomentRE.value;
          if joistsfixedmomentLE.value>0 then
             domoment(ml*1.0,'L');
          if joistsfixedmomentRE.value>0 then
             domoment(mr*1.0,'R');
     end;

     calcforces;
end;

procedure docase6bLRFD; // 0.9DL-1.0EQ
var
  ml,mr:single;
begin
     clearjoints;

     //Dead Load
     if jtype in jtype1 then
     begin
         if pos('F',MainForm.JoistsDescription.Value)>0 then
            loadgirder((0.9/1.2)*load*0.4)
         else
            loadgirder(0.9*load*0.4);
     end
     else
         uniformload(0.9*((1.5*load-1.6*livel)/1.2),'TC');

     //negative fixed moments
     with mainform do
     begin
          ml:=-joistsfixedmomentLE.value-joistslateralmomentLE.value;
          mr:=joistsfixedmomentRE.value-joistslateralmomentRE.value;
          if joistsfixedmomentLE.value>0 then
             domoment(ml*1.0,'L');
          if joistsfixedmomentRE.value>0 then
             domoment(mr*1.0,'R');
     end;

     calcforces;
end;

procedure solvesyst;
var
   sig,pos,pos2,j,m:integer;
   x1,x2,y1,y2,x,y:single;
begin
     memb:=JointList.count*2;
     for pos2:=1 to memb do
     begin
          for pos:=1 to memb*2 do
          begin
               if pos=pos2+memb then
                  matrix[pos,pos2]:=1
               else
                   matrix[pos,pos2]:=0;
          end;
     end;
     for j:=1 to JointList.count do
     begin
          pos:=2*j-1; pos2:=2*j;
          if j=supp1 then {first support joint of joist}
          begin
               Matrix[1,pos]:=1;
               Matrix[2,pos2]:=1;
          end;
          if j=supp2 then
             Matrix[JointList.count*2,pos2]:=1;
          for m:=1 to MemberList.count do
          begin
               membdata:=MemberList.items[m-1];
               jointdata:=JointList.items[membdata^.joint1-1];
               x1:=jointdata^.coordX;
               y1:=jointdata^.coordY;
               jointdata:=JointList.items[membdata^.joint2-1];
               x2:=jointdata^.coordX;
               y2:=jointdata^.coordY;
               membdata^.length:=clength(x1,y1,x2,y2);
               membdata^.angle:=cangle(x1,y1,x2,y2);
               if membdata^.angle>0 then
                  membdata^.csc:=1/sin(membdata^.angle)
               else
                   membdata^.csc:=0;
               if (membdata^.joint1=j) or (membdata^.joint2=j) then
               begin
                    if membdata^.joint1=j then
                    begin
                         x:=x2-x1;
                         y:=y2-y1;
                    end
                    else
                    begin
                         x:=x1-x2;
                         y:=y1-y2;
                    end;
                    if y=0 then
                    begin
                         Matrix[m+2,pos]:=x/abs(x);
                         Matrix[m+2,pos2]:=0;
                    end
                    else
                    begin
                         if x<0 then sig:=-1 else sig:=1;
                         Matrix[m+2,pos]:=abs(sin(arctan(x/y)))*sig;
                         if y<0 then sig:=-1 else sig:=1;
                         Matrix[m+2,pos2]:=abs(cos(arctan(x/y)))*sig;
                    end;
               end;
          end;
     end;
     solveinv;
     for j:=1 to memberlist.count do
     begin
          membdata:=MemberList.items[j-1];
          membdata^.maxc:=0;
          membdata^.maxt:=0;
          membdata^.overst:=0;
     end;
     TCSection.maxforce:=0; BCSection.maxforce:=0;
     TCSection.maxforce2:=0; BCSection.maxforce2:=0;
     firstpl.fillers:=0; firstpr.fillers:=0;
     maxr1:=0; maxr2:=0;
     maxshr:=0; maxtsh:=0;
     maxPointLoad:=0;

     if LRFD then
        fb:=fy*0.9*1000
     else
        fb:=fy*0.6*1000;

     if jtype='C' then
     begin
          case1kcs;
          if mainform.CaseCombo.Enabled then
             mainform.CaseCombo.Enabled:=false;
          docase5;
          with mainform do
          begin
               if (joistslateralmomentLE.value>0) or (joistslateralmomentRE.value>0) then
               begin
                    docase6;
               end;
          end;
     end
     else
     begin
          if not mainform.CaseCombo.Enabled then
             mainform.CaseCombo.Enabled:=true;
          if LRFD then
          begin
            docase1LRFD;
            
            docase3aLRFD;
            docase3bLRFD;

            docase4aLRFD;
            docase4bLRFD;

            docase5aLRFD;
            docase5bLRFD;

            docase6aLRFD;
            docase6bLRFD;

            if (mainform.joiststcaxialload.value>0) or (mainform.joistsbcaxialload.value>0) then
              docase2bLRFD;
            docase2aLRFD;
          end
          else
          begin
            docase5;
            with mainform do
            begin
                 if (joiststcaxialload.value>0) or (joistsbcaxialload.value>0) then
                    docase4;
                 if (joistslateralmomentLE.value>0) or (joistslateralmomentRE.value>0) then
                 begin
                      docase6;
                      docase7;
                      docase8;
                 end;
            end;
            docase3(1);
          end;
     end;
     calcsummary;
     if mainform.joistsconsolidate.Value then
        consolidate;
end;

end.
