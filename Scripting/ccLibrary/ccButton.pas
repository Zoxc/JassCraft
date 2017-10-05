unit ccButton;

interface

uses
  SysUtils, Classes, Forms, Controls, StdCtrls, ccCodeFuncs, ccCodeVariables, ccCodeMain, ccCodeFuncList;

type
  TccButton = class(TButton)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    procedure Button_OnClickX(Sender: TObject);
  end;


implementation

procedure TccButton.Button_OnClickX(Sender: TObject);
var Data: TEventData;
    Params:TParams;
begin
 Data := ReadEvent('OnClick', TComponent(Sender));
 Data.Func.Execute(Params); 
end;

function Button_OnClick(S:TParams; FData: TsFunctionData):String;
var Button:TccButton;
begin
  Button := TccButton(GetVar(S.Data[0], FData).Loc);
  AssignEvent('OnClick', S.Data[1], Button, FData);
  Button.OnClick := Button.Button_OnClickX;
end;

function Button_Create(S:TParams; FData: TsFunctionData):String;
var F:TccButton;
    Form:TForm;
begin
 Debug('Made var '''+S.Data[0]+''' a button.');
 Form := TForm(GetVar(S.Data[1], FData).Loc);
 F := TccButton.Create(Form);
 F.Parent := Form;
 F.Visible := True;
 GetVar(S.Data[0], FData).Loc := Pointer(F);
end;

function Button_Free(S:TParams; FData: TsFunctionData):String;
begin
 TccButton(GetVar(S.Data[0], FData).Loc).Free;
end;

initialization
  // -------------------- Button Unit
 AddFunction('Button.Create', 'HH', Button_Create);
 AddFunction('Button.OnClick', 'HH', Button_OnClick);
 AddFunction('Button.Free', 'H', Button_Free);

end.
