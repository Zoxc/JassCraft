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
unit uExSynEdit;

interface

uses
  Messages, SynEdit;

type
  TWmMButtonUpProcedure = procedure (var Message: TMessage) of object;

  TExSynEdit = class(TSynEdit)
  private
    fOnMButtonUp: TWmMButtonUpProcedure;
    procedure WmMButtonUp(var Message: TMessage); message WM_MBUTTONUP;
  public
    property OnMButtonUp: TWmMButtonUpProcedure write fOnMButtonUp;
  end;

implementation

{ TExSynEdit }

procedure TExSynEdit.WmMButtonUp(var Message: TMessage);
begin
  if Assigned(fOnMButtonUp) then
    fOnMButtonUp(Message);
end;

end.
