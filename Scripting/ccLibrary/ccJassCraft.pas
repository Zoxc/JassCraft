unit ccJassCraft;

interface

uses ccCodeMain, uDocuments, Dialogs, ccCodeVariables, SysUtils, Forms, ccCodeFuncs, Controls, ccCodeFuncList;

implementation


// -------------------- JassCraft Unit
function JassCraft_SelText(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';
 if S.Data[0] <> '-1' then
  Document.Editor.SelText := S.Data[0]
 else Result := Document.Editor.SelText;
end;

function JassCraft_SelLength(S:TParams; FData: TsFunctionData):String;
begin
 Result := '0';
 if S.Data[0] <> '-1' then
  Document.Editor.SelLength := StrToIntX(S.Data[0])
 else Result := IntToStr(Document.Editor.SelLength);
end;

function JassCraft_SelStart(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';
 if S.Data[0] <> '-1' then
  begin
  Document.Editor.SelStart := StrToIntX(S.Data[0]);
  end
 else
 begin
 Result := IntToStr(Document.Editor.SelStart);
 end;
end;


initialization

 AddFunction('JassCraft.SelText', 'S', JassCraft_SelText);
 AddFunction('JassCraft.SelLength', 'I', JassCraft_SelLength);
 AddFunction('JassCraft.SelStart', 'I', JassCraft_SelStart);

end.
