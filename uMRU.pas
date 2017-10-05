unit uMRU;

interface

uses
	Classes, SysUtils, uMyIniFiles;

type
	TMRUList = class
  private
  	fMRUList: TStringList;
    fMRUListMPQ: TStringList;
    fLimit: Integer;
    fMyIniFile: TMyIniFile;
    fIniSection: String;
    function GetItem(Index: Integer): String;
    procedure Read;
    procedure Write;
    function GetCount: Integer;
  public
  	constructor Create(aMyIniFile: TMyIniFile; aLimit: Integer;
    	aIniSection: String);
    destructor Destroy; override;

    procedure Add(Item, MPQ: String);
    procedure Clear;

    property AllItems: TStringList read fMRUList;
    property AllItemsMPQ: TStringList read fMRUListMPQ;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: String read GetItem; default;
  end;

implementation

{ TMRUList }

procedure TMRUList.Add(Item,MPQ: String);
var i:Integer;
begin
  i := fMRUList.IndexOf(Item);
	if i <> -1 then
   begin
  	fMRUList.Delete(i);
    fMRUListMPQ.Delete(i);
   end;

  fMRUList.Insert(0, Item);
  fMRUListMPQ.Insert(0, MPQ);

  if fMRUList.Count > fLimit then
   begin
  	fMRUList.Delete(fLimit);
    fMRUListMPQ.Delete(fLimit);
   end;
end;

procedure TMRUList.Clear;
begin
  fMRUList.Clear;
  fMRUListMPQ.Clear;
  fMyIniFile.EraseSection(fIniSection);
end;

constructor TMRUList.Create(aMyIniFile: TMyIniFile; aLimit: Integer;
  aIniSection: String);
begin
	fMyIniFile := aMyIniFile;
  fLimit := aLimit;
  fIniSection := aIniSection;
  fMRUList := TStringList.Create;
  fMRUListMPQ := TStringList.Create;
  Read;
end;

destructor TMRUList.Destroy;
begin
	Write;
  fMRUList.Free;
  inherited;
end;

function TMRUList.GetCount: Integer;
begin
	Result := fMRUList.Count;
end;

function TMRUList.GetItem(Index: Integer): String;
begin
	Result := fMRUList[Index];
end;

procedure TMRUList.Read;
var
	i: Integer;
begin
	i := 1;

	while (fMyIniFile.ValueExists(fIniSection, 'MRUItem' + IntToStr(i)))
  and (i <= fLimit) do
	begin
		fMRUList.Add(fMyIniFile.ReadString(fIniSection, 'MRUItem' + IntToStr(i), ''));
    fMRUListMPQ.Add( fMyIniFile.ReadString(fIniSection, 'MRUItemMPQ' + IntToStr(i), ''));
		Inc(i);
	end;
end;

procedure TMRUList.Write;
var
	i: Integer;
begin
	for i := 1 to fMRUList.Count do
   begin
		fMyIniFile.WriteString(fIniSection, 'MRUItem' + IntToStr(i), fMRUList[i - 1]);
    fMyIniFile.WriteString(fIniSection, 'MRUItemMPQ' + IntToStr(i), fMRUListMPQ[i - 1]);
   end;
end;

end.
