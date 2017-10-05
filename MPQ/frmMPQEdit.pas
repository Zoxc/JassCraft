unit frmMPQEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pMpqEditor, ImgList, ComCtrls, ExtCtrls, TB2Item, TBX,
  TB2Dock, TB2Toolbar, ActnList, TB2ExtItems, TBXExtItems, XPMan,
  TBXSwitcher, JvComponentBase, JvDockControlForm, uDocuments, Menus;

type
  TfrmMPQ = class(TForm)
    OpenDialog: TOpenDialog;
    MPQImages: TImageList;
    tbDock: TTBXDock;
    tbMPQ: TTBXToolbar;
    MPQActionList: TActionList;
    actOpen: TAction;
    actClose: TAction;
    TBXItem2: TTBXItem;
    TBXItem5: TTBXItem;
    MPQFileIcons: TImageList;
    MPQFiles: TListBox;
    JvDockClient: TJvDockClient;
    TBXPopupMenu: TTBXPopupMenu;
    actExport: TAction;
    actOpenInEdit: TAction;
    TBXItem1: TTBXItem;
    TBXItem3: TTBXItem;
    SaveDialog: TSaveDialog;
    procedure OnDone(List:TStringList);
    procedure actOpenExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure GenerateTree(Folder:String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MPQFilesDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure MPQFilesDblClick(Sender: TObject);
    procedure actOpenInEditExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    Mpq:TMpq;
    Opened:Boolean;
    Files:TStringList;
    //PList:TStringList;
    Path,FileName:String;
  end;

var
  frmMPQ: TfrmMPQ;

implementation

uses uMain;

{$R *.dfm}

procedure TfrmMPQ.GenerateTree(Folder:String);
var  i:Integer;
Str:String;

function CountChar(S,C:String):Integer;
var i,ct:Integer;
begin
ct := 0;
for i := 1 to Length(S) do
  if S[i] = C[1] then
   Inc(ct);

Result := ct;
end;

begin
Path := Folder;
MPQFiles.Items.BeginUpdate;
MPQFiles.Items.Clear;
if Path <> '' then
 MPQFiles.Items.Add('(Up a level)\\');
for i := 0 to Files.Count-1 do
  begin
  if Copy(Files[i], 0, Length(Folder)) = Folder then
   begin
  Str := Copy(Files[i], Length(Folder)+1, Length(Files[i]));
  if CountChar(Str, '\') <= 1 then
    begin
  if Pos('\', Str) <> 0 then
   begin
    Str := Copy(Str, 0, Pos('\', Str));
      if MPQFiles.Items.IndexOf(Str) = -1 then
      MPQFiles.Items.Add(Str);
   end;
  end;
  end;
end;

for i := 0 to Files.Count-1 do
  begin
  if Copy(Files[i], 0, Length(Folder)) = Folder then
   begin
  Str := Copy(Files[i], Length(Folder)+1, Length(Files[i]));
  if CountChar(Str, '\') <= 1 then
    begin
  if Pos('\', Str) = 0 then
      MPQFiles.Items.Add(Str);
     end;
   end;
end;
MPQFiles.Items.EndUpdate;
end;

procedure TfrmMPQ.OnDone(List:TStringList);
begin
Opened := True;
if Assigned(Files) then Files.Free;
Files := List;
GenerateTree('');
Application.ProcessMessages;
actClose.Enabled := True;
end;

procedure TfrmMPQ.actOpenExecute(Sender: TObject);
var fn:String;
list: TMpqListfiles;
begin
  if OpenDialog.Execute then
   begin
  if Opened then
  actCloseExecute(nil);
  MPQFiles.Items.Text := 'Loading MPQ...';
  Application.ProcessMessages;
  fn := OpenDialog.FileName;
  Mpq := TMpq.Create(fn);
  list := TMpqListfiles.Create(True);
  list.Mpq := Mpq;
  list.OnDone := OnDone;
  list.Resume;   
  OnDone(TStringList.Create);
   end;
end;

procedure TfrmMPQ.actCloseExecute(Sender: TObject);
begin
Opened := False;
if Assigned(Mpq) then Mpq.Free;
Files.Clear;
MPQFiles.Items.Clear;
actClose.Enabled := False;
end;

procedure TfrmMPQ.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Files.Free; 
end;

procedure TfrmMPQ.MPQFilesDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
  var B:TIcon;
  S:String;
  I:Integer;
  F:Boolean;
  C:TColor;
begin
       
with MPQFiles.Canvas do
 begin
 FillRect(Rect);
 I := 0;
 S := MPQFiles.Items[Index];
 F := Pos('\', S) <> 0;
 if F then I := 2
 else
  begin
 if LowerCase(ExtractFileExt(S)) = '.j' then I := 1;
 if LowerCase(ExtractFileExt(S)) = '.txt' then I := 4;
  end;
 C := Font.Color;
 if S = '(Up a level)\\' then
  begin
 S := '(Up a level)\';
 I := 3;
 Font.Color := clGray;
  end;
 B := TIcon.Create;
 MPQFileIcons.GetIcon(I, B);
 Draw(2,Rect.Top+1, B);
 B.Free;
 if F then S := Copy(S, 0, Length(S)-1);
 TextOut(20, Rect.Top+2, S);
 Font.Color := C;
 end;
end;

procedure TfrmMPQ.MPQFilesDblClick(Sender: TObject);
var i,p:Integer;
begin
if MPQFiles.ItemIndex <> -1 then
 begin
   if Pos('\', MPQFiles.Items[MPQFiles.ItemIndex]) <> 0 then
    begin
    if MPQFiles.Items[MPQFiles.ItemIndex] = '(Up a level)\\' then
     begin
     p := 0; 
     for i := 1 to Length(Path)-1 do
      if Path[i] = '\' then p := i;

     Path := Copy(Path, 0, p);
     GenerateTree(Path);
     end
    else
      GenerateTree(Path+MPQFiles.Items[MPQFiles.ItemIndex]);
    end
   else
    begin
    DocumentFactory.Open(Mpq.MpqName, Path+MPQFiles.Items[MPQFiles.ItemIndex]);
    end;
 end;
end;

procedure TfrmMPQ.actOpenInEditExecute(Sender: TObject);
begin
 MPQFilesDblClick(nil);
end;

procedure TfrmMPQ.actExportExecute(Sender: TObject);
begin
 if SaveDialog.Execute then
  begin
 //  Mpq.Write()
  // SaveDialog.FileName;
  end;
end;

procedure TfrmMPQ.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
Tag := 1;
end;

end.

