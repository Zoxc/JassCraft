
unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, JvDockControlForm, JvDockVIDStyle,
  SynEditPrint, JvTabBar, SynEditRegexSearch,
  SynEditMiscClasses, SynEditSearch, Menus, ImgList, ActnList,
  ComCtrls, ToolWin, uMyIniFiles, uMRU, uUtils, SynEditTypes, uDocuments,
  SynEdit, JvDockTree, JvComponentBase, TB2ExtItems, TBXExtItems, TB2Item,
  TBX, TB2Dock, TB2Toolbar, XPMan, JvDockVSNetStyle, uMPQ, JassUnit,
  SynJass, StrUtils, uScriptingEngine, StdActns, uSyntaxCheck;

type
  TMainForm = class(TForm)
    actlMain: TActionList;
    StatusBar: TStatusBar;
    FileNew: TAction;
    FileOpen: TAction;
    FileSave: TAction;
    FileSaveAs: TAction;
    FileSaveAll: TAction;
    actFileClose: TAction;
    FileCloseAll: TAction;
    FilePrint: TAction;
    FileExit: TAction;
    EditUndo: TAction;
    EditRedo: TAction;
    EditDelete: TAction;
    EditSelectAll: TAction;
    EditIndent: TAction;
    SearchFind: TAction;
    SearchFindNext: TAction;
    SearchReplace: TAction;
    SearchGoToLine: TAction;
    HelpTopics: TAction;
    ViewFont: TAction;
    ViewToolbar: TAction;
    ViewStatusBar: TAction;
    ViewShowGutter: TAction;
    ViewShowLineNumbers: TAction;
    ViewShowRightMargin: TAction;
    ViewWordWrap: TAction;
    ViewShowIndentGuides: TAction;
    ViewSettings: TAction;
    HelpAbout: TAction;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    dlgFont: TFontDialog;
    Search: TSynEditSearch;
    RegexSearch: TSynEditRegexSearch;
    ViewShowSpecialCharacters: TAction;
    SearchReplaceNext: TAction;
    EditDeleteWord: TAction;
    EditDeleteLine: TAction;
    EditDeleteToEndOfWord: TAction;
    EditDeleteToEndOfLine: TAction;
    EditDeleteWordBack: TAction;
    EditSelectWord: TAction;
    EditSelectLine: TAction;
    EditColumnSelect: TAction;
    tmrDelayClose: TTimer;
    DockServer: TJvDockServer;
    SearchFunctionList: TAction;
    EditChangeCaseUpper: TAction;
    EditChangeCaseLower: TAction;
    EditChangeCaseToggle: TAction;
    EditChangeCaseCapitalize: TAction;
    FileMRUClear: TAction;
    FileMRUOpenAll: TAction;
    MenuImageList: TImageList;
    Bookmarks: TImageList;
    CloseImage: TTBImageList;
    TopDock: TTBXDock;
    tbMain: TTBXToolbar;
    TBXItem1: TTBXItem;
    TBXSubmenuItem5: TTBXSubmenuItem;
    TBXMRUListItem1: TTBXMRUListItem;
    TBXItem3: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    TBXItem4: TTBXItem;
    TBXItem5: TTBXItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    TBXItem6: TTBXItem;
    TBXItem7: TTBXItem;
    TBXItem8: TTBXItem;
    MainMenu: TTBXToolbar;
    TBXSubmenuItem1: TTBXSubmenuItem;
    TBXItem2: TTBXItem;
    TBXItem9: TTBXItem;
    miReopen: TTBXSubmenuItem;
    TBXSeparatorItem7: TTBXSeparatorItem;
    TBXItem10: TTBXItem;
    TBXItem11: TTBXItem;
    TBXItem12: TTBXItem;
    TBXItem13: TTBXItem;
    TBXItem14: TTBXItem;
    TBXSeparatorItem8: TTBXSeparatorItem;
    Quit1: TTBXItem;
    TBXSubmenuItem2: TTBXSubmenuItem;
    TBXItem15: TTBXItem;
    TBXItem16: TTBXItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    TBXItem17: TTBXItem;
    TBXItem18: TTBXItem;
    TBXItem19: TTBXItem;
    TBXSeparatorItem4: TTBXSeparatorItem;
    TBXItem22: TTBXItem;
    TBXSubmenuItem3: TTBXSubmenuItem;
    TBXItem23: TTBXItem;
    TBXItem24: TTBXItem;
    FindNext1: TTBXItem;
    TBXSubmenuItem7: TTBXSubmenuItem;
    TBXItem20: TTBXItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    TBXSeparatorItem10: TTBXSeparatorItem;
    TBXSeparatorItem9: TTBXSeparatorItem;
    JvModernTabBarPainter: TJvModernTabBarPainter;
    TBXItem21: TTBXItem;
    TBXItem25: TTBXItem;
    TBXSubmenuItem6: TTBXSubmenuItem;
    TBXItem26: TTBXItem;
    TBXSeparatorItem12: TTBXSeparatorItem;
    TBXItem29: TTBXItem;
    TBXSubmenuItem9: TTBXSubmenuItem;
    TBXItem30: TTBXItem;
    TBXItem31: TTBXItem;
    TBXItem32: TTBXItem;
    TBXItem33: TTBXItem;
    TBXItem34: TTBXItem;
    TBXSubmenuItem10: TTBXSubmenuItem;
    TBXItem35: TTBXItem;
    TBXItem36: TTBXItem;
    TBXItem37: TTBXItem;
    TBXSeparatorItem13: TTBXSeparatorItem;
    TBXItem38: TTBXItem;
    TBXItem39: TTBXItem;
    TBXSeparatorItem14: TTBXSeparatorItem;
    TBXItem40: TTBXItem;
    TBXSeparatorItem15: TTBXSeparatorItem;
    TBXItem41: TTBXItem;
    TBXItem42: TTBXItem;
    TBXItem43: TTBXItem;
    TBXItem44: TTBXItem;
    TBXSeparatorItem16: TTBXSeparatorItem;
    TBXItem45: TTBXItem;
    TBXItem46: TTBXItem;
    TBXItem47: TTBXItem;
    TBXItem48: TTBXItem;
    TBXSeparatorItem17: TTBXSeparatorItem;
    TBXItem49: TTBXItem;
    TBXSubmenuItem4: TTBXSubmenuItem;
    TBXItem27: TTBXItem;
    XPManifest1: TXPManifest;
    mnuEditor: TTBXPopupMenu;
    TBXItem28: TTBXItem;
    TBXItem50: TTBXItem;
    TBXSeparatorItem6: TTBXSeparatorItem;
    TBXItem51: TTBXItem;
    TBXItem52: TTBXItem;
    TBXItem53: TTBXItem;
    TBXSeparatorItem18: TTBXSeparatorItem;
    TBXItem54: TTBXItem;
    TBXSeparatorItem19: TTBXSeparatorItem;
    TBXSubmenuItem8: TTBXSubmenuItem;
    TBXItem55: TTBXItem;
    TBXItem56: TTBXItem;
    TBXItem57: TTBXItem;
    TBXItem58: TTBXItem;
    TBXItem59: TTBXItem;
    TBXItem60: TTBXItem;
    TBXItem61: TTBXItem;
    TBXItem62: TTBXItem;
    TBXItem63: TTBXItem;
    TBXItem64: TTBXItem;
    TBXSubmenuItem11: TTBXSubmenuItem;
    TBXItem65: TTBXItem;
    TBXItem66: TTBXItem;
    TBXItem67: TTBXItem;
    TBXItem68: TTBXItem;
    TBXItem69: TTBXItem;
    TBXItem70: TTBXItem;
    TBXItem71: TTBXItem;
    TBXItem72: TTBXItem;
    TBXItem73: TTBXItem;
    TBXItem74: TTBXItem;
    TBXItem75: TTBXItem;
    JvDockVIDStyle1: TJvDockVSNetStyle;
    TBXItem76: TTBXItem;
    ViewNativeList: TAction;
    TBXSeparatorItem11: TTBXSeparatorItem;
    TBXSubmenuItem12: TTBXSubmenuItem;
    TBXItem77: TTBXItem;
    ToolsSyntaxCheck: TAction;
    SynCode: TSynEdit;
    actMPQEdit: TAction;
    TBXItem78: TTBXItem;
    SynCodeSplit: TSplitter;
    actFuncList: TAction;
    TBXItem79: TTBXItem;
    TBXSeparatorItem20: TTBXSeparatorItem;
    actCodeView: TAction;
    TBXItem81: TTBXItem;
    actInsertFromWE: TAction;
    actLoadFromWE: TAction;
    actSaveAllToWE: TAction;
    actSaveSelToWE: TAction;
    TBXSubmenuItem14: TTBXSubmenuItem;
    TBXItem82: TTBXItem;
    TBXItem83: TTBXItem;
    TBXSeparatorItem21: TTBXSeparatorItem;
    TBXItem84: TTBXItem;
    TBXItem85: TTBXItem;
    actRestoreOver: TAction;
    TBXSeparatorItem22: TTBXSeparatorItem;
    TBXItem86: TTBXItem;
    actInsertColor: TAction;
    TBXSeparatorItem23: TTBXSeparatorItem;
    TBXSeparatorItem24: TTBXSeparatorItem;
    TBXItem87: TTBXItem;
    TBXSeparatorItem25: TTBXSeparatorItem;
    ColorDialog: TColorDialog;
    pnlMain: TPanel;
    tbDocuments: TJvTabBar;
    pnlSyntax: TPanel;
    pnlBottomSplit: TSplitter;
    BottomTabBarPainter: TJvModernTabBarPainter;
    tbxWorkspaces: TTBXSubmenuItem;
    TBXSeparatorItem26: TTBXSeparatorItem;
    TBXItem88: TTBXItem;
    TBXItem89: TTBXItem;
    actWorkSpaceOpen: TAction;
    actWorkSpaceSave: TAction;
    dlgWorkSpace: TSaveDialog;
    actWorkSpaceClose: TAction;
    actWorkSpaceSaveAs: TAction;
    TBXItem90: TTBXItem;
    TBXItem91: TTBXItem;
    dlgWorkSpaceOpen: TOpenDialog;
    actWorkSpaceClearAll: TAction;
    TBXSeparatorItem27: TTBXSeparatorItem;
    TBXSeparatorItem28: TTBXSeparatorItem;
    TBXSubmenuItem15: TTBXSubmenuItem;
    TBXItem92: TTBXItem;
    TBXItem93: TTBXItem;
    actCommentSel: TAction;
    actUnCommentSel: TAction;
    TBXSubmenuItem16: TTBXSubmenuItem;
    TBXItem94: TTBXItem;
    TBXItem95: TTBXItem;
    checkout: TListBox;
    pnlSyntaxLeft: TPanel;
    btnStartSyntax: TButton;
    btnSyntaxClose: TButton;
    Label1: TLabel;
    TBXSeparatorItem30: TTBXSeparatorItem;
    tbLay: TTBXToolbar;
    TBXLabelItem1: TTBXLabelItem;
    layoutsel: TTBXComboBoxItem;
    TBXItem96: TTBXItem;
    TBXItem97: TTBXItem;
    TBXSeparatorItem31: TTBXSeparatorItem;
    actLayoutBar: TAction;
    TBXItem98: TTBXItem;
    mnuLay: TTBXSubmenuItem;
    TBXItem80: TTBXItem;
    templates: TTBXSubmenuItem;
    tbxCodeFold: TTBXSubmenuItem;
    TBXItem99: TTBXItem;
    TBXItem100: TTBXItem;
    TBXSeparatorItem29: TTBXSeparatorItem;
    TBXItem101: TTBXItem;
    TBXItem102: TTBXItem;
    EditSelectAll1: TEditSelectAll;
    AddHiddenGlobal: TAction;
    EditCut: TAction;
    EditCopy: TAction;
    EditPaste: TAction;
    procedure FileNewExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileOpenExecute(Sender: TObject);
    procedure FileSaveExecute(Sender: TObject);
    procedure FileSaveAsExecute(Sender: TObject);
    procedure FileSaveAllExecute(Sender: TObject);
    procedure actFileCloseExecute(Sender: TObject);
    procedure FileCloseAllExecute(Sender: TObject);
    procedure FileExitExecute(Sender: TObject);
    procedure EditUndoExecute(Sender: TObject);
    procedure EditRedoExecute(Sender: TObject);
    procedure EditCutExecute(Sender: TObject);
    procedure EditCopyExecute(Sender: TObject);
    procedure EditPasteExecute(Sender: TObject);
    procedure SaveLayout;
    procedure EditDeleteExecute(Sender: TObject);
    procedure EditSelectAllExecute(Sender: TObject);
    procedure EditIndentExecute(Sender: TObject);
    procedure EditUnindentExecute(Sender: TObject);
    procedure tbDocumentsTabSelected(Sender: TObject; Item: TJvTabBarItem);
    procedure tbDocumentsTabClosed(Sender: TObject; Item: TJvTabBarItem);
    procedure FileSaveUpdate(Sender: TObject);
    procedure FileSaveAllUpdate(Sender: TObject);
    procedure EditUndoUpdate(Sender: TObject);
    procedure ShowHide(Sender: TControl);
    procedure EditRedoUpdate(Sender: TObject);
    procedure ReadVisible;
    procedure MakeLayoutMenu;
    procedure SelAvailUpdate(Sender: TObject);
    procedure EditCopyUpdate(Sender: TObject);
    procedure EditPasteUpdate(Sender: TObject);
    procedure AnyDocumentOpenUpdate(Sender: TObject);
    procedure ViewToolbarExecute(Sender: TObject);
    procedure ViewStatusBarExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ViewShowGutterExecute(Sender: TObject);
    procedure ViewShowLineNumbersExecute(Sender: TObject);
    procedure ViewShowRightMarginExecute(Sender: TObject);
    procedure ViewWordWrapExecute(Sender: TObject);
    procedure ViewFontExecute(Sender: TObject);
    procedure ViewShowIndentGuidesExecute(Sender: TObject);
    procedure miEditorFont1Click(Sender: TObject);
    procedure ViewSettingsExecute(Sender: TObject);
    procedure RecentFilesClick(Sender: TObject);
    procedure ViewCollapseAllExecute(Sender: TObject);
    procedure ViewUncollapseAllExecute(Sender: TObject);
    procedure ViewCollapseLevel0Execute(Sender: TObject);
    procedure ViewUncollapseLevel0Execute(Sender: TObject);
    procedure SearchFindExecute(Sender: TObject);
    procedure SearchFindNextExecute(Sender: TObject);
    procedure SearchReplaceExecute(Sender: TObject);
    procedure SearchGoToLineExecute(Sender: TObject);
    procedure HelpTopicsExecute(Sender: TObject);
    procedure HelpAboutExecute(Sender: TObject);
    procedure ViewShowSpecialCharactersExecute(Sender: TObject);
    procedure SearchReplaceNextExecute(Sender: TObject);
    procedure FileWorkspaceOpenExecute(Sender: TObject);
    procedure FileWorkspaceSaveExecute(Sender: TObject);
    procedure FileWorkspaceSaveAsExecute(Sender: TObject);
    procedure FileWorkspaceCloseExecute(Sender: TObject);
    procedure FileWorkspaceSaveUpdate(Sender: TObject);
    procedure RecentWorkspacesClick(Sender: TObject);
    procedure ViewCollapseCurrentExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ViewOutputExecute(Sender: TObject);
    procedure ViewOutputUpdate(Sender: TObject);
    procedure EditDeleteWordExecute(Sender: TObject);
    procedure EditDeleteLineExecute(Sender: TObject);
    procedure EditDeleteToEndOfWordExecute(Sender: TObject);
    procedure EditDeleteToEndOfLineExecute(Sender: TObject);
    procedure EditDeleteWordBackExecute(Sender: TObject);
    procedure EditSelectWordExecute(Sender: TObject);
    procedure EditSelectLineExecute(Sender: TObject);
    procedure EditColumnSelectExecute(Sender: TObject);
    procedure EditColumnSelectUpdate(Sender: TObject);
    procedure tmrDelayCloseTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LoadLayout(S:String);
    procedure EditChangeCaseUpperExecute(Sender: TObject);
    procedure EditChangeCaseLowerExecute(Sender: TObject);
    procedure EditChangeCaseToggleExecute(Sender: TObject);
    procedure EditChangeCaseCapitalizeExecute(Sender: TObject);
    procedure FileMRUClearExecute(Sender: TObject);
    procedure FileWorkspaceMRUClearExecute(Sender: TObject);
    procedure FileMRUOpenAllExecute(Sender: TObject);
    procedure TBXSubmenuItem8Click(Sender: TObject);
    procedure TBXSubmenuItem11Click(Sender: TObject);
    procedure TBXItem55Click(Sender: TObject);
    procedure TBXItem65Click(Sender: TObject);
    procedure TBXItem75Click(Sender: TObject);
    procedure ViewNativeListExecute(Sender: TObject);
    procedure ViewNativeListUpdate(Sender: TObject);
    procedure ToolsSyntaxCheckExecute(Sender: TObject);
    procedure actMPQEditExecute(Sender: TObject);
    procedure actMPQEditUpdate(Sender: TObject);
    procedure ChangeMode(ToMode:TDocumentType);
    procedure OnKeyPress(Sender: TObject; var Key: Char);
    procedure actFuncListExecute(Sender: TObject);
    procedure actFuncListUpdate(Sender: TObject);
    procedure OnSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    procedure FindReplaceForm(Replace: Boolean);
    procedure OnScroll(Sender: TObject; ScrollBar: TScrollBarKind);
    procedure OnDblClick(Sender: TObject);
    procedure actCodeViewExecute(Sender: TObject);
    procedure actCodeViewUpdate(Sender: TObject);
    procedure actInsertFromWEExecute(Sender: TObject);
    procedure actLoadFromWEExecute(Sender: TObject);
    procedure actSaveAllToWEExecute(Sender: TObject);
    procedure actRestoreOverExecute(Sender: TObject);
    procedure actInsertColorExecute(Sender: TObject);
    procedure actWorkSpaceOpenExecute(Sender: TObject);
    procedure actWorkSpaceCloseExecute(Sender: TObject);
    procedure actWorkSpaceSaveAsExecute(Sender: TObject);
    procedure actWorkSpaceClearAllExecute(Sender: TObject);
    procedure actWorkSpaceCloseUpdate(Sender: TObject);
    procedure actWorkSpaceSaveExecute(Sender: TObject);
    procedure OnKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TBXItem92Click(Sender: TObject);
    procedure OnKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TBXItem93Click(Sender: TObject);
    procedure actCommentSelUpdate(Sender: TObject);
    procedure actCommentSelExecute(Sender: TObject);
    procedure actUnCommentSelExecute(Sender: TObject);
    procedure btnStartSyntaxClick(Sender: TObject);
    procedure btnSyntaxCloseClick(Sender: TObject);
    procedure checkoutDblClick(Sender: TObject);
    procedure ViewStatusBarUpdate(Sender: TObject);
    procedure ViewToolbarUpdate(Sender: TObject);
    procedure TBXItem97Click(Sender: TObject);
    procedure layoutselChange(Sender: TObject; const Text: String);
    procedure TBXItem96Click(Sender: TObject);
    procedure actLayoutBarUpdate(Sender: TObject);
    procedure actLayoutBarExecute(Sender: TObject);
    procedure mnuLayItemClick(Sender: TObject);
    procedure mnuLayClick(Sender: TObject);
    procedure TBXItem80Click(Sender: TObject);
    procedure mnuEditorPopup(Sender: TObject);
    procedure TBXItem99Click(Sender: TObject);
    procedure TBXItem100Click(Sender: TObject);
    procedure TBXItem101Click(Sender: TObject);
    procedure TBXItem102Click(Sender: TObject);
    procedure templatesClick(Sender: TObject);
  private
    { Private declarations }
    fWorkspaceFile: String;
    fWorkspaceModified: Boolean;
    procedure SetupDialogsFilter;
    procedure OpenWorkspace(FileName: String);
    procedure OnIdle(Sender: TObject; var Done: Boolean);
    procedure ReadSettings(FirstTime: Boolean = False);
    procedure WMOpenFile(var Message: TMessage); message WM_OPENFILE;
  public
    TEOverwritten:String;
    Layout:String;
    UseEnterIndent, UseParamLight:Boolean;
    { Public declarations }
    procedure StatusMsg(Msg: String; BackColor: TColor = -1;
    	TextColor: TColor = -1; TimeInterval: Integer = -1;
      DoBeep: Boolean = False);
    procedure UpdateMRUFilesMenu;
    procedure UpdateMRUWorkspacesMenu;
    procedure WmMButtonUp(var Message: TMessage); message WM_MBUTTONUP;
    procedure SaveAs(aDocument: TDocument = nil);
  end;


var
  MainForm: TMainForm;
  SynJass:TSynEdit_JassSyn;
  Settings: TMyIniFile;
  TEHandle:HWND;
  MRUFiles, MRUWorkspaces: TMRUList;
  frFindText, frReplaceText: String;
  frWholeWords, frMatchCase, frRegExp, frFromCursor, frPrompt,
  frInAll, frDirUp, frSelOnly: Boolean;

const
  idXYPanel = 0; // Luciano
  idModifiedPanel = 1;
  idInsertModePanel = 2;
  idCapsPanel = 3;
  idNumPanel = 4;
  idScrollPanel = 5;
  idDocTypePanel = 6;
  idDocSizePanel = 7;
  idMsgPanel = 8;

  function GetTEWindowHandle(S:String='Trigger Editor'):HWND;
  function GetTEJassEditorHandle(S:String='Trigger Editor'):HWND;
function GetTEJassText(var Text:String):Boolean;

implementation

uses uFind, uAbout, uReplace, uGoToLine, uProject,
	uOutput, uOptions, uNativeList, frmMPQEdit, uFuncInfo, uFuncList, uSplash;

{$R *.dfm}

function GetTEWindowHandle(S:String):HWND;
begin
  Result  := FindWindow(nil, PAnsiChar(S));
end;

function GetTEJassEditorHandle(S:String):HWND;
  function GetTextHandle(hTE: hwnd; lParam: Longint):Boolean; stdcall;
  var
    Buff  : array[0..255] of Char;

  begin
    Result  := True;
    GetClassName(hTE, Buff, 256);
    if Pos('Edit', Buff)>0 then
      TEHandle  := hTE;
  end;

var
  Hnd : HWND;

begin
  Hnd     := GetTEWindowHandle;
  TEHandle   := 0;
  Result  := 0;

  if Hnd=0 then
    Exit;
  EnumChildWindows(Hnd, @GetTextHandle, Integer(@Hnd));
  Result  := TEHandle;
end;

function GetTEJassText(var Text:String):Boolean;
var
  hTE : HWND;


begin
  hTE := GetTEJassEditorHandle;
  result  := hTE<>0;
  if not result then
    Exit;

  iL    := SendMessage(hTE, WM_GETTEXTLENGTH, 0, 0)+2;
  SetLength(Buff, iL);
  SendMessage(hTE, WM_GETTEXT, iL, Integer(@Buff[0]));
  Text  := StrPas(@Buff[0]);
end;

procedure TMainForm.FileNewExecute(Sender: TObject);
begin
	DocumentFactory.New;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  AppPath := IncludeTrailPathSep( ExtractFileDir(Application.ExeName) );
  if not FileExists(AppPath+'blizzard.j') then
   ExtractNatives(AppPath);

  Application.OnIdle := OnIdle;
  fWorkspaceFile := '';


  Settings := TMyIniFile.Create(AppPath + 'Settings.ini');
  Settings.WriteInteger('General', 'InstanceHandle', Handle);
  ReadSettings(True);


  SynJass:=TSynEdit_JassSyn.Create(nil);

  JassLib := TJassLib.Create;

  DocumentFactory := TDocumentFactory.Create;

  DocumentFactory.JassSyn.ApplyTheme(SynCode);

  // Docking windows
  OutputForm := TOutputForm.Create(Self);
  frmNative := TfrmNative.Create(Self);
  frmFuncList := TfrmFuncList.Create(Self);
  frmMPQ := TfrmMPQ.Create(Self);

  ScriptingEngineInit;

  LoadDockTreeFromFile(AppPath + 'Docking.ini');

  ReadVisible;


  end;

procedure TMainForm.MakeLayoutMenu;
var i:Integer;
Menu:TTBXItem;
begin

    while mnuLay.Count > 0 do
       mnuLay.Delete(0);

    for i := 0 to layoutsel.Strings.Count-1 do
      begin
      Menu := TTBXItem.Create(mnuLay);
      Menu.Caption := layoutsel.Strings[i];
      Menu.OnClick := mnuLayItemClick;
      mnuLay.Add(Menu);
      end;
      
end;

procedure TMainForm.ReadVisible;
var i,c:Integer;
begin
    c := Settings.ReadInteger('Layouts', 'Count', 0);
    for i := 0 to c-1 do
      begin
      layoutsel.Strings.Add(Settings.ReadString('Layouts', IntToStr(i), 'Default'));
      end;
    layoutsel.Text := Settings.ReadString('Layouts', 'Used', 'Default');

    LoadLayout(layoutsel.Text);
    MakeLayoutMenu;
    layoutsel.OnChange := layoutselChange;
end;

procedure TMainForm.FileOpenExecute(Sender: TObject);
var
	i: Integer;
begin
	SetupDialogsFilter;

	with dlgOpen do
  begin
    if Document <> nil then // Luciano
    	InitialDir := ExtractFileDir(Document.FileName);

  	if Execute then
    	for i := 0 to Files.Count - 1 do
      	DocumentFactory.Open( PChar(Files[i]), '');
  end;
end;

procedure TMainForm.FileSaveExecute(Sender: TObject);
begin
	if Document.Saved then
		Document.Save
  else
  	FileSaveAsExecute(nil);
end;

procedure TMainForm.FileSaveAsExecute(Sender: TObject);
begin
  SaveAs;
end;

procedure TMainForm.FileSaveAllExecute(Sender: TObject);
begin
	DocumentFactory.SaveAll;
end;

procedure TMainForm.actFileCloseExecute(Sender: TObject);
begin
	if Document <> nil then
  	tmrDelayClose.Enabled := True;
end;

procedure TMainForm.FileCloseAllExecute(Sender: TObject);
begin
	DocumentFactory.CloseAll;
end;

procedure TMainForm.FileExitExecute(Sender: TObject);
begin
	Close;
end;

procedure TMainForm.EditUndoExecute(Sender: TObject);
begin
if Document.Editor.Focused then
 begin
	Document.Undo;
 end;
end;

procedure TMainForm.EditRedoExecute(Sender: TObject);
begin
if Document.Editor.Focused then
 begin
	Document.Redo;
 end;
end;

procedure TMainForm.EditCutExecute(Sender: TObject);
begin

if Screen.ActiveControl is TSynEdit then
    (Screen.ActiveControl as TSynEdit).CutToClipboard
else if Screen.ActiveControl is TEdit then
    (Screen.ActiveControl as TEdit).CutToClipboard
else if Screen.ActiveControl is TComboBox then
    SendMessage((Screen.ActiveControl as TComboBox).Handle, WM_CUT, 0, 0);

end;

procedure TMainForm.EditCopyExecute(Sender: TObject);
begin

if Screen.ActiveControl is TSynEdit then
    (Screen.ActiveControl as TSynEdit).CopyToClipboard
else if Screen.ActiveControl is TEdit then
    (Screen.ActiveControl as TEdit).CopyToClipboard
else if Screen.ActiveControl is TComboBox then
    SendMessage((Screen.ActiveControl as TComboBox).Handle, WM_COPY, 0, 0);
end;

procedure TMainForm.EditPasteExecute(Sender: TObject);
begin
  if Screen.ActiveControl is TSynEdit then
    (Screen.ActiveControl as TSynEdit).PasteFromClipboard
  else if Screen.ActiveControl is TEdit then
    (Screen.ActiveControl as TEdit).PasteFromClipboard
  else if Screen.ActiveControl is TComboBox then
    SendMessage((Screen.ActiveControl as TComboBox).Handle, WM_PASTE, 0, 0);
end;

procedure TMainForm.EditDeleteExecute(Sender: TObject);
begin

  if Screen.ActiveControl is TSynEdit then
    SendMessage((Screen.ActiveControl as TSynEdit).Handle, WM_KEYDOWN, VK_DELETE, 0)
  else if Screen.ActiveControl is TEdit then
  SendMessage((Screen.ActiveControl as TEdit).Handle, WM_KEYDOWN, VK_DELETE, 0)
  else if Screen.ActiveControl is TComboBox then
    SendMessage((Screen.ActiveControl as TComboBox).Handle, WM_KEYDOWN, VK_DELETE, 0);
end;

procedure TMainForm.EditSelectAllExecute(Sender: TObject);
begin
if Document.Editor.Focused then
	Document.SelectAll;
end;

procedure TMainForm.EditIndentExecute(Sender: TObject);
begin
	Document.Indent;
end;

procedure TMainForm.EditUnindentExecute(Sender: TObject);
begin
	Document.Unindent;
end;

procedure TMainForm.tbDocumentsTabSelected(Sender: TObject;
  Item: TJvTabBarItem);
begin
	if Item <> nil then
   begin
		TDocument(Item.Data).Activate;
    TipForm.CloseToolTip;
   end
  else
   begin
     if GetFormVisible(frmFuncList) then
     frmFuncList.Clear;
   end;
end;

procedure TMainForm.tbDocumentsTabClosed(Sender: TObject;
  Item: TJvTabBarItem);
begin
	Document.Close;
end;

procedure TMainForm.FileSaveUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := (Document <> nil) and (Document.CanSave);
end;

procedure TMainForm.FileSaveAllUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := DocumentFactory.CanSaveAll;
end;

procedure TMainForm.EditUndoUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := (Document <> nil) and (Document.CanUndo);
end;

procedure TMainForm.EditRedoUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := (Document <> nil) and (Document.CanRedo);
end;

procedure TMainForm.SelAvailUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := (Document <> nil) and (Document.SelAvail);
end;

procedure TMainForm.EditCopyUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := (Document <> nil) and (Document.SelAvail);
end;

procedure TMainForm.EditPasteUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := (Document <> nil) and (Document.CanPaste);
end;

procedure TMainForm.AnyDocumentOpenUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := Document <> nil;
end;

procedure TMainForm.ViewToolbarExecute(Sender: TObject);
begin
  ShowHide(tbMain);
end;

procedure TMainForm.ViewStatusBarExecute(Sender: TObject);
begin
  ShowHide(StatusBar);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
	with Settings do
  begin
    // Window size/position
    if ReadBool('General', 'SaveWindowPosition', False) then
    begin
			WriteInteger('General', 'WindowState', Integer(WindowState));

    	if WindowState <> wsMaximized then
    	begin
      	WriteInteger('General', 'WindowLeft', Left);
      	WriteInteger('General', 'WindowTop', Top);
      	WriteInteger('General', 'WindowWidth', Width);
      	WriteInteger('General', 'WindowHeight', Height);
    	end;
    end;
  WriteInteger('General', 'SynCodeHeight', SynCode.Height);
  WriteInteger('General', 'SyntaxHeight', pnlSyntax.Height);
  SaveLayout;
  WriteString('Layouts', 'Used', Layoutsel.Text);
  SaveDockTreeToFile(AppPath + 'Docking.ini');

  //Docked windows
  frmNative.SaveSettings;

  // MRU stuff
	MRUFiles.Free;
  MRUWorkspaces.Free;

  // Other stuff
	Settings.Free;
    end;

end;

procedure TMainForm.ViewShowGutterExecute(Sender: TObject);
begin
	Settings.WriteBool('Editor', 'ShowGutter', ViewShowGutter.Checked);
  DocumentFactory.ReadAllFromIni;
end;

procedure TMainForm.ViewShowLineNumbersExecute(Sender: TObject);
begin
	Settings.WriteBool('Editor', 'ShowLineNumbers', ViewShowLineNumbers.Checked);
  DocumentFactory.ReadAllFromIni;
end;

procedure TMainForm.ViewShowRightMarginExecute(Sender: TObject);
begin
	Settings.WriteBool('Editor', 'ShowRightMargin', ViewShowRightMargin.Checked);
  DocumentFactory.ReadAllFromIni;
end;

procedure TMainForm.ViewWordWrapExecute(Sender: TObject);
begin
	Settings.WriteBool('Editor', 'WordWrap', ViewWordWrap.Checked);
  DocumentFactory.ReadAllFromIni;
end;

procedure TMainForm.ViewFontExecute(Sender: TObject);
begin
	with dlgFont do
  begin
  	Font.Name := Settings.ReadString('Editor', 'FontName', 'Courier New');
    Font.Size := Settings.ReadInteger('Editor', 'FontSize', 10);

  	if Execute then
    begin
			Settings.WriteString('Editor', 'FontName', Font.Name);
			Settings.WriteInteger('Editor', 'FontSize', Font.Size);
    end;
  end;

  DocumentFactory.ReadAllFromIni;
end;

procedure TMainForm.ViewShowIndentGuidesExecute(Sender: TObject);
begin
	Settings.WriteBool('Editor', 'ShowIndentGuides', ViewShowIndentGuides.Checked);
  DocumentFactory.ReadAllFromIni;
end;

procedure TMainForm.miEditorFont1Click(Sender: TObject);
var
	ItemCaption, FontName: String;
  FontSize: Integer;
begin
	ItemCaption := (Sender as TMenuItem).Caption;
  FontName := StringReplace( Copy( ItemCaption, 1, Pos(',', ItemCaption) - 1 ), '&', '', [] );
  FontSize := StrToInt( Copy( ItemCaption, Pos(',', ItemCaption) + 1, MaxInt ) );
	Settings.WriteString('Editor', 'FontName', FontName);
	Settings.WriteInteger('Editor', 'FontSize', FontSize);
  DocumentFactory.ReadAllFromIni;
end;

procedure TMainForm.ViewSettingsExecute(Sender: TObject);
begin
	with TOptionsDialog.Create(Self) do
  try
  	if ShowModal = mrOK then
    begin
      DocumentFactory.ReadAllFromIni;
    	ReadSettings;
    end;
  finally
  	Free;
  end;
end;

procedure TMainForm.UpdateMRUFilesMenu;
var
	i: Integer;
  TBXItem2: TTBXSeparatorItem;
  TBXItem: TTBXItem;
  s:String;
begin
  miReopen.Clear;
  for i := 0 to MRUFiles.Count - 1 do
  begin
  s := '';
    TBXItem := TTBXItem.Create(Self);
    if MRUFiles.AllItemsMPQ[i] <> '' then
       s := MRUFiles.AllItemsMPQ[i]+' | ';
    TBXItem.Caption := '&' + IntToStr(i) + #32 + s + MRUFiles[i];
    TBXItem.Tag := i;
    TBXItem.OnClick := RecentFilesClick;
    miReopen.Add(TBXItem);
  end;

  TBXItem2 := TTBXSeparatorItem.Create(Self);
  miReopen.Add(TBXItem2);
  TBXItem := TTBXItem.Create(Self);
  TBXItem.Action := FileMRUClear;
  miReopen.Add(TBXItem);
  TBXItem := TTBXItem.Create(Self);
  TBXItem.Action := FileMRUOpenAll;
  miReopen.Add(TBXItem);
end;

procedure TMainForm.RecentFilesClick(Sender: TObject);
begin
	DocumentFactory.Open( PChar(MRUFiles[(Sender as TTBXItem).Tag]), PChar(MRUFiles.AllItemsMPQ[(Sender as TTBXItem).Tag]) );
end;

procedure TMainForm.ViewCollapseAllExecute(Sender: TObject);
begin
	Document.CollapseAll;
end;

procedure TMainForm.ViewUncollapseAllExecute(Sender: TObject);
begin
	Document.UncollapseAll;
end;

procedure TMainForm.ViewCollapseLevel0Execute(Sender: TObject);
begin
	Document.CollapseLevel( (Sender as TAction).Tag );
end;

procedure TMainForm.ViewUncollapseLevel0Execute(Sender: TObject);
begin
	Document.UncollapseLevel( (Sender as TAction).Tag );
end;

procedure TMainForm.SearchFindExecute(Sender: TObject);
begin
	FindReplaceForm(False);
end;

procedure TMainForm.SearchFindNextExecute(Sender: TObject);
begin
	if frFindText <> '' then
		if not Document.FindNext then
      StatusMsg( PChar( Format(msgNotFound, [frFindText]) ), ErrorMsgColor, clWhite,
      	4000, False );
end;

procedure TMainForm.SearchReplaceExecute(Sender: TObject);
begin
	FindReplaceForm(True);
end;

procedure TMainForm.SearchGoToLineExecute(Sender: TObject);
begin
	with TGoToLineDialog.Create(Self) do
  try
  	if ShowModal = mrOk then
    	Document.GoToLine( StrToInt(txtLine.Text) );
  finally
  	Free;
  end;
end;

procedure TMainForm.HelpTopicsExecute(Sender: TObject);
begin
//
end;

procedure TMainForm.HelpAboutExecute(Sender: TObject);
begin
	with TAboutDialog.Create(Self) do
  try
  	ShowModal;
  finally
  	Free;
  end;
end;

procedure TMainForm.ViewShowSpecialCharactersExecute(Sender: TObject);
begin
	Settings.WriteBool('Editor', 'ShowSpecialChars', ViewShowSpecialCharacters.Checked);
  DocumentFactory.ReadAllFromIni;
end;

procedure TMainForm.SearchReplaceNextExecute(Sender: TObject);
begin
	if frFindText <> '' then
		if not Document.ReplaceNext then
  		StatusMsg( PChar( Format(msgNotFound, [frFindText]) ), ErrorMsgColor, clWhite,
      	4000, False );
end;

procedure TMainForm.FindReplaceForm(Replace: Boolean);
begin
	if Replace then
  	FindDialog := TReplaceDialog.Create(Self)
  else
  	FindDialog := TFindDialog.Create(Self);

  FindDialog.chkWhole.Checked := frWholeWords;
  FindDialog.chkCase.Checked := frMatchCase;
  FindDialog.chkRegExp.Checked := frRegExp;
  FindDialog.chkFromCursor.Checked := frFromCursor;
  FindDialog.chkInAll.Checked := frInAll;
  FindDialog.rbUp.Checked := frDirUp;
  FindDialog.rbDown.Checked := not frDirUp;

  if Document.SelAvail then
  	FindDialog.chkSelOnly.Checked := True
  else
  	FindDialog.chkSelOnly.Enabled := False;

  if Replace then
  	with TReplaceDialog(FindDialog) do
    begin
    	chkPrompt.Checked := frPrompt;
    end;

	FindDialog.Show;
end;

procedure TMainForm.StatusMsg(Msg: String; BackColor, TextColor: TColor;
  TimeInterval: Integer; DoBeep: Boolean);
begin
	{if BackColor = -1 then
  	fStatusBarColor := clBtnFace
  else
  begin
  	fStatusBarColor := BackColor;
    StatusBar.Panels[idMsgPanel].Style := psOwnerDraw;
  end;

	if TextColor = -1 then
  	fStatusBarTextColor := clWindowText
  else
  begin
  	fStatusBarTextColor := TextColor;
    StatusBar.Panels[idMsgPanel].Style := psOwnerDraw;
  end;

	if TimeInterval <> -1 then
  begin
  	tmrStatusBar.Interval := TimeInterval;
  	tmrStatusBar.Enabled := True;
  end;  }

	StatusBar.Panels[idMsgPanel].Text := Msg;

  if DoBeep then
  	Beep;
end;

procedure TMainForm.SetupDialogsFilter;
var

  Filter,DefaultExt: String;
begin
  Filter := 'Wc3 files (*.j;*.ai;*.mdl;)|*.j;*.ai;*.mdl;|All files (*.*)|*.*';
  DefaultExt := '*.j;*.ai;*.mdl;';
  dlgOpen.DefaultExt := DefaultExt;
  dlgSave.DefaultExt := DefaultExt;
	dlgOpen.Filter := Filter;
	dlgSave.Filter := Filter;
end;

procedure TMainForm.FileWorkspaceOpenExecute(Sender: TObject);
begin
	with dlgOpen do
  begin
  	Filter := 'Mystix workspace (*.mws)|*.mws|';

    if Execute then
    begin
    	DocumentFactory.CloseAll;
    	OpenWorkspace(FileName);
    end;
  end;
end;

procedure TMainForm.FileWorkspaceSaveExecute(Sender: TObject);
var
	i: Integer;
	WorkspaceFiles: TStringList;
begin
	if fWorkspaceFile = '' then
  	FileWorkspaceSaveAsExecute(nil)
  else
  begin
  	fWorkspaceModified := False;
  	WorkspaceFiles := TStringList.Create;

    try
    	for i := 0 to DocumentFactory.Count - 1 do
      	WorkspaceFiles.Add(DocumentFactory.Documents[i].FileName);

      WorkspaceFiles.SaveToFile(fWorkspaceFile);
    finally
    	WorkspaceFiles.Free;
    end;
	end;
end;

procedure TMainForm.FileWorkspaceSaveAsExecute(Sender: TObject);
begin
	with dlgSave do
  begin
  	Filter := 'Mystix workspace (*.mws)|*.mws|';
    DefaultExt := 'mws';

    if Execute then
    begin
    	fWorkspaceFile := FileName;
      fWorkspaceModified := False;
      Caption := Copy( ExtractFileName(fWorkspaceFile) , 1,
      	Length( ExtractFileName(fWorkspaceFile) ) - 4 ) + ' - Mystix';
      FileWorkspaceSaveExecute(nil);
    end;
  end;
end;

procedure TMainForm.FileWorkspaceCloseExecute(Sender: TObject);
var
	i: Integer;
const
	sMessage = 'Do you want to save changes in current workspace?';
begin
	if fWorkspaceModified then
  	if Application.MessageBox(sMessage, 'Confirm', MB_ICONQUESTION or MB_YESNO) = IDYES then
    	FileWorkspaceSaveExecute(nil);

	for i := DocumentFactory.Count - 1 downto 0 do
  	if DocumentFactory.Documents[i].Saved then
    	DocumentFactory.Documents[i].Close;

  MRUWorkspaces.Add(fWorkspaceFile, '');
  UpdateMRUWorkspacesMenu;
  fWorkspaceFile := '';
  Caption := 'Mystix';
end;

procedure TMainForm.FileWorkspaceSaveUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := fWorkspaceFile <> '';
end;

procedure TMainForm.UpdateMRUWorkspacesMenu;
var
	i: Integer;
  MenuItem: TTBXItem;
  Sep:TTBXSeparatorItem;
begin
  for i := tbxWorkspaces.Count - 1 downto 5 do
  	tbxWorkspaces.Delete(i);

  for i := 0 to MRUWorkspaces.Count - 1 do
  begin
  	MenuItem := TTBXItem.Create(Self);
    MenuItem.Caption := '&' + IntToStr(i) + #32 + MRUWorkspaces[i];
    MenuItem.Tag := i;
    MenuItem.OnClick := RecentWorkspacesClick;
    tbxWorkspaces.Add(MenuItem);
  end;

  Sep := TTBXSeparatorItem.Create(Self);
  tbxWorkspaces.Add(Sep);
  MenuItem := TTBXItem.Create(Self);
  MenuItem.Action := actWorkSpaceClearAll;
  tbxWorkspaces.Add(MenuItem);
end;

procedure TMainForm.RecentWorkspacesClick(Sender: TObject);
begin
	OpenWorkspace( PChar(MRUWorkspaces[(Sender as TTBXItem).Tag]) );
end;

procedure TMainForm.OpenWorkspace(FileName: String);
var
	WorkspaceFiles: TMyIniFile;
  i: Integer;
begin
	if DocumentFactory.CloseAll then
  begin
 	fWorkspaceFile := FileName;
	fWorkspaceModified := False;
  WorkspaceFiles := TMyIniFile.Create(FileName);
	i := 1;
	while WorkspaceFiles.ValueExists('Main', 'File' + IntToStr(i)) do
	begin
    if FileExists(WorkspaceFiles.ReadString('Main', 'File' + IntToStr(i), '')) then
    DocumentFactory.Open( WorkspaceFiles.ReadString('Main', 'File' + IntToStr(i), ''), WorkspaceFiles.ReadString('Main', 'FileMPQ' + IntToStr(i), '') );
		Inc(i);
	end;
  WorkspaceFiles.Free;
  end;
end;

procedure TMainForm.ViewCollapseCurrentExecute(Sender: TObject);
begin
	Document.CollapseCurrent;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i, j: Integer;
begin
  if fWorkspaceFile <> '' then
    Settings.WriteString('General', 'LastWorkspace', fWorkspaceFile)
  else
  begin
    Settings.EraseSection('LastOpenFiles');
    j := 0;

    for i := 0 to DocumentFactory.Count - 1 do
      if DocumentFactory[i].Saved then
      begin
        Settings.WriteString('LastOpenFiles', IntToStr(j),
          DocumentFactory[i].FileName);
        Settings.WriteString('LastOpenFilesMPQ', IntToStr(j),
          DocumentFactory[i].FileInMPQ);
        Inc(j);
      end;
  end;

	CanClose := DocumentFactory.CloseAll;
end;

procedure TMainForm.OnIdle(Sender: TObject; var Done: Boolean);
begin // Luciano
  if GetKeyState(VK_NUMLOCK) = 1 then
    StatusBar.Panels[idNumPanel].Text := 'NUM'
  else
    StatusBar.Panels[idNumPanel].Text := '';

  if GetKeyState(VK_CAPITAL) = 1 then
    StatusBar.Panels[idCapsPanel].Text := 'CAPS'
  else
    StatusBar.Panels[idCapsPanel].Text := '';

  if GetKeyState(VK_SCROLL) = 1 then
    StatusBar.Panels[idScrollPanel].Text := 'SCRL'
  else
    StatusBar.Panels[idScrollPanel].Text := '';
end;

procedure TMainForm.ViewOutputExecute(Sender: TObject);
begin
	if GetFormVisible(OutputForm) then
  	HideDockForm(OutputForm)
  else
  	ShowDockForm(OutputForm);
end;

procedure TMainForm.ViewOutputUpdate(Sender: TObject);
begin
	(Sender as TAction).Checked := GetFormVisible(OutputForm);
end;

procedure TMainForm.EditDeleteWordExecute(Sender: TObject);
begin
	Document.DeleteWord;
end;

procedure TMainForm.EditDeleteLineExecute(Sender: TObject);
begin
	Document.DeleteLine;
end;

procedure TMainForm.EditDeleteToEndOfWordExecute(Sender: TObject);
begin
	Document.DeleteToEndOfWord;
end;

procedure TMainForm.EditDeleteToEndOfLineExecute(Sender: TObject);
begin
	Document.DeleteToEndOfLine;
end;

procedure TMainForm.EditDeleteWordBackExecute(Sender: TObject);
begin
	Document.DeleteWordBack;
end;

procedure TMainForm.EditSelectWordExecute(Sender: TObject);
begin
	Document.SelectWord;
end;

procedure TMainForm.EditSelectLineExecute(Sender: TObject);
begin
	Document.SelectLine;
end;

procedure TMainForm.EditColumnSelectExecute(Sender: TObject);
begin
	Document.ColumnSelect;
end;

procedure TMainForm.EditColumnSelectUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := Document <> nil;

  if (Sender as TAction).Enabled then
  	(Sender as TAction).Checked := Document.Editor.SelectionMode = smColumn;
end;

procedure TMainForm.tmrDelayCloseTimer(Sender: TObject);
begin
	tmrDelayClose.Enabled := False;
	Document.Close;
end;

procedure TMainForm.ReadSettings(FirstTime: Boolean = False);
var
	i: Integer;
//  LanguageFiles: TStringList;
begin
	with Settings do
  begin

    UseEnterIndent := ReadBool('Jass', 'EnterIndent', True);
    if Assigned(DocumentFactory) then
    DocumentFactory.JassSyn.ApplyTheme(SynCode);
    // Visible Stuff
    if ReadBool('General', 'VSTheme', True) then
      TBXSetTheme('Office2003')
    else TBXSetTheme('Default');

    // Read MRU
    MRUFiles := TMRUList.Create(Settings, 10, 'MRUFiles');
    UpdateMRUFilesMenu;
    MRUWorkspaces := TMRUList.Create(Settings, 10, 'MRUWorkspaces');
    UpdateMRUWorkspacesMenu;

  	// Read general settings
    if (FirstTime) and (ReadBool('General', 'SaveWindowPosition', False)) then
    begin
    	WindowState := TWindowState(ReadInteger('General', 'WindowState', 2));

    	if WindowState = wsMinimized then
    		WindowState := wsMaximized;

    	if WindowState <> wsMaximized then
    	begin
    		Left := ReadInteger('General', 'WindowLeft', 0);
    		Top := ReadInteger('General', 'WindowTop', 0);
    		Width := ReadInteger('General', 'WindowWidth', Screen.Width div 2);
    		Height := ReadInteger('General', 'WindowHeight', Screen.Height div 2);
    	end;
    end;
    SynCode.Height := ReadInteger('General', 'SynCodeHeight', 200);
    pnlSyntax.Height := ReadInteger('General', 'SyntaxHeight', 86);


    // Read editor settings
    ViewShowGutter.Checked := ReadBool('Editor', 'ShowGutter', True);
    ViewShowLineNumbers.Checked := ReadBool('Editor', 'ShowLineNumbers', True);
    ViewShowRightMargin.Checked := ReadBool('Editor', 'ShowRightMargin', True);
    ViewShowSpecialCharacters.Checked := ReadBool('Editor', 'ShowSpecialChars', True);
    ViewWordWrap.Checked := ReadBool('Editor', 'WordWrap', True);
    ViewShowIndentGuides.Checked := ReadBool('Editor', 'ShowIndentGuides', True);

    // Read open/save dialog filters
    SetupDialogsFilter;

    // Read shortcuts
    for i := 0 to actlMain.ActionCount - 1 do
    	TAction(actlMain.Actions[i]).ShortCut := TextToShortCut(ReadString('Keyboard',
      	actlMain.Actions[i].Name, ''));

  end;
end;

procedure TMainForm.WmMButtonUp(var Message: TMessage);
var
	Action: TAction;
begin
  try
    Action := TAction(FindComponent(Settings.ReadString('Mouse', 'MiddleButton', '')));

    if Action.Enabled then
      Action.OnExecute(Action);
  except end;
end;

procedure TMainForm.SaveAs(aDocument: TDocument);
var
	DefExt, Buffer: String;
  i, p: Integer;
begin
  if aDocument = nil then
    aDocument := Document;
    
	SetupDialogsFilter;

	with dlgSave do
  begin
    if aDocument.Saved then
      FileName := ExtractFileName(aDocument.FileName)
    else
      FileName := aDocument.FileName;

		if Execute then
    begin
    	if ExtractFileExt(FileName) = '' then
      begin
      	Buffer := Filter;
      	i := 1;

        while i < FilterIndex do
        begin
        	p := Pos('|*.', Buffer);
          Delete(Buffer, 1, p + 2);
          p := Pos('|', Buffer);
          Delete(Buffer, 1, p);
          Inc(i);
        end;

        p := Pos('|*.', Buffer);
        Delete(Buffer, 1, p + 2);

        i := 1;

        while not (Buffer[i] in [';', '|']) do
        	Inc(i);

        DefExt := Copy(Buffer, 1, i - 1);

        if DefExt = '*' then
        	DefExt := Settings.ReadString('General', 'DefaultExtension', 'txt');

        DefExt := '.' + DefExt;
      end
      else
      	DefExt := '';

    	aDocument.Saved := True;
      aDocument.FileName := FileName + DefExt;
      aDocument.Save;
    end;
  end;
end;

procedure TMainForm.LoadLayout(S:String);
begin
if S = Layout then Exit;
Layout := S;

    frmNative.Hide;
    frmFuncList.Hide;
    frmMPQ.Hide;
    Application.ProcessMessages;
  StatusBar.Visible := False;
  SynCode.Visible := False;
  SynCodeSplit.Visible := False;

    MainMenu.Hide;
    tbMain.Visible := Settings.ReadBool('Layout_'+S, 'tbMain', True);
    tbLay.Visible := Settings.ReadBool('Layout_'+S, 'tbLay', True);
    MainMenu.Show;

    StatusBar.Visible := Settings.ReadBool('Layout_'+S, 'StatusBar', True);
    SynCode.Visible := Settings.ReadBool('Layout_'+S, 'SynCode', True);

    if Settings.ReadBool('Layout_'+S, 'frmMPQ', True) then ShowDockForm(frmMPQ)
    else HideDockForm(frmMPQ);

    if Settings.ReadBool('Layout_'+S, 'frmFuncList', True) then ShowDockForm(frmFuncList)
    else HideDockForm(frmFuncList);


    if Settings.ReadBool('Layout_'+S, 'frmNative', True) then ShowDockForm(frmNative)
    else HideDockForm(frmNative);

end;

procedure TMainForm.SaveLayout;
begin
Settings.WriteBool('Layout_'+Layout, 'StatusBar', StatusBar.Visible);
Settings.WriteBool('Layout_'+Layout, 'tbMain', tbMain.Visible);
Settings.WriteBool('Layout_'+Layout, 'tbLay', tbLay.Visible);
Settings.WriteBool('Layout_'+Layout, 'frmNative', frmNative.Visible);
Settings.WriteBool('Layout_'+Layout, 'frmMPQ', frmMPQ.Visible);
Settings.WriteBool('Layout_'+Layout, 'frmFuncList', frmFuncList.Visible);
Settings.WriteBool('Layout_'+Layout, 'SynCode', SynCode.Visible);
end;

procedure TMainForm.ShowHide(Sender: TControl);
begin
if Sender is TForm then
 begin
 
 if GetFormVisible(Sender as TForm) then
 HideDockForm(Sender as TForm)
 else ShowDockForm(Sender as TForm);

 end
else
Sender.Visible := not Sender.Visible;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  i: Integer;
  Names: TStringList;
begin
  if Settings.ReadBool('General', 'ReopenLastWorkspace', False) then
    OpenWorkspace(Settings.ReadString('General', 'LastWorkspace', ''))
  else if Settings.ReadBool('General', 'ReopenLastFiles', False) then
  begin
    Names := TStringList.Create;

    try
      Settings.ReadSection('LastOpenFiles', Names);

      for i := 0 to Names.Count - 1 do
       begin
       if FileExists(Settings.ReadString('LastOpenFiles', Names[i], '')) then
        DocumentFactory.Open(Settings.ReadString('LastOpenFiles', Names[i], ''), Settings.ReadString('LastOpenFilesMPQ', Names[i], ''));
       end;
    finally
      Names.Free;
    end;
  end
  else if Settings.ReadBool('General', 'CreateEmptyDocument', False) then
    DocumentFactory.New;

  for i := 1 to ParamCount do
    DocumentFactory.Open(ParamStr(i), '');

  SynCode.Highlighter := DocumentFactory.JassSyn;

  frmSplash.Timer.Enabled := True;


end;

procedure TMainForm.EditChangeCaseUpperExecute(Sender: TObject);
begin
  Document.UpperCase;
end;

procedure TMainForm.EditChangeCaseLowerExecute(Sender: TObject);
begin
  Document.LowerCase;
end;

procedure TMainForm.EditChangeCaseToggleExecute(Sender: TObject);
begin
  Document.ToggleCase;
end;

procedure TMainForm.EditChangeCaseCapitalizeExecute(Sender: TObject);
begin
  Document.Capitalize;
end;

procedure TMainForm.FileMRUClearExecute(Sender: TObject);
begin
  MRUFiles.Clear;
  UpdateMRUFilesMenu;
end;

procedure TMainForm.FileWorkspaceMRUClearExecute(Sender: TObject);
begin
  MRUWorkspaces.Clear;
  UpdateMRUWorkspacesMenu;
end;

procedure TMainForm.FileMRUOpenAllExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to MRUFiles.Count - 1 do
    DocumentFactory.Open(MRUFiles[i], '');
end;

procedure TMainForm.WMOpenFile(var Message: TMessage);
var
	FileName: PChar;
begin
	SetForegroundWindow(Self.Handle);
	BringWindowToTop(Self.Handle);
	GetMem(FileName, 255);
	GlobalGetAtomName(Message.wParam, FileName, 255);
	DocumentFactory.Open(FileName, '');
	GlobalDeleteAtom(Message.wParam);
	FreeMem(FileName);
end;

procedure TMainForm.TBXSubmenuItem8Click(Sender: TObject);
var i:Integer;
begin
for i := 0 to TTBXSubmenuItem(Sender).Count-1  do
 TTBXSubmenuItem(Sender).Items[i].Checked := Document.Editor.IsBookmark(TTBXSubmenuItem(Sender).Items[i].Tag);

end;

procedure TMainForm.TBXSubmenuItem11Click(Sender: TObject);
var i:Integer;
begin
for i := 0 to TTBXSubmenuItem(Sender).Count-1  do
 TTBXSubmenuItem(Sender).Items[i].Enabled := Document.Editor.IsBookmark(TTBXSubmenuItem(Sender).Items[i].Tag);

end;

procedure TMainForm.TBXItem55Click(Sender: TObject);
begin
if Document.Editor.IsBookmark(TTBXItem(Sender).Tag) then
    Document.Editor.ClearBookMark(TTBXItem(Sender).Tag)
else
Document.Editor.SetBookMark(TTBXItem(Sender).Tag, Document.Editor.CaretX, Document.Editor.CaretY);
end;

procedure TMainForm.TBXItem65Click(Sender: TObject);
begin
Document.Editor.GotoBookMark(TTBXItem(Sender).Tag);
end;

procedure TMainForm.TBXItem75Click(Sender: TObject);
var i:Integer;
begin
for i := 0 to 9 do
Document.Editor.ClearBookMark(i);
end;

procedure TMainForm.ViewNativeListExecute(Sender: TObject);
begin
  ShowHide(frmNative);
end;

procedure TMainForm.ViewNativeListUpdate(Sender: TObject);
begin
(Sender as TAction).Checked := GetFormVisible(frmNative);
end;

procedure TMainForm.ToolsSyntaxCheckExecute(Sender: TObject);
begin
  pnlSyntax.Show;
  pnlBottomSplit.Show;
  if btnStartSyntax.Caption = 'Start' then
  btnStartSyntaxClick(nil);
end;

procedure TMainForm.actMPQEditExecute(Sender: TObject);
begin
  ShowHide(frmMPQ);
end;

procedure TMainForm.actMPQEditUpdate(Sender: TObject);
begin
(Sender as TAction).Checked := GetFormVisible(frmMPQ);
end;

procedure TMainForm.ChangeMode(ToMode:TDocumentType);
begin
  {if ToMode = dtJass then
   begin

   end
  else
   begin
   end;
(Sender as TAction).Checked := GetFormVisible(frmMPQ);}
end;

procedure TMainForm.OnKeyPress(Sender: TObject; var Key: Char);
begin
 if Document.Mode = dtJass then
 if Key = '(' then
  begin
   TipForm.MakeToolTip(Document.Editor.CaretX, Document.Editor.CaretY-1, 0);
  end;
  Document.GutterUpdate;
end;

procedure TMainForm.actFuncListExecute(Sender: TObject);
begin
  ShowHide(frmFuncList);
end;

procedure TMainForm.actFuncListUpdate(Sender: TObject);
begin
(Sender as TAction).Checked := GetFormVisible(frmFuncList);
end;

procedure TMainForm.OnSpecialLineColors(Sender: TObject; Line: Integer;
  var Special: Boolean; var FG, BG: TColor);
begin
  if Line = Document.GoToLineLine then
  if Document.Editor.CaretY = Line then
   if Document.GoToLineT.Enabled then
    begin
  FG := $00004000;
  BG := $00CAECCC;
  Special := True;
    end;
end;

procedure TMainForm.OnScroll(Sender: TObject; ScrollBar: TScrollBarKind);
begin
 if Document.Mode = dtJass then
   TipForm.RelocPopup;
end;

procedure TMainForm.OnDblClick(Sender: TObject);
begin
 if Document.Mode = dtJass then
   TipForm.MakeToolTip(Document.Editor.CaretX, Document.Editor.CaretY-1, 0);
 //ShowMessage(Copy(Document.Editor.Lines[Document.Editor.CaretY-1], 0, Document.Editor.CaretX));
end;

procedure TMainForm.actCodeViewExecute(Sender: TObject);
begin
  ShowHide(SynCode);
  ShowHide(SynCodeSplit);
end;

procedure TMainForm.actCodeViewUpdate(Sender: TObject);
begin
(Sender as TAction).Checked := SynCode.Visible;
end;

procedure TMainForm.actInsertFromWEExecute(Sender: TObject);
var
  sT  : String;

begin
if not Assigned(Document) then Exit;
  if GetTEJassText(sT) then begin
    with Document.Editor do begin
      SelText   := sT;
      Document.GotoLine(CaretY);
      Document.GutterUpdate;
      if sT<>'' then
        Document.Editor.OnChange(nil);
    end; //with
  end else begin
    MessageBox(Handle, 'World Editor is not running!', 'JassCraft', MB_OK or MB_ICONHAND);
  end; //if
end;

procedure TMainForm.actLoadFromWEExecute(Sender: TObject);
var
  sT  : String;

begin
if not Assigned(Document) then Exit;
  if GetTEJassText(sT) then begin
    with Document.Editor do begin
      SelectAll;
      SelText  := sT;
      SelStart := 0;
      Document.GotoLine(CaretY);
      OnStatusChange(Document.Editor, []);
      OnChange(nil);
      Document.UpdateType(Document.Mode);
      Document.GutterUpdate;
    end; //with
  end else begin
    MessageBox(Handle, 'World Editor is not running!', 'JassCraft', MB_OK or MB_ICONHAND);
   end; //if
end;

procedure TMainForm.actSaveAllToWEExecute(Sender: TObject);
const
  ciSelected  = 1;
var
  hTE : HWND;
  pT  : PAnsiChar;
  sT:String;
begin
if not Assigned(Document) then Exit;
  hTE := GetTEJassEditorHandle;
  if hTE=0 then begin
    MessageBox(Handle, 'World Editor is not running!', 'JassCraft', MB_OK or MB_ICONHAND);
    Exit;
  end; //if

  if (Sender as TAction).Tag=1 then
    pT  := PAnsiChar(Document.Editor.SelText)
  else
    pT  := PAnsiChar(Document.Editor.Text);

   if GetTEJassText(sT) then begin
   TEOverwritten := sT;
   end;

  SendMessage(hTE, WM_SETTEXT, 0, Longint(pT));
  SendMessage(hTE, WM_CHAR, Ord(' '), 0);
  SendMessage(hTE, WM_CHAR, VK_BACK, 0);
  SetForegroundWindow(hTE);
  Windows.SetFocus(hTE);
end;

procedure TMainForm.actRestoreOverExecute(Sender: TObject);
begin
if TEOverwritten <> '' then
DocumentFactory.Restore(TEOverwritten)
else MessageBox(Handle, 'No overwritted trigger stored!', 'JassCraft', MB_OK or MB_ICONHAND);
end;

procedure TMainForm.actInsertColorExecute(Sender: TObject);
  function ColorABCD_ADCB(const Color:TColor):TColor;
  var
    P : PChar;
    C : Char;
  begin
    result  := Color;
    P := @result;
    C := P^;
    P^  := (P+2)^;
    Inc(P, 2);
    P^  := C;
  end;
begin
  if Assigned(Document) then
 if ColorDialog.Execute then
  begin
   ColorDialog.Color := ColorABCD_ADCB(ColorDialog.Color);
   Document.Editor.SelText   := '|c'+IntToHex(ColorDialog.Color, 8)+'|r';
   Document.Editor.SelStart  := Document.Editor.SelStart-2;
  end;
end;

procedure TMainForm.actWorkSpaceOpenExecute(Sender: TObject);
begin
	with dlgWorkSpaceOpen do
  begin
    if Execute then
    begin
    	DocumentFactory.CloseAll;
    	OpenWorkspace(FileName);
    end;
  end;
end;

procedure TMainForm.actWorkSpaceCloseExecute(Sender: TObject);
var
	i: Integer;
const
	sMessage = 'Do you want to save changes in current workspace?';
begin
	if fWorkspaceModified then
  	if Application.MessageBox(sMessage, 'Confirm', MB_ICONQUESTION or MB_YESNO) = IDYES then
    	actWorkSpaceSave.Execute;

	for i := DocumentFactory.Count - 1 downto 0 do
  	if DocumentFactory.Documents[i].Saved then
    	DocumentFactory.Documents[i].Close;

  MRUWorkspaces.Add(fWorkspaceFile, '');
  UpdateMRUWorkspacesMenu;
  fWorkspaceFile := '';
end;

procedure TMainForm.actWorkSpaceSaveAsExecute(Sender: TObject);
begin
	with dlgWorkSpace do
  begin
    if Execute then
    begin
    	fWorkspaceFile := FileName;
      fWorkspaceModified := False;
      actWorkSpaceSave.Execute;
    end;
  end;
end;

procedure TMainForm.actWorkSpaceClearAllExecute(Sender: TObject);
begin
  MRUWorkspaces.Clear;
  UpdateMRUWorkspacesMenu;
end;

procedure TMainForm.actWorkSpaceCloseUpdate(Sender: TObject);
begin
	(Sender as TAction).Enabled := fWorkspaceFile <> '';
end;

procedure TMainForm.actWorkSpaceSaveExecute(Sender: TObject);
var
	i: Integer;
	WorkspaceFiles: TMyIniFile;
begin
	if fWorkspaceFile = '' then
  	FileWorkspaceSaveAsExecute(nil)
  else
  begin
  	fWorkspaceModified := False;
  WorkspaceFiles := TMyIniFile.Create(fWorkspaceFile);

    try
    	for i := 0 to DocumentFactory.Count - 1 do
       begin
        WorkspaceFiles.WriteString('Main', 'File'+IntToStr(i+1), DocumentFactory.Documents[i].FileName);
      	WorkspaceFiles.WriteString('Main', 'FileMPQ'+IntToStr(i+1), DocumentFactory.Documents[i].FileInMPQ);
       end;
    finally
    	WorkspaceFiles.Free;
    end;
	end;
end;

procedure TMainForm.OnKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    Document.GutterUpdate;
end;

procedure TMainForm.TBXItem92Click(Sender: TObject);
begin
Document.UpdateType(dtNone);
end;

procedure TMainForm.OnKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var i:Integer;
  T:TTabResult;
  S,d:String;



begin
  if Document.Mode = dtJass then
  if UseEnterIndent then
  if Key = VK_RETURN then
   begin
    T := AddTab(Document, d);
    if T.LastLine then
     begin

       S := Document.Editor.Lines[Document.Editor.CaretY-2];
       i := TabCount(S)-Document.Editor.TabWidth;
       d := DupeString(' ', i);
       Document.Editor.Lines[Document.Editor.CaretY-2] := d+Trim(S);
       
       if T.CurrentLine then
        begin
       i :=  i+Document.Editor.TabWidth;
       d := DupeString(' ', i);
        end;

       Document.Editor.Lines[Document.Editor.CaretY-1] := d;
       Document.Editor.CaretX := 1 + i;
     end
    else if T.CurrentLine then
     begin
       i := Document.Editor.TabWidth + TabCount(Document.Editor.Lines[Document.Editor.CaretY-2]);
       Document.Editor.Lines[Document.Editor.CaretY-1] := DupeString(' ', i);
       Document.Editor.CaretX := 1 + i;
     end;   

   end;
end;

procedure TMainForm.TBXItem93Click(Sender: TObject);
begin
Document.UpdateType(dtJass);
end;

procedure TMainForm.actCommentSelUpdate(Sender: TObject);
begin
 (Sender as TAction).Enabled := (Document <> nil);
end;

procedure TMainForm.actCommentSelExecute(Sender: TObject);
var i:Integer;
S:TStringList;
begin
if Document.Editor.SelLength = 0 then
 begin
  Document.Editor.SelText := '//';
  Exit;
 end;
S := TStringList.Create;
S.Text := Document.Editor.SelText;
for i := 0 to  S.Count-1 do
 if Copy(Trim(S[i]), 0, 2) <> '//' then
   S[i] := '//'+S[i];
Document.Editor.SelText := Copy(S.Text, 0, Length(S.Text)-2);
S.Free;
end;

procedure TMainForm.actUnCommentSelExecute(Sender: TObject);
var i:Integer;
S:TStringList;
b:String;
 p:Integer;

begin
if Document.Editor.SelLength = 0 then
 begin
  b := Document.Editor.Lines[Document.Editor.CaretY-1];
  p := Pos('//', b);
  if p <> 0 then
   Delete(b, p, 2);
  Document.Editor.Lines[Document.Editor.CaretY-1] := b;
  Exit;
 end;
S := TStringList.Create;
S.Text := Document.Editor.SelText;
for i := 0 to  S.Count-1 do
 begin
 b := S[i];
 p := Pos('//', b);
 if p <> 0 then
 Delete(b, p, 2);
 S[i] := b;
 end;
Document.Editor.SelText := Copy(S.Text, 0, Length(S.Text)-2);
S.Free;
end;


procedure TMainForm.btnStartSyntaxClick(Sender: TObject);


var
  sCom  : String;
  i   : Integer;

begin

 if btnStartSyntax.Caption = 'Cancel' then
  begin
   StopPJass;
  end
 else
  begin


  if Document = nil then Exit;
  sCom  := Document.Editor.Lines.Text;
  sCom  := Trim(sCom);
  if sCom='' then begin
    MessageBox(Handle, 'Document is empty!', 'JassCraft',  MB_OK);
    Exit;
  end; //if

  checkout.Clear;
  if Pos(#13#10, sCom)=0 then
    sCom  := AnsiReplaceStr(sCom, #13, #13#10);
   i := FileCreate(AppPath + tmpJ);

  FileWrite(i, PChar(sCom)[0], Length(sCom));

  FileClose(i);

  Application.ProcessMessages;

  sCom  := AppPath+'pjass.exe';
  if not FileExists(sCom) then begin
    MessageBox(Handle,  'Did not find PJASS!', 'JassCraft', MB_OK or MB_ICONHAND);
    Exit;
  end; //if

  for i := 0 to High(JassLib.Docs) do
   begin
  if Settings.ReadBool('JassSyn', IntToStr(i-1), false) then
    sCom  := sCom+' '+GetShortPathName(TJassDoc(JassLib.Docs[i]).Filename);
   end;

  sCom  := sCom+' '+GetShortPathName(tmpJ);

  RunPJass(sCom);

 btnStartSyntax.Caption := 'Cancel';
 checkout.Items.Text  := 'Checking '+Document.FileName+'...';
 end;


end;

procedure TMainForm.btnSyntaxCloseClick(Sender: TObject);
begin
pnlBottomSplit.Hide;
pnlSyntax.Hide;
end;

procedure TMainForm.checkoutDblClick(Sender: TObject);
var
  i : Integer;
  sL  : String;

begin
{  if Document = nil then Exit;
  if checkout.ItemIndex = -1 then Exit;  }

  sL  := Document.Editor.Lines[checkout.ItemIndex];
  
  if Pos('Line ', sL)=0 then
    Exit;

  sL  := Copy(sL, 6, Length(sL)-5);
  ShowMessage(sL);
  i   := Pos(':', sL);
  sL  := Copy(sL, 1, i-1);
  i   := StrToInt(sL);
  Document.GotoLine(i);
  Document.Editor.SetFocus;
end;

procedure TMainForm.ViewStatusBarUpdate(Sender: TObject);
begin
(Sender as TAction).Checked := StatusBar.Visible;
end;

procedure TMainForm.ViewToolbarUpdate(Sender: TObject);
begin
(Sender as TAction).Checked := tbMain.Visible;
end;

procedure TMainForm.TBXItem97Click(Sender: TObject);
var S:String;
i:Integer;
begin
 S := InputBox('JassCraft', 'Layout Name:', '');
 if S = '' then Exit;
 i := Settings.ReadInteger('Layouts', 'Count', 0);
 Settings.WriteInteger('Layouts', 'Count', i+1);
 Settings.WriteString('Layouts', IntToStr(i), S);
 layoutsel.Strings.Add(S);
 MakeLayoutMenu;
 layoutsel.Text := S;
 SaveLayout;
end;

procedure TMainForm.layoutselChange(Sender: TObject; const Text: String);
begin
SaveLayout;
LoadLayout(Text);
end;

procedure TMainForm.TBXItem96Click(Sender: TObject);
var i:Integer;
begin
if MessageDlg('Do you want to delete '''+layoutsel.Text+'''?', mtConfirmation, [mbYes, mbNo], 0) = mrYes	then
 begin
  Settings.EraseSection('Layout_'+layoutsel.Text);
  Settings.EraseSection('Layouts');
  layoutsel.Strings.Delete(layoutsel.Strings.IndexOf(layoutsel.Text));
  for i := 0 to layoutsel.Strings.Count-1 do
    Settings.WriteString('Layouts', IntToStr(i), layoutsel.Strings[i]);
  Settings.WriteInteger('Layouts', 'Count', layoutsel.Strings.Count);
  layoutsel.ItemIndex := 0;
  MakeLayoutMenu;
 end
end;

procedure TMainForm.actLayoutBarUpdate(Sender: TObject);
begin
(Sender as TAction).Checked := tbLay.Visible;
end;

procedure TMainForm.actLayoutBarExecute(Sender: TObject);
begin
  ShowHide(tbLay);
end;

procedure TMainForm.mnuLayItemClick(Sender: TObject);
begin
layoutsel.Text := (Sender as TTBXItem).Caption;
end;

procedure TMainForm.mnuLayClick(Sender: TObject);
var i:Integer;
begin
 for i := 0 to mnuLay.Count-1 do
    mnuLay[i].Checked := mnuLay[i].Caption = Layout;
end;

procedure TMainForm.TBXItem80Click(Sender: TObject);
begin
Document.UpdateType(dtMdl);
end;

procedure TMainForm.mnuEditorPopup(Sender: TObject);
begin
tbxCodeFold.Visible := Document.Editor.CodeFolding.Enabled;
end;

procedure TMainForm.TBXItem99Click(Sender: TObject);
begin
Document.Editor.CollapseAll;
end;

procedure TMainForm.TBXItem100Click(Sender: TObject);
begin
Document.Editor.UncollapseAll;
end;

procedure TMainForm.TBXItem101Click(Sender: TObject);
var S:String;
begin
  S := InputBox('JassCraft', 'Collapse level:', '1');
  if StrToIntDef(S, 0) = 0 then Exit;
  Document.Editor.CollapseLevel(StrToIntDef(S,0)+1);
end;

procedure TMainForm.TBXItem102Click(Sender: TObject);
var S:String;
begin
  S := InputBox('JassCraft', 'Uncollapse level:', '1');
  if StrToIntDef(S, 0) = 0 then Exit;
  Document.Editor.UncollapseLevel(StrToIntDef(S,0)+1);
end;

procedure TMainForm.templatesClick(Sender: TObject);
var i:Integer;
begin
 for i := 0 to templates.Count-1 do
   templates.Items[i].Enabled := Assigned(Document);
end;

end.
