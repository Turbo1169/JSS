unit Output;

interface

uses Windows, sysutils, graphics, printers, math, classes;

procedure drawjoist(tpaint:TCanvas; rcoord:trect);
procedure Drawbid(temppaint:TCanvas; scle,fontscle:single);
procedure Drawconf(temppaint:TCanvas; scle,fontscle:single);
procedure Drawstress(temppaint:TCanvas; scle,fontscle:single; page:integer);
procedure drawlogo(tpaint:tcanvas; scle:single);

implementation

uses main;

const
     m:single=0.03;

function dectoing(decn:single):shortstring; external 'comlib.dll';

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

procedure drawlogo(tpaint:tcanvas; scle:single);
var
   temprect:trect;
   x1,x2,y1,y2:integer;
   width,f:single;
begin
     width:=1.65;
     with tpaint do
     begin
          pen.color:=clblack;
          pen.width:=round(3/(printer.pageheight/11)*scle);
          rectangle(trunc(scle*0.22),trunc(scle*0.22),trunc(scle*(8.5-0.22)),trunc(scle*(11-0.22)));
          pen.width:=round(1/(printer.pageheight/11)*scle);
          rectangle(trunc(scle*0.25),trunc(scle*0.25),trunc(scle*(8.5-0.25)),trunc(scle*(11-0.25)));
          f:=mainform.image1.picture.graphic.width/mainform.image1.picture.graphic.height;
          x1:=trunc(scle*0.3); y1:=trunc(scle*0.4);
          x2:=x1+trunc(scle*width); y2:=y1+trunc(scle*(width/f));
          temprect.left:=x1;
          temprect.top:=y1;
          temprect.right:=x2;
          temprect.bottom:=y2;
          stretchdraw(temprect,mainform.image1.picture.graphic);
     end;
end;

{procedure drawlogo(tpaint:tcanvas; scle:single);
var
   temprect:trect;
   x1,x2,y1,y2:integer;
   f:single;
begin
     with tpaint do
     begin
          pen.color:=clblack;
          pen.width:=round(3/(printer.pageheight/11)*scle);
          rectangle(trunc(scle*0.22),trunc(scle*0.22),trunc(scle*(8.5-0.22)),trunc(scle*(11-0.22)));
          pen.width:=round(1/(printer.pageheight/11)*scle);
          rectangle(trunc(scle*0.25),trunc(scle*0.25),trunc(scle*(8.5-0.25)),trunc(scle*(11-0.25)));
          f:=mainform.image1.picture.graphic.width/mainform.image1.picture.graphic.height;
          x1:=trunc(scle*(0.3+0.75-((1.2-0.3)*f)/2)); y1:=trunc(scle*0.3);
          x2:=x1+trunc(scle*((1.2-0.3)*f)); y2:=trunc(scle*1.2);
          temprect.left:=x1;
          temprect.top:=y1;
          temprect.right:=x2;
          temprect.bottom:=y2;
          stretchdraw(temprect,mainform.image1.picture.graphic);
     end;
end;}

procedure drawjoist(tpaint:TCanvas; rcoord:trect);
var
   ded,max,max2,min,min2:single;
   x1,y1,x2,y2,x,y:integer;
   tempy,tempx,scle,scle2:single;
   rect1:trect;
begin
     joverst:=false;
     with mainform do
     begin
          scle2:=abs(rcoord.left-rcoord.right)/300;
          max:=0; max2:=0; min:=joistsscissoradd.value;
          for x:=1 to JointList.count do
          begin
               jointdata:=JointList.items[x-1];
               if jointdata^.coordX>max then
                  max:=jointdata^.coordX;
               if jointdata^.coordY>max2 then
                  max2:=jointdata^.coordY;
               if jointdata^.coordY<min then
                  min:=jointdata^.coordY;
          end;
          ded:=min; max2:=max2-ded; max:=max-2;
          min2:=max/2; min:=max2/2;
          if (rcoord.right-rcoord.left)/max<((rcoord.bottom-rcoord.top)-2)/max2 then
             scle:=(rcoord.right-rcoord.left)/max
          else
              scle:=((rcoord.bottom-rcoord.top)-2)/max2;
          min:=min*scle+((rcoord.bottom-rcoord.top)-2)/2;
          min2:=(rcoord.right-rcoord.left)/2-min2*scle;
          // partial loads
          if PartList.Count>0 then
          begin
                tempy:=0;
                for x:=1 to PartList.Count do
                begin
                      PartData:=PartList.Items[x-1];
                      if not PartData^.uplift then
                      begin
                        if partdata^.Force>tempy then
                                tempy:=partdata^.Force;
                        if partdata^.Force2>tempy then
                                tempy:=partdata^.Force2;
                      end;
                      tempy:=tempy/(abs(rcoord.top-rcoord.bottom)/10);
                end;
                for x:=1 to PartList.Count do
                begin
                      PartData:=PartList.Items[x-1];
                      if not PartData^.uplift then
                      begin
                              jointdata:=JointList.items[partdata^.joint1-1];
                              x1:=trunc((min2+(jointdata^.coordX-2)*scle)+rcoord.left);
                              y1:=trunc((min-(jointdata^.coordY-ded)*scle)+rcoord.top-scle2*0.5);
                              jointdata:=JointList.items[partdata^.joint2-1];
                              x2:=trunc((min2+(jointdata^.coordX-2)*scle)+rcoord.left);
                              y2:=trunc((min-(jointdata^.coordY-ded)*scle)+rcoord.top-scle2*0.5);
                              with tpaint do
                              begin
                                      Brush.Color:=clBlue;
                                      pen.color:=clBlue;
                                      brush.Style:=bsVertical;
                                      Polygon([Point(x1, y1), Point(x1, y1-trunc(partdata.Force/tempy)), Point(x2, y2-trunc(partdata.Force2/tempy)), Point(x2, y2)]);
                              end;
                      end;
                end;
          end;
          tpaint.brush.Style:=bsSolid;
          // concentrated loads
          if conclist.count>0 then
          for x:=1 to conclist.count do
          begin
               concdata:=conclist.items[x-1];
               findsupmemb;
               jointdata:=JointList.items[membdata^.joint2-1];
               tempy:=jointdata^.coordY;
               tempx:=jointdata^.coordX;
               jointdata:=JointList.items[membdata^.joint1-1];
               if jointdata^.coordY<tempy then
               begin
                 tempy:=jointdata^.coordY+(concdata^.dist-jointdata^.coordx)*tan(membdata^.angle);
               end
               else
               begin
                 tempy:=tempy+(tempx-concdata^.dist)*tan(membdata^.angle);
               end;
               x1:=trunc((min2+(concdata^.dist-2)*scle)+rcoord.left);
               y1:=trunc((min-(tempy-ded)*scle)+rcoord.top);
               with tpaint do
               begin
                    pen.color:=clgreen;
                    brush.color:=clgreen;
                    brush.style:=bssolid;
                    if concdata^.force>0 then
                    begin
                         moveto(x1,y1);
                         lineto(x1-trunc(1*scle2),y1-trunc(3*scle2));
                         lineto(x1+trunc(1*scle2),y1-trunc(3*scle2));
                         lineto(x1,y1);
                         floodfill(x1,y1-trunc(1*scle2),clgreen,fsborder);
                    end
                    else
                    begin
                         moveto(x1,y1+pen.width);
                         lineto(x1-trunc(1*scle2),y1+trunc(3*scle2)+pen.width);
                         lineto(x1+trunc(1*scle2),y1+trunc(3*scle2)+pen.width);
                         lineto(x1,y1+pen.width);
                         floodfill(x1,y1+trunc(1*scle2)+pen.width,clgreen,fsborder);
                    end;
               end;
          end;
          for x:=1 to 2 do {Supports}
          begin
               case x of
                    1:jointdata:=JointList.items[supp1-1];
                    2:jointdata:=JointList.items[supp2-1];
               end;
               x1:=trunc((min2+(jointdata^.coordX-2)*scle)+rcoord.left);
               y1:=trunc((min-(jointdata^.coordY-ded)*scle)+rcoord.top);
               with tpaint do
               begin
                    pen.color:=clred;
                    brush.color:=clred;
                    brush.style:=bssolid;
                    moveto(x1,y1+pen.width);
                    lineto(x1-trunc(1.5*scle2),y1+trunc(2.5*scle2)+pen.width);
                    lineto(x1+trunc(1.5*scle2),y1+trunc(2.5*scle2)+pen.width);
                    lineto(x1,y1+pen.width);
                    for y:=0 to 2 do
                    begin
                         moveto(x1+trunc(1.5*scle2)-trunc(scle2*y),y1+trunc(2.5*scle2)+pen.width);
                         lineto(x1+trunc(0.5*scle2)-trunc(scle2*y),y1+trunc(3.5*scle2)+pen.width);
                    end;
               end;
          end;
          findangle(tcsection.section);
          for x:=1 to sprinklist.count do {Sprinklers}
          begin
               Sprinkler:=SprinkList.items[x-1];
               with tpaint do
               begin
                    pen.color:=clred;
                    brush.color:=clred;
                    brush.style:=bssolid;
                    x1:=round((min2+(sprinkler^.x-sprinkler^.d/2-2)*scle)+rcoord.left);
                    y1:=round((min-(ed+angprop^.Y-sprinkler^.y-ded+sprinkler^.d/2)*scle)+rcoord.top)+1;
                    x2:=round(x1+sprinkler^.d*scle);
                    y2:=round(y1+sprinkler^.d*scle);
                    Ellipse(x1,y1,x2,y2);
                    floodfill(trunc(x1+sprinkler^.d/2*scle),trunc(y1+sprinkler^.d/2*scle),clred,fsborder);
               end;
          end;
          {tpaint.font.name:='Small fonts';
          tpaint.font.height:=10;}
          tpaint.brush.color:=clblack;
          tpaint.brush.style:=bssolid;
          tpaint.pen.color:=clblack;
          for x:=1 to memberlist.count do
          begin
              membdata:=MemberList.items[x-1];
              jointdata:=JointList.items[membdata^.joint1-1];
              x1:=trunc((min2+(jointdata^.coordX-2)*scle)+rcoord.left);
              y1:=trunc((min-(jointdata^.coordY-ded)*scle)+rcoord.top);
              jointdata:=JointList.items[membdata^.joint2-1];
              x2:=trunc((min2+(jointdata^.coordX-2)*scle)+rcoord.left);
              y2:=trunc((min-(jointdata^.coordY-ded)*scle)+rcoord.top);
              with tpaint do
              begin
                   if (membdata^.weld=1) and (copy(membdata^.position,1,1)<>'W') and (copy(membdata^.position,1,1)<>'V') and (membdata^.overst<>2) then
                   begin
                        if y2<y1 then
                        begin
                             rect1.left:=x1+trunc((membdata^.length*scle/2-1*scle2)*cos(membdata^.angle));
                             rect1.top:=y1-trunc(((membdata^.length*scle/2-1*scle2)/(membdata^.length*scle))*
                                  (membdata^.length*scle*sin(membdata^.angle)))+1;
                             rect1.right:=rect1.left+trunc(2*scle2*cos(membdata^.angle));
                             rect1.bottom:=rect1.top-trunc(2*scle2*sin(membdata^.angle));
                             rect1.left:=rect1.left-trunc(sin(membdata^.angle)*1*scle2);
                             rect1.top:=rect1.top-trunc(cos(membdata^.angle)*1*scle2);
                        end
                        else
                        begin
                             rect1.left:=x2-trunc((membdata^.length*scle/2-1*scle2)*cos(membdata^.angle));
                             rect1.top:=y2-trunc(((membdata^.length*scle/2-1*scle2)/(membdata^.length*scle))*
                                  (membdata^.length*scle*sin(membdata^.angle)))+1;
                             rect1.right:=rect1.left-trunc(2*scle2*cos(membdata^.angle));
                             rect1.bottom:=rect1.top-trunc(2*scle2*sin(membdata^.angle));
                             rect1.left:=rect1.left+trunc(sin(membdata^.angle)*1*scle2);
                             rect1.top:=rect1.top-trunc(cos(membdata^.angle)*1*scle2);
                        end;
                        fillrect(rect1);
                   end;
                   moveto(x1,y1+1);
                   if membdata^.overst=1 then
                   begin
                        tpaint.brush.color:=clred;
                        tpaint.pen.color:=clred;
                        joverst:=true;
                   end;
                   if membdata^.overst=2 then
                      pen.width:=trunc(scle2+1)
                   else
                       pen.width:=1;
                   lineto(x2,y2+1);
                   tpaint.brush.color:=clblack;
                   tpaint.pen.color:=clblack;
              end;
          end;
          tpaint.brush.Color:=clwhite;
          if (deltascle>0) and (jtype<>'C') then //Deflection
          begin
               if mainform.CaseCombo.ItemIndex=0 then
               begin
                        mainform.CaseCombo.ItemIndex:=1;
                        mainform.CaseComboChange(nil);
               end;
               tpaint.font.name:='MS Serif';
               tpaint.Font.Color:=clred;
               tpaint.brush.style:=bssolid;
               tpaint.pen.color:=clred;
               tpaint.font.height:=trunc(scle2*6);
               tpaint.TextOut(rcoord.left,rcoord.top,'Deflection '+CaseCombo.Text);
               tpaint.font.height:=trunc(scle2*4);
               for x:=1 to memberlist.count do
               begin
                   membdata:=MemberList.items[x-1];
                   jointdata:=JointList.items[membdata^.joint1-1];
                   x1:=trunc((min2+(jointdata^.coordX-2+jointdata^.DeltaX)*scle)+rcoord.left);
                   y1:=trunc((min-(jointdata^.coordY-ded+jointdata^.DeltaY*deltascle)*scle)+rcoord.top);
                   tpaint.TextOut(x1,y1+1,format('%0.2f',[jointdata^.DeltaY]));
                   jointdata:=JointList.items[membdata^.joint2-1];
                   x2:=trunc((min2+(jointdata^.coordX-2+jointdata^.DeltaX)*scle)+rcoord.left);
                   y2:=trunc((min-(jointdata^.coordY-ded+jointdata^.DeltaY*deltascle)*scle)+rcoord.top);
                   tpaint.TextOut(x2,y2+1,format('%0.2f',[jointdata^.DeltaY]));
                   with tpaint do
                   begin
                        moveto(x1,y1+1);
                        if membdata^.overst=1 then
                        begin
                             tpaint.brush.color:=clred;
                             tpaint.pen.color:=clred;
                             joverst:=true;
                        end;
                        if membdata^.overst=2 then
                           pen.width:=trunc(scle2+1)
                        else
                            pen.width:=1;
                        lineto(x2,y2+1);
                   end;
               end;
               tpaint.Font.Color:=clblack;
          end;
          tpaint.pen.color:=clblack;
     end;
end;

procedure Drawbid(temppaint:TCanvas; scle,fontscle:single);
var
  Line,line2,line3:single;
  x:integer;
  desc:string;

begin
     with mainform,temppaint do
     begin
          drawlogo(temppaint,scle);
          font.name:='Arial';
          font.size:=12;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          textout(trunc(scle*4.0),trunc(scle*0.30),'BID SHEET');
          dobox(temppaint,fontscle,scle,2,0.5,1,'Job Number:',jobinfojobnumber.value);
          dobox(temppaint,fontscle,scle,3,0.5,4.2,'Job Name:',jobjobname.value+' - '+jobinfoDescription.value);
          line:=dobox(temppaint,fontscle,scle,7.2,0.5,1,'Date Quoted:',datetostr(jobinfodatequoted.value));
          dobox(temppaint,fontscle,scle,2,line,2.5,'Location:',joblocation2.value);
          dobox(temppaint,fontscle,scle,4.5,line,3.7,'Customer:',jobcustomer.value);
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          textout(trunc(scle*0.3),trunc(scle*1.3),'Base Bid');
          line:=1.3+font.height/scle;
          docell(temppaint,fontscle,scle,0.3,line,0.75,'Description','C');
          docell(temppaint,fontscle,scle,1.05,line,0.45,'Pieces','C');
          docell(temppaint,fontscle,scle,1.5,line,0.65,'Tons','C');
          docell(temppaint,fontscle,scle,2.15,line,0.95,'Mat. Cost','C');
          docell(temppaint,fontscle,scle,3.1,line,0.65,'Ton/L.H.','C');
          docell(temppaint,fontscle,scle,3.75,line,0.65,'Line Hrs.','C');
          docell(temppaint,fontscle,scle,4.4,line,0.95,'Labor Cost','C');
          docell(temppaint,fontscle,scle,5.35,line,0.95,'Total Cost','C');
          docell(temppaint,fontscle,scle,6.3,line,0.95,'Total Profit','C');
          line:=docell(temppaint,fontscle,scle,7.25,line,0.95,'Total Price','C');
          for x:=0 to 7 do
          begin
               case x of
                 0:desc:='L1';
                 1:desc:='L2';
                 2:desc:='LS';
                 3:desc:='JG';
                 4:desc:='HB';
                 5:desc:='XB';
                 6:desc:='KB';
                 7:desc:='JS';
               end;
               docell(temppaint,fontscle,scle,0.3,line,0.75,desc,'C');
               docell(temppaint,fontscle,scle,1.05,line,0.45,inttostr(jobinfo.fieldbyname(desc+' Pieces').asinteger),'R');
               docell(temppaint,fontscle,scle,1.5,line,0.65,format('%8.2n',[jobinfo.fieldbyname(desc+' Tons').asfloat]),'R');
               docell(temppaint,fontscle,scle,2.15,line,0.95,
                      format('%10.2m',[jobinfo.fieldbyname(desc+' Material').asfloat]),'R');
               if x<4 then
               begin
                    docell(temppaint,fontscle,scle,3.1,line,0.65,
                          format('%8.2n',[jobinfo.fieldbyname(desc+' TonLH').asfloat]),'R');
                    docell(temppaint,fontscle,scle,3.75,line,0.65,
                          format('%8.2n',[jobinfo.fieldbyname(desc+' Line Hrs').asfloat]),'R');
                    docell(temppaint,fontscle,scle,6.3,line,0.95,
                          format('%10.2m',[jobinfo.fieldbyname(desc+' Total Profit').asfloat]),'R');
               end;
               docell(temppaint,fontscle,scle,4.4,line,0.95,format('%10.2m',[jobinfo.fieldbyname(desc+' Labor').asfloat]),'R');
               docell(temppaint,fontscle,scle,5.35,line,0.95,format('%10.2m',[jobinfo.fieldbyname(desc+' Cost').asfloat]),'R');
               if x<4 then
               line:=docell(temppaint,fontscle,scle,7.25,line,0.95,
                            format('%10.2m',[jobinfo.fieldbyname(desc+' price profit').asfloat]),'R')
               else
                   line:=docell(temppaint,fontscle,scle,7.25,line,0.95,
                            format('%10.2m',[jobinfo.fieldbyname(desc+' Cost').asfloat]),'R');
          end;
          docell(temppaint,fontscle,scle,0.3,line,0.75,'Total','C');
          docell(temppaint,fontscle,scle,1.05,line,0.45,inttostr(jobinfo.fieldbyname('total pieces').asinteger),'R');
          docell(temppaint,fontscle,scle,1.5,line,0.65,format('%8.2n',[jobinfo.fieldbyname('total Tons').asfloat]),'R');
          docell(temppaint,fontscle,scle,2.15,line,0.95,format('%10.2m',[jobinfo.fieldbyname('total Material').asfloat]),'R');
          docell(temppaint,fontscle,scle,3.1,line,0.65,format('%8.2n',[jobinfo.fieldbyname('Tons LH').asfloat]),'R');
          docell(temppaint,fontscle,scle,3.75,line,0.65,format('%8.2n',[jobinfo.fieldbyname('total lh').asfloat]),'R');
          docell(temppaint,fontscle,scle,4.4,line,0.95,format('%10.2m',[jobinfo.fieldbyname('total Labor').asfloat]),'R');
          docell(temppaint,fontscle,scle,5.35,line,0.95,format('%10.2m',[jobinfo.fieldbyname('total Cost').asfloat]),'R');
          docell(temppaint,fontscle,scle,6.3,line,0.95,format('%10.2m',[jobinfo.fieldbyname('Total Profit').asfloat]),'R');
          line:=docell(temppaint,fontscle,scle,7.25,line,0.95,
                format('%10.2m',[jobinfo.fieldbyname('total price').asfloat]),'R');
          jobmisc.disablecontrols;
          for x:=0 to 3 do
          begin
               font.name:='Arial';
               font.size:=10;
               font.height:=round(-font.height*fontscle);
               font.style:=[fsbold];
               line2:=line+0.15;
               doextras(x);
               if jobmisc.recordcount>0 then
               begin
                    textout(trunc(scle*0.3),trunc(scle*line2),extrastabs.tabs.strings[x]);
                    line:=line2+font.height/scle;;
                    docell(temppaint,fontscle,scle,0.3,line,0.75,'Quantity','C');
                    docell(temppaint,fontscle,scle,1.05,line,2,'Description','C');
                    docell(temppaint,fontscle,scle,3.05,line,0.75,'Unit Price','C');
                    docell(temppaint,fontscle,scle,3.8,line,0.6,'Unit','C');
                    line:=docell(temppaint,fontscle,scle,4.4,line,0.95,'Total Price','C');
                    jobmisc.first;
                    while not jobmisc.eof do
                    begin
                         docell(temppaint,fontscle,scle,0.3,line,0.75,inttostr(jobmiscquantity.value),'R');
                         docell(temppaint,fontscle,scle,1.05,line,2,jobmiscdescription.value,'L');
                         docell(temppaint,fontscle,scle,3.05,line,0.75,format('%10.2m',[jobmiscunitprice.value]),'R');
                         docell(temppaint,fontscle,scle,3.8,line,0.6,jobmiscunit.value,'L');
                         line2:=line;
                         line:=docell(temppaint,fontscle,scle,4.4,line,0.95,format('%10.2m',[jobmisctotalprice.value]),'R');
                         jobmisc.next;
                    end;
                    docell(temppaint,fontscle,scle,5.35,line2,1.9,'Total '+extrastabs.tabs.strings[x]+':','T');
                    line2:=docell(temppaint,fontscle,scle,7.25,line2,0.95,format('%10.2m',[jobinfo.fieldbyname('Total '
                         +extrastabs.tabs.strings[x]).asfloat]),'T');
               end;
               if x=1 then
               begin
                    if jobinfoextras.value<>0 then
                    begin
                         docell(temppaint,fontscle,scle,5.35,line2,1.9,'Extra Charge:','T');
                         line2:=docell(temppaint,fontscle,scle,7.25,line2,0.95,format('%10.2m',[jobinfoextras.value]),'T');
                    end;
                    line:=line2;
                    docell(temppaint,fontscle,scle,5.35,line2,1.9,'Subtotal #1 (Plant Price):','T');
                    line2:=docell(temppaint,fontscle,scle,7.25,line2,0.95,format('%10.2m',[jobinfosubtotal1.value]),'S');
               end;
               if x=2 then
               begin
                    if jobinfocommission.value>0 then
                    begin
                         docell(temppaint,fontscle,scle,5.35,line2,1.9,'Commissions:','T');
                         line2:=docell(temppaint,fontscle,scle,7.25,line2,0.95,
                                format('%10.2m',[jobinfocommission.value]),'T');
                    end;
                    line:=line2;
                    docell(temppaint,fontscle,scle,5.35,line2,1.9,'Subtotal #2 (El Paso):','T');
                    line2:=docell(temppaint,fontscle,scle,7.25,line2,0.95,format('%10.2m',[jobinfosubtotal2.value]),'S');
               end;
          end;
          doextras(extrastabs.TabIndex);
          jobmisc.enablecontrols;
          docell(temppaint,fontscle,scle,5.35,line2,1.9,'Selling Price:','T');
          docell(temppaint,fontscle,scle,7.25,line2,0.95,format('%10.2m',[jobinfosellingprice.value]),'S');
          line3:=10.4;
          dobox(temppaint,fontscle,scle,0.3,line3,1.5,'Tons Sold:',format('%0.2f',[jobinfotonssold.value])+
          ' ('+format('%0.2f',[jobinfooverweight.value])+'%)');
          if jobinfotonssold.value>0 then
          begin
               dobox(temppaint,fontscle,scle,1.8,line3,1,'Price/Ton EP:',
                    format('%0.2m',[jobinfosubtotal2.value/jobinfotonssold.value]));
               dobox(temppaint,fontscle,scle,2.8,line3,1,'Price/Ton Job:',
                    format('%0.2m',[jobinfosellingprice.value/jobinfotonssold.value]));
          end
          else
          begin
               dobox(temppaint,fontscle,scle,1.8,line3,1,'Price/Ton EP:',
                    format('%0.2m',[0.00]));
               dobox(temppaint,fontscle,scle,2.8,line3,1,'Price/Ton Job:',
                    format('%0.2m',[0.00]));
          end;
          dobox(temppaint,fontscle,scle,3.8,line3,1,'Profit/LH:',format('%0.2m',[jobinfoprofitLH.value]));
          if jobinfosellingprice.value>0 then
             dobox(temppaint,fontscle,scle,4.8,line3,1.95,'Total Profit:',format('%0.2m',[jobinfototalprofit.value])+
             ' ('+format('%0.2f',[jobinfototalprofit.value/jobinfosellingprice.value*100])+'%)')
          else
              dobox(temppaint,fontscle,scle,4.8,line3,1.95,'Total Profit:',format('%0.2m',[0.00]));
          dobox(temppaint,fontscle,scle,6.75,line3,1.45,'Selling Price:',format('%0.2m',[jobinfosellingprice.value]));
     end;
end;

procedure Drawconf(temppaint:TCanvas; scle,fontscle:single);
var
  Line,line2,col:single;
  x:integer;
  desc:string;
  exc:array[1..26] of string;
begin
     with mainform,temppaint do
     begin
          drawlogo(temppaint,scle);
          font.name:='Arial';
          font.size:=12;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          textout(trunc(scle*4.25),trunc(scle*0.30),'QUOTE');
          dobox(temppaint,fontscle,scle,2,0.5,1,'Job Number:',jobinfojobnumber.value);
          dobox(temppaint,fontscle,scle,3,0.5,4.2,'Job Name:',jobjobname.value+' - '+jobinfoDescription.value);
          line:=dobox(temppaint,fontscle,scle,7.2,0.5,1,'Date Quoted:',datetostr(jobinfodatequoted.value));
          dobox(temppaint,fontscle,scle,2,line,2.5,'Location:',joblocation2.value);
          dobox(temppaint,fontscle,scle,4.5,line,3.7,'Customer:',jobcustomer.value);
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          textout(trunc(scle*0.3),trunc(scle*1.3),'Joists, Girders and Bridging');
          line:=1.3+font.height/scle;
          docell(temppaint,fontscle,scle,0.3,line,2,'Description','C');
          docell(temppaint,fontscle,scle,2.3,line,0.75,'Quantity','C');
          line2:=line;
          line:=docell(temppaint,fontscle,scle,3.05,line,0.85,'Tons','C');
          docell(temppaint,fontscle,scle,4,line2,1,'Total Pieces:','L');
          line2:=docell(temppaint,fontscle,scle,5,line2,1.5,
               inttostr(jobinfo.fieldbyname('total pieces').asinteger),'L');
          docell(temppaint,fontscle,scle,4,line2,1,'Total Tons:','L');
          line2:=docell(temppaint,fontscle,scle,5,line2,1.5,format('%0.2n',[jobinfo.fieldbyname('total Tons').asfloat
              *(1+jobinfooverweight.value/100)]),'L');
          doextras(0);
          docell(temppaint,fontscle,scle,4,line2,1,'Paint:','L');
          line2:=docell(temppaint,fontscle,scle,5,line2,1.5,jobmiscdescription.value,'L')+0.15;
          pen.color:=clblack;
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          pen.width:=round(3/(printer.pageheight/11)*scle);
          {rectangle(trunc(scle*4.5),trunc(scle*line2),trunc(scle*(8.5-0.3)),trunc(scle*(line2+1)));
          pen.width:=round(1/(printer.pageheight/11)*scle);
          line2:=line2+0.15;
          textout(trunc(scle*4.75),trunc(scle*line2),'This Quote is for Joists and Joist Girders that');
          line2:=line2+font.height/scle;
          textout(trunc(scle*4.75),trunc(scle*line2),'do not Conform to Certain Parts of Proposed');
          line2:=line2+font.height/scle;
          textout(trunc(scle*4.75),trunc(scle*line2),'OSHA Requirements Contained in 29 CFR Part');
          line2:=line2+font.height/scle;
          textout(trunc(scle*4.75),trunc(scle*line2),'1926 - Safety Standards for Steel Erection;');
          line2:=line2+font.height/scle;
          textout(trunc(scle*4.75),trunc(scle*line2),'Proposed Rule (63 FR 43451)');
          line2:=line2+font.height/scle+0.25;}
          if jobstate.value='TX' then
          begin
               textout(trunc(scle*4.5),trunc(scle*line2),'* Sales Tax not Included and Will be Billed Unless');
               line2:=line2+font.height/scle;
               textout(trunc(scle*4.5),trunc(scle*line2),'  a Resale or Exemption Certificate is Received.');
               line2:=line2+font.height/scle;
          end;
          for x:=0 to 7 do
          begin
               case x of
                 0:desc:='L1';
                 1:desc:='L2';
                 2:desc:='LS';
                 3:desc:='JG';
                 4:desc:='HB';
                 5:desc:='XB';
                 6:desc:='KB';
                 7:desc:='JS';
               end;
               docell(temppaint,fontscle,scle,2.3,line,0.75,inttostr(jobinfo.fieldbyname(desc+' Pieces').asinteger),'R');
               docell(temppaint,fontscle,scle,3.05,line,0.85,
                   format('%8.2n',[jobinfo.fieldbyname(desc+' Tons').asfloat*(1+jobinfooverweight.value/100)]),'R');
               case x of
                 0:desc:='Short Span Round';
                 1:desc:='Short Span Crimped';
                 2:desc:='Long Span Joists';
                 3:desc:='Joist Girders';
                 4:desc:='Horizontal Bridging';
                 5:desc:='Diagonal Bridging';
                 6:desc:='Knee Braces';
                 7:desc:='Joist Substitutes';
               end;
               line:=docell(temppaint,fontscle,scle,0.3,line,2,desc,'L');
          end;
          jobmisc.disablecontrols;
          x:=1;
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          line2:=line2+0.15;
          doextras(x); col:=0;
          if jobmisc.recordcount>0 then
          begin
               textout(trunc(scle*0.3),trunc(scle*(line+0.15)),'Misc Included in Price');
               line:=line+0.15+font.height/scle;
               docell(temppaint,fontscle,scle,0.3,line,2,'Description','C');
               line:=docell(temppaint,fontscle,scle,2.3,line,0.75,'Quantity','C');
               jobmisc.first;
               line2:=line+0.15;
               while not jobmisc.eof do
               begin
                    if jobmiscitem.value<>7 then
                    begin
                         docell(temppaint,fontscle,scle,0.3,line,2,jobmiscdescription.value,'L');
                         line:=docell(temppaint,fontscle,scle,2.3,line,0.75,inttostr(jobmiscquantity.value),'R');
                    end
                    else
                        col:=jobmisctotalprice.value;
                    jobmisc.next;
               end;
          end;
          docell(temppaint,fontscle,scle,5.35,line2,1.9,'Total Joists and Bridging:','T');
          line2:=docell(temppaint,fontscle,scle,7.25,line2,0.95,
               format('%10.2m',[jobinfo.fieldbyname('Subtotal2').asfloat-col]),'T');
          if col>0 then
          begin
               docell(temppaint,fontscle,scle,5.35,line2,1.9,'Total for Nailer Instalation:','T');
               line2:=docell(temppaint,fontscle,scle,7.25,line2,0.95,format('%10.2m',[col]),'T');
          end;
          docell(temppaint,fontscle,scle,5.35,line2,1.9,'Total Freight:','T');
          line2:=docell(temppaint,fontscle,scle,7.25,line2,0.95,
               format('%10.2m',[jobinfo.fieldbyname('Total Freight').asfloat]),'T');
          doextras(extrastabs.tabindex);
          jobmisc.enablecontrols;
          docell(temppaint,fontscle,scle,5.35,line2,1.9,'Total Price:','T');
          line2:=docell(temppaint,fontscle,scle,7.25,line2,0.95,format('%10.2m',[jobinfosellingprice.value]),'S');
          if line2>line then
             line:=line2;
          line:=line+0.15;
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          textout(trunc(scle*0.3),trunc(scle*line),'Additional Notes');
          line:=line+font.height/scle;
          line2:=line;
          font.style:=[];
          col:=0.3;
          mainform.memo1.width:=300;
          for x:=0 to mainform.memo1.lines.count-1 do
          begin
               textout(trunc(scle*col),trunc(scle*line),mainform.memo1.Lines[x]);
               line:=line+font.height/scle;
               if line>6.75 then
               begin
                    line:=line2;
                    col:=col+3.95;
               end;
               if col>4.25 then
                  Break;
          end;
          mainform.memo1.width:=404;
          line:=6.9;
          line2:=line;
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          textout(trunc(scle*0.3),trunc(scle*line),'STANDARD QUALIFICATIONS AND EXCLUSIONS');
          line:=line+font.height/scle;
          font.size:=8;
          font.height:=round(-font.height*fontscle);
          font.style:=[];
          if JobInfoValidUntil.Value>0 then
                exc[1]:=' 1.- Price Good Until '+datetostr(JobInfoValidUntil.Value)
          else
                exc[1]:=' 1.- Price Good Until '+datetostr(jobinfodatequoted.value+30);
          exc[2]:=' 2.- FOB Plant with Freight Allowed to Nearest Jobsite Address';
          exc[3]:=' 3.- SJI Welding Utilizing AWS Certified Welders and Procedures';
          exc[4]:=' 4.- Weld Inspections, if Required Must be Made at our Plant (cost not by JSS) and are Final';
          exc[5]:=' 5.- Will Fabricate in Conformance with Latest SJI Standards '+
                  'Unless Specifically Notified';
          exc[6]:='     in Writing Otherwise';
          exc[7]:=' 6.- Standard JSS Panel Layout for all Members';
          exc[8]:=' 7.- One Dip Coat Standard Primer Unless Otherwise Noted';
          exc[9]:=' 8.- Standard Cleaning Unless Otherwise Noted';
          exc[10]:=' 9.- No Taxes Included';
          exc[11]:='10.- No Additional Webs at Concentrated Loads by JSS';
          exc[12]:='11.- No Holes, Clips or Plates for Attaching Other Trades';
          exc[13]:='12.- No Cost of Shop Inspection in Our Price';
          exc[14]:='13.- JSS Will Furnish Bolts From Our Product to Our Product Only';
          exc[15]:='14.- Terms: 1% 10 Days, Net 30 Days, No Retainage Permited';
          exc[16]:='15.- Exclude Misc. Angles, Kickers, Braces or Plates';
          exc[17]:='16.- Exclude Special Hangers';
          exc[18]:='17.- No Bridging Anchors or Sleeve Anchors';
          exc[19]:='18.- JSS is a Purchase Order Company Only, We Accept no Liquidated Damages';
          exc[20]:='19.- JSS Will Not Detail to Fit Fire Sprinkler Lines Unless Specifically';
          exc[21]:='      Asked for at an Additional Cost';
          exc[22]:='20.- Additional Engineering Performed for Load Changes, Fixes, Etc.';
          exc[23]:='      Other Than Our Fault is Extra';
          exc[24]:='21.- Splice Assembly to be Done by Customer (cost not by JSS)';
          exc[25]:='22.- JSS Will not be Responsible for Misalignment of Top Chord Extensions due to Fabrication,';
          exc[26]:='      Shipping or Field Conditions, any Field Adjustments will be at no Cost to JSS';
          for x:=1 to 26 do
          begin
               case x of
               19:font.style:=[fsbold];
               20:font.style:=[];
               25:font.style:=[fsbold];
               end;
               textout(trunc(scle*0.3),trunc(scle*line),exc[x]);
               line:=line+font.height/scle;
          end;
          line:=line2;
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          textout(trunc(scle*5.5),trunc(scle*line),'DELIVERY TIME (1 WEEK AFTER FAB)');
          line:=line+font.height/scle;
          docell(temppaint,fontscle,scle,5.5,line,1,'Weeks','L');
          docell(temppaint,fontscle,scle,6.5,line,0.85,'Detail Job','C');
          line:=docell(temppaint,fontscle,scle,7.35,line,0.85,'List Job','C');
          docell(temppaint,fontscle,scle,5.5,line,1,'Detail','L');
          docell(temppaint,fontscle,scle,6.5,line,0.85,inttostr(jobinfodetail.value),'R');
          line:=docell(temppaint,fontscle,scle,7.35,line,0.85,'','C');
          docell(temppaint,fontscle,scle,5.5,line,1,'Approval','L');
          docell(temppaint,fontscle,scle,6.5,line,0.85,inttostr(jobinfoapproval.value),'R');
          line:=docell(temppaint,fontscle,scle,7.35,line,0.85,'','C');
          docell(temppaint,fontscle,scle,5.5,line,1,'Fabrication','L');
          docell(temppaint,fontscle,scle,6.5,line,0.85,inttostr(jobinfofabrication.value),'R');
          line:=docell(temppaint,fontscle,scle,7.35,line,0.85,inttostr(jobinfolist.value),'R');
          docell(temppaint,fontscle,scle,5.5,line,1,'Total','L');
          docell(temppaint,fontscle,scle,6.5,line,0.85,inttostr(jobinfodetail.value+
             jobinfoapproval.value+jobinfofabrication.value),'R');
          line:=docell(temppaint,fontscle,scle,7.35,line,0.85,inttostr(jobinfolist.value),'R');
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          line:=line+font.height/scle;
          textout(trunc(scle*4.5),trunc(scle*line),'* Customer Must Specify Sequence Schedule');
          line:=line+font.height/scle;
          textout(trunc(scle*4.5),trunc(scle*line),'  at the Time We Receive Purchase Order.');
          line:=line+(font.height/scle)*2;
          textout(trunc(scle*4.5),trunc(scle*line),'* Only the Structural Plans Will be Detailed.');
          font.name:='Arial';
          font.size:=10;
          font.height:=round(-font.height*fontscle);
          font.style:=[fsbold];
          line:=10.25;
          textout(trunc(scle*2.75),trunc(scle*line),'JOIST STRUCTURAL SYSTEMS S.A. DE C.V.');
          line:=line+font.height/scle;
          line2:=line;
          font.name:='Arial';
          font.size:=10;
          font.style:=[];
          font.height:=round(-font.height*fontscle);
          textout(trunc(scle*0.4),trunc(scle*line),'5812 CROMO DRIVE | EL PASO, TX 79912');
          //line:=line+font.height/scle;
          //textout(trunc(scle*0.4),trunc(scle*line),'PHONE (915)726-6285 | FAX (01152656)648-6083');
          line:=line2;
          textout(trunc(scle*3.25),trunc(scle*line),'AVE. TECNOLOGICO 6320, COL. AEROPUERTO | CD. JUAREZ, CHIH. 32500');
          line:=line+font.height/scle;
          textout(trunc(scle*2.5),trunc(scle*line),'TEL (011-52-656)170-4803, FAX (011-52-656) 170-4804');
     end;
end;

procedure Drawstress(temppaint:TCanvas; scle,fontscle:single; page:integer);
var
  temprect:trect;
  maxcv1,maxtv1,maxv1l,maxv2l,bct,bcc,tct,tcc,Line,line2:single;
  allowtv1,allowtv2:single;
  v1max,v2max,x,y,m:integer;
  temp:string;
  v1,v2,v1v:boolean;

  procedure title;
  begin
       with mainform,temppaint do
       begin
            drawlogo(temppaint,scle);
            font.name:='Arial';
            font.size:=12;
            font.height:=round(-font.height*fontscle);
            font.style:=[fsbold];
            textout(trunc(scle*3.5),trunc(scle*0.30),'STRESS ANALYSIS - PAGE '+inttostr(page));
            textout(trunc(scle*6.5),trunc(scle*0.30),'SJI 2015 DESIGN GUIDE');
            dobox(temppaint,fontscle,scle,2,0.5,1,'Job Number:',jobjobnumber.value);
            if dept=0 then
               dobox(temppaint,fontscle,scle,3,0.5,4.2,'Job Name:',jobjobname.value+' - '+jobinfoDescription.value)
            else
                dobox(temppaint,fontscle,scle,3,0.5,4.2,'Job Name:',jobjobname.value+' - '+sequenceDescription.value);
            line:=dobox(temppaint,fontscle,scle,7.2,0.5,1,'Date Run:',datetostr(date));
            dobox(temppaint,fontscle,scle,2,line,2.5,'Location:',joblocation2.value);
            temp:=jdesc.caption+' '+joistsdescription.value;
            dobox(temppaint,fontscle,scle,4.5,line,3,'Joist Description:',temp);
            dobox(temppaint,fontscle,scle,7.5,line,0.7,'Mark:',joistsmark.value);
       end;
  end;

  procedure docolumn(endp:endptype; title:string; colp:single);
  var
     z:integer;
  begin
       with temppaint do
       begin
            line:=docell(temppaint,fontscle,scle,colp,line,0.95,title,'C');
            line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2f',[endp.l]),'R');
            if (endp.f<>0) or (endp.bending<>0) then
            begin
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2n',[endp.bending]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2n',[endp.f]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2n',[endp.fa2]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2f',[endp.lr]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2n',[endp.fcr]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2n',[endp.fa]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2n',[endp.fe]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.4f',[endp.cm]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2f',[endp.me]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2f',[endp.mi]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2f',[endp.ppfb]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.2f',[endp.mpfb]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,inttostr(endp.fillers),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%11.2n',[endp.fa2+endp.ppfb]),'R');
                 line:=docell(temppaint,fontscle,scle,colp,line,0.95,format('%6.4n',[endp.bratio+endp.fa2/endp.fa]),'R');
            end
            else
                 for z:=1 to 15 do
                      line:=docell(temppaint,fontscle,scle,colp,line,0.95,'-','C');
       end;
  end;

begin
     with mainform,temppaint do
     begin
          if page=1 then
          begin
               title;
               font.name:='Arial';
               font.size:=10;
               font.height:=round(-font.height*fontscle);
               font.style:=[fsbold];
               textout(trunc(scle*0.3),trunc(scle*1.25),'Geometry');
               line:=1.25+font.height/scle;
               dobox(temppaint,fontscle,scle,0.3,line,1,'Base Length:',joistsbaselength.value);
               dobox(temppaint,fontscle,scle,1.3,line,1,'Working Length:',dectoing(wl));
               dobox(temppaint,fontscle,scle,2.3,line,1,'Joist Depth:',format('%6.2f',[depth]));
               dobox(temppaint,fontscle,scle,3.3,line,1,'Efective Depth:',format('%6.2f',[ed]));
               dobox(temppaint,fontscle,scle,4.3,line,1.25,'BC Panel Length:',bcpanels.caption);
               line:=dobox(temppaint,fontscle,scle,5.55,line,2.65,'Shape:',jshape.caption)+0.05;
               line2:=line;
               docell(temppaint,fontscle,scle,0.3,line,1,'Variable','C');
               docell(temppaint,fontscle,scle,1.3,line,0.7,'Left End','C');
               line:=docell(temppaint,fontscle,scle,2,line,0.7,'Right End','C');
               docell(temppaint,fontscle,scle,0.3,line,1,'BC Panel','L');
               docell(temppaint,fontscle,scle,1.3,line,0.7,joistsbcpanelsle.value,'L');
               line:=docell(temppaint,fontscle,scle,2,line,0.7,joistsbcpanelsre.value,'L');
               docell(temppaint,fontscle,scle,0.3,line,1,'TC Panel','L');
               docell(temppaint,fontscle,scle,1.3,line,0.7,joiststcpanelsle.value,'L');
               line:=docell(temppaint,fontscle,scle,2,line,0.7,joiststcpanelsre.value,'L');
               docell(temppaint,fontscle,scle,0.3,line,1,'First Half','L');
               docell(temppaint,fontscle,scle,1.3,line,0.7,joistsfirsthalfle.value,'L');
               line:=docell(temppaint,fontscle,scle,2,line,0.7,joistsfirsthalfre.value,'L');
               docell(temppaint,fontscle,scle,0.3,line,1,'First Diag.','L');
               docell(temppaint,fontscle,scle,1.3,line,0.7,joistsfirstdiagle.value,'L');
               line:=docell(temppaint,fontscle,scle,2,line,0.7,joistsfirstdiagre.value,'L');
               docell(temppaint,fontscle,scle,0.3,line,1,'Depth','L');
               docell(temppaint,fontscle,scle,1.3,line,0.7,format('%0.2f',[joistsdepthle.value]),'L');
               line:=docell(temppaint,fontscle,scle,2,line,0.7,format('%0.2f',[joistsdepthre.value]),'L');
               rectangle(trunc(scle*2.7),trunc(scle*line2),trunc(scle*8.2),trunc(scle*line));
               temprect.left:=trunc(scle*2.75);
               temprect.top:=trunc(scle*(line2+0.05));
               temprect.right:=trunc(scle*(8.15));
               temprect.bottom:=trunc(scle*line);
               drawjoist(temppaint,temprect);
               font.name:='Arial';
               font.size:=10;
               font.height:=round(-font.height*fontscle);
               font.style:=[fsbold];
               line:=line+font.height/scle;
               textout(trunc(scle*0.3),trunc(scle*line),'Loads');
               line:=line+font.height/scle;
               for x:=1 to loadlist.count do
               begin
                    loads:=loadlist.items[x-1];
                    if odd(x) then
                    begin
                         docell(temppaint,fontscle,scle,0.3,line,2.5,loads^.desc,'L');
                         if x=loadlist.count then
                         begin
                                if (loads^.Load2>=0) and (loads^.load<>loads^.load2) then
                                        line:=docell(temppaint,fontscle,scle,2.8,line,1.15,format('%0.2n',[loads^.load])+'-'+format('%0.2n',[loads^.load2]),'R')
                                else
                                        line:=docell(temppaint,fontscle,scle,2.8,line,1.15,format('%0.2n',[loads^.load]),'R');
                         end
                         else
                         begin
                                if (loads^.Load2>=0) and (loads^.load<>loads^.load2) then
                                        docell(temppaint,fontscle,scle,2.8,line,1.15,format('%0.2n',[loads^.load])+'-'+format('%0.2n',[loads^.load2]),'R')
                                else
                                        docell(temppaint,fontscle,scle,2.8,line,1.15,format('%0.2n',[loads^.load]),'R');
                         end;
                    end
                    else
                    begin
                         docell(temppaint,fontscle,scle,4,line,2.5,loads^.desc,'L');
                         if (loads^.Load2>=0) and (loads^.load<>loads^.load2) then
                                 line:=docell(temppaint,fontscle,scle,6.5,line,1.15,format('%0.2n',[loads^.load])+'-'+format('%0.2n',[loads^.load2]),'R')
                         else
                                 line:=docell(temppaint,fontscle,scle,6.5,line,1.15,format('%0.2n',[loads^.load]),'R');
                    end;
               end;
               font.name:='Arial';
               font.size:=10;
               font.height:=round(-font.height*fontscle);
               font.style:=[fsbold];
               line:=line+font.height/scle;
               if LRFD then
                  textout(trunc(scle*0.3),trunc(scle*line),'Stress Analysis Summary (LRFD)')
               else
                  textout(trunc(scle*0.3),trunc(scle*line),'Stress Analysis Summary (ASD)');
               line:=line+font.height/scle;
               dobox(temppaint,fontscle,scle,0.3,line,0.95,'Int. Panel TC:',format('%0.2n',[TCSection.maxintp]));
               dobox(temppaint,fontscle,scle,1.25,line,0.95,'Max Panel BC:',format('%0.2n',[BCSection.maxintp]));
               dobox(temppaint,fontscle,scle,2.2,line,1.2,'Reaction LE:',format('%0.2n',[maxr1]));
               dobox(temppaint,fontscle,scle,3.4,line,1.2,'Reaction RE:',format('%0.2n',[maxr2]));
               if jtype='C' then
                  dobox(temppaint,fontscle,scle,4.6,line,1.2,'Minimum Shear:',format('%0.2n',[minshr]))
               else
                   if maxr1>maxr2 then
                      dobox(temppaint,fontscle,scle,4.6,line,1.2,'Minimum Shear:',format('%0.2n',[maxr1/4]))
                   else
                       dobox(temppaint,fontscle,scle,4.6,line,1.2,'Minimum Shear:',format('%0.2n',[maxr2/4]));
               dobox(temppaint,fontscle,scle,5.8,line,1.2,'Max TC Comp.:',format('%0.2n',[abs(TCSection.maxforce)]));
               line:=dobox(temppaint,fontscle,scle,7,line,1.2,'Max BC Tension',format('%0.2n',[BCSection.maxforce]))+0.05;
               docell(temppaint,fontscle,scle,0.3,line,0.7,'Member','C');
               docell(temppaint,fontscle,scle,1,line,0.95,'TC Tension','C');
               docell(temppaint,fontscle,scle,1.95,line,0.95,'TC Compresion','C');
               docell(temppaint,fontscle,scle,2.9,line,0.95,'BC Tension','C');
               docell(temppaint,fontscle,scle,3.85,line,0.95,'BC Compresion','C');
               docell(temppaint,fontscle,scle,4.8,line,0.95,'Web Tension','C');
               docell(temppaint,fontscle,scle,5.75,line,0.95,'Web Comp.','C');
               docell(temppaint,fontscle,scle,6.7,line,0.75,'Web Length','C');
               line:=docell(temppaint,fontscle,scle,7.45,line,0.75,'PP Dist.','C');
               bct:=0; bcc:=0; tct:=0; tcc:=0; maxv2l:=0; maxcv1:=0; maxv1l:=0; v1v:=false;
               maxtv1:=0;
               if joistsconsolidate.Value then
                  m:=middle
               else
                   m:=memberlist.count;
               for x:=1 to m do
               begin
                    membdata:=MemberList.items[x-1];
                    temp:=membdata^.position;
                    if (temp='TC') or (temp='EP') or (temp='NP') or (temp='BC') then
                    begin
                       if temp='BC' then
                       begin
                            bct:=membdata^.maxt;
                            bcc:=membdata^.maxc;
                       end
                       else
                       begin
                            tct:=membdata^.maxt;
                            tcc:=membdata^.maxc;
                       end;
                    end
                    else
                    begin
                         if membdata^.position='V2' then
                         begin
                              if maxv2l<membdata^.length then
                                 maxv2l:=membdata^.length;
                         end
                         else
                         begin
                              if membdata^.position='V1S' then
                              begin
                                   bct:=0;
                                   bcc:=0;
                                   if maxcv1<membdata^.maxc then
                                      maxcv1:=membdata^.maxc;
                                   if maxtv1<membdata^.maxt then
                                      maxtv1:=membdata^.maxt;
                                   if maxv1l<membdata^.length then
                                      maxv1l:=membdata^.length;
                              end;
                              if (membdata^.position='W2') and ((bct>0) or (bcc>0)) then
                              begin
                                   bct:=0;
                                   bcc:=0;
                              end;
                              if (membdata^.position='V1S') and (round(membdata^.angle/pi*180)=90) then
                                 v1v:=true
                              else
                              begin
                                   docell(temppaint,fontscle,scle,0.3,line,0.7,membdata^.position,'C');
                                   docell(temppaint,fontscle,scle,1,line,0.95,format('%11.2n',[tct]),'R');
                                   docell(temppaint,fontscle,scle,1.95,line,0.95,format('%11.2n',[tcc]),'R');
                                   docell(temppaint,fontscle,scle,2.9,line,0.95,format('%11.2n',[bct]),'R');
                                   docell(temppaint,fontscle,scle,3.85,line,0.95,format('%11.2n',[bcc]),'R');
                                   docell(temppaint,fontscle,scle,4.8,line,0.95,format('%11.2n',[membdata^.maxt]),'R');
                                   docell(temppaint,fontscle,scle,5.75,line,0.95,format('%11.2n',[membdata^.maxc]),'R');
                                   docell(temppaint,fontscle,scle,6.7,line,0.75,format('%6.2f',[membdata^.length]),'R');
                                   jointdata:=JointList.items[membdata^.Joint1-1];
                                   line:=docell(temppaint,fontscle,scle,7.45,line,0.75,dectoing(jointdata^.coordX),'L');
                              end;
                         end;
                    end;
               end;
               font.name:='Arial';
               font.size:=10;
               font.height:=round(-font.height*fontscle);
               if m<memberlist.count then
               begin
                    textout(trunc(scle*0.3),trunc(scle*line),'* Symmetrical Joist');
                    line:=line+font.height/scle;
               end;
               font.style:=[fsbold];
               line:=line+font.height/scle;
               if not rndweb then
               begin
                    textout(trunc(scle*0.3),trunc(scle*line),'Standard Verticals');
                    line:=line+font.height/scle;
                    docell(temppaint,fontscle,scle,0.3,line,0.7,'Member','C');
                    docell(temppaint,fontscle,scle,1,line,0.95,'Position','C');
                    docell(temppaint,fontscle,scle,1.95,line,0.95,'Max Tension','C');
                    docell(temppaint,fontscle,scle,2.90,line,0.95,'Max Comp.','C');
                    line:=docell(temppaint,fontscle,scle,3.85,line,0.75,'Length','C');
                    if v1v then
                    begin
                         docell(temppaint,fontscle,scle,0.3,line,0.7,'V1','C');
                         docell(temppaint,fontscle,scle,1,line,0.95,'End Panel','C');
                         docell(temppaint,fontscle,scle,1.95,line,0.95,format('%0.2n',[maxtv1]),'R');
                         docell(temppaint,fontscle,scle,2.90,line,0.95,format('%0.2n',[maxcv1]),'R');
                         line:=docell(temppaint,fontscle,scle,3.85,line,0.75,format('%0.2f',[maxv1l]),'R');
                    end;
                    docell(temppaint,fontscle,scle,0.3,line,0.7,'V2','C');
                    docell(temppaint,fontscle,scle,1,line,0.95,'Interior','C');
                    docell(temppaint,fontscle,scle,1.95,line,0.95,format('%0.2n',[maxtv2]),'R');
                    docell(temppaint,fontscle,scle,2.90,line,0.95,format('%0.2n',[maxcv2]),'R');
                    line:=docell(temppaint,fontscle,scle,3.85,line,0.75,format('%0.2f',[maxv2l]),'R');
               end;
          end
          else
          begin
               title;
               line:=line+font.height/scle;
               font.name:='Arial';
               font.size:=10;
               font.height:=round(-font.height*fontscle);
               font.style:=[fsbold];
               textout(trunc(scle*0.3),trunc(scle*1.25),'Chord Properties');
               line:=1.25+font.height/scle;
               {textout(trunc(scle*0.3),trunc(scle*line),'Chord Properties');
               line:=line+font.height/scle;}
               docell(temppaint,fontscle,scle,0.3,line,0.7,'Chord','C');
               docell(temppaint,fontscle,scle,1,line,0.75,'Area','C');
               docell(temppaint,fontscle,scle,1.75,line,0.75,'Rx','C');
               docell(temppaint,fontscle,scle,2.5,line,0.75,'Rz','C');
               docell(temppaint,fontscle,scle,3.25,line,0.75,'Ryy','C');
               docell(temppaint,fontscle,scle,4,line,0.75,'Y','C');
               docell(temppaint,fontscle,scle,4.75,line,0.75,'Ix','C');
               docell(temppaint,fontscle,scle,5.5,line,0.75,'Q','C');
               line:=docell(temppaint,fontscle,scle,6.25,line,1.95,'Material','C');
               for x:=1 to 2 do
               begin
                    case x of
                         1:begin
                                findangle(TCSection.section);
                                docell(temppaint,fontscle,scle,0.3,line,0.7,'TC','C');
                                docell(temppaint,fontscle,scle,3.25,line,0.75,format('%0.4f',[TCSection.Ryy]),'C');
                           end;
                         2:begin
                                findangle(BCSection.section);
                                docell(temppaint,fontscle,scle,0.3,line,0.7,'BC','C');
                                docell(temppaint,fontscle,scle,3.25,line,0.75,format('%0.4f',[BCSection.Ryy]),'C');
                           end;
                    end;
                    docell(temppaint,fontscle,scle,1,line,0.75,format('%0.4f',[angprop^.area]),'C');
                    docell(temppaint,fontscle,scle,1.75,line,0.75,format('%0.4f',[angprop^.Rx]),'C');
                    docell(temppaint,fontscle,scle,2.5,line,0.75,format('%0.4f',[angprop^.Rz]),'C');
                    docell(temppaint,fontscle,scle,4,line,0.75,format('%0.4f',[angprop^.Y]),'C');
                    docell(temppaint,fontscle,scle,4.75,line,0.75,format('%0.4f',[angprop^.Ix]),'C');
                    docell(temppaint,fontscle,scle,5.5,line,0.75,format('%0.4f',[angprop^.Q]),'C');
                    line:=docell(temppaint,fontscle,scle,6.25,line,1.95,angprop^.section+' = '+angprop^.description,'L');
               end;
               line:=line+font.height/scle;
               font.name:='Arial';
               font.size:=10;
               font.height:=round(-font.height*fontscle);
               font.style:=[fsbold];
               if LRFD then
                  textout(trunc(scle*0.3),trunc(scle*line),'Axial and Bending Analysis (LRFD)')
               else
                  textout(trunc(scle*0.3),trunc(scle*line),'Axial and Bending Analysis (ASD)');
               line:=line+font.height/scle;
               dobox(temppaint,fontscle,scle,0.3,line,0.95,'K:',format('%0.2n',[k]));
               dobox(temppaint,fontscle,scle,1.25,line,0.95,'Fy:',format('%0.2n',[fy*1000]));
               dobox(temppaint,fontscle,scle,2.2,line,0.95,'Fb:',format('%0.2n',[fb]));
               dobox(temppaint,fontscle,scle,3.15,line,1.05,'Mom of Inertia:',format('%0.2n',[momi]));
               if joistslldeflection.value>1 then
                  dobox(temppaint,fontscle,scle,4.2,line,1,'LL '+
                       inttostr(joistslldeflection.value)+':',format('%0.2n',[ll360]))
               else
                   dobox(temppaint,fontscle,scle,4.2,line,1,'LL 360:',format('%0.2n',[ll360]));
               if joiststldeflection.value>1 then
                  dobox(temppaint,fontscle,scle,5.2,line,1,'TL '+
                       inttostr(joiststldeflection.value)+':',format('%0.2n',[ll240]))
               else
                   dobox(temppaint,fontscle,scle,5.2,line,1,'LL 240:',format('%0.2n',[ll240]));
               dobox(temppaint,fontscle,scle,6.2,line,1,'Max Bridg TC:',dectoing(latsup));
               line:=dobox(temppaint,fontscle,scle,7.2,line,1,'Max Bridg BC:',dectoing(latsup2))+0.05;
               line2:=line;
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Top Chord Check','C');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,'Interior Panel','C');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Length','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2f',[TCSection.maxintp]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Bending Load','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2f',[TCSection.bending]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Axial Load','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2n',[abs(TCSection.maxforce)]),'R');
               if LRFD then
                docell(temppaint,fontscle,scle,0.3,line,1.7,'fau','L')
               else
                docell(temppaint,fontscle,scle,0.3,line,1.7,'fa','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2n',[abs(TCSection.fa2)]),'R');
               if LRFD then
                docell(temppaint,fontscle,scle,0.3,line,1.7,'Maximum L/r','L')
               else
                docell(temppaint,fontscle,scle,0.3,line,1.7,'Maximum K L/r','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2f',[abs(TCSection.lrmax)]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Fcr','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2n',[abs(TCSection.fcr)]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Fa','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2n',[abs(TCSection.fa)]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Fe','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2n',[abs(TCSection.fe)]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Cm','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.4f',[abs(TCSection.cm)]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Panel Point Moment','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2f',[abs(TCSection.ppmom)]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Mid Panel Moment','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2f',[abs(TCSection.mpmom)]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Panel Point fb','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2f',[abs(TCSection.ppfb)]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Mid Panel fb','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%6.2f',[abs(TCSection.mpfb)]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Fillers','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,inttostr(TCSection.fillers),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Panel Point Stress','L');
               line:=docell(temppaint,fontscle,scle,3.9,line,0.95,format('%12.2n',[abs(TCSection.Fa2+TCSection.ppfb)]),'R');
               docell(temppaint,fontscle,scle,0.3,line,1.7,'Mid Panel Stress','L');
               docell(temppaint,fontscle,scle,3.9,line,0.95,
                     format('%12.4n',[abs(TCSection.Fa2/TCSection.Fa)+TCSection.bratio]),'R');
               line:=line2; docolumn(endpl,'End Panel LE',2);
               line:=line2; docolumn(firstpl,'First Panel LE',2.95);
               line:=line2; docolumn(firstpr,'First Panel RE',4.85);
               line:=line2; docolumn(endpr,'End Panel RE',5.8);
               line2:=dobox(temppaint,fontscle,scle,6.8,line2,1.4,'Gap Between Chords:',format('%0.2n',[gap]));
               line2:=dobox(temppaint,fontscle,scle,6.8,line2,1.4,'Min Weld Len 2X:',format('%0.4f',[TCSection.weld]))+0.05;
               line2:=dobox(temppaint,fontscle,scle,6.8,line2,1.4,'Max Load Fillers TC:',format('%0.2n',[TCSection.mlf]));
               line2:=dobox(temppaint,fontscle,scle,6.8,line2,1.4,'Max Load no Fillers TC:',format('%0.2n',[TCSection.mlnf]));
               line2:=dobox(temppaint,fontscle,scle,6.8,line2,1.4,'TC OAL/Ryy:',format('%0.4n',[wl/TCSection.Ryy]))+0.05;
               line2:=dobox(temppaint,fontscle,scle,6.8,line2,1.4,'BC Stress:',format('%0.2n',[BCSection.tenst]));
               line2:=dobox(temppaint,fontscle,scle,6.8,line2,1.4,'BC L/Rz:',
                      format('%0.4n',[BCSection.maxintp/angprop^.Rz]))+0.05;
               line2:=dobox(temppaint,fontscle,scle,6.8,line2,1.4,'TC Shear Stress:',format('%0.2n',[TCSection.shrcap]));
               line2:=dobox(temppaint,fontscle,scle,6.8,line2,1.4,'BC Shear Stress:',format('%0.2n',[BCSection.shrcap]));
               if jtype in jtype1 then
               begin
                        findangle(TCSection.Section);
                        dobox(temppaint,fontscle,scle,6.8,line2,1.4,'TC Bearing Capacity:',format('%0.2n',[maxPointLoad/2000])+'K < '+format('%0.2n',[GirderBearingCapacity/1000])+'K');
               end;
               line:=line+font.height/scle;
               font.name:='Arial';
               font.size:=10;
               font.height:=round(-font.height*fontscle);
               font.style:=[fsbold];
               textout(trunc(scle*0.3),trunc(scle*line),'Web Design');
               line:=line+font.height/scle;
               docell(temppaint,fontscle,scle,0.3,line,0.7,'Member','C');
               docell(temppaint,fontscle,scle,1,line,0.95,'Web Tension','C');
               docell(temppaint,fontscle,scle,1.95,line,0.95,'Allow Tension','C');
               docell(temppaint,fontscle,scle,2.9,line,0.95,'Web Comp','C');
               docell(temppaint,fontscle,scle,3.85,line,0.95,'Allow Comp','C');
               docell(temppaint,fontscle,scle,4.8,line,0.95,'Weld','C');
               docell(temppaint,fontscle,scle,5.75,line,0.5,'Qty','C');
               line:=docell(temppaint,fontscle,scle,6.25,line,1.95,'Material','C');
               if joistsconsolidate.Value then
                  m:=middle
               else
                   m:=memberlist.count;
               v1:=false; v2:=false;
               allowtv1:=0;
               allowtv2:=0;
               maxcv1:=0;
               maxtv1:=0;
               for x:=1 to m do
               begin
                    membdata:=MemberList.items[x-1];
                    if (copy(membdata^.position,1,1)='W') or (rndweb and (membdata^.position='V1S')) then
                    begin
                         if membdata^.overst>0 then
                            docell(temppaint,fontscle,scle,0.3,line,0.7,'* '+membdata^.position+' *','C')
                         else
                             docell(temppaint,fontscle,scle,0.3,line,0.7,membdata^.position,'C');
                         docell(temppaint,fontscle,scle,1,line,0.95,format('%0.2n',[membdata^.maxt]),'R');
                         docell(temppaint,fontscle,scle,1.95,line,0.95,format('%0.2n',[membdata^.allowt]),'R');
                         docell(temppaint,fontscle,scle,2.9,line,0.95,format('%0.2n',[abs(membdata^.maxc)]),'R');
                         docell(temppaint,fontscle,scle,3.85,line,0.95,format('%0.2n',[membdata^.allowc]),'R');
                         temp:=format('%0.1f',[membdata^.weld])+' x '+format('%0.3f',[membdata^.thick]);
                         docell(temppaint,fontscle,scle,4.8,line,0.95,temp,'C');
                         if membdata^.material='D' then
                            docell(temppaint,fontscle,scle,5.75,line,0.5,'2','C')
                         else
                             docell(temppaint,fontscle,scle,5.75,line,0.5,'1','C');
                         if membdata^.material='R' then
                         begin
                              findrnd(membdata^.section);
                              line:=docell(temppaint,fontscle,scle,6.25,line,
                                    1.95,rndprop^.section+' = '+rndprop^.description,'L');
                         end
                         else
                         begin
                              findangle(membdata^.section);
                              line:=docell(temppaint,fontscle,scle,6.25,line,
                                    1.95,angprop^.section+' = '+angprop^.description,'L');
                         end;
                         {if ((jtype='K') or (jtype='C')) and (membdata^.position='W2') and (membdata^.material<>'D') then
                         begin
                              textout(trunc(scle*0.3),trunc(scle*line),'* Allowable Tensile Stress Reduced 10%');
                              line:=line+font.height/scle;
                         end;}
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
                    docell(temppaint,fontscle,scle,0.3,line,0.7,copy(membdata^.position,1,2),'C');
                    docell(temppaint,fontscle,scle,1.95,line,0.95,format('%0.2n',[membdata^.allowt]),'R');
                    docell(temppaint,fontscle,scle,3.85,line,0.95,format('%0.2n',[membdata^.allowc]),'R');
                    temp:=format('%0.1f',[membdata^.weld])+' x '+format('%0.3f',[membdata^.thick]);
                    docell(temppaint,fontscle,scle,4.8,line,0.95,temp,'C');
                    if membdata^.position='V1S' then
                    begin
                         docell(temppaint,fontscle,scle,1,line,0.95,format('%0.2n',[maxtv1]),'R');
                         docell(temppaint,fontscle,scle,2.9,line,0.95,format('%0.2n',[maxcv1]),'R');
                    end
                    else
                    begin
                         docell(temppaint,fontscle,scle,1,line,0.95,format('%0.2n',[maxtv2]),'R');
                         docell(temppaint,fontscle,scle,2.9,line,0.95,format('%0.2n',[maxcv2]),'R');
                    end;
                    if membdata^.material='D' then
                       docell(temppaint,fontscle,scle,5.75,line,0.5,'2','C')
                    else
                        docell(temppaint,fontscle,scle,5.75,line,0.5,'1','C');
                    if membdata^.material='R' then
                    begin
                         findrnd(membdata^.section);
                         line:=docell(temppaint,fontscle,scle,6.25,line,1.95,rndprop^.section+' = '+rndprop^.description,'L');
                    end
                    else
                    begin
                         findangle(membdata^.section);
                         line:=docell(temppaint,fontscle,scle,6.25,line,1.95,angprop^.section+' = '+angprop^.description,'L');
                    end;
               end;
               if m<memberlist.count then
               begin
                    textout(trunc(scle*0.3),trunc(scle*line),'* Symmetrical Joist');
                    line:=line+font.height/scle;
               end;
               {if dept=1 then
               begin
                    textout(trunc(scle*0.3),trunc(scle*line),'Joist Weight: '+format('%0.2f',[joistsweight.value]));
                    line:=line+font.height/scle;
               end;}
               {textout(trunc(scle*0.3),trunc(scle*line),'* Eccentricity Check - OK');}
          end;
     end;
end;

end.
