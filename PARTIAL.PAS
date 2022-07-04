unit Partial;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TPartialForm = class(TForm)
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Label2: TLabel;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label3: TLabel;
    Edit2: TEdit;
    Label1: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    ComboBox2: TComboBox;
    Edit4: TEdit;
    Label6: TLabel;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBox1: TCheckBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure RadioGroup1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Edit2Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Edit3Change(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure valdec(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure distance;
  public
    { Public declarations }
    procedure getload(var joint1,joint2:integer; var Load,load2:single; var wind:boolean);
  end;

var
  PartialForm: TPartialForm;


implementation

{$R *.DFM}

uses main,entry;

var
   jpos:string;
   ctr:integer;

function dectoing(decn:single):shortstring; external 'comlib.dll';

procedure TPartialForm.getload(var joint1,joint2:integer; var Load,load2:single; var wind:boolean);
var
   c:integer;
   found:boolean;
begin
     edit1.Text:=format('%0.2f',[load]);
     edit4.Text:=edit1.Text;
     distance;
     showmodal;
     found:=false; c:=0;
     while (c<JointList.count) and (not found) do
     begin
          jointdata:=JointList.items[c];
          if jointdata^.position=jpos then
             if dectoing(jointdata^.coordX)=combobox1.text then
                found:=true;
          inc(c);
     end;
     if found then
        joint1:=c;
     found:=false; c:=0;
     while (c<JointList.count) and (not found) do
     begin
          jointdata:=JointList.items[c];
          if jointdata^.position=jpos then
             if dectoing(jointdata^.coordX)=combobox2.text then
                found:=true;
          inc(c);
     end;
     if found then
        joint2:=c;
     load:=strtofloat(edit1.text);
     load2:=strtofloat(edit4.text);
     wind:=CheckBox1.Checked;
end;

procedure TPartialForm.distance;
var
   p,c:integer;
   mindif:single;
begin
     edit2.text:='0';
     edit3.text:='0';
     c:=0; p:=0;
     combobox1.clear;
     combobox2.clear;
     mindif:=bl;
     if RadioButton1.Checked then
     begin
        jpos:='TC';
        CheckBox1.Enabled:=true;
     end
     else
     begin
        jpos:='BC';
        checkbox1.Checked:=false;
        CheckBox1.Enabled:=false;
     end;
     while c<JointList.count do
     begin
          jointdata:=JointList.items[c];
          if jointdata^.position=jpos then
          begin
               combobox1.items.add(dectoing(jointdata^.coordX));
               combobox2.items.add(dectoing(jointdata^.coordX));
               if abs(bl/2-jointdata^.coordx)<mindif then
               begin
                    ctr:=combobox1.items.count-1;
                    mindif:=abs(bl/2-jointdata^.coordx);
               end;
               inc(p);
          end;
          inc(c);
     end;
     edit2.text:=inttostr(1);
     edit3.text:=inttostr(p);
end;

procedure TPartialForm.RadioGroup1Click(Sender: TObject);
begin
     distance;
end;

procedure TPartialForm.ComboBox1Change(Sender: TObject);
begin
     edit2.text:=inttostr(combobox1.itemindex+1);
end;

procedure TPartialForm.CancelBtnClick(Sender: TObject);
begin
     edit1.text:='0';
end;

procedure TPartialForm.ComboBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
     if odSelected in state then
        combobox1.canvas.font.color:=clwhite
     else
          if index=ctr then
             combobox1.canvas.font.color:=clred
          else
              combobox1.canvas.font.color:=clblack;
     combobox1.canvas.fillrect(rect);
     combobox1.canvas.textout(rect.left+2,rect.top+1,combobox1.items[index]);
end;

procedure TPartialForm.Edit2Change(Sender: TObject);
begin
     combobox1.itemindex:=strtoint(edit2.text)-1;
end;

procedure TPartialForm.ComboBox2Change(Sender: TObject);
begin
     try
     if (Combobox2.text<>'') and (strtofloat(edit1.text)<>0) then
        OkBtn.enabled:=true
     except
           OkBtn.enabled:=false;
     end;
     edit3.text:=inttostr(combobox2.itemindex+1);
end;

procedure TPartialForm.ComboBox2DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
     if odSelected in state then
        combobox2.canvas.font.color:=clwhite
     else
          if index=ctr then
             combobox2.canvas.font.color:=clred
          else
              combobox2.canvas.font.color:=clblack;
     combobox2.canvas.fillrect(rect);
     combobox2.canvas.textout(rect.left+2,rect.top+1,combobox2.items[index]);
end;

procedure TPartialForm.Edit3Change(Sender: TObject);
begin
     combobox2.itemindex:=strtoint(edit3.text)-1;
end;

procedure TPartialForm.RadioButton1Click(Sender: TObject);
begin
        distance;
end;

procedure TPartialForm.Edit2Exit(Sender: TObject);
begin
     if (strtoint(edit2.text)>combobox1.Items.Count) or (strtoint(edit2.text)<1)  or (strtoint(edit2.text)>=strtoint(edit3.text)) then
     begin
        edit2.SetFocus;
        raise exception.Create('Invalid panel number');
     end;
end;

procedure TPartialForm.Edit3Exit(Sender: TObject);
begin
     if (strtoint(edit3.text)>combobox2.Items.Count) or (strtoint(edit3.text)<1) or (strtoint(edit3.text)<=strtoint(edit2.text)) then
     begin
        edit3.SetFocus;
        raise exception.Create('Invalid panel number');
     end;
end;

procedure TPartialForm.valdec(Sender: TObject);
begin
     if tedit(sender).text='' then
        tedit(sender).text:='0';
     try
     tedit(sender).text:=format('%0.2f',[strtofloat(tedit(sender).text)]);
     except
           tedit(sender).setfocus;
           raise exception.create('Invalid input');
     end;
     if tedit(sender).name='Edit1' then
        Edit4.Text:=Edit1.Text;
end;

procedure TPartialForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
        cancelbtn.SetFocus;
end;

end.
