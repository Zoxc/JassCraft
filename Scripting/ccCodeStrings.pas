unit ccCodeStrings;

interface

uses Windows, Classes, SysUtils, Math, StrUtils, Dialogs, ccCodeVariables, ccCodeFuncs, ccCodeMain;

function ParseToString(S:String; Data:TsFunctionData):TParams;
function ParseStr(S:String; Data:TsFunctionData):String;
procedure FilterStrings(S:TParams; Data:TsFunctionData);

implementation


procedure FilterStrings(S:TParams; Data:TsFunctionData);
var i:Integer;
Func:String;
function lastP(s:String):integer;
var x:Integer;
begin
 Result := 0;
for x := 1 to Length(s) do
 if s[x] = ')' then Result := x;
end;
begin
for i := 0 to High(S.Data) do
 if (S.Data[i][1] = '|') then
   begin


    Func := Copy(S.Data[i], 2, Length(S.Data[i]));
    Func := CallCode(Func, Data);
    S.Data[i] := '+'+Func;


   end;

end;

function ParseToString(S:String; Data:TsFunctionData):TParams;
var i,lvl:Integer;
InStr,Slash:Boolean;
Cur,Func:String;
procedure AddS(r:String);
begin
SetLength(Result.Data, High(Result.Data)+2);
Result.Data[High(Result.Data)] := r;
end;
begin
InStr := False;
Slash := False;
lvl := 0;
for i := 1 to Length(S) do
 begin

  if (S[i] = '(') and (not InStr) then Inc(lvl);
  if (S[i] = ')') and (not InStr) then Dec(lvl);

  if (S[i] = '"') and (lvl = 0) then
   begin
     if not(Slash and InStr) then
      begin

     InStr := not InStr;
     if not InStr then
      begin
     if Cur <> '' then
     AddS('+'+Cur);
     Cur := '';
      end
     else
      begin
     if Func <> '' then
     AddS('|'+Func);
     Func := '';
      end;
     end
   else
     begin
   Cur := Cur + '"';
   Slash := False;
   end;

   end
  else
   begin
    if InStr then
     begin
     if S[i] <> '\' then
     if not Slash then
     Cur := Cur + S[i];
     end
    else
     begin
    Func := Func + S[i];
     end;
   end;


  if (S[i] = '+') and (not InStr) then
   begin
     if (Func <> '') and (Func <> '+') then
     AddS('|'+Copy(Func, 1, Length(Func)-1));
     Func := '';
   end;

  if Slash and InStr then
   begin
     if  (S[i]='r') then
     Cur := Cur + #13;
    if (S[i]='n') then
     Cur := Cur + #10;
     if  (S[i]='\')then
     Cur := Cur + '\';
     Slash := False;
   end
     else
 Slash := S[i] = '\';

 end;
 if Func <> '' then
 AddS('|'+Func);
 if Cur <> '' then
 AddS('+'+Cur);
 FilterStrings(Result, Data);
end;



function ParseStr(S:String; Data:TsFunctionData):String;
var
i:Integer;
Str:TParams;
begin
Result := '';
Str := ParseToString(S, Data);
for i := 0 to High(Str.Data) do
 begin
  if Str.Data[i] <> '' then
   if Str.Data[i][1] = '+' then
    Result := Result + Copy(Str.Data[i], 2, Length(Str.Data[i]));
 end;

end;

end.
