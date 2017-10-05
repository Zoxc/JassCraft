unit ccForms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ccCodeFuncs, ccCodeVariables, ccCodeMain, ccCodeFuncList;

type
  TccForm = class(TForm)
    procedure Form_OnKeyUpX(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Form_OnCloseX(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Form_OnPaintX(Sender: TObject);
    procedure Form_OnKeyDownX(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

// -------------------- Form Unit
function Form_Create(S:TParams; FData: TsFunctionData):String;
function Form_ShowModal(S:TParams; FData: TsFunctionData):String;
function Form_Free(S:TParams; FData: TsFunctionData):String;
function Form_Center(S:TParams; FData: TsFunctionData):String;
function KeyToString(Key: Word):String;

implementation

function KeyToString(Key: Word):String;
begin
 case Key of
    VK_ESCAPE: Result := 'ESC';
    VK_RETURN: Result := 'RETURN';
    VK_LEFT: Result := 'LEFT';
    VK_RIGHT: Result := 'RIGHT';
 end;
end;

// -------------------- Form Unit
function Form_Center(S:TParams; FData: TsFunctionData):String;
var F:TccForm;
begin
  F := TccForm(GetVar(S.Data[0], FData).Loc);
  F.Top := Screen.DesktopTop+(((Screen.DesktopHeight-Screen.DesktopTop) div 2)-(F.Height div 2));
  F.Left := Screen.DesktopLeft+(((Screen.DesktopWidth-Screen.DesktopLeft) div 2)-(F.Width div 2));
end;
function Form_Create(S:TParams; FData: TsFunctionData):String;
var F:TccForm;
begin
 Debug('Made var '''+S.Data[0]+''' a form.');
 F := TccForm.Create(Application);
 GetVar(S.Data[0], FData).Loc := Pointer(F);
end;
function Form_ShowModal(S:TParams; FData: TsFunctionData):String;
begin
 TccForm(GetVar(S.Data[0], FData).Loc).ShowModal;
end;
function Form_Free(S:TParams; FData: TsFunctionData):String;
begin
 TccForm(GetVar(S.Data[0], FData).Loc).Free;
end;
function Form_OnTop(S:TParams; FData: TsFunctionData):String;
begin
 if S.Data[1] = '0' then
  TccForm(GetVar(S.Data[0], FData).Loc).FormStyle := fsNormal
 else TccForm(GetVar(S.Data[0], FData).Loc).FormStyle := fsStayOnTop;
end;
function Form_Canvas(S:TParams; FData: TsFunctionData):String;
begin
  GetVar(S.Data[0], FData).Loc := Pointer(TccForm(GetVar(S.Data[1], FData).Loc).Canvas);
end;
function Form_Paint(S:TParams; FData: TsFunctionData):String;
begin
  TccForm(GetVar(S.Data[0], FData).Loc).Repaint;
end;

procedure TccForm.Form_OnPaintX(Sender: TObject);
var Data: TEventData;
    Params:TParams;
begin
 Data := ReadEvent('OnPaint', TComponent(Sender));
 Data.Func.Execute(Params);
end;

procedure TccForm.Form_OnKeyDownX(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var Data: TEventData;
    Params:TParams;
begin
 Data := ReadEvent('OnKeyDown', TComponent(Sender));
 SetLength(Params.Data, 1);
 Params.Data[0] := KeyToString(Key);
 Data.Func.Execute(Params);
end;

function Form_OnPaint(S:TParams; FData: TsFunctionData):String;
var Form:TccForm;
begin
  Form := TccForm(GetVar(S.Data[0], FData).Loc);
  AssignEvent('OnPaint', S.Data[1], Form, FData);
  Form.OnPaint := Form.Form_OnPaintX;
end;


function Form_OnKeyDown(S:TParams; FData: TsFunctionData):String;
var Form:TccForm;
begin
  Form := TccForm(GetVar(S.Data[0], FData).Loc);
  AssignEvent('OnKeyDown', S.Data[1], Form, FData);
  Form.OnKeyDown := Form.Form_OnKeyDownX;
end;

function Form_OnKeyUp(S:TParams; FData: TsFunctionData):String;
var Form:TccForm;
begin
  Form := TccForm(GetVar(S.Data[0], FData).Loc);
  AssignEvent('OnKeyUp', S.Data[1], Form, FData);
  Form.OnKeyUp := Form.Form_OnKeyUpX;
end;


function Form_OnClose(S:TParams; FData: TsFunctionData):String;
var Form:TccForm;
begin
  Form := TccForm(GetVar(S.Data[0], FData).Loc);
  AssignEvent('OnClose', S.Data[1], Form, FData);
  Form.OnClose := Form.Form_OnCloseX;
end;

{$R *.dfm}

procedure TccForm.Form_OnKeyUpX(Sender: TObject; var Key: Word; Shift: TShiftState);
var Data: TEventData;
    Params:TParams;
begin
 Data := ReadEvent('OnKeyUp', TComponent(Sender));
 SetLength(Params.Data, 1);
 Params.Data[0] := KeyToString(Key);
 Data.Func.Execute(Params);
end;

procedure TccForm.Form_OnCloseX(Sender: TObject; var Action: TCloseAction);
var Data: TEventData;
    Params:TParams;
begin
 Data := ReadEvent('OnClose', TComponent(Sender));
 Data.Func.Execute(Params);
end;

procedure TccForm.FormCreate(Sender: TObject);
begin
DoubleBuffered := True;
end;


initialization
  // -------------------- Form Unit
 AddFunction('Form.Create', 'H', Form_Create);
 AddFunction('Form.Canvas', 'HH', Form_Canvas);
 AddFunction('Form.ShowModal', 'H', Form_ShowModal);
 AddFunction('Form.Paint', 'H', Form_Paint);
 AddFunction('Form.OnTop', 'HB', Form_OnTop);
 AddFunction('Form.OnPaint', 'HH', Form_OnPaint);
 AddFunction('Form.OnKeyDown', 'HH', Form_OnKeyDown);
 AddFunction('Form.OnKeyUp', 'HH', Form_OnKeyUp);
 AddFunction('Form.OnClose', 'HH', Form_OnClose);
 AddFunction('Form.Free', 'H', Form_Free);
 AddFunction('Form.Center', 'H', Form_Center);

end.
