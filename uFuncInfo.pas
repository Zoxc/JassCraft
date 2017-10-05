unit uFuncInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, uDocuments, JassUnit, SynEditTypes, SynEditMiscClasses,
  SynEdit, SynJass, Themes;

type
  TTipForm = class(TForm)
    procedure FormPaint(Sender: TObject);
    function TextWdth(S:String):Integer;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    AutoChangeCase:Boolean;
    mFunc:TFunction;
    LineY,LineX,LineParam:Integer;
    procedure CloseToolTip;
    procedure MakeToolTip(X,Y,Param:Integer);
    procedure UpdateToolTip(X,Y:Integer);
    procedure Popup(AFunc:TFunction; X,Y,Param:Integer);
    function GetTipParamX(Line:String;X:Integer):Integer;
    function GetTipX(Line:String;X:Integer):Integer;
    procedure RelocPopup;
  end;

var
  TipForm: TTipForm;

implementation

uses uMain;

{$R *.dfm}

procedure TTipForm.RelocPopup;
begin
if Visible then
Popup(mFunc, LineX, LineY, LineParam);
end;

function TTipForm.GetTipParamX(Line:String;X:Integer):Integer;
var i,b:Integer;
begin
Result := 0;
b := 0;
for i := X-1 downto 1 do
 begin
 if Line[i] = ')' then
  Inc(b);

 if Line[i] = '(' then
     Dec(b);

 if Line[i] = ',' then
   if b = 0 then
    Inc(Result);

  end;
end;

function TTipForm.GetTipX(Line:String;X:Integer):Integer;
var i,b:Integer;
begin
Result := -1;
b := 0;
for i := X-1 downto 1 do
 begin
 if Line[i] = ')' then
  Inc(b);
 if Line[i] = '(' then
   if b > 0 then
   Dec(b)
   else
    begin
   Result := i;
   Break;
    end;
  end;
end;

procedure TTipForm.UpdateToolTip(X,Y:Integer);
var Line:String;
TipPos,Pr:Integer;
begin

if LineY <> Y then
 begin
 CloseToolTip;
 Exit;
 end;
Line := Document.Editor.Lines[Y];
TipPos := GetTipX(Line, X);
if TipPos = -1 then
 begin
 CloseToolTip;
 Exit;
 end;
 Pr := GetTipParamX(Line, X);

if (TipPos <> LineX) or (Pr <> LineParam) then
MakeToolTip(TipPos, Y, Pr);
end;

procedure TTipForm.CloseToolTip;
begin
Hide;
LineY := -1;
LineX := -1;
end;

procedure TTipForm.Popup(AFunc:TFunction; X,Y,Param:Integer);
var S:String;
function CaretXPix: Integer;
var
  p: TPoint;
  t:TDisplayCoord;
  function LogicalToPhysicalPos(p: TPoint): TPoint;
var
  s: string;
  i, L: integer;
  x2: integer;
begin
  if p.Y - 1 < Document.Editor.Lines.Count then begin
    s := Document.Editor.Lines[p.Y - 1];
    l := Length(s);
    x2 := 0;
    for i := 1 to p.x - 1 do begin
      if (i <= l) and (s[i] = #9) then
        inc(x2, Document.Editor.TabWidth - (x mod Document.Editor.TabWidth))
      else
        inc(x2);
    end;
    p.x := x2 + 1;
  end;
  Result := p;
end;
begin
  p := LogicalToPhysicalPos(Point(X, Y+1));
  t.Column := p.X;
  t.Row := p.Y;
  Result := Document.Editor.RowColumnToPixels(t).X;
end;

function CaretYPix: Integer;
var  t:TDisplayCoord;
begin
t.Column := 1;
  t.Row := Y+1;
  Result := Document.Editor.RowColumnToPixels(t).Y;
end;

begin
  LineY := Y;
  LineX := X;
  mFunc := AFunc;
  Left :=  Document.Editor.ClientToScreen(Point(0,0)).x+CaretXPix+2;
  Top := Document.Editor.ClientToScreen(Point(0,0)).y+CaretYPix+2-27;
  LineParam := Param;
  MainForm.SynCode.Text := mFunc.Code;
  S := mFunc.Code;
  if Pos(#13, S) <> 0 then S := Copy(mFunc.Code, 0, Pos(#13, mFunc.Code)-1);
  Caption := StripSpaces(S);
  Width := TextWdth(Caption)+4;
  Visible := True;
  Self.Repaint;
  Document.Editor.SetFocus;
end;

procedure TTipForm.MakeToolTip(X,Y,Param:Integer);
var Line,Func:String;
    AFunc:TFunction;
    Start,i:Integer;
    b:Byte;
    Pass,St:Boolean;

procedure FilterFunc(Doc:TJassDoc);
var x :Integer;
begin
for x := 0 to High(Doc.Functions)-1 do
 begin
 if AutoChangeCase then
  begin
    if LowerCase(TFunction(Doc.Functions[x]).Name) = LowerCase(Func) then
       AFunc := TFunction(Doc.Functions[x]);
  end
 else
  begin
    if TFunction(Doc.Functions[x]).Name = Func then
       AFunc := TFunction(Doc.Functions[x]);
  end;
  end;
end;


begin
 if X = 1 then Exit;
 Line := ' '+Document.Editor.Lines[Y];
 for i := X-1 downto 1 do
  begin
   Pass := False;
   b := Ord(LowerCase(Line)[i]);
   if b >= 97 then
   if b <= 122 then
    begin
     St := False;
     Pass := True;
     end;

   if b >= 48 then
   if b <= 57 then
   begin
     St := False;
     Pass := True;
     end;

  if (b = 32) and St then
     Pass := True;  

  // if b = 45 then  Pass := True;
  // if b = 95 then  Pass := True;

    if not Pass then
     begin
     Start := i+1;
     Break;
     end;
  end;
  Func := Trim(Copy(Line, Start, X-Start+1));
  if Trim(Func) = '' then
   begin
     CloseToolTip;
     Exit;
   end;
  for i := 0 to High(JassLib.Docs)-1 do
    begin
     FilterFunc(JassLib.Docs[i]);
  end;
  FilterFunc(Document.JassDoc);
  if AFunc.Name = '' then Exit;

  if (AutoChangeCase) and (AFunc.Name <> Func) then
   begin
    Line := Document.Editor.Lines[Y];
    Delete(Line, X-Length(AFunc.Name), Length(AFunc.Name));
    Insert(AFunc.Name, Line, X-Length(AFunc.Name));
    Document.Editor.Lines[Y] := Line;
   end;
  Popup(AFunc, X,Y, Param); 
end;

function TTipForm.TextWdth(S:String):Integer;
var AType:Boolean;
DrawPos,p:Integer;
DrawText,Ins,Prm:String;
begin
with Canvas do
 begin

 Font.Name := 'Tahoma';
 Font.Size := 8;

 Ins := Trim(Copy(Caption, Pos(' ', Caption)+1, Length(Caption)));


 //    DrawY := Round( ( 21 /2) - (TextHeight('Wg')/2) );
 //    DrawPos := 4;

     Font.Style := [fsBold];
     p := 0;

     DrawText := '(';

     DrawPos := DrawPos+TextWidth(DrawText);


     DrawText := Copy(Ins, Pos('takes ', Ins)+5, Length(Ins));
     Prm := Copy(DrawText, 0, Pos(' returns', DrawText)-1);
     AType := True;
     Font.Style := [];
     while Pos(' ', Prm) <> 0 do
      begin
     Prm := Copy(Prm, Pos(' ', Prm)+1, Length(Prm));
      if LineParam = p then Font.Style := [fsBold]
      else Font.Style := [];


      if Pos(' ', Prm) <> 0 then
      DrawText := Copy(Prm, 0, Pos(' ', Prm)-1)+' '
      else DrawText := Prm;

      DrawPos := DrawPos+TextWidth(DrawText);
      AType := not AType;
      if AType then
      Inc(p);
      end;

     Font.Style := [fsBold];


     DrawText := ') ';

     DrawPos := DrawPos+TextWidth(DrawText);

     DrawText := Trim(Copy(Ins, Pos('returns ', Ins)+8, Length(Ins)));
     Font.Style := [];
     if DrawText <> 'nothing' then
      begin
        Font.Style := [];



     DrawPos := DrawPos+TextWidth('returns ');


         DrawPos := DrawPos+TextWidth(DrawText);

      end;



end;
Result := DrawPos;
end;


procedure TTipForm.CreateParams(var Params: TCreateParams);
const
  CS_DROPSHADOW = $20000;
begin
  inherited;
  if Themes.ThemeServices.ThemesAvailable then
   begin
   Params.Style := WS_POPUP;
   Params.WindowClass.style := Params.WindowClass.style or CS_DROPSHADOW;
   end;
end;


procedure TTipForm.FormPaint(Sender: TObject);
var AType:Boolean;
DrawPos,DrawY,p:Integer;
DrawText,Ins,Prm:String;
function Dark(T:TColor):TColor;
var r: array[0..2] of byte;
begin
r[0] := GetRValue(T);
r[1] := GetGValue(T);
r[2] := GetBValue(T);
r[0] := r[0]-15;
r[1] := r[1]-15;
r[2] := r[2]-15;
Result := RGB(r[0],r[1],r[2]);
end;
begin

with Canvas do
 begin
 Pen.Color := Dark(DocumentFactory.JassSyn.Theme[0]);;
 Brush.Style := bsSolid;
 Brush.Color := DocumentFactory.JassSyn.Theme[0];
 Rectangle(0,0,Width,Height);
 Brush.Style := bsClear;
 Font.Name := 'Tahoma';
 Font.Size := 8;

 Ins := Trim(Copy(Caption, Pos(' ', Caption)+1, Length(Caption)));


     DrawY := Round( ( 21 /2) - (TextHeight('Wg')/2) );
     DrawPos := 4;

     Font.Style := [fsBold];
     Font.Color := clGray;
     p := 0;
     DrawText := '(';
     TextOut(DrawPos, DrawY, DrawText);
     DrawPos := DrawPos+TextWidth(DrawText);


     DrawText := Copy(Ins, Pos('takes ', Ins)+5, Length(Ins));
     Prm := Copy(DrawText, 0, Pos(' returns', DrawText)-1);
     AType := True;
     Font.Style := [];
     while Pos(' ', Prm) <> 0 do
      begin

           if LineParam = p then Font.Style := [fsBold]
      else Font.Style := [];

     Prm := Copy(Prm, Pos(' ', Prm)+1, Length(Prm));
      if AType then
     Font.Color := THighlightStyle(DocumentFactory.JassSyn.Styles[9]).Font.Color
      else Font.Color := THighlightStyle(DocumentFactory.JassSyn.Styles[3]).Font.Color;


      if Pos(' ', Prm) <> 0 then
      DrawText := Copy(Prm, 0, Pos(' ', Prm)-1)+' '
      else DrawText := Prm;
      TextOut(DrawPos, DrawY, DrawText);
      DrawPos := DrawPos+TextWidth(DrawText);
      AType := not AType;
      if AType then
      Inc(p);
      end;

     Font.Style := [fsBold];
     Font.Color := clGray;

     DrawText := ') ';
     TextOut(DrawPos, DrawY, DrawText);
     DrawPos := DrawPos+TextWidth(DrawText);

     DrawText := Trim(Copy(Ins, Pos('returns ', Ins)+8, Length(Ins)));
        Font.Style := [];
     if DrawText <> 'nothing' then
      begin
        Font.Color :=  THighlightStyle(DocumentFactory.JassSyn.Styles[7]).Font.Color;

        TextOut(DrawPos, DrawY, 'returns ');
     DrawPos := DrawPos+TextWidth('returns ');

        Font.Color := THighlightStyle(DocumentFactory.JassSyn.Styles[9]).Font.Color;

         TextOut(DrawPos, DrawY, DrawText);

      end;



 end;
end;

procedure TTipForm.FormCreate(Sender: TObject);
begin
 AutoChangeCase := Settings.ReadBool('Jass', 'FuncCase', True);
end;

procedure TTipForm.FormActivate(Sender: TObject);
begin
MainForm.SetFocus;
end;

end.

