object ImportForm: TImportForm
  Left = 363
  Top = 204
  BorderStyle = bsDialog
  Caption = 'Import Jobs'
  ClientHeight = 280
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
  object Label1: TLabel
    Left = 16
    Top = 249
    Width = 209
    Height = 13
    Caption = 'Warning: Importing will add and update jobs.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 417
    Height = 225
    Caption = 'Available Jobs'
    TabOrder = 0
    object SelectBox: TListBox
      Left = 12
      Top = 20
      Width = 393
      Height = 193
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object OKBtn: TBitBtn
    Left = 268
    Top = 244
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
    Top = 244
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    Style = bsNew
  end
end
