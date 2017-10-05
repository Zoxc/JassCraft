unit uDocuments;

interface

uses
	SysUtils, Classes, Graphics, Controls, Forms, JvTabBar, SynEdit,
  SynEditKeyCmds, SynEditTypes, SynEditMiscClasses, Windows,
  uExSynEdit, pMpqReadWrite, JvDockControlForm, ExtCtrls, StrUtils,
  SynJass, uOptions, JassUnit, Dialogs, uCodeFolding, SynEditCodeFolding, SynMdl;

type
  TDocumentType = (dtJass, dtMdl, dtNone);
  TTabResult = record
  LastLine:Boolean;
  CurrentLine:Boolean;
  end;

  TDocument = class
  private
    fEditor: TExSynEdit;
    fFileName: String;
    //fHighlighter: TSynUniSyn;
    fTab: TJvTabBarItem;
    fType: String;
    function GetModified: Boolean;
    procedure SetModified(const Value: Boolean);
    function GetCode: String;
    procedure SynEditStatusChange(Sender: TObject; Changes: TSynStatusChanges);
		procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
		procedure MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
		procedure SynEditReplaceText(Sender: TObject; const ASearch, AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
    procedure SynEditChange(Sender: TObject);
  public
    HGlobals:array of TGlobal;
    fSaved: Boolean;
    GoToLineT:TTimer;
    GoToLineLine:Integer;
    JassDoc:TJassDoc;
    FileInMPQ: String;
    Mode: TDocumentType;
  	constructor Create;
    procedure FullClean;
    destructor Destroy; override;
    procedure UpdateType(new:TDocumentType);
    procedure GutterUpdate;
    function CanPaste: Boolean;
    function CanRedo: Boolean;
    function CanSave: Boolean;
    function CanUndo: Boolean;
    function FindNext: Boolean;
    function FindText(Text: String; WholeWords, MatchCase, RegExp, SelOnly, FromCursor, DirUp, ListResults: Boolean): Boolean;
    function ReplaceNext: Boolean;
    function ReplaceText(Text, ReplaceWith: String; WholeWords, MatchCase, RegExp, SelOnly, FromCursor, Prompt, DirUp, ReplaceAll: Boolean): Boolean;
    function SelAvail: Boolean;
    procedure Activate;
    function Close: Integer;
    procedure CollapseAll;
    procedure CollapseCurrent;
    procedure CollapseLevel(Level: Integer);
    procedure ColumnSelect;
    procedure Copy;
    procedure Cut;
    procedure Delete;
    procedure DeleteWord;
    procedure DeleteLine;
    procedure DeleteToEndOfWord;
    procedure DeleteToEndOfLine;
    procedure DeleteWordBack;
    procedure Indent;
    procedure Open(aFileName,fFileInMPQ: String);
    procedure Paste;
    procedure ReadFromIni;
    procedure Redo;
    procedure Save;
    procedure SelectAll;
    procedure SelectWord;
    procedure SelectLine;
    procedure SetupOptions(var Options: TSynSearchOptions; WholeWords, MatchCase, RegExp, SelOnly, FromCursor, DirUp: Boolean);
    procedure UncollapseAll;
    procedure UncollapseLevel(Level: Integer);
    procedure Undo;
    procedure Unindent;
    procedure UpdateCaption;
    procedure GoToLine(Line: Integer);
    procedure UpdateExplorer;
    procedure UpperCase;
    procedure LowerCase;
    procedure ToggleCase;
    procedure Capitalize;
    procedure GoToLineEx(Line: Integer);
    procedure OnGoToLineTimer(Sender: TObject);

    property FileName: String read fFileName write fFileName;
    property Saved: Boolean read fSaved write fSaved;
    property Editor: TExSynEdit read fEditor;
    property Modified: Boolean read GetModified write SetModified;
    property Code: String read GetCode;
  end;

  TDocumentFactory = class
  private
    fDocuments: TList;
    fUntitledIndex: Integer;
    fLastSearchedForText: String;
    function GetDocument(Index: Integer): TDocument;
    function GetCount: Integer;
  public
    JassSyn: TSynEdit_JassSyn;
    MdlSyn: TSynEdit_MdlSyn;
  	constructor Create;
    procedure LoadSynSettings;
    destructor Destroy; override;
    procedure InitMdlSynColors(Syn:TSynEdit_MdlSyn);
    function AddDocument: TDocument;
    function CanSaveAll: Boolean;
    function CloseAll: Boolean;
    procedure InitJassSynColors(Syn:TSynEdit_JassSyn);
    procedure New;
    procedure Restore(S: String);
    procedure Open(aFileName,MPQPath: String);
    procedure ReadAllFromIni;
    procedure RemoveDocument(aDocument: TDocument);
    procedure SaveAll;
    function IsSearchedForTheFirstTime(S: String): Boolean;

    property Documents[Index: Integer]: TDocument read GetDocument; default;
    property Count: Integer read GetCount;
  end;

var
	DocumentFactory: TDocumentFactory;
  Document: TDocument;

function AddTab(Doc: TDocument; var EndAdd:String):TTabResult;
function TabCount(S:String):Integer;
function RemoveComment(Line:String):String;
function IsInStringOrValue(Line:String;Pos:Integer):Boolean;
procedure DefaultTheme(S:TSynEdit);

implementation

uses uMain, IniFiles, uUtils, uConfirmReplace, uFind, uFuncList, uFuncInfo;

procedure DefaultTheme(S:TSynEdit);
begin
S.Color := clWindow;
S.SelectedColor.Background := clHighlight;
S.SelectedColor.Foreground := clHighlightText;
S.ActiveLineColor := $00E6FFFA;
end;

function TabCount(S:String):Integer;
var R:String;
begin
 R := TrimLeft(S);
 Result := Length(S)-Length(R);
end;

function AddTab(Doc: TDocument; var EndAdd:String):TTabResult;
var S:String;
p:Integer;
begin
S := Trim(Doc.Editor.Lines[Doc.Editor.CaretY-2]);
p := Pos(' ', S);
if p <> 0 then
S := Copy(S, 0, Pos(' ', S)-1);

if S = 'function' then
Result.CurrentLine := True;

if S = 'constant' then
 begin
 S := Trim(Doc.Editor.Lines[Doc.Editor.CaretY-2]);
 p := Pos(' ', S);
 if p <> 0 then
 S := Trim(Copy(S, Pos(' ', S), Length(S)));
 p := Pos(' ', S);
 if p <> 0 then
 S := Copy(S, 0, Pos(' ', S)-1);
 if S = 'function' then Result.CurrentLine := True;
 end;

if (S = 'globals') or (S = 'loop') or (S = 'if') or (S = 'elseif') or (S = 'else') or (S = 'function') then
Result.CurrentLine := True;

if (S = 'endif') or (S = 'elseif') or (S = 'else') or (S = 'endglobals') or (S = 'endfunction') or (S = 'endloop') then
Result.LastLine := True;
end;

{ TDocument }

procedure TDocument.Activate;
begin
	Document := Self;
  fTab.Selected := True;
  fEditor.BringToFront;
  SynEditStatusChange(fEditor, [scAll]);

  if Mode = dtJass then
   if GetFormVisible(frmFuncList) then
     frmFuncList.UpdateChange(Self);

  MainForm.ChangeMode(Mode);

  try
    fEditor.SetFocus;
  except end;

  fEditor.OnChange(nil);

  if fType <> '' then
		MainForm.StatusBar.Panels[idDocTypePanel].Text := fType
end;

function TDocument.CanPaste: Boolean;
begin
	Result := fEditor.CanPaste;
end;

function TDocument.CanRedo: Boolean;
begin
	Result := fEditor.CanRedo;
end;

function TDocument.CanSave: Boolean;
begin
	Result := fEditor.Modified;
end;

function TDocument.CanUndo: Boolean;
begin
	Result := fEditor.CanUndo;
end;

procedure TDocument.Capitalize;
begin
  fEditor.ExecuteCommand(ecTitleCase, #0, nil);
end;

procedure TDocument.FullClean;
var i:Integer;
begin
  Document := nil;
  fEditor.Free;
  fTab.Free;
	DocumentFactory.RemoveDocument(Self);

  if DocumentFactory.Count = 0 then
  begin
  	for i := 0 to MainForm.StatusBar.Panels.Count - 1 do
    	MainForm.StatusBar.Panels[i].Text := '';
  end;
end;

function TDocument.Close: Integer;
var
  s:String;
begin
if FileInMPQ <> '' then
s := FileInMPQ
else s := fFileName;
	Result := IDNO;

  if Modified then
  	with Application do
    	case MessageBox( PChar( Format('Do you want to save changes for %s?', [s]) ) , 'Confirm',
			MB_YESNOCANCEL or MB_ICONQUESTION) of
      	IDYES:
        	begin
          	Result := IDYES;
          	Save;
          end;
        IDCANCEL:
        	begin
          	Result := IDCANCEL;
          	Exit;
          end;
      end;

	if fSaved then
  begin
  	MRUFiles.Add(fFileName, FileInMPQ);
    MainForm.UpdateMRUFilesMenu;
  end;

  FullClean;
end;

procedure TDocument.CollapseAll;
begin

end;

procedure TDocument.CollapseCurrent;
begin

end;

procedure TDocument.CollapseLevel(Level: Integer);
begin

end;

procedure TDocument.ColumnSelect;
begin
	if fEditor.SelectionMode = smColumn then
		fEditor.SelectionMode := smNormal
  else
		fEditor.SelectionMode := smColumn;
end;

procedure TDocument.GutterUpdate;
begin
	fEditor.Gutter.DigitCount := Length(IntToStr(fEditor.Lines.Count))+1;
end;

procedure TDocument.Copy;
begin
	fEditor.CommandProcessor(ecCopy, #0, nil);
end;

constructor TDocument.Create;
begin
  GoToLineT := TTimer.Create(nil);
	fSaved := False;
  fFileName := '';
  fType := '';
	fEditor := TExSynEdit.Create(nil);
  JassDoc := TJassDoc.Create;
  with fEditor do
  begin
    BorderStyle := bsNone;
    RightEdge := 0;
  	Align := alClient;
  	Top := 49;
    GutterUpdate;
  	Gutter.AutoSize := False;
    Gutter.LeftOffset := 0;
    Gutter.Font.Name := 'Courier New';
    Gutter.Font.Size := 10;
    Gutter.Font.Color := $00cc9999;
   { Gutter.Color := $00cc9999;
    Gutter.Gradient := True;    }
  	WantTabs := True;
  	Highlighter := DocumentFactory.JassSyn;
    OnChange := SynEditChange;
  	OnStatusChange := SynEditStatusChange;
  	OnReplaceText := SynEditReplaceText;
  	OnMouseDown := MouseDown;
  	OnMouseMove := MouseMove;
  	OnMouseUp := MouseUp;
    OnMButtonUp := MainForm.WmMButtonUp;   
    OnKeyDown := MainForm.OnKeyDown;
    OnKeyUp := MainForm.OnKeyUp;
    OnKeyPress := MainForm.OnKeyPress;
    OnScroll := MainForm.OnScroll;
    OnDblClick := MainForm.OnDblClick;
    OnSpecialLineColors := MainForm.OnSpecialLineColors;
  end;

  with MainForm do
  begin
    fEditor.Width := Width;
    fEditor.Height := Height;
    fEditor.PopupMenu := mnuEditor;
  end;

  ReadFromIni;
  fEditor.Parent := MainForm.pnlMain;
	fTab := TJvTabBar(MainForm.tbDocuments).AddTab('');
  fTab.Data := Self;
end;

procedure TDocument.Cut;
begin
	fEditor.CommandProcessor(ecCut, #0, nil);
end;

procedure TDocument.Delete;
begin
	fEditor.CommandProcessor(ecDeleteChar, #0, nil);
end;

procedure TDocument.DeleteLine;
begin
	fEditor.CommandProcessor(ecDeleteLine, #0, nil);
end;

procedure TDocument.DeleteToEndOfLine;
begin
	fEditor.CommandProcessor(ecDeleteEOL, #0, nil);
end;

procedure TDocument.DeleteToEndOfWord;
begin
	fEditor.CommandProcessor(ecDeleteWord, #0, nil);
end;

procedure TDocument.DeleteWord;
var
	Left, Right, Len: Integer;
  Line: String;
  LeftDone, RightDone: Boolean;
  ptBefore, ptAfter: TBufferCoord;
begin
	Line := fEditor.LineText;
	Len := Length(Line);
  LeftDone := False;
  RightDone := False;
	fEditor.BeginUpdate;

	try
		if Len > 0 then
		begin
			Left := fEditor.CaretX;
			Right := fEditor.CaretX;

			repeat
				if (not LeftDone) and (Left - 1 > 0)
        and (Line[Left - 1] in TSynValidStringChars) then
					Dec(Left)
				else
					LeftDone := True;

				if (not RightDone) and (Right + 1 <= Len)
        and (Line[Right + 1] in TSynValidStringChars) then
					Inc(Right)
				else
					RightDone := True;
				
			until (LeftDone) and (RightDone);

			if Right - Left > 0 then
			begin
      	Inc(Right);
				ptBefore.Char := Left;
        ptBefore.Line := fEditor.CaretY;
        ptAfter.Char := Right;
        ptAfter.Line := fEditor.CaretY;
        fEditor.SetCaretAndSelection(ptBefore, ptBefore, ptAfter);
				fEditor.CommandProcessor(ecDeleteChar, #0, nil);
			end;
		end;
	finally
		fEditor.EndUpdate;
	end;
end;

procedure TDocument.DeleteWordBack;
begin
	fEditor.CommandProcessor(ecDeleteLastWord, #0, nil);
end;

destructor TDocument.Destroy;
begin
	//fHighlighter.Free;
  inherited;
end;

function TDocument.FindNext: Boolean;
var
	Options: TSynSearchOptions;
begin
  SetupOptions(Options, frWholeWords, frMatchCase, frRegExp, frSelOnly, frFromCursor, frDirUp);
	Exclude(Options, ssoEntireScope);
	Result := fEditor.SearchReplace(frFindText, '', Options) <> 0;
end;

function TDocument.FindText(Text: String; WholeWords, MatchCase, RegExp,
	SelOnly, FromCursor, DirUp,ListResults: Boolean): Boolean;
var
	Options: TSynSearchOptions;

begin
	SetupOptions(Options, WholeWords, MatchCase, RegExp, SelOnly, FromCursor, DirUp);
	Result := fEditor.SearchReplace(Text, '', Options) <> 0;
{  if Result then
   begin
    BottomTab.Hide;
    BottomTab.Title := 'Search for '''+Text+''' in ';
    next := fEditor.SearchReplace(Text, '', Options) <> 0;
    BottomTab.Show;
   end; }
end;

function TDocument.GetCode: String;
begin
	Result := fEditor.Text;
end;

function TDocument.GetModified: Boolean;
begin
	Result := fEditor.Modified;
end;

procedure TDocument.GoToLine(Line: Integer);
begin
  fEditor.GotoLineAndCenter(Line);
end;

function IsInStringOrValue(Line:String;Pos:Integer):Boolean;
var
  iCase, i  : Integer;
    
begin
  iCase   := 0;
  i := 1;
  while i<Pos do begin
    if Line[i]='"' then begin
      iCase := 1;
      repeat
        i := i + 1;
        if (Line[i]='"')and(Line[i-1]<>'\')then begin
          iCase := 0;
          break;
        end; //if
      until i>=Pos;
    end else if Line[i]='''' then begin
      iCase := 2;
      repeat
        i := i + 1;
        if Line[i]='''' then begin
          iCase := 0;
          break;
        end; //if
      until i>=Pos;
    end else
      iCase := 0;
    i := i + 1;
  end; //while
  result  := iCase<>0;
end;

function RemoveComment(Line:String):String;
var
  i : Integer;
begin
  i   := Pos('//', Line);
  while i>0 do
  begin
    if IsInStringOrValue(Line, i) then
    begin
      i := PosEx('//', Line, i+1);
    end else begin
      Line  := TrimRight(System.Copy(Line, 1, i-1));
      i := 0;
    end; //if
  end; //while
  result  := Line;
end;

procedure TDocument.Indent;

var sTab:String;




function GetIndentSpace(var Spaces:Integer;Line:String):String;
var
  sT  : String;
  l   : Integer;
  iR  : Integer;
  iT  : Integer;
    
begin
  Line  := RemoveComment(Line);
  iT  := Editor.TabWidth;
  l   := Length(Line);
  iR  := Spaces;
  //+Tab - "loop" "globals" "else"
  if (Line='loop')or(Line='else')or(Line='globals') then
    Spaces  := Spaces + iT;
      
  //+Tab - end "then"
  if l>=4 then begin
    sT  := System.Copy(Line, l-3, 4);
    if (sT='then') then //and(Q_PosStr('//', Line)=0) then begin
    begin
      Spaces  := Spaces + iT;
    end; //if
  end; //if

  //+Tab - begin "function"
  if Pos('function', Line)=1 then begin
    Spaces  := Spaces + iT;
  end; //if
    
  //+Tab - begin "constant function"
  if Pos('constant', Line)=1 then begin
    sT  := Trim(System.Copy(Line, 9, l-8));
    if Pos('function', sT)=1 then
      Spaces  := Spaces + iT;
  end; //if
    
  //-Tab - begin  "else"
  if l>=4 then begin
    sT  := System.Copy(Line, 1, 4);
    if (sT='else') then begin
      Spaces  := Spaces - iT;
      iR      := iR - iT;
    end; //if
  end; //if

  //-Tab - "endloop" "endif" "endfunction" "endglobals"
  if (Line='endloop')or(Line='endif')or(Line='endfunction')or(Line='endglobals')then begin
    iR      := iR - iT;
    Spaces  := Spaces - iT;
  end; //if
  Result  := StringOfChar(' ', iR);
end;

  procedure IndentText(const iB, iE:Integer;bolShow:Boolean);
  var
    iR, i : Integer;
    sL  : String;
  begin
    iR  := 0;
    for i:=iB to iE do
    begin
      sL  := Trim(Editor.Lines.Strings[i]);
      Editor.Lines.Strings[i]  := GetIndentSpace(iR, sL)+sL;
     { if bolShow and ((i mod 8)=4) then
        frmPreview.SetLoadingBar(i-iB);}
    end; //for
  end;
  
  procedure AddTab(const iB, iE:Integer;bolShow:Boolean);
  var
    i   : Integer;
  begin
    for i:=iB to iE do
    begin
      Editor.Lines.Strings[i]  := sTab+Editor.Lines.Strings[i];
      {if bolShow and ((i mod 8)=4) then
        frmPreview.SetLoadingBar(i-iB);}
    end; //for
  end;
  
  procedure DelTab(const iB, iE:Integer;bolShow:Boolean);
  var
    i   : Integer;
  begin
    for i:=iB to iE do
    begin
      Editor.Lines.Strings[i]  := TrimLeft(Editor.Lines.Strings[i]);
     { if bolShow and ((i mod 8)=4) then
        frmPreview.SetLoadingBar(i-iB);}
    end; //for
  end;
  
const
  ciIndent  = 1;
  ciAddTab  = 2;
  ciDelTab  = 3;
var
  bolShow   : Boolean;
  iB, iE, i : Integer;
begin
  if Mode = dtJass then
   begin
  with Editor do
  begin
    sTab := DupeString(' ', Editor.TabWidth);
    BeginUpDate;
    BeginUndoBlock;
    if SelLength=0 then
    begin
     // i   := Length(Text);
      iB  := 0;
      iE  := Lines.Count-1;
    end else begin
     // i   := SelLength;
      iE  := CaretY-1;
      SelLength := 0;
      iB  := CaretY-1;
      if iB=iE then
      begin
        SelStart  := SelStart + i;
        iE  := CaretY-1;
      end; //if
    end; //if
  end; //with

{  bolShow := i>uOption.IndentShow;
  if bolShow then begin
    Hide;
    with frmPreview do begin
      lblLoad.Caption := ssPreview.Indent;
      lblLoad.Show;
      prbLoading.Max  := iE-iB;
      prbLoading.Show;
      Show;
      SetLoadingBar(0);
    end; //with
  end; //if

  case (Sender as TMenuItem).Tag of
    ciIndent  :  }
    IndentText(iB, iE, bolShow);
    {ciAddTab  : AddTab(iB, iE, bolShow);
    ciDelTab  : DelTab(iB, iE, bolShow);
  end; //Case }

  {if bolShow then
    frmPreview.SetLoadingBar(iE);  }

  with Editor do begin
    EndUndoBlock;
    EndUpdate;
    OnChange(Editor);
  end; //with
{  if bolShow then begin
    frmPreview.Close;
    Show; }

  end; 


end;

procedure TDocument.LowerCase;
begin
  if SelAvail then
    fEditor.ExecuteCommand(ecLowerCaseBlock, #0, nil)
  else
    fEditor.ExecuteCommand(ecLowerCase, #0, nil);
end;

procedure TDocument.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//	MainForm.OnMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TDocument.MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 //	MainForm.OnMouseMove(Sender, Shift, X, Y);
end;

procedure TDocument.MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 //	MainForm.OnMouseUp(Sender, Button, Shift, X, Y);
end;

procedure TDocument.Open(aFileName,fFileInMPQ: String);
var Ext:String;
begin
	fSaved := True;
	fFileName := aFileName;
  if fFileInMPQ <> '' then
   begin

   FileInMPQ := fFileInMPQ;
   try
   MpqRead(aFileName, fFileInMPQ, fEditor.Lines);
   except
   on E:Exception do
    begin
      Close;
      Application.HandleException(E);
      Exit;
    end;
    end;
   end
  else  Editor.Lines.LoadFromFile(fFileName);
  {if Mode = dtJass then
   if GetFormVisible(frmFuncList) then
     frmFuncList.actRefreshExecute(nil);}
  UpdateCaption;
  GutterUpdate;
  if fFileInMPQ <> '' then
   Ext := SysUtils.LowerCase(ExtractFileExt(fFileInMPQ))
  else  Ext := SysUtils.LowerCase(ExtractFileExt(fFileName));

  if (Ext = '.j') or (Ext = '.ai') then
      UpdateType(dtJass)
  else if  Ext = '.mdl' then
     UpdateType(dtMdl)
  else
      UpdateType(dtNone);
end;

procedure TDocument.Paste;
begin
	fEditor.CommandProcessor(ecPaste, #0, nil);
end;

procedure TDocument.ReadFromIni;
var
	Options: TSynEditorOptions;
begin
	with Settings do
  begin
    UpdateType(dtJass);

    GutterUpdate;
    fEditor.ExtraLineSpacing := ReadInteger('Editor', 'ExtraLineSpacing', 0);
  	fEditor.Font.Name := ReadString('Editor', 'FontName', 'Courier New');
    fEditor.Font.Size := ReadInteger('Editor', 'FontSize', 10);
  	fEditor.Gutter.Visible := ReadBool('Editor', 'ShowGutter', True);
    fEditor.Gutter.ShowLineNumbers := ReadBool('Editor', 'ShowLineNumbers', True);

    fEditor.WordWrap := ReadBool('Editor', 'WordWrap', True);
    fEditor.InsertCaret := TSynEditCaretType(ReadInteger('Editor', 'InsertCaret', 0));
    fEditor.InsertMode := ReadBool('Editor', 'InsertMode', True);
    fEditor.Gutter.LeadingZeros := ReadBool('Editor', 'ShowLeadingZeros', False);
    fEditor.MaxUndo := ReadInteger('Editor', 'MaxUndo', 1024);
    fEditor.OverwriteCaret := TSynEditCaretType(ReadInteger('Editor', 'OverwriteCaret', 0));
    fEditor.Gutter.ZeroStart := ReadBool('Editor', 'ZeroStart', False);
    fEditor.TabWidth := ReadInteger('Editor', 'TabWidth', 4);

    Options := [];

    if ReadBool('Editor', 'AutoIndent', True) then
    	Include(Options, eoAutoIndent);

    if ReadBool('Editor', 'GroupUndo', True) then
    	Include(Options, eoGroupUndo);

    if ReadBool('Editor', 'ScrollPastEOF', False) then
    	Include(Options, eoScrollPastEof);

    if ReadBool('Editor', 'ScrollPastEOL', False) then
    	Include(Options, eoScrollPastEol);

    if ReadBool('Editor', 'ShowSpecialChars', False) then
    	Include(Options, eoShowSpecialChars);

    if ReadBool('Editor', 'TabsToSpaces', False) then
    	Include(Options, eoTabsToSpaces);

    if ReadBool('Editor', 'TrimTrailingSpaces', True) then
    	Include(Options, eoTrimTrailingSpaces);

    fEditor.Options := Options;
  end;
end;

procedure TDocument.Redo;
begin
	fEditor.CommandProcessor(ecRedo, #0, nil);
end;

function TDocument.ReplaceNext: Boolean;
var
	Options: TSynSearchOptions;
begin
  SetupOptions(Options, frWholeWords, frMatchCase, frRegExp, frSelOnly, frFromCursor, frDirUp);
	Exclude(Options, ssoEntireScope);
	Result := fEditor.SearchReplace(frFindText, frReplaceText, Options) <> 0;
end;

function TDocument.ReplaceText(Text, ReplaceWith: String; WholeWords, MatchCase,
	RegExp, SelOnly, FromCursor, Prompt, DirUp, ReplaceAll: Boolean): Boolean;
var
	Options: TSynSearchOptions;
begin
	SetupOptions(Options, WholeWords, MatchCase, RegExp, SelOnly, FromCursor, DirUp);
  Include(Options, ssoReplace);

  if Prompt then
  	Include(Options, ssoPrompt);

  if ReplaceAll then
  begin
  	Include(Options, ssoReplaceAll);
    DocumentFactory.fLastSearchedForText := '';
  end;

  Result := fEditor.SearchReplace(Text, ReplaceWith, Options) <> 0;
end;

procedure TDocument.UpdateType(new:TDocumentType);
begin
Mode := new;
if Mode = dtJass then
   begin
Editor.Highlighter := DocumentFactory.JassSyn;
DocumentFactory.JassSyn.ApplyTheme(Editor);
   end;
if Mode = dtNone then
  begin
Editor.Highlighter := nil;
DefaultTheme(Editor);
  end;
if Mode = dtMdl then
  begin
Editor.Highlighter := DocumentFactory.MdlSyn;
DocumentFactory.MdlSyn.ApplyTheme(Editor);
  end;
InitJassFolding(Editor);
end;

procedure TDocument.Save;
begin
  if fSaved then
  begin
	  fSaved := True;
    fEditor.Modified := False;

    if FileInMPQ <> '' then
     MpqWrite(fFileName, FileInMPQ, fEditor.Lines)
    else
    fEditor.Lines.SaveToFile(fFileName);

    UpdateCaption;
  end
  else
    MainForm.SaveAs(Self);
end;

function TDocument.SelAvail: Boolean;
begin
	Result := fEditor.SelAvail;
end;

procedure TDocument.SelectAll;
begin
	fEditor.CommandProcessor(ecSelectAll, #0, nil);
end;

procedure TDocument.SelectLine;
begin
	fEditor.BeginUpdate;

  try
  	fEditor.CommandProcessor(ecLineStart, #0, nil);
    fEditor.CommandProcessor(ecSelLineEnd, #0, nil);
  finally
  	fEditor.EndUpdate;
  end;
end;

procedure TDocument.SelectWord;
var
	Left, Right, Len: Integer;
  Line: String;
  LeftDone, RightDone: Boolean;
  ptBefore, ptAfter: TBufferCoord;
begin
	Line := fEditor.LineText;
	Len := Length(Line);
  LeftDone := False;
  RightDone := False;
	fEditor.BeginUpdate;

	try
		if Len > 0 then
		begin
			Left := fEditor.CaretX;
			Right := fEditor.CaretX;

			repeat
				if (not LeftDone) and (Left - 1 > 0)
        and (Line[Left - 1] in TSynValidStringChars) then
					Dec(Left)
				else
					LeftDone := True;

				if (not RightDone) and (Right + 1 <= Len)
        and (Line[Right + 1] in TSynValidStringChars) then
					Inc(Right)
				else
					RightDone := True;
				
			until (LeftDone) and (RightDone);

			if Right - Left > 0 then
			begin
      	Inc(Right);
				ptBefore.Char := Left;
        ptBefore.Line := fEditor.CaretY;
        ptAfter.Char := Right;
        ptAfter.Line := fEditor.CaretY;
        fEditor.SetCaretAndSelection(ptBefore, ptBefore, ptAfter);
			end;
		end;
	finally
		fEditor.EndUpdate;
	end;
end;

procedure TDocument.SetModified(const Value: Boolean);
begin
	fEditor.Modified := Value;
end;

procedure TDocument.SetupOptions(var Options: TSynSearchOptions;
  WholeWords, MatchCase, RegExp, SelOnly, FromCursor, DirUp: Boolean);
begin
	Options := [];

	if MatchCase then
		Include(Options, ssoMatchCase);

	if WholeWords then
		Include(Options, ssoWholeWord);

	if DirUp then
		Include(Options, ssoBackwards);

	if SelOnly then
		Include(Options, ssoSelectedOnly);

	if not FromCursor then
		Include(Options, ssoEntireScope);

  if not RegExp then
		fEditor.SearchEngine := MainForm.Search
	else
		fEditor.SearchEngine := MainForm.RegexSearch;
end;

procedure TDocument.SynEditChange(Sender: TObject);
var
  Size : Double;
  Aux  : String;
begin // Luciano
  Size := Length(fEditor.Text) / 1024;

  if Size > 0 then
  begin
    Aux := 'KB';

    if Size > 999 then
    begin
      Aux := 'MB';
      Size := Size / 1024;
    end;

    MainForm.StatusBar.Panels[idDocSizePanel].Text := FormatFloat('0.00',Size) + ' ' + Aux;
  end
  else
    MainForm.StatusBar.Panels[idDocSizePanel].Text := '';
end;

procedure TDocument.SynEditReplaceText(Sender: TObject; const ASearch,
  AReplace: String; Line, Column: Integer; var Action: TSynReplaceAction);
var
  P: TPoint;
  C: TDisplayCoord;
begin
	if frPrompt then
  begin
		C.Row := fEditor.LineToRow(Line);
  	C.Column := Column;
  	P := fEditor.RowColumnToPixels(C);
  	Inc(P.Y, fEditor.LineHeight);

  	if P.X + 337 > fEditor.Width then
  		P.X := P.X - ((P.X + 337) - fEditor.Width);

  	if P.Y + 125 > fEditor.Height then
  		P.Y := P.Y - (125 + fEditor.LineHeight);

		P := fEditor.ClientToScreen(P);

  	case TConfirmReplaceDialog.Create(MainForm).Execute(P.X, P.Y,
    ASearch, AReplace) of
  		mrCancel: Action := raCancel;
  		mrIgnore: Action := raSkip;
  		mrYes: Action := raReplace;
  		mrAll: Action := raReplaceAll;
  	end;
  end
  else
  	Action := raReplace;
end;

procedure TDocument.SynEditStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
{  var Pos:Integer;
  function InParam:Boolean;
  var S:String;
  begin
  Result := False;
  Pos := fEditor.CaretX;
  S := fEditor.Lines[fEditor.CaretY-1];
  if (S[Pos] = '(') or (S[Pos] = ')') then
   Result := True;
  end;           }
begin // Luciano
           {
  if MainForm.UseParamLight then
    if InParam then
     begin
    DocumentFactory.JassSyn.iParenthesisY := fEditor.CaretY-1;
    DocumentFactory.JassSyn.iParenthesisX := fEditor.CaretX-1;
    MainForm.StatusMsg(Format('%d, %d', [fEditor.CaretY, fEditor.CaretX-1]), 0,0,0,false);
    fEditor.Repaint;
     end;
          }
	if Changes * [scAll, scCaretX, scCaretY] <> [] then
  begin
    TipForm.UpdateToolTip(fEditor.CaretX, fEditor.CaretY-1);
  	if  (fEditor.CaretX > 0) and (fEditor.CaretY > 0) then
    	with fEditor do
  			MainForm.StatusBar.Panels[idXYPanel].Text := Format('%6d:%3d',
        	[CaretY, CaretX])
    else
      MainForm.StatusBar.Panels[idXYPanel].Text := '';
  end;

  if Changes * [scAll, scInsertMode, scReadOnly] <> [] then
  begin
    if fEditor.ReadOnly then
      MainForm.StatusBar.Panels[idInsertModePanel].Text := sStrings[siReadOnly]
    else
    begin
    	if fEditor.InsertMode then
      	MainForm.StatusBar.Panels[idInsertModePanel].Text := sStrings[siInsertMode]
      else
      	MainForm.StatusBar.Panels[idInsertModePanel].Text := sStrings[siOverwriteMode]
    end;
  end;

  if Changes * [scAll, scModified] <> [] then
  begin
  	fTab.Modified := fEditor.Modified;

    if fEditor.Modified then
    	MainForm.StatusBar.Panels[idModifiedPanel].Text := sStrings[siModified]
    else
			MainForm.StatusBar.Panels[idModifiedPanel].Text := '';
  end;

  if scSelection in Changes then
  begin
  	if (fEditor.SelAvail) then
			MainForm.StatusMsg(Format('%d lines selected',
      [Abs(fEditor.BlockBegin.Line - fEditor.BlockEnd.Line) + 1]))
    else
    	MainForm.StatusMsg('');

    if FindDialog <> nil then
			FindDialog.chkSelOnly.Enabled := fEditor.SelAvail;
  end;
end;

procedure TDocument.ToggleCase;
begin
  if SelAvail then
    fEditor.ExecuteCommand(ecToggleCaseBlock, #0, nil)
  else
    fEditor.ExecuteCommand(ecToggleCase, #0, nil)
end;

procedure TDocument.UncollapseAll;
begin

end;

procedure TDocument.UncollapseLevel(Level: Integer);
begin

end;

procedure TDocument.Undo;
begin
	fEditor.CommandProcessor(ecUndo, #0, nil);
end;

procedure TDocument.Unindent;
begin
	fEditor.CommandProcessor(ecBlockUnindent, #0, nil);
end;

procedure TDocument.UpdateCaption;
begin
	if fSaved then
  	fTab.Caption := ExtractFileName(fFileName)
  else
  	fTab.Caption := fFileName;

  if FileInMPQ <> '' then
   	fTab.Caption :=	fTab.Caption + ' | ' + FileInMPQ;
end;

procedure TDocument.UpdateExplorer;
begin
 JassDoc.ParseStrings(Editor.Lines);
end;

procedure TDocument.OnGoToLineTimer(Sender: TObject);
begin
GoToLineT.Enabled := False;
Editor.Repaint;
end;

procedure TDocument.GoToLineEx(Line: Integer);
begin
GoToLineT.Enabled := False;
GoToLineLine := Line;
GoToLineT.Interval := 400;
GoToLineT.OnTimer := OnGoToLineTimer;
GoToLineT.Enabled := True;
GoToLine(Line);
Editor.Repaint;
end;

procedure TDocument.UpperCase;
begin
  if SelAvail then
    fEditor.ExecuteCommand(ecUpperCaseBlock, #0, nil)
  else
    fEditor.ExecuteCommand(ecUpperCase, #0, nil);
end;

{ TDocumentFactory }

function TDocumentFactory.AddDocument: TDocument;
begin
	Result := TDocument.Create;
  fDocuments.Add(Result);
  Result.Activate;
end;

function TDocumentFactory.CanSaveAll: Boolean;
var
	i: Integer;
begin
	Result := False;

  for i := 0 to Count - 1 do
  	if Documents[i].Modified then
    begin
    	Result := True;
      Break;
    end;
end;

function TDocumentFactory.CloseAll: Boolean;
var
	i: Integer;
begin
	Result := True;

	for i := Count - 1 downto 0 do
		if Documents[i].Close = IDCANCEL then
    begin
    	Result := False;
      Exit;
    end;
end;

procedure TDocumentFactory.LoadSynSettings;
var i,s:Integer;
JASS:THighlightStyle;
begin
s := Settings.ReadInteger('Jass', 'UseStyle', 0);

for i := 0 to High(JassSyn.Theme) do
    begin;
   JassSyn.Theme[i] := Settings.ReadColor('JassStyle'+IntToStr(s), JassSyn.ThemeStr[i], clWhite);
   MdlSyn.Theme[i] := Settings.ReadColor('JassStyle'+IntToStr(s), JassSyn.ThemeStr[i], clWhite);
    end;
for i := 0 to JassSyn.Styles.Count-1 do
 begin
  JASS := THighlightStyle(JassSyn.Styles[i]);
  LoadHighlightStyle(Settings, s, JASS);
 end;
for i := 0 to MdlSyn.Styles.Count-1 do
 begin
  JASS := THighlightStyle(MdlSyn.Styles[i]);
  LoadHighlightStyle(Settings, s, JASS);
 end;
JassSyn.LoadSynSettings;
MdlSyn.LoadSynSettings;
end;

procedure TDocumentFactory.InitJassSynColors(Syn:TSynEdit_JassSyn);
begin
  SetLength(Syn.ThemeStr, 9);
  SetLength(Syn.Theme, 9);
  Syn.ThemeStr[0] := 'ActiveLine';
  Syn.ThemeStr[1] := 'SelectedBG';
  Syn.ThemeStr[2] := 'SelectedFG';
  Syn.ThemeStr[3] := 'Background';
  Syn.ThemeStr[4] := 'Gutter';
  Syn.ThemeStr[5] := 'GutterFont';
  Syn.ThemeStr[6] := 'FolderBar';
  Syn.ThemeStr[7] := 'CollapsedLine';
  Syn.ThemeStr[8] := 'FolderBarLines';
end;

procedure TDocumentFactory.InitMdlSynColors(Syn:TSynEdit_MdlSyn);
begin
  SetLength(Syn.ThemeStr, 9);
  SetLength(Syn.Theme, 9);
  Syn.ThemeStr[0] := 'ActiveLine';
  Syn.ThemeStr[1] := 'SelectedBG';
  Syn.ThemeStr[2] := 'SelectedFG';
  Syn.ThemeStr[3] := 'Background';
  Syn.ThemeStr[4] := 'Gutter';
  Syn.ThemeStr[5] := 'GutterFont';
  Syn.ThemeStr[6] := 'FolderBar';
  Syn.ThemeStr[7] := 'CollapsedLine';
  Syn.ThemeStr[8] := 'FolderBarLines';
end;

constructor TDocumentFactory.Create;
var Style:THighlightStyle;
Func:TFoldRegionItem;
begin
  JassSyn:= TSynEdit_JassSyn.Create(nil);
  MdlSyn:= TSynEdit_MdlSyn.Create(nil);
  
  InitJassSynColors(JassSyn);
  InitMdlSynColors(MdlSyn);

  //Strings
  Style := THighlightStyle.Create(False);
  Style.Title := 'Strings';
  JassSyn.Styles.Add(Style);
  MdlSyn.Styles.Add(Style);
  
  //Symbols
  Style := THighlightStyle.Create(False);
  Style.Title := 'Symbols';
  JassSyn.Styles.Add(Style);
  MdlSyn.Styles.Add(Style);

  //Params
  Style := THighlightStyle.Create(False);
  Style.Title := 'Params';
  JassSyn.Styles.Add(Style);
  MdlSyn.Styles.Add(Style);

  //Space
  Style := THighlightStyle.Create(False);
  Style.Title := 'Space';
  JassSyn.Styles.Add(Style);
  MdlSyn.Styles.Add(Style);

  //Numbers
  Style := THighlightStyle.Create(False);
  Style.Title := 'Value';
  JassSyn.Styles.Add(Style);
  MdlSyn.Styles.Add(Style);

  //Comments
  Style := THighlightStyle.Create(False);
  Style.Title := 'Comment';
  JassSyn.Styles.Add(Style);
  MdlSyn.Styles.Add(Style);

  //MDL syntop - Big Blocks
  Style := THighlightStyle.Create(True);
  Style.Names.Add('Model');
  Style.Names.Add('Version');
  Style.Names.Add('Sequences');
  Style.Names.Add('Textures');
  Style.Names.Add('Materials');
  Style.Names.Add('Geoset');
  Style.Names.Add('GeosetAnim');
  Style.Names.Add('Bone');
  Style.Names.Add('Attachment');
  Style.Names.Add('PivotPoints');
  Style.Names.Add('ParticleEmitter2');
  Style.Names.Add('Camera');
  Style.Names.Add('EventObject');
  Style.Names.Add('CollisionShape');

  Style.Title := 'Big Blocks';
  MdlSyn.Styles.Add(Style);

  //MDL syn - Functions
  Style := THighlightStyle.Create(True);
  Style.Title := 'Small Blocks';
  Style.Names.LoadFromFile(AppPath+'mdldata.dt');
  MdlSyn.Styles.Add(Style);

  //Big Blocks
  Style := THighlightStyle.Create(True);
  Style.Names.Add('function');
  Style.Names.Add('endfunction');
  Style.Names.Add('if');
  Style.Names.Add('then');
  Style.Names.Add('endif');
  Style.Names.Add('elseif');
  Style.Names.Add('else');
  Style.Names.Add('loop');
  Style.Names.Add('endloop');
  Style.Names.Add('globals');
  Style.Names.Add('endglobals');
  Style.Names.Add('type');
  Style.Names.Add('native');

  Style.Title := 'Big Blocks';
  JassSyn.Styles.Add(Style);



  //Small Blocks 7
  Style := THighlightStyle.Create(True);
  Style.Names.Add('call');
  Style.Names.Add('extends');
  Style.Names.Add('set');
  Style.Names.Add('local');
  Style.Names.Add('exitwhen');
  Style.Names.Add('takes');
  Style.Names.Add('returns');
  Style.Names.Add('array');
  Style.Names.Add('not');
  Style.Names.Add('return');
  Style.Names.Add('constant');
  Style.Title := 'Small Blocks';
  JassSyn.Styles.Add(Style);

  //Minor Constants
  Style := THighlightStyle.Create(True);
  Style.Names.Add('nothing');
  Style.Names.Add('null');
  Style.Names.Add('true');
  Style.Names.Add('false');
  Style.Title := 'Minor Constants';
  JassSyn.Styles.Add(Style);

    //Types
  Style := THighlightStyle.Create(True);
  Style.Title := 'Types';
  Style.Callback := JassUnit.IsType;
  JassSyn.Styles.Add(Style);

  //Functions
  Style := THighlightStyle.Create(True);
  Style.Title := 'Functions';
  Style.Callback := JassUnit.IsFunc;
  JassSyn.Styles.Add(Style);

  //Variables
  Style := THighlightStyle.Create(True);
  Style.Title := 'Variables';
  Style.Callback := JassUnit.IsVar;
  JassSyn.Styles.Add(Style);

  //Consts
  Style := THighlightStyle.Create(True);
  Style.Title := 'Constants';
  Style.Callback := JassUnit.IsConst;
  JassSyn.Styles.Add(Style);

  JassSyn.AssignStyleTree;
  MdlSyn.AssignStyleTree;

  LoadSynSettings;

  JassSyn.FoldRegions.Add(rtKeyWord, False, False, True, 'takes', 'endfunction');

  JassSyn.FoldRegions.Add(rtKeyWord, False, False, True, 'globals', 'endglobals', Func);

  MdlSyn.FoldRegions.Add(rtChar, False, False, False, '{', '}');

	fDocuments := TList.Create;
  fUntitledIndex := 1;
end;

destructor TDocumentFactory.Destroy;
begin
	fDocuments.Free;
  inherited;
end;

function TDocumentFactory.GetDocument(Index: Integer): TDocument;
begin
	Result := TDocument( fDocuments[Index] );
end;

function TDocumentFactory.IsSearchedForTheFirstTime(S: String): Boolean;
begin
	Result := fLastSearchedForText <> S;

  if Result = True then
  	fLastSearchedForText := S;
end;

procedure TDocumentFactory.New;
begin
	with AddDocument do
  	FileName := 'Untitled'+IntToStr(fUntitledIndex);

  Document.UpdateCaption;
  Inc(fUntitledIndex);

   if GetFormVisible(frmFuncList) then
     frmFuncList.actRefreshExecute(nil);

end;

procedure TDocumentFactory.Restore(S: String);
begin
	with AddDocument do
  	FileName := 'Restored Trigger';

  Document.UpdateCaption;
  Document.Editor.Text := S;
  Document.UpdateType(Document.Mode);

   if GetFormVisible(frmFuncList) then
     frmFuncList.actRefreshExecute(nil);
end;

procedure TDocumentFactory.Open(aFileName,MPQPath: String);
var
	i: Integer;
begin
	// Check if this file isn't already open
  for i := 0 to Count - 1 do
  	if SameText(Documents[i].FileName, aFileName) and SameText(Documents[i].FileInMPQ, MPQPath) then
    begin
    	Documents[i].Activate;
      Exit;
    end;

  with AddDocument do
  	Open(aFileName,MPQPath);
end;

procedure TDocumentFactory.ReadAllFromIni;
var
	i: Integer;
begin
  LoadSynSettings;
	for i := 0 to Count - 1 do
  	Documents[i].ReadFromIni;
end;

procedure TDocumentFactory.RemoveDocument(aDocument: TDocument);
begin
	fDocuments.Remove(aDocument);
end;

procedure TDocumentFactory.SaveAll;
var
	i: Integer;
begin
	for i := 0 to Count - 1 do
  	Documents[i].Save;
end;

function TDocumentFactory.GetCount: Integer;
begin
	Result := fDocuments.Count;
end;

end.          
