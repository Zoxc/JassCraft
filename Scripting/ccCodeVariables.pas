unit ccCodeVariables;

interface

uses Windows, Classes, SysUtils, Math, StrUtils, Dialogs, ccCodeMain;

type
TVar = class(TObject)
 Name:String;
 T:String;
 Value:String;
 Loc: Pointer;
end;

var VarList: TStringList;
    GlobalConst:TVar;

function GetVar(S:String; Data:TsFunctionData):TVar;
procedure AddVar(A:TVar; List:TStringList);
procedure MakeVar(Name,T:String; Data:TsFunctionData);
procedure SetVar(Name,V:String; Data:TsFunctionData);
procedure FreeVar(S:String; Data:TsFunctionData);
function GetVarValue(S:String; Data:TsFunctionData):String;
function ToVars(S:String):TStringList;
procedure DefaultVar(Vr:TVar);
procedure Constant(Name, Data:String);

implementation

uses ccCodeStrings, ccCodeNumbers, ccCodeBools, ccCodeFuncs;

function ToVars(S:String):TStringList;
var i:Integer;Ss:String;
begin
Result := TStringList.Create;
for i := 1 to Length(S) do
 begin
  if S[i]=',' then
   begin
   Result.Add(Trim(Ss));
   Ss := '';
   end
  else
   Ss := Ss+S[i];
 end;
end;

procedure DefaultVar(Vr:TVar);
begin
 if Vr.T = 'int' then
 Vr.Value := '0'
 else if Vr.T = 'string' then
 Vr.Value := ''
 else if Vr.T = 'boolean' then
 Vr.Value := '0'
end;
          
procedure SetVar(Name,V:String; Data:TsFunctionData);
var Vr:TVar;
begin
 Vr := GetVar(Name, Data);
 if Vr.T = 'int' then
 Vr.Value := ParseInt(V, Data)
 else if Vr.T = 'string' then
 Vr.Value := ParseStr(V, Data)
 else if Vr.T = 'boolean' then
 Vr.Value := ParseBool(V, Data);
 Debug('Var: '+Name +' is now "'+Vr.Value+'"');
end;

procedure MakeVar(Name,T:String; Data:TsFunctionData);
var
    A:TVar;
begin
 A := TVar.Create;
 A.Name := Name;
 A.T := T;
 DefaultVar(A);
 AddVar(A, Data.Vars);
 Debug('Made '''+Name+''' as '''+T+'''');
end;

function GetVar(S:String; Data:TsFunctionData):TVar;
var i:Integer;
begin
 Result := nil;
 I := Data.Vars.IndexOf(S);
 if i <> -1 then
  begin
    Result := TVar(Data.Vars.Objects[i]);
    Exit;
  end;

 I := Data.Func.Script.Vars.IndexOf(S);
 if i <> -1 then
  begin
    Result := TVar(Data.Func.Script.Vars.Objects[i]);
    Exit;
  end;

 I := VarList.IndexOf(S);
 if i <> -1 then
  begin
    Result := TVar(VarList.Objects[i]);
    Exit;
  end;
end;

function GetVarValue(S:String; Data:TsFunctionData):String;
begin
 Result := GetVar(S, Data).Value;
//  Result := '1';
end;

procedure AddVar(A:TVar; List:TStringList);
begin
 List.AddObject(A.Name, A);
end;

procedure FreeVar(S:String; Data:TsFunctionData);
var I:Integer;
begin
 I := VarList.IndexOf(S);
 TVar(i).Free;
 VarList.Delete(i);
 Debug('Cleaned '+S);
end;

procedure Constant(Name, Data:String);
var GlobalConst:TVar;
begin
 GlobalConst := TVar.Create;
 GlobalConst.Name := Name;
 GlobalConst.Value := Data;
 AddVar(GlobalConst, VarList);
end;

initialization
  DecimalSeparator := '.';
VarList := TStringList.Create;
Constant('true', '1');
Constant('false', '0');

end.
