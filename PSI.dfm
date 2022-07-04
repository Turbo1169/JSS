object PSIForm: TPSIForm
  Left = 259
  Top = 153
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'PSI Joists'
  ClientHeight = 320
  ClientWidth = 503
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 503
    Height = 279
    TabStop = False
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 279
    Width = 503
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object OKBtn: TBitBtn
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Import'
      Default = True
      ModalResult = 1
      TabOrder = 0
      Style = bsNew
    end
    object CancelBtn: TBitBtn
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      Style = bsNew
    end
    object ProgressBar1: TProgressBar
      Left = 180
      Top = 12
      Width = 150
      Height = 16
      TabOrder = 2
      Visible = False
    end
  end
end
