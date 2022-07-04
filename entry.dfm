object EntryForm: TEntryForm
  Left = 574
  Top = 267
  HelpContext = 1
  BorderStyle = bsDialog
  Caption = 'Joist Properties'
  ClientHeight = 324
  ClientWidth = 481
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 4
    Top = 4
    Width = 473
    Height = 281
    ActivePage = TabSheet3
    TabOrder = 0
    OnChanging = PageControl1Changing
    object TabSheet1: TTabSheet
      Caption = 'General'
      object Joist: TGroupBox
        Left = 8
        Top = 8
        Width = 449
        Height = 117
        Caption = 'Joist'
        TabOrder = 0
        object Label2: TLabel
          Left = 12
          Top = 20
          Width = 27
          Height = 13
          Caption = 'Mark:'
        end
        object Label1: TLabel
          Left = 12
          Top = 44
          Width = 56
          Height = 13
          Caption = 'Description:'
        end
        object Label20: TLabel
          Left = 252
          Top = 44
          Width = 63
          Height = 13
          Caption = 'Base Length:'
        end
        object Label4: TLabel
          Left = 252
          Top = 20
          Width = 42
          Height = 13
          Caption = 'Quantity:'
        end
        object Label18: TLabel
          Left = 252
          Top = 68
          Width = 79
          Height = 13
          Caption = 'Working Length:'
        end
        object WorkLength: TLabel
          Left = 348
          Top = 68
          Width = 59
          Height = 13
          Caption = 'WorkLength'
        end
        object Label27: TLabel
          Left = 425
          Top = 44
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label40: TLabel
          Left = 425
          Top = 68
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label50: TLabel
          Left = 193
          Top = 92
          Width = 8
          Height = 13
          Caption = 'in'
        end
        object Label86: TLabel
          Left = 252
          Top = 92
          Width = 52
          Height = 13
          Caption = 'Tons/L.H.:'
        end
        object DBEdit2: TDBEdit
          Left = 92
          Top = 16
          Width = 45
          Height = 21
          CharCase = ecUpperCase
          DataField = 'Mark'
          DataSource = MainForm.DataSource2
          TabOrder = 0
        end
        object DBEdit1: TDBEdit
          Left = 92
          Top = 40
          Width = 93
          Height = 21
          CharCase = ecUpperCase
          DataField = 'Description'
          DataSource = MainForm.DataSource2
          TabOrder = 2
        end
        object DBEdit16: TDBEdit
          Left = 344
          Top = 40
          Width = 77
          Height = 21
          Hint = 'Feet|'
          DataField = 'Base Length'
          DataSource = MainForm.DataSource2
          TabOrder = 3
          OnExit = valdectoing
        end
        object DBEdit22: TDBEdit
          Left = 344
          Top = 16
          Width = 45
          Height = 21
          DataField = 'Quantity'
          DataSource = MainForm.DataSource2
          TabOrder = 1
        end
        object brgspc: TEdit
          Left = 136
          Top = 89
          Width = 50
          Height = 21
          Enabled = False
          TabOrder = 5
          Text = '0.00'
          OnExit = brgspcExit
        end
        object brgsup: TCheckBox
          Left = 12
          Top = 91
          Width = 113
          Height = 17
          TabStop = False
          Caption = 'TC Bridging Support'
          TabOrder = 4
          OnClick = brgsupClick
        end
        object TonsLH: TEdit
          Left = 344
          Top = 89
          Width = 45
          Height = 21
          TabOrder = 6
          Text = '0.00'
        end
      end
      object Shape: TDBRadioGroup
        Left = 8
        Top = 128
        Width = 129
        Height = 117
        Caption = 'Shape'
        DataField = 'Shape'
        DataSource = MainForm.DataSource2
        Items.Strings = (
          'Parallel Chords'
          'Single Pitch'
          'Double Pitch'
          'Scissor')
        ParentBackground = True
        TabOrder = 1
        Values.Strings = (
          'P'
          'S'
          'D'
          'T')
        OnClick = ShapeClick
      end
      object GroupBox2: TGroupBox
        Left = 144
        Top = 128
        Width = 313
        Height = 117
        Caption = 'Dimensions'
        TabOrder = 2
        object Label8: TLabel
          Left = 12
          Top = 20
          Width = 54
          Height = 13
          Caption = 'Ridge Line:'
        end
        object Label32: TLabel
          Left = 12
          Top = 44
          Width = 48
          Height = 13
          Caption = 'Depth LE:'
        end
        object Label33: TLabel
          Left = 176
          Top = 44
          Width = 50
          Height = 13
          Caption = 'Depth RE:'
        end
        object Label19: TLabel
          Left = 12
          Top = 68
          Width = 61
          Height = 13
          Caption = 'Scissor Rise:'
        end
        object Label51: TLabel
          Left = 136
          Top = 44
          Width = 8
          Height = 13
          Caption = 'in'
        end
        object Label52: TLabel
          Left = 288
          Top = 44
          Width = 8
          Height = 13
          Caption = 'in'
        end
        object Label53: TLabel
          Left = 136
          Top = 68
          Width = 8
          Height = 13
          Caption = 'in'
        end
        object Label74: TLabel
          Left = 172
          Top = 20
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object DBEdit14: TDBEdit
          Left = 80
          Top = 40
          Width = 50
          Height = 21
          DataField = 'Depth LE'
          DataSource = MainForm.DataSource2
          Enabled = False
          TabOrder = 1
        end
        object DBEdit15: TDBEdit
          Left = 232
          Top = 40
          Width = 50
          Height = 21
          DataField = 'Depth RE'
          DataSource = MainForm.DataSource2
          Enabled = False
          TabOrder = 2
        end
        object DBEdit23: TDBEdit
          Left = 80
          Top = 64
          Width = 50
          Height = 21
          DataField = 'Scissor Add'
          DataSource = MainForm.DataSource2
          Enabled = False
          TabOrder = 3
        end
        object DBComboBox1: TDBComboBox
          Left = 80
          Top = 15
          Width = 89
          Height = 22
          Style = csOwnerDrawFixed
          DataField = 'Ridge Position'
          DataSource = MainForm.DataSource2
          Enabled = False
          ItemHeight = 16
          TabOrder = 0
          OnDrawItem = DBComboBox1DrawItem
        end
        object ConsCheck: TDBCheckBox
          Left = 12
          Top = 91
          Width = 213
          Height = 17
          TabStop = False
          Caption = 'Consolidate Left and Right Loads'
          DataField = 'Consolidate'
          DataSource = MainForm.DataSource2
          TabOrder = 4
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Geometry'
      object GroupBox6: TGroupBox
        Left = 8
        Top = 8
        Width = 449
        Height = 117
        Caption = 'Panels'
        TabOrder = 0
        object Label31: TLabel
          Left = 16
          Top = 64
          Width = 83
          Height = 13
          Caption = 'BC Panel Length:'
        end
        object Label37: TLabel
          Left = 16
          Top = 88
          Width = 74
          Height = 13
          Caption = '# of BC Panels:'
        end
        object Label54: TLabel
          Left = 196
          Top = 64
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object PanelGrid: TStringGrid
          Left = 228
          Top = 18
          Width = 209
          Height = 86
          ColCount = 2
          DefaultRowHeight = 16
          Enabled = False
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          TabOrder = 2
          OnDblClick = PanelGridDblClick
          RowHeights = (
            16
            16)
        end
        object PanelCheck: TCheckBox
          Left = 16
          Top = 20
          Width = 113
          Height = 17
          TabStop = False
          Caption = 'Variable TC Panels'
          TabOrder = 0
          OnClick = PanelCheckClick
        end
        object DBEdit31: TDBEdit
          Left = 112
          Top = 62
          Width = 77
          Height = 21
          DataField = 'BC Panel'
          DataSource = MainForm.DataSource2
          TabOrder = 3
          OnExit = valdectoing
        end
        object DBEdit35: TDBEdit
          Left = 112
          Top = 86
          Width = 50
          Height = 21
          DataField = 'BCP'
          DataSource = MainForm.DataSource2
          TabOrder = 4
        end
        object Button1: TButton
          Left = 140
          Top = 20
          Width = 79
          Height = 25
          Caption = 'Girder Panel'
          TabOrder = 1
          TabStop = False
          OnClick = Button1Click
        end
      end
      object LeftEnd: TGroupBox
        Left = 8
        Top = 128
        Width = 221
        Height = 117
        Caption = 'Left End'
        TabOrder = 1
        object Label7: TLabel
          Left = 12
          Top = 20
          Width = 47
          Height = 13
          Caption = 'BC Panel:'
        end
        object Label11: TLabel
          Left = 12
          Top = 44
          Width = 47
          Height = 13
          Caption = 'TC Panel:'
        end
        object Label12: TLabel
          Left = 12
          Top = 68
          Width = 44
          Height = 13
          Caption = 'First Half:'
        end
        object Label13: TLabel
          Left = 12
          Top = 92
          Width = 67
          Height = 13
          Caption = 'First Diagonal:'
        end
        object DBText1: TDBText
          Left = 118
          Top = 68
          Width = 77
          Height = 17
          DataField = 'firsthalfle'
          DataSource = MainForm.DataSource2
        end
        object Label55: TLabel
          Left = 200
          Top = 20
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label56: TLabel
          Left = 200
          Top = 44
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label57: TLabel
          Left = 200
          Top = 92
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label61: TLabel
          Left = 200
          Top = 68
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object DBEdit6: TDBEdit
          Left = 116
          Top = 16
          Width = 77
          Height = 21
          DataField = 'BC Panels LE'
          DataSource = MainForm.DataSource2
          TabOrder = 0
          OnExit = valdectoing
        end
        object DBEdit8: TDBEdit
          Left = 116
          Top = 41
          Width = 77
          Height = 21
          DataField = 'TC Panels LE'
          DataSource = MainForm.DataSource2
          TabOrder = 1
          OnExit = valdectoing
        end
        object DBEdit12: TDBEdit
          Left = 116
          Top = 88
          Width = 77
          Height = 21
          DataField = 'First Diag LE'
          DataSource = MainForm.DataSource2
          TabOrder = 2
          OnExit = valdectoing
        end
      end
      object RightEnd: TGroupBox
        Left = 236
        Top = 128
        Width = 221
        Height = 117
        Caption = 'Right End'
        TabOrder = 2
        object Label14: TLabel
          Left = 12
          Top = 20
          Width = 47
          Height = 13
          Caption = 'BC Panel:'
        end
        object Label15: TLabel
          Left = 12
          Top = 44
          Width = 47
          Height = 13
          Caption = 'TC Panel:'
        end
        object Label16: TLabel
          Left = 12
          Top = 68
          Width = 44
          Height = 13
          Caption = 'First Half:'
        end
        object Label17: TLabel
          Left = 12
          Top = 92
          Width = 67
          Height = 13
          Caption = 'First Diagonal:'
        end
        object DBText2: TDBText
          Left = 118
          Top = 68
          Width = 77
          Height = 17
          DataField = 'firsthalfre'
          DataSource = MainForm.DataSource2
        end
        object Label58: TLabel
          Left = 200
          Top = 20
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label59: TLabel
          Left = 200
          Top = 44
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label60: TLabel
          Left = 200
          Top = 92
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label62: TLabel
          Left = 200
          Top = 68
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object DBEdit7: TDBEdit
          Left = 116
          Top = 16
          Width = 77
          Height = 21
          DataField = 'BC Panels RE'
          DataSource = MainForm.DataSource2
          TabOrder = 0
          OnExit = valdectoing
        end
        object DBEdit9: TDBEdit
          Left = 116
          Top = 40
          Width = 77
          Height = 21
          DataField = 'TC Panels RE'
          DataSource = MainForm.DataSource2
          TabOrder = 1
          OnExit = valdectoing
        end
        object DBEdit13: TDBEdit
          Left = 116
          Top = 88
          Width = 77
          Height = 21
          DataField = 'First Diag RE'
          DataSource = MainForm.DataSource2
          TabOrder = 2
          OnExit = valdectoing
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Additional Loads'
      object Concentrated: TGroupBox
        Left = 8
        Top = 8
        Width = 449
        Height = 141
        Caption = 'Concentrated'
        TabOrder = 0
        object Label38: TLabel
          Left = 16
          Top = 116
          Width = 80
          Height = 13
          Caption = 'Additional Shear:'
        end
        object Label5: TLabel
          Left = 256
          Top = 44
          Width = 81
          Height = 13
          Caption = 'Add Bending TC:'
        end
        object Label44: TLabel
          Left = 256
          Top = 68
          Width = 81
          Height = 13
          Caption = 'Add Bending BC:'
        end
        object Label9: TLabel
          Left = 256
          Top = 92
          Width = 69
          Height = 13
          Caption = 'TC Axial Load:'
        end
        object Label10: TLabel
          Left = 256
          Top = 116
          Width = 69
          Height = 13
          Caption = 'BC Axial Load:'
        end
        object Label70: TLabel
          Left = 416
          Top = 44
          Width = 13
          Height = 13
          Caption = 'lbs'
        end
        object Label71: TLabel
          Left = 416
          Top = 68
          Width = 13
          Height = 13
          Caption = 'lbs'
        end
        object Label72: TLabel
          Left = 416
          Top = 92
          Width = 13
          Height = 13
          Caption = 'lbs'
        end
        object Label73: TLabel
          Left = 416
          Top = 116
          Width = 13
          Height = 13
          Caption = 'lbs'
        end
        object Label75: TLabel
          Left = 208
          Top = 116
          Width = 13
          Height = 13
          Caption = 'lbs'
        end
        object Label84: TLabel
          Left = 256
          Top = 20
          Width = 49
          Height = 13
          Caption = 'Add Load:'
        end
        object Label85: TLabel
          Left = 416
          Top = 20
          Width = 13
          Height = 13
          Caption = 'lbs'
        end
        object DBEdit32: TDBEdit
          Left = 138
          Top = 112
          Width = 65
          Height = 21
          DataField = 'Any Panel'
          DataSource = MainForm.DataSource2
          TabOrder = 1
        end
        object ConcGrid: TStringGrid
          Left = 12
          Top = 18
          Width = 209
          Height = 86
          ColCount = 2
          DefaultRowHeight = 16
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          TabOrder = 0
          OnDrawCell = ConcGridDrawCell
          OnKeyDown = ConcGridKeyDown
          RowHeights = (
            16
            16)
        end
        object DBEdit5: TDBEdit
          Left = 348
          Top = 40
          Width = 65
          Height = 21
          DataField = 'Anywhere TC'
          DataSource = MainForm.DataSource2
          TabOrder = 3
        end
        object DBEdit39: TDBEdit
          Left = 348
          Top = 64
          Width = 65
          Height = 21
          DataField = 'Anywhere BC'
          DataSource = MainForm.DataSource2
          TabOrder = 4
        end
        object DBEdit25: TDBEdit
          Left = 348
          Top = 88
          Width = 65
          Height = 21
          DataField = 'TC Axial Load'
          DataSource = MainForm.DataSource2
          TabOrder = 5
        end
        object DBEdit26: TDBEdit
          Left = 348
          Top = 112
          Width = 65
          Height = 21
          DataField = 'BC Axial Load'
          DataSource = MainForm.DataSource2
          TabOrder = 6
        end
        object DBEdit17: TDBEdit
          Left = 348
          Top = 16
          Width = 65
          Height = 21
          DataField = 'Add Load'
          DataSource = MainForm.DataSource2
          TabOrder = 2
        end
      end
      object UniformLoads: TGroupBox
        Left = 8
        Top = 152
        Width = 169
        Height = 93
        Caption = 'Uniform'
        TabOrder = 1
        object Label6: TLabel
          Left = 12
          Top = 44
          Width = 39
          Height = 13
          Caption = 'Add TC:'
        end
        object Label43: TLabel
          Left = 12
          Top = 68
          Width = 39
          Height = 13
          Caption = 'Add BC:'
        end
        object Label3: TLabel
          Left = 12
          Top = 20
          Width = 47
          Height = 13
          Caption = 'Net Uplift:'
        end
        object Label63: TLabel
          Left = 148
          Top = 20
          Width = 11
          Height = 13
          Caption = 'plf'
        end
        object Label64: TLabel
          Left = 148
          Top = 44
          Width = 11
          Height = 13
          Caption = 'plf'
        end
        object Label65: TLabel
          Left = 148
          Top = 68
          Width = 11
          Height = 13
          Caption = 'plf'
        end
        object DBEdit4: TDBEdit
          Left = 80
          Top = 41
          Width = 65
          Height = 21
          DataField = 'TC Uniform Load'
          DataSource = MainForm.DataSource2
          TabOrder = 1
        end
        object DBEdit38: TDBEdit
          Left = 80
          Top = 65
          Width = 65
          Height = 21
          DataField = 'BC Uniform Load'
          DataSource = MainForm.DataSource2
          TabOrder = 2
        end
        object DBEdit24: TDBEdit
          Left = 80
          Top = 17
          Width = 65
          Height = 21
          DataField = 'Net Uplift'
          DataSource = MainForm.DataSource2
          TabOrder = 0
        end
      end
      object Moments: TGroupBox
        Left = 184
        Top = 152
        Width = 273
        Height = 45
        Caption = 'Fixed Moment'
        TabOrder = 2
        object Label22: TLabel
          Left = 12
          Top = 20
          Width = 16
          Height = 13
          Caption = 'LE:'
        end
        object Label23: TLabel
          Left = 148
          Top = 20
          Width = 18
          Height = 13
          Caption = 'RE:'
        end
        object Label66: TLabel
          Left = 104
          Top = 20
          Width = 22
          Height = 13
          Caption = 'ft-lbs'
        end
        object Label68: TLabel
          Left = 240
          Top = 20
          Width = 22
          Height = 13
          Caption = 'ft-lbs'
        end
        object DBEdit27: TDBEdit
          Left = 36
          Top = 17
          Width = 65
          Height = 21
          DataField = 'Fixed Moment LE'
          DataSource = MainForm.DataSource2
          TabOrder = 0
        end
        object DBEdit28: TDBEdit
          Left = 172
          Top = 17
          Width = 65
          Height = 21
          DataField = 'Fixed Moment RE'
          DataSource = MainForm.DataSource2
          TabOrder = 1
        end
      end
      object GroupBox7: TGroupBox
        Left = 184
        Top = 200
        Width = 273
        Height = 45
        Caption = 'Lateral Moment'
        TabOrder = 3
        object Label24: TLabel
          Left = 12
          Top = 20
          Width = 16
          Height = 13
          Caption = 'LE:'
        end
        object Label30: TLabel
          Left = 148
          Top = 20
          Width = 18
          Height = 13
          Caption = 'RE:'
        end
        object Label67: TLabel
          Left = 104
          Top = 20
          Width = 22
          Height = 13
          Caption = 'ft-lbs'
        end
        object Label69: TLabel
          Left = 240
          Top = 20
          Width = 22
          Height = 13
          Caption = 'ft-lbs'
        end
        object DBEdit29: TDBEdit
          Left = 36
          Top = 17
          Width = 65
          Height = 21
          DataField = 'Lateral Moment LE'
          DataSource = MainForm.DataSource2
          TabOrder = 0
        end
        object DBEdit30: TDBEdit
          Left = 172
          Top = 17
          Width = 65
          Height = 21
          DataField = 'Lateral Moment RE'
          DataSource = MainForm.DataSource2
          TabOrder = 1
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Chords'
      object GroupBox4: TGroupBox
        Left = 8
        Top = 156
        Width = 449
        Height = 89
        Caption = 'Chords'
        TabOrder = 2
        object Label42: TLabel
          Left = 12
          Top = 44
          Width = 60
          Height = 13
          Caption = 'Min BC Size:'
        end
        object Label41: TLabel
          Left = 12
          Top = 20
          Width = 60
          Height = 13
          Caption = 'Min TC Size:'
        end
        object Label35: TLabel
          Left = 288
          Top = 20
          Width = 66
          Height = 13
          Caption = 'LL Deflection:'
        end
        object Label36: TLabel
          Left = 286
          Top = 44
          Width = 67
          Height = 13
          Caption = 'TL Deflection:'
        end
        object BCCombo: TComboBox
          Left = 88
          Top = 40
          Width = 177
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 1
        end
        object TCCombo: TComboBox
          Left = 88
          Top = 16
          Width = 177
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
        end
        object DBEdit33: TDBEdit
          Left = 368
          Top = 18
          Width = 57
          Height = 21
          DataField = 'LL Deflection'
          DataSource = MainForm.DataSource2
          TabOrder = 2
        end
        object DBEdit34: TDBEdit
          Left = 368
          Top = 42
          Width = 57
          Height = 21
          DataField = 'TL Deflection'
          DataSource = MainForm.DataSource2
          TabOrder = 3
        end
      end
      object GroupBox9: TGroupBox
        Left = 236
        Top = 8
        Width = 221
        Height = 145
        Caption = 'Right Side'
        TabOrder = 1
        object Label48: TLabel
          Left = 12
          Top = 20
          Width = 68
          Height = 13
          Caption = 'TCXR Length:'
        end
        object Label21: TLabel
          Left = 12
          Top = 44
          Width = 51
          Height = 13
          Caption = 'Seat BDR:'
        end
        object Label39: TLabel
          Left = 12
          Top = 92
          Width = 61
          Height = 13
          Caption = 'Seat Length:'
        end
        object Label26: TLabel
          Left = 12
          Top = 68
          Width = 52
          Height = 13
          Caption = 'Seat Type:'
        end
        object Label79: TLabel
          Left = 200
          Top = 20
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label80: TLabel
          Left = 200
          Top = 44
          Width = 8
          Height = 13
          Caption = 'in'
        end
        object Label81: TLabel
          Left = 200
          Top = 92
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label29: TLabel
          Left = 12
          Top = 116
          Width = 32
          Height = 13
          Caption = 'BCXR:'
        end
        object Label83: TLabel
          Left = 200
          Top = 120
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object DBEdit19: TDBEdit
          Left = 116
          Top = 17
          Width = 77
          Height = 21
          DataField = 'TCXR'
          DataSource = MainForm.DataSource2
          TabOrder = 0
          OnExit = valdectoing
        end
        object DBComboBox3: TDBComboBox
          Left = 116
          Top = 65
          Width = 45
          Height = 21
          Style = csDropDownList
          DataField = 'TCXRTY'
          DataSource = MainForm.DataSource2
          ItemHeight = 13
          Items.Strings = (
            'S'
            'R'
            'RD')
          TabOrder = 2
        end
        object DBEdit3: TDBEdit
          Left = 116
          Top = 41
          Width = 77
          Height = 21
          DataField = 'Seats BDR'
          DataSource = MainForm.DataSource2
          TabOrder = 1
          OnExit = valdectoinch
        end
        object DBEdit11: TDBEdit
          Left = 117
          Top = 86
          Width = 77
          Height = 21
          DataField = 'Seat Length RE'
          DataSource = MainForm.DataSource2
          TabOrder = 3
          OnExit = valdectoing
        end
        object DBEdit21: TDBEdit
          Left = 113
          Top = 113
          Width = 81
          Height = 21
          DataField = 'BCXR'
          DataSource = MainForm.DataSource2
          TabOrder = 4
          OnExit = valdectoing
        end
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 221
        Height = 145
        Caption = 'Left Side'
        TabOrder = 0
        object Label34: TLabel
          Left = 12
          Top = 20
          Width = 66
          Height = 13
          Caption = 'TCXL Length:'
        end
        object Label47: TLabel
          Left = 12
          Top = 44
          Width = 49
          Height = 13
          Caption = 'Seat BDL:'
        end
        object Label49: TLabel
          Left = 12
          Top = 92
          Width = 61
          Height = 13
          Caption = 'Seat Length:'
        end
        object Label25: TLabel
          Left = 12
          Top = 68
          Width = 52
          Height = 13
          Caption = 'Seat Type:'
        end
        object Label76: TLabel
          Left = 200
          Top = 20
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label77: TLabel
          Left = 200
          Top = 44
          Width = 8
          Height = 13
          Caption = 'in'
        end
        object Label78: TLabel
          Left = 200
          Top = 92
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object Label28: TLabel
          Left = 12
          Top = 116
          Width = 30
          Height = 13
          Caption = 'BCXL:'
        end
        object Label82: TLabel
          Left = 200
          Top = 116
          Width = 6
          Height = 13
          Caption = 'ft'
        end
        object DBEdit10: TDBEdit
          Left = 116
          Top = 17
          Width = 77
          Height = 21
          DataField = 'TCXL'
          DataSource = MainForm.DataSource2
          TabOrder = 0
          OnExit = valdectoing
        end
        object DBComboBox2: TDBComboBox
          Left = 116
          Top = 65
          Width = 45
          Height = 21
          Style = csDropDownList
          DataField = 'TCXLTY'
          DataSource = MainForm.DataSource2
          ItemHeight = 13
          Items.Strings = (
            'S'
            'R'
            'RD')
          TabOrder = 2
        end
        object DBEdit18: TDBEdit
          Left = 116
          Top = 41
          Width = 77
          Height = 21
          DataField = 'Seats BDL'
          DataSource = MainForm.DataSource2
          TabOrder = 1
          OnExit = valdectoinch
        end
        object DBEdit36: TDBEdit
          Left = 116
          Top = 89
          Width = 81
          Height = 21
          DataField = 'Seat Length LE'
          DataSource = MainForm.DataSource2
          TabOrder = 3
          OnExit = valdectoing
        end
        object DBEdit20: TDBEdit
          Left = 116
          Top = 113
          Width = 81
          Height = 21
          DataField = 'BCXL'
          DataSource = MainForm.DataSource2
          TabOrder = 4
          OnExit = valdectoing
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Extras'
      object GroupBox5: TGroupBox
        Left = 8
        Top = 8
        Width = 449
        Height = 117
        Caption = 'Partial Uniform'
        TabOrder = 0
        object PartGrid: TStringGrid
          Left = 12
          Top = 19
          Width = 353
          Height = 86
          ColCount = 3
          DefaultRowHeight = 16
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          TabOrder = 0
          OnDrawCell = PartGridDrawCell
          OnKeyDown = PartGridKeyDown
          RowHeights = (
            16
            16)
        end
      end
      object GroupBox8: TGroupBox
        Left = 8
        Top = 128
        Width = 449
        Height = 57
        Caption = 'Supports'
        TabOrder = 1
        object Label45: TLabel
          Left = 12
          Top = 23
          Width = 86
          Height = 13
          Caption = 'Left Support Joint:'
        end
        object Label46: TLabel
          Left = 200
          Top = 23
          Width = 93
          Height = 13
          Caption = 'Right Support Joint:'
        end
        object SuppL: TEdit
          Left = 112
          Top = 20
          Width = 57
          Height = 21
          TabOrder = 0
          OnExit = SuppLExit
        end
        object SuppR: TEdit
          Left = 308
          Top = 20
          Width = 57
          Height = 21
          TabOrder = 1
          OnExit = SuppRExit
        end
      end
      object GroupBox3: TGroupBox
        Left = 8
        Top = 188
        Width = 449
        Height = 57
        Caption = 'Special Design'
        TabOrder = 2
        object Label87: TLabel
          Left = 196
          Top = 25
          Width = 8
          Height = 13
          Caption = 'in'
        end
        object SpecialGap: TCheckBox
          Left = 12
          Top = 24
          Width = 125
          Height = 17
          TabStop = False
          Caption = 'Gap Between Chords'
          TabOrder = 0
          OnClick = SpecialGapClick
        end
        object GapValue: TEdit
          Left = 140
          Top = 22
          Width = 50
          Height = 21
          Enabled = False
          TabOrder = 1
          Text = '0.00'
          OnExit = GapValueExit
        end
        object DBCheckBox1: TDBCheckBox
          Left = 308
          Top = 24
          Width = 76
          Height = 17
          TabStop = False
          Caption = 'Use LRFD'
          DataField = 'LRFD'
          DataSource = MainForm.DataSource2
          TabOrder = 2
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
      end
    end
  end
  object OKBtn: TBitBtn
    Left = 318
    Top = 292
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    Style = bsNew
  end
  object CancelBtn: TBitBtn
    Left = 398
    Top = 292
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    Style = bsNew
  end
end
