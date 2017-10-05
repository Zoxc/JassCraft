// by eGust
unit SynJass;

{$I SynEdit.inc}

interface

uses
  SysUtils,
  Classes,
{$IFDEF SYN_CLX}
  QControls,
  QGraphics,
{$ELSE}
  Windows,
  Controls,
  Graphics,
{$ENDIF}
  SynEdit,
  SynEditTypes,
  SynEditHighlighter;

type
  TtkTokenKind = (
    tkComment,
    tkIdentifier,
    tkKey,
    tkNull,
    tkSpace,
    tkString,
    tkOperator,
    tkParenthesis,
    tkBadParenthesis,
    tkValue,
    tkUnknown);

  TRangeState = (rsUnKnown, rsComment, rsValue, rsOperator, rsString);

  TProcTableProc = procedure of object;
  THighlightStyleKeyword = function (S:String):boolean;

type
  THighlightStyle = class(TObject)
  Font:TFont;
  BgColor:TColor;
  Keyword:Boolean;
  Callback:THighlightStyleKeyword;
  Title:String;
  Names:TStringList;
  constructor Create(IsKeyword:Boolean);
  destructor Detroy;
  function IndexOf(S:String):Boolean;
  end;

  TSynEdit_JassSyn = class(TSynCustomHighlighter)
  private
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    fRange: TRangeState;
    Run: LongInt;
    fStringLen: Integer;
    fToIdent: PChar;
    fTokenPos: Integer;
    fTokenID: TtkTokenKind;

    iIndexOfKey : Integer;
    iMaxKeys    : Integer;

    fCommentAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    fValueAttri: TSynHighlighterAttributes;
    fOperatorAttri: TSynHighlighterAttributes;
    fParenthesisAttri     : TSynHighlighterAttributes;
    fBadParenthesisAttri  : TSynHighlighterAttributes;

    fIdentifierAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;

    function KeyHash(ToHash: PChar): Boolean;
    procedure IdentProc;
    procedure UnknownProc;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
    procedure NullProc;
    procedure SpaceProc;
    procedure CRProc;
    procedure LFProc;
    procedure CommentProc;
    procedure StringProc;
    procedure ValueProc;
    procedure NumberValueProc;
    procedure OperatorProc;
    procedure ParenthesisProc;

  protected
    //function OnMouseKeyDown();
    //function GetIdentChars: TSynIdentChars; override;
    //function IsFilterStored: Boolean; override;
  public
    iParenthesisX, iBadParenthesisX, iParenthesisY  : Integer;
    Theme: array of TColor;
    ThemeStr: array of String;
      fKeysAttri: array of TSynHighlighterAttributes;
    Styles: TList;
    procedure ApplyTheme(S:TSynEdit);
    procedure LoadSynSettings;
    procedure AssignStyleTree;
    constructor Create(AOwner: TComponent); override;
    //{$IFNDEF SYN_CPPB_1} class {$ENDIF}
    //function GetLanguageName: string; override;
    {function GetRange: Pointer; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;}
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes; override;
    function GetEOL: Boolean; override;
    function GetTokenID: TtkTokenKind;
    procedure SetLine(NewValue: String; LineNumber: Integer); override;
    function GetToken: String; override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri write fCommentAttri;
    property ValueAttri: TSynHighlighterAttributes read fValueAttri write fValueAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri write fStringAttri;

    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri write fSpaceAttri;
  end;

implementation

{uses
  SynEditStrConst;}

{$IFDEF SYN_COMPILER_3_UP}
resourcestring
{$ELSE}
const
{$ENDIF}
  SYNS_FilterJass = 'Jass files (*.j)|*.j';
  SYNS_LangJass = 'Warcraft III Jass';
  SYNS_AttrJass = 'Jass';

const
  SYNS_NoSkip   : TSynIdentChars = ['_', 'a'..'z', 'A'..'Z', '0'..'9'];
  SYNS_Number   : TSynIdentChars = ['0'..'9'];
  SYNS_Operator : TSynIdentChars = ['!','*','-','+', '/','=',
                                    '[',']','<','>',','];
  SYNS_Parenthesis  : TSynIdentChars = ['(',')'];

var
  Identifiers: array[#0..#255] of ByteBool;

destructor THighlightStyle.Detroy;
begin
      if Keyword then
       begin
      Names.Text := '';
      Names.Free;
       end;
      Font.Free;
end;

constructor THighlightStyle.Create(IsKeyword:Boolean);
begin
Keyword := IsKeyword;
BgColor := clWhite;

if IsKeyword then
  Names := TStringList.Create;
Font := TFont.Create;
end;

function THighlightStyle.IndexOf(S:String):Boolean;
var i:Integer;
begin
Result := False;
for i := 0 to Names.Count-1 do
 if Names[i] = S then
  begin
   Result := True;
   Break;
  end;
end;

procedure MakeIdentTable;
var
  I   : Char;
begin
  for I := #0 to #255 do
     Identifiers[I] := I in SYNS_NoSkip;
end;

procedure TSynEdit_JassSyn.AssignStyleTree;
var
  i   : Integer;
  Style: THighlightStyle;
begin
  iMaxKeys    := Styles.Count;
  iIndexOfKey := 0;

  SetLength(fKeysAttri,iMaxKeys);
  for i:=0 to Styles.Count-1 do begin
    Style := THighlightStyle(Styles.List[i]);
    fKeysAttri[i] := TSynHighLighterAttributes.Create(Style.Title);
    AddAttribute(fKeysAttri[i]);

    if Style.Title='Comment' then
      fCommentAttri   := fKeysAttri[i]
    else if Style.Title='Space' then
     begin
      fIdentifierAttri  := fKeysAttri[i];
      fSpaceAttri := TSynHighLighterAttributes.Create('Space ');
      AddAttribute(fSpaceAttri);
     end
    else if Style.Title='Strings' then
      fStringAttri    := fKeysAttri[i]
    else if Style.Title='Symbols' then
    begin
      fOperatorAttri  := fKeysAttri[i];
    end
    else if Style.Title='Params' then
    begin
      fParenthesisAttri     := TSynHighLighterAttributes.Create('Parenthesis');
      fBadParenthesisAttri  := TSynHighLighterAttributes.Create('BadParenthesis');
      AddAttribute(fParenthesisAttri);
      AddAttribute(fBadParenthesisAttri);
    end
    else if Style.Title='Value' then
      fValueAttri     := fKeysAttri[i]; 

  end;

  SetAttributesOnChange(DefHighlightChange);
  //InitIdent;
  MakeMethodTables;
  fRange := rsUnknown;
end;

procedure TSynEdit_JassSyn.ApplyTheme(S:TSynEdit);
begin
S.Color := Theme[3];
S.SelectedColor.Background := Theme[1];
S.SelectedColor.Foreground := Theme[2];
S.ActiveLineColor := Theme[0];
S.Gutter.Color := Theme[4];
S.Gutter.Font.Color := Theme[5];
S.CodeFolding.FolderBarColor := Theme[6];
S.CodeFolding.FolderBarLinesColor := Theme[8];
S.CodeFolding.CollapsedLineColor := Theme[7];
end;

procedure TSynEdit_JassSyn.LoadSynSettings;
var i:Integer;
JASS:THighlightStyle;
begin
for i := 0 to Styles.Count-1 do
 begin
  JASS := THighlightStyle(Styles[i]);
  fKeysAttri[i].Foreground := JASS.Font.Color;
  fKeysAttri[i].Background := JASS.BgColor;
  fKeysAttri[i].Style := JASS.Font.Style;
 end;
end;


function TSynEdit_JassSyn.KeyHash(ToHash: PChar): Boolean;
var
  sT  : String;
  Style  : THighlightStyle;
  i : Integer;

begin
  Result := false;
  
  while ToHash^ in SYNS_NoSkip do
    inc(ToHash);

  fStringLen := ToHash - fToIdent;

  sT  := fToIdent;
  sT  := Copy(sT, 1, fStringLen);
  for i:= 0 to Styles.Count-1 do begin
    Style := THighlightStyle(Styles[i]);

    if Style.Keyword then
     begin
      if Assigned(Style.Callback) then
       begin
      if Style.Callback(sT) then
         begin
         Result  := true;
         iIndexOfKey := i;
         Exit;
      end; //if
       end
      else
       begin
      if Style.IndexOf(sT) then
         begin
         Result  := true;
         iIndexOfKey := i;
         Exit;
      end; //if
       end;
     end; //if
  end; //for
end;

function TSynEdit_JassSyn.IdentKind(MayBe: PChar): TtkTokenKind;
begin
  fToIdent := MayBe;
  if KeyHash(MayBe) then
    Result := tkKey
  else
    Result := tkIdentifier;
end;

procedure TSynEdit_JassSyn.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      '/': fProcTable[I] := CommentProc;
      '''': fProcTable[I] := ValueProc;
      '"': fProcTable[I] := StringProc;
      #1..#9,
      #11,
      #12,
      #14..#32 : fProcTable[I] := SpaceProc;
      '0'..'9' : fProcTable[I] := NumberValueProc;
    else
      if I in SYNS_NoSkip then
        fProcTable[I] := IdentProc
      else if I in SYNS_Number then
        fProcTable[I] := NumberValueProc
      else if I in SYNS_Operator then
        fProcTable[I] := OperatorProc
      else if I in SYNS_Parenthesis then
        fProcTable[I] := ParenthesisProc
      else
        fProcTable[I] := UnknownProc;
    end;
end;

procedure TSynEdit_JassSyn.SpaceProc;
begin
  fTokenID := tkSpace;
  repeat
    inc(Run);
  until not (fLine[Run] in [#1..#32]);
end;

procedure TSynEdit_JassSyn.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TSynEdit_JassSyn.CRProc;
begin
  fTokenID := tkSpace;
  inc(Run);
  if fLine[Run] = #10 then
    inc(Run);
end;

procedure TSynEdit_JassSyn.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TSynEdit_JassSyn.CommentProc;
begin
  Inc(Run);
  if (fLine[Run] = '/') then
  begin
    fRange := rsComment;
    while not (fLine[Run] in [#0, #10, #13]) do
      Inc(Run);
    fTokenID := tkComment;
  end
  else
    fTokenID := tkOperator;
end;

procedure TSynEdit_JassSyn.StringProc;
begin
  //Inc(Run);
  fRange := rsString;
  repeat
    Inc(Run);
    if (fLine[Run]='"')and(fLine[Run-1]<>'\') then
    begin
      Inc(Run);
      break;
    end; //if
  until fLine[Run] in [#0, #10, #13];
  
  fRange    := rsUnKnown;
  fTokenID := tkString;
end;

procedure TSynEdit_JassSyn.ValueProc;
begin
  //Inc(Run);
  fRange := rsValue;
  repeat
    Inc(Run);
    if fLine[Run]='''' then begin
      Inc(Run);
      break;
    end; //if
  until fLine[Run] in [#0, #10, #13];

  fRange    := rsUnKnown;
  fTokenID  := tkValue;
end;

procedure TSynEdit_JassSyn.NumberValueProc;
begin
  Inc(Run);
  fRange := rsValue;

  while (fLine[Run] in SYNS_Number)or(fLine[Run]='.') do
    Inc(Run);

  fTokenID  := tkValue;
end;

procedure TSynEdit_JassSyn.OperatorProc;
begin
  Inc(Run);
  fRange := rsOperator;

  while (fLine[Run] in SYNS_Operator) and
      ((fLine[Run]='/')and(fLine[Run+1]<>'/')) do
    Inc(Run);

  fTokenID := tkOperator;
end;

procedure TSynEdit_JassSyn.ParenthesisProc;
begin
  fTokenID := tkOperator;
  if fLineNumber=iParenthesisY then
  begin
    if Run=iParenthesisX then
      fTokenID := tkParenthesis;
    if Run=iBadParenthesisX then
      fTokenID := tkBadParenthesis;
  end; //if

  Inc(Run);
  fRange := rsOperator;
end;

constructor TSynEdit_JassSyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  iMaxKeys  := 0;
  Styles:= TList.Create;

  iParenthesisX     := -1;
  iBadParenthesisX  := -1;
  iParenthesisY     := -1;

  fCommentAttri     := nil;
  fIdentifierAttri  := nil;
  fSpaceAttri       := nil;
  fValueAttri       := nil;
  fStringAttri      := nil;
  fParenthesisAttri     := nil;
end;

procedure TSynEdit_JassSyn.SetLine(NewValue: String; LineNumber: Integer);
begin
  fLine := PChar(NewValue);
  Run := 0;
  fLineNumber := LineNumber;
  Next;
end;

procedure TSynEdit_JassSyn.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));
  inc(Run, fStringLen);
  while Identifiers[fLine[Run]] do
    Inc(Run);
end;

procedure TSynEdit_JassSyn.UnknownProc;
begin
{$IFDEF SYN_MBCSSUPPORT}
  if FLine[Run] in LeadBytes then
    Inc(Run,2)
  else
{$ENDIF}
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSynEdit_JassSyn.Next;
begin
  fTokenPos := Run;
  fRange := rsUnknown;
  fProcTable[fLine[Run]];
end;

function TSynEdit_JassSyn.GetDefaultAttribute(Index: integer): TSynHighLighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT    : Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER : Result := fIdentifierAttri;
    SYN_ATTR_STRING     : Result := fStringAttri;
    SYN_ATTR_WHITESPACE : Result := fSpaceAttri;
  else
    Result := nil;
  end;
end;

function TSynEdit_JassSyn.GetEOL: Boolean;
begin
  Result := fTokenID = tkNull;
end;

function TSynEdit_JassSyn.GetToken: String;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TSynEdit_JassSyn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TSynEdit_JassSyn.GetTokenAttribute: TSynHighLighterAttributes;
begin
  case GetTokenID of
    tkComment:
      Result  := fCommentAttri;
    tkIdentifier:
      Result  := fIdentifierAttri;
    tkSpace:
      Result  := fSpaceAttri;
    tkString:
      Result  := fStringAttri;
    tkValue:
      Result  := fValueAttri;
    tkUnknown:
      Result  := fIdentifierAttri;
    tkKey:
      Result  := fKeysAttri[iIndexOfKey];
    tkOperator:
      Result  := fOperatorAttri;
    tkParenthesis:
      result  := fParenthesisAttri;
    tkBadParenthesis:
      result  := fBadParenthesisAttri;
  else
    Result := nil;
  end;
end;

function TSynEdit_JassSyn.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TSynEdit_JassSyn.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

{function TSynEdit_JassSyn.GetIdentChars: TSynIdentChars;
begin
  Result := SYNS_NoSkip;
end;

function TSynEdit_JassSyn.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterJass;
end;}

//{$IFNDEF SYN_CPPB_1} class {$ENDIF}
{function TSynEdit_JassSyn.GetLanguageName: string;
begin
  Result := SYNS_LangJass;
end;}

{procedure TSynEdit_JassSyn.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TSynEdit_JassSyn.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

function TSynEdit_JassSyn.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;
}
initialization
  MakeIdentTable;
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynEdit_JassSyn);
{$ENDIF}
end.
