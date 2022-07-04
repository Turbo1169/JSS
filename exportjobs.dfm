object ExportJobsForm: TExportJobsForm
  Left = 666
  Top = 298
  BorderStyle = bsDialog
  Caption = 'Export Jobs'
  ClientHeight = 298
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 417
    Height = 245
    Caption = 'Available Jobs'
    TabOrder = 0
    object SelectBox: TListBox
      Left = 12
      Top = 20
      Width = 393
      Height = 213
      ItemHeight = 13
      MultiSelect = True
      TabOrder = 0
    end
  end
  object OKBtn: TBitBtn
    Left = 268
    Top = 264
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    Style = bsNew
  end
  object CancelBtn: TBitBtn
    Left = 348
    Top = 264
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    Style = bsNew
  end
  object ProgressBar1: TProgressBar
    Left = 16
    Top = 267
    Width = 150
    Height = 16
    TabOrder = 3
    Visible = False
  end
  object DeleteCheck: TCheckBox
    Left = 72
    Top = 80
    Width = 137
    Height = 17
    Caption = 'Delete Exported Jobs'
    TabOrder = 4
    Visible = False
  end
end
