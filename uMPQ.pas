unit uMPQ;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Registry, StdCtrls, FileCtrl, pMpqAPI;

procedure ExtractNatives(Path:String);

implementation

procedure ExtractNatives(Path:String);
 const iBufferSize = 65536;
var WarPath:String;
  mhMapHandle: MpqHandle;
  mhFileHandle: MpqHandle;
  ptBuffer: Pointer;
  dwBytesRead: dWord;
  ssStream: TStringStream;
  S:TStringList;
begin
with TRegistry.Create do
 begin
 RootKey := HKEY_CURRENT_USER;
 if OpenKey('\Software\Blizzard Entertainment\Warcraft III\', False) then
  begin
  WarPath := ReadString('InstallPathX');
  if WarPath = '' then
    WarPath := ReadString('InstallPath');
  CloseKey;
  end;
 Free;
 end;
if WarPath = '' then
 begin
 SelectDirectory('Select your WarCraft 3 Folder:', '', WarPath);
 if WarPath = '' then Exit;
 end;

WarPath := IncludeTrailingPathDelimiter(WarPath);
if FileExists(WarPath+'War3Patch.mpq') then
  WarPath := WarPath+'War3Patch.mpq'
else if FileExists(WarPath+'war3x.mpq') then
 WarPath := WarPath+'war3x.mpq'
else if FileExists(WarPath+'war3.mpq') then
 WarPath := WarPath+'war3.mpq'
else
 begin
 ShowMessage('Did not find WarCraft MPQ File! Please put common.j in this folder!');
 Exit;
 end;

  if not SFileOpenArchive(PChar(WarPath),0,0,@mhMapHandle) then
   begin
    SFileCloseArchive(mhMapHandle);
    raise Exception.Create('This is not a valid Mpq archive!');
    Exit;
   end;

  GetMem(ptBuffer,iBufferSize);
    if not SFileOpenFileEx(mhMapHandle,'Scripts\blizzard.j',0,@mhFileHandle) then
     begin
      SFileCloseFile(mhFileHandle);
      SFileCloseArchive(mhMapHandle);
      raise Exception.Create('Did not find blizzard.j file in MPQ!');
      Exit;
     end
    else
     begin
  ssStream := TStringStream.Create('');
  repeat
     SFileReadFile(mhFileHandle,ptBuffer,iBufferSize,@dwBytesRead,nil);
     ssStream.Write(ptBuffer^,dwBytesRead);
  until dwBytesRead < iBufferSize;
  SFileCloseFile(mhFileHandle);
  S := TStringList.Create;
  S.Text := ssStream.DataString;
  ssStream.Free;
  S.SaveToFile(IncludeTrailingPathDelimiter(Path)+'blizzard.j');
  S.Free;
   end;
  FreeMem(ptBuffer);


  GetMem(ptBuffer,iBufferSize);
    if not SFileOpenFileEx(mhMapHandle,'Scripts\common.j',0,@mhFileHandle) then
     begin
      SFileCloseFile(mhFileHandle);
      SFileCloseArchive(mhMapHandle);
      raise Exception.Create('Did not find common.j file in MPQ!');
      Exit;
     end
    else
     begin
  ssStream := TStringStream.Create('');
  repeat
     SFileReadFile(mhFileHandle,ptBuffer,iBufferSize,@dwBytesRead,nil);
     ssStream.Write(ptBuffer^,dwBytesRead);
  until dwBytesRead < iBufferSize;
  SFileCloseFile(mhFileHandle);

  S := TStringList.Create;
  S.Text := ssStream.DataString;
  ssStream.Free;
  S.SaveToFile(IncludeTrailingPathDelimiter(Path)+'common.j');
  S.Free;
   end;
  FreeMem(ptBuffer);

  GetMem(ptBuffer,iBufferSize);
    if not SFileOpenFileEx(mhMapHandle,'Scripts\common.ai',0,@mhFileHandle) then
     begin
      SFileCloseFile(mhFileHandle);
      SFileCloseArchive(mhMapHandle);
      raise Exception.Create('Did not find common.ai file in MPQ!');
      Exit;
     end
    else
     begin
  ssStream := TStringStream.Create('');
  repeat
     SFileReadFile(mhFileHandle,ptBuffer,iBufferSize,@dwBytesRead,nil);
     ssStream.Write(ptBuffer^,dwBytesRead);
  until dwBytesRead < iBufferSize;
  SFileCloseFile(mhFileHandle);

  S := TStringList.Create;
  S.Text := ssStream.DataString;
  ssStream.Free;
  S.SaveToFile(IncludeTrailingPathDelimiter(Path)+'common.ai');
  S.Free;
   end;
  FreeMem(ptBuffer);


     SFileCloseArchive(mhMapHandle);
end;

end.
 