object ConfirmReplaceDialog: TConfirmReplaceDialog
  Left = 275
  Top = 110
  BorderStyle = bsDialog
  Caption = 'Confirm Replace'
  ClientHeight = 81
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object imgIcon: TImage
    Left = 8
    Top = 8
    Width = 32
    Height = 32
  end
  object lblQuestion: TLabel
    Left = 48
    Top = 8
    Width = 273
    Height = 29
    AutoSize = False
    WordWrap = True
  end
  object btnCancel: TButton
    Left = 8
    Top = 48
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 0
  end
  object btnSkip: TButton
    Left = 88
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Skip'
    ModalResult = 5
    TabOrder = 1
  end
  object btnReplace: TButton
    Left = 168
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Replace'
    Default = True
    ModalResult = 6
    TabOrder = 2
  end
  object btnAll: TButton
    Left = 248
    Top = 48
    Width = 75
    Height = 25
    Caption = 'All'
    ModalResult = 8
    TabOrder = 3
  end
end
