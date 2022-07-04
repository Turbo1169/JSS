object GPanelForm: TGPanelForm
  Left = 442
  Top = 362
  BorderStyle = bsDialog
  Caption = 'Girder Panel'
  ClientHeight = 126
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 297
    Height = 73
    Caption = 'Layout'
    TabOrder = 0
    object Label102: TLabel
      Left = 12
      Top = 20
      Width = 73
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Panel A (ft)'
    end
    object Label103: TLabel
      Left = 88
      Top = 20
      Width = 41
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = '#'
    end
    object Label104: TLabel
      Left = 132
      Top = 20
      Width = 73
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'N Panels (ft)'
    end
    object Label105: TLabel
      Left = 208
      Top = 20
      Width = 73
      Height = 13
      Alignment = taCenter
      AutoSize = False
      Caption = 'Panel B (ft)'
    end
    object Edit15: TEdit
      Left = 12
      Top = 36
      Width = 73
      Height = 21
      TabOrder = 0
      OnExit = Edit15Exit
    end
    object Edit16: TEdit
      Left = 88
      Top = 36
      Width = 41
      Height = 21
      Enabled = False
      TabOrder = 1
    end
    object Edit17: TEdit
      Left = 132
      Top = 36
      Width = 73
      Height = 21
      TabOrder = 2
      OnExit = Edit15Exit
    end
    object Edit18: TEdit
      Left = 208
      Top = 36
      Width = 73
      Height = 21
      TabOrder = 3
      OnExit = Edit15Exit
    end
  end
  object OKBtn: TBitBtn
    Left = 150
    Top = 92
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    Style = bsNew
  end
  object CancelBtn: TBitBtn
    Left = 230
    Top = 92
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    Style = bsNew
  end
end
