unit uCodeFolding;

interface

uses SynEdit, SynEditCodeFolding, Graphics;


procedure InitJassFolding(SynEdit:TSynEdit);


implementation

uses uMain;

procedure InitJassFolding(SynEdit:TSynEdit);
begin
SynEdit.CodeFolding.Enabled := Settings.ReadBool('Editor', 'CodeFolding', False);
if SynEdit.CodeFolding.Enabled then
SynEdit.InitCodeFolding;
end;

end.
