unit PSI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls;

type
  joistdata=record
    mark:string[6];
    tldef,lldef,qty:integer;
    addload,uplift,bl,tcxl,tcxr,bcxl,bcxr:single;
    tcbend,bcbend,bcunif,tcunif:single;
    desc:string;
  end;
  TPSIForm = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ProgressBar1: TProgressBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure doimport;
  public
    { Public declarations }
  end;

var
  PSIForm: TPSIForm;

implementation

uses Main, Entry;

{$R *.DFM}

function dectoing(decn:single):shortstring; external 'comlib.dll';

function PSIinchtodec(ing:shortstring):single;
var
   temp:string;
   c,x:integer;
   conv,conv1,conv2:single;
begin
     if pos('"',ing)>0 then
        delete(ing,pos('"',ing),1);
     conv2:=0;
     x:=pos(' ',ing);
     if x=0 then
        x:=length(ing)+1;
     if length(ing)>0 then
     begin
          temp:=copy(ing,1,x-1);
          delete(ing,1,x);
          val(temp,conv,c);
          conv2:=conv2+conv/12;
          x:=pos('/',ing);
          if x=0 then
             x:=length(ing)+1;
          if length(ing)>0 then
          begin
               temp:=copy(ing,1,x-1);
               delete(ing,1,x);
               val(temp,conv,c);
               temp:=copy(ing,1,length(ing));
               val(temp,conv1,c);
               if conv1>0 then
                  conv2:=conv2+conv/conv1/12;
          end;
     end;
     result:=conv2*12;
end;

function PSIingtodec(ing:shortstring):single;
var
   temp:string;
   c,x:integer;
   conv,conv1,conv2:single;
begin
     if pos('''',ing)>0 then
        delete(ing,pos('''',ing),1)
     else
     begin
        PSIingtodec:=PSIinchtodec(ing);
        exit;
     end;
     if pos('"',ing)>0 then
        delete(ing,pos('"',ing),1);
     conv2:=0;
     x:=pos('-',ing);
     if x=0 then
        x:=length(ing)+1;
     if length(ing)>0 then
     begin
          temp:=copy(ing,1,x-1);
          delete(ing,1,x);
          val(temp,conv,c);
          conv2:=conv2+conv;
          x:=pos(' ',ing);
          if x=0 then
             x:=length(ing)+1;
          if length(ing)>0 then
          begin
               temp:=copy(ing,1,x-1);
               delete(ing,1,x);
               val(temp,conv,c);
               conv2:=conv2+conv/12;
               x:=pos('/',ing);
               if x=0 then
                  x:=length(ing)+1;
               if length(ing)>0 then
               begin
                    temp:=copy(ing,1,x-1);
                    delete(ing,1,x);
                    val(temp,conv,c);
                    temp:=copy(ing,1,length(ing));
                    val(temp,conv1,c);
                    if conv1>0 then
                       conv2:=conv2+conv/conv1/12;
               end;
          end;
     end;
     PSIingtodec:=conv2*12;
end;

procedure addjoist(newjoist:joistdata);
begin
        with mainform do
        begin
                {if (dept=0) and (joists.Locate('[jobinfojobnumber.value,jobinfopage.value,newjoist.mark] ,[])) then
                begin
                        joists.delete;
                end;
                if (dept>0) and (joists.Locate([sequencejobnumber.value,sequencepage.value,newjoist.mark], [])) then
                begin
                        joists.delete;
                end;}

                if Joists.Locate('Mark', newjoist.mark, []) then
                  Joists.Delete;


                mintc:='';
                minbc:='';
                joists.insert;
                joistsTCXL.value:=dectoing(0);
                joistsTCXR.value:=dectoing(0);
                joistsconsolidate.Value:=false;
                JoistsTCXLTY.Value:='R';
                JoistsTCXRTY.Value:='R';
                joiststime.value:=1;
                JoistsMark.Value:=newjoist.mark;
                JoistsQuantity.Value:=newjoist.qty;
                JoistsDescription.Value:=newjoist.desc;
                JoistsBaseLength.Value:=dectoing(newjoist.bl);
                joistslldeflection.value:=newjoist.lldef;
                joiststldeflection.value:=newjoist.tldef;
                joistsTCXL.value:=dectoing(newjoist.tcxl);
                joistsTCXR.value:=dectoing(newjoist.tcxr);
                JoistsBCXL.Value:=dectoing(newjoist.bcxl);
                JoistsBCXR.Value:=dectoing(newjoist.bcxr);
                JoistsAddLoad.Value:=newjoist.addload;
                JoistsNetUplift.Value:=newjoist.uplift;
                JoistsTCUniformLoad.Value:=newjoist.tcunif;
                JoistsBCUniformLoad.Value:=newjoist.bcunif;
                JoistsAnywhereTC.Value:=newjoist.tcbend;
                JoistsAnywhereBC.Value:=newjoist.bcbend;
                entryform.updatejoist;
        end;
end;

procedure TPSIForm.doimport;
var
        x:integer;
        strvar,temp:string;
        jdata:joistdata;
begin
        x:=0;
        ProgressBar1.Visible:=true;
        LockWindowUpdate(mainform.handle);
        entryform:=tentryform.create(application);
        while x<Memo1.Lines.Count do
        begin
                temp:=Memo1.Lines[x];
                if copy(temp,1,1)='[' then
                begin
                        jdata.mark:=copy(temp,2,length(temp)-2);

                        strvar:='QUANTITY';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.qty:=strtoint(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='BASELENGTH';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.bl:=psiingtodec(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='TCXL';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.tcxl:=psiingtodec(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='TCXR';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.tcxr:=psiingtodec(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='BCXL';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.bcxl:=psiingtodec(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='BCXR';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.bcxr:=psiingtodec(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='mdepth';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.desc:=inttostr(round(strtofloat(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)))));

                        strvar:='series';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        temp:=copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp));
                        jdata.desc:=jdata.desc+copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp));
                        if (temp='K') or (temp='LH') or (temp='DLH') then
                        begin
                                strvar:='totload';
                                repeat
                                        inc(x);
                                        temp:=Memo1.Lines[x];
                                until copy(temp,1,LENGTH(strvar))=strvar;
                                jdata.desc:=jdata.desc+copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp));
                                strvar:='liveload';
                                repeat
                                        inc(x);
                                        temp:=Memo1.Lines[x];
                                until copy(temp,1,LENGTH(strvar))=strvar;
                                if strtofloat(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)))>0 then
                                begin
                                        jdata.desc:=jdata.desc+'/';
                                        jdata.desc:=jdata.desc+copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp));
                                end;
                        end
                        else
                        begin
                                strvar:='qtyspaces';
                                repeat
                                        inc(x);
                                        temp:=Memo1.Lines[x];
                                until copy(temp,1,LENGTH(strvar))=strvar;
                                jdata.desc:=jdata.desc+copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp))+'N';
                                strvar:='ppload';
                                repeat
                                        inc(x);
                                        temp:=Memo1.Lines[x];
                                until copy(temp,1,LENGTH(strvar))=strvar;
                                jdata.desc:=jdata.desc+copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp))+'K';
                        end;
                        strvar:='netuplift';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.uplift:=strtofloat(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='tldefl';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.tldef:=strtoint(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='lldefl';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.lldef:=strtoint(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='adload';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.addload:=strtofloat(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)))*1000;

                        strvar:='tcbendload';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.tcbend:=strtofloat(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='bcbendload';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.bcbend:=strtofloat(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='addbcuniload';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.bcunif:=strtofloat(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        strvar:='addtcuniload';
                        repeat
                                inc(x);
                                temp:=Memo1.Lines[x];
                        until copy(temp,1,LENGTH(strvar))=strvar;
                        jdata.tcunif:=strtofloat(copy(temp,pos('=',temp)+1,length(temp)-pos('=',temp)));

                        addjoist(jdata);
                end;
                inc(x);
                ProgressBar1.Position:=round((x/Memo1.Lines.Count)*100);
        end;
        entryform.free;
        LockWindowUpdate(0);
end;


procedure TPSIForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        if ModalResult=mrOK then
        begin
                OKBtn.Enabled:=false;
                doimport;
        end;
end;

end.
