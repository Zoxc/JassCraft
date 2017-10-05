object GoToLineDialog: TGoToLineDialog
  Left = 279
  Top = 190
  BorderStyle = bsDialog
  Caption = 'Go to Line'
  ClientHeight = 73
  ClientWidth = 185
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblGoTo: TLabel
    Left = 8
    Top = 12
    Width = 88
    Height = 13
    Caption = 'Go to line number:'
  end
  object txtLine: TEdit
    Left = 120
    Top = 8
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '1'
  end
  object btnOK: TButton
    Left = 24
    Top = 40
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 104
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
