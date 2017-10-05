inherited ReplaceDialog: TReplaceDialog
  Left = 325
  Top = 236
  Caption = 'Replace Text'
  ClientHeight = 298
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object lblReplace: TLabel [1]
    Left = 8
    Top = 80
    Width = 65
    Height = 13
    Caption = 'Replace wi&th:'
  end
  inherited gbConditions: TGroupBox
    Top = 152
    inherited chkListFounds: TCheckBox
      TabOrder = 6
    end
    object chkPrompt: TCheckBox
      Left = 8
      Top = 116
      Width = 165
      Height = 17
      Caption = '&Prompt on replace'
      TabOrder = 5
    end
  end
  inherited chkInAll: TCheckBox
    Top = 216
    OnClick = chkInAllClick
  end
  inherited btnFindNext: TButton
    Caption = 'R&eplace Next'
  end
  inherited btnClose: TButton
    Top = 240
    TabOrder = 5
  end
  inherited btnHelp: TButton
    Top = 268
    TabOrder = 7
  end
  inherited gbDirection: TGroupBox
    Top = 152
  end
  object btnReplaceAll: TButton
    Left = 336
    Top = 36
    Width = 97
    Height = 25
    Caption = 'Replace &All'
    TabOrder = 4
    OnClick = btnReplaceAllClick
  end
  object cmbReplace: TMemo
    Left = 96
    Top = 80
    Width = 233
    Height = 65
    ScrollBars = ssBoth
    TabOrder = 8
  end
end
