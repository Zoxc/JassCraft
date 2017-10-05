unit uFuncList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvDockControlForm, JvComponent, JvDockVCStyle, StdCtrls,
  JvTabBar, JvDockVSNetStyle, JvDockVIDStyle, JvComponentBase, TB2Item,
  TBX, ActnList, TB2Dock, TB2Toolbar, ComCtrls, uDocuments, ImgList, JassUnit,
  Menus, uReplace;

type
  TfrmFuncList = class(TForm)
    JvDockClient: TJvDockClient;
    JvModernTabBarPainter: TJvModernTabBarPainter;
    treeView: TTreeView;
    ActionList: TActionList;
    actGoTo: TAction;
    actRefresh: TAction;
    ImageList: TImageList;
    popupMenu: TTBXPopupMenu;
    TBXItem4: TTBXItem;
    TBXItem5: TTBXItem;
    TBXItem6: TTBXItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    TBXDock1: TTBXDock;
    tbFuncList: TTBXToolbar;
    TBXItem1: TTBXItem;
    TBXItem3: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    Sep: TTBXSeparatorItem;
    procedure actRefreshExecute(Sender: TObject);
    procedure Clear;
    procedure actGoToExecute(Sender: TObject);
    procedure treeViewEdited(Sender: TObject; Node: TTreeNode;
      var S: String);
    procedure treeViewEditing(Sender: TObject; Node: TTreeNode;
      var AllowEdit: Boolean);
      procedure UpdateChange(Sender: TObject);
    procedure popupMenuPopup(Sender: TObject);
  private
    { Private declarations }
  public
     Obj:TObject;
  end;

var
  frmFuncList: TfrmFuncList;

implementation

uses uMain, uMyIniFiles, uFind;

{$R *.dfm}

procedure TfrmFuncList.UpdateChange(Sender: TObject);
begin
if Obj <> Sender then
treeView.Enabled := False
else treeView.Enabled := True;
end;

procedure TfrmFuncList.Clear;
begin
treeView.Items.Clear;
end;

procedure TfrmFuncList.actRefreshExecute(Sender: TObject);
var Node,Top,Func,Global,HGlobal:TTreeNode;
Str:String;
i:Integer;
F:PFunction;
G:PGlobal;

begin
if Assigned(Document) then
 begin
Obj := Document;
treeView.Enabled := False;
treeView.Items.BeginUpdate;

if treeView.Items.Count > 0 then
begin
treeView.Items.Item[0].DeleteChildren;
treeView.Items.Delete(treeView.Items.Item[0]);
end;

treeView.Enabled := True;
Document.UpdateExplorer;
if Document.FileInMPQ <> '' then
Str := Document.FileInMPQ
else
 begin
  if Document.fSaved then
  Str := ExtractFileName(Document.FileName)
  else
Str := Document.FileName;
 end;
Top := treeView.Items.Add(nil, Str);
Top.ImageIndex := 4;
Top.SelectedIndex := 4;
{
HGlobal := treeView.Items.AddChild(Top, 'Hidden Globals');
HGlobal.ImageIndex := 3;
HGlobal.SelectedIndex := 3;  }
Global := treeView.Items.AddChild(Top, 'Globals');
Global.ImageIndex := 3;
Global.SelectedIndex := 3;
Func := treeView.Items.AddChild(Top, 'Functions');
Func.ImageIndex := 1;
Func.SelectedIndex := 1;
for i := 0 to High(Document.JassDoc.Functions) do
 begin
  F := @Document.JassDoc.Functions[i];
  Node := treeView.Items.AddChild(Func, F.Name);
  Node.ImageIndex := 1;
  Node.SelectedIndex := 1;
  Node.Data := F;
 end;       {
for i := 0 to High(Document.HGlobals) do
 begin
  G := @Document.HGlobals[i];
  Node := treeView.Items.AddChild(HGlobal, G.Name);
  Node.ImageIndex := 0;
  Node.SelectedIndex := 0;
  Node.Data := G;
 end;  }
for i := 0 to High(Document.JassDoc.Globals) do
 begin
  G := @Document.JassDoc.Globals[i];
  Node := treeView.Items.AddChild(Global, G.Name);
  Node.ImageIndex := 0;
  Node.SelectedIndex := 0;
  Node.Data := G;
 end;

Top.Expand(False);
treeView.Items.EndUpdate;

 end;
end;

procedure TfrmFuncList.actGoToExecute(Sender: TObject);
begin
if Assigned(Document) then
if Assigned(treeView.Selected) then
if Assigned(treeView.Selected.Data) then
 begin
  if treeView.Selected.ImageIndex = 1 then
   Document.GoToLineEx((PFunction(treeView.Selected.Data)^).Line)
  else
   Document.GoToLineEx((PGlobal(treeView.Selected.Data)^).Line);     
 end;
end;

procedure TfrmFuncList.treeViewEdited(Sender: TObject; Node: TTreeNode;
  var S: String);

begin
	Document.ReplaceText(Node.Text, S, True,
      	True, False, False, False, False, False,
        True);
end;

procedure TfrmFuncList.treeViewEditing(Sender: TObject; Node: TTreeNode;
  var AllowEdit: Boolean);
begin
AllowEdit := False;
 if Assigned(Document) then
if Assigned(treeView.Selected) then
if Assigned(treeView.Selected.Data) then
 AllowEdit := True;
end;

procedure TfrmFuncList.popupMenuPopup(Sender: TObject);
begin
if Assigned(treeView.Selected) then
 begin


 end;
end;

end.
