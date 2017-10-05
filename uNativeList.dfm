object frmNative: TfrmNative
  Left = 784
  Top = 280
  Width = 178
  Height = 515
  BorderStyle = bsSizeToolWin
  Caption = 'Native List'
  Color = clBtnFace
  DockSite = True
  DragKind = dkDock
  DragMode = dmAutomatic
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 11
    Width = 37
    Height = 13
    Caption = 'Search:'
  end
  object showhide: TLabel
    Left = 0
    Top = 462
    Width = 161
    Height = 13
    Cursor = crHandPoint
    Alignment = taCenter
    AutoSize = False
    Caption = 'Show options'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGray
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = showhideClick
    OnMouseEnter = showhideMouseEnter
    OnMouseLeave = showhideMouseLeave
  end
  object search: TComboBox
    Left = 44
    Top = 8
    Width = 119
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = searchChange
  end
  object list: TListBox
    Left = 4
    Top = 32
    Width = 159
    Height = 429
    ItemHeight = 13
    Sorted = True
    TabOrder = 1
    OnClick = listClick
    OnDblClick = listDblClick
  end
  object options: TPanel
    Left = 4
    Top = 320
    Width = 159
    Height = 141
    BevelOuter = bvNone
    TabOrder = 2
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 159
      Height = 141
      Align = alClient
      Caption = 'Search Options'
      TabOrder = 0
      DesignSize = (
        159
        141)
      object Label2: TLabel
        Left = 8
        Top = 16
        Width = 54
        Height = 13
        Caption = 'Search for:'
      end
      object Label3: TLabel
        Left = 8
        Top = 80
        Width = 48
        Height = 13
        Caption = 'Search in:'
      end
      object sfor: TCheckListBox
        Left = 64
        Top = 16
        Width = 81
        Height = 57
        OnClickCheck = sforClickCheck
        ItemHeight = 13
        Items.Strings = (
          'Functions'
          'Types'
          'Variables'
          'Constants')
        TabOrder = 0
      end
      object sin: TCheckListBox
        Left = 64
        Top = 80
        Width = 81
        Height = 17
        OnClickCheck = sinClickCheck
        ItemHeight = 13
        TabOrder = 1
      end
      object cases: TCheckBox
        Left = 8
        Top = 98
        Width = 97
        Height = 21
        Anchors = [akLeft, akBottom]
        Caption = 'Case Sensitive'
        TabOrder = 2
        OnClick = casesClick
      end
      object fromb: TCheckBox
        Left = 8
        Top = 116
        Width = 97
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = 'From Beginning'
        TabOrder = 3
        OnClick = frombClick
      end
    end
  end
  object JvDockClient: TJvDockClient
    LRDockWidth = 173
    DirectDrag = False
    TopDock = False
    BottomDock = False
    DockStyle = MainForm.JvDockVIDStyle1
    Left = 40
    Top = 72
  end
end
