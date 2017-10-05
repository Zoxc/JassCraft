unit ccCodeBools;

interface

uses Windows, Classes, SysUtils, Math, StrUtils, Dialogs, ccCodeVariables,
ccCodeFuncs, ccCodeMain;

function ParseBool(S:String; Data:TsFunctionData):String;

implementation

function ParseBool(S:String; Data:TsFunctionData):String;
begin
if S <> '' then
begin
if (S[1] = '0') or(S[1] = '1') then
Result := S[1]
else Result := CallCode(S, Data);
end;
end;    

end.
