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
unit uConfirmReplace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TConfirmReplaceDialog = class(TForm)
    imgIcon: TImage;
    lblQuestion: TLabel;
    btnCancel: TButton;
    btnSkip: TButton;
    btnReplace: TButton;
    btnAll: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    function Execute(X, Y: Integer; ASearch, AReplace: String): TModalResult;
  end;

var
  ConfirmReplaceDialog: TConfirmReplaceDialog;

implementation

uses uUtils, uMyIniFiles, uMain;

{$R *.dfm}

function TConfirmReplaceDialog.Execute(X, Y: Integer; ASearch,
  AReplace: String): TModalResult;
begin
	Left := X;
  Top := Y;
	lblQuestion.Caption := Format(sStrings[siConfirmReplace], [ASearch, AReplace]);
	Result := ShowModal;
end;

procedure TConfirmReplaceDialog.FormCreate(Sender: TObject);
begin
	imgIcon.Picture.Icon.Handle := LoadIcon(0, IDI_ASTERISK);
end;

procedure TConfirmReplaceDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
	Action := caFree;
end;

end.
