unit ccCodeFuncs;

interface

uses SysUtils, Dialogs, ccCodeMain, SynEdit;

type

TcFunc = function(P:TParams; FData: TsFunctionData):String;

TcFunction = record
Name:String;
Proc:TcFunc;
Params:String;
end;

var Funcs: array of TcFunction;

function GetFunc(Func:String):TcFunction;
procedure Debug(T:String);
procedure DebugMark(Line:Integer; T:Char);

function CallCode(Code:String; Data:TsFunctionData):String;
function GetParam(Code:String;Num:Integer):String;

implementation

uses uMain,  ccCodeVariables, ccCodeStrings, ccCodeNumbers, ccCodeBools;

procedure Debug(T:String);
begin

end;

procedure DebugMark(Line:Integer; T:Char);

begin


end;

function GetFunc(Func:String):TcFunction;
var i:Integer;
begin
 for i := 0 to High(Funcs) do
  if LowerCase(Funcs[i].Name) = LowerCase(Func) then
   begin
   Result := Funcs[i];
   Exit;
   end;
end;



function GetParam(Code:String;Num:Integer):String;
var Func:String;
i,lvl,p:Integer;
InString,Slash:Boolean;
function lastP(s:String):integer;
var x:Integer;
begin
 Result := 0;
for x := 1 to Length(Func) do
 if Func[x] = ')' then Result := x;
end;
begin
 Func := Copy(Code, Pos('(', Code)+1, Length(Code));
 Func := Copy(Func, 1, lastP(')')-1);
 Result := '';
 p := 0;
 lvl := 0;
 for i := 1 to Length(Func) do
  begin

  if (Func[i] = '"') then
    begin
     if InString then
        begin
         if not Slash then
      InString := False;
        end
     else
      begin
       InString := True;
      end;

    end;

  if (lvl = 0) then
   begin

  if (Func[i] = ',') and not InString then
   begin
        Inc(p);
   end
   else
    begin

      if p = Num then
       begin
   Result := Result+Func[i];
       end;

    end;

   end;

   if lvl > 0 then
   begin
   if p = Num then
    begin
   Result := Result+Func[i];
    end;
   end;

  if Func[i] = '\' then
  Slash := True
  else Slash := False;
  

  if (Func[i] = '(') and not InString then
   Inc(lvl);
  if (Func[i] = ')') and not InString then
   Dec(lvl);
   
  end;
 Result := Trim(Result);
end;


function CallCode(Code:String; Data:TsFunctionData):String;
var Func,ParamType:String;
Params:TParams;
AFunc:TcFunction;
sFunc:TsFunction;
I:Integer;
ScriptFunc:Boolean;
begin

 sFunc := nil;
 ScriptFunc := False;
 if Pos('(', Code) <> 0 then
  begin

 Func := Trim(Copy(Code, 1, Pos('(', Code)-1));
 AFunc := GetFunc(Func);
 if AFunc.Name = '' then
  begin

 for i := 0 to High(Data.Func.Script.Functions) do
  begin
    if LowerCase(Data.Func.Script.Functions[i].Name) = LowerCase(Func) then
     begin
       sFunc := Data.Func.Script.Functions[i];
       ScriptFunc := True;
       Break;
     end;
  end;
 if not ScriptFunc then
  begin
 Debug('Function "'+Func+'" don''t exist');
 Exit;
  end; 
  end;



 if ScriptFunc then
    ParamType := sFunc.Params
 else ParamType := AFunc.Params;

 SetLength(Params.Data, Length(ParamType));
 for i := 0 to Length(ParamType)-1 do
  begin
   Params.Data[i] := GetParam(Code, i);
   case ParamType[i+1] of
    'S': Params.Data[i] := ParseStr(Params.Data[i], Data);
    'I': Params.Data[i] := ParseInt(Params.Data[i], Data);
    'B': Params.Data[i] := ParseBool(Params.Data[i], Data);
    'H': Params.Data[i] := Trim(Params.Data[i]);
   end;
  end;


 if ScriptFunc then
  Result := sFunc.Execute(Params)
 else
  Result := AFunc.Proc(Params, Data);
end
 else
  begin
  Result := GetVarValue(Code, Data);
  end;
end;


end.
