unit ccCodeNumbers;

interface

uses Windows, Classes, SysUtils, Math, StrUtils, Dialogs, ccCodeVariables, ccCodeMain;

type TNumber = TStringList;

function ParseToNumber(S:String; Data:TsFunctionData):TNumber;
function ExecMath(Int1, Int2:Extended; Op:Char):Extended;
function ParseInt(S:String; Data:TsFunctionData):String;
procedure FilterInt(S:TNumber; Data:TsFunctionData);
function ExecIntFunc(S, P1:String):String;
function AssignOp(N:String;Plus:Boolean):String;

const Digits: array[0..11] of Char = '0123456789. ';
const Ops: array[0..2] of Char = '*/^';

implementation

uses ccCodeFuncs;

function AssignOp(N:String;Plus:Boolean):String;
begin
   if Pos('-', N) <> 0 then
    begin
       N := Copy(N, 2, Length(N));
     if Plus then
      Result := '-'+N
     else Result := '+'+N;
    end
   else
    begin
     if Plus then
      Result := '+'+N
     else Result := '-'+N;
    end;
end;


function ExecIntFunc(S, P1:String):String;
var Par:Extended;
begin
 try
 Par := StrToFloat(P1)
 except on E:Exception do Par := 0;
 end;
  if LowerCase(S) = 'cos' then
    Result := Format('%g', [cos(Par)]);
end;


procedure FilterInt(S:TNumber; Data:TsFunctionData);
var i:Integer;
Func,P:String;
function lastP(s:String):integer;
var x:Integer;
begin
 Result := 0;
for x := 1 to Length(s) do
 if s[x] = ')' then Result := x;
end;
begin

for i := 0 to S.Count-1 do

  if (S[i] <> '') and (S[i][1] = '|') then
   begin
    Func := Copy(S[i], 4, Pos('(', S[i])-4);
    P := Copy(S[i], Pos('(', S[i])+1, Length(S[i]));
    P := Copy(P, 1, lastP(P)-1);
    if (Func = '') and (Pos('(', S[i]) <> 0) then
     begin
     if P = '' then P := '0';
     P := ParseInt(P, Data);
     S[i] := AssignOp(P, S[i][2] = '+');
     end
    else
     begin
       S[i] := AssignOp(CallCode(Trim(Copy(S[i], 4,Length(S[i]))), Data), S[i][2] = '+');
     end;



   end;
end;

function ParseToNumber(S:String; Data:TsFunctionData):TNumber;
var i,lvl:Integer;
Number,Func:String;
Op:Char;
InFunc:Boolean;


function PassOp:Boolean;
var x:Integer;
begin
Result := False;
for x := 0 to High(Ops) do
 if (S[i] = Ops[x]) then
  begin
  Result := True;
  Exit;
  end;
end;

function PassDigits:Boolean;
var x:Integer;
begin
Result := False;
for x := 0 to High(Digits) do
 if (S[i] = Digits[x]) then
  begin
  Result := True;
  Exit;
  end;
end;

begin
Result := TNumber.Create;
Number := '';
InFunc := False;
i := 1;
lvl := 0;
Op := '+';
for i := 1 to Length(S) do
 begin
  if InFunc then
   begin
     if lvl = 0 then
      begin

       if (S[i] = '*') or (S[i] = '/') or (S[i] = '^') or (S[i] = '-') or  (S[i] = '+') then
        begin

        InFunc := False;
        if Trim(Func) <> '' then
        Result.Add('|'+Op+'|'+Func);
        Func := '';

        if (S[i] = '-') or (S[i] = '+') then
        Op := S[i]
        else Result.Add(S[i]);

        end;

      end;

     if S[i] = '(' then Inc(lvl);
     if S[i] = ')' then
       begin
       Dec(lvl);
       if lvl = 0 then
        begin
        InFunc := False;
        Func := Func+S[i];
        if Trim(Func) <> '' then
        Result.Add('|'+Op+'|'+Func);
        Func := '';
        end;
       end;
       if InFunc then
     Func := Func+S[i];
   end
   else
    begin
  if PassDigits then
   begin
   if S[i] <> ' ' then
   Number := Number+S[i]
   end
  else
   begin
    if Number <> '' then
    Result.Add(Op+Number);
    Number := '';
    if (S[i] = '-') or (S[i] = '+') then
    Op := S[i]
    else
     begin
     if PassOp then
     Result.Add(S[i])
     else
      begin
       Func := Func+S[i];
       if S[i] = '(' then lvl := 1
       else lvl := 0;
       InFunc := True;
      end;

     end;


   end;
   end;
 end;
    if Number <> '' then
    Result.Add(Op+Number);
    if Trim(Func) <> '' then
    Result.Add('|'+Op+'|'+Func);
    FilterInt(Result, Data);
end;


function ExecMath(Int1, Int2:Extended; Op:Char):Extended;
begin
Result := 0;
case Op of
 '/': Result := Int1/Int2;
 '*': Result := Int1*Int2;
 '^': Result := Power(Int1, Int2);
end;
end;

function ParseInt(S:String; Data:TsFunctionData):String;
var V:Extended;
i:Integer;
Number:TNumber;
Op:Char;

begin
Op := #0;
Number := ParseToNumber(S, Data);
V := 0;
for i := 0 to Number.Count-1 do
 begin
   if (Number[i][1] = '*') or (Number[i][1] = '/') or (Number[i][1] = '^') then
    Op := Number[i][1]
   else
    begin
     if Op <> #0 then
      begin

       V := ExecMath(V, StrToFloat(Number[i]), Op);
       Op := #0;
      end
     else
      begin
   V := V + StrToFloat(Number[i]);
      end;
    end;
 end;

Result := Format('%g', [V]);
end;

end.
