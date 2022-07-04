unit Joblook;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids, DBGrids, StdCtrls, Buttons, DBCtrls,
  ExtCtrls, DB, ADODB;

type
  TJobLookForm = class(TForm)
    DataSource1: TDataSource;
    GroupBox1: TGroupBox;
    Locate: TLabel;
    edit1: TEdit;
    DBGrid1: TDBGrid;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label2: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label1: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    Label3: TLabel;
    Table1: TADOTable;
    Table1JobNumber: TWideStringField;
    Table1JobName: TWideStringField;
    Table1Location: TWideStringField;
    Table1State: TWideStringField;
    Table1Customer: TWideStringField;
    Table1Sold: TBooleanField;
    Table1Century: TSmallintField;
    Table1Where: TStringField;
    procedure FormShow(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormHide(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure ADOTable1CalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    function joblocate(job:string):string;
  end;

var
  JobLookForm: TJobLookForm;
  jobret:string;

implementation

{$R *.DFM}

uses main;

function TJobLookForm.joblocate(job:string):string;
var
   currjob:string;
begin
     table1.indexfieldnames:='Century;[Job Number]';
     table1.open;
     currjob:=job;
     table1.Locate('Job Number', job, []);
     if job='' then
        table1.first;
     showmodal;
     if modalresult=mrOk then
        result:=jobret
     else
        result:=currjob;
     table1.close;
end;

procedure TJobLookForm.FormShow(Sender: TObject);
begin
     edit1.text:='';
     edit1.setfocus;
end;

procedure TJobLookForm.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if edit1.text<>'' then
     begin
          try
          table1.disablecontrols;
          if RadioButton1.Checked then
              table1.locate('Job Number', uppercase(edit1.text), [loPartialKey])
          else
              table1.locate('Job Name', uppercase(edit1.text), [loPartialKey]);
          finally
          table1.enablecontrols;
          end;
     end;
end;

procedure TJobLookForm.FormHide(Sender: TObject);
begin
     jobret:=table1jobnumber.value;
end;

procedure TJobLookForm.DBGrid1DblClick(Sender: TObject);
begin
     if okbtn.enabled then
        modalresult:=mrOK;
end;

procedure TJobLookForm.ADOTable1CalcFields(DataSet: TDataSet);
begin
    table1where.value:=table1location.value+', '+table1state.value;
end;

procedure TJobLookForm.DataSource1DataChange(Sender: TObject; Field: TField);
begin
     {if dept>0 then
        okbtn.enabled:=table1sold.value;}
end;

procedure TJobLookForm.RadioButton1Click(Sender: TObject);
begin
     table1.indexfieldnames:='Century;[Job Number]';
     locate.caption:='Job Number:';
     table1jobname.index:=1;
     table1jobnumber.index:=0;
     edit1.text:='';
     edit1.setfocus;
end;

procedure TJobLookForm.RadioButton2Click(Sender: TObject);
begin
     table1.indexfieldnames:='[Job Name]';
     locate.caption:='Job Name:';
     table1jobname.index:=0;
     table1jobnumber.index:=1;
     edit1.text:='';
     edit1.setfocus;
end;

end.

