unit Import;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, DBTables, ComCtrls, Db;

type
  TImportForm = class(TForm)
    GroupBox1: TGroupBox;
    SelectBox: TListBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImportForm: TImportForm;

implementation

{$R *.DFM}

procedure importdata;
var
   table1,table2:Ttable;
   batch:tbatchmove;
begin
     batch:=tbatchmove.Create(application);
     table1:=TTable.create(application);
     table1.databasename:='EXPORT';
     table1.tablename:='JOBINFO.DB';
     table2:=TTable.create(application);
     table2.databasename:='JOIST';
     table2.tablename:=table1.tablename;
     //table2.IndexFieldNames:='Job Number';
     batch.Source:=table1;
     batch.Destination:=table2;
     batch.Mode:=batAppendUpdate;
     batch.Execute;

     table1.tablename:='QUOTES.DB';
     table2.tablename:=table1.tablename;
     //table2.IndexFieldNames:='Job Number;Page';
     batch.Execute;

     table1.tablename:='JOBMISC.DB';
     table2.tablename:=table1.tablename;
     //table2.IndexFieldNames:='Job Number;Page;Category;Item';
     batch.Execute;

     table1.tablename:='JOISTS.DB';
     table2.tablename:=table1.tablename;
     //table2.IndexFieldNames:='Job Number;Page;Mark';
     batch.Execute;

     table1.tablename:='BRIDG.DB';
     table2.tablename:=table1.tablename;
     //table2.IndexFieldNames:='Job Number;Page;Mark';
     batch.Execute;

     table1.tablename:='JSUBST.DB';
     table2.tablename:=table1.tablename;
     //table2.IndexFieldNames:='Job Number;Page;Mark';
     batch.Execute;

     table1.free;
     table2.free;
     batch.free;
end;

procedure TImportForm.FormShow(Sender: TObject);
var
        table1:Ttable;
begin
        table1:=TTable.create(application);
        table1.databasename:='EXPORT';
        table1.tablename:='JOBINFO.DB';
        table1.open;
        SelectBox.Clear;
        selectbox.items.beginupdate;
        while not table1.eof do
        begin
             Selectbox.items.add('['+table1.fieldbyname('Job Number').asstring+'] - '+table1.fieldbyname('Job Name').asstring);
             table1.next;
        end;
        selectbox.items.endupdate;
        table1.close;
        table1.free;
end;

procedure TImportForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        if modalresult=mrOK then
        begin
                okbtn.Enabled:=false;
                importdata;
        end;
end;

end.
