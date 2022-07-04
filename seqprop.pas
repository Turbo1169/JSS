unit Seqprop;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls, DB, Tabs,
  DBTables, DBLookup;

type
  TSeqPropForm = class(TForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    DBEdit1: TDBEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    PaintCombo: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure newjob;
    procedure modprop;
  end;

var
  SeqPropForm: TSeqPropForm;
  isnewjob:boolean;

implementation

uses main;

{$R *.DFM}

var
   tindex,tdesc:shortstring;

procedure TSeqPropForm.modprop;
var
   x:integer;
begin
     for x:=0 to paintcombo.Items.Count-1 do
     begin
          if mainform.SequencePaint.Value=PaintCombo.Items[x] then
             PaintCombo.ItemIndex:=x;
     end;
     tindex:=mainform.SequenceIndex.Value;
     tdesc:=MainForm.SequenceDescription.Value;
     showmodal;
end;

procedure TSeqPropForm.newjob;
var
   page:integer;
begin
     with mainform do
     begin
          sequence.refresh;
          sequence.last;
          if sequence.recordcount>0 then
             page:=sequencepage.value+1
          else
              page:=0;
          sequence.insert;
          sequencestatus.value:='M';
          sequenceDepartment.value:=dept;
          sequencepage.value:=page;
          paintcombo.itemindex:=0;
          sequence.post;
          isnewjob:=true;
     end;
     showmodal;
end;

procedure TSeqPropForm.FormCreate(Sender: TObject);
begin
     isnewjob:=false;
end;

procedure TSeqPropForm.FormShow(Sender: TObject);
begin
     dbedit1.setfocus;
end;

procedure TSeqPropForm.OKBtnClick(Sender: TObject);
begin
     Okbtn.setfocus;
end;

procedure TSeqPropForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
{var
   temp:shortstring;
   tpage:integer;
   jobn,jobn2:string;}
begin
     if modalresult=mrOk then
     begin
          with mainform do
          begin
            sequencepaint.value:=paintcombo.items[paintcombo.itemindex];
            Sequence.Post;
          end;
          {temp:=mainform.SequenceIndex.Value;
          tpage:=mainform.SequencePage.Value;
          with mainform do
          begin
               try
               sequence.disablecontrols;
               sequence.first;
               while not sequence.eof do
               begin
                    if (temp=SequenceIndex.value) and (sequencePage.Value<>tpage) then
                    begin
                         sequence.Locate('Page', tpage, []);
                         dbedit2.setfocus;
                         raise exception.create('Index already exists');
                    end;
                    sequence.next;
               end;
               sequence.Locate('Page', tpage, []);
               if not isnewjob then
               begin
                    try
                    Shopordlist.DisableControls;
                    shopordlist.indexfieldnames:='Job Number;Mark';
                    shopordlist.masterfields:='';
                    shopordlist.mastersource:=nil;
                    jobn2:=jobn;
                    jobn:=jobjobnumber.value;
                    jobn2:=jobn;
                    if tindex<>'' then
                       jobn:=jobn+'-'+tindex;
                    if SequenceIndex.value<>'' then
                       jobn2:=jobn2+'-'+SequenceIndex.value;
                    while (shopordlist.findkey([jobn])) and (jobn<>jobn2) do
                    begin
                         shopordlist.edit;
                         shopordlistJobNumber.value:=jobn2;
                         shopordlist.post;
                    end;
                    finally
                    shopordlist.indexfieldnames:='ListNumber';
                    shopordlist.masterfields:='ListNumber';
                    shopordlist.mastersource:=Datasource8;
                    Shopordlist.EnableControls;
                    end;
               end;
               sequence.edit;
               sequencepaint.value:=paintcombo.items[paintcombo.itemindex];
               sequence.post;
               finally
               sequence.enablecontrols;
               end;
          end;}
     end
     else
     begin
          if isnewjob then
               mainform.Sequence.delete
          else
          begin
               {mainform.sequence.edit;
               mainform.SequenceIndex.Value:=tindex;
               mainform.SequenceDescription.Value:=tdesc;}
               mainform.Sequence.Cancel;
          end;
     end;
end;

end.
