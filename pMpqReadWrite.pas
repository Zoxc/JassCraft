unit pMpqReadWrite;

interface

uses Windows, pMpqAPI, Classes, SysUtils, Forms, dialogs;

procedure MpqRead(Mpq:String; FileName:String; Strings: TStrings);
procedure MpqWrite(Mpq:String; FileName:String; Strings: TStrings);

const
   MAFA_FORMAPS=MAFA_COMPRESS OR MAFA_ENCRYPT OR MAFA_REPLACE_EXISTING OR MAFA_EXISTS;


implementation

procedure MpqRead(Mpq:String; FileName:String; Strings: TStrings);
 const iBufferSize = 65536;
 var
  FileHandle,MpqFile: MpqHandle;
  ptBuffer: Pointer;
  dwBytesRead: dWord;
  ssStream: TStringStream;
begin

if not SFileOpenArchive(PChar(Mpq),0,0,@MpqFile) then
 begin
    SFileCloseArchive(MpqFile);
    raise Exception.Create('This is not a valid Mpq archive!');
    Exit;
 end;

  GetMem(ptBuffer,iBufferSize);
  if not SFileOpenFileEx(MpqFile,PChar(FileName),0,@FileHandle) then
   begin
    SFileCloseFile(FileHandle);
    SFileCloseArchive(MpqFile);
    raise Exception.Create('File is not in Mpq archive!');
    Exit;
   end;

  ssStream := TStringStream.Create('');
  repeat
     SFileReadFile(FileHandle,ptBuffer,iBufferSize,@dwBytesRead,nil);
     ssStream.Write(ptBuffer^,dwBytesRead);
  until dwBytesRead < iBufferSize;
  SFileCloseFile(FileHandle);
  FreeMem(ptBuffer);
  SFileCloseArchive(MpqFile);

  Strings.Clear;
  Strings.Text := ssStream.DataString;
  ssStream.Free;
end;

procedure MpqWrite(Mpq:String; FileName:String; Strings: TStrings);
//var
 // MpqFile: MpqHandle;
  var
  FileHandle,MpqFile: MpqHandle;
begin
if not SFileOpenArchive(PChar(Mpq),0,0,@MpqFile) then
 begin
    SFileCloseArchive(MpqFile);
    raise Exception.Create('This is not a valid Mpq archive!');
    Exit;
 end;
{
  MpqFile := MPQOpenArchiveForUpdate(PAnsiChar(Mpq),MOAU_OPEN_EXISTING OR MOAU_MAINTAIN_LISTFILE,0);
    MPQDeleteFile(MpqFile,'(attributes)');
    MPQDeleteFile(MpqFile, PChar(FileName));

    MpqAddFileFromBufferEx(MpqFile, Pointer(Strings.Text)^, Length(Strings.Text), PChar(FileName), MAFA_FORMAPS, MAFA_COMPRESS_DEFLATE, Z_BEST_COMPRESSION);
    MpqCompactArchive(MpqFile);
  MPQCloseUpdatedArchive(MpqFile,0);
  msStream.Free;
  }
end;

end.
 