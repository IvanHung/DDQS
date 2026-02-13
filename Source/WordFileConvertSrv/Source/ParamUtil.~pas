unit ParamUtil;

interface

uses
  Windows, Classes, SysUtils, FileResInfo, Forms, Registry, IniFiles;

type
  TParamMedia = class;
  TParamMediaClass = class of TParamMedia;

  TParamAccess = class(TObject)
  private
    FParamMedia: TParamMedia;
    FParamList: TList;
    FApplicationID: string;
    FResInfo: TFixedFileVersionInfo;
    FPageID: string;
    function GetValue(Section, Ident: string): string;
    procedure SetValue(Section, Ident: string; const Value: string);

    procedure SetApplicationID(const Value: string);
    procedure SetPageID(const Value: string);

    function GetParamClass: TParamMediaClass;
    procedure SetParamClass(const Value: TParamMediaClass);

    function GetSection(Index: Integer): string;
    function GetSectionCount: Integer;

    function GetItem(Section: string; Index: Integer): string;
    function GetItemCount(Section: string): Integer;
    function GetValueAsBool(Section, Ident: string): Boolean;
    function GetValueAsInt(Section, Ident: string): Integer;
    procedure SetValueAsBool(Section, Ident: string; const Value: Boolean);
    procedure SetValueAsInt(Section, Ident: string; const Value: Integer);
  protected
    function GetDefaultApplicationID: string;
  public
    constructor Create; overload;
    constructor Create(aPageID: string); overload;
    destructor Destroy; override;

    procedure Clear;

    property ResInfo: TFixedFileVersionInfo read FResInfo;

    property ApplicationID: string read FApplicationID write SetApplicationID;
    property PageID: string read FPageID write SetPageID;
    property ParamClass: TParamMediaClass read GetParamClass write SetParamClass;
    property Value[Section: string; Ident: string]: string read GetValue write SetValue; default;
    property ValueAsInt[Section: string; Ident: string]: Integer read GetValueAsInt write SetValueAsInt;
    property ValueAsBool[Section: string; Ident: string]: Boolean read GetValueAsBool write SetValueAsBool;

    procedure SectionDelete(Section: string);
    function SectionExists(Section: string): Boolean;
    procedure GetSectionList(SectionList: TStrings);
    property Section[Index: Integer]: string read GetSection;
    property SectionCount: Integer read GetSectionCount;

    procedure ItemDelete(Section: string; Ident: string);
    function ItemExists(Section: string; Ident: string): Boolean;
    procedure GetItemList(Section: string; ItemList: TStrings);
    property Item[Section: string; Index: Integer]: string read GetItem;
    property ItemCount[Section: string]: Integer read GetItemCount;
  end;

{ TParamMedia }

  TParamMedia = class(TObject)
  private
    FApplicationID: string;
    FPageID: string;
    FSectionList: TStringList;
    FItemList: TStringList;
    FLastAccessSection: string;
    procedure SetApplicationID(const Value: string);
    procedure SetPageID(const Value: string);
    function GetValue(Section, Ident: string): string;
    procedure SetValue(Section, Ident: string; const Value: string);
  protected
    property ApplicationID: string read FApplicationID;
    property PageID: string read FPageID;
    procedure Open; virtual; abstract;
    procedure Close; virtual; abstract;
    procedure GetSectionList(SectionList: TStrings); virtual; abstract;
    procedure GetItemList(Section: string; ItemList: TStrings); virtual; abstract;
    function InternalRead(Section, Ident: string): string; virtual; abstract;
    procedure InternalWrite(Section, Ident, Value: string); virtual; abstract;
    procedure InternalSectionDelete(Section: string); virtual; abstract;
    procedure InternalItemDelete(Section, Ident: string); virtual; abstract;
    procedure InternalClear; virtual; abstract;
  public
    constructor Create; virtual; abstract;
    destructor Destroy; override;

    procedure Clear; 

    procedure ResetList;
    procedure ReadItemList(Section: string);
    procedure ReadSectionList;

    property Value[Section: string; Ident: string]: string read GetValue write SetValue; default;

    function SectionExists(Section: string): Boolean;
    procedure SectionDelete(Section: string);
    property SectionList: TStringList read FSectionList;
    function GetSection(Index: Integer): string;
    function GetSectionCount: Integer;

    function ItemExists(Section, Ident: string): Boolean;
    procedure ItemDelete(Section, Ident: string); 
    property ItemList: TStringList read FItemList;
    function GetItem(Section: string; Index: Integer): string;
    function GetItemCount(Section: string): Integer;
  end;

{ TParamMediaRegistry }

type
  TParamMediaRegistry = class(TParamMedia)
  private
    FRegHomePath: string;
    FSectionList: TStringList;
    FSectionItemList: TStringList;
    FLastAccessListSection: string;
  protected
    FRootKey: DWORD;
    procedure Open; override;
    procedure Close; override;
    procedure GetSectionList(SectionList: TStrings); override;
    procedure GetItemList(Section: string; ItemList: TStrings); override;
    function InternalRead(Section, Ident: string): string; override;
    procedure InternalWrite(Section, Ident, Value: string); override;
    procedure InternalItemDelete(Section, Ident: string); override;
    procedure InternalSectionDelete(Section: string); override;
    procedure InternalClear; override;
  public
    constructor Create; override;
  end;

{ TParamMediaRegistryGlobal }

  TParamMediaRegistryGlobal = class(TParamMediaRegistry)
  public
    constructor Create; override;
  end;

var
  ParamAccess: TParamAccess;

implementation

var
  PrivateResInfo: TFixedFileVersionInfo = nil;

const
  DefinePageID: string = 'default';

const
  DefaultParamMediaClass: TParamMediaClass = TParamMediaRegistryGlobal;

{ TParamAccess }

constructor TParamAccess.Create;
begin
  FResInfo := PrivateResInfo;

  FApplicationID := GetDefaultApplicationID;
  FPageID := DefinePageID;
  FParamList := TList.Create;

  ParamClass := DefaultParamMediaClass;
end;

constructor TParamAccess.Create(aPageID: string);
begin
  FResInfo := PrivateResInfo;

  FApplicationID := GetDefaultApplicationID;
  FPageID := aPageID;
  FParamList := TList.Create;

  ParamClass := DefaultParamMediaClass;
end;

destructor TParamAccess.Destroy;
begin
  FParamMedia.Free;
  FParamList.Free;

  inherited;
end;

procedure TParamAccess.Clear;
begin
  FParamMedia.Clear;
end;

function TParamAccess.GetDefaultApplicationID: string;
begin
  if ResInfo.StringRes[RES_KEY_ProductName] <> '' then
    Result := ResInfo.StringRes[RES_KEY_ProductName]
  else if Application.Title <> '' then
    Result := Application.Title
  else
    Result := ParamStr(0);

  if ResInfo.StringRes[RES_KEY_CompanyName] <> '' then
    Result := ResInfo.StringRes[RES_KEY_CompanyName] + '.' + Result;
end;

function TParamAccess.GetValue(Section, Ident: string): string;
begin
  Section := Trim(Section);
  Ident := Trim(Ident);

  Result := FParamMedia.Value[Section, Ident];
end;

procedure TParamAccess.SetValue(Section, Ident: string;
  const Value: string);
begin
  Section := Trim(Section);
  Ident := Trim(Ident);

  if (Section = '') or (Ident = '') then
    raise Exception.Create('Required Section and Ident.');

  if Value = '' then
  begin
    if FParamMedia.ItemExists(Section, Ident) then
      FParamMedia.ItemDelete(Section, Ident);
    if FParamMedia.GetItemCount(Section) = 0 then
      FParamMedia.SectionDelete(Section);
  end
  else
    FParamMedia.Value[Section, Ident] := Value;
end;

function TParamAccess.GetValueAsInt(Section, Ident: string): Integer;
begin
  Result := StrToIntDef(Value[Section, Ident], 0);
end;

procedure TParamAccess.SetValueAsInt(Section, Ident: string;
  const Value: Integer);
begin
  Self.Value[Section, Ident] := IntToStr(Value);
end;

function TParamAccess.GetValueAsBool(Section, Ident: string): Boolean;
var
  BVal: string;
begin
  BVal := UpperCase(Trim(Value[Section, Ident]));
  Result := (BVal = 'Y') or (BVal = 'YES') or
      (BVal = 'T') or (BVal = 'TRUE') or (BVal = '1');
end;

procedure TParamAccess.SetValueAsBool(Section, Ident: string;
  const Value: Boolean);
begin
  if Value then
    Self.Value[Section, Ident] := 'True'
  else
    Self.Value[Section, Ident] := 'False';
end;

procedure TParamAccess.SetApplicationID(const Value: string);
begin
  FApplicationID := Trim(Value);
  FParamMedia.SetApplicationID(FApplicationID);
end;

procedure TParamAccess.SetPageID(const Value: string);
begin
  FPageID := Trim(Value);
  if FPageID = '' then
    FPageID := DefinePageID;
  FParamMedia.SetPageID(FPageID);
end;

function TParamAccess.GetParamClass: TParamMediaClass;
begin
  Result := TParamMediaClass(FParamMedia.ClassType);
end;

procedure TParamAccess.SetParamClass(const Value: TParamMediaClass);
begin
  if (FParamMedia = nil) or
      (Value <> TParamMediaClass(FParamMedia.ClassType)) then
  begin
    if FParamMedia <> nil then
      FParamMedia.Free;
    FParamMedia := Value.Create;
    FParamMedia.SetApplicationID(FApplicationID);
    FParamMedia.SetPageID(FPageID);
  end;
end;

function TParamAccess.GetSection(Index: Integer): string;
begin
  Result := FParamMedia.GetSection(Index);
end;

function TParamAccess.GetSectionCount: Integer;
begin
  Result := FParamMedia.GetSectionCount;
end;

function TParamAccess.SectionExists(Section: string): Boolean;
begin
  Result := FParamMedia.SectionExists(Section);
end;

procedure TParamAccess.SectionDelete(Section: string);
begin
  FParamMedia.SectionDelete(Section);
end;

procedure TParamAccess.GetSectionList(SectionList: TStrings);
begin
  FParamMedia.ReadSectionList;
  SectionList.Clear;
  SectionList.Assign(FParamMedia.SectionList);
end;

function TParamAccess.GetItem(Section: string; Index: Integer): string;
begin
  Result := FParamMedia.GetItem(Section, Index);
end;

function TParamAccess.GetItemCount(Section: string): Integer;
begin
  Result := FParamMedia.GetItemCount(Section);
end;

function TParamAccess.ItemExists(Section, Ident: string): Boolean;
begin
  Result := FParamMedia.ItemExists(Section, Ident);
end;

procedure TParamAccess.ItemDelete(Section, Ident: string);
begin
  FParamMedia.ItemDelete(Section, Ident);
end;

procedure TParamAccess.GetItemList(Section: string; ItemList: TStrings);
begin
  FParamMedia.ReadItemList(Section);
  ItemList.Clear;
  ItemList.Assign(FParamMedia.ItemList);
end;

{ TParamMedia }

destructor TParamMedia.Destroy;
begin
  Close;

  inherited;
end;

procedure TParamMedia.ResetList;
begin
  if FItemList <> nil then
  begin
    FItemList.Free;
    FItemList := nil;
  end;

  if FSectionList <> nil then
  begin
    FSectionList.Free;
    FSectionList := nil;
  end;
end;

procedure TParamMedia.ReadItemList(Section: string);
begin
  if (FItemList = nil) or (FLastAccessSection <> Section) then
  begin
    if FItemList <> nil then
      FItemList.Free;

    FItemList := TStringList.Create;

    GetItemList(Section, FItemList);
    FLastAccessSection := Section;
  end;
end;

procedure TParamMedia.ReadSectionList;
begin
  if FSectionList = nil then
  begin
    FSectionList := TStringList.Create;
    GetSectionList(FSectionList);
  end;
end;

procedure TParamMedia.SetApplicationID(const Value: string);
begin
  if FApplicationID <> Value then
  begin
    Close;
    ResetList;
    FApplicationID := Value;
    Open;
  end;
end;

procedure TParamMedia.SetPageID(const Value: string);
begin
  if FPageID <> Value then
  begin
    Close;
    ResetList;
    FPageID := Value;
    Open;
  end;
end;

function TParamMedia.GetValue(Section, Ident: string): string;
begin
  Section := Trim(Section);
  Ident := Trim(Ident);

  Result := '';
  try
    Result := InternalRead(Section, Ident);
  except
  end;
end;

procedure TParamMedia.SetValue(Section, Ident: string;
  const Value: string);
begin
  Section := Trim(Section);
  Ident := Trim(Ident);

  if (Section = '') or (Ident = '') then
    raise Exception.Create('Required Section and Ident.');

  ResetList;

  if Value = '' then
  begin
    if ItemExists(Section, Ident) then
      ItemDelete(Section, Ident);
    if GetItemCount(Section) = 0 then
      SectionDelete(Section);
  end
  else
    InternalWrite(Section, Ident, Value);
end;

function TParamMedia.SectionExists(Section: string): Boolean;
var
  i: Integer;
begin
  Result := False;

  try
    for i := 0 to GetSectionCount-1 do
      if GetSection(i) = Section then
      begin
        Result := True;
        Break;
      end;
  except
  end;
end;

function TParamMedia.GetSection(Index: Integer): string;
begin
  Result := '';

  try
    ReadSectionList;
    Result := FSectionList[Index];
  except
  end;
end;

function TParamMedia.GetSectionCount: Integer;
begin
  Result := 0;

  try
    ReadSectionList;
    Result := FSectionList.Count;
  except
  end;
end;

procedure TParamMedia.SectionDelete(Section: string);
begin
  ResetList;
  InternalSectionDelete(Section);
end;

function TParamMedia.ItemExists(Section, Ident: string): Boolean;
var
  i: Integer;
begin
  Result := False;

  try
    for i := 0 to GetItemCount(Section)-1 do
      if GetItem(Section, i) = Ident then
      begin
        Result := True;
        Break;
      end;
  except
  end;
end;

function TParamMedia.GetItem(Section: string; Index: Integer): string;
begin
  Result := '';

  try
    ReadItemList(Section);
    Result := FItemList[Index];
  except
  end;
end;

function TParamMedia.GetItemCount(Section: string): Integer;
begin
  Result := 0;

  try
    ReadItemList(Section);
    Result := FItemList.Count;
  except
  end;
end;

procedure TParamMedia.ItemDelete(Section, Ident: string);
begin
  ResetList;
  InternalItemDelete(Section, Ident);
end;

procedure TParamMedia.Clear;
begin
  ResetList;
  InternalClear;
end;

{ TParamMediaRegistry }

constructor TParamMediaRegistry.Create;
begin
  FRootKey := HKEY_CURRENT_USER;
end;

procedure TParamMediaRegistry.InternalClear;
var
  Reg: TRegistry;
begin
  FLastAccessListSection := '';
  FSectionItemList.Free;
  FSectionItemList := nil;
  FSectionList.Free;
  FSectionList := nil;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := FRootKey;
    Reg.DeleteKey(FRegHomePath);
  finally
    Reg.Free;
  end;
end;

procedure TParamMediaRegistry.InternalItemDelete(Section, Ident: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := FRootKey;
    if Reg.OpenKey(FRegHomePath + Section, False) then
      Reg.DeleteValue(Ident);
  finally
    Reg.Free;
  end;
end;

procedure TParamMediaRegistry.InternalSectionDelete(Section: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := FRootKey;
    Reg.DeleteKey(FRegHomePath + Section);
  finally
    Reg.Free;
  end;
end;

procedure TParamMediaRegistry.Open;
begin
  FRegHomePath := '\Software\' + ApplicationID + '\' + PageID + '\';
end;

procedure TParamMediaRegistry.Close;
begin
end;

procedure TParamMediaRegistry.GetItemList(Section: string;
  ItemList: TStrings);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := FRootKey;
    if Reg.OpenKey(FRegHomePath + Section, False) then
      Reg.GetValueNames(ItemList);
  finally
    Reg.Free;
  end;
end;

procedure TParamMediaRegistry.GetSectionList(SectionList: TStrings);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := FRootKey;
    if Reg.OpenKey(FRegHomePath, False) then
      Reg.GetKeyNames(SectionList);
  finally
    Reg.Free;
  end;
end;

function TParamMediaRegistry.InternalRead(Section, Ident: string): string;
var
  Reg: TRegistry;
begin
  Result := '';

  try
    Reg := TRegistry.Create;
    try
      Reg.RootKey := FRootKey;
      if Reg.OpenKey(FRegHomePath + Section, False) then
        if Reg.ValueExists(Ident) then
          Result := Reg.ReadString(Ident);
    finally
      Reg.Free;
    end;
  except
  end;
end;

procedure TParamMediaRegistry.InternalWrite(Section, Ident, Value: string);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := FRootKey;

    if not Reg.OpenKey(FRegHomePath + Section, True) then
      raise Exception.Create('Write registry value fail.')
    else
      Reg.WriteString(Ident, Value);
  finally
    Reg.Free;
  end;
end;

{
function TParamMediaRegistry.Item(Section: string; Index: Integer): string;
begin
  Result := '';

  try
    if (FSectionItemList = nil) or (FLastAccessListSection <> Section) then
    begin
      if FSectionItemList <> nil then
        FSectionItemList.Free;
        
      FReg := TRegistry.Create;
      try
        FReg.RootKey := FRootKey;
        if FReg.OpenKey(FRegHomePath + Section, False) then
        begin
          FSectionItemList := TStringList.Create;

          FReg.GetValueNames(FSectionItemList);
          FLastAccessListSection := Section;
        end;
      finally
        FReg.Free;
      end;
    end
    else
      Result := FSectionItemList[Index];
  except
  end;
end;

function TParamMediaRegistry.ItemCount(Section: string): Integer;
begin
  Result := 0;

  try
    if (FSectionItemList = nil) or (FLastAccessListSection <> Section) then
    begin
      if FSectionItemList <> nil then
        FSectionItemList.Free;
        
      FReg := TRegistry.Create;
      try
        FReg.RootKey := FRootKey;
        if FReg.OpenKey(FRegHomePath + Section, False) then
        begin
          FSectionItemList := TStringList.Create;

          FReg.GetValueNames(FSectionItemList);
          Result := FSectionItemList.Count;
          FLastAccessListSection := Section;
        end;
      finally
        FReg.Free;
      end;
    end
    else
      Result := FSectionItemList.Count;
  except
  end;
end;

function TParamMediaRegistry.ItemExists(Section, Ident: string): Boolean;
begin
  Result := Read(Section, Ident) <> '';
end;

procedure TParamMediaRegistry.RenewLists(Section: string);
begin
  if (FSectionItemList <> nil) and (FLastAccessListSection = Section) then
  begin
    FSectionItemList.Free;
    FSectionItemList := nil;
  end;

  if FSectionList <> nil then
  begin
    FSectionList.Free;
    FSectionList := nil;
  end;
end;

function TParamMediaRegistry.Section(Index: Integer): string;
begin
  Result := '';

  try
    if FSectionList = nil then
    begin
      FReg := TRegistry.Create;
      try
        FReg.RootKey := FRootKey;
        if FReg.OpenKey(FRegHomePath, False) then
        begin
          FSectionList := TStringList.Create;

          FReg.GetKeyNames(FSectionList);
        end;
      finally
        FReg.Free;
      end;
    end
    else
      Result := FSectionList[Index];
  except
  end;
end;

function TParamMediaRegistry.SectionCount: Integer;
begin
  if FSectionList = nil then
  begin
    FReg := TRegistry.Create;
    try
      FReg.RootKey := FRootKey;
      if FReg.OpenKey(FRegHomePath, False) then
      begin
        FSectionList := TStringList.Create;

        FReg.GetKeyNames(FSectionList);
        Result := FSectionList.Count;
      end
      else
        Result := 0;
    finally
      FReg.Free;
    end;
  end
  else
    Result := FSectionList.Count;
end;

procedure TParamMediaRegistry.RenewLists(Section: string);
begin

end;

function TParamMediaRegistry.SectionExists(Section: string): Boolean;
begin
  FReg := TRegistry.Create;
  try
    FReg.RootKey := FRootKey;
    Result := FReg.KeyExists(FRegHomePath + Section);
  finally
    FReg.Free;
  end;
end;}


{ TParamMediaRegistryGlobal }

constructor TParamMediaRegistryGlobal.Create;
begin
  FRootKey := HKEY_LOCAL_MACHINE;
end;

initialization
  PrivateResInfo := TFixedFileVersionInfo.Create(ParamStr(0));
  ParamAccess := TParamAccess.Create;

finalization
  ParamAccess.Free;
  PrivateResInfo.Free;

end.
