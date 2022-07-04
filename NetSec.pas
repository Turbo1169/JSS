unit NetSec;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  NTNLM32, StdCtrls, ExtCtrls;

type
  TSecurityForm = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
   SecurityForm: TSecurityForm;

   function openkey:smallint;
   function softwarelock:smallint;
   function closekey:smallint;

implementation

{$R *.DFM}

{ TForm1 }

Const
     { Change These two constants for different key type and algo ID }
     KeyType = 'C';
     { AlgoID = $FC9D; }
     AlgoID = $901D;

var
        KeyHandle : SmallInt;
        params         : RNBO_PARAMETERS_T;
        queryData      : QUERY_DATA;
        TempStr        : String;

function closekey: smallint;
var
        x:integer;
begin
     x:=0;
     result:=1;
     try
     while (result<>0) and (x<5) do
     begin
        result:=0;
        result  := close_key( KeyHandle );
        TempStr := 'close_key = ';
        TempStr := TempStr + IntToStr(result);
        inc(x);
     end;
     finally
        if result<>0 then
                ShowMessage('Hardware lock not found for closing.')
        else
                detach_from_dll;
     end;
end;

function openkey: smallint;
var
        x:integer;
begin
     SecurityForm:=TSecurityForm.Create(Application);
     SecurityForm.show;
     x:=0;
     KeyHandle:=1;
     try
     while (KeyHandle<>0) and (x<5) do
     begin
         SecurityForm.Label1.Caption:='Running Security check (try '+inttostr(x+1)+' of 5)';
         SecurityForm.Refresh;
         KeyHandle:=0;
         params.RNBO_FUNC       := RBP_DEFINE_PROTOCOLS;
         params.p2.protocols[0] := XP_NWLINK_IPX;
         params.p2.protocols[1] := XP_TCP_IP;
         params.p2.protocols[2] := XP_NETBIOS_ANY;
         params.p2.protocols[3] := XP_LOCAL;
         params.p2.protocols[4] := XP_TERMINATOR;
         result  := set_rnbo_lib_parameters(params);
         TempStr := 'set_rnbo_lib_parameters  = ';
         TempStr := TempStr + IntToStr(result);

         KeyHandle  := open_first_key( keyType, algoID );
         TempStr := 'open_first_key = ';
         TempStr := TempStr + IntToStr(KeyHandle);
         inc(x);
         if KeyHandle<>0 then
                SecurityForm.Label1.Caption:='Hardware Lock not found';
     end;
     finally
     SecurityForm.close;
     SecurityForm.free;
     if KeyHandle<>0 then
     begin
        ShowMessage('Hardware lock not found, aborting execution.');
     end;
     result:=KeyHandle;
     end;
end;

function softwarelock: smallint;
var
        x:integer;
begin
     x:=0;
     result:=1;
     try
     while (result<>0) and (x<5) do
     begin
         result:=0;
         if ( keyType = 'C' ) then
         begin
              queryData.C.COMMAND      := QC_READ_OP;
              queryData.C.CELL_ADDRESS := 61;
              result := query_key( KeyHandle, queryData );
         end
         else { pro key }
         begin
              queryData.PRO := 'WELCOME TO NETSENTINEL';
              result        := query_key( KeyHandle, queryData );
         end;
         inc(x);
     end;
     finally
     if result<>0 then
        ShowMessage('Hardware lock not found or authorized use terminated.');
     end;
end;

end.
 