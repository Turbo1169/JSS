unit Batch;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls, DB, Tabs,
  DBTables, DBLookup, ADODB;

type
  batchr=record
    mark:string[6];
    weight,time,length:single;
    quantity:integer;
    description:String[14];
    chords:string[5];
  end;
  TBatchForm = class(TForm)
    Joist: TGroupBox;
    Label20: TLabel;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    TypeCombo: TComboBox;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    GroupBox1: TGroupBox;
    SelectBox: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    BatchBox: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TypeComboChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    procedure Sort(var A: array of batchr);
  public
    { Public declarations }
  end;

var
  BatchForm: TBatchForm;

implementation

uses main;

{$R *.DFM}

var
   newent:boolean;
   temp:string;
   batchlist:array[0..29] of batchr;

function ingtodec(ing:shortstring):single; external 'comlib.dll';
function dectoing(decn:single):shortstring; external 'comlib.dll';

procedure TBatchForm.Sort(var A: array of batchr);

  procedure QuickSort(var A: array of batchr; iLo, iHi: Integer);
  var
    Lo, Hi: Integer;
    T: Batchr;
    Mid: single;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := A[(Lo + Hi) div 2].length;
    repeat
      while A[Lo].length < Mid do Inc(Lo);
      while A[Hi].length > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;

begin
  QuickSort(A, 0, Batchbox.items.count-1);
end;

procedure TBatchForm.OKBtnClick(Sender: TObject);
begin
     Okbtn.setfocus;
end;

procedure TBatchForm.FormCreate(Sender: TObject);
begin
     newent:=false;
end;

procedure TBatchForm.FormShow(Sender: TObject);
var
   listn:integer;
begin
     newent:=true;
     typecombo.itemindex:=0;
     MainForm.Shoporder.Filtered:=false;
     MainForm.Shoporder.refresh;
     MainForm.shoporder.last;
     listn:=MainForm.shoporderlistnumber.AsInteger;
     try
     MainForm.shoporder.DisableControls;
     MainForm.shoporder.insert;
     MainForm.ShoporderJobNumber.Value:=mainform.SequenceJobNumber.Value;
     MainForm.ShoporderPage.Value:=MainForm.SequencePage.Value;
     inc(listn);
     MainForm.shoporderlistnumber.Value:=listn;
     MainForm.shoporderdate.value:=date;
     MainForm.shoporder.post;
     finally
     MainForm.Shoporder.Filtered:=true;
     MainForm.shoporder.EnableControls;
     end;
     MainForm.Shoporder.Locate('List Number', listn, []);
     dbedit1.setfocus;
     MainForm.BatchedJoists.Requery();
     TypeComboChange(Sender);
end;

procedure TBatchForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
   qty,x:integer;
   Tons,Time:single;
begin
     if batchform.modalresult=mrOk then
     begin
          MainForm.shoporder.edit;
          MainForm.shoporderlisttype.value:=temp;
          for x:=0 to Batchbox.items.count-1 do
          begin
               temp:=batchbox.items.strings[x];
               temp:=copy(temp,pos('[',temp)+1,length(temp)-pos('[',temp)-1);
               batchlist[x].mark:=temp;
               with mainform do
               begin
                    mainform.joists.Locate('Mark', temp, []);
                    batchlist[x].length:=ingtodec(joistsbaselength.value)+ingtodec(joiststcxl.value)+
                                ingtodec(joiststcxr.value);
                    batchlist[x].quantity:=joistsquantity.value;
                    batchlist[x].weight:=joistsweight.value;
                    batchlist[x].time:=joiststime.value;
                    batchlist[x].description:=joistsdescription.value;
                    batchlist[x].chords:=joistschords.value;
               end;
          end;
          MainForm.shoporder.post;
          sort(batchlist);
          qty:=0; tons:=0; time:=0;
          for x:=0 to Batchbox.items.count-1 do
          begin
               MainForm.ShopordList.insert;
               MainForm.ShopordListquantity.value:=batchlist[x].quantity;
               MainForm.ShopordListsort.value:=x;
               MainForm.ShopordListmark.value:=batchlist[x].mark;
               MainForm.ShopordListweight.value:=batchlist[x].weight;
               tons:=tons+batchlist[x].weight*batchlist[x].quantity/2000;
               time:=time+batchlist[x].time*batchlist[x].quantity;
               qty:=qty+batchlist[x].quantity;
               MainForm.ShopordListtime.value:=batchlist[x].time*batchlist[x].quantity;
               MainForm.ShopordListlength.value:=dectoing(batchlist[x].length);
               MainForm.ShopordListdescription.value:=batchlist[x].description;
          end;
          MainForm.ShopordList.post;
          MainForm.shoporder.edit;
          MainForm.shoporderquantity.value:=qty;
          MainForm.shopordertons.value:=tons;
          MainForm.shopordertime.value:=time;
          MainForm.shoporder.post;
     end
     else
         MainForm.shoporder.delete;
end;

procedure TBatchForm.TypeComboChange(Sender: TObject);
begin
     try
     speedbutton2.enabled:=false;
     OKbtn.enabled:=false;
     batchbox.clear;
     selectbox.items.beginupdate;
     selectbox.clear;
     with mainform do
     begin
          case typecombo.itemindex of
          0:temp:='L1';
          1:temp:='L2';
          2:temp:='LS';
          3:temp:='JG';
          end;
          joists.first;
          while not joists.eof do
          begin
               if (joistsjoisttype.value=temp) and (not BatchedJoists.Locate('Mark', joistsmark.value, [])) then
                  Selectbox.items.add(joistsdescription.value+' - ['+joistsmark.value+']');
               joists.next;
          end;
     end;
     if selectbox.items.count>0 then
        speedbutton1.enabled:=true
     else
         speedbutton1.enabled:=false;
     finally
      selectbox.items.endupdate;
     end;
end;

procedure TBatchForm.SpeedButton1Click(Sender: TObject);
var
   x:integer;
begin
     x:=0;
     selectbox.items.beginupdate;
     batchbox.items.beginupdate;
     repeat
           if (selectbox.selected[x]) and (batchbox.items.count<high(batchlist)+1) then
           begin
                Batchbox.items.add(selectbox.items.strings[x]);
                if speedbutton2.enabled=false then
                begin
                     speedbutton2.enabled:=true;
                     OKbtn.enabled:=true;
                end;
                selectbox.items.delete(x);
           end
           else
               inc(x);
     until x=selectbox.items.count;
     selectbox.items.endupdate;
     batchbox.items.endupdate;
     if (selectbox.items.count=0) or (batchbox.items.count>high(batchlist)) then
        speedbutton1.enabled:=false;
end;

procedure TBatchForm.SpeedButton2Click(Sender: TObject);
var
   x:integer;
begin
     x:=0;
     selectbox.items.beginupdate;
     batchbox.items.beginupdate;
     repeat
           if batchbox.selected[x] then
           begin
                selectbox.items.add(batchbox.items.strings[x]);
                if speedbutton1.enabled=false then
                   speedbutton1.enabled:=true;
                batchbox.items.delete(x);
           end
           else
               inc(x);
     until x=batchbox.items.count;
     selectbox.items.endupdate;
     batchbox.items.endupdate;
     if batchbox.items.count=0 then
     begin
          speedbutton2.enabled:=false;
          OKbtn.enabled:=false;
     end;
end;

end.
