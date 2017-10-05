unit ccSystem;

interface

uses ccCodeMain, Dialogs, ccCodeVariables, SysUtils, Forms, ccCodeFuncs, Controls, ccCodeFuncList;

implementation

// -------------------- Application Unit
function Application_Update(S:TParams; FData: TsFunctionData):String;
begin
 Application.ProcessMessages;
end;


// -------------------- System Unit
function System_Print(S:TParams; FData: TsFunctionData):String;
begin
  Debug('Print: '+S.Data[0]);
end;
function System_Sleep(S:TParams; FData: TsFunctionData):String;
begin
  Sleep(Round(StrToFloat(S.Data[0])));
end;
function System_Message(S:TParams; FData: TsFunctionData):String;
begin
  ShowMessage(S.Data[0]);
end;
function System_Ask(S:TParams; FData: TsFunctionData):String;
begin
  if MessageDlg(S.Data[0], mtCustom, [mbYes,mbNo], 0) = mrYes then
     Result := '1'
  else Result := '0';
end;

// -------------------- Boolean handling
function Boolean_Not(S:TParams; FData: TsFunctionData):String;
begin
  if S.Data[0] = '0' then
   Result := '1'
  else Result := '0';
end;
function Boolean_Or(S:TParams; FData: TsFunctionData):String;
begin
  if (S.Data[0] = '1') or (S.Data[1] = '1') then
   Result := '1'
  else Result := '0';
end;
function Boolean_And(S:TParams; FData: TsFunctionData):String;
begin
  if (S.Data[0] = '1') and (S.Data[1] = '1') then
   Result := '1'
  else Result := '0';
end;

// -------------------- Comparing

function Compare(S:TParams; FData: TsFunctionData):String;
begin

 if S.Data[1] = '=' then
    begin

      if (S.Data[0] = S.Data[2]) then
           Result := '1'
      else Result := '0';
    end;
 if S.Data[1] = '>' then
    begin
      if (StrToIntX(S.Data[0]) > StrToIntX(S.Data[2])) then
           Result := '1'
      else Result := '0';
    end;
 if S.Data[1] = '<' then
    begin
      if (StrToIntX(S.Data[0]) < StrToIntX(S.Data[2])) then
           Result := '1'
      else Result := '0';
    end;
 if S.Data[1] = '>=' then
    begin
      if (StrToIntX(S.Data[0]) >= StrToIntX(S.Data[2])) then
           Result := '1'
      else Result := '0';
    end;
 if S.Data[1] = '<=' then
    begin
      if (StrToIntX(S.Data[0]) <= StrToIntX(S.Data[2])) then
           Result := '1'
      else Result := '0';
    end;
 if S.Data[1] = '!=' then
    begin
      if (S.Data[0] <> S.Data[2]) then
           Result := '1'
      else Result := '0';
    end;
end;


initialization
 
// -------------------- Boolean handling
 AddFunction('not', 'B', Boolean_Not);
 AddFunction('or', 'B', Boolean_Or);
 AddFunction('and', 'B', Boolean_And);

// -------------------- Comparing
 AddFunction('Compare.Str', 'SSS', Compare);
 AddFunction('Compare.Int', 'ISI', Compare);
 AddFunction('Compare.Bool', 'BSB', Compare);

 // -------------------- System Unit
 AddFunction('System.Print', 'S', System_Print);
 AddFunction('System.Sleep', 'I', System_Sleep);
 AddFunction('System.Ask', 'S', System_Ask);
 AddFunction('System.Message', 'S', System_Message);

 // -------------------- Application Unit
 AddFunction('Application.Update', '', Application_Update);



end.
