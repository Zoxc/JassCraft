unit uNativeList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uMain, JvComponentBase, JvDockControlForm, StdCtrls, Buttons,
  JvgSpeedButton, JvExControls, JvComponent, JvSpeedButton, ExtCtrls,
  CheckLst, JassUnit, uDocuments;

type
  TListRecord = record
  Code:Pointer;
  StrOut:String;
  end;
  PListRecord = ^TListRecord;
  
  TfrmNative = class(TForm)
    JvDockClient: TJvDockClient;
    search: TComboBox;
    list: TListBox;
    Label1: TLabel;
    showhide: TLabel;
    options: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    sfor: TCheckListBox;
    Label3: TLabel;
    sin: TCheckListBox;
    cases: TCheckBox;
    fromb: TCheckBox;
    procedure FormResize(Sender: TObject);
    procedure showhideMouseLeave(Sender: TObject);
    procedure showhideMouseEnter(Sender: TObject);
    procedure showhideClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveSettings;
    procedure Filter;
    procedure FilterFunc(Doc:TJassDoc; S:String);
procedure FilterType(Doc:TJassDoc; S:String);
procedure FilterConst(Doc:TJassDoc; S:String);
procedure FilterGlobal(Doc:TJassDoc; S:String);
    procedure searchChange(Sender: TObject);
    function FilterWord(Name,S:String):Boolean;
    procedure sforClickCheck(Sender: TObject);
    procedure sinClickCheck(Sender: TObject);
    procedure casesClick(Sender: TObject);
    procedure frombClick(Sender: TObject);
    procedure listClick(Sender: TObject);
    procedure listDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    ModeShow:Boolean;
    ListArray: array of TListRecord;
    ShowOptions:Boolean;
    procedure AddToList(S:String; ListR:TListRecord);
  end;

var
  frmNative: TfrmNative;

implementation

{$R *.dfm}

procedure TfrmNative.AddToList(S:String; ListR:TListRecord);
var i:Integer;
begin
i := High(ListArray);
SetLength(ListArray, i+2);
list.Items.Add(S);
ListArray[i+1] := ListR;
end;

procedure TfrmNative.FormResize(Sender: TObject);
begin
search.Width := ClientWidth-44-5;
list.Width := ClientWidth-9;
showhide.Top := ClientHeight-17;
showhide.Width := ClientWidth-9;
if ShowOptions then
 begin
 options.Visible := True;
 options.Height := 141+((sin.Items.Count-1)*13);
 list.Height := ClientHeight-32-options.Height-4-20;
 list.Width := ClientWidth-9;
 options.Width := ClientWidth-9;
 options.Top := ClientHeight-options.Height-20;
 sfor.Width := options.ClientWidth-64-5;
 sin.Height := 4+(sin.Items.Count*13);
 sin.Width := options.ClientWidth-64-5;
 end
else
 begin
 options.Visible := False;
 list.Height := ClientHeight-32-20;
 end;
end;

procedure TfrmNative.showhideMouseLeave(Sender: TObject);
begin
showhide.Font.Color := clGray;
end;

procedure TfrmNative.showhideMouseEnter(Sender: TObject);
begin
showhide.Font.Color := clBlack;
end;

procedure TfrmNative.showhideClick(Sender: TObject);
begin
 ShowOptions := not ShowOptions;
 if ShowOptions then
  showhide.Caption := 'Hide options'
 else
  showhide.Caption := 'Show options';
 FormResize(nil);
end;


function TfrmNative.FilterWord(Name,S:String):Boolean;
begin
Result := false;
 if cases.Checked and fromb.Checked then
  begin
   if Copy(Name,0,Length(s)) = S then Result := true;
  end
 else if cases.Checked then
  begin
    if Pos(S, Name) <> 0 then Result := true;
  end
 else if fromb.Checked then
  begin
   if LowerCase(Copy(Name,0,Length(s))) = LowerCase(S) then Result := true;
  end
 else
  begin
   if Pos(LowerCase(S), LowerCase(Name)) <> 0 then Result := true;
  end;
end;



procedure TfrmNative.FilterType(Doc:TJassDoc; S:String);
var i:Integer;
f:TType;
L:PListRecord;
begin
for i := 0 to High(Doc.Types) do
 begin
 f := TType(Doc.Types[i]);
 if (S = '') or (FilterWord(f.NewName, S)) then
  begin
   New(L);
   L.Code :=  Pointer(f.Code);
   L.StrOut :=  f.NewName;
   list.Items.AddObject(f.NewName , Pointer(L));
  end;
 end;

end;

procedure TfrmNative.FilterConst(Doc:TJassDoc; S:String);
var i:Integer;
f:TGlobal;
L:PListRecord;
begin
for i := 0 to High(Doc.Globals) do
 begin
 f := Doc.Globals[i];
 if ((S = '') or (FilterWord(f.Name, S))) and (f.Constant) then
  begin
   New(L);
   L.Code :=  Pointer(f.Code);
   L.StrOut :=  f.Name;
   list.Items.AddObject(f.Name , Pointer(L));
  end;
 end;

end;

procedure TfrmNative.FilterGlobal(Doc:TJassDoc; S:String);
var i:Integer;
f:TGlobal;
L:PListRecord;
begin
for i := 0 to High(Doc.Globals) do
 begin
 f := Doc.Globals[i];
 if ((S = '') or (FilterWord(f.Name, S))) and (not f.Constant) then
  begin
   New(L);
   L.Code :=  Pointer(f.Code);
   L.StrOut :=  f.Name;
   list.Items.AddObject(f.Name , Pointer(L));
  end;
 end;

end;

procedure TfrmNative.FilterFunc(Doc:TJassDoc; S:String);
var i:Integer;
f:TFunction;
L:PListRecord;
begin
for i := 0 to High(Doc.Functions) do
 begin
 f := Doc.Functions[i];
 if (S = '') or (FilterWord(f.Name, S)) then
  begin
   New(L);
   L.Code :=  Pointer(f.Code);
   L.StrOut :=  f.Name;
   list.Items.AddObject(f.Name , Pointer(L));
  end;
 end;

end;


procedure TfrmNative.Filter;
var i:Integer;
begin
list.Items.BeginUpdate;
for i := 0 to list.Items.Count-1 do
 if list.Items.Objects[i] <> nil then
   Dispose(PListRecord(list.Items.Objects[i]));
list.Items.Clear;

for i := 0 to High(JassLib.Docs) do
 begin
 if (JassLib.Docs[i].Filename = ':') or (sin.Checked[sin.Items.IndexOf(JassLib.Docs[i].Name)]) then
   begin
    if sfor.Checked[0] then
     FilterFunc(JassLib.Docs[i], search.Text);
    if sfor.Checked[1] then
     FilterType(JassLib.Docs[i], search.Text);
    if sfor.Checked[3] then
     FilterConst(JassLib.Docs[i], search.Text);
    if sfor.Checked[2] then
     FilterGlobal(JassLib.Docs[i], search.Text);
   end;
 end;
list.Items.EndUpdate;
end;

procedure TfrmNative.FormCreate(Sender: TObject);
var
i,p:Integer;
begin
p := 0;
for i := 0 to High(JassLib.Docs) do
 begin
 if JassLib.Docs[i].Filename <> ':' then
  begin
 sin.Items.Add(JassLib.Docs[i].Name);
 sin.Checked[p] := Settings.ReadBool('JassUse', TJassDoc(JassLib.Docs[i]).Name, false);
 Inc(p);
  end;
 end;

sfor.Checked[0] := Settings.ReadBool('JassShow', 'f', true);
sfor.Checked[1] := Settings.ReadBool('JassShow', 't', false);
sfor.Checked[2] := Settings.ReadBool('JassShow', 'v', false);
sfor.Checked[3] := Settings.ReadBool('JassShow', 'c', false);
Filter;
end;

procedure TfrmNative.SaveSettings;
var
i:Integer;
begin
for i := 0 to sin.Items.Count-1 do
 begin
 Settings.WriteBool('JassUse', sin.Items[i], sin.Checked[i]);
 end;
 
Settings.WriteBool('JassShow', 'f', sfor.Checked[0]);
Settings.WriteBool('JassShow', 't', sfor.Checked[1]);
Settings.WriteBool('JassShow', 'v', sfor.Checked[2]);
Settings.WriteBool('JassShow', 'c', sfor.Checked[3]);
end;

procedure TfrmNative.searchChange(Sender: TObject);
begin
Filter;
end;

procedure TfrmNative.sforClickCheck(Sender: TObject);
begin
Filter;
end;

procedure TfrmNative.sinClickCheck(Sender: TObject);
begin
Filter;
end;

procedure TfrmNative.casesClick(Sender: TObject);
begin
Filter;
end;

procedure TfrmNative.frombClick(Sender: TObject);
begin
Filter;
end;

procedure TfrmNative.listClick(Sender: TObject);
begin
if list.ItemIndex = -1 then Exit;

MainForm.SynCode.Text := String((PListRecord(list.Items.Objects[list.ItemIndex])^).Code);
end;

procedure TfrmNative.listDblClick(Sender: TObject);
begin
if Document = nil then Exit;
if list.ItemIndex = -1 then Exit;
  Document.Editor.SelText := (PListRecord(list.Items.Objects[list.ItemIndex])^).StrOut;
end;

procedure TfrmNative.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
Tag := 1;
end;              

end.
