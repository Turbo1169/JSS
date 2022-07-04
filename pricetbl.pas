unit Pricetbl;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs, DB,
  DBTables, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TPriceTblForm = class(TForm)
    DataSource1: TDataSource;
    OKBtn: TBitBtn;
    TabSet1: TTabControl;
    DBGrid1: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabSet1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PriceTblForm: TPriceTblForm;

implementation

{$R *.DFM}

uses main;

procedure TPriceTblForm.FormShow(Sender: TObject);
begin
     datasource1.dataset:=mainform.pricetbl;
     TabSet1Change(Sender);
     mainform.pricetbl.Filtered:=true;
end;

procedure TPriceTblForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     mainform.pricetbl.Filtered:=false;
end;

procedure TPriceTblForm.TabSet1Change(Sender: TObject);
begin
     with mainform.pricetbl do
     begin
          Filter:='[category] = '''+tabset1.tabs.strings[tabset1.tabindex]+'''';
     end;
end;


end.
