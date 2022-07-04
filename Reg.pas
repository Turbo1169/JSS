unit Reg;

interface

uses
  SysUtils, Forms, Winprocs, Classes, StdCtrls, Buttons, ExtCtrls, Controls;

type
  TRegForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Bevel1: TBevel;
    OKBtn: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RegForm: TRegForm;

implementation

{$R *.DFM}

end.
