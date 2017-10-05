unit uOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, CheckLst, uMyIniFiles, ActnList,
  Menus, Registry, StrUtils, Mask, JvExMask, JvToolEdit, SynEdit,
  SynJass,  SynEditTypes, SynEditHighlighter, Grids, ValEdit;

type
  TTemplate = record
  Text,FileName:String;
  Title:String;
  ShortCut:TShortCut;
  Pos:Integer;
  end;
  TOptionsDialog = class(TForm)
    pctrlOptions: TPageControl;
    btnOK: TButton;
    btnCancel: TButton;
    tsGeneral: TTabSheet;
    tsEditor: TTabSheet;
    chkSaveWindowPos: TCheckBox;
    chkReopenWorkspace: TCheckBox;
    chkReopenLastFiles: TCheckBox;
    chkCreateEmpty: TCheckBox;
    gbGeneral: TGroupBox;
    chkAutoIndent: TCheckBox;
    chkGroupUndo: TCheckBox;
    chkHighlightLine: TCheckBox;
    chkInsertMode: TCheckBox;
    chkScrollPastEOF: TCheckBox;
    chkScrollPastEOL: TCheckBox;
    chkIndentGuides: TCheckBox;
    chkSpecialCharacters: TCheckBox;
    chkTabsToSpaces: TCheckBox;
    chkWordWrap: TCheckBox;
    gbGutterMargin: TGroupBox;
    lblExtraLine: TLabel;
    Edit2: TEdit;
    udExtraSpacing: TUpDown;
    lblInsertCaret: TLabel;
    cmbInsertCaret: TComboBox;
    lblOverwriteCaret: TLabel;
    cmbOverwriteCaret: TComboBox;
    Edit3: TEdit;
    udMaxUndo: TUpDown;
    lblMaxUndo: TLabel;
    lblTabWidth: TLabel;
    Edit4: TEdit;
    udTabWidth: TUpDown;
    chkShowGutter: TCheckBox;
    chkShowRightMargin: TCheckBox;
    chkShowLineNumbers: TCheckBox;
    chkShowLeadingZeros: TCheckBox;
    chkZeroStart: TCheckBox;
    lblRightMarginPos: TLabel;
    Edit5: TEdit;
    udRightMargin: TUpDown;
    lblGutterColor: TLabel;
    cbGutter: TColorBox;
    lblFoldingBarColor: TLabel;
    cbFoldingBar: TColorBox;
    lblFoldingLinesColor: TLabel;
    cbFoldingLines: TColorBox;
    chkHighlightGuides: TCheckBox;
    btnFont: TButton;
    chkCodeFolding: TCheckBox;
    lblFoldingButton: TLabel;
    cmbFoldingButton: TComboBox;
    dlgOpen: TOpenDialog;
    tsKeyboard: TTabSheet;
    dlgFont: TFontDialog;
    gbKeyboard: TGroupBox;
    lblKeyCategories: TLabel;
    lstKeyCat: TListBox;
    lstKeyCmd: TListBox;
    lblKeyCommands: TLabel;
    lblShortcutKey: TLabel;
    lblShortCutAssigned: TLabel;
    lblShortCutAssignedTo: TLabel;
    btnHelp: TButton;
    chkOneCopy: TCheckBox;
    chkCtrl: TCheckBox;
    chkShift: TCheckBox;
    chkAlt: TCheckBox;
    cmbShortCut: TComboBox;
    tsJass: TTabSheet;
    chcFuncCase: TCheckBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox1: TComboBox;
    cmbSSection: TComboBox;
    clrBack: TColorBox;
    clrColor: TColorBox;
    chkBold: TCheckBox;
    chkItalic: TCheckBox;
    chkUnderline: TCheckBox;
    cmbStyle: TComboBox;
    styleAdd: TButton;
    styleDelete: TButton;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    btnNFAdd: TButton;
    btnNFRemove: TButton;
    chkEnterIndent: TCheckBox;
    chkVSTheme: TCheckBox;
    chkParamLight: TCheckBox;
    lstNatives: TCheckListBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    SynDemo: TSynEdit;
    TabSheet2: TTabSheet;
    values: TValueListEditor;
    TabSheet3: TTabSheet;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    tmpList: TListBox;
    Button1: TButton;
    Button2: TButton;
    grpFiles: TGroupBox;
    foJ: TCheckBox;
    foAI: TCheckBox;
    foMDL: TCheckBox;
    tmpData: TSynEdit;
    tmpTitle: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    tmpShortcut: THotKey;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure UpdateTemplates;
    procedure btnOKClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure lstKeyCatClick(Sender: TObject);
    procedure lstKeyCmdClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure chkCtrlClick(Sender: TObject);
    procedure chkShiftClick(Sender: TObject);
    procedure chkAltClick(Sender: TObject);
    procedure cmbShortCutChange(Sender: TObject);
    procedure lstKeyCmdDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmbSSectionChange(Sender: TObject);
    procedure chkBoldClick(Sender: TObject);
    procedure UpdateJASSHighlight;
    procedure FormShow(Sender: TObject);
    procedure styleAddClick(Sender: TObject);
    procedure cmbStyleChange(Sender: TObject);
    procedure lstNativesClick(Sender: TObject);
    procedure btnNFAddClick(Sender: TObject);
    procedure btnNFRemoveClick(Sender: TObject);
    procedure valuesDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure valuesDblClick(Sender: TObject);
    procedure tmpListClick(Sender: TObject);
    procedure tmpDataChange(Sender: TObject);
    procedure tmpTitleChange(Sender: TObject);
    procedure tmpShortcutChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    fSettingsCopy: TMyIniFile;
    fSettingShortCut: Boolean;
    Temps: array of TTemplate;

    procedure SynEditing(Enable: Boolean);
    procedure ShortcutAssigned;
    procedure ShortcutChanged;
    function ShortcutGet: String;
  public
    ListCache:TBitmap;
  JassSyn: TSynEdit_JassSyn;
  end;

var
  OptionsDialog: TOptionsDialog;
  CommandNames: TStringList;

procedure SaveHighlightStyle(Ini:TMyIniFile; StyleNum:Integer; Style:THighlightStyle);
procedure LoadHighlightStyle(Ini:TMyIniFile; StyleNum:Integer; Style:THighlightStyle);


implementation

uses uMain, IniFiles, uUtils, uFuncInfo, uDocuments;

{$R *.dfm}


procedure TOptionsDialog.SynEditing(Enable: Boolean);
begin
cmbStyle.Enabled := Enable;
//styleDelete.Enabled := Enable;
cmbSSection.Enabled := Enable;
clrColor.Enabled := Enable;
clrBack.Enabled := Enable;
chkBold.Enabled := Enable;
chkItalic.Enabled := Enable;
chkUnderline.Enabled := Enable;
SynDemo.Enabled := Enable;

end;

procedure TOptionsDialog.UpdateTemplates;
var i:Integer;
begin
tmpList.Items.BeginUpdate;
tmpList.Items.Clear;
for i := 0 to High(Temps) do
 tmpList.Items.Add(Temps[i].Title);
tmpList.Items.EndUpdate;
end;

procedure TOptionsDialog.FormCreate(Sender: TObject);
var
	i,c: Integer;
  TempFileName: String;
  JassA:THighlightStyle;
  JassB:THighlightStyle;
  Temp:TTemplate;
   sr: TSearchRec;
  S:TStringList;
function FromString(S:String):String;
begin
Result := AnsiReplaceStr(S, '\r', #13);
Result := AnsiReplaceStr(Result, '\n', #10);
Result := AnsiReplaceStr(Result, '\"', '"');
Result := AnsiReplaceStr(Result, '\\', '\');
end;
begin
  // Templates
    S := TStringList.Create;
         SetLength(Temps, 0);
      if FindFirst(AppPath+'Scripts\*.jcs', faAnyFile	, sr) = 0 then
    begin

      repeat

        S.LoadFromFile(AppPath+'Scripts\'+sr.Name);
        if (S.Count > 0) and ( S[0] = '//JCSTEMPSYS !Remove this comment if you edit the script') then
         begin
        Temp.FileName := AppPath+'Scripts\'+sr.Name;
        Temp.Title := FromString(Copy(S[4], 28, Length(S[4])-28-15));
        Temp.ShortCut := TextToShortCut(Copy(S[5], 26, Length(S[5])-27));
        Temp.Text := FromString(Copy(S[10], 20, Length(S[10])-21));
        Temp.Pos :=  StrToInt(Copy(S[11], 43, Length(S[11])-43));
        SetLength(Temps, High(Temps)+2);
        Temps[High(Temps)] := Temp;
         end;
               S.Clear;
      until FindNext(sr) <> 0;
      FindClose(sr);

    end;
    S.Free;

    UpdateTemplates;
    
	TempFileName := PChar(ExtractFilePath(Settings.FileName) + 'SettingsCopy.ini');
	CopyFile(PChar(Settings.FileName), PChar(TempFileName), False);
	fSettingsCopy := TMyIniFile.Create(TempFileName);
  for i := 0 to values.RowCount-2 do
     values.ItemProps[i].EditStyle := esEllipsis;
	with fSettingsCopy do
  begin
  	// Syntax Highlight
   JassSyn:= TSynEdit_JassSyn.Create(nil);
   DocumentFactory.InitJassSynColors(JassSyn);
   for i := 0 to High(JassSyn.ThemeStr) do
    begin
     values.InsertRow(JassSyn.ThemeStr[i], '', True);
    end;

   for i := 0 to DocumentFactory.JassSyn.Styles.Count-1 do
    begin
      JassA := THighlightStyle(DocumentFactory.JassSyn.Styles[i]);
      JassB:=THighlightStyle.Create(JassA.Keyword);
      JassB.Title := JassA.Title;
      if  JassB.Keyword then
      JassB.Names.Text :=  JassA.Names.Text;
      JassSyn.Styles.Add(JassB);
      cmbSSection.Items.Add(JassB.Title);

    end;
    c := ReadInteger('Jass', 'StyleCount', 0);
    if c = 0 then
      SynEditing(False)
    else
    begin
    for i := 0 to c-1 do
     begin
    cmbStyle.Items.Add(ReadString('JassStyle'+IntToStr(i), 'Title', ''));
     end;
    cmbStyle.ItemIndex := ReadInteger('Jass', 'UseStyle', 0);
    end;
    JassSyn.AssignStyleTree;
    JassSyn.LoadSynSettings;
    SynDemo.Highlighter := JassSyn;
    cmbStyle.ItemIndex := ReadInteger('Jass', 'UseStyle', 0); 
    // Native Files


    c := ReadInteger('JassFiles', 'Count', 0);
    for i := 0 to c-1 do
     begin
    lstNatives.Items.Add(ReadString('JassFiles', IntToStr(i), ''));
    lstNatives.Checked[i] := ReadBool('JassSyn', IntToStr(i), false);
     end;

    // File
    with TRegistry.Create do
     begin
     RootKey := HKEY_CLASSES_ROOT;
     for i := 0 to grpFiles.ControlCount-1 do
      begin
       if OpenKey(TCheckbox(grpFiles.Controls[i]).Caption, False) then
        begin
        if ReadString('') = 'JassCraft.File' then
        TCheckbox(grpFiles.Controls[i]).Checked := True
        else
        TCheckbox(grpFiles.Controls[i]).Checked := False;
        end
       else TCheckbox(grpFiles.Controls[i]).Checked := False;
      end;
     Free;
     end;

    // Read data
    chkOneCopy.Checked := ReadBool('General', 'OnlyOneCopy', False);
  	chkSaveWindowPos.Checked := ReadBool('General', 'SaveWindowPosition', False);
    chkReopenWorkspace.Checked := ReadBool('General', 'ReopenLastWorkspace', False);
    chkReopenLastFiles.Checked := ReadBool('General', 'ReopenLastFiles', False);
    chkCreateEmpty.Checked := ReadBool('General', 'CreateEmptyDocument', False);
    chkVSTheme.Checked := ReadBool('General', 'VSTheme', True);

		// Editor
    // Setup controls
    for i := 8 to 11 do
    begin
    	cmbInsertCaret.Items.Add(sStrings[i]);
      cmbOverwriteCaret.Items.Add(sStrings[i]);
    end;

    for i := 16 to 17 do
    	cmbFoldingButton.Items.Add(sStrings[i]);

    // Read data
    chkAutoIndent.Checked := ReadBool('Editor', 'AutoIndent', False);
    chkCodeFolding.Checked := ReadBool('Editor', 'CodeFolding', False);
    chkGroupUndo.Checked := ReadBool('Editor', 'GroupUndo', False);
    chkHighlightLine.Checked := ReadBool('Editor', 'HighlightActiveLine', False);
    chkHighlightGuides.Checked := ReadBool('Editor', 'HighlightIndentGuides', False);
    chkInsertMode.Checked := ReadBool('Editor', 'InsertMode', False);
    chkScrollPastEOF.Checked := ReadBool('Editor', 'ScrollPastEOF', False);
    chkScrollPastEOL.Checked := ReadBool('Editor', 'ScrollPastEOL', False);
    chkIndentGuides.Checked := ReadBool('Editor', 'ShowIndentGuides', False);
    chkSpecialCharacters.Checked := ReadBool('Editor', 'ShowSpecialCharacters', False);
    chkTabsToSpaces.Checked := ReadBool('Editor', 'TabsToSpaces', False);
    chkWordWrap.Checked := ReadBool('Editor', 'WordWrap', False);

    udExtraSpacing.Position := ReadInteger('Editor', 'ExtraLineSpacing', 0);
    udMaxUndo.Position := ReadInteger('Editor', 'MaximumUndo', 1024);
    cmbInsertCaret.ItemIndex := ReadInteger('Editor', 'InsertCaret', 0);
    cmbOverwriteCaret.ItemIndex := ReadInteger('Editor', 'OverwriteCaret', 0);
    cmbFoldingButton.ItemIndex := ReadInteger('Editor', 'FoldingButtonStyle', 0);
    udTabWidth.Position := ReadInteger('Editor', 'TabWidth', 4);
    dlgFont.Font.Name := ReadString('Editor', 'FontName', '');
    dlgFont.Font.Size := ReadInteger('Editor', 'FontSize', 10);
    btnFont.Caption := Format('Font: %s, %d',
    	[dlgFont.Font.Name, dlgFont.Font.Size]);

		chkShowGutter.Checked := ReadBool('Editor', 'ShowGutter', False);
    chkShowRightMargin.Checked := ReadBool('Editor', 'ShowRightMargin', False);
    chkShowLineNumbers.Checked := ReadBool('Editor', 'ShowLineNumbers', False);
    chkShowLeadingZeros.Checked := ReadBool('Editor', 'ShowLeadingZeros', False);
    chkZeroStart.Checked := ReadBool('Editor', 'ZeroStart', False);

		udRightMargin.Position := ReadInteger('Editor', 'RightMarginPosition', 80);
    cbGutter.Selected := ReadColor('Editor', 'GutterColor', clBtnFace);
    cbFoldingBar.Selected := ReadColor('Editor', 'FoldingBarColor', clDefault);
    cbFoldingLines.Selected := ReadColor('Editor', 'FoldingBarLinesColor', clDefault);

    // Jass
    chcFuncCase.Checked := ReadBool('Jass', 'FuncCase', True);
    chkEnterIndent.Checked := ReadBool('Jass', 'EnterIndent', True);
    chkParamLight.Checked := ReadBool('Jass', 'ParamLight', True);



    // Keyboard & Mouse
    // Setup controls
		with MainForm.actlMain do
    begin
    	lstKeyCat.Items.BeginUpdate;

    	try
    		for i := 0 to ActionCount - 1 do
      		if lstKeyCat.Items.IndexOf(Actions[i].Category) = -1 then
        		lstKeyCat.Items.Add(Actions[i].Category);

        if lstKeyCat.Count > 0 then
        begin
        	lstKeyCat.ItemIndex := 0;
          lstKeyCatClick(nil);
        end;
      finally
      	lstKeyCat.Items.EndUpdate;
      end;

      CommandNames := TStringList.Create;

      for i := 0 to ActionCount - 1 do
      	CommandNames.Add(Actions[i].Name);

      CommandNames.Sort;
    end;

  end;
end;

procedure SaveHighlightStyle(Ini:TMyIniFile; StyleNum:Integer; Style:THighlightStyle);
begin
 Ini.WriteColor('JassStyle'+IntToStr(StyleNum), Style.Title+'|BgColor', Style.BgColor);
 Ini.WriteColor('JassStyle'+IntToStr(StyleNum), Style.Title+'|FrColor', Style.Font.Color);
 Ini.WriteBool('JassStyle'+IntToStr(StyleNum), Style.Title+'|Bold', fsBold in Style.Font.Style);
 Ini.WriteBool('JassStyle'+IntToStr(StyleNum), Style.Title+'|Italic', fsItalic in Style.Font.Style);
 Ini.WriteBool('JassStyle'+IntToStr(StyleNum), Style.Title+'|Underline', fsUnderline in Style.Font.Style);
end;

procedure LoadHighlightStyle(Ini:TMyIniFile; StyleNum:Integer; Style:THighlightStyle);
begin
 Style.Font.Color := Ini.ReadColor('JassStyle'+IntToStr(StyleNum), Style.Title+'|FrColor', clBlack);
 Style.BgColor := Ini.ReadColor('JassStyle'+IntToStr(StyleNum), Style.Title+'|BgColor', clWhite);
 Style.Font.Style := [];
 if Ini.ReadBool('JassStyle'+IntToStr(StyleNum), Style.Title+'|Bold', false) then
    Style.Font.Style := Style.Font.Style + [fsBold];
 if Ini.ReadBool('JassStyle'+IntToStr(StyleNum), Style.Title+'|Italic', false) then
    Style.Font.Style := Style.Font.Style + [fsItalic];
 if Ini.ReadBool('JassStyle'+IntToStr(StyleNum), Style.Title+'|Underline', false) then
    Style.Font.Style := Style.Font.Style + [fsUnderline];
end;

procedure TOptionsDialog.btnOKClick(Sender: TObject);
var i:Integer;
S:TStringList;
sr:TSearchRec;
function ToString(S:String):String;
begin
Result := AnsiReplaceStr(S, '\', '\\');
Result := AnsiReplaceStr(Result, #13, '\r');
Result := AnsiReplaceStr(Result, #10, '\n');
Result := AnsiReplaceStr(Result, '"', '\"');
end;
begin
	with fSettingsCopy do
  begin

    // Templates
         S := TStringList.Create;


  if FindFirst(AppPath+'Scripts\*.jcs', faAnyFile	, sr) = 0 then
    begin

      repeat
        S.LoadFromFile(AppPath+'Scripts\'+sr.Name);
        if (S.Count > 0) and ( S[0] = '//JCSTEMPSYS !Remove this comment if you edit the script') then
         begin
        DeleteFile(AppPath+'Scripts\'+sr.Name)
         end;
        S.Clear;
      until FindNext(sr) <> 0;
      FindClose(sr);

    end;


    for i := 0 to High(Temps) do
     begin
     if Temps[i].FileName = '' then
        Temps[i].FileName := AppPath+'Scripts\'+Temps[i].Title+'.jcs';
     S.Add('//JCSTEMPSYS !Remove this comment if you edit the script');
     S.Add('function Init()');
     S.Add('{');
     S.Add('var int MenuItem');
     S.Add('Menu.CreateRoot(MenuItem, "'+ToString(Temps[i].Title)+'", "&Templates")');
     S.Add('Menu.Shortcut(MenuItem, "'+ShortcutToText(Temps[i].ShortCut)+'")');
     S.Add('Menu.OnClick(MenuItem, Click)');
     S.Add('}');
     S.Add('function Click()');
     S.Add('{');
     S.Add('JassCraft.SelText("'+ToString(Temps[i].Text)+'")');
     S.Add('JassCraft.SelStart(JassCraft.SelStart(-1)-'+IntToStr(Temps[i].Pos)+')');
     S.Add('}');
     S.SaveToFile(Temps[i].FileName);
     S.Clear;
     end;
     S.Free;

    // File Types
     with TRegistry.Create do
      begin
      RootKey := HKEY_CLASSES_ROOT;
      OpenKey('\JassCraft.File', True);
      WriteString('', 'JassCraft File');
      CloseKey;
      OpenKey('\JassCraft.File\DefaultIcon', True);
      WriteString('', '"'+Application.ExeName+'",1');
      CloseKey;
      OpenKey('\JassCraft.File\shell\Open\command', True);
      WriteString('', '"'+Application.ExeName+'" "%1"');
      CloseKey;
     for i := 0 to grpFiles.ControlCount-1 do
      begin
      if TCheckBox(grpFiles.Controls[i]).Checked then
       begin
       OpenKey('\'+TCheckBox(grpFiles.Controls[i]).Caption, True);
       WriteString('', 'JassCraft.File');
       CloseKey;
       end;
      end;
      Free;
      end;


  	// General
    WriteBool('General', 'OnlyOneCopy', chkOneCopy.Checked);
  	WriteBool('General', 'SaveWindowPosition', chkSaveWindowPos.Checked);
    WriteBool('General', 'ReopenLastWorkspace', chkReopenWorkspace.Checked);
    WriteBool('General', 'ReopenLastFiles', chkReopenLastFiles.Checked);
    WriteBool('General', 'CreateEmptyDocument', chkCreateEmpty.Checked);
    WriteBool('General', 'VSTheme', chkVSTheme.Checked);
    // Editor
    WriteBool('Editor', 'AutoIndent', chkAutoIndent.Checked);
    WriteBool('Editor', 'CodeFolding', chkCodeFolding.Checked);
    WriteBool('Editor', 'GroupUndo', chkGroupUndo.Checked);
    WriteBool('Editor', 'HighlightActiveLine', chkHighlightLine.Checked);
    WriteBool('Editor', 'HighlightIndentGuides', chkIndentGuides.Checked);
    WriteBool('Editor', 'InsertMode', chkInsertMode.Checked);
    WriteBool('Editor', 'ScrollPastEOF', chkScrollPastEOF.Checked);
    WriteBool('Editor', 'ScrollPastEOL', chkScrollPastEOL.Checked);
    WriteBool('Editor', 'ShowIndentGuides', chkIndentGuides.Checked);
    WriteBool('Editor', 'ShowSpecialCharacters', chkSpecialCharacters.Checked);
    WriteBool('Editor', 'TabsToSpaces', chkTabsToSpaces.Checked);
    WriteBool('Editor', 'WordWrap', chkWordWrap.Checked);

    WriteInteger('Editor', 'ExtraLineSpacing', udExtraSpacing.Position);
    WriteInteger('Editor', 'MaximumUndo', udMaxUndo.Position);
    WriteInteger('Editor', 'InsertCaret', cmbInsertCaret.ItemIndex);
    WriteInteger('Editor', 'OverwriteCaret', cmbOverwriteCaret.ItemIndex);
    WriteInteger('Editor', 'FoldingButtonStyle', cmbFoldingButton.ItemIndex);
    WriteInteger('Editor', 'TabWidth', udTabWidth.Position);
    WriteString('Editor', 'FontName', dlgFont.Font.Name);
    WriteInteger('Editor', 'FontSize', dlgFont.Font.Size);

    WriteBool('Editor', 'ShowGutter', chkShowGutter.Checked);
    WriteBool('Editor', 'ShowRightMargin', chkShowRightMargin.Checked);
    WriteBool('Editor', 'ShowLineNumbers', chkShowLineNumbers.Checked);
    WriteBool('Editor', 'ShowLeadingZeros', chkShowLeadingZeros.Checked);
    WriteBool('Editor', 'ZeroStart', chkZeroStart.Checked);
    WriteInteger('Editor', 'RightMarginPosition', udRightMargin.Position);
    WriteColor('Editor', 'GutterColor', cbGutter.Selected);
    WriteColor('Editor', 'FoldingBarColor', cbFoldingBar.Selected);
    WriteColor('Editor', 'FoldingBarLinesColor', cbFoldingLines.Selected);


    //Jass
    WriteBool('Jass', 'FuncCase', chcFuncCase.Checked);
    WriteBool('Jass', 'ParamLight', chkParamLight.Checked);
    WriteBool('Jass', 'EnterIndent', chkEnterIndent.Checked);
    if cmbStyle.ItemIndex <> -1 then
    WriteInteger('Jass', 'UseStyle', cmbStyle.ItemIndex);

    // Native Files
    WriteInteger('JassFiles', 'Count', lstNatives.Items.Count);
    for i := 0 to lstNatives.Items.Count-1 do
     begin
     WriteString('JassFiles', IntToStr(i), lstNatives.Items[i]);
     WriteBool('JassSyn', IntToStr(i), lstNatives.Checked[i]);
     end;


  end;

  DeleteFile(Settings.FileName);
  CopyFile(PChar(fSettingsCopy.FileName), PChar(Settings.FileName), False);

	ModalResult := mrOK;
end;

procedure TOptionsDialog.btnFontClick(Sender: TObject);
begin
	if dlgFont.Execute then
     btnFont.Caption := Format('Font: %s, %d',
    	[dlgFont.Font.Name, dlgFont.Font.Size]);
end;

procedure TOptionsDialog.lstKeyCatClick(Sender: TObject);
var
	i: Integer;
  Category,s: String;
  Action:TAction;
begin
	if lstKeyCat.ItemIndex <> -1 then
  begin
  	lstKeyCmd.Clear;
  	Category := lstKeyCat.Items[lstKeyCat.ItemIndex];

  	with MainForm.actlMain do
    	for i := 0 to ActionCount - 1 do
      	if SameText(Category, Actions[i].Category) then
         begin
         Action := TAction(Actions[i]);
         if Action.HelpKeyword <> '' then
         s := Action.HelpKeyword + ' -> ' +Action.Caption
         else s := Action.Caption;
        	lstKeyCmd.AddItem(s, Action);
         end;

    if lstKeyCmd.Count > 0 then
    begin
    	lstKeyCmd.ItemIndex := 0;
      lstKeyCmdClick(nil);
    end;  
  end;
end;

procedure TOptionsDialog.lstKeyCmdClick(Sender: TObject);
var
  Shortcut: String;
  P: Integer;
begin
  fSettingShortCut := True;
	Shortcut := fSettingsCopy.ReadString('Keyboard',
  	TAction(lstKeyCmd.Items.Objects[lstKeyCmd.ItemIndex]).Name, '');

  chkCtrl.Checked := Pos('Ctrl', Shortcut) > 0;
  chkShift.Checked := Pos('Shift', Shortcut) > 0;
  chkAlt.Checked := Pos('Alt', Shortcut) > 0;

  repeat
    P := Pos('+', Shortcut);
    
    if P = 0 then
      cmbShortCut.ItemIndex := cmbShortCut.Items.IndexOf(
        Copy(Shortcut, 1, MaxInt))
    else
      Delete(Shortcut, 1, P);
  until P = 0;

  fSettingShortCut := False;
  lblShortCutAssignedTo.Caption := '';
end;

procedure TOptionsDialog.FormDestroy(Sender: TObject);
var i:Integer;
begin
  DeleteFile(fSettingsCopy.FileName);
	CommandNames.Free;
   for i := 0 to JassSyn.Styles.Count-1 do
    begin
      THighlightStyle(JassSyn.Styles[i]).Free;
    end;
end;

procedure TOptionsDialog.btnCancelClick(Sender: TObject);
begin
	DeleteFile(fSettingsCopy.FileName);
  ModalResult := mrCancel;
end;

procedure TOptionsDialog.ShortcutAssigned;
var
	i: Integer;
  Shortcut: String;
begin
  lblShortCutAssignedTo.Caption := '';

  if not fSettingShortCut then
  begin
    Shortcut := ShortcutGet;

	  with MainForm.actlMain do
  	  for i := 0 to ActionCount - 1 do
  		  if (TAction(Actions[i]).ShortCut = TextToShortCut(Shortcut))
        and (Shortcut <> '') then
      	  lblShortCutAssignedTo.Caption := AnsiReplaceStr(TAction(Actions[i]).Caption, '&', '');
  end;
end;

procedure TOptionsDialog.ShortcutChanged;
begin
  if not fSettingShortCut then
	  fSettingsCopy.WriteString('Keyboard', TAction(lstKeyCmd.Items.Objects[lstKeyCmd.ItemIndex]).Name,
  	  ShortcutGet);
end;

function TOptionsDialog.ShortcutGet: String;
begin
  if chkCtrl.Checked then
    Result := 'Ctrl+';

  if chkShift.Checked then
    Result := Result + 'Shift+';

  if chkAlt.Checked then
    Result := Result + 'Alt+';

  if cmbShortCut.Items[cmbShortCut.ItemIndex] <> '' then
    Result := Result + cmbShortCut.Items[cmbShortCut.ItemIndex]
  else
    Result := '';
end;

procedure TOptionsDialog.chkCtrlClick(Sender: TObject);
begin
  ShortcutAssigned;
  ShortcutChanged;
end;

procedure TOptionsDialog.chkShiftClick(Sender: TObject);
begin
  ShortcutAssigned;
  ShortcutChanged;
end;

procedure TOptionsDialog.chkAltClick(Sender: TObject);
begin
  ShortcutAssigned;
  ShortcutChanged;
end;

procedure TOptionsDialog.cmbShortCutChange(Sender: TObject);
begin
  ShortcutAssigned;
  ShortcutChanged;
end;

procedure TOptionsDialog.lstKeyCmdDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
  var i:Integer;
  Text:String;
  Action:TAction;
  Icon:TIcon;

function CalcColorIndex(StartColor, EndColor: TColor; Steps, ColorIndex: Integer): TColor;
var
  BeginRGBValue: Array[0..2] of Byte;
  RGBDifference: Array[0..2] of Integer;
  Red, Green, Blue: Byte;
  NumColors: Integer;
begin
  if (ColorIndex < 1) or (ColorIndex > Steps) then
    raise ERangeError.Create('ColorIndex can''t be less than 1 or greater than ' + IntToStr(Steps));
  NumColors := Steps;
  Dec(ColorIndex);
  BeginRGBValue[0] := GetRValue(ColorToRGB(StartColor));
  BeginRGBValue[1] := GetGValue(ColorToRGB(StartColor));
  BeginRGBValue[2] := GetBValue(ColorToRGB(StartColor));
  RGBDifference[0] := GetRValue(ColorToRGB(EndColor)) - BeginRGBValue[0];
  RGBDifference[1] := GetGValue(ColorToRGB(EndColor)) - BeginRGBValue[1];
  RGBDifference[2] := GetBValue(ColorToRGB(EndColor)) - BeginRGBValue[2];

  // Calculate the bands color
  Red := BeginRGBValue[0] + MulDiv(ColorIndex, RGBDifference[0], NumColors - 1);
  Green := BeginRGBValue[1] + MulDiv(ColorIndex, RGBDifference[1], NumColors - 1);
  Blue := BeginRGBValue[2] + MulDiv(ColorIndex, RGBDifference[2], NumColors - 1);
  Result := RGB(Red, Green, Blue);
end;


begin
with lstKeyCmd.Canvas do
 begin
Text := lstKeyCmd.Items[Index];
if (ListCache = nil) then
 begin
  ListCache := TBitmap.Create;
  ListCache.Height := 22;
  ListCache.Width := 25;
  for i := 0 to 25 do
    begin
     ListCache.Canvas.Pen.Color := CalcColorIndex($fbfefe, $acc3c4, 26, i+1);
     ListCache.Canvas.MoveTo(i, 0);
     ListCache.Canvas.LineTo(i, ListCache.Height+1);
    end;
 end;

 Draw(0,Rect.Top, ListCache);
 Font.Color := clBlack;
 if odSelected in State then
  begin
  Pen.Color := $c56a31;
  Brush.Color := $eed2c1;
  Rectangle(Rect);
  end
 else
  begin
  Pen.Color := clWhite;
  Brush.Color := clWhite;
  Rect.Left := 25;
  FillRect(Rect);
  end;

 if Pos('&', Text) <> 0 then
  Delete(Text, Pos('&', Text), 1);

 TextOut(30, Rect.Top+5, Text);

 Action := TAction(lstKeyCmd.Items.Objects[Index]);
 if (Action.ImageIndex <> -1) and Assigned(Action.ActionList.Images) then
 if Action.ImageIndex < Action.ActionList.Images.Count then
   begin
   Icon := TIcon.Create;
   Action.ActionList.Images.GetIcon(Action.ImageIndex, Icon);
   Draw(4,Rect.Top+3, Icon);
   Icon.Free;
  end;

 Font.Color :=  $00000000;
 Brush.Color := $00000000;
 TextOut(0,0,'');

 end;
end;

procedure TOptionsDialog.cmbSSectionChange(Sender: TObject);
var  Att:THighlightStyle;
begin
 if cmbSSection.ItemIndex = -1 then Exit;
 Att := THighlightStyle(JassSyn.Styles[cmbSSection.ItemIndex]);
 clrBack.Selected := Att.BgColor;
 clrColor.Selected := Att.Font.Color;
 chkBold.Checked := fsBold in Att.Font.Style;
 chkItalic.Checked := fsItalic in Att.Font.Style;
 chkUnderline.Checked := fsUnderline in Att.Font.Style;
end;

procedure TOptionsDialog.UpdateJASSHighlight;
 var Att:THighlightStyle;
begin
 if cmbSSection.ItemIndex = -1 then Exit;
 if cmbStyle.ItemIndex = -1 then Exit;

 Att := THighlightStyle(JassSyn.Styles[cmbSSection.ItemIndex]);

 Att.Font.Style := [];
 if chkBold.Checked then
  Att.Font.Style := [fsBold] + Att.Font.Style;
 if chkItalic.Checked then
  Att.Font.Style := [fsItalic] + Att.Font.Style;
 if chkUnderline.Checked then
  Att.Font.Style := [fsUnderline] + Att.Font.Style;
 Att.Font.Color := clrColor.Selected;
 Att.BgColor := clrBack.Selected;

 fSettingsCopy.WriteColor('JassStyle'+IntToStr(cmbStyle.ItemIndex), Att.Title+'|BgColor', Att.BgColor);
 fSettingsCopy.WriteColor('JassStyle'+IntToStr(cmbStyle.ItemIndex), Att.Title+'|FrColor', Att.Font.Color);
 fSettingsCopy.WriteBool('JassStyle'+IntToStr(cmbStyle.ItemIndex), Att.Title+'|Bold', fsBold in Att.Font.Style);
 fSettingsCopy.WriteBool('JassStyle'+IntToStr(cmbStyle.ItemIndex), Att.Title+'|Italic', fsItalic in Att.Font.Style);
 fSettingsCopy.WriteBool('JassStyle'+IntToStr(cmbStyle.ItemIndex), Att.Title+'|Underline', fsUnderline in Att.Font.Style);

 JassSyn.LoadSynSettings;
 JassSyn.ApplyTheme(SynDemo);

end;

procedure TOptionsDialog.chkBoldClick(Sender: TObject);
begin
UpdateJASSHighlight;
end;

procedure TOptionsDialog.FormShow(Sender: TObject);
begin
cmbStyleChange(nil);
if tmpList.Items.Count > 0 then
tmpList.ItemIndex := 0;
tmpListClick(nil);
end;

procedure TOptionsDialog.styleAddClick(Sender: TObject);
var s:String;
begin
s := InputBox('Create Style', 'Name of the style:', '');
if s = '' then Exit;
fSettingsCopy.WriteString('JassStyle'+InttoStr(cmbStyle.Items.Count),'Title', s);
cmbStyle.Items.Add(s);
fSettingsCopy.WriteInteger('Jass', 'StyleCount', cmbStyle.Items.Count);
cmbStyle.ItemIndex := cmbStyle.Items.Count-1;
SynEditing(True);
end;

procedure TOptionsDialog.cmbStyleChange(Sender: TObject);
var i:Integer;
begin
 if cmbStyle.ItemIndex = -1 then Exit;

 for i := 0 to High(JassSyn.Theme) do
   begin
   JassSyn.Theme[i] := Settings.ReadColor('JassStyle'+IntToStr(cmbStyle.ItemIndex), JassSyn.ThemeStr[i], clWhite);
   values.ItemProps[i].EditMask := ColorToString(JassSyn.Theme[i]);
   end;

 for i := 0 to JassSyn.Styles.Count-1 do
  begin
 LoadHighlightStyle(fSettingsCopy, cmbStyle.ItemIndex, THighlightStyle(JassSyn.Styles[i]));
  end;
  
cmbSSection.ItemIndex := 0;
cmbSSectionChange(nil);
JassSyn.LoadSynSettings;
JassSyn.ApplyTheme(SynDemo);
end;

procedure TOptionsDialog.lstNativesClick(Sender: TObject);
begin
btnNFRemove.Enabled := (lstNatives.ItemIndex <> -1);
end;

procedure TOptionsDialog.btnNFAddClick(Sender: TObject);
begin
if dlgOpen.Execute then
 begin
 if ExtractFilePath(dlgOpen.FileName) = AppPath then
    lstNatives.Items.Add(ExtractFileName(dlgOpen.FileName))
 else
    lstNatives.Items.Add(dlgOpen.FileName);
 end;
end;

procedure TOptionsDialog.btnNFRemoveClick(Sender: TObject);
begin
if lstNatives.ItemIndex <> -1 then
lstNatives.Items.Delete(lstNatives.ItemIndex);
end;

procedure TOptionsDialog.valuesDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
if (ACol = 1) and (ARow <> 0) then
 with values.Canvas do
  begin
  Brush.Color := JassSyn.Theme[ARow-1];
  if values.Selection.Top = ARow then
  Rectangle(Rect)
  else
  FillRect(Rect);
  end;
end;

procedure TOptionsDialog.valuesDblClick(Sender: TObject);
begin
with TColorDialog.Create(nil) do
 begin
 Color := StringToColor(values.ItemProps[values.Selection.Top-1].EditMask);
 if Execute then
 begin
 values.ItemProps[values.Selection.Top-1].EditMask := ColorToString(Color);
 JassSyn.Theme[values.Selection.Top-1] := Color;
 fSettingsCopy.WriteColor('JassStyle'+IntToStr(cmbStyle.ItemIndex), JassSyn.ThemeStr[values.Selection.Top-1], Color);
 JassSyn.ApplyTheme(SynDemo);
 end;
 Free;
 end;
end;

procedure TOptionsDialog.tmpListClick(Sender: TObject);
begin
tmpData.Text := Temps[tmpList.ItemIndex].Text;
tmpTitle.Text := Temps[tmpList.ItemIndex].Title;
tmpShortcut.HotKey := Temps[tmpList.ItemIndex].ShortCut;
tmpData.SelStart := Length(tmpData.Text)-Temps[tmpList.ItemIndex].Pos;
tmpData.SelLength := 0;
if tmpData.CanFocus then
tmpData.SetFocus;
end;

procedure TOptionsDialog.tmpDataChange(Sender: TObject);
begin
if tmpList.ItemIndex = -1 then Exit;
Temps[tmpList.ItemIndex].Text := tmpData.Text;
end;

procedure TOptionsDialog.tmpTitleChange(Sender: TObject);
begin
if tmpList.ItemIndex = -1 then Exit;
Temps[tmpList.ItemIndex].Title := tmpTitle.Text;
end;

procedure TOptionsDialog.tmpShortcutChange(Sender: TObject);
begin
if tmpList.ItemIndex = -1 then Exit;
Temps[tmpList.ItemIndex].ShortCut := tmpShortcut.HotKey;
end;

procedure TOptionsDialog.Button1Click(Sender: TObject);
var Temp:TTemplate;
begin
Temp.Title := InputBox('JassCraft', 'Enter template name:', '');
if Temp.Title = '' then Exit;
SetLength(Temps, High(Temps)+2);
Temps[High(Temps)] := Temp;
UpdateTemplates;
end;

procedure TOptionsDialog.Button2Click(Sender: TObject);
var i:Integer;
begin
for i := tmpList.ItemIndex+1 to High(Temps) do
 Temps[i-1] := Temps[i];
SetLength(Temps, High(Temps));
UpdateTemplates;
end;

procedure TOptionsDialog.Button3Click(Sender: TObject);
begin
Temps[tmpList.ItemIndex].Pos := Length(tmpData.Text)-tmpData.SelStart;
end;

end.
