unit ccMath;

interface

uses ccCodeMain, Dialogs, ccCodeVariables, SysUtils, Forms, ccCodeFuncs, Controls, ccCodeFuncList;

implementation

// -------------------- Application Unit
function Math_Cos(S:TParams; FData: TsFunctionData):String;
begin
 Result := Format('%g', [Cos(StrToFloat(S.Data[0]))]);
end;

function Math_Sin(S:TParams; FData: TsFunctionData):String;
begin
 Result := Format('%g', [Sin(StrToFloat(S.Data[0]))]);
end;



initialization
  DecimalSeparator := '.';
// -------------------- Math
 AddFunction('Math.Cos', 'I', Math_Cos);
 AddFunction('Math.Sin', 'I', Math_Sin);
 Constant('PI', Format('%g', [PI]));


end.
