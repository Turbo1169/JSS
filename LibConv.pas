unit LibConv;

interface

uses windows, sysutils, forms, reg, registry, classes, dialogs, BDE, db,
     dbtables;

function ingtodec(ing:shortstring):single; export;
function dectoing(decn:single):shortstring; export;
function inchtodec(ing:shortstring):single; export;
function dectoinch(decn:single):shortstring; export;
function rndprec(decn:single):single; export;
procedure addstr(var temp2:shortstring; news:shortstring; spos:integer); export;
function week(actdate:tdatetime):smallint; export;
function clength(x1,y1,x2,y2:single):single; export;
function cangle(x1,y1,x2,y2:single):single; export;
function verifyreg:boolean; export;
function mpass:shortstring; export;
procedure diagbridg(var a,b,c,d:single; s1,s2:single); export;
procedure XlsBeginStream(XlsStream: TStream; const BuildNumber: Word); export;
procedure XlsEndStream(XlsStream: TStream); export;
procedure XlsWriteCellRk(XlsStream: TStream; const ACol, ARow: Word; const AValue: Integer); export;
procedure XlsWriteCellNumber(XlsStream: TStream; const ACol, ARow: Word; const AValue: Double); export;
procedure XlsWriteCellLabel(XlsStream: TStream; const ACol, ARow: Word; const AValue: string); export;
function CalcAccWeight(TypeDesc:string; gage:smallint; adim,bdim,cdim,length:single):single; export;
function CalcDeckWeight(gage,galvanized,coverage:smallint; CoilWidth:single):single; export;
function findint(var x1,y1:single; x2,y2,x3,y3,x4,y4:single):boolean; export;
function checkBDE:boolean; export;

implementation

type
  TGageProp = Record
    Gage:smallint;
    Thick,Weight:single;
  end;

const
     prec:integer=8;
     precinch:integer=16;
     C1:word=52845;
     C2:word=11719;
     NN:word=5555;
     SECTION='Microsoft';

var
        CXlsBof: array[0..5] of Word = ($809, 8, 00, $10, 0, 0);
        CXlsEof: array[0..1] of Word = ($0A, 00);
        CXlsLabel: array[0..5] of Word = ($204, 0, 0, 0, 0, 0);
        CXlsNumber: array[0..4] of Word = ($203, 14, 0, 0, 0);
        CXlsRk: array[0..4] of Word = ($27E, 10, 0, 0, 0);
        GageProp:array[0..16] of TGageProp;
        x:integer;

function GetConfigParameter(Param: string; Count: pword): string;

var

  hCur: hDBICur;

  rslt: DBIResult;

  Config: CFGDesc;

  Path, Option: string;

  Temp: array[0..255] of char;



begin

  Result := ''; hCur := nil;

  if Count <> nil then

    Count^ := 0;

  try

    if Pos(';', Param) = 0 then

      raise EDatabaseError.Create('Invalid parameter passed to function.  There must ' +

         'be a semi-colon delimited sting passed');

    Path := Copy(Param, 0, Pos(';', Param) - 1);

    Option := Copy(Param, Pos(';', Param) + 1, Length(Param) - Pos(';', Param));

    Check(DbiOpenCfgInfoList(nil, dbiREADONLY, cfgPERSISTENT, StrPCopy(Temp, Path), hCur));

    Check(DbiSetToBegin(hCur));

    repeat

      rslt := DbiGetNextRecord(hCur, dbiNOLOCK, @Config, nil);

      if rslt = DBIERR_NONE then

      begin

        if StrPas(Config.szNodeName) = Option then

          Result := Config.szValue;

        if Count <> nil then

          Inc(Count^);

      end

      else

        if rslt <> DBIERR_EOF then

          Check(rslt);

    until rslt <> DBIERR_NONE;

  finally

    if hCur <> nil then

      Check(DbiCloseCursor(hCur));

  end;

end;

procedure SetConfigParameter(Param: string; Value: string);

var

  hCur: hDBICur;

  rslt: DBIResult;

  Config: CFGDesc;

  Path, Option: string;

  Found: boolean;

  Temp: array[0..255] of char;



begin

  hCur := nil;

  Found := False;

  try

    if Pos(';', Param) = 0 then

      raise EDatabaseError.Create('Invalid parameter passed to function.  There must ' +

         'be a semi-colon delimited sting passed');

    Path := Copy(Param, 0, Pos(';', Param) - 1);

    Option := Copy(Param, Pos(';', Param) + 1, Length(Param) - Pos(';', Param));

    Check(DbiOpenCfgInfoList(nil, dbiREADWRITE, cfgPERSISTENT, StrPCopy(Temp, Path), hCur));

    repeat

      rslt := DbiGetNextRecord(hCur, dbiNOLOCK, @Config, nil);

      if rslt = DBIERR_NONE then

      begin

        if StrPas(Config.szNodeName) = Option then

        begin

          StrPCopy(Config.szValue, Value);

          Check(DbiModifyRecord(hCur, @Config, FALSE));

          Found := True;

          break;

        end;

      end

      else

        if rslt <> DBIERR_EOF then

          Check(rslt);

    until rslt <> DBIERR_NONE;

    if Found = False then

      raise EDatabaseError.Create(Param + ' entry was not found in configuration file');



  finally

    if hCur <> nil then

      Check(DbiCloseCursor(hCur));

 end;

end;

procedure XlsBeginStream(XlsStream: TStream; const BuildNumber: Word);
begin
  CXlsBof[4] := BuildNumber;
  XlsStream.WriteBuffer(CXlsBof, SizeOf(CXlsBof));
end;

procedure XlsEndStream(XlsStream: TStream);
begin
  XlsStream.WriteBuffer(CXlsEof, SizeOf(CXlsEof));
end;

procedure XlsWriteCellRk(XlsStream: TStream; const ACol, ARow: Word; const AValue: Integer);
var
  V: Integer;
begin
  CXlsRk[2] := ARow;
  CXlsRk[3] := ACol;
  XlsStream.WriteBuffer(CXlsRk, SizeOf(CXlsRk));
  V := (AValue shl 2) or 2;
  XlsStream.WriteBuffer(V, 4);
end;

procedure XlsWriteCellNumber(XlsStream: TStream; const ACol, ARow: Word; const AValue: Double);
begin
  CXlsNumber[2] := ARow;
  CXlsNumber[3] := ACol;
  XlsStream.WriteBuffer(CXlsNumber, SizeOf(CXlsNumber));
  XlsStream.WriteBuffer(AValue, 8);
end;

procedure XlsWriteCellLabel(XlsStream: TStream; const ACol, ARow: Word; const AValue: string);
var
  L: Word;
begin
  L := Length(AValue);
  CXlsLabel[1] := 8 + L;
  CXlsLabel[2] := ARow;
  CXlsLabel[3] := ACol;
  CXlsLabel[5] := L;
  XlsStream.WriteBuffer(CXlsLabel, SizeOf(CXlsLabel));
  XlsStream.WriteBuffer(Pointer(AValue)^, L);
end;

function suppassw:shortstring;
var
     year,month,day:word;
     code,temp:string;
     x,sum:integer;
begin
     decodedate(now,year,month,day);
     code:=inttostr(year)+','+inttostr(month)+','+inttostr(day);
     sum:=year*month*day+111169;
     temp:=inttostr(sum);
     code:='';
     for x:=1 to length(temp) do
     begin
          code:=code+chr(trunc((strtoint(copy(temp,1,1)))*2.6+65));
          delete(temp,1,1);
     end;
     result:=code;
end;

function findint(var x1,y1:single; x2,y2,x3,y3,x4,y4:single):boolean;
var
   temp:single;
   s1,s2:single;
begin
        if x2<>x1 then
                s1:=(y2-y1)/(x2-x1)
        else
                s1:=0;
        if x4<>x3 then
                s2:=(y4-y3)/(x4-x3)
        else
                s2:=0;
        if ((s1=s2) and (x2<>x1) and (x4<>x3)) or ((x2=x1) and (x4=x3)) then
        begin
                MessageDlg('Intersection of two paralell lines with the same slope does not exist.', mtWarning,  [mbOk], 0);
                result:=false;
                exit;
        end;
        if (x2=x1) or (x4=x3) then
        begin
                if x2=x1 then
                begin
                        temp:=x2;
                        y1:=s2*temp+(y3-s2*x3);
                end
                else
                begin
                        temp:=x3;
                        y1:=s1*temp+(y2-s1*x2);
                end;
        end
        else
        begin
                temp:=(y4-s2*x4)-(y2-s1*x2);
                temp:=temp/(s1-s2);
                y1:=s1*temp+(y2-s1*x2);
        end;
        x1:=temp;
        result:=true;
end;

procedure diagbridg(var a,b,c,d:single; s1,s2:single);
var
   x1,y1,x2,y2,x3,y3,x4,y4:single;
   xslope,yslope:single;
begin
     xslope:=sin(arctan(s1/b))*b;
     yslope:=b-cos(arctan(s1/b))*b;
     x1:=0-xslope;
     y1:=0+yslope;
     x2:=0+a;
     y2:=0+b+d;
     a:=clength(x1,y1,x2,y2);
     xslope:=sin(arctan(s2/c))*c;
     yslope:=c-cos(arctan(s2/c))*c;
     x3:=0;
     x4:=x2-xslope;
     y3:=0+b;
     y4:=(y3-(c-d))+yslope;
     findint(x1,y1,x2,y2,x3,y3,x4,y4);
     b:=a-clength(x1,y1,x2,y2);
     c:=clength(x3,y3,x4,y4);
     d:=clength(x1,y1,x3,y3);
end;

function clength(x1,y1,x2,y2:single):single;
begin
     clength:=sqrt(sqr(abs(x1-x2))+sqr(abs(y1-y2)));
end;

function cangle(x1,y1,x2,y2:single):single;
begin
     if abs(x1-x2)>0 then
        cangle:=arctan(abs(y1-y2)/abs(x1-x2))
     else
         cangle:=pi/2;
end;

function week(actdate:tdatetime):smallint;
var
   days:single;
   mond2,week2:smallint;
   ayear,amonth,aday:word;
begin
     decodedate(actdate,ayear,amonth,aday);
     mond2:=dayofweek(encodedate(ayear,1,1));
     if mond2=7 then
        mond2:=0;
     dec(mond2);
     days:=actdate-encodedate(ayear,1,1)+mond2;
     week2:=trunc(days/7)+1;
     if week2>52 then
     begin
        if encodedate(ayear+1,1,1)-actdate+dayofweek(actdate)<7 then
                week2:=week2-52;
     end;
     result:=week2;
end;

procedure addstr(var temp2:shortstring; news:shortstring; spos:integer);
var
   x,l:integer;
begin
     if spos>0 then
     begin
          l:=length(temp2);
          spos:=spos*5;
          if (spos-l)>0 then
          begin
               for x:=1 to (spos-l) do
               begin
                    temp2:=temp2+' ';
               end;
          end;
     end;
     temp2:=temp2+news;
end;

function rndprec(decn:single):single;
begin
     rndprec:=round(decn*prec)/prec;
end;

function inchtodec(ing:shortstring):single;
var
   temp:string;
   c,x:integer;
   conv,conv1,conv2:single;
begin
     conv2:=0;
     x:=pos(' ',ing);
     if x=0 then
        x:=length(ing)+1;
     if length(ing)>0 then
     begin
          if pos(' ',ing)>0 then
          begin
                temp:=copy(ing,1,x-1);
                delete(ing,1,x);
                val(temp,conv,c);
                conv2:=conv2+conv/12;
          end
          else
          begin
                if pos('/',ing)=0 then
                begin
                        val(ing,conv,c);
                        conv2:=conv/12;
                end;
          end;
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

function dectoinch(decn:single):shortstring;
var
   temp,temp2:string;
   max,max2,dd:integer;
begin
     max:=trunc(decn);
     dd:=round(frac(decn)*precinch);
     if dd=precinch then
     begin
        inc(max);
        dd:=0;
     end;
     if max>0 then
        temp2:=inttostr(max)
     else
        temp2:='';
     if dd>0 then
     begin
        max:=2; max2:=1;
        while max<precinch do
        begin
          if dd/max=int(dd/max) then
             max2:=max;
          max:=max*2;
        end;
        temp:=inttostr(trunc(dd/max2));
        if temp2<>'' then
                temp2:=temp2+' '+temp+'/'+inttostr(trunc(precinch/max2))
        else
                temp2:=temp+'/'+inttostr(trunc(precinch/max2));
     end;
     result:=temp2
end;

function ingtodec(ing:shortstring):single;
var
   temp:string;
   c,x:integer;
   conv,conv1,conv2:single;
begin
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
     result:=conv2*12;
end;

function dectoing(decn:single):shortstring;
var
   temp,temp2:string;
   max,max2,dd:integer;
begin
     decn:=decn/12; max2:=trunc(decn);
     max:=trunc(frac(decn)*12);
     dd:=round(frac(frac(decn)*12)*prec);
     if dd=prec then
     begin
        inc(max);
        dd:=0;
     end;
     if max=12 then
     begin
          inc(max2);
          max:=0;
     end;
     temp2:=inttostr(max2)+'-'+inttostr(max);
     if dd>0 then
     begin
        max:=2; max2:=1;
        while max<prec do
        begin
          if dd/max=int(dd/max) then
             max2:=max;
          max:=max*2;
        end;
        temp:=inttostr(trunc(dd/max2));
        temp2:=temp2+' '+temp+'/'+inttostr(trunc(prec/max2));
     end;
     dectoing:=temp2
end;

function mpass:shortstring;
begin
     mpass:='vk41592';
end;

function Decrypt(const S:string; Key:Word): String;
var
   I:byte;
begin
     setlength(Result,length(S));
     for I:=1 to length(S) do begin
         result[I]:=char(byte(S[I]) xor (Key shr 8));
         Key:=(byte(S[I])+Key)*C1+C2;
     end;
end;

function Encrypt(const S:string; Key:Word): String;
var
   I:byte;
begin
     setlength(Result,length(S));
     for I:=1 to length(S) do begin
         result[I]:=char(byte(S[I]) xor (Key shr 8));
         Key:=(byte(result[I])+Key)*C1+C2;
     end;
end;

function doregister:boolean;
var
   temp,code:string;
   finifile:TRegIniFile;
   year,month,day:word;
begin
  finifile:=TRegIniFile.Create('Software');
  temp:=decrypt(finifile.ReadString(SECTION,'RmRegistry',''),NN);
  if copy(temp,1,2)<>'te' then
     finifile.WriteString(SECTION,'RmRegistry',encrypt('te'+temp,NN))
  else
      delete(temp,1,2);
  regform:=Tregform.Create(Application);
  regform.showmodal;
  code:=regform.edit1.text;
  regform.free;
  if uppercase(code)=uppercase(suppassw) then
  begin
       decodedate(now,year,month,day);
       code:=inttostr(year)+','+inttostr(month)+','+inttostr(day)+'aw';
       if temp=code then
       begin
            result:=false;
       end
       else
       begin
            finifile.WriteString(SECTION,'RmRegistry',encrypt(code,NN));
            result:=true;
       end;
  end
  else
      result:=false;
  finifile.free;
end;

function verifyreg:boolean;
Var
   Code:String;
   finifile:TRegIniFile;
   regdate:Tdatetime;
   year,month,day:word;
begin
   try
   finifile:=TRegIniFile.Create('Software');
   code:=finifile.ReadString(SECTION,'RmRegistry','');
   finifile.free;
   code:=decrypt(code,NN);
   if copy(code,length(code)-1,2)<>'aw' then
        raise exception.create('Code not Found');
   delete(code,length(code)-1,2);
   year:=strtoint(copy(code,1,pos(',',code)-1));
   delete(code,1,pos(',',code));
   month:=strtoint(copy(code,1,pos(',',code)-1));
   delete(code,1,pos(',',code));
   day:=strtoint(code);
   regdate:=encodedate(year,month,day);
   if regdate+90>date then
      result:=True
   else
       result:=false;
   except
         result:=false;
   end;
   if not result then
        if doregister then
           result:=true;
end;

Procedure FileCopy( Const sourcefilename, targetfilename: String );
Var
  S, T: TFileStream;
Begin
  S := TFileStream.Create( sourcefilename, fmOpenRead );
  try
    T := TFileStream.Create( targetfilename,
                             fmOpenWrite or fmCreate );
    try
      T.CopyFrom(S, S.Size ) ;
    finally
      T.Free;
    end;
  finally
    S.Free;
  end;
End;

function checkBDE:boolean;
begin
        if (GetConfigParameter('\SYSTEM\INIT\;LOCAL SHARE',nil)='FALSE') or (uppercase(GetConfigParameter('\DRIVERS\PARADOX\INIT\;NET DIR',nil))<>'K:\') then
        begin
                result:=false;
                SetConfigParameter('\DRIVERS\PARADOX\INIT\;NET DIR', 'K:\');
                SetConfigParameter('\SYSTEM\INIT\;LOCAL SHARE', 'TRUE');
        end
        else
                result:=true;
        if result=false then
                MessageDlg('BDE settings corrected. Please restart application.', mtInformation, [mbOk], 0);
end;

function CalcAccWeight(TypeDesc:string; gage:smallint; adim,bdim,cdim,length:single):single;
var
        wtsqft,area:single;
        x:integer;
begin
        area:=0;
        wtsqft:=0;
        for x := low(GageProp) to high(GageProp) do
        begin
                if gageprop[x].Gage=Gage then
                begin
                        wtsqft:=gageprop[x].Weight;
                        break;
                end;
        end;
        if TypeDesc='PS' then // Pour Stop
        begin
                area:=(adim+bdim+1)*length;
        end;
        if TypeDesc='GF' then // Girder Filler
        begin
                area:=(adim+(1+3/8)+(1+3/4))*length;
        end;
        if TypeDesc='CC' then // Cell Closure
        begin
                area:=(adim+bdim)*length;
        end;
        if TypeDesc='RVP' then // Ridge/Valley Plate
        begin
                area:=(adim+bdim)*length;
        end;
        if TypeDesc='FP' then // Flat Plate
        begin
                area:=adim*length;
        end;
        if TypeDesc='SP' then // Sump Pan
        begin
                area:=adim*bdim;
        end;
        if TypeDesc='FS' then // Filler Sheet
        begin
                area:=(adim+bdim+cdim)*length;
        end;
        if TypeDesc='CS' then // Cant Strip
        begin
                area:=(adim+bdim*2)*length;
        end;
        if TypeDesc='ZC' then // "Z" Closure
        begin
                area:=(adim+bdim+cdim)*length;
          end;
        if TypeDesc='COL' then // Column Closure
        begin
                area:=adim*bdim;
        end;
        if TypeDesc='SC' then // Side Closure
        begin
                area:=(adim+bdim*2)*length;
        end;
        if TypeDesc='BP' then // Bent Plate
        begin
                area:=(adim+bdim+cdim)*length;
        end;
        result:=area/144*wtsqft;
end;

function CalcDeckWeight(gage,galvanized,coverage:smallint; CoilWidth:single):single;
var
        thick,area:single;
        x:integer;
begin
        for x := low(GageProp) to high(GageProp) do
        begin
                if gageprop[x].Gage=Gage then
                        break;
        end;
        case Galvanized of
                40:thick:=0.0005;
                60:thick:=0.0007;
                90:thick:=0.001;
        else
                thick:=0;
        end;
        thick:=(thick+GageProp[x].Thick)*0.97;
        area:=CoilWidth*Thick;
        result:=(area*3.4)/(Coverage/12);
end;

begin
        for x := low(GageProp) to high(GageProp) do
        begin
                case x of
                0:begin
                        GageProp[x].Gage:=8;
                        GageProp[x].Thick:=0.1644;
                        GageProp[x].Weight:=6.875;
                  end;
                1:begin
                        GageProp[x].Gage:=9;
                        GageProp[x].Thick:=0.1495;
                        GageProp[x].Weight:=6.25
                  end;
                2:begin
                        GageProp[x].Gage:=10;
                        GageProp[x].Thick:=0.1345;
                        GageProp[x].Weight:=5.625;
                  end;
                3:begin
                        GageProp[x].Gage:=11;
                        GageProp[x].Thick:=0.1196;
                        GageProp[x].Weight:=5;
                  end;
                4:begin
                        GageProp[x].Gage:=12;
                        GageProp[x].Thick:=0.1046;
                        GageProp[x].Weight:=4.375;
                  end;
                5:begin
                        GageProp[x].Gage:=13;
                        GageProp[x].Thick:=0.0897;
                        GageProp[x].Weight:=3.75;
                  end;
                6:begin
                        GageProp[x].Gage:=14;
                        GageProp[x].Thick:=0.0747;
                        GageProp[x].Weight:=3.125;
                  end;
                7:begin
                        GageProp[x].Gage:=16;
                        GageProp[x].Thick:=0.0598;
                        GageProp[x].Weight:=2.5;
                  end;
                8:begin
                        GageProp[x].Gage:=17;
                        GageProp[x].Thick:=0.0538;
                        GageProp[x].Weight:=2.25;
                  end;
                9:begin
                        GageProp[x].Gage:=18;
                        GageProp[x].Thick:=0.0478;
                        GageProp[x].Weight:=2;
                  end;
                10:begin
                        GageProp[x].Gage:=20;
                        GageProp[x].Thick:=0.0359;
                        GageProp[x].Weight:=1.5;
                  end;
                11:begin
                        GageProp[x].Gage:=21;
                        GageProp[x].Thick:=0.0329;
                        GageProp[x].Weight:=1.375;
                  end;
                12:begin
                        GageProp[x].Gage:=22;
                        GageProp[x].Thick:=0.0299;
                        GageProp[x].Weight:=1.25;
                  end;
                13:begin
                        GageProp[x].Gage:=23;
                        GageProp[x].Thick:=0.0269;
                        GageProp[x].Weight:=1.125;
                  end;
                14:begin
                        GageProp[x].Gage:=24;
                        GageProp[x].Thick:=0.0239;
                        GageProp[x].Weight:=1;
                  end;
                15:begin
                        GageProp[x].Gage:=26;
                        GageProp[x].Thick:=0.0179;
                        GageProp[x].Weight:=0.75;
                  end;
                16:begin
                        GageProp[x].Gage:=28;
                        GageProp[x].Thick:=0.0149;
                        GageProp[x].Weight:=0.625;
                  end;
                end;
        end;

end.
