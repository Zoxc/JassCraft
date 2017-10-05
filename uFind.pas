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
unit uFind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFindDialog = class(TForm)
    lblFind: TLabel;
    gbConditions: TGroupBox;
    chkWhole: TCheckBox;
    chkCase: TCheckBox;
    chkRegExp: TCheckBox;
    chkInAll: TCheckBox;
    btnFindNext: TButton;
    btnClose: TButton;
    btnHelp: TButton;
    chkSelOnly: TCheckBox;
    chkFromCursor: TCheckBox;
    gbDirection: TGroupBox;
    rbUp: TRadioButton;
    rbDown: TRadioButton;
    chkListFounds: TCheckBox;
    cmbFind: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure cmbFindChange(Sender: TObject);
    procedure btnFindNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkRegExpClick(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure SetOptions; virtual;
  public
    { Public declarations }
  end;

var
  FindDialog: TFindDialog;

implementation

uses uDocuments, uMain, uUtils, uMyIniFiles;

{$R *.dfm}

procedure TFindDialog.FormActivate(Sender: TObject);
begin
	AlphaBlendValue := 255;
end;

procedure TFindDialog.FormDeactivate(Sender: TObject);
begin
	AlphaBlendValue := 155;
end;

procedure TFindDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	Action := caFree;
  FindDialog := nil;
end;

procedure TFindDialog.btnCloseClick(Sender: TObject);
begin
	Close;
end;

procedure TFindDialog.cmbFindChange(Sender: TObject);
  procedure WholeWordsOpt(aEnabled: Boolean);
  begin
    chkWhole.Enabled := aEnabled;

    if not aEnabled then
      chkWhole.Checked := False;
  end;
begin
  btnFindNext.Enabled := cmbFind.Text <> '';

  if Pos(#32, cmbFind.Text) <> 0 then
    WholeWordsOpt(False)
  else if Pos(#9, cmbFind.Text) <> 0 then
    WholeWordsOpt(False)
  else
    if not chkWhole.Enabled then
      WholeWordsOpt(True);
end;

procedure TFindDialog.btnFindNextClick(Sender: TObject);
var
	i: Integer;

  procedure NotFound;
  begin
  	MainForm.StatusMsg( PChar( Format(msgNotFound, [cmbFind.Text]) ), ErrorMsgColor,
    	clWhite, 4000, False );
  end;
begin
	SetOptions;
  
	if chkInAll.Checked then
  	for i := 0 to DocumentFactory.Count - 1 do
    begin
    	if DocumentFactory.IsSearchedForTheFirstTime( PChar(frFindText) ) then
    		DocumentFactory.Documents[i].FindText(frFindText, frWholeWords,
        	frMatchCase, frRegExp, chkSelOnly.Checked, frFromCursor, frDirUp, chkListFounds.Checked)
      else
      	DocumentFactory.Documents[i].FindNext;
    end
  else
  begin
  	if DocumentFactory.IsSearchedForTheFirstTime(frFindText) then
    begin
			if not Document.FindText(frFindText, frWholeWords,
				frMatchCase, frRegExp, chkSelOnly.Checked, frFromCursor, frDirUp, chkListFounds.Checked) then
        	NotFound;
    end
    else
    begin
    	if not Document.FindNext then
      	NotFound;
    end;
  end;

end;

procedure TFindDialog.FormCreate(Sender: TObject);
begin
	cmbFindChange(nil);
  chkRegExpClick(nil);
  if Document.Editor.SelText <> '' then
       cmbFind.Text := Document.Editor.SelText;
end;

procedure TFindDialog.SetOptions;
begin
	frFindText := cmbFind.Text;
	frWholeWords := chkWhole.Checked;
  frMatchCase := chkCase.Checked;
  frRegExp := chkRegExp.Checked;
  frFromCursor := chkFromCursor.Checked;
  frInAll := chkInAll.Checked;
  frDirUp := rbUp.Checked;
  frSelOnly := (chkSelOnly.Checked) and (chkSelOnly.Enabled);
end;

procedure TFindDialog.chkRegExpClick(Sender: TObject);
begin
	chkWhole.Enabled := not chkRegExp.Checked;
end;

end.
