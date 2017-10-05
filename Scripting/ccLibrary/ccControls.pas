unit ccControls;

interface

uses ccCodeMain,ccForms,ccLabel,ccButton, ccCodeVariables, SysUtils, Dialogs, Forms, Controls, ccCodeFuncList;

implementation


// -------------------- Control Unit
function Control_Left(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TControl(GetVar(S.Data[0], FData).Loc).Left := StrToIntX(S.Data[1])
 else Result := IntToStr(TControl(GetVar(S.Data[0], FData).Loc).Left );
end;
function Control_Top(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TControl(GetVar(S.Data[0], FData).Loc).Top := StrToIntX(S.Data[1])
 else Result := IntToStr(TControl(GetVar(S.Data[0], FData).Loc).Top );
end;
function Control_Width(S:TParams; FData: TsFunctionData):String;
begin
 Result := 'a';if S.Data[1] <> '' then
  TControl(GetVar(S.Data[0], FData).Loc).Width := StrToIntX(S.Data[1])
 else Result := IntToStr(TControl(GetVar(S.Data[0], FData).Loc).Width );  
end;
function Control_Height(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TControl(GetVar(S.Data[0], FData).Loc).Height := StrToIntX(S.Data[1])
 else Result := IntToStr(TControl(GetVar(S.Data[0], FData).Loc).Height );
end;
function Control_Text(S:TParams; FData: TsFunctionData):String;
var P:Pointer;
begin
 Result := '';
 P := GetVar(S.Data[0], FData).Loc;

 if (TObject(P) is TccForm) then
    begin
      if S.Data[1] <> '' then
       TccForm(P).Caption := S.Data[1]
      else Result := TccForm(P).Caption;
    end;

 if (TObject(P) is TccLabel) then
    begin
      if S.Data[1] <> '' then
       TccLabel(P).Caption := S.Data[1]
      else Result := TccLabel(P).Caption;
    end;

 if (TObject(P) is TccButton) then
    begin
      if S.Data[1] <> '' then
       TccButton(P).Caption := S.Data[1]
      else Result := TccButton(P).Caption;
    end;

end;
function Control_Visible(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TControl(GetVar(S.Data[0], FData).Loc).Visible := S.Data[1] = '1'
 else
 begin
 if TControl(GetVar(S.Data[0], FData).Loc).Visible then Result := '1'
 else Result := '0';
 end;
end;



initialization

  // -------------------- Control Unit
 AddFunction('Control.Left', 'HI', Control_Left);
 AddFunction('Control.Top', 'HI', Control_Top);
 AddFunction('Control.Width', 'HI', Control_Width);
 AddFunction('Control.Height', 'HI', Control_Height);
 AddFunction('Control.Visible', 'HB', Control_Visible);
 AddFunction('Control.Text', 'HS', Control_Text);




end.
