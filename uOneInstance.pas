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
unit uOneInstance;

interface

uses
	Windows, Forms, SysUtils, uMyIniFiles, uUtils;

procedure OneInstance;

var
	hAtom: THandle;

const
	sAtom = 'Mystix_Running';

implementation

procedure OneInstance;
var
	i, hInst: Integer;
begin
	with TMyIniFile.Create(ExtractFilePath(Application.ExeName) + PathSep + 'Settings.ini') do 
	try
  	if GlobalFindAtom(sAtom) <> 0 then
    begin
    	if ReadBool('General', 'OnlyOneCopy', False) then 
    	begin
      	hInst := ReadInteger('General', 'InstanceHandle', 0);

        if IsWindow(hInst) then
        begin
          for i := 1 to ParamCount do
        	  PostMessage(hInst, WM_OPENFILE,
              GlobalAddAtom(PChar(ParamStr(i))), 0);

          Halt;
        end
        else
          hAtom := GlobalFindAtom(sAtom);
      end;
    end
    else
      hAtom := GlobalAddAtom(sAtom);
  finally
  	Free;
  end;
end;

initialization
	OneInstance;

finalization
  if hAtom <> 0 then
	  GlobalDeleteAtom(hAtom);

end.
