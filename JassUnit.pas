unit JassUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, StrUtils, Dialogs,
  SynJass, Graphics;

type
  TStrArray= record
  Strs : array of String[255];
  end;

  TFunction = record
     Name, Returns, Code: String;
     Native, Constant:Boolean;
     ParamName: array of String[255];
     ParamType: array of String[255];
     Line:Integer;
  end;
  PFunction = ^TFunction;

  TGlobal = record
     Name, VarType, Code: String;
     Constant, IsArray:Boolean;
     Line:Integer;
  end;                     
  PGlobal = ^TGlobal;

  TType = record
     NewName, OldName, Code: String;
  end;

  TJassDoc = class(TObject)
    Name:String;
    Filename:String;
    Functions: array of TFunction;
    Globals: array of TGlobal;
    Types: array of TType;
    procedure ParseStrings(S:TStrings);
    procedure ParseFile(S:String);
  end;

  TJassLib = class(TObject)
  private
    { Private declarations }
  public
    Docs: array of TJassDoc;
    constructor Create;
  end;

var
  JassLib: TJassLib;

function StripSpaces(S:String):String;
function StrToArray(S:String): TStrArray;
function IsFunc(S:String):Boolean;
function IsConst(S:String):Boolean;
function IsType(S:String):Boolean;
function IsVar(S:String):Boolean;

procedure bAddDoc(Doc:TJassDoc; Lib:TJassLib);
procedure bAddType(T:TType; Doc:TJassDoc);
procedure bAddFunc(T:TFunction; Doc:TJassDoc);
procedure bAddGlobal(T:TGlobal; Doc:TJassDoc);

implementation

uses uMain, uUtils;

procedure bAddDoc(Doc:TJassDoc; Lib:TJassLib);
var i:Integer;
begin
i := High(Lib.Docs);
SetLength(Lib.Docs, i+2);
Lib.Docs[i+1] := Doc;
end;

procedure bAddFunc(T:TFunction; Doc:TJassDoc);
var i:Integer;
begin
i := High(Doc.Functions);
SetLength(Doc.Functions, i+2);
Doc.Functions[i+1] := T;
end;

procedure bAddGlobal(T:TGlobal; Doc:TJassDoc);
var i:Integer;
begin
i := High(Doc.Globals);
SetLength(Doc.Globals, i+2);
Doc.Globals[i+1] := T;
end;

procedure bAddType(T:TType; Doc:TJassDoc);
var i:Integer;
begin
i := High(Doc.Types);
SetLength(Doc.Types, i+2);
Doc.Types[i+1] := T;
end;

function IsType(S:String):Boolean;
var i,x:Integer;
    Doc:TJassDoc;
begin
 Result := False;
 for i := 0 to High(JassLib.Docs) do
   begin
     Doc := TJassDoc(JassLib.Docs[i]);
     for x := 0 to High(Doc.Types) do
      begin
     if (Doc.Types[x].NewName = S) then
       begin
      Result := True;
      Exit;
       end;
     end;
   end;
end;

function IsVar(S:String):Boolean;
var i,x:Integer;
    Doc:TJassDoc;
begin
 Result := False;
 for i := 0 to High(JassLib.Docs) do
   begin
     Doc := TJassDoc(JassLib.Docs[i]);
     for x := 0 to High(Doc.Globals) do
      begin
     if (Doc.Globals[x].Name = S) and (Doc.Globals[x].Constant = false) then
       begin
      Result := True;
      Exit;
       end;
     end;
   end;
end;

function IsConst(S:String):Boolean;
var i,x:Integer;
    Doc:TJassDoc;
begin
 Result := False;
 for i := 0 to High(JassLib.Docs) do
   begin
     Doc := TJassDoc(JassLib.Docs[i]);
     for x := 0 to High(Doc.Globals) do
      begin
     if (Doc.Globals[x].Name = S) and (Doc.Globals[x].Constant = true) then
       begin
      Result := True;
      Exit;
       end;
     end;
   end;
end;

function IsFunc(S:String):Boolean;
var i,x:Integer;
    Doc:TJassDoc;
begin
 Result := False;
 for i := 0 to High(JassLib.Docs) do
   begin
     Doc := TJassDoc(JassLib.Docs[i]);
     for x := 0 to High(Doc.Functions) do
      begin
     if Doc.Functions[x].Name = S then
       begin
      Result := True;
      Exit;
       end;
     end;
   end;
end;

constructor TJassLib.Create;
var Doc: TJassDoc;
count,i:Integer;
fn:String;

procedure AddNativeType(S:String);
var T:TType;
begin
T.NewName := S;
T.OldName := '';
T.Code := '// Wc3 Hardcoded Native ';
bAddType(T, Doc);
end;

begin
inherited Create;
count := Settings.ReadInteger('JassFiles', 'Count', 0);
Doc := TJassDoc.Create;
Doc.Name := 'Native JASS';
Doc.Filename := ':';

AddNativeType('handle');
AddNativeType('real');
AddNativeType('string');
AddNativeType('integer');
AddNativeType('boolean');
AddNativeType('code');

bAddDoc(Doc, Self);

for i := 0 to count-1 do
 begin
  Doc := TJassDoc.Create;
  fn := Settings.ReadString('JassFiles', IntToStr(i), '');
  if Pos(':', fn) = 0 then
   fn := AppPath+fn;
  Doc.Filename := fn;
  Doc.Name := ExtractFileName(fn);
  if FileExists(fn) then
   begin
    Doc.ParseFile(fn);
    bAddDoc(Doc, Self);
   end
  else Doc.Free;

 end;
end;

function StrToArray(S:String): TStrArray;
var t:String;
i:Integer;
begin
i := 0;
t := Trim(S)+' ';
while Pos(' ', t)<>0 do
 begin
 SetLength(Result.Strs, i+1);
 Result.Strs[i] := Copy(t, 0, Pos(' ', t)-1);
 t := TrimLeft(Copy(t, Pos(' ', t)+1, Length(t)));
 i := i+1;
 end;
end;


   {
function StrToArray ( S : String): TStrArray;
var
	P, pt	: PChar;
	i : Integer;
begin
	P	:= PChar ( S);
	pt	:= P;
	i	:= 0;
	while P^<>#0 do
	begin
		if P^=' ' then Inc ( i);
		Inc ( P);
	end;
	
	SetLength ( Result.Str, i);
	P	:= pt;
	while P^<>#0 do
	begin
		if P^=' ' then
		  //dosomething
		Inc ( P);
	end;
end;

     }







function StripSpaces(S:String):String;
var temp:String;
begin
temp := S;
while Pos('  ', temp)<>0 do
 begin
  temp := AnsiReplaceStr(temp, '  ', ' ');
 end;
Result := temp;
end;

procedure TJassDoc.ParseFile(S:String);
var F:TStringList;
begin
F:=TStringList.Create;
F.LoadFromFile(S);
ParseStrings(F);
F.Free;
end;


procedure TJassDoc.ParseStrings(S:TStrings);
var i:Integer;
line:String;
InGlobals:Boolean;

function CountChar(S,C:String):Integer;
var i,ct:Integer;
begin
ct := 0;
for i := 1 to Length(S) do
  if S[i] = C[1] then
   Inc(ct);

Result := ct;
end;

procedure AddFunction(LineStrs: TStrArray);
var Func:TFunction;
Params,pi,pit:Integer;
ParamsArr:TStrArray;
lineex:String;
begin
Func.Name := LineStrs.Strs[1];
Func.Line := i+2;
Params := CountChar(line, ',')+1;
SetLength(Func.ParamName, Params);
SetLength(Func.ParamType, Params);
lineex := AnsiReplaceStr(line, ',', ' ');
lineex := Copy(lineex, Pos('takes ', lineex)+5, Length(lineex));
ParamsArr := StrToArray(lineex);
if ParamsArr.Strs[0] <> 'nothing' then
 begin
pit := 0;
for pi := 1 to Params do
 begin
   Func.ParamType[pi-1] := ParamsArr.Strs[pit];
   Func.ParamName[pi-1] := ParamsArr.Strs[pit+1];
   Inc(pit, 2);
 end;
 end;
Func.Returns := ParamsArr.Strs[High(ParamsArr.Strs)];

pi := i+1;
pit := 0;
while pi < S.Count do
begin
if Copy(Trim(S[pi]), 0, Length('endfunction')) = 'endfunction' then
 begin
 pit := pi;
 Break;
 end;
Inc(pi);
end;
 Func.Code := S[i];
for pi := i+1 to pit do
 begin
 Func.Code := Func.Code + #13#10 + S[pi];
 end;

i := pit-1;
bAddFunc(Func, Self);
SetLength(ParamsArr.Strs, 0);
end;

procedure AddNative(LineStrs: TStrArray);
var Native:TFunction;
Start,Params,pi,pit:Integer;
ParamsArr:TStrArray;
lineex:String;
begin
Native.Native := True;
Native.Line := i+1;
Start := 0;
if LineStrs.Strs[0] = 'constant' then
 begin
  Native.Constant := True;
  Start := 1;
 end;
Native.Name := LineStrs.Strs[Start+1];
Params := CountChar(line, ',')+1;
SetLength(Native.ParamName, Params);
SetLength(Native.ParamType, Params);
lineex := AnsiReplaceStr(line, ',', ' ');
lineex := Copy(lineex, Pos('takes ', lineex)+5, Length(lineex));
ParamsArr := StrToArray(lineex);

if ParamsArr.Strs[0] <> 'nothing' then
 begin
pit := 0;
for pi := 1 to Params do
 begin
   Native.ParamType[pi-1] := ParamsArr.Strs[pit];
   Native.ParamName[pi-1] := ParamsArr.Strs[pit+1];
   Inc(pit, 2);
 end;
 end;
Native.Returns := ParamsArr.Strs[High(ParamsArr.Strs)];
Native.Code := line;
bAddFunc(Native, Self);
SetLength(ParamsArr.Strs, 0);
end;

procedure AddGlobal(LineStrs: TStrArray);
var Global:TGlobal;
Start:Integer;
begin

Global.Line := i+1;
Start := 0;
if LineStrs.Strs[0] = 'constant' then
 begin
  Global.Constant := True;
  Start := 1;
 end;
Global.VarType := LineStrs.Strs[Start];
if LineStrs.Strs[Start+1] = 'array' then
 begin
  Global.IsArray := True;
  Inc(Start);
 end;
Global.Name := LineStrs.Strs[Start+1];
Global.Code := line;
bAddGlobal(Global, Self);
end;

procedure AddType(LineStrs: TStrArray);
var VarType:TType;
begin
VarType.NewName := LineStrs.Strs[1];
VarType.OldName := LineStrs.Strs[3];
VarType.Code := line;
bAddType(VarType, Self);
end;

procedure ParseLine;
var LineStrs: TStrArray;
begin
line := S[i];
if Copy(Trim(line), 0, 2) = '//' then
 begin
  Inc(i);
  Exit;
 end;
if Trim(line) = '' then
 begin
  Inc(i);
  Exit;
 end;
LineStrs := StrToArray(line);

if InGlobals then
 begin
 if LineStrs.Strs[0] = 'endglobals' then
     InGlobals := False
 else
    AddGlobal(LineStrs);
 end
 
else
 begin
 if LineStrs.Strs[0] = 'globals' then
   begin
   InGlobals := True;

   end

 else if LineStrs.Strs[0] = 'type' then
  AddType(LineStrs)
 else if LineStrs.Strs[0] = 'constant' then
  AddNative(LineStrs)
 else if LineStrs.Strs[0] = 'native' then
  AddNative(LineStrs)
 else if LineStrs.Strs[0] = 'function' then
  AddFunction(LineStrs)
end;
SetLength(LineStrs.Strs, 0);
Inc(i);
end;

begin
 InGlobals := False;
 SetLength(Self.Functions, 0);
 SetLength(Self.Globals, 0);
 SetLength(Self.Types, 0);
 i := 0;
 while i < S.Count do
  begin
  ParseLine;
  end;
end;

end.
