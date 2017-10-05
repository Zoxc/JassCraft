unit ccMenus;

interface

uses Classes, ccCodeMain, Dialogs, ccCodeVariables, SysUtils, Forms, ccCodeFuncs,
Controls, ccCodeFuncList, TBX, uMain, Menus;

type
  TccMenuItem = class(TTBXItem)
  procedure Menu_OnClickX(Sender: TObject);
  end;

implementation


function Menu_CreateRoot(S:TParams; FData: TsFunctionData):String;
var F:TccMenuItem;
  i:Integer;
  Root:TTBXItem;
begin
 for i := 0 to MainForm.MainMenu.Items.Count-1 do
  begin
   if MainForm.MainMenu.Items.Items[i].Caption = S.Data[2] then
    begin
    Root := TTBXItem(MainForm.MainMenu.Items.Items[i]);
    Break;
    end;
  end;
 Debug('Made var '''+S.Data[0]+''' a menuitem.');
 F := TccMenuItem.Create(Root);
 F.Caption := S.Data[1];
 Root.Add(F);
 GetVar(S.Data[0], FData).Loc := Pointer(F);
end;

function Menu_ShortCut(S:TParams; FData: TsFunctionData):String;
begin
 TccMenuItem(GetVar(S.Data[0], FData).Loc).ShortCut := TextToShortCut(S.Data[1]);
end;

procedure TccMenuItem.Menu_OnClickX(Sender: TObject);
var Data: TEventData;
    Params:TParams;
begin
 Data := ReadEvent('OnClick', TComponent(Sender));
 Data.Func.Execute(Params);
end;

function Menu_OnClick(S:TParams; FData: TsFunctionData):String;
var Menu:TccMenuItem;
begin
  Menu := TccMenuItem(GetVar(S.Data[0], FData).Loc);
  AssignEvent('OnClick', S.Data[1], Menu, FData);
  Menu.OnClick := Menu.Menu_OnClickX;
end;


initialization
 
// -------------------- Menus handling
 AddFunction('Menu.CreateRoot', 'HSS', Menu_CreateRoot);
 AddFunction('Menu.ShortCut', 'HS', Menu_ShortCut);
 AddFunction('Menu.OnClick', 'HH', Menu_OnClick);

end.
