unit Jobinfo;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls, DB, DBLookup, Grids,
  DBGrids, ComCtrls, ADODB;

type
  TJobInfoForm = class(TForm)
    DataSource2: TDataSource;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBEdit2: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    GroupBox2: TGroupBox;
    Label24: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    GroupBox3: TGroupBox;
    DBGrid1: TDBGrid;
    GroupBox6: TGroupBox;
    DBText1: TDBText;
    Label14: TLabel;
    Label16: TLabel;
    DBText2: TDBText;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Customer: TADOTable;
    CustomerCustomer: TWideStringField;
    CustomerAddress: TWideStringField;
    CustomerCity: TWideStringField;
    CustomerState: TWideStringField;
    CustomerZip: TWideStringField;
    LastJobNumber: TADOQuery;
    LastJobNumberJobNumber: TWideStringField;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DataSource1DataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
    function newjob:string;
    procedure modprop(currjob:string);
  end;

var
  JobInfoForm: TJobInfoForm;
  isnewjob:boolean;
  jobstat:array[0..99] of string;

implementation

{$R *.DFM}

uses main;

procedure TJobInfoForm.modprop(currjob:string);
begin
     dbedit1.enabled:=false;
     mainform.job.edit;
     showmodal;
end;

function TJobInfoForm.newjob:string;
var
   newjobno:integer;
   Year,Month,Day:Word;
   jobno:string;
begin
     LastJobNumber.Open;
     DecodeDate(Date,Year,Month,Day);
     if copy(LastJobNumberjobnumber.value,1,2)=copy(inttostr(Year),3,2) then
        newjobno:=strtoint(copy(LastJobNumberjobnumber.value,4,4))+1
     else
         newjobno:=1;
     LastJobNumber.Close;
     jobno:=inttostr(newjobno);
     while length(jobno)<4 do
           jobno:='0'+jobno;
     jobno:=copy(inttostr(Year),3,2)+'-'+jobno;
     with mainform do
     begin
        job.Open;
        job.insert;
        jobCentury.Value:=strtoint(copy(inttostr(Year),1,2));
        jobjobnumber.value:=jobno;
        jobsold.value:=false;
     end;
     caption:='New Job';
     isnewjob:=true;
     showmodal;
     result:=jobno;
end;

procedure TJobInfoForm.FormCreate(Sender: TObject);
begin
     isnewjob:=false;
     customer.open;
end;

procedure TJobInfoForm.FormShow(Sender: TObject);
var
   x:integer;
begin
     dbedit2.setfocus;
     x:=0;
     if not isnewjob then
     begin
          if dept=0 then
          begin
               if mainform.jobinfo.RecordCount=0 then
                  PageControl1.Pages[1].TabVisible:=false;
               with mainform.jobinfo do
               begin
                    disablecontrols;
                    first;
                    while not eof do
                    begin
                         jobstat[x]:=mainform.jobinfostatus.value;
                         inc(x);
                         next;
                    end;
                    enablecontrols;
               end;
          end
          else
              PageControl1.Pages[1].TabVisible:=false;
     end
     else
         PageControl1.Pages[1].TabVisible:=false;
end;

procedure TJobInfoForm.OKBtnClick(Sender: TObject);
begin
     Okbtn.setfocus;
end;

procedure TJobInfoForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   x:integer;
begin
     if modalresult=mrOk then
     begin
          if mainform.job.state<>dsbrowse then
             mainform.job.post;
     end
     else
     begin
          if isnewjob then
               mainform.job.delete
          else
          begin
               PageControl1.ActivePage.PageIndex:=0;
               mainform.job.cancel;
               x:=0;
               if dept=0 then
               begin
                    with mainform.jobinfo do
                    begin
                         first;
                         while not eof do
                         begin
                              edit;
                              mainform.jobinfostatus.value:=jobstat[x];
                              post;
                              inc(x);
                              next;
                         end;
                    end;
               end;
          end;
     end;
     customer.close;
end;

procedure TJobInfoForm.DataSource1DataChange(Sender: TObject; Field: TField);
begin
     if mainform.job.state=dsinsert then
        PageControl1.Pages[1].TabVisible:=false;
end;

end.
