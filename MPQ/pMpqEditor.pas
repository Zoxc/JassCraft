unit pMpqEditor;

interface

uses Windows, pMpqAPI, Classes, SysUtils, Forms, dialogs;

type
     TMpqListDone = procedure(List:TStringList) of object;

     TMpq = class(TObject)
     private
        procedure OpenMpq;
        procedure CloseMpq;
     public
        MpqName:String;
        MpqFile: MpqHandle;
        constructor Create(FileName:String);
        function Read(FileName:String; Strings: TStrings):Boolean;
        function Write(FileName:String; Strings: TStrings):Boolean;
        function FileExists(FileName:String;Reopen:Boolean):Boolean;
        function ExportFile(FileInMPQ,RealFile:String):Boolean;
     end;

     TMpqListfiles = class(TThread)
     private
     List:TStringList;
     public
     Mpq:TMpq;
     OnDone: TMpqListDone;
     protected
        procedure Execute; override;
     end;

implementation


procedure TMpqListfiles.Execute;
var listfile:TStringList;
  i,max:Integer;
begin
List:=TStringList.Create;
Mpq.OpenMpq;
if Mpq.FileExists('(listfile)', false) then
 Mpq.Read('(listfile)', List)
else
 begin
  listfile:=TStringList.Create;
  listfile.LoadFromFile(ExtractFilePath(Application.ExeName)+'mpqlist.txt');
  Max := listfile.Count-1;
  for i := 0 to Max do
   if Mpq.FileExists(listfile[i], false) then
     List.Add(listfile[i]);
  listfile.Free;
 end;
OnDone(List);
Mpq.CloseMpq;
FreeOnTerminate := True;
Terminate;
end;

function TMpq.FileExists(FileName:String;Reopen:Boolean):Boolean;
var
  FileHandle: MpqHandle;
begin
Result := False;
if Reopen then
OpenMpq;
  if SFileOpenFileEx(MpqFile,PChar(FileName),0,@FileHandle) then
    Result := True;
SFileCloseFile(FileHandle);
if Reopen then
CloseMpq;
end;

procedure TMpq.OpenMpq;
begin
  if not SFileOpenArchive(PChar(MpqName),0,0,@MpqFile) then
   begin
    SFileCloseArchive(MpqFile);
    raise Exception.Create('This is not a valid Mpq archive!');
   end;
end;

procedure TMpq.CloseMpq;
begin
    SFileCloseArchive(MpqFile);
end;

function TMpq.ExportFile(FileInMPQ,RealFile:String):Boolean;
  const iBufferSize = 65536;
 var
  msStream: TFileStream;
  pFileName: PChar;
  FileHandle: MpqHandle;
  ptBuffer: Pointer;
  dwBytesRead: dWord;
begin
Result := True;
 pFileName := PChar(FileInMPQ);
 if not SysUtils.FileExists(RealFile) then
 msStream := TFileStream.Create(RealFile, fmOpenWrite);

  GetMem(ptBuffer,iBufferSize);
  if not SFileOpenFileEx(MpqFile,pFileName,0,@FileHandle) then
   begin
    SFileCloseFile(FileHandle);
    CloseMpq;
    raise Exception.Create('File not found!');
    Exit;
   end;

  repeat
     SFileReadFile(FileHandle,ptBuffer,iBufferSize,@dwBytesRead,nil);
     msStream.Write(ptBuffer^,dwBytesRead);
  until dwBytesRead < iBufferSize;
  
  SFileCloseFile(FileHandle);

  FreeMem(ptBuffer);

  CloseMpq;
  msStream.Free;
end;

function TMpq.Write(FileName:String; Strings: TStrings):Boolean;
var
  msStream: TMemoryStream;
begin
  Result := true;
 // Strings.Text
 ShowMessage(FileName);ShowMessage(MpqName);
  msStream  := TMemoryStream.Create;
  Strings.SaveToStream(msStream);
  MpqFile := MPQOpenArchiveForUpdate(PChar(MpqName),MOAU_OPEN_EXISTING,0);
  try
    MPQDeleteFile(MpqFile,'(attributes)');
    MPQDeleteFile(MpqFile, PChar(FileName));
    MpqAddFileFromBufferEx(MpqFile, msStream.Memory, msStream.Size, PChar(FileName), MAFA_COMPRESS or MAFA_REPLACE_EXISTING, MAFA_COMPRESS_DEFLATE, Z_BEST_COMPRESSION);
    MpqCompactArchive(MpqFile);
  except
    on E:Exception do Result  := false;
  end; //try
  MPQCloseUpdatedArchive(MpqFile,0);
  msStream.Free;
end;

function TMpq.Read(FileName:String; Strings: TStrings):Boolean;
 const iBufferSize = 65536;
 var
  FileHandle: MpqHandle;
  ptBuffer: Pointer;
  dwBytesRead: dWord;
  ssStream: TStringStream;
begin
try
Result := False;
OpenMpq;

  GetMem(ptBuffer,iBufferSize);
  if not SFileOpenFileEx(MpqFile,PChar(FileName),0,@FileHandle) then
   begin
    SFileCloseFile(FileHandle);
    CloseMpq;
    raise Exception.Create('File not found!');
    Exit;
   end;

  ssStream := TStringStream.Create('');
  repeat
     SFileReadFile(FileHandle,ptBuffer,iBufferSize,@dwBytesRead,nil);
     ssStream.Write(ptBuffer^,dwBytesRead);
  until dwBytesRead < iBufferSize;
  SFileCloseFile(FileHandle);
  FreeMem(ptBuffer);
  CloseMpq;

  Strings.Clear;
  Strings.Text := ssStream.DataString;
  ssStream.Free;
   except
    on E:Exception do
    begin
      ssStream.Free;
      CloseMpq;
      raise Exception.Create('Load Error');
    end;
   end;
end;

constructor TMpq.Create(FileName:String);
begin
inherited Create;
 MpqName := FileName;
 if not SFileOpenArchive(PChar(MpqName),0,0,@MpqFile) then
  raise Exception.Create('This is not a valid Mpq archive!');
 SFileCloseArchive(MpqFile);
end;

end.
 