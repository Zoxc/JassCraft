object OptionsDialog: TOptionsDialog
  Left = 305
  Top = 141
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 482
  ClientWidth = 501
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pctrlOptions: TPageControl
    Left = 8
    Top = 8
    Width = 485
    Height = 429
    ActivePage = tsGeneral
    TabOrder = 0
    object tsGeneral: TTabSheet
      Caption = 'General'
      object chkSaveWindowPos: TCheckBox
        Left = 4
        Top = 24
        Width = 333
        Height = 17
        Caption = 'Save main window position on exit'
        TabOrder = 0
      end
      object chkReopenWorkspace: TCheckBox
        Left = 4
        Top = 44
        Width = 333
        Height = 17
        Caption = 'Reopen last workspace'
        TabOrder = 1
      end
      object chkReopenLastFiles: TCheckBox
        Left = 4
        Top = 64
        Width = 333
        Height = 17
        Caption = 'Reopen last open files'
        TabOrder = 2
      end
      object chkCreateEmpty: TCheckBox
        Left = 4
        Top = 84
        Width = 333
        Height = 17
        Caption = 'Create empty document at startup'
        TabOrder = 3
      end
      object chkOneCopy: TCheckBox
        Left = 4
        Top = 4
        Width = 333
        Height = 17
        Caption = 'Allow to run only one copy'
        TabOrder = 4
      end
      object chkVSTheme: TCheckBox
        Left = 4
        Top = 104
        Width = 333
        Height = 17
        Caption = 'Use Visual Studio Menu Theme'
        TabOrder = 5
      end
      object grpFiles: TGroupBox
        Left = 8
        Top = 128
        Width = 185
        Height = 73
        Caption = 'Files to open in JassCraft'
        TabOrder = 6
        object foJ: TCheckBox
          Left = 12
          Top = 16
          Width = 37
          Height = 17
          Caption = '.j'
          TabOrder = 0
        end
        object foAI: TCheckBox
          Left = 12
          Top = 32
          Width = 37
          Height = 17
          Caption = '.ai'
          TabOrder = 1
        end
        object foMDL: TCheckBox
          Left = 12
          Top = 48
          Width = 37
          Height = 17
          Caption = '.mdl'
          TabOrder = 2
        end
      end
    end
    object tsEditor: TTabSheet
      Caption = 'Editor'
      ImageIndex = 1
      object gbGeneral: TGroupBox
        Left = 4
        Top = 4
        Width = 469
        Height = 253
        Caption = 'General options'
        TabOrder = 0
        object lblExtraLine: TLabel
          Left = 8
          Top = 168
          Width = 88
          Height = 13
          Caption = 'Extra line spacing:'
        end
        object lblInsertCaret: TLabel
          Left = 236
          Top = 140
          Width = 90
          Height = 13
          Caption = 'Insert mode caret:'
        end
        object lblOverwriteCaret: TLabel
          Left = 236
          Top = 168
          Width = 109
          Height = 13
          Caption = 'Overwrite mode caret:'
        end
        object lblMaxUndo: TLabel
          Left = 8
          Top = 196
          Width = 75
          Height = 13
          Caption = 'Maximum undo:'
        end
        object lblTabWidth: TLabel
          Left = 236
          Top = 224
          Width = 51
          Height = 13
          Caption = 'Tab width:'
        end
        object lblFoldingButton: TLabel
          Left = 236
          Top = 196
          Width = 99
          Height = 13
          Caption = 'Folding button style:'
        end
        object chkAutoIndent: TCheckBox
          Left = 8
          Top = 16
          Width = 221
          Height = 17
          Caption = 'Auto indent'
          TabOrder = 0
        end
        object chkGroupUndo: TCheckBox
          Left = 8
          Top = 56
          Width = 221
          Height = 17
          Caption = 'Group undo'
          TabOrder = 2
        end
        object chkHighlightLine: TCheckBox
          Left = 8
          Top = 76
          Width = 221
          Height = 17
          Caption = 'Highlight active line'
          TabOrder = 3
        end
        object chkInsertMode: TCheckBox
          Left = 8
          Top = 116
          Width = 221
          Height = 17
          Caption = 'Insert mode'
          TabOrder = 5
        end
        object chkScrollPastEOF: TCheckBox
          Left = 236
          Top = 16
          Width = 221
          Height = 17
          Caption = 'Scroll past EOF'
          TabOrder = 6
        end
        object chkScrollPastEOL: TCheckBox
          Left = 236
          Top = 36
          Width = 221
          Height = 17
          Caption = 'Scroll past EOL'
          TabOrder = 7
        end
        object chkIndentGuides: TCheckBox
          Left = 236
          Top = 56
          Width = 221
          Height = 17
          Caption = 'Show indent guides'
          TabOrder = 8
        end
        object chkSpecialCharacters: TCheckBox
          Left = 236
          Top = 76
          Width = 221
          Height = 17
          Caption = 'Show special characters'
          TabOrder = 9
        end
        object chkTabsToSpaces: TCheckBox
          Left = 236
          Top = 96
          Width = 221
          Height = 17
          Caption = 'Tabs to spaces'
          TabOrder = 10
        end
        object chkWordWrap: TCheckBox
          Left = 236
          Top = 116
          Width = 221
          Height = 17
          Caption = 'Word wrap'
          TabOrder = 11
        end
        object Edit2: TEdit
          Left = 180
          Top = 164
          Width = 33
          Height = 21
          TabOrder = 12
          Text = '0'
        end
        object udExtraSpacing: TUpDown
          Left = 213
          Top = 164
          Width = 15
          Height = 21
          Associate = Edit2
          Max = 60
          TabOrder = 13
        end
        object cmbInsertCaret: TComboBox
          Left = 364
          Top = 136
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 17
        end
        object cmbOverwriteCaret: TComboBox
          Left = 364
          Top = 164
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 18
        end
        object Edit3: TEdit
          Left = 180
          Top = 192
          Width = 33
          Height = 21
          TabOrder = 14
          Text = '0'
        end
        object udMaxUndo: TUpDown
          Left = 213
          Top = 192
          Width = 15
          Height = 21
          Associate = Edit3
          Max = 1024
          TabOrder = 15
        end
        object Edit4: TEdit
          Left = 412
          Top = 220
          Width = 33
          Height = 21
          TabOrder = 20
          Text = '0'
        end
        object udTabWidth: TUpDown
          Left = 445
          Top = 220
          Width = 15
          Height = 21
          Associate = Edit4
          Max = 10
          TabOrder = 21
        end
        object chkHighlightGuides: TCheckBox
          Left = 8
          Top = 96
          Width = 221
          Height = 17
          Caption = 'Highlight indent guides'
          TabOrder = 4
        end
        object btnFont: TButton
          Left = 8
          Top = 220
          Width = 221
          Height = 25
          Caption = 'Font: Courier New, 10'
          TabOrder = 16
          OnClick = btnFontClick
        end
        object chkCodeFolding: TCheckBox
          Left = 8
          Top = 36
          Width = 221
          Height = 17
          Caption = 'Code folding (Buggy)'
          TabOrder = 1
        end
        object cmbFoldingButton: TComboBox
          Left = 364
          Top = 192
          Width = 97
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 19
        end
      end
      object gbGutterMargin: TGroupBox
        Left = 4
        Top = 264
        Width = 469
        Height = 129
        Caption = 'Gutter and margin'
        TabOrder = 1
        object lblRightMarginPos: TLabel
          Left = 216
          Top = 20
          Width = 104
          Height = 13
          Caption = 'Right margin position:'
        end
        object lblGutterColor: TLabel
          Left = 216
          Top = 48
          Width = 61
          Height = 13
          Caption = 'Gutter color:'
        end
        object lblFoldingBarColor: TLabel
          Left = 216
          Top = 76
          Width = 83
          Height = 13
          Caption = 'Folding bar color:'
        end
        object lblFoldingLinesColor: TLabel
          Left = 216
          Top = 104
          Width = 107
          Height = 13
          Caption = 'Folding bar lines color:'
        end
        object chkShowGutter: TCheckBox
          Left = 8
          Top = 16
          Width = 193
          Height = 17
          Caption = 'Show gutter'
          TabOrder = 0
        end
        object chkShowRightMargin: TCheckBox
          Left = 8
          Top = 36
          Width = 193
          Height = 17
          Caption = 'Show right margin'
          TabOrder = 1
        end
        object chkShowLineNumbers: TCheckBox
          Left = 8
          Top = 56
          Width = 193
          Height = 17
          Caption = 'Show line numbers'
          TabOrder = 2
        end
        object chkShowLeadingZeros: TCheckBox
          Left = 8
          Top = 76
          Width = 193
          Height = 17
          Caption = 'Show leading zeros'
          TabOrder = 3
        end
        object chkZeroStart: TCheckBox
          Left = 8
          Top = 96
          Width = 193
          Height = 17
          Caption = 'Zero start'
          TabOrder = 4
        end
        object Edit5: TEdit
          Left = 412
          Top = 16
          Width = 33
          Height = 21
          TabOrder = 5
          Text = '0'
        end
        object udRightMargin: TUpDown
          Left = 445
          Top = 16
          Width = 15
          Height = 21
          Associate = Edit5
          TabOrder = 6
        end
        object cbGutter: TColorBox
          Left = 352
          Top = 43
          Width = 109
          Height = 22
          DefaultColorColor = clBtnFace
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 7
        end
        object cbFoldingBar: TColorBox
          Left = 352
          Top = 71
          Width = 109
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 8
        end
        object cbFoldingLines: TColorBox
          Left = 352
          Top = 99
          Width = 109
          Height = 22
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 9
        end
      end
    end
    object tsKeyboard: TTabSheet
      Caption = 'Keyboard'
      ImageIndex = 6
      object gbKeyboard: TGroupBox
        Left = 4
        Top = 4
        Width = 469
        Height = 389
        Caption = 'Keyboard shortcuts'
        TabOrder = 0
        object lblKeyCategories: TLabel
          Left = 8
          Top = 16
          Width = 56
          Height = 13
          Caption = 'Categories:'
        end
        object lblKeyCommands: TLabel
          Left = 152
          Top = 16
          Width = 56
          Height = 13
          Caption = 'Commands:'
        end
        object lblShortcutKey: TLabel
          Left = 12
          Top = 336
          Width = 65
          Height = 13
          Caption = 'Shortcut key:'
        end
        object lblShortCutAssigned: TLabel
          Left = 252
          Top = 336
          Width = 60
          Height = 13
          Caption = 'Assigned to:'
        end
        object lblShortCutAssignedTo: TLabel
          Left = 252
          Top = 360
          Width = 108
          Height = 13
          Caption = 'lblShortCutAssignedTo'
        end
        object lstKeyCat: TListBox
          Left = 8
          Top = 32
          Width = 137
          Height = 297
          Style = lbOwnerDrawFixed
          ItemHeight = 16
          TabOrder = 0
          OnClick = lstKeyCatClick
        end
        object lstKeyCmd: TListBox
          Left = 152
          Top = 32
          Width = 305
          Height = 297
          Style = lbOwnerDrawFixed
          ItemHeight = 22
          Sorted = True
          TabOrder = 1
          OnClick = lstKeyCmdClick
          OnDrawItem = lstKeyCmdDrawItem
        end
        object chkCtrl: TCheckBox
          Left = 84
          Top = 360
          Width = 41
          Height = 17
          Caption = 'Ctrl'
          TabOrder = 2
          OnClick = chkCtrlClick
        end
        object chkShift: TCheckBox
          Left = 128
          Top = 360
          Width = 45
          Height = 17
          Caption = 'Shift'
          TabOrder = 3
          OnClick = chkShiftClick
        end
        object chkAlt: TCheckBox
          Left = 184
          Top = 360
          Width = 33
          Height = 17
          Caption = 'Alt'
          TabOrder = 4
          OnClick = chkAltClick
        end
        object cmbShortCut: TComboBox
          Left = 84
          Top = 332
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          Sorted = True
          TabOrder = 5
          OnChange = cmbShortCutChange
          Items.Strings = (
            ''
            #39
            '-'
            ','
            '.'
            '/'
            ';'
            '\'
            ']'
            '='
            '0'
            '1'
            '2'
            '3'
            '4'
            '5'
            '6'
            '7'
            '8'
            '9'
            'A'
            'B'
            'BkSp'
            'C'
            'D'
            'Del'
            'Down'
            'E'
            'End'
            'F'
            'F1'
            'F10'
            'F11'
            'F12'
            'F2'
            'F3'
            'F4'
            'F5'
            'F6'
            'F7'
            'F8'
            'F9'
            'G'
            'H'
            'Home'
            'I'
            'Ins'
            'J'
            'K'
            'L'
            'Left'
            'M'
            'N'
            'O'
            'P'
            'PgDn'
            'PgUp'
            'Q'
            'R'
            'Right'
            'S'
            'T'
            'Tab'
            'U'
            'Up'
            'V'
            'W'
            'X'
            'Y'
            'Z'
            '[')
        end
      end
    end
    object tsJass: TTabSheet
      Caption = 'Jass Enchantments'
      ImageIndex = 4
      object chcFuncCase: TCheckBox
        Left = 8
        Top = 8
        Width = 121
        Height = 17
        Caption = 'Auto function case'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object GroupBox1: TGroupBox
        Left = 200
        Top = 8
        Width = 265
        Height = 385
        Caption = 'Syntax Highligthing'
        TabOrder = 1
        object Label1: TLabel
          Left = 16
          Top = 28
          Width = 55
          Height = 13
          Caption = 'Highligther:'
        end
        object Label2: TLabel
          Left = 16
          Top = 100
          Width = 39
          Height = 13
          Caption = 'Section:'
        end
        object Label3: TLabel
          Left = 16
          Top = 124
          Width = 29
          Height = 13
          Caption = 'Color:'
        end
        object Label4: TLabel
          Left = 16
          Top = 148
          Width = 60
          Height = 13
          Caption = 'Background:'
        end
        object Label5: TLabel
          Left = 16
          Top = 172
          Width = 53
          Height = 13
          Caption = 'Font Style:'
        end
        object Label6: TLabel
          Left = 16
          Top = 52
          Width = 28
          Height = 13
          Caption = 'Style:'
        end
        object ComboBox1: TComboBox
          Left = 88
          Top = 24
          Width = 169
          Height = 21
          Style = csDropDownList
          Enabled = False
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 0
          Text = 'Jass'
          Items.Strings = (
            'Jass')
        end
        object cmbSSection: TComboBox
          Left = 88
          Top = 96
          Width = 169
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 1
          OnChange = cmbSSectionChange
        end
        object clrBack: TColorBox
          Left = 88
          Top = 144
          Width = 169
          Height = 22
          DefaultColorColor = clNone
          NoneColorColor = clNone
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 2
          OnChange = chkBoldClick
        end
        object clrColor: TColorBox
          Left = 88
          Top = 120
          Width = 169
          Height = 22
          DefaultColorColor = clNone
          NoneColorColor = clNone
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbCustomColor, cbPrettyNames]
          ItemHeight = 16
          TabOrder = 3
          OnChange = chkBoldClick
        end
        object chkBold: TCheckBox
          Left = 88
          Top = 171
          Width = 41
          Height = 17
          Caption = 'Bold'
          TabOrder = 4
          OnClick = chkBoldClick
        end
        object chkItalic: TCheckBox
          Left = 136
          Top = 171
          Width = 41
          Height = 17
          Caption = 'Italic'
          TabOrder = 5
          OnClick = chkBoldClick
        end
        object chkUnderline: TCheckBox
          Left = 184
          Top = 171
          Width = 65
          Height = 17
          Caption = 'Underline'
          TabOrder = 6
          OnClick = chkBoldClick
        end
        object cmbStyle: TComboBox
          Left = 88
          Top = 48
          Width = 169
          Height = 21
          Style = csDropDownList
          ItemHeight = 0
          TabOrder = 7
          OnChange = cmbStyleChange
        end
        object styleAdd: TButton
          Left = 88
          Top = 72
          Width = 49
          Height = 21
          Caption = 'Add'
          TabOrder = 8
          OnClick = styleAddClick
        end
        object styleDelete: TButton
          Left = 144
          Top = 72
          Width = 57
          Height = 21
          Caption = 'Remove'
          Enabled = False
          TabOrder = 9
        end
        object PageControl1: TPageControl
          Left = 8
          Top = 192
          Width = 249
          Height = 185
          ActivePage = TabSheet1
          TabOrder = 10
          object TabSheet1: TTabSheet
            Caption = 'Demo'
            object SynDemo: TSynEdit
              Left = 0
              Top = 0
              Width = 241
              Height = 157
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Courier New'
              Font.Style = []
              TabOrder = 0
              BorderStyle = bsNone
              Gutter.Font.Charset = DEFAULT_CHARSET
              Gutter.Font.Color = clWindowText
              Gutter.Font.Height = -11
              Gutter.Font.Name = 'Courier New'
              Gutter.Font.Style = []
              Lines.Strings = (
                '// Comment'
                ''
                'function Demo takes integer param returns integer'
                '    local integer result'
                '    call BJDebugMsg("Testing")'
                '    set result = param+1.0'
                '    return result-(1)'
                'endfunction')
            end
          end
          object TabSheet2: TTabSheet
            Caption = 'Colors'
            ImageIndex = 1
            object values: TValueListEditor
              Left = 0
              Top = 0
              Width = 241
              Height = 157
              Align = alClient
              BorderStyle = bsNone
              DefaultColWidth = 140
              Options = [goVertLine, goHorzLine, goColSizing, goAlwaysShowEditor, goThumbTracking]
              Strings.Strings = (
                '')
              TabOrder = 0
              TitleCaptions.Strings = (
                'Name'
                'Color')
              OnDblClick = valuesDblClick
              OnDrawCell = valuesDrawCell
              ColWidths = (
                140
                99)
            end
          end
        end
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 120
        Width = 185
        Height = 273
        Caption = 'Native Files'
        TabOrder = 2
        object Label7: TLabel
          Left = 8
          Top = 16
          Width = 158
          Height = 13
          Caption = 'Check to include in Syntax Check'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object btnNFAdd: TButton
          Left = 104
          Top = 240
          Width = 75
          Height = 25
          Caption = 'Add'
          TabOrder = 0
          OnClick = btnNFAddClick
        end
        object btnNFRemove: TButton
          Left = 24
          Top = 240
          Width = 75
          Height = 25
          Caption = 'Remove'
          Enabled = False
          TabOrder = 1
          OnClick = btnNFRemoveClick
        end
        object lstNatives: TCheckListBox
          Left = 8
          Top = 32
          Width = 169
          Height = 201
          ItemHeight = 13
          TabOrder = 2
        end
      end
      object chkEnterIndent: TCheckBox
        Left = 8
        Top = 26
        Width = 121
        Height = 17
        Caption = 'Indent on '#39'Enter'#39
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object chkParamLight: TCheckBox
        Left = 8
        Top = 44
        Width = 121
        Height = 17
        Caption = 'Highlight parameters'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Templates'
      ImageIndex = 4
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 153
        Height = 401
        Caption = 'Templates'
        TabOrder = 0
        object tmpList: TListBox
          Left = 8
          Top = 16
          Width = 137
          Height = 345
          ItemHeight = 13
          TabOrder = 0
          OnClick = tmpListClick
        end
        object Button1: TButton
          Left = 8
          Top = 368
          Width = 65
          Height = 25
          Caption = '&New'
          TabOrder = 1
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 72
          Top = 368
          Width = 73
          Height = 25
          Caption = '&Delete'
          TabOrder = 2
          OnClick = Button2Click
        end
      end
      object GroupBox4: TGroupBox
        Left = 160
        Top = 0
        Width = 316
        Height = 401
        Caption = 'Data'
        TabOrder = 1
        object Label8: TLabel
          Left = 8
          Top = 354
          Width = 24
          Height = 13
          Caption = 'Title:'
        end
        object Label9: TLabel
          Left = 8
          Top = 378
          Width = 45
          Height = 13
          Caption = 'Shortcut:'
        end
        object tmpData: TSynEdit
          Left = 8
          Top = 16
          Width = 297
          Height = 297
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = []
          TabOrder = 0
          Gutter.Font.Charset = DEFAULT_CHARSET
          Gutter.Font.Color = clWindowText
          Gutter.Font.Height = -11
          Gutter.Font.Name = 'Courier New'
          Gutter.Font.Style = []
          Options = [eoDragDropEditing, eoGroupUndo, eoShowScrollHint, eoSmartTabDelete, eoSmartTabs, eoTabsToSpaces]
          OnChange = tmpDataChange
        end
        object tmpTitle: TEdit
          Left = 56
          Top = 352
          Width = 249
          Height = 21
          TabOrder = 1
          OnChange = tmpTitleChange
        end
        object tmpShortcut: THotKey
          Left = 56
          Top = 376
          Width = 249
          Height = 19
          HotKey = 0
          Modifiers = []
          TabOrder = 2
          OnChange = tmpShortcutChange
        end
        object Button3: TButton
          Left = 232
          Top = 320
          Width = 75
          Height = 25
          Caption = 'Save Cursor'
          TabOrder = 3
          OnClick = Button3Click
        end
      end
    end
  end
  object btnOK: TButton
    Left = 256
    Top = 448
    Width = 75
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 336
    Top = 448
    Width = 75
    Height = 25
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnHelp: TButton
    Left = 416
    Top = 448
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 3
  end
  object dlgOpen: TOpenDialog
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 120
    Top = 448
  end
  object dlgFont: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdFixedPitchOnly, fdNoStyleSel]
    Left = 152
    Top = 448
  end
end
