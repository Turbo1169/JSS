unit ChkFiles;

interface

uses classes, sysutils, dialogs, registry;

function checkLaunch:boolean;

implementation

const
        SECTION='NMBS Joist Design';
var
        localpath,netpath:string;

function checkfiledate(filename:string): Boolean;
var
   netdate,localdate:Tdatetime;
begin
        if FileExists(netpath+'\'+FileName) then
        begin
                netdate:=FileDateToDateTime(FileAge(netpath+'\'+filename));
                if FileExists(localpath+FileName) then
                begin
                        localdate:=FileDateToDateTime(FileAge(localpath+filename));
                        if netdate>localdate then
                                result:=true
                        else
                                result:=false;
                end
                else
                        result:=true;
        end
        else
                result:=false;
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

function checkLaunch:boolean;
var
        filename:string;
        finifile: TRegIniFile;
begin
        finifile:=TRegIniFile.Create('Software');
        netpath:=finifile.ReadString(SECTION,'netpath','');

        localpath:=ExtractFilePath(ParamStr(0));
        filename:='launch.exe';
        if checkfiledate(filename) then
        begin
                result:=false;
                filecopy(netpath+'\'+filename, localpath+'\'+filename);
                MessageDlg('Launch file updated. Please restart application.', mtInformation, [mbOk], 0);
        end
        else
                result:=true;
end;


end.
 