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
unit uReplace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uFind, StdCtrls, ExtCtrls;

type
  TReplaceDialog = class(TFindDialog)
    btnReplaceAll: TButton;
    lblReplace: TLabel;
    chkPrompt: TCheckBox;
    cmbReplace: TMemo;
    procedure btnFindNextClick(Sender: TObject);
    procedure btnReplaceAllClick(Sender: TObject);
    procedure cmbFindChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkInAllClick(Sender: TObject);
  private
    { Private declarations }
    procedure Replace(ReplaceAll: Boolean);
  protected
    procedure SetOptions; override;
  public
    Find,ReplaceWith:String;
  end;

var
  ReplaceDialog: TReplaceDialog;

implementation

uses uDocuments, uMain, uUtils, uMyIniFiles;

{$R *.dfm}

procedure TReplaceDialog.btnFindNextClick(Sender: TObject);
begin
	Replace(False);
end;

procedure TReplaceDialog.Replace(ReplaceAll: Boolean);
var
	i: Integer;

  procedure NotFound;
  begin
  	MainForm.StatusMsg( PChar( Format(msgNotFound, [cmbFind.Text]) ), ErrorMsgColor,
    	clWhite, 4000, False );
  end;
begin
	SetOptions;

	if chkPrompt.Checked then
		Hide;

	if chkInAll.Checked then
  	for i := 0 to DocumentFactory.Count - 1 do
    begin
    	if DocumentFactory.IsSearchedForTheFirstTime(frFindText) then
    		DocumentFactory.Documents[i].ReplaceText(frFindText, frReplaceText,
        	frWholeWords, frMatchCase, frRegExp, frSelOnly, frFromCursor,
          frPrompt, frDirUp, ReplaceAll)
      else
      	DocumentFactory.Documents[i].ReplaceNext;
    end
  else
  begin
  	if DocumentFactory.IsSearchedForTheFirstTime(cmbFind.Text) then
    begin
			if not Document.ReplaceText(frFindText, frReplaceText, frWholeWords,
      	frMatchCase, frRegExp, frSelOnly, frFromCursor, frPrompt, frDirUp,
        ReplaceAll) then
      		NotFound;
    end
    else
    begin
    	if not Document.ReplaceNext then
      	NotFound;
    end;
  end;

	if chkPrompt.Checked then
  	Show;
end;

procedure TReplaceDialog.btnReplaceAllClick(Sender: TObject);
begin
	Replace(True);
end;

procedure TReplaceDialog.cmbFindChange(Sender: TObject);
begin
  inherited;
	btnReplaceAll.Enabled := cmbFind.Text <> '';
end;

procedure TReplaceDialog.FormCreate(Sender: TObject);
begin
  inherited;
	cmbFindChange(nil);
  if Document.Editor.SelText <> '' then
     cmbFind.Text := Document.Editor.SelText;
end;

procedure TReplaceDialog.SetOptions;
begin
  inherited;
  frReplaceText := cmbReplace.Text;
	frPrompt := chkPrompt.Checked;
end;

procedure TReplaceDialog.chkInAllClick(Sender: TObject);
begin
	chkPrompt.Enabled := not chkInAll.Checked;

  if chkInAll.Checked then
  	chkPrompt.Checked := False; 
end;

end.
