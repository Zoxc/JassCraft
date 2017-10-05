unit ccCodeMain;

interface

uses Windows, Classes, SysUtils, Math, StrUtils, Dialogs;

type

TIfData = class(TObject)
iEnd,iJump,iStart:Integer;
end;

TScript = class;

TParams = record
Data: array of String;
end;

TsFunction = class(TObject)
  Name:String;
  Params:String;
  ParamNames:TParams;
  Start:Integer;
  Labels: array of String;
  LabelsStart: array of Integer;
  LabelTitles: array of String;
  Script: TScript;
  procedure Init(Code:String);
  function Execute(Params:TParams):String;
end;

TsFunctionData = class(TObject)
  Vars: TStringList;
  Func:TsFunction;
  constructor Create(Params, ParamNames:TParams; AFunc:TsFunction);
  destructor Destroy; override;
end;


TScript = class(TObject)
Vars: TStringList;
Functions:array of TsFunction;
constructor Create(S:String);
destructor Destroy; override;
procedure Init;
end;

var IsDebug:Boolean;

implementation

uses uMain, ccCodeStrings, ccCodeVariables, ccCodeBools, ccCodeFuncs;


destructor TsFunctionData.Destroy;
begin
  Vars.Free;
end;

constructor TsFunctionData.Create(Params, ParamNames:TParams; AFunc:TsFunction);
var AVar: TVar;
    i:Integer;
begin
 Vars := TStringList.Create;
 Func := AFunc;
 for I := 0 to High(Params.Data) do
  begin
    AVar := TVar.Create;
    AVar.Name := ParamNames.Data[i];
    case AFunc.Params[i] of
      'S': AVar.T := 'string';
      'B': AVar.T := 'boolean';
      'H': AVar.T := 'handle';
      'I': AVar.T := 'int';
    end;
    AVar.Value :=  Params.Data[i];
    Vars.AddObject(AVar.Name, AVar);
  end;
end;

function TsFunction.Execute(Params:TParams):String;
var iLine,x:Integer;
    Section:Integer;
    Data:TsFunctionData;
    Lines:TStringList;
    InFunc:Boolean;
    IfList:TList;
    Line,FirstWord,SecoundWord,Rest:String;
    
function IfData:TIfData;
var E,F,d:Boolean;
SI,CL:String;
CI,lvl:Integer;

function Pass:Boolean;
begin
Result := ParseBool(Trim(Copy(CL, Pos(' ', CL)+1, Length(CL))), Data) = '1';
end;

begin
Result := TIFData.Create;
Result.iEnd := -1;
Result.iStart := -1;
CI := iLine;
E := True;
lvl := 0;
d := False;
while E do
   begin
   CL := Trim(Lines[CI]);
   if Pos(' ', CL) <> 0 then
   SI := Trim(Copy(CL, 1, Pos(' ', CL)-1))
   else SI := CL;

         if SI = 'if' then
     Inc(lvl);

  if lvl = 1 then
   begin

   if (SI = 'if') then
      begin
      if Pass then
       begin
          F := True;
          Result.iStart := CI;
          end;
      end;

   if (SI = 'endif') then
      begin
     if Result.iEnd = -1 then
      begin
       Result.iEnd := CI -1;

      end;
      Result.iJump := CI+1;
      if Result.iStart = -1 then
      Result.iStart := CI;;
      Exit;
      end;

   if (SI = 'else')  then
      begin


      if (not F) then
       begin
          F := True;
          Result.iStart := CI;
       end
      else
       begin
       if not D then
        begin
       Result.iEnd := CI -1;
       d := True;
        end;
       end

        end;


   if (SI = 'elseif') then
      begin


      if (not F) then
       begin
       if Pass then
        begin
          F := True;
          Result.iStart := CI;
          end;
       end
      else
       begin
              if not D then
        begin
       Result.iEnd := CI -1;
       d := True;
        end;
       end

        end;

          
   end;
      if SI = 'endif' then
     Dec(lvl);



          
   Inc(CI);
   if CI = Lines.Count then
     E := False;
   end;
end;

procedure ClearIfList;
begin
  while IfList.Count > 0 do
    begin
      TIfData(IfList[0]).Free;
      IfList.Delete(0);
    end;
end;

begin
 if IsDebug then
 DebugMark(Start+1, 'F');
 Data := TsFunctionData.Create(Params, ParamNames, Self);
 iLine := 0;
 Section := 0;
 InFunc := True;
 IfList := TList.Create;

 Lines := TStringList.Create;

 while InFunc do
  begin
  Lines.Text := Labels[Section];
  Line := Trim(Lines[iLine]);
  FirstWord := Trim(Copy(line, 1, Pos(' ', line)-1));
  SecoundWord := Trim(Copy(Line, Pos(' ', Line)+1, Length(Line)));
  if Pos(' ', SecoundWord) <> 0 then
  SecoundWord := Trim(Copy(SecoundWord, 1, Pos(' ', SecoundWord)-1));
  Rest := Trim(Copy(Line, Pos(' ', Line)+1, Length(Line)));
  Rest := Trim(Copy(Rest, Pos(' ', Rest)+1, Length(Rest)));
    if IsDebug then
    if (Line <> '') and (Copy(FirstWord, 1,2) <> '//') then
  DebugMark(LabelsStart[Section]+iLine+1, 'A');

   if FirstWord = 'var' then
      MakeVar(Rest, SecoundWord, Data)
   else if FirstWord = 'if' then
     begin
       IfList.Add(IfData);
       iLine := TIfData(IfList[IfList.Count-1]).iStart;
      end
   else if FirstWord = 'set' then
     begin
      SetVar(SecoundWord, Copy(line, Pos('=', line)+2, Length(line)), Data);
      end
   else if FirstWord = 'clean' then
      begin
      FreeVar(line, Data);
      end
   else if FirstWord = 'endif' then
      begin

      end
   else if FirstWord = 'Exit' then
      begin
       Lines.Free;
       Data.Free;
       ClearIfList;
       IfList.Free;
       Exit;
      end
   else if Copy(FirstWord, 1,2) = '//' then
      begin

      end
   else if Line = '' then
      begin

      end
   else if FirstWord = 'goto' then
      begin
        for x := 0 to High(LabelTitles) do
           if SecoundWord = LabelTitles[x] then
             begin
               ClearIfList;
               iLine := -1;
               Section := x;
               Break;
             end;

      end
   else
     CallCode(Line, Data);   

   for x := 0 to IfList.Count - 1 do
     if TIfData(IfList[x]).iEnd = iLine then
      begin
        iLine := TIfData(IfList[x]).iJump-1;
        Break;
      end;

   Inc(iLine);
   if iLine = Lines.Count then
     InFunc := False;


  end;

       Lines.Free;
       Data.Free;
       ClearIfList;
       IfList.Free;
end;

procedure TsFunction.Init(Code:String);
var S:TStringList;
i,lbl,x:Integer;
data,title:String;
begin
  S := TStringList.Create;
  S.Text := Code;
  lbl := 0;
  data := '';
  title := '';
  x := Start+2;
  for i := 0 to S.Count - 1 do
   begin
     S[i] := Trim(S[i]);

     if S[i] <> '' then
      begin

     if S[i][1] = ':' then
      begin
       SetLength(Labels, lbl+1);
       SetLength(LabelTitles, lbl+1);
       SetLength(LabelsStart, lbl+1);
       LabelsStart[lbl]:= x;
       Labels[lbl]:= Data;
       LabelTitles[lbl] := title;
       Inc(lbl);
       x := i+Start+2+lbl;
       data := '';
       title := Copy(S[i], 2, Length(S[i]));
      end
      else
     data := data + S[i] + #13#10;

      end
   else
    data := data + S[i] + #13#10;
   end;

SetLength(Labels, High(Labels)+2);
SetLength(LabelTitles, High(LabelTitles)+2);
SetLength(LabelsStart, lbl+1);
LabelsStart[lbl]:= x;
Labels[lbl]:= Data;
LabelTitles[lbl] := title;
   S.Free;
end;

procedure TScript.Init;
var Params:TParams;
    i:Integer;
begin
   for i := 0 to High(Functions) do
    if LowerCase(Functions[i].Name) = 'init' then
     begin
       Functions[i].Execute(Params);
       Exit;
     end;
end;

destructor TScript.Destroy;
begin
  Vars.Free;
end;


constructor TScript.Create(S:String);
var i:Integer;
Sl:TStringList;
InFunc:Boolean;
Func: TsFunction;
Code,x,y:String;
AVar:TVar;

procedure StoreHeader;
var v:String;
  x,y: Integer;
begin
 v := Trim(Sl[i]);
 Func.Name := Trim(Copy(v, 9, Pos('(', v)-9));
 v := Copy(v, Pos('(', v)+1, Length(v));
 v := Trim(Copy(v, 1, Pos(')', v)-1));
 y := 0;
 for x := 1 to Length(v) do
   begin
     SetLength(Func.ParamNames.Data, y+1);
     if v[x] = ',' then
        Inc(y)
     else
     Func.ParamNames.Data[y] := Func.ParamNames.Data[y] + v[x];
   end;
 for x := 0 to High(Func.ParamNames.Data) do
   begin
     Func.ParamNames.Data[x] := Trim(Func.ParamNames.Data[x]);
     Func.Params := Func.Params + UpperCase(Func.ParamNames.Data[x][1]);
     Func.ParamNames.Data[x] := Trim(Copy(Func.ParamNames.Data[x], Pos(' ',Func.ParamNames.Data[x])+1, Length(Func.ParamNames.Data[x])));
   end;
end;

begin
 Vars := TStringList.Create;
 Sl := TStringList.Create;
 Sl.Text := S;
 InFunc := False;
 for I := 0 to Sl.Count - 1 do
 begin
   Sl[i] := Trim(Sl[i]);
   if Sl[i] <> '' then
    begin

    if Sl[i]='}' then
     begin
        InFunc := False;
        Func.Init(Code);
     end;
    if InFunc then
      begin
       Code := Code + Sl[i]+#13#10;
      end;
    if Sl[i]='{' then
     begin
        InFunc := True;
        Code := '';
     end;

   if Copy(Sl[i], 1, 6)='global' then
     begin
        x := Trim(Sl[i]);
        y := Trim(Copy(x, Pos(' ', x)+1, Length(x)));
        y := Trim(Copy(y, 1, Pos(' ', y)-1));
        AVar := TVar.Create;
        AVar.T := y;
        y := Trim(Copy(x, Pos(' ', x)+1, Length(x)));
        AVar.Name := Trim(Copy(y, Pos(' ', y)+1, Length(y)));
        DefaultVar(AVar); 
        Vars.AddObject(AVar.Name, AVar);
        Debug('Made global '+AVar.Name+' as '+AVar.T );
     end;

   if Copy(Sl[i], 1, 8)='function' then
     begin
        Func := TsFunction.Create;
        Func.Script := Self;
        Func.Start := i;
        SetLength(Functions, High(Functions)+2);
        Functions[High(Functions)] := Func;
        StoreHeader;
     end;

    end
    else
      if InFunc then
      begin
       Code := Code + Sl[i]+#13#10;
      end;
   
 end;
 Sl.Free;  
end;

end.
