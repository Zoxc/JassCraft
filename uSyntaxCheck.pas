unit uSyntaxCheck;

interface

uses
  Classes, Messages, Windows, SysUtils, Variants, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uUtils, StrUtils;

type
  TSyntaxCheck = class(TThread)
  private
    { Private declarations }
  public
    Pass:Boolean;

  sR:String;
    Cmd:String;
    Dead:Boolean;
    ProcessInfo         : TProcessInformation;
    Buffer              : Pchar;
  protected
    procedure Execute; override;
procedure Finalize;
    end;


const
  tmpJ  = 'tempchk.j';

var Check:TSyntaxCheck;


procedure RunPJass(Cmd:String);
procedure StopPJass;
function GetShortPathName(FileName:String):String;

implementation

uses uMain;


    function GetShortPathName(FileName:String):String;
  var
    sCD, sAD  : String;

  begin
    Result  := FileName+'';
    if (Length(FileName)>0)and(FileName[1]='<') then
      Exit;

    if Pos('\', FileName)=0 then begin
      sCD := GetCurrentDir;
      if sCD[Length(sCD)]<>'\' then
        sCD := sCD+'\';
      sCD := ExtractShortPathName(sCD);
      sAD := ExtractShortPathName(AppPath);
      if UpperCase(sCD)<>UpperCase(sAD) then
        FileName  := AppPath+FileName;
    end; //if

    Result  := ExtractShortPathName(FileName);
  end;
procedure StopPJass;
begin
 Check.Terminate;
 while not Check.Dead do
  begin
  Sleep(50);
  end;
 MainForm.btnStartSyntax.Caption := 'Start';
 MainForm.btnStartSyntax.Enabled := True;
 MainForm.checkout.Items.Text  := 'Syntax check cancelled.';
end;

procedure RunPJass(Cmd:String);
begin
 Check := TSyntaxCheck.Create(True);
 Check.FreeOnTerminate := True;
 Check.Cmd := Cmd;
 Check.Resume;
end;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TSyntaxCheck.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TSyntaxCheck }

procedure TSyntaxCheck.Finalize;
var  i : Integer;
begin
  if not Pass then
    begin
    MainForm.checkout.Items.Text  := 'Error lanching PJass!';
  Exit;
    end;
  sR  := AnsiReplaceStr(sR, GetShortPathName(AppPath), '');
  sR  := AnsiReplaceStr(sR, tmpJ+':', 'Line ');
  sR  := AnsiReplaceStr(sR, tmpJ, 'Editing file');
  MainForm.checkout.Items.Text  := sR;

  with MainForm.checkout do begin
    for i:=Items.Count-1 downto 0 do begin
      if Trim(Items.Strings[i])='' then
        Items.Delete(i);
    end; //for
  end; //with
 MainForm.btnStartSyntax.Enabled := True;
end;

procedure TSyntaxCheck.Execute;
const
  ReadBuffer = $800;
var
  Security            : TSecurityAttributes;
  ReadPipe,WritePipe  : THandle;
  start               : TStartUpInfo;
  BytesRead           : DWord;
  Apprunning          : DWord;
    i : Integer;

begin
   Pass := False;
  With Security do begin
    nlength              := SizeOf(TSecurityAttributes);
    binherithandle       := true;
    lpsecuritydescriptor := nil;
  end;
  if Createpipe(ReadPipe, WritePipe, @Security, 0) then begin
    Buffer  := AllocMem(ReadBuffer + 1);
    FillChar(Start,Sizeof(Start),#0);
    start.cb          := SizeOf(start);
    start.hStdOutput  := WritePipe;
    start.hStdInput   := ReadPipe;
    start.dwFlags     := STARTF_USESTDHANDLES+STARTF_USESHOWWINDOW;
    start.wShowWindow := SW_HIDE;

    if (CreateProcess(nil,
          PChar(Cmd),
          nil,
          nil,
          TRUE,
          NORMAL_PRIORITY_CLASS,
          nil,
          nil,
          start,
          ProcessInfo))
    then begin
      i := 0;
      repeat
        Apprunning := WaitForSingleObject(ProcessInfo.hProcess,500);
        inc(i);
      until (Apprunning <> WAIT_TIMEOUT) or (i>60) or (Terminated);
      Pass := True;
      sR  := '';
      if not Terminated then
       begin
      Repeat
        BytesRead := 0;
        ReadFile(ReadPipe,Buffer[0], ReadBuffer,BytesRead,nil);
        Buffer[BytesRead]:= #0;
        OemToAnsi(Buffer,Buffer);
        sR  := sR + StrPas(Buffer);
      until (BytesRead < ReadBuffer);
       end;
    end;
    FreeMem(Buffer);
    TerminateProcess(ProcessInfo.hProcess, 0);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ReadPipe);
    CloseHandle(WritePipe);
  end;
  MainForm.btnStartSyntax.Caption := 'Start';
  MainForm.btnStartSyntax.Enabled := True;  
   DeleteFile(AppPath+tmpJ);

  if not Terminated then
     begin
  Synchronize(Finalize);
      end;

  Dead := True;
end;

end.
