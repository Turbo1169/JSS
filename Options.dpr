program Options;

uses
  Forms,
  OptMain in 'OptMain.pas' {OptMainForm},
  Price in 'Price.pas' {PriceForm},
  angles in 'angles.pas' {AnglesForm},
  rounds in 'rounds.pas' {RoundsForm},
  password in 'password.pas' {PasswordForm},
  SupPassw in 'SupPassw.pas' {SupPasswForm},
  NewPassw in 'NewPassw.pas' {NewPasswForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'System Options';
  Application.CreateForm(TOptMainForm, OptMainForm);
  Application.Run;
end.
