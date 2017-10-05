unit ccGraphics;

interface

uses ccCodeMain, Windows, Graphics, ccCodeVariables, ccCodeFuncs, SysUtils, Dialogs,
Forms, Controls, ccCodeFuncList, Types;

implementation

function Bitmap_Create(S:TParams; FData: TsFunctionData):String;
var F:TBitmap;
begin
 Debug('Made var '''+S.Data[0]+''' a bitmap.');
 F := TBitmap.Create;
 GetVar(S.Data[0], FData).Loc := Pointer(F);
end;

function Bitmap_Width(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TBitmap(GetVar(S.Data[0], FData).Loc).Width := StrToIntX(S.Data[1])
 else Result := IntToStr(TBitmap(GetVar(S.Data[0], FData).Loc).Width );
end;

function Bitmap_Height(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TBitmap(GetVar(S.Data[0], FData).Loc).Width := StrToIntX(S.Data[1])
 else Result := IntToStr(TBitmap(GetVar(S.Data[0], FData).Loc).Width );
end;

function Bitmap_Canvas(S:TParams; FData: TsFunctionData):String;
begin
  GetVar(S.Data[0], FData).Loc := Pointer(TBitmap(GetVar(S.Data[1], FData).Loc).Canvas);
end;
function Bitmap_Free(S:TParams; FData: TsFunctionData):String;
begin
 TBitmap(GetVar(S.Data[0], FData).Loc).Free;
end;

// -------------------- Canvas Unit

function Canvas_Fill(S:TParams; FData: TsFunctionData):String;
begin
 TCanvas(GetVar(S.Data[0], FData).Loc).FillRect(Rect(
 StrToIntX(S.Data[1]),
 StrToIntX(S.Data[2]),
 StrToIntX(S.Data[3]),
 StrToIntX(S.Data[4])
 ));
end;

function Canvas_Brush(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TCanvas(GetVar(S.Data[0], FData).Loc).Brush.Color := Round(StrToFloat(S.Data[1]))
 else Result := IntToStr(TCanvas(GetVar(S.Data[0], FData).Loc).Brush.Color );
end;

function Canvas_Pen(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TCanvas(GetVar(S.Data[0], FData).Loc).Pen.Color := StrToIntX(S.Data[1])
 else Result := IntToStr(TCanvas(GetVar(S.Data[0], FData).Loc).Pen.Color );
end;

function Canvas_Draw(S:TParams; FData: TsFunctionData):String;
begin
 TCanvas(GetVar(S.Data[0], FData).Loc).Draw(StrToIntX(S.Data[1]), StrToIntX(S.Data[2]), TGraphic(GetVar(S.Data[3], FData).Loc));
end;

function Canvas_Font_Name(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TCanvas(GetVar(S.Data[0], FData).Loc).Font.Name := S.Data[1]
 else Result := TCanvas(GetVar(S.Data[0], FData).Loc).Font.Name;
end;

function Canvas_Font_Size(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TCanvas(GetVar(S.Data[0], FData).Loc).Font.Size := StrToIntX(S.Data[1])
 else Result := IntToStr(TCanvas(GetVar(S.Data[0], FData).Loc).Font.Size );
end;

function Canvas_Font_Color(S:TParams; FData: TsFunctionData):String;
begin
 Result := '';if S.Data[1] <> '' then
  TCanvas(GetVar(S.Data[0], FData).Loc).Font.Color := StrToIntX(S.Data[1])
 else Result := IntToStr(TCanvas(GetVar(S.Data[0], FData).Loc).Font.Color );
end;

function Canvas_Font_Draw(S:TParams; FData: TsFunctionData):String;
begin
 TCanvas(GetVar(S.Data[0], FData).Loc).TextOut(StrToIntX(S.Data[1]), StrToIntX(S.Data[2]), S.Data[3]);
end;

function Canvas_Font_Width(S:TParams; FData: TsFunctionData):String;
begin
 Result := IntToStr(TCanvas(GetVar(S.Data[0], FData).Loc).TextWidth(S.Data[1]));
end;


// -------------------- Graphics Unit

function Graphics_MakeColor(S:TParams; FData: TsFunctionData):String;
begin
Result := IntToStr(RGB(
 StrToIntX(S.Data[0]),
 StrToIntX(S.Data[1]),
 StrToIntX(S.Data[2])
 ));
end;



initialization

// -------------------- Bitmap Unit
 AddFunction('Bitmap.Create', 'H', Bitmap_Create);
 AddFunction('Bitmap.Canvas', 'HH', Bitmap_Canvas);
 AddFunction('Bitmap.Width', 'HI', Bitmap_Width);
 AddFunction('Bitmap.Height', 'HI', Bitmap_Height);
 AddFunction('Bitmap.Free', 'H', Bitmap_Free);

// -------------------- Canvas Unit
 AddFunction('Canvas.Fill', 'HIIII', Canvas_Fill);
 AddFunction('Canvas.Pen', 'HI', Canvas_Pen);
 AddFunction('Canvas.Brush', 'HI', Canvas_Brush);
 AddFunction('Canvas.Draw', 'HIIH', Canvas_Brush);
 AddFunction('Canvas.Font.Size', 'HI', Canvas_Font_Size);
 AddFunction('Canvas.Font.Name', 'HS', Canvas_Font_Name);
 AddFunction('Canvas.Font.Color', 'HI', Canvas_Font_Color);
 AddFunction('Canvas.Font.Draw', 'HIIS', Canvas_Font_Draw);
 AddFunction('Canvas.Font.Width', 'HS', Canvas_Font_Width);

// -------------------- Graphics Unit

  AddFunction('Graphics.MakeColor', 'III', Graphics_MakeColor);

end.
