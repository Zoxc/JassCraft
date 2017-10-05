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
unit uMyIniFiles;

interface

uses
	Graphics, SysUtils, IniFiles;

type
	TMyIniFile = class(TIniFile)
  public
  	function ReadColor(const Section, Ident: String; Default: TColor): TColor;
    procedure WriteColor(const Section, Ident: String; Value: TColor);
  end;

implementation

{ TMyIniFile }

function TMyIniFile.ReadColor(const Section, Ident: String;
  Default: TColor): TColor;
var
	Color: String;
begin
	Color := ReadString(Section, Ident, '');

  if Color <> '' then
  	Result := TColor( StrToInt(Color) )
  else
  	Result := Default;
end;

procedure TMyIniFile.WriteColor(const Section, Ident: String;
  Value: TColor);
begin
	WriteString(Section, Ident, '$' + IntToHex(Integer(Value), 8));
end;

end.
 