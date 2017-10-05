{
Mystix
Copyright (C) 2005  Piotr Jura

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

You can contact with me by e-mail: pjura@o2.pl
}
unit uUtils;

interface

uses
	Classes,
  SysUtils,
  Messages;

const
  PathSep = '\';
  ErrorMsgColor = $000000DD;
  ProjectVersion = '0.3.1';
  msgNotFound = 'Could not find the text: %s';

  WM_OPENFILE = WM_USER + 1;

  StringsCount = 18;
  siUntitled = 0;
  siModified = 1;
  siInsertMode = 2;
  siOverwriteMode = 3;
  siReadOnly = 4;
  siAskSaveChanges = 5;
  siNotFound = 6;
  siLinesSelected = 7;
  siCaretVerticalLine = 8;
  siCaretHorizontalLine = 9;
  siCaretHalfBlock = 10;
  siCaretBlock = 11;
  siFontButton = 12;
  siNoDocType = 13;
  siTenDocTypes = 14;
  siConfirmReplace = 15;
  siSquare = 16;
  siEllipse = 17;
  siWrongLangVersion = 18;

var
  sStrings: array[0..StringsCount] of String;
  AppPath: String;

procedure FileListInDir(Dir, Mask: String; Attr: Integer; var FileList: TStringList);
function IncludeTrailPathSep(S: String): String;

implementation

procedure FileListInDir(Dir, Mask: String; Attr: Integer; var FileList: TStringList);
var
	Sr: TSearchRec;
begin
	if FileList = nil then
		FileList := TStringList.Create;

  FileList.Clear;

	if FindFirst(Dir + Mask, Attr, Sr) = 0 then
  begin
  	repeat
    	if Sr.Name[1] <> '.' then
      	FileList.Add(Dir + Sr.Name);
    until FindNext(Sr) <> 0;

    FindClose(Sr);
  end;
end;

function IncludeTrailPathSep(S: String): String;
begin
	if S[Length(S)] <> PathSep then
  	Result := S + PathSep;
end;

end.
