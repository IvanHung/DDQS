unit IPCUtils;

interface

uses
  Windows, SysUtils, Classes;

type
{ THandledObject }

  THandledObject = class(TObject)
  protected
    FHandle: THandle;
  public
    destructor Destroy; override;
    property Handle: THandle read FHandle;
  end;

{ TEvent }

  TEvent = class(THandledObject)
  public
    constructor Create(const Name: string; Manual: Boolean);
    procedure Signal;
    procedure Reset;
    function Wait(TimeOut: Integer = -1): Boolean;
  end;

{ TMutex }

  TMutex = class(THandledObject)
  public
    constructor Create(const Name: string);
    function Get(TimeOut: Integer = -1): Boolean;
    function Release: Boolean;
  end;

{ TSharedMem }

  TSharedMem = class(THandledObject)
  private
    FName: string;
    FSize: Integer;
    FCreated: Boolean;
    FFileView: Pointer;
  public
    constructor Create(const Name: string; Size: Integer);
    destructor Destroy; override;
    property Name: string read FName;
    property Size: Integer read FSize;
    property Buffer: Pointer read FFileView;
    property Created: Boolean read FCreated;
  end;

  TSharedQueue = class;

{ TSharedQueueEventListener }

  TSharedQueueEventListener = class(TThread)
  protected
    FName: string;
    FSender: TObject; 
    FListenEvent: TEvent;
    FExecEvent: TNotifyEvent;
    procedure DoExecEvent;
    procedure Execute; override;
  public
    constructor Create(aName: string; aSender: TObject; aExecEvent: TNotifyEvent);
  end;

{ TSharedQueue }

  TSharedQueue = class(TObject)
  private
    FSharedMem: TSharedMem;
    FMutex: TMutex;
    FIDMutex: TMutex;
    FName: string;
    FOnPop: TNotifyEvent;
    FPopEventListener: TSharedQueueEventListener;
    FOnPush: TNotifyEvent;
    FPushEventListener: TSharedQueueEventListener;
    FPushEvent: TEvent;
    FPopEvent: TEvent;
    FIsGirl: Boolean;
    function GetItemCount: Integer;
    function GetItemSize: Integer;
    procedure SetOnPop(const Value: TNotifyEvent);
    procedure SetOnPush(const Value: TNotifyEvent);
  public
    constructor Create(const Name: string; aItemSize: Integer;
        aItemCount: Integer = 1024);
    destructor Destroy; override;
    function PopItem(ItemData: PChar): Boolean;
    procedure PushItem(ItemData: PChar);
    function PopText: string;
    procedure PushText(Text: string);
    procedure Reset;
    property Name: string read FName;
    property ItemSize: Integer read GetItemSize;
    property ItemCount: Integer read GetItemCount;
    property IsGirl: Boolean read FIsGirl;
    property OnPush: TNotifyEvent read FOnPush write SetOnPush;
    property OnPop: TNotifyEvent read FOnPop write SetOnPop;
  end;

implementation

const
  IPCUtilsHeader = 'IPCUTIL_';

{ THandledObject }

destructor THandledObject.Destroy;
begin
  if FHandle <> 0 then
    CloseHandle(FHandle);
end;

{ TEvent }

constructor TEvent.Create(const Name: string; Manual: Boolean);
begin
  FHandle := CreateEvent(nil, Manual, False, PChar(Name));
  if FHandle = 0 then abort;
end;

procedure TEvent.Reset;
begin
  ResetEvent(FHandle);
end;

procedure TEvent.Signal;
begin
  SetEvent(FHandle);
end;

function TEvent.Wait(TimeOut: Integer = -1): Boolean;
begin
  Result := WaitForSingleObject(FHandle, TimeOut) = WAIT_OBJECT_0;
end;

{ TMutex }

constructor TMutex.Create(const Name: string);
begin
  FHandle := CreateMutex(nil, False, PChar(Name));
  if FHandle = 0 then abort;
end;

function TMutex.Get(TimeOut: Integer = -1): Boolean;
begin
  Result := WaitForSingleObject(FHandle, TimeOut) = WAIT_OBJECT_0;
end;

function TMutex.Release: Boolean;
begin
  Result := ReleaseMutex(FHandle);
end;

{ TSharedMem }

constructor TSharedMem.Create(const Name: string; Size: Integer);
begin
  try
    FName := Name;
    FSize := Size;

    FHandle := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
        Size, PChar(Name));
    if FHandle = 0 then Abort;

    FCreated := GetLastError = 0;

    FFileView := MapViewOfFile(FHandle, FILE_MAP_WRITE, 0, 0, Size);
    
    if FFileView = nil then Abort;
  except
    raise Exception.Create(Format('Error creating shared memory %s (%d)', [Name, GetLastError]));
  end;
end;

destructor TSharedMem.Destroy;
begin
  if FFileView <> nil then
    UnmapViewOfFile(FFileView);
  inherited Destroy;
end;

{ TSharedQueue }

type
  PSharedQueueMemory = ^TSharedQueueMemory;
  TSharedQueueMemory = record
    ItemSize: Integer;
    ItemCount: Integer;
    ReadIndex: Integer;
    WriteIndex: Integer;
    ItemStart: Byte;
  end;

constructor TSharedQueue.Create(const Name: string; aItemSize: Integer;
  aItemCount: Integer);
begin
  if aItemSize = 0 then
    raise Exception.Create('ItemSize too small.');

  FIDMutex := TMutex.Create(IPCUtilsHeader + FName + '_MUTEX_GIRL');
  if FIDMutex.Get(0) then
    FIsGirl := True
  else
  begin
    FIDMutex.Free;

    FIDMutex := TMutex.Create(IPCUtilsHeader + FName + '_MUTEX_BOY');
    if FIDMutex.Get(0) then
      FIsGirl := False
    else
    begin
      FIDMutex.Free;
      raise Exception.Create('ShareQueue "' + Name + '" is full up.');
    end;
  end;

  FName := Name;

  FMutex := TMutex.Create(IPCUtilsHeader + FName + '_MUTEX');

  FMutex.Get;
  try
    try
      FSharedMem := TSharedMem.Create(IPCUtilsHeader + FName + '_SMEM', sizeof(Integer)*4 + aItemCount * aItemSize);

      if PSharedQueueMemory(FSharedMem.Buffer)^.ItemSize > 0 then
        if PSharedQueueMemory(FSharedMem.Buffer)^.ItemSize <> aItemSize then
          raise Exception.Create('ItemSize not equals previous setting.');

      if PSharedQueueMemory(FSharedMem.Buffer)^.ItemCount > aItemCount then
      begin
        aItemCount := PSharedQueueMemory(FSharedMem.Buffer)^.ItemCount;
        FSharedMem.Free;
        FSharedMem := TSharedMem.Create(IPCUtilsHeader + FName + '_SMEM', sizeof(Integer)*4 + aItemCount * aItemSize);
      end;

      PSharedQueueMemory(FSharedMem.Buffer)^.ItemSize := aItemSize;
      PSharedQueueMemory(FSharedMem.Buffer)^.ItemCount := aItemCount;
    except
      FSharedMem.Free;
      raise;
    end;
  finally
    FMutex.Release;
  end;

  if FIsGirl then
  begin
    FPushEvent := TEvent.Create(IPCUtilsHeader + FName + '_EVN_PUSH_BOY', False);
    FPopEvent := TEvent.Create(IPCUtilsHeader + FName + '_EVN_POP_BOY', False);
  end
  else
  begin
    FPushEvent := TEvent.Create(IPCUtilsHeader + FName + '_EVN_PUSH_GIRL', False);
    FPopEvent := TEvent.Create(IPCUtilsHeader + FName + '_EVN_POP_GIRL', False);
  end;
end;

destructor TSharedQueue.Destroy;
begin
  try
    FPopEvent.Free;
    FPushEvent.Free;

    if FPushEventListener <> nil then
    begin
      FPushEventListener.Terminate;
      FPushEventListener := nil;
    end;

    if FPopEventListener <> nil then
    begin
      FPopEventListener.Terminate;
      FPopEventListener := nil;
    end;

    FSharedMem.Free;
    FMutex.Free;
  finally
    FIDMutex.Release;
    FIDMutex.Free;
  end;

  inherited;
end;

function TSharedQueue.GetItemCount: Integer;
begin
  FMutex.Get;
  try
    Result := PSharedQueueMemory(FSharedMem.Buffer)^.ItemCount;
  finally
    FMutex.Release;
  end;
end;

function TSharedQueue.GetItemSize: Integer;
begin
  FMutex.Get;
  try
    Result := PSharedQueueMemory(FSharedMem.Buffer)^.ItemSize;
  finally
    FMutex.Release;
  end;
end;

function TSharedQueue.PopItem(ItemData: PChar): Boolean;
var
  SrcMem: PChar;
begin
  FMutex.Get;
  try
    with PSharedQueueMemory(FSharedMem.Buffer)^ do
    begin
      if ReadIndex = WriteIndex then
        Result := False
      else
      begin
        SrcMem := PChar(@ItemStart);
        SrcMem := SrcMem + ReadIndex * ItemSize;
        Move(SrcMem^, ItemData^, ItemSize);

        Inc(ReadIndex);
        if ReadIndex >= ItemCount then
          ReadIndex := 0;
        Result := True;
      end;
    end;
  finally
    FMutex.Release;
  end;
  FPopEvent.Signal;
end;

function TSharedQueue.PopText: string;
var
  Ret: PChar;
begin
  Result := '';
  Ret := StrAlloc(ItemSize);
  try
    if PopItem(Ret) then
      Result := Ret;
  finally
    StrDispose(Ret);
  end;
end;

procedure TSharedQueue.PushItem(ItemData: PChar);
var
  SrcMem: PChar;
begin
  FMutex.Get;
  try
    with PSharedQueueMemory(FSharedMem.Buffer)^ do
    begin
      SrcMem := PChar(@ItemStart);
      SrcMem := SrcMem + WriteIndex * ItemSize;
      Move(ItemData^, SrcMem^, ItemSize);

      Inc(WriteIndex);
      if WriteIndex >= ItemCount then
        WriteIndex := 0;
    end;
  finally
    FMutex.Release;
  end;
  FPushEvent.Signal;
end;

procedure TSharedQueue.PushText(Text: string);
var
  PText: PChar;
begin
  PText := AllocMem(ItemSize);
  try
    StrCopy(PText, PChar(Text));
    PushItem(PText);
  finally
    FreeMem(PText);
  end;
end;

procedure TSharedQueue.Reset;
begin
  FMutex.Get;
  try
    with PSharedQueueMemory(FSharedMem.Buffer)^ do
      ReadIndex := WriteIndex;
  finally
    FMutex.Release;
  end;
end;

procedure TSharedQueue.SetOnPop(const Value: TNotifyEvent);
begin
  FOnPop := Value;

  if FPopEventListener <> nil then
  begin
    FPopEventListener.Terminate;
    FPopEventListener := nil;
  end;
  if Assigned(FOnPop) then
  begin
    if FIsGirl then
      FPopEventListener := TSharedQueueEventListener.Create(IPCUtilsHeader + FName + '_EVN_POP_GIRL', Self, FOnPop)
    else
      FPopEventListener := TSharedQueueEventListener.Create(IPCUtilsHeader + FName + '_EVN_POP_BOY', Self, FOnPop);
  end;
end;

procedure TSharedQueue.SetOnPush(const Value: TNotifyEvent);
begin
  FOnPush := Value;

  if FPushEventListener <> nil then
  begin
    FPushEventListener.Terminate;
    FPushEventListener := nil;
  end;
  if Assigned(FOnPush) then
  begin
    if FIsGirl then
      FPushEventListener := TSharedQueueEventListener.Create(IPCUtilsHeader + FName + '_EVN_PUSH_GIRL', Self, FOnPush)
    else
      FPushEventListener := TSharedQueueEventListener.Create(IPCUtilsHeader + FName + '_EVN_PUSH_BOY', Self, FOnPush);
  end;
end;

{ TSharedQueueEventListener }

constructor TSharedQueueEventListener.Create(aName: string; aSender: TObject; aExecEvent: TNotifyEvent);
begin
  FreeOnTerminate := True;
  FName := aName;
  FSender := aSender;
  FExecEvent := aExecEvent;

  inherited Create(False);
end;

procedure TSharedQueueEventListener.DoExecEvent;
begin
  try
    FExecEvent(FSender);
  except
  end;
end;

procedure TSharedQueueEventListener.Execute;
begin
  FListenEvent := TEvent.Create(FName, False);
  try
    while not Terminated do
      if FListenEvent.Wait(500) then
        Synchronize(DoExecEvent);
  finally
    FListenEvent.Free;
  end;
end;

end.
