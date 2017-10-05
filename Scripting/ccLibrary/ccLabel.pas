unit ccLabel;

interface

uses
  SysUtils, Classes, Forms, Controls, StdCtrls, ccCodeFuncs, ccCodeVariables, ccCodeMain, ccCodeFuncList;

type
  TccLabel = class(TLabel)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;


implementation

function Label_Create(S:TParams; FData: TsFunctionData):String;
var F:TccLabel;
    Form:TForm;
begin
 Debug('Made var '''+S.Data[0]+''' a label.');
 Form := TForm(GetVar(S.Data[1], FData).Loc);
 F := TccLabel.Create(Form);
 F.Parent := Form;
 F.Visible := True;
 GetVar(S.Data[0], FData).Loc := Pointer(F);
end;

function Label_Free(S:TParams; FData: TsFunctionData):String;
begin
 TccLabel(GetVar(S.Data[0], FData).Loc).Free;
end;

initialization
  // -------------------- Label Unit
 AddFunction('Label.Create', 'HH', Label_Create);
 AddFunction('Label.Free', 'H', Label_Free);

end.
