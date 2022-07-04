unit Tcpanel;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons;

type
  TTCPanelForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    OKBtn: TBitBtn;
    CancelBtn: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TCPanelForm: TTCPanelForm;

implementation

{$R *.DFM}

end.
