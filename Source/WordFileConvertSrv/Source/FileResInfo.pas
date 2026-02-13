unit FileResInfo;

interface

uses
  Classes, Windows, SysUtils;

type
  TFixedFileInfoFlag = (ffDebug, ffInfoInferred, ffPatched, ffPreRelease,
    ffPrivateBuild, ffSpecialBuild);
  TFixedFileInfoFlags = set of TFixedFileInfoFlag;

  TVersionOperatingSystemFlag = (vosUnknown, vosDOS, vosOS2_16, vosOS2_32,
    vosNT, vosWindows16, vosPresentationManager16, vosPresentationManager32,
    vosWindows32);
  TVersionOperatingSystemFlags = set of TVersionOperatingSystemFlag;

  TVersionFileType = (vftUnknown, vftApplication, vftDLL, vftDriver, vftFont,
    vftVXD, vftStaticLib);

  TFixedFileVersionInfo = class
  private
    FData: PVSFixedFileInfo;
    FFileName: string;
    FTranslationIDs: TStringList;
    FTranslationIDIndex: Integer;
    FVersionInfo: PChar;
    FVersionInfoSize: Integer;

    function GetSignature: DWORD;
    function GetStructureVersion: DWORD;
    function GetFileVersionMS: DWORD;
    function GetFileVersionLS: DWORD;
    function GetProductVersionMS: DWORD;
    function GetProductVersionLS: DWORD;
    function GetValidFlags: TFixedFileInfoFlags;
    function GetFlags: TFixedFileInfoFlags;
    function GetFileOperatingSystem: TVersionOperatingSystemFlags;
    function GetFileType: TVersionFileType;
    function GetFileSubType: DWORD;
    function GetCreationDate: TDateTime;
    function GetStringRes(Index: string): string;
  public
    constructor Create(FileName: string);
    destructor Destroy; override;

    property FileName: string read FFileName;
    property Data: PVSFixedFileInfo read FData write FData;
    property Signature: DWORD read GetSignature;
    property StructureVersion: DWORD read GetStructureVersion;
    property FileVersionMS: DWORD read GetFileVersionMS;
    property FileVersionLS: DWORD read GetFileVersionLS;
    property ProductVersionMS: DWORD read GetProductVersionMS;
    property ProductVersionLS: DWORD read GetProductVersionLS;
    property ValidFlags: TFixedFileInfoFlags read GetValidFlags;
    property Flags: TFixedFileInfoFlags read GetFlags;
    property FileOperatingSystem: TVersionOperatingSystemFlags
      read GetFileOperatingSystem;
    property FileType: TVersionFileType read GetFileType;
    property FileSubType: DWORD read GetFileSubType;
    property CreationDate: TDateTime read GetCreationDate;
    property StringRes[Index: string]: string read GetStringRes;
  end;

  function ResGetFileVersion(FileName: string): string;
  function ResGetProductVersion(FileName: string): string;
  function ResGetFileResString(FileName, Index: string): string;
  function ResGetFileCreateDate(FileName: string): TDateTime;

const
  RES_KEY_CompanyName = 'CompanyName';
  RES_KEY_FileDescription = 'FileDescription';
  RES_KEY_FileVersion = 'FileVersion';
  RES_KEY_InternalName = 'InternalName';
  RES_KEY_LegalCopyright = 'LegalCopyright';
  RES_KEY_LegalTrademarks = 'LegalTrademarks';
  RES_KEY_OriginalFilename = 'OriginalFilename';
  RES_KEY_ProductName = 'ProductName';
  RES_KEY_ProductVersion = 'ProductVersion';
  RES_KEY_Comments = 'Comments';
  RES_KEY_BuildFlags = 'BuildFlags';

implementation

const
  DEFAULT_LANG_ID       = $0409;
  DEFAULT_CHAR_SET_ID   = $04E4;
  DEFAULT_LANG_CHAR_SET = '040904E4';

function ResGetFileVersion(FileName: string): string;
var
  VerInfo: TFixedFileVersionInfo;
begin
  VerInfo := TFixedFileVersionInfo.Create(FileName);
  try
    Result := IntToStr(HiWord(VerInfo.GetFileVersionMS)) + '.' +
      IntToStr(LoWord(VerInfo.GetFileVersionMS)) + '.' +
      IntToStr(HiWord(VerInfo.GetFileVersionLS)) + '.' +
      IntToStr(LoWord(VerInfo.GetFileVersionLS));
  finally
    VerInfo.Free;
  end;
end;

function ResGetProductVersion(FileName: string): string;
var
  VerInfo: TFixedFileVersionInfo;
begin
  VerInfo := TFixedFileVersionInfo.Create(FileName);
  try
    Result := IntToStr(HiWord(VerInfo.GetProductVersionMS)) + '.' +
      IntToStr(LoWord(VerInfo.GetProductVersionMS)) + '.' +
      IntToStr(HiWord(VerInfo.GetProductVersionLS)) + '.' +
      IntToStr(LoWord(VerInfo.GetProductVersionLS));
  finally
    VerInfo.Free;
  end;
end;

function ResGetFileResString(FileName, Index: string): string;
var
  VerInfo: TFixedFileVersionInfo;
begin
  VerInfo := TFixedFileVersionInfo.Create(FileName);
  try
    Result := VerInfo.StringRes[Index];
  finally
    VerInfo.Free;
  end;
end;

function ResGetFileCreateDate(FileName: string): TDateTime;
var
  VerInfo: TFixedFileVersionInfo;
begin
  VerInfo := TFixedFileVersionInfo.Create(FileName);
  try
    Result := VerInfo.CreationDate;
  finally
    VerInfo.Free;
  end;
end;

constructor TFixedFileVersionInfo.Create(FileName: string);
const
  TRANSLATION_INFO = '\VarFileInfo\Translation';
type
  TTranslationPair = packed record
    Lang,
    CharSet: word;
  end;
  PTranslationIDList = ^TTranslationIDList;
  TTranslationIDList = array[0..MAXINT div SizeOf(TTranslationPair)-1]
      of TTranslationPair;
var
  QueryLen: UINT;
  IDsLen: UINT;
  Dummy: DWORD;
  IDs: PTranslationIDList;
  IDCount: integer;
  TempFilename: array[0..255] of char;
begin
  FTranslationIDs := TStringList.Create;

  FFileName := FileName;

  StrPCopy(TempFileName, FFileName);

  FVersionInfoSize := GetFileVersionInfoSize(TempFileName, Dummy);
  if FVersionInfoSize = 0 then
    FData := nil
  else
  begin
    FVersionInfo := AllocMem(FVersionInfoSize);
    GetFileVersionInfo(PChar(FileName), Dummy, FVersionInfoSize, FVersionInfo);

    VerQueryValue(FVersionInfo, '\', Pointer(FData), QueryLen);
    
    if VerQueryValue(FVersionInfo, TRANSLATION_INFO, Pointer(IDs), IDsLen) then
    begin
      IDCount := IDsLen div SizeOf(TTranslationPair);
      for Dummy := 0 to IDCount-1 do
      begin
        if IDs^[Dummy].Lang = 0 then
          IDs^[Dummy].Lang := DEFAULT_LANG_ID;
        if IDs^[Dummy].CharSet = 0 then
          IDs^[Dummy].CharSet := DEFAULT_CHAR_SET_ID;
        FTranslationIDs.Add(Format('%.4x%.4x',
            [IDs^[Dummy].Lang, IDs^[Dummy].CharSet]));
      end;
    end;
  end;
end;

destructor TFixedFileVersionInfo.Destroy;
begin
  FreeMem(FVersionInfo);
  FTranslationIDs.Free;

  inherited;
end;

function TFixedFileVersionInfo.GetSignature: DWORD;
begin
  if FData = nil then
    Result := 0
  else
    Result := FData^.dwSignature;
end;

function TFixedFileVersionInfo.GetStructureVersion: DWORD;
begin
  if FData = nil then
    Result := 0
  else
    Result := FData^.dwStrucVersion;
end;

function TFixedFileVersionInfo.GetFileVersionMS: DWORD;
begin
  if FData = nil then
    Result := 0
  else
    Result := FData^.dwFileVersionMS;
end;

function TFixedFileVersionInfo.GetFileVersionLS: DWORD;
begin
  if FData = nil then
    Result := 0
  else
    Result := FData^.dwFileVersionLS;
end;

function TFixedFileVersionInfo.GetProductVersionMS: DWORD;
begin
  if FData = nil then
    Result := 0
  else
    Result := FData^.dwProductVersionMS;
end;

function TFixedFileVersionInfo.GetProductVersionLS: DWORD;
begin
  if FData = nil then
    Result := 0
  else
    Result := FData^.dwProductVersionLS;
end;

function TFixedFileVersionInfo.GetValidFlags: TFixedFileInfoFlags;
begin
  Result := [];
  if FData <> nil then
  begin
    if (FData^.dwFileFlagsMask and VS_FF_DEBUG) <> 0 then
      Include(Result, ffDebug);
    if (FData^.dwFileFlagsMask and VS_FF_PRERELEASE) <> 0 then
      Include(Result, ffPreRelease);
    if (FData^.dwFileFlagsMask and VS_FF_PATCHED) <> 0 then
      Include(Result, ffPatched);
    if (FData^.dwFileFlagsMask and VS_FF_PRIVATEBUILD) <> 0 then
      Include(Result, ffPrivateBuild);
    if (FData^.dwFileFlagsMask and VS_FF_INFOINFERRED) <> 0 then
      Include(Result, ffInfoInferred);
    if (FData^.dwFileFlagsMask and VS_FF_SPECIALBUILD) <> 0 then
      Include(Result, ffSpecialBuild);
  end;
end;

function TFixedFileVersionInfo.GetFlags: TFixedFileInfoFlags;
begin
  Result := [];
  if FData <> nil then
  begin
    if (FData^.dwFileFlags and VS_FF_DEBUG) <> 0 then
      Include(Result, ffDebug);
    if (FData^.dwFileFlags and VS_FF_PRERELEASE) <> 0 then
      Include(Result, ffPreRelease);
    if (FData^.dwFileFlags and VS_FF_PATCHED) <> 0 then
      Include(Result, ffPatched);
    if (FData^.dwFileFlags and VS_FF_PRIVATEBUILD) <> 0 then
      Include(Result, ffPrivateBuild);
    if (FData^.dwFileFlags and VS_FF_INFOINFERRED) <> 0 then
      Include(Result, ffInfoInferred);
    if (FData^.dwFileFlags and VS_FF_SPECIALBUILD) <> 0 then
      Include(Result, ffSpecialBuild);
  end;
end;

function TFixedFileVersionInfo.GetFileOperatingSystem:
  TVersionOperatingSystemFlags;
begin
  Result := [];
  if FData <> nil then
  begin
    case HiWord(FData^.dwFileOS) of
      VOS_DOS shr 16: Include(Result, vosDOS);
      VOS_OS216 shr 16: Include(Result, vosOS2_16);
      VOS_OS232 shr 16: Include(Result, vosOS2_32);
      VOS_NT shr 16: Include(Result, vosNT);
    else
      Include(Result, vosUnknown);
    end;

    case LoWord(FData^.dwFileOS) of
      LoWord(VOS__WINDOWS16): Include(Result, vosWindows16);
      LoWord(VOS__PM16): Include(Result, vosPresentationManager16);
      LoWord(VOS__PM32): Include(Result, vosPresentationManager32);
      LoWord(VOS__WINDOWS32): Include(Result, vosWindows32);
    else
      Include(Result, vosUnknown);
    end;
  end;
end;

function TFixedFileVersionInfo.GetFileType: TVersionFileType;
begin
  Result := vftUnknown;
  if FData <> nil then
  begin
    case FData^.dwFileType of
      VFT_APP: Result := vftApplication;
      VFT_DLL: Result := vftDLL;
      VFT_DRV: Result := vftDriver;
      VFT_FONT: Result := vftFont;
      VFT_VXD: Result := vftVXD;
      VFT_STATIC_LIB: Result := vftStaticLib;
    end;
  end;
end;

function TFixedFileVersionInfo.GetFileSubType: DWORD;
begin
  if FData = nil then
    Result := 0
  else
  begin
    Result := FData^.dwFileSubtype;
  end;
end;

function TFixedFileVersionInfo.GetCreationDate: TDateTime;
begin
  if FData = nil then
    Result := 0
  else
    Result := FileDateToDateTime(FileAge(FileName));
end;

function TFixedFileVersionInfo.GetStringRes(Index: string): string;
var
  ResStr: PChar;
  StrLen: UINT;
  SubBlock: array[0..255] of char;
  LangCharSet: string;
begin
  if FTranslationIDIndex < FTranslationIDs.Count then
    LangCharSet := FTranslationIDs[FTranslationIDIndex]
  else
    LangCharSet := DEFAULT_LANG_CHAR_SET;
  StrPCopy(SubBlock, '\StringFileInfo\' + LangCharSet + '\' + Index);
  if (FVersionInfo <> nil) and
     VerQueryValue(FVersionInfo, SubBlock, Pointer(ResStr), StrLen)
  then
    Result := StrPas(ResStr)
  else
    Result := '';
end;

end.
 