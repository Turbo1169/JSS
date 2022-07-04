unit joistrep;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  quickrpt, Qrctrls, ExtCtrls, Db, DBTables;

type
  TjoistrepForm = class(TForm)
    QuickRep1: TQuickRep;
    DetailBand1: TQRBand;
    QRDBText1: TQRDBText;
    ColumnHeaderBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRLabel2: TQRLabel;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRLabel5: TQRLabel;
    QRLabel6: TQRLabel;
    QRLabel7: TQRLabel;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    QRDBText7: TQRDBText;
    QRLabel8: TQRLabel;
    QRDBText8: TQRDBText;
    QRLabel9: TQRLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  joistrepForm: TjoistrepForm;

implementation

uses Main;

{$R *.DFM}

end.
