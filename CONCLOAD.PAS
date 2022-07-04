unit Concload;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TConcLoadForm = class(TForm)
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label2: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label3: TLabel;
    WindCheck: TCheckBox;
    VCBCheck: TCheckBox;
    Label1: TLabel;
    Label4: TLabel;
    ComboBox1: TComboBox;
    procedure valdec(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Exit(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    { Private declarations }
    procedure distance;
  public
    { Public declarations }
    procedure getload(var Chord:string; var Dist,Load:single; var vcb,w:boolean);
  end;

var
  ConcLoadForm: TConcLoadForm;


implementation

{$R *.DFM}

uses main,entry;

var
   jpos:string;
   ctr:integer;

function dectoing(decn:single):shortstring; external 'comlib.dll';
function ingtodec(ing:shortstring):single; external 'comlib.dll';

procedure TConcLoadForm.distance;
var
   c:integer;
   mindif:single;
begin
     c:=0;
     combobox1.clear;
     mindif:=bl;
     if RadioGroup1.ItemIndex=0 then
     begin
        jpos:='TC';
     end
     else
     begin
        jpos:='BC';
     end;
     while c<JointList.count do
     begin
          jointdata:=JointList.items[c];
          if jointdata^.position=jpos then
          begin
               combobox1.items.add(dectoing(jointdata^.coordX));
               if abs(bl/2-jointdata^.coordx)<mindif then
               begin
                    ctr:=combobox1.items.count-1;
                    mindif:=abs(bl/2-jointdata^.coordx);
               end;
          end;
          inc(c);
     end;
     combobox1.text:=dectoing(bl/2);
end;

procedure TConcLoadForm.getload(var Chord:string; var Dist,Load:single; var vcb,w:boolean);
begin
     distance;
     showmodal;
     if RadioGroup1.ItemIndex=0 then
        chord:='TC'
     else
        chord:='BC';
     Dist:=ingtodec(combobox1.text);
     load:=strtofloat(edit1.text);
     w:=windcheck.checked;
     vcb:=VCBCheck.Checked;
end;

procedure TConcLoadForm.valdec(Sender: TObject);
begin
     if tedit(sender).text='' then
        tedit(sender).text:='0';
     try
     tedit(sender).text:=format('%0.2f',[strtofloat(tedit(sender).text)]);
     except
           tedit(sender).setfocus;
           raise exception.create('Invalid input');
     end;
end;

procedure TConcLoadForm.FormShow(Sender: TObject);
begin
        combobox1.SetFocus;
end;

procedure TConcLoadForm.ComboBox1Exit(Sender: TObject);
var
   temp:string;
begin
     temp:=tcombobox(sender).text;
     if temp<>dectoing(ingtodec(temp)) then
     begin
          if temp='' then
             tcombobox(sender).text:='0-0'
          else
          begin
               tcombobox(sender).text:=dectoing(ingtodec(temp));
               if tcombobox(sender).text='0-0' then
               begin
                    tcombobox(sender).text:=temp;
                    tcombobox(sender).setfocus;
                    raise exception.create('Invalid input in field');
               end;
          end;
     end;
end;

procedure TConcLoadForm.RadioGroup1Click(Sender: TObject);
begin
        distance;
end;

end.
