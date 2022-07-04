unit export;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, dbtables, ComCtrls;

type
  TExportForm = class(TForm)
    GroupBox1: TGroupBox;
    SelectBox: TListBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    ProgressBar1: TProgressBar;
    DeleteCheck: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExportForm: TExportForm;

implementation

uses Main;

{$R *.DFM}

Procedure CopyRecord(const SourceTable, DestTable : TTable);
var
  I : Word;
begin
  DestTable.Append;
  For I := 0 to SourceTable.FieldCount - 1 do
  begin
       DestTable.Fields[I].Assign(SourceTable.Fields[I]);
  end;
  DestTable.Post;
  if ExportForm.DeleteCheck.Checked then
        SourceTable.delete;
end;

procedure exportdata(job:string; empty:boolean);
var
   table1,table2:Ttable;
   x:integer;
begin
     table1:=TTable.create(application);
     table2:=TTable.create(application);
     try
         for x:=1 to 5 do
         begin
             table1.databasename:='EXPORT';
             case x of
               1:table1.tablename:='BRIDG.DB';
               2:table1.tablename:='JSUBST.DB';
               3:table1.tablename:='JOISTS.DB';
               4:table1.tablename:='JOBMISC.DB';
               5:table1.tablename:='QUOTES.DB';
             end;
             if empty then
                    table1.EmptyTable;
             table1.open;
             table2.databasename:='JOIST';
             table2.tablename:=table1.tablename;
             table2.IndexFieldNames:='Job Number;Page';
             table2.open;
             with table2 do
             begin
                  EditRangeStart;
                  FieldByName('Job Number').AsString:=job;
                  FieldByName('Page').Asinteger:=0;
                  EditRangeEnd;
                  FieldByName('Job Number').AsString:=job;
                  FieldByName('Page').Asinteger:=100;
                  ApplyRange;
                  first;
                  if ExportForm.DeleteCheck.Checked then
                  begin
                    while table2.RecordCount>0 do
                            copyrecord(table2,table1);
                  end
                  else
                  while not eof do
                  begin
                     copyrecord(table2,table1);
                     next;
                  end;
                  CancelRange;
             end;
             table1.Close;
             table2.close;
         end;
         table1.databasename:='EXPORT';
         table1.tablename:='JOBINFO.DB';
         if empty then
            table1.EmptyTable;
         table1.open;
         table2.databasename:='JOIST';
         table2.tablename:=table1.tablename;
         table2.IndexFieldNames:='Job Number';
         table2.open;
         if table2.FindKey([job]) then
                copyrecord(table2,table1);
     finally
        table1.Close;
        table2.close;
        table1.free;
        table2.free;
     end;
end;

procedure TExportForm.FormShow(Sender: TObject);
var
        table1:Ttable;
begin
        table1:=TTable.create(application);
        table1.databasename:='JOIST';
        table1.tablename:='JOBINFO.DB';
        table1.IndexFieldNames:='Century;Job Number';
        table1.open;
        SelectBox.Clear;
        selectbox.items.beginupdate;
        while not table1.eof do
        begin
             Selectbox.items.add('['+table1.fieldbyname('Job Number').asstring+'] - '+table1.fieldbyname('Job Name').asstring);
             if table1.fieldbyname('Job Number').asstring=mainform.jobjobnumber.value then
                selectbox.selected[selectbox.items.count-1]:=true;
             table1.next;
        end;
        selectbox.items.endupdate;
        table1.close;
        table1.free;
end;

procedure TExportForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
        c,x:integer;
        temp:string;
begin
        if modalresult=mrOK then
        begin
                 okbtn.Enabled:=false;
                 ProgressBar1.Visible:=true;
                 x:=0;
                 c:=0;
                 repeat
                       if (selectbox.selected[x]) then
                       begin
                            temp:=selectbox.items.strings[x];
                            temp:=copy(temp,pos('[',temp)+1,pos(']',temp)-2);
                            ProgressBar1.Position:=round((c+1)/selectbox.SelCount*100);
                            if (temp=mainform.jobjobnumber.value) and (ExportForm.DeleteCheck.Checked) then
                                mainform.Close1Click(Sender);
                            if c=0 then
                                exportdata(temp,true)
                            else
                                exportdata(temp,false);
                            inc(c);
                       end;
                       inc(x);
                 until x=selectbox.items.count;
        end;
end;

end.
