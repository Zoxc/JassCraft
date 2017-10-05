unit uScriptingEngine;

interface

uses ccCodeMain, Windows, SysUtils, Classes, uUtils;

procedure ScriptingEngineInit;

var Scripts:array of TScript;

implementation

procedure ScriptingEngineInit;
var sr: TSearchRec;
S:TStringList;
begin
    S := TStringList.Create;
    if FindFirst(AppPath+'Scripts\*.jcs', faAnyFile	, sr) = 0 then
    begin

      repeat
        SetLength(Scripts, High(Scripts)+2);
        S.LoadFromFile(AppPath+'Scripts\'+sr.Name);
        Scripts[High(Scripts)] := TScript.Create(S.Text);
        Scripts[High(Scripts)].Init;
        S.Clear;
      until FindNext(sr) <> 0;
      FindClose(sr);

    end;
    S.Free;

end;

end.
