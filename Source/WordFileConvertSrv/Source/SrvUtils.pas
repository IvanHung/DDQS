unit SrvUtils;

interface

uses
  Windows, SysUtils, Classes, ComCtrls;

type
  TSrvStatus = (ssNotExists,
      ssStopped, ssStartPending, ssStopPending, ssRunning,
      ssContinuePending, ssPausePending, ssPaused);

  TServiceUtility = class(TObject)
  private
    FHSCMan: THandle;
    FServiceName: string;
    FStatus: TSrvStatus;
    function GetActive: Boolean;
    function GetInstalled: Boolean;
    procedure SetActive(const Value: Boolean);
    procedure CloseSCMan;
    procedure OpenSCMan;
  public
    constructor Create(aServiceName: string);
    destructor Destroy; override;

    function Install(DisplayName: string; FileName: string;
        AutoStart: Boolean = True; ProcessInteractive: Boolean = False): Boolean;
    function Uninstall: Boolean;

    function Start: Boolean;
    function Stop: Boolean;

    procedure ResetStatus;
    
    property Status: TSrvStatus read FStatus;
    property Active: Boolean read GetActive write SetActive;
    property Installed: Boolean read GetInstalled;

    property ServiceName: string read FServiceName;
  end;

implementation

const

  { Service State -- for Enum Requests (Bit Mask) }
  SERVICE_ACTIVE = $00000001;
  SERVICE_INACTIVE = $00000002;
  SERVICE_STATE_ALL = (SERVICE_ACTIVE or
    SERVICE_INACTIVE);

  { Character to designate that a name is a group }
  SC_GROUP_IDENTIFIERA = '+';
  SC_GROUP_IDENTIFIER = SC_GROUP_IDENTIFIERA;

  { Controls }
  SERVICE_CONTROL_STOP = $00000001;
  SERVICE_CONTROL_PAUSE = $00000002;
  SERVICE_CONTROL_CONTINUE = $00000003;
  SERVICE_CONTROL_INTERROGATE = $00000004;
  SERVICE_CONTROL_SHUTDOWN = $00000005;

  { Service State -- for CurrentState }
  SERVICE_STOPPED = $00000001;
  SERVICE_START_PENDING = $00000002;
  SERVICE_STOP_PENDING = $00000003;
  SERVICE_RUNNING = $00000004;
  SERVICE_CONTINUE_PENDING = $00000005;
  SERVICE_PAUSE_PENDING = $00000006;
  SERVICE_PAUSED = $00000007;

  { Service Control Manager object specific access types }
  SC_MANAGER_CONNECT = $0001;
  SC_MANAGER_CREATE_SERVICE = $0002;
  SC_MANAGER_ENUMERATE_SERVICE = $0004;
  SC_MANAGER_LOCK = $0008;
  SC_MANAGER_QUERY_LOCK_STATUS = $0010;
  SC_MANAGER_MODIFY_BOOT_CONFIG = $0020;

  SC_MANAGER_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or
    SC_MANAGER_CONNECT or
    SC_MANAGER_CREATE_SERVICE or
    SC_MANAGER_ENUMERATE_SERVICE or
    SC_MANAGER_LOCK or
    SC_MANAGER_QUERY_LOCK_STATUS or
    SC_MANAGER_MODIFY_BOOT_CONFIG);

  { Service object specific access type }
  SERVICE_QUERY_CONFIG = $0001;
  SERVICE_CHANGE_CONFIG = $0002;
  SERVICE_QUERY_STATUS = $0004;
  SERVICE_ENUMERATE_DEPENDENTS = $0008;
  SERVICE_START = $0010;
  SERVICE_STOP = $0020;
  SERVICE_PAUSE_CONTINUE = $0040;
  SERVICE_INTERROGATE = $0080;
  SERVICE_USER_DEFINED_CONTROL = $0100;

  SERVICE_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or
    SERVICE_QUERY_CONFIG or
    SERVICE_CHANGE_CONFIG or
    SERVICE_QUERY_STATUS or
    SERVICE_ENUMERATE_DEPENDENTS or
    SERVICE_START or
    SERVICE_STOP or
    SERVICE_PAUSE_CONTINUE or
    SERVICE_INTERROGATE or
    SERVICE_USER_DEFINED_CONTROL);

  { Service Types (Bit Mask) }
  SERVICE_KERNEL_DRIVER = $00000001;
  SERVICE_FILE_SYSTEM_DRIVER = $00000002;
  SERVICE_ADAPTER = $00000004;
  SERVICE_RECOGNIZER_DRIVER = $00000008;

  SERVICE_DRIVER = (SERVICE_KERNEL_DRIVER or
    SERVICE_FILE_SYSTEM_DRIVER or
    SERVICE_RECOGNIZER_DRIVER);

  SERVICE_WIN32_OWN_PROCESS = $00000010;
  SERVICE_WIN32_SHARE_PROCESS = $00000020;
  SERVICE_WIN32 = (SERVICE_WIN32_OWN_PROCESS or
    SERVICE_WIN32_SHARE_PROCESS);

  SERVICE_INTERACTIVE_PROCESS = $00000100;

  SERVICE_TYPE_ALL = (SERVICE_WIN32 or
    SERVICE_ADAPTER or
    SERVICE_DRIVER or
    SERVICE_INTERACTIVE_PROCESS);

  { Start Type }
  SERVICE_BOOT_START = $00000000;
  SERVICE_SYSTEM_START = $00000001;
  SERVICE_AUTO_START = $00000002;
  SERVICE_DEMAND_START = $00000003;
  SERVICE_DISABLED = $00000004;

  { Error control type }
  SERVICE_ERROR_IGNORE = $00000000;
  SERVICE_ERROR_NORMAL = $00000001;
  SERVICE_ERROR_SEVERE = $00000002;
  SERVICE_ERROR_CRITICAL = $00000003;

type
  PServiceStatus = ^TServiceStatus;
  _SERVICE_STATUS = record
    dwServiceType: DWORD;
    dwCurrentState: DWORD;
    dwControlsAccepted: DWORD;
    dwWin32ExitCode: DWORD;
    dwServiceSpecificExitCode: DWORD;
    dwCheckPoint: DWORD;
    dwWaitHint: DWORD;
  end;
  SERVICE_STATUS = _SERVICE_STATUS;
  TServiceStatus = _SERVICE_STATUS;

  PEnumServiceStatusA = ^TEnumServiceStatusA;
  PEnumServiceStatus = PEnumServiceStatusA;

  _ENUM_SERVICE_STATUSA = record
    lpServiceName: PAnsiChar;
    lpDisplayName: PAnsiChar;
    ServiceStatus: TServiceStatus;
  end;
  ENUM_SERVICE_STATUSA = _ENUM_SERVICE_STATUSA;
  _ENUM_SERVICE_STATUS = _ENUM_SERVICE_STATUSA;
  TEnumServiceStatusA = _ENUM_SERVICE_STATUSA;
  TEnumServiceStatus = TEnumServiceStatusA;

  { QueryConfig Service Configuration Structure }
  PQueryServiceConfigA = ^TQueryServiceConfigA;
  PQueryServiceConfig = PQueryServiceConfigA;
  _QUERY_SERVICE_CONFIGA = record
    dwServiceType: DWORD;
    dwStartType: DWORD;
    dwErrorControl: DWORD;
    lpBinaryPathName: PAnsiChar;
    lpLoadOrderGroup: PAnsiChar;
    dwTagId: DWORD;
    lpDependencies: PAnsiChar;
    lpServiceStartName: PAnsiChar;
    lpDisplayName: PAnsiChar;
  end;
  _QUERY_SERVICE_CONFIG = _QUERY_SERVICE_CONFIGA;
  QUERY_SERVICE_CONFIGA = _QUERY_SERVICE_CONFIGA;
  QUERY_SERVICE_CONFIG = QUERY_SERVICE_CONFIGA;
  TQueryServiceConfigA = _QUERY_SERVICE_CONFIGA;
  TQueryServiceConfig = TQueryServiceConfigA;
  
  TOpenSCManager = function(lpMachineName, lpDatabaseName: PChar;
    dwDesiredAccess: DWORD): THandle; stdcall;

  TLockServiceDatabase = function(hSCManager: THandle): Pointer; stdcall;
  TUnlockServiceDatabase = function(ScLock: Pointer): BOOL; stdcall;

  TCreateService = function(hSCManager: THandle;
    lpServiceName, lpDisplayName: PChar;
    dwDesiredAccess, dwServiceType, dwStartType, dwErrorControl: DWORD;
    lpBinaryPathName, lpLoadOrderGroup: PChar;
    lpdwTagId: LPDWORD;
    lpDependencies, lpServiceStartName, lpPassword: PChar): THandle; stdcall;

  TCloseServiceHandle = function(hSCObject: THandle): BOOL; stdcall;

  TOpenService = function(hSCManager: THandle;
    lpServiceName: PChar;
    dwDesiredAccess: DWORD): THandle; stdcall;

  TControlService = function(hService: THandle;
    dwControl: DWORD;
    var lpServiceStatus: TServiceStatus): BOOL; stdcall;

  TQueryServiceStatus = function(hService: THandle;
    var lpServiceStatus: TServiceStatus): BOOL; stdcall;

  TDeleteService = function(hService: THandle): BOOL; stdcall;

  TStartService = function(hService: THandle;
    dwNumServiceArgs: DWORD;
    var lpServiceArgVectors: PChar): BOOL; stdcall;

  TEnumServicesStatus = function(hSCManager: THandle;
    dwServiceType, dwServiceState: DWORD;
    var lpServices: TEnumServiceStatus;
    cbBufSize: DWORD;
    var pcbBytesNeeded, lpServicesReturned, lpResumeHandle: DWORD): BOOL;
      stdcall;

  TQueryServiceConfigFunc = function(hService: THandle;
    lpServiceConfig: PQueryServiceConfig;
    cbBufSize: DWORD;
    var pcbBytesNeeded: DWORD): BOOL; stdcall;

  TAdvApiProcs = class
  private
    FHAdvApi32: THandle;
  public
    OpenSCManager: TOpenSCManager;
    LockServiceDatabase: TLockServiceDatabase;
    UnlockServiceDatabase: TUnlockServiceDatabase;
    CreateService: TCreateService;
    CloseServiceHandle: TCloseServiceHandle;
    OpenService: TOpenService;
    ControlService: TControlService;
    QueryServiceStatus: TQueryServiceStatus;
    DeleteService: TDeleteService;
    StartService: TStartService;
    EnumServicesStatus: TEnumServicesStatus;
    QueryServiceConfig: TQueryServiceConfigFunc;
    constructor Create;
    destructor Destroy; override;
  end;

var
  AdvApiProcs: TAdvApiProcs = nil;

procedure SetControlState(
  HSvc: THandle; WantedState: Cardinal; var SS: TServiceStatus);
var
  OldCheckPoint: DWORD;
  WaitTime: DWORD;
  StartTickCount: DWORD;
begin
  if AdvApiProcs.QueryServiceStatus(HSvc, SS) then
  begin
    StartTickCount := GetTickCount();
    OldCheckPoint := SS.dwCheckPoint;

    while (SS.dwCurrentState <> WantedState) do
    begin
      WaitTime := DWORD(SS.dwWaitHint div 10);

      if (WaitTime < 1000) then
        WaitTime := 1000
      else if (WaitTime > 10000) then
        WaitTime := 10000;

      Sleep(WaitTime);

      if not AdvApiProcs.QueryServiceStatus(HSvc, SS) then
        Break;

      if (SS.dwCheckPoint > OldCheckPoint) then
      begin
        StartTickCount := GetTickCount();
        OldCheckPoint := SS.dwCheckPoint;
      end
      else
      begin
        if (GetTickCount - StartTickCount > SS.dwWaitHint) then
          Break;
      end;
    end;
  end;
end;

{ TServiceUtility }

constructor TServiceUtility.Create(aServiceName: string);
begin
  if AdvApiProcs = nil then
    AdvApiProcs := TAdvApiProcs.Create;

  OpenSCMan;

  FServiceName := aServiceName;
  ResetStatus;
end;

destructor TServiceUtility.Destroy;
begin
  CloseSCMan;

  inherited;
end;

procedure TServiceUtility.OpenSCMan;
begin
  FHSCMan := AdvApiProcs.OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if FHSCMan = 0 then
    raise Exception.Create('Can not open Service Control Manager');
end;

procedure TServiceUtility.CloseSCMan;
begin
  if FHSCMan <> 0 then
    AdvApiProcs.CloseServiceHandle(FHSCMan);
end;

function TServiceUtility.Install(DisplayName: string; FileName: string;
    AutoStart: Boolean = True; ProcessInteractive: Boolean = False): Boolean;
const
  BoolToAutoStart: array[False..True] of DWORD = (SERVICE_DEMAND_START,
    SERVICE_AUTO_START);
var
  HSvc: THandle;
  ServiceType: DWORD;
begin
  ResetStatus;
  if FStatus <> ssNotExists then
  begin
    Result := True;
    Exit;
  end;

  if ExtractFilePath(FileName) = '' then
    FileName := ExtractFilePath(ParamStr(0)) + FileName;

  if not FileExists(FileName) then
    raise Exception.Create('File not exists.');

  if ProcessInteractive then
    ServiceType := SERVICE_WIN32_OWN_PROCESS or SERVICE_INTERACTIVE_PROCESS
  else
    ServiceType := SERVICE_WIN32_OWN_PROCESS;

  Result := False;
  try
    HSvc := AdvApiProcs.CreateService(
      FHSCMan, // handle to SCM database
      PChar(FServiceName), // name of service to start
      PChar(DisplayName), // display name
      SERVICE_ALL_ACCESS, // type of access to service
      ServiceType, // type of service
      BoolToAutoStart[AutoStart], // when to start service
      SERVICE_ERROR_NORMAL, // severity of service failure
      PChar(FileName), // name of binary file
      nil, // name of load ordering group
      nil, // tag identifier
      nil, // array of dependency names
      nil, // account name
      nil); // account password

    if HSvc = 0 then
      raise Exception.Create('Can not register service: ' + FServiceName);

    AdvApiProcs.CloseServiceHandle(HSvc);

    Result := GetInstalled;
  except
  end;

  ResetStatus;
end;

function TServiceUtility.Uninstall: Boolean;
var
  HSvc: THandle;
  Ret: LongInt;
begin
  ResetStatus;
  if FStatus = ssNotExists then
  begin
    Result := True;
    Exit;
  end;

  Result := False;
  try
    HSvc := AdvApiProcs.OpenService(FHSCMan, PChar(FServiceName), SERVICE_ALL_ACCESS);

    if HSvc = 0 then
      raise Exception.Create('Can not access service: ' + FServiceName);

    Ret := Ord(AdvApiProcs.DeleteService(HSvc));

    case Ret of
      0: raise Exception.Create('Can not unregister service: ' + FServiceName);
      ERROR_ACCESS_DENIED:
        raise Exception.Create('Access Denied. Can not unregister service: ' + FServiceName);
      ERROR_INVALID_HANDLE:
        raise Exception.Create('Invalid Handle. Can not unregister service: ' + FServiceName);
      ERROR_SERVICE_MARKED_FOR_DELETE: ;
    end;

    AdvApiProcs.CloseServiceHandle(HSvc);

    Result := not GetInstalled;
  except
  end;

  ResetStatus;
end;

function TServiceUtility.Start: Boolean;
var
  HSvc: THandle;
  SS: TServiceStatus;
  PParams: PChar;
  i: Integer;
begin
  ResetStatus;
  if FStatus = ssRunning then
  begin
    Result := True;
    Exit;
  end;

  Result := False;

  HSvc := AdvApiProcs.OpenService(
      FHSCMan, PChar(ServiceName), SERVICE_ALL_ACCESS);
  if HSvc = 0 then
    raise Exception.Create('Can not access service: ' + ServiceName);

  try
    PParams := PChar('');
    if AdvApiProcs.StartService(HSvc, 0, PParams) then
    begin
      for i := 0 to 20 do
      begin
        SetControlState(HSvc, SERVICE_RUNNING, SS);
        Result := SS.dwCurrentState = SERVICE_RUNNING;
        if Result then
          Break;
        Sleep(1000);
      end;
    end;
  finally
    AdvApiProcs.CloseServiceHandle(HSvc);
  end;

  ResetStatus;
end;

function TServiceUtility.Stop: Boolean;
var
  HSvc: THandle;
  SS: TServiceStatus;
  i: Integer;
begin
  ResetStatus;
  if (FStatus = ssStopped) or (FStatus = ssPaused) then
  begin
    Result := True;
    Exit;
  end;

  Result := False;

  HSvc := AdvApiProcs.OpenService(
      FHSCMan, PChar(ServiceName), SERVICE_ALL_ACCESS);
  if HSvc = 0 then
    raise Exception.Create('Can not access service: ' + ServiceName);

  try
    if AdvApiProcs.ControlService(HSvc, SERVICE_CONTROL_STOP, SS) then
    begin
      for i := 0 to 20 do
      begin
        SetControlState(HSvc, SERVICE_STOPPED, SS);
        Result := SS.dwCurrentState = SERVICE_STOPPED;
        if Result then
          Break;
        Sleep(1000);
      end;
    end;
  finally
    AdvApiProcs.CloseServiceHandle(HSvc);
  end;

  ResetStatus;
end;

function TServiceUtility.GetActive: Boolean;
begin
  Result := FStatus = ssRunning;
end;

procedure TServiceUtility.SetActive(const Value: Boolean);
begin
  if Value then
    Start
  else
    Stop;
end;

function TServiceUtility.GetInstalled: Boolean;
begin
  Result := FStatus <> ssNotExists;
end;

procedure TServiceUtility.ResetStatus;
var
  HSvc: THandle;
  SS: TServiceStatus;
begin
  FStatus := ssNotExists;

  try
    HSvc := AdvApiProcs.OpenService(FHSCMan, PChar(FServiceName), SERVICE_ALL_ACCESS);

    if HSvc = 0 then
      Exit;

    if not AdvApiProcs.QueryServiceStatus(HSvc, SS) then
      Exit;

    AdvApiProcs.CloseServiceHandle(HSvc);

    case SS.dwCurrentState of
      SERVICE_STOPPED: FStatus := ssStopped;
      SERVICE_START_PENDING: FStatus := ssStartPending;
      SERVICE_STOP_PENDING: FStatus := ssStopPending;
      SERVICE_RUNNING: FStatus := ssRunning;
      SERVICE_CONTINUE_PENDING: FStatus := ssContinuePending;
      SERVICE_PAUSE_PENDING: FStatus := ssPausePending;
      SERVICE_PAUSED: FStatus := ssPaused;
    end;
  except
  end;
end;

{ TAdvApiProcs }

const
  AdvApi32FileName = 'advapi32.dll';

constructor TAdvApiProcs.Create;
begin
  FHAdvApi32 := LoadLibrary(AdvApi32FileName);

  if FHAdvApi32 = 0 then
    raise Exception.Create('Can not obtain Advapi32 handle');

  @OpenSCManager := GetProcAddress(FHAdvApi32, 'OpenSCManagerA');
  @LockServiceDatabase := GetProcAddress(FHAdvApi32, 'LockServiceDatabase');
  @UnlockServiceDatabase := GetProcAddress(FHAdvApi32, 'UnlockServiceDatabase');
  @CreateService := GetProcAddress(FHAdvApi32, 'CreateServiceA');
  @CloseServiceHandle := GetProcAddress(FHAdvApi32, 'CloseServiceHandle');
  @OpenService := GetProcAddress(FHAdvApi32, 'OpenServiceA');
  @ControlService := GetProcAddress(FHAdvApi32, 'ControlService');
  @QueryServiceStatus := GetProcAddress(FHAdvApi32, 'QueryServiceStatus');
  @DeleteService := GetProcAddress(FHAdvApi32, 'DeleteService');
  @StartService := GetProcAddress(FHAdvApi32, 'StartServiceA');
  @EnumServicesStatus := GetProcAddress(FHAdvApi32, 'EnumServicesStatusA');
  @QueryServiceConfig := GetProcAddress(FHAdvApi32, 'QueryServiceConfigA');

  if (@OpenSCManager = nil) or
      (@LockServiceDatabase = nil) or
      (@UnlockServiceDatabase = nil) or
      (@CreateService = nil) or
      (@CloseServiceHandle = nil) or
      (@OpenService = nil) or
      (@ControlService = nil) or
      (@QueryServiceStatus = nil) or
      (@DeleteService = nil) or
      (@StartService = nil) or
      (@EnumServicesStatus = nil) or
      (@QueryServiceConfig = nil) then
    raise Exception.Create('Can not obtain an Advapi32 function entry point');
end;

destructor TAdvApiProcs.Destroy;
begin
  if FHAdvApi32 <> 0 then
    FreeLibrary(FHAdvApi32);

  inherited;
end;

end.

