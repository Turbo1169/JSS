unit Login;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, DBCtrls, ExtCtrls, DB, Mask, DBTables;

type
  TLoginForm = class(TForm)
    Panel1: TPanel;
    NewPass: TEdit;
    Confirm: TEdit;
    Passw: TEdit;
    BitBtn1: TBitBtn;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    UserList: TComboBox;
    Label6: TLabel;
    Image1: TImage;
    procedure OKBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure UserListChange(Sender: TObject);
    procedure NewPassChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;
  retu:string;
  derror:boolean;

implementation

uses Main;

{$R *.DFM}

procedure TLoginForm.OKBtnClick(Sender: TObject);
begin
     if userlist.visible then
     with mainform do
     begin
          //if users.findkey([userList.text]) then
          if users.locate('User',userList.text,[]) then
          if userspassword.value=uppercase(passw.text) then
             retu:=userlist.text
          else
              derror:=true;
     end
     else
     begin
          with mainform do
          begin
               users.edit;
               userspassword.value:=uppercase(newpass.text);
               users.post;
               retu:=userlist.text
          end;
     end;
end;

procedure TLoginForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     if derror then
     begin
          derror:=false;
          passw.SetFocus;
          raise exception.create('Invalid Password');
     end;
end;

procedure TLoginForm.BitBtn1Click(Sender: TObject);
begin
     if mainform.users.locate('user',userList.text,[]) then
     if mainform.userspassword.value=uppercase(passw.text) then
     begin
          label1.caption:='New Password:';
          label2.caption:='Confirmation:';
          userlist.hide;
          passw.hide;
          bitbtn1.hide;
          newpass.show;
          confirm.show;
          newpass.setfocus;
     end
     else
     begin
          passw.SetFocus;
          raise exception.create('Please Type Old Password');
     end;
end;

procedure TLoginForm.UserListChange(Sender: TObject);
begin
     if userlist.text<>'' then
     begin
        OkBtn.enabled:=true;
        bitbtn1.enabled:=true;
     end;
end;

procedure TLoginForm.NewPassChange(Sender: TObject);
begin
     if uppercase(newpass.text)=uppercase(confirm.text) then
        OkBtn.enabled:=true
     else
         OkBtn.enabled:=false;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
     if userlist.ItemIndex>=0 then
     begin
          passw.SetFocus;
          OKBtn.Enabled:=true;
          bitbtn1.Enabled:=true;
     end;
end;

end.
