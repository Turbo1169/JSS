unit Main2;

interface

uses windows, db, sysutils, controls, forms, extctrls, graphics, comctrls,
printers, dialogs,variants;

procedure totaljob;
procedure totalseq;
procedure Pagetotal;
procedure JobInfoCalc;
procedure JobMiscCalc;
procedure optionfill(book:tnotebook);
procedure iconcreate;
procedure iconfree;
procedure printprog;

implementation

uses main, output, output2;

type
  PageTot=Record
    Inches,Material,LineHrs,Tons:single;
    Splices:integer;
    Pieces:Longint;
  end;

var
   pagesum:array[0..7] of pagetot;
   bitmaps:array[0..3] of Tbitmap;
   prntscle:single;

function ingtodec(ing:shortstring):single; external 'comlib.dll';

procedure Pagetotal;
var
   crecord:TBookmark;
   linehrs:single;
   x:integer;
begin
     with mainform do
     begin
          for x:=0 to 7 do
          begin
               pagesum[x].lineHrs:=0;
               pagesum[x].tons:=0;
               pagesum[x].pieces:=0;
               pagesum[x].material:=0;
               pagesum[x].inches:=0;
               pagesum[x].splices:=0;
          end;
          with joists do
          begin
               disablecontrols;
               crecord:=GetBookmark;
               first;
               while not eof do
               begin
                    lineHrs:=joiststime.value;
                    x:=0;
                    if joistsjoisttype.value='L1' then
                       lineHrs:=lineHrs/SSMan;
                    if joistsjoisttype.value='L2' then
                    begin
                       x:=1;
                       lineHrs:=lineHrs/SSMan;
                    end;
                    if joistsjoisttype.value='LS' then
                    begin
                       x:=2;
                       lineHrs:=lineHrs/LSMan;
                    end;
                    if joistsjoisttype.value='JG' then
                    begin
                       x:=3;
                       lineHrs:=lineHrs/LSMan;
                    end;
                    pagesum[x].tons:=pagesum[x].tons+(joistsweight.value*joistsquantity.value)/2000;
                    pagesum[x].lineHrs:=pagesum[x].lineHrs+(lineHrs*joistsquantity.value);
                    pagesum[x].pieces:=pagesum[x].pieces+joistsquantity.value;
                    pagesum[x].material:=pagesum[x].material+(joistsmaterial.value*joistsquantity.value);
                    pagesum[x].inches:=pagesum[x].inches+(ingtodec(joistsbaselength.value)*joistsquantity.value);
                    if (ingtodec(joistsbaselength.value)/12)>=80 then
                       pagesum[x].splices:=pagesum[x].splices+joistsquantity.value;
                    next;
               end;
               gotobookmark(crecord);
               freebookmark(crecord);
               enablecontrols;
          end;
          if dept=0 then
          begin
               with bridg do
               begin
                    disablecontrols;
                    crecord:=GetBookmark;
                    first;
                    while not eof do
                    begin
                         if bridgtype.value='HB' then
                            x:=4
                         else
                             x:=5;
                         pagesum[x].tons:=pagesum[x].tons+bridgweight.value/2000;
                         pagesum[x].pieces:=pagesum[x].pieces+bridgplanfeet.value;
                         pagesum[x].material:=pagesum[x].material+bridgmaterial.value;
                         next;
                    end;
                    gotobookmark(crecord);
                    freebookmark(crecord);
                    enablecontrols;
               end;
          end;
          with jsubst do
          begin
               disablecontrols;
               crecord:=GetBookmark;
               first;
               x:=7;
               while not eof do
               begin
                    pagesum[x].tons:=pagesum[x].tons+jsubstweight.value/2000*jsubstQuantity.value;
                    pagesum[x].pieces:=pagesum[x].pieces+jsubstQuantity.value;
                    pagesum[x].material:=pagesum[x].material+jsubstmaterial.value*jsubstQuantity.value;
                    next;
               end;
               gotobookmark(crecord);
               freebookmark(crecord);
               enablecontrols;
          end;
     end;
end;

procedure totaljob;
var
   trucks,splices,x:integer;
   inches,tot:single;
begin
     if mainform.jobinfo.recordcount>0 then
     with mainform do
     if jobinfostatus.value='M' then
     try
     JobInfo.DisableControls;
     if mainform.JobInfoDateQuoted.Value<>date then
        mainform.UpdateFile1Click(nil);
     screen.cursor:=crhourglass;
     pagetotal;
     jobinfo.edit;
     tot:=0; splices:=0; inches:=0;
     for x:=0 to 7 do
     begin
          case x of
          0:begin
            jobinfoL1pieces.value:=pagesum[x].pieces;
            jobinfoL1tons.value:=pagesum[x].tons;
            jobinfoL1linehrs.value:=pagesum[x].linehrs;
            jobinfoL1material.value:=pagesum[x].material;
          end;
          1:begin
            jobinfoL2pieces.value:=pagesum[x].pieces;
            jobinfoL2tons.value:=pagesum[x].tons;
            jobinfoL2linehrs.value:=pagesum[x].linehrs;
            jobinfoL2material.value:=pagesum[x].material;
          end;
          2:begin
            jobinfoLSpieces.value:=pagesum[x].pieces;
            jobinfoLStons.value:=pagesum[x].tons;
            jobinfoLSlinehrs.value:=pagesum[x].linehrs;
            jobinfoLSmaterial.value:=pagesum[x].material;
          end;
          3:begin
            jobinfoJGpieces.value:=pagesum[x].pieces;
            jobinfoJGtons.value:=pagesum[x].tons;
            jobinfoJGlinehrs.value:=pagesum[x].linehrs;
            jobinfoJGmaterial.value:=pagesum[x].material;
          end;
          4:begin
            jobinfoHBpieces.value:=pagesum[x].pieces;
            jobinfoHBtons.value:=pagesum[x].tons;
            jobinfoHBmaterial.value:=pagesum[x].material;
          end;
          5:begin
            jobinfoXBpieces.value:=pagesum[x].pieces;
            jobinfoXBtons.value:=pagesum[x].tons;
            jobinfoXBmaterial.value:=pagesum[x].material;
          end;
          6:begin
            jobinfoKBpieces.value:=jobinfoJGpieces.value*2;
            findangle('20');
            jobinfoKBtons.value:=jobinfoKBpieces.value*5*angprop^.weight/2000;
            jobinfoKBmaterial.value:=jobinfoKBtons.value*angprop^.cost;
          end;
          7:begin
            jobinfoJSpieces.value:=pagesum[x].pieces;
            jobinfoJStons.value:=pagesum[x].tons;
            jobinfoJSmaterial.value:=pagesum[x].material;
          end;
          end;
          if x=6 then
             tot:=tot+jobinfoKBtons.value
          else
          begin
              tot:=tot+pagesum[x].tons;
              splices:=splices+pagesum[x].splices;
          end;
          if x<3 then
             inches:=inches+pagesum[x].inches;
     end;
     jobmisc.disablecontrols;
     {JobMisc.Close;
     JobMisc.DataSet.CommandText:='select * from jobmisc where `job number`=:''job number'' and page=:page';
     JobMisc.open;}
     JobMisc.Filtered:=false;
     if JobMisc.Locate('Category', 'Paint',[]) then
     begin
          jobmisc.edit;
          jobmiscquantity.value:=trunc(tot)+1;
     end;
     if (JobMisc.Locate('Category;item', vararrayof(['Fees',4]),[])) or (JobMisc.Locate('Category;item', vararrayof(['Fees',5]),[])) then
     begin
          jobmisc.edit;
          jobmiscquantity.value:=trunc(tot)+1;
     end;
     for x:=1 to 3 do
     begin
          if JobMisc.Locate('Category;item', vararrayof(['Fees',x]),[]) then
          begin
               trucks:=trunc(tot/jobmiscvalue.value);
               if trunc(tot/jobmiscvalue.value)<tot/jobmiscvalue.value then
                  inc(trucks);
               jobmisc.edit;
               jobmiscquantity.value:=trucks;
          end;
     end;
     if JobMisc.Locate('Category;item', vararrayof(['Freight',1]),[]) then
     begin
          trucks:=trunc(tot/jobmiscvalue.value);
          if trunc(tot/jobmiscvalue.value)<tot/jobmiscvalue.value then
          inc(trucks);
          JobMisc.Locate('Category;item', vararrayof(['Freight',2]),[]);
          jobmisc.edit;
          jobmiscquantity.value:=jobmiles.value*trunc(jobmiscvalue.value);
          trucks:=trucks-trunc(jobmiscvalue.value);
          JobMisc.Locate('Category;item', vararrayof(['Freight',3]),[]);
          jobmisc.edit;
          jobmiscquantity.value:=jobmiles.value*trunc(jobmiscvalue.value);
          trucks:=trucks-trunc(jobmiscvalue.value);
          JobMisc.Locate('Category;item', vararrayof(['Freight',1]),[]);
          jobmisc.edit;
          jobmiscquantity.value:=jobmiles.value*trucks;
     end;
     if JobMisc.Locate('Category;item', vararrayof(['Misc',4]),[]) then
     begin
          jobmisc.edit;
          jobmiscquantity.value:=splices;
     end;
     if JobMisc.Locate('Category;item', vararrayof(['Misc',1]),[]) then
     begin
        jobmisc.edit;
        jobmiscquantity.value:=round(inches/jobmiscvalue.value);
     end;
     if JobMisc.Locate('Category;item', vararrayof(['Misc',7]),[]) then
     begin
        jobmisc.edit;
        jobmiscquantity.value:=round(inches/12);
     end;
     if JobMisc.Locate('Category;item', vararrayof(['Misc',3]),[]) then
     begin
        jobmisc.edit;
        jobmiscquantity.value:=round(pagesum[3].inches/jobmiscvalue.value);
     end;
     if jobmisc.state<>dsbrowse then
        jobmisc.post;
     //JobMisc.ApplyUpdates(0);
     for x:=0 to 3 do
     begin
          doextras(x);
          jobmisc.first; tot:=0;
          while not jobmisc.eof do
          begin
               tot:=tot+jobmisctotalprice.value;
               jobmisc.next;
          end;
          jobinfo.fieldbyname('Total '+extrastabs.tabs.strings[x]).asfloat:=tot;
     end;
     doextras(extrastabs.TabIndex);
     jobmisc.enablecontrols;
     jobinfostatus.value:='Q';
     if jobinfocommission.value>0 then
     begin
          tot:=15*jobinfotonssold.value;
          if jobinfotonssold.value>15 then
             tot:=14*(jobinfotonssold.value-15)+225;
          if jobinfotonssold.value>30 then
             tot:=12*(jobinfotonssold.value-30)+435;
          if jobinfotonssold.value>60 then
             tot:=11*(jobinfotonssold.value-60)+795;
          if jobinfotonssold.value>100 then
             tot:=10*(jobinfotonssold.value-100)+1235;
          if jobinfotonssold.value>150 then
             tot:=8*(jobinfotonssold.value-150)+1735;
          if tot<100 then
             tot:=100;
          jobinfocommission.value:=tot;
     end;
     jobinfo.post;
     finally
     screen.cursor:=crdefault;
     JobInfo.EnableControls;
     end;
end;

procedure totalseq;
var
   x:integer;
   tot:single;
begin
     if mainform.sequence.recordcount>0 then
     with mainform do
     if sequencestatus.value='M' then
     try
     screen.cursor:=crhourglass;
     with joists do
     begin
          pagetotal;
          sequence.edit;
          tot:=0;
          for x:=0 to 3 do
          begin
               case x of
               0:begin
                 sequenceL1pieces.value:=pagesum[x].pieces;
                 sequenceL1tons.value:=pagesum[x].tons;
                 sequenceL1linehrs.value:=pagesum[x].linehrs;
               end;
               1:begin
                 sequenceL2pieces.value:=pagesum[x].pieces;
                 sequenceL2tons.value:=pagesum[x].tons;
                 sequenceL2linehrs.value:=pagesum[x].linehrs;
               end;
               2:begin
                 sequenceLSpieces.value:=pagesum[x].pieces;
                 sequenceLStons.value:=pagesum[x].tons;
                 sequenceLSlinehrs.value:=pagesum[x].linehrs;
               end;
               3:begin
                 sequenceJGpieces.value:=pagesum[x].pieces;
                 sequenceJGtons.value:=pagesum[x].tons;
                 sequenceJGlinehrs.value:=pagesum[x].linehrs;
               end;
               end;
               tot:=tot+pagesum[x].tons;
          end;
          sequencestatus.value:='Q';
          sequence.post;
     end;
     finally
     screen.cursor:=crdefault;
     end;
end;

procedure JobInfoCalc;
begin
with mainform do
begin
     if jobinfoL1linehrs.value>0 then
        jobinfoL1TonLH.value:=jobinfoL1Tons.value/jobinfoL1linehrs.value;
     if jobinfoL2linehrs.value>0 then
        jobinfoL2TonLH.value:=jobinfoL2Tons.value/jobinfoL2linehrs.value;
     if jobinfoLSlinehrs.value>0 then
        jobinfoLSTonLH.value:=jobinfoLSTons.value/jobinfoLSlinehrs.value;
     if jobinfoJGlinehrs.value>0 then
        jobinfoJGTonLH.value:=jobinfoJGTons.value/jobinfoJGlinehrs.value;
     jobinfoL1labor.value:=jobinfoL1linehrs.value*jobinfosslinehour.value;
     jobinfoL2labor.value:=jobinfoL2linehrs.value*jobinfosslinehour.value;
     jobinfoLSlabor.value:=jobinfoLSlinehrs.value*jobinfolslinehour.value;
     jobinfoJGlabor.value:=jobinfoJGlinehrs.value*jobinfolslinehour.value;
     jobinfoHBlabor.value:=jobinfoHBTons.value*jobinfoHBLaborCost.value;
     jobinfoXBlabor.value:=jobinfoXBTons.value*jobinfoXBLaborCost.value;
     jobinfoKBlabor.value:=jobinfoKBTons.value*jobinfoKBLaborCost.value;
     jobinfoJSlabor.value:=jobinfoJSTons.value*jobinfoJSLaborCost.value;
     jobinfoL1Cost.value:=jobinfoL1Material.value+jobinfoL1Labor.value;
     jobinfoL2Cost.value:=jobinfoL2Material.value+jobinfoL2Labor.value;
     jobinfoLSCost.value:=jobinfoLSMaterial.value+jobinfoLSLabor.value;
     jobinfoJGCost.value:=jobinfoJGMaterial.value+jobinfoJGLabor.value;
     jobinfoHBCost.value:=jobinfoHBMaterial.value+jobinfoHBLabor.value;
     jobinfoXBCost.value:=jobinfoXBMaterial.value+jobinfoXBLabor.value;
     jobinfoKBCost.value:=jobinfoKBMaterial.value+jobinfoKBLabor.value;
     jobinfoJSCost.value:=jobinfoJSMaterial.value+jobinfoJSLabor.value;
     jobinfoL1TotalProfit.value:=jobinfoL1LineHrs.value*jobinfoProfitLH.value;
     jobinfoL2TotalProfit.value:=jobinfoL2LineHrs.value*jobinfoProfitLH.value;
     jobinfoLSTotalProfit.value:=jobinfoLSLineHrs.value*jobinfoProfitLH.value;
     jobinfoJGTotalProfit.value:=jobinfoJGLineHrs.value*jobinfoProfitLH.value;
     jobinfoL1PriceProfit.value:=jobinfoL1Cost.value+jobinfoL1TotalProfit.value;
     jobinfoL2PriceProfit.value:=jobinfoL2Cost.value+jobinfoL2TotalProfit.value;
     jobinfoLSPriceProfit.value:=jobinfoLSCost.value+jobinfoLSTotalProfit.value;
     jobinfoJGPriceProfit.value:=jobinfoJGCost.value+jobinfoJGTotalProfit.value;
     jobinfototalpieces.value:=jobinfoL1Pieces.value+jobinfoL2Pieces.value+jobinfoLSPieces.value
     +jobinfoJGPieces.value+jobinfoJSPieces.value;
     jobinfototalTons.value:=jobinfoL1Tons.value+jobinfoL2Tons.value+jobinfoLSTons.value
     +jobinfoJGTons.value+jobinfoHBTons.value+jobinfoXBTons.value+jobinfoKBTons.value+jobinfoJSTons.value;
     jobinfototalMaterial.value:=jobinfoL1Material.value+jobinfoL2Material.value+jobinfoLSMaterial.value
     +jobinfoJGMaterial.value+jobinfoHBMaterial.value+jobinfoXBMaterial.value+jobinfoKBMaterial.value+jobinfoJSmaterial.value;
     jobinfototalLH.value:=jobinfoL1LineHrs.value+jobinfoL2LineHrs.value+jobinfoLSLineHrs.value
     +jobinfoJGLineHrs.value;
     jobinfototalLabor.value:=jobinfoL1Labor.value+jobinfoL2Labor.value+jobinfoLSLabor.value
     +jobinfoJGLabor.value+jobinfoHBLabor.value+jobinfoXBLabor.value+jobinfoKBLabor.value+jobinfoJSlabor.value;
     jobinfototalcost.value:=jobinfototalMaterial.value+jobinfototalLabor.value;
     if jobinfototalLH.value>0 then
       jobinfotonsLH.value:=jobinfototalTons.value/jobinfototalLH.value;
     jobinfototalprofit.value:=jobinfototalLH.value*jobinfoProfitLH.value;
     jobinfototalprice.value:=jobinfototalprofit.value+jobinfototalcost.value;
     jobinfosubtotal1.value:=jobinfototalpaint.value+jobinfototalmisc.value+jobinfototalprice.value+jobinfoextras.value;
     jobinfosubtotal2.value:=jobinfosubtotal1.value+jobinfocommission.value+jobinfototalfees.value;
     jobinfosellingprice.value:=jobinfosubtotal2.value+jobinfototalfreight.value;
     jobinfotonssold.value:=jobinfototaltons.value*(1+jobinfooverweight.value/100);
     jobinfototdet.value:=jobinfodetail.value+jobinfoapproval.value+jobinfofabrication.value;
     jobinfoprojlist.value:=jobinfodatequoted.value+jobinfolist.value*7;
     jobinfoprojDet.value:=jobinfodatequoted.value+jobinfototdet.value*7;
end;
end;

procedure JobMiscCalc;
begin
with mainform do
begin
     pricetbl.Locate('category;item',vararrayof([jobmisccategory.value,jobmiscitem.value]),[]);
     if (jobmisccategory.value='Freight') and (jobmiscquantity.value>0) and (jobmiles.value>0) then
        jobmiscdescription.value:=pricetbldescription.value+
        ' ('+inttostr(trunc(jobmiscquantity.value/jobmiles.value))+')'
     else
         jobmiscdescription.value:=pricetbldescription.value;
     {if (jobmisccategory.value='Misc') and (jobmiscitem.value=7) then
        jobmisctotalprice.value:=jobmiscquantity.value*jobmiscunitprice.value+
        jobinfototalfreight.value*(jobmiscvalue.value/100)
     else}
     jobmisctotalprice.value:=jobmiscquantity.value*jobmiscunitprice.value;
     jobmiscunit.value:=pricetblunit.value;
end;
end;

{procedure totaljob2;
type
    line=record
      pcs:integer;
      tons,lh:single;
    end;
var
   brgtons,freight,comm,sub2,tons:single;
   lsum:array[0..3] of line;
   x:integer;
   row:string[2];
begin
     with mainform do
     begin
          with jobinfo do
          begin
               disablecontrols;
               first;
               freight:=0;
               brgtons:=0;
               comm:=0;
               sub2:=0;
               tons:=0;
               for x:=0 to 3 do
               begin
                    lsum[x].pcs:=0;
                    lsum[x].tons:=0;
                    lsum[x].lh:=0;
               end;
               while not eof do
               begin
                    if jobinfostatus.value='S' then
                    begin
                         freight:=freight+jobinfototalfreight.value;
                         comm:=comm+jobinfocommission.value;
                         sub2:=sub2+jobinfosubtotal2.value;
                         tons:=tons+jobinfotonssold.value;
                         for x:=0 to 3 do
                         begin
                              case x of
                                0:row:='L1';
                                1:row:='L2';
                                2:row:='LS';
                                3:row:='JG';
                              end;
                              lsum[x].pcs:=lsum[x].pcs+fieldbyname(row+' Pieces').asinteger;
                              lsum[x].tons:=lsum[x].tons+fieldbyname(row+' Tons').asfloat;
                              lsum[x].lh:=lsum[x].lh+fieldbyname(row+' Line Hrs').asfloat;
                         end;
                         for x:=0 to 2 do
                         begin
                              case x of
                                0:row:='HB';
                                1:row:='XB';
                                2:row:='KB';
                              end;
                              brgtons:=brgtons+fieldbyname(row+' Tons').asfloat;
                         end;
                    end;
                    next;
               end;
               enablecontrols;
          end;
          with soldjobs do
          begin
               edit;
               soldjobsfreight.value:=freight;
               soldjobscommission.value:=comm;
               soldjobssubtotal2.value:=sub2;
               soldjobssellingprice.value:=freight+sub2;
               soldjobstonssold.value:=tons;
               soldjobsbridging.value:=brgtons;
               for x:=0 to 3 do
               begin
                    case x of
                      0:row:='L1';
                      1:row:='L2';
                      2:row:='LS';
                      3:row:='JG';
                    end;
                    fieldbyname(row+' Pieces').asinteger:=lsum[x].pcs;
                    fieldbyname(row+' Tons').asfloat:=lsum[x].tons;
                    fieldbyname(row+' Line Hrs').asfloat:=lsum[x].lh;
               end;
               post;
          end;
     end;
end;}

procedure iconcreate;
var
   x:integer;
   temp:pchar;
begin
     for x:=Low(bitmaps) to High(bitmaps) do
     begin
          bitmaps[x]:=tbitmap.create;
          temp:='BITMAP_1';
          case x of
            1:temp:='BITMAP_2';
            2:temp:='BITMAP_3';
            3:temp:='BITMAP_4';
          end;
          bitmaps[x].Handle:=LoadBitmap(HInstance,temp);
     end;
end;

procedure iconfree;
var
   b:integer;
begin
     for b:=Low(bitmaps) to High(bitmaps) do
          bitmaps[b].free;
end;

procedure optionfill(book:tnotebook);
var
   x,y,z:integer;
begin
     z:=book.pages.count-1;
     if (mainform.modulebook.pageindex=2) and (dept<>1) then
        z:=z-1;
     if (mainform.modulebook.pageindex=1) and (dept=2) then
        z:=z-1;
     for x:=0 to z do
     begin
          y:=x;
          case mainform.modulebook.pageindex of
          0:y:=x;
          1:y:=1;
          2:y:=1;
          end;
          if (dept=2) and (x>0) and (mainform.modulebook.pageindex=1) then
             mainform.ListBox1.Items.AddObject(book.pages.strings[x+1],Bitmaps[y])
          else
          begin
               mainform.ListBox1.Items.AddObject(book.pages.strings[x],Bitmaps[y]);
          end;
     end;
     if (mainform.modulebook.pageindex=1) and (dept=2) and (book.pageindex>0) then
        mainform.listbox1.itemindex:=book.pageindex-1
     else
         mainform.listbox1.itemindex:=book.pageindex;
end;

procedure doprint(ncopy:integer);
var
   curr,x,y:integer;
   Gauge1:tprogressbar;
   StartTime,EndTime:single;
const
     CLOCK_TICK:Single=1000;
begin
    with mainform do
    begin
         Gauge1:=tprogressbar.Create(application);
         enabled:=false;
         for x:=0 to Mainmenu.Items.count-1 do
             Mainmenu.Items[x].enabled:=False;
         Hint.SimplePanel:=true;
         try
         Gauge1.Parent:=hint;
         Gauge1.Top:=2;
         Gauge1.Left:=160;
         gauge1.position:=0;
         curr:=1;
         if reportn>0 then
         begin
              for y:=1 to ncopy do
              begin
                   hint.SimpleText:='Printing Page '+inttostr(curr)+' of '+inttostr(ncopy);
                   case reportn of
                   1:drawmatprop(printer.canvas,prntscle,1);
                   2:drawmatreq(printer.canvas,prntscle,1);
                   end;
                   gauge1.position:=trunc(curr/(ncopy)*100);
                   inc(curr);
              end;
         end
         else
         begin
              if modulebook.pageindex=2 then
              begin
                   prevpages:=2;
                   if printdialog1.printrange=prallpages then
                   begin
                        Joists.First;
                        recalcjoist;
                        //iconview.col:=0;
                        //iconview.row:=0;
                        ncopy:=ncopy*joists.recordcount;
                   end;
                   for y:=1 to ncopy do
                   for x:=1 to prevpages do
                   begin
                        hint.SimpleText:='Printing Page '+inttostr(curr)+' of '+inttostr(prevpages*ncopy);
                        Mainform.ListBox1Click(nil);
                        drawstress(printer.canvas,prntscle,1,x);
                        gauge1.position:=trunc(curr/(prevpages*ncopy)*100);
                        inc(curr);
                        if curr<=ncopy*prevpages then
                           printer.newpage;
                        if (printdialog1.printrange=prallpages) and (x=prevpages) then
                        begin
                             {if curr/prevpages>joists.recordcount then
                             begin
                                  iconview.col:=0;
                                  iconview.row:=0;
                             end
                             else
                                 NextClick(nil);}
                             //Joists.Next;
                             //recalcjoist;
                             //MainForm.ListBox1Click(nil);

                             if curr/prevpages>joists.recordcount then
                             begin
                                  joists.First;
                             end
                             else
                             begin
                                joists.next;
                                recalcjoist;
                             end;
                        end;
                   end;
              end;
              if (modulebook.pageindex=0) and (jobbook.pageindex=0) then
              begin
                   prevpages:=2;
                   if printdialog1.printrange=prallpages then
                   begin
                        ncopy:=ncopy*jobinfo.recordcount;
                   end;
                   for y:=1 to ncopy do
                   for x:=1 to prevpages do
                   begin
                        hint.SimpleText:='Printing Page '+inttostr(curr)+' of '+inttostr(prevpages*ncopy);
                        if x=1 then
                           drawbid(printer.canvas,prntscle,1);
                        if x=2 then
                           drawconf(printer.canvas,prntscle,1);
                        gauge1.position:=trunc(curr/(prevpages*ncopy)*100);
                        inc(curr);
                        if curr<=ncopy*prevpages then
                           printer.newpage;
                        if (printdialog1.printrange=prallpages) and (x=prevpages) then
                        begin
                             if curr/prevpages<=jobinfo.recordcount then
                                 NextClick(nil);
                        end;
                   end;
              end;
         end;
         StartTime:=GetTickCount;
         repeat
               EndTime:=GetTickCount-StartTime;
         until (EndTime/CLOCK_TICK>0.5);
         finally
         enabled:=true;
         for x:=0 to Mainmenu.Items.count-1 do
             Mainmenu.Items[x].enabled:=true;
         gauge1.free;
         Hint.SimplePanel:=false;
         end;
    end;
end;

procedure printprog;
begin
     try
     prntscle:=printer.pagewidth/8.5;
     Printer.Orientation:=poPortrait;
     Printer.Title:='Job '+MainForm.JobJobNumber.value;
     Printer.BeginDoc;
     doprint(mainform.printdialog1.copies);
     Printer.EndDoc;
     except
           printer.abort;
           Printer.EndDoc;
     end;
end;

end.
