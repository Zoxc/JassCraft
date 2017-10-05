unit ccCodeFuncList;

interface

uses Windows, ccCodeMain, Classes, ccCodeVariables, SysUtils, Dialogs, Forms, Controls, ccCodeFuncs;

type
TEventData = record
  Event: String;
  Func: TsFunction;
  Script:TScript;
end;

TEventDataList = class
  Data: array of TEventData;
end;

procedure AddFunction(Name, Params:String; Proc:TcFunc);

procedure AssignEvent(EventName, FuncName:String; Obj:TComponent; Data:TsFunctionData);
function ReadEvent(EventName:String; Obj:TComponent):TEventData;

function StrToIntX(S:String):Integer;


implementation

function StrToIntX(S:String):Integer;
begin
Result := Round(StrToFloat(S));
end;

function ReadEvent(EventName:String; Obj:TComponent):TEventData;
var E:TEventDataList;
    i:Integer;
begin
 E :=  TEventDataList(Pointer(Obj.Tag));
 for i := 0 to High(E.Data) do
     if E.Data[i].Event = EventName then
      begin
        Result := E.Data[i];
        Exit;
      end;
end;

procedure AssignEvent(EventName, FuncName:String; Obj:TComponent; Data:TsFunctionData);
var E:TEventDataList;
    i:Integer;
    function FindFunc:TsFunction;
    var x:Integer;
    begin
    for x := 0 to High(Data.Func.Script.Functions) do
    if LowerCase(Data.Func.Script.Functions[x].Name) = LowerCase(FuncName) then
     begin
       Result := Data.Func.Script.Functions[x];
       Exit;
     end;
    end;
begin
  if Obj.Tag <> 0 then
   begin
    E :=  TEventDataList(Pointer(Obj.Tag));
   end
  else
   begin
    E := TEventDataList.Create;
    Obj.Tag := Integer(Pointer(E));
   end;
   
   for i := 0 to High(E.Data) do
     if E.Data[i].Event = EventName then
      begin
        E.Data[i].Func := FindFunc;
        E.Data[i].Script := Data.Func.Script;
        Exit;
      end;

   SetLength(E.Data, High(E.Data)+2);

   with E.Data[High(E.Data)] do
    begin
       Event := EventName;
       Func := FindFunc;
       Script := Data.Func.Script;
    end
end;

procedure AddFunction(Name, Params:String; Proc:TcFunc);
var Func:TcFunction;
begin
 Func.Name := Name;
 Func.Proc := Proc;
 Func.Params := Params;
 SetLength(Funcs, High(Funcs)+2);
 Funcs[High(Funcs)] := Func;
end;



initialization

end.
