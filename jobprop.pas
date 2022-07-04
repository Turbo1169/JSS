unit Jobprop;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls, DB, DBTables, DBLookup, ComCtrls,
  variants;

type
  TJobPropForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label6: TLabel;
    Label24: TLabel;
    DBEdit2: TDBEdit;
    Commission: TCheckBox;
    PaintCombo: TComboBox;
    GroupBox5: TGroupBox;
    Label4: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    GroupBox4: TGroupBox;
    Label22: TLabel;
    Label1: TLabel;
    DBEdit5: TDBEdit;
    DBEdit8: TDBEdit;
    GroupBox6: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label23: TLabel;
    Label25: TLabel;
    ElPasoCheck: TCheckBox;
    JobSiteCheck: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label8: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    HolesCheck: TCheckBox;
    PipeCheck: TCheckBox;
    SpliceCheck: TCheckBox;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit7: TEdit;
    WoodCheck: TCheckBox;
    DBEdit14: TDBEdit;
    HolesCombo: TComboBox;
    PipeCombo: TComboBox;
    GroupBox7: TGroupBox;
    BitBtn1: TBitBtn;
    QNotes: TDBMemo;
    AddCond: TComboBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    DBText4: TDBText;
    Label5: TLabel;
    DateTimePicker1: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure HolesCheckClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PipeCheckClick(Sender: TObject);
    procedure ElPasoCheckClick(Sender: TObject);
    procedure JobSiteCheckClick(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure valinteger(Sender: TObject);
    procedure HolesComboExit(Sender: TObject);
    procedure PipeComboExit(Sender: TObject);
  private
    { Private declarations }
    procedure fillpaint;
  public
    { Public declarations }
    procedure newjob;
    procedure recalcquote;
  end;

var
  JobPropForm: TJobPropForm;
  isnewjob:boolean;

implementation

uses main;

{$R *.DFM}

procedure TJobPropForm.newjob;
var
   page:integer;
begin
     MainForm.JobInfo.DisableControls;
     try
     MainForm.JobInfo.Last;
     if MainForm.JobInfo.recordcount>0 then
        page:=MainForm.JobInfopage.value+1
     else
         page:=0;
     with mainform do
     begin
         JobInfo.insert;
         JobInfopage.value:=page;
         JobInfodatequoted.value:=date;
         pricetbl.Locate('category;item',vararrayof(['Labor',3]),[]);
         JobInfoprofitLH.value:=mainform.pricetblunitprice.value;
         JobInfooverweight.value:=7;
         JobInfodetail.value:=4;
         JobInfoapproval.value:=2;
         JobInfofabrication.value:=4;
         JobInfolist.value:=6;
         JobInfo.post;
         JobInfo.edit;
     end;
     caption:='New Quote';
     isnewjob:=true;
     paintcombo.itemindex:=1;
     SpliceCheck.checked:=true;
     ElPasoCheck.checked:=true;
     JobsiteCheck.checked:=true;
     finally
       MainForm.JobInfo.EnableControls;
     end;
     showmodal;
end;

procedure TJobPropForm.FormCreate(Sender: TObject);
begin
     PageControl1.ActivePageIndex:=0;   
     isnewjob:=false;
     if fileexists('notes.txt') then
        AddCond.Items.LoadFromFile('notes.txt');
     fillpaint;
end;

procedure TJobPropForm.FormShow(Sender: TObject);
begin
     if MainForm.JobInfoValidUntil.Value>0 then
           DateTimePicker1.Date:=MainForm.JobInfoValidUntil.Value
     else
           DateTimePicker1.Date:=MainForm.JobInfoDateQuoted.Value+30;
     if not isnewjob then
     begin
          with mainform do
          begin
                JobMisc.Filtered:=false;
                {JobMisc.Close;
                JobMisc.DataSet.CommandText:='select * from jobmisc where "job number"=:''job number'' and page=:page';
                JobMisc.open;}
          end;
          if MainForm.JobInfocommission.value>0 then
             commission.checked:=true;
          if mainform.JobMisc.Locate('Job Number;Page;Category',vararrayof([MainForm.JobInfojobnumber.value,MainForm.JobInfopage.value,'Paint']),[]) then
             PaintCombo.itemindex:=mainform.jobmiscitem.value
          else
              PaintCombo.itemindex:=0;
          if mainform.JobMisc.Locate('Category;Item',vararrayof(['Misc',1]),[]) then
          begin
               HolesCombo.Text:=format('%0.2f',[mainform.jobmiscvalue.value]);
               HolesCheck.checked:=true;
          end;
          if mainform.JobMisc.Locate('Category;Item',vararrayof(['Misc',3]),[]) then
          begin
               PipeCombo.Text:=format('%0.2f',[mainform.jobmiscvalue.value]);
               PipeCheck.checked:=true;
          end;
          if mainform.JobMisc.Locate('Category;Item',vararrayof(['Misc',4]),[]) then
               SpliceCheck.checked:=true;
          if mainform.JobMisc.Locate('Category;Item',vararrayof(['Misc',7]),[]) then
               WoodCheck.checked:=true;
          if mainform.JobMisc.Locate('Category;Item',vararrayof(['Misc',2]),[]) then
          begin
               edit3.text:=inttostr(mainform.jobmiscquantity.value);
          end;
          if mainform.JobMisc.Locate('Category;Item',vararrayof(['Misc',6]),[]) then
          begin
               edit4.text:=inttostr(mainform.jobmiscquantity.value);
          end;
          if mainform.JobMisc.Locate('Category;Item',vararrayof(['Misc',5]),[]) then
          begin
               edit7.text:=inttostr(mainform.jobmiscquantity.value);
          end;
          if mainform.JobMisc.Locate('Category;Item',vararrayof(['Fees',1]),[]) then
          begin
               ElPasoCheck.checked:=true;
               edit1.text:=format('%0.2f',[mainform.jobmiscvalue.value]);
          end;
          if mainform.JobMisc.Locate('Category;Item',vararrayof(['Freight',1]),[]) then
          begin
               JobSiteCheck.checked:=true;
               edit2.text:=format('%0.2f',[mainform.jobmiscvalue.value]);
               mainform.JobMisc.Locate('Category;Item',vararrayof(['Freight',2]),[]);
               edit5.text:=format('%0.0f',[mainform.jobmiscvalue.value]);
               mainform.JobMisc.Locate('Category;Item',vararrayof(['Freight',3]),[]);
               edit6.text:=format('%0.0f',[mainform.jobmiscvalue.value]);
          end;
          mainform.doextras(mainform.extrastabs.TabIndex);
     end;
     HolesCheckClick(Sender);
     PipeCheckClick(Sender);
     dbedit2.setfocus;
end;

procedure TJobPropForm.OKBtnClick(Sender: TObject);
begin
     Okbtn.setfocus;
end;

procedure TJobPropForm.fillpaint;
begin
     with mainform.pricetbl do
     begin
          Filter:='category = ''Paint''';
          Filtered:=true;
          first;
          paintcombo.items.add('No Paint');
          while not eof do
          begin
               paintcombo.items.add(mainform.pricetbldescription.value);
               next;
          end;
          Filtered:=false;
     end;
end;

procedure TJobPropForm.HolesCheckClick(Sender: TObject);
begin
     if Holescheck.checked then
          HolesCombo.enabled:=true
     else
     begin
         HolesCombo.enabled:=false;
         holescombo.text:='12.00';
     end;
end;

procedure TJobPropForm.recalcquote;
begin
     mainform.pricetbl.Locate('Category;Item',vararrayof(['Labor',1]),[]);
     mainform.JobInfosslinehour.value:=mainform.pricetblunitprice.value;
     mainform.pricetbl.Locate('Category;Item',vararrayof(['Labor',2]),[]);
     mainform.JobInfolslinehour.value:=mainform.pricetblunitprice.value;
     mainform.pricetbl.Locate('Category;Item',vararrayof(['Labor',4]),[]);
     mainform.JobInfoHBLaborCost.value:=mainform.pricetblunitprice.value;
     mainform.pricetbl.Locate('Category;Item',vararrayof(['Labor',5]),[]);
     mainform.JobInfoXBLaborCost.value:=mainform.pricetblunitprice.value;
     mainform.pricetbl.Locate('Category;Item',vararrayof(['Labor',6]),[]);
     mainform.JobInfoKBLaborCost.value:=mainform.pricetblunitprice.value;
     mainform.pricetbl.Locate('Category;Item',vararrayof(['Labor',7]),[]);
     mainform.JobInfoJSLaborCost.value:=mainform.pricetblunitprice.value;
     mainform.JobInfostatus.value:='M';
     mainform.JobInfo.post;
end;

procedure TJobPropForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   x:integer;
begin
     if modalresult=mrOk then
     begin
          with mainform do
          begin
                JobInfoValidUntil.Value:=DateTimePicker1.Date;
                JobMisc.DisableControls;
                JobMisc.Filtered:=false;
          end;
          if commission.checked then
            MainForm.JobInfocommission.value:=100
         else
             MainForm.JobInfocommission.value:=0;
          recalcquote;
          while mainform.jobmisc.recordcount>0 do
                mainform.jobmisc.delete;
          if paintcombo.itemindex>0 then
          begin
               mainform.jobmisc.insert;
               mainform.jobmisccategory.value:='Paint';
               mainform.jobmiscitem.value:=paintcombo.itemindex;
               if mainform.pricetbl.Locate('Category;Item',vararrayof(['Paint',paintcombo.itemindex]),[]) then
                  mainform.JobMiscunitprice.value:=mainform.pricetblunitprice.value;
          end;
          if holescheck.checked then
          begin
               mainform.jobmisc.insert;
               mainform.jobmisccategory.value:='Misc';
               mainform.jobmiscitem.value:=1;
               mainform.jobmiscvalue.value:=strtofloat(HolesCombo.Text);
               if mainform.pricetbl.Locate('Category;Item',vararrayof(['Misc',1]),[]) then
                  mainform.jobmiscunitprice.value:=mainform.pricetblunitprice.value;
          end;
          if pipecheck.checked then
          begin
               mainform.jobmisc.insert;
               mainform.jobmisccategory.value:='Misc';
               mainform.jobmiscitem.value:=3;
               mainform.jobmiscvalue.value:=strtofloat(PipeCombo.Text);
               if mainform.pricetbl.Locate('Category;Item',vararrayof(['Misc',3]),[]) then
                  mainform.jobmiscunitprice.value:=mainform.pricetblunitprice.value;
          end;
          if Splicecheck.checked then
          begin
               mainform.jobmisc.insert;
               mainform.jobmisccategory.value:='Misc';
               mainform.jobmiscitem.value:=4;
               if mainform.pricetbl.Locate('Category;Item',vararrayof(['Misc',4]),[]) then
                  mainform.jobmiscunitprice.value:=mainform.pricetblunitprice.value;
          end;
          if Woodcheck.checked then
          begin
               mainform.jobmisc.insert;
               mainform.jobmisccategory.value:='Misc';
               mainform.jobmiscitem.value:=7;
               if mainform.pricetbl.Locate('Category;Item',vararrayof(['Misc',7]),[]) then
               begin
                  mainform.jobmiscunitprice.value:=mainform.pricetblunitprice.value;
                  mainform.jobmiscvalue.value:=30;
               end;
          end;
          if strtoint(edit3.text)>0 then
          begin
               mainform.jobmisc.insert;
               mainform.jobmisccategory.value:='Misc';
               mainform.jobmiscitem.value:=2;
               if mainform.pricetbl.Locate('Category;Item',vararrayof(['Misc',2]),[]) then
               begin
                  mainform.jobmiscunitprice.value:=mainform.pricetblunitprice.value;
                  mainform.jobmiscquantity.value:=strtoint(edit3.text);
               end;
          end;
          if strtoint(edit4.text)>0 then
          begin
               mainform.jobmisc.insert;
               mainform.jobmisccategory.value:='Misc';
               mainform.jobmiscitem.value:=6;
               if mainform.pricetbl.Locate('Category;Item',vararrayof(['Misc',6]),[]) then
               begin
                  mainform.jobmiscunitprice.value:=mainform.pricetblunitprice.value;
                  mainform.jobmiscquantity.value:=strtoint(edit4.text);
               end;
          end;
          if strtoint(edit7.text)>0 then
          begin
               mainform.jobmisc.insert;
               mainform.jobmisccategory.value:='Misc';
               mainform.jobmiscitem.value:=5;
               if mainform.pricetbl.Locate('Category;Item',vararrayof(['Misc',5]),[]) then
               begin
                  mainform.jobmiscunitprice.value:=mainform.pricetblunitprice.value;
                  mainform.jobmiscquantity.value:=strtoint(edit7.text);
               end;
          end;
          if ElPasocheck.checked then
          begin
               for x:=1 to 3 do
               begin
                    mainform.jobmisc.insert;
                    mainform.jobmisccategory.value:='Fees';
                    mainform.jobmiscitem.value:=x;
                    if mainform.pricetbl.Locate('Category;Item',vararrayof(['Fees',x]),[]) then
                    begin
                         mainform.jobmiscunitprice.value:=mainform.pricetblunitprice.value;
                         mainform.jobmiscvalue.value:=strtofloat(edit1.text);
                    end;
               end;
               mainform.jobmisc.insert;
               mainform.jobmisccategory.value:='Fees';
               if woodcheck.Checked then
                   mainform.pricetbl.Locate('Category;Item',vararrayof(['Fees',5]),[])
               else
                   mainform.pricetbl.Locate('Category;Item',vararrayof(['Fees',4]),[]);
               mainform.jobmiscunitprice.value:=mainform.pricetblunitprice.value;
               mainform.jobmiscvalue.value:=strtofloat(edit1.text);
               mainform.jobmiscitem.value:=mainform.pricetblitem.value;
               {if (JobSiteCheck.Checked) and (strtoint(edit6.text)>0) then
               begin
                    mainform.pricetbl.findkey(['Fees',6]);
                    jobmisc.insert;
                    jobmisccategory.value:='Fees';
                    jobmiscitem.value:=6;
                    jobmiscunitprice.value:=mainform.pricetblunitprice.value;
                    jobmiscvalue.value:=strtofloat(edit1.text);
                    jobmiscquantity.value:=strtoint(edit6.text);
               end;}
          end;
          if Jobsitecheck.checked then
          begin
               for x:=1 to 3 do
               begin
                    mainform.jobmisc.insert;
                    mainform.jobmisccategory.value:='Freight';
                    mainform.jobmiscitem.value:=x;
                    if mainform.pricetbl.Locate('Category;Item',vararrayof(['Freight',x]),[]) then
                    begin
                       mainform.jobmiscunitprice.value:=mainform.pricetblunitprice.value;
                       case x of
                       1:mainform.jobmiscvalue.value:=strtofloat(edit2.text);
                       2:mainform.jobmiscvalue.value:=strtoint(edit5.text);
                       3:mainform.jobmiscvalue.value:=strtoint(edit6.text);
                       end;
                    end;
               end;
          end;
          if mainform.jobmisc.state<>dsbrowse then
             mainform.jobmisc.post;
          //mainform.JobMisc.ApplyUpdates(0);
          mainform.doextras(mainform.extrastabs.TabIndex);
          MainForm.JobMisc.EnableControls;
     end
     else
     begin
          if isnewjob then
               MainForm.JobInfo.delete
          else
               MainForm.JobInfo.cancel;
     end;
end;

procedure TJobPropForm.PipeCheckClick(Sender: TObject);
begin
     if pipecheck.checked then
          pipeCombo.enabled:=true
     else
     begin
         pipeCombo.enabled:=false;
         pipecombo.Text:='12.00';
     end;
end;

procedure TJobPropForm.ElPasoCheckClick(Sender: TObject);
begin
     if ElPasoCheck.checked then
     begin
          edit1.text:='15.00';
          edit1.enabled:=true;
     end
     else
     begin
         edit1.text:='';
         edit1.enabled:=false;
     end;
end;

procedure TJobPropForm.JobSiteCheckClick(Sender: TObject);
begin
     if JobSiteCheck.checked then
     begin
          edit2.text:='15.00';
          edit2.enabled:=true;
          edit5.text:='0';
          edit6.text:='0';
          edit5.enabled:=true;
          edit6.enabled:=true;
     end
     else
     begin
         edit2.text:='';
         edit2.enabled:=false;
         edit5.text:='';
         edit6.text:='';
         edit5.enabled:=false;
         edit6.enabled:=false;
     end;
end;

procedure TJobPropForm.Edit1Exit(Sender: TObject);
begin
     try
     edit1.text:=format('%0.2f',[strtofloat(edit1.text)]);
     except
           edit1.setfocus;
           raise exception.create('Invalid input');
     end;
     if strtofloat(edit1.text)<=0 then
     begin
          edit1.setfocus;
          raise exception.create('Value must be greater than 0');
     end;
end;

procedure TJobPropForm.Edit2Exit(Sender: TObject);
begin
     try
     edit2.text:=format('%0.2f',[strtofloat(edit2.text)]);
     except
           edit2.setfocus;
           raise exception.create('Invalid input');
     end;
     if strtofloat(edit2.text)<=0 then
     begin
          edit2.setfocus;
          raise exception.create('Value must be greater than 0');
     end;
end;

procedure TJobPropForm.BitBtn1Click(Sender: TObject);
begin
     qnotes.lines.add('* '+addcond.text);
end;

procedure TJobPropForm.valinteger(Sender: TObject);
begin
     try
     if tedit(sender).text='' then tedit(sender).text:='0';
     tedit(sender).text:=inttostr(strtoint(tedit(sender).text));
     except
           tedit(sender).setfocus;
           raise exception.create('Invalid input');
     end;
end;

procedure TJobPropForm.HolesComboExit(Sender: TObject);
begin
     try
     HolesCombo.text:=format('%0.2f',[strtofloat(HolesCombo.text)]);
     except
           HolesCombo.setfocus;
           raise exception.create('Invalid input');
     end;
     if strtofloat(HolesCombo.text)<=0 then
     begin
          HolesCombo.setfocus;
          raise exception.create('Value must be greater than 0');
     end;
end;

procedure TJobPropForm.PipeComboExit(Sender: TObject);
begin
     try
     PipeCombo.text:=format('%0.2f',[strtofloat(PipeCombo.text)]);
     except
           PipeCombo.setfocus;
           raise exception.create('Invalid input');
     end;
     if strtofloat(PipeCombo.text)<=0 then
     begin
          PipeCombo.setfocus;
          raise exception.create('Value must be greater than 0');
     end;
end;

end.
