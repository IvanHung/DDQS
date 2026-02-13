unit LogFunc;
// Log工具

interface

  // 加入系統紀錄
  procedure AppendLog(Log: string); overload;
  procedure AppendLog(Log: string; var BinaryData; Count: Integer); overload;

  // 加入系統Rec紀錄
  procedure AppendRec(Log: string); overload;
  procedure AppendRec(Log: string; var BinaryData; Count: Integer); overload;

  // 加入系統Err紀錄
  procedure AppendErr(Log: string); overload;
  procedure AppendErr(Log: string; var BinaryData; Count: Integer); overload;

  // 重整系統紀錄
  procedure ResetLog;

{$IFDEF USEFORM}
  // 清除LOG作業紀錄畫面
  procedure RenewLogForm;

  // 顯示LOG作業紀錄畫面
  procedure ShowLogForm;

  // 隱藏LOG作業紀錄畫面
  procedure HideLogForm;
{$ENDIF}

var
  // 啟用LOG機制
  LOG_Enabled: Boolean = True;
  // 顯示LOG作業紀錄畫面
  LOG_ShowForm: Boolean = False;
  // LOG檔案名稱
  LOG_FileName: string = 'Active.log';
  // Rec紀錄標記
  LOG_RecTag: string = 'REC>';
  // Err紀錄標記
  LOG_ErrTag: string = 'ERR>';

implementation

uses
  SysUtils, Classes, {$IFDEF USEFORM}LogForm, {$ENDIF}Forms;

const
  MaxLogCount = 3000;

{$IFDEF USEFORM}
var
  StaticLogForm: TfrmLog = nil;
{$ENDIF}

// 加入系統Rec紀錄
procedure AppendRec(Log: string);
begin
  AppendLog(LOG_RecTag + ' ' + Log);
end;

procedure AppendRec(Log: string; var BinaryData; Count: Integer);
begin
  AppendLog(LOG_RecTag + ' ' + Log, BinaryData, Count);
end;

// 加入系統Err紀錄
procedure AppendErr(Log: string);
begin
  AppendLog(LOG_ErrTag + ' ' + Log);
end;

procedure AppendErr(Log: string; var BinaryData; Count: Integer);
begin
  AppendLog(LOG_ErrTag + ' ' + Log, BinaryData, Count);
end;

// 加入系統紀錄
procedure AppendLog(Log: string; var BinaryData; Count: Integer);
var
  TF: TextFile;
  LogPathFileName: string;
  i: Integer;
  LogLine: string;
begin
  if not LOG_Enabled then
    Exit;

  LogLine := Trim(Log);

  LogLine := FormatDateTime('[yyyymmdd-hhnnss ', Now) +
          ExtractFileName(ParamStr(0)) + '] ' + LogLine;
  LogLine := LogLine + #13#10 +
          '[Binary Data] Length=' + IntToStr(Count);
  LogLine := LogLine + #13#10 +
          '[Binary Data Begin]';

  for i := 0 to Count-1 do
    LogLine := LogLine + Char(PChar(@BinaryData) + i);

  LogLine := LogLine + #13#10 +
          '[Binary Data End]';

  LogLine := StringReplace(LogLine, #13#10, #13#10 +
      FormatDateTime('[yyyymmdd-hhnnss ', Now) +
      ExtractFileName(ParamStr(0)) + '] ', [rfReplaceAll]);

  for i := 1 to Length(LogLine) do
    if (LogLine[i] < #32) and
      not ((i > 1) and (LogLine[i-1] = #13) and (LogLine[i] = #10)) and
      not ((i < Length(LogLine)) and (LogLine[i] = #13) and (LogLine[i+1] = #10)) then
      LogLine[i] := ' ';

  try
    try
      if ExtractFilePath(LOG_FileName) = '' then
        LogPathFileName := ExtractFilePath(ParamStr(0)) + LOG_FileName
      else
        LogPathFileName := LOG_FileName;

      AssignFile(TF, LogPathFileName);
      try
        try
          if FileExists(LogPathFileName) then
            Append(TF)
          else
            ReWrite(TF);
          WriteLn(TF, LogLine);
        except
        end;
      finally
        CloseFile(TF);
      end;
    except
    end;
  finally
{$IFDEF USEFORM}
    if LOG_ShowForm then
    begin
      ShowLogForm;
      StaticLogForm.reLog.Lines.Add(LogLine);
      StaticLogForm.Update;
      if StaticLogForm.Abort then
        Abort;
    end
    else
      HideLogForm;
{$ENDIF}
  end;
end;

// 加入系統紀錄
procedure AppendLog(Log: string);
var
  TF: TextFile;
  LogPathFileName: string;
  i: Integer;
  LogLine: string;
begin
  if not LOG_Enabled then
    Exit;

  LogLine := Trim(Log);

  LogLine := FormatDateTime('[yyyymmdd-hhnnss ', Now) +
          ExtractFileName(ParamStr(0)) + '] ' + LogLine;
          
  LogLine := StringReplace(LogLine, #13#10, #13#10 +
      FormatDateTime('[yyyymmdd-hhnnss ', Now) +
      ExtractFileName(ParamStr(0)) + '] ', [rfReplaceAll]);

  for i := 1 to Length(LogLine) do
    if (LogLine[i] < #32) and
      not ((i > 1) and (LogLine[i-1] = #13) and (LogLine[i] = #10)) and
      not ((i < Length(LogLine)) and (LogLine[i] = #13) and (LogLine[i+1] = #10)) then
      LogLine[i] := ' ';

  try
    try
      if ExtractFilePath(LOG_FileName) = '' then
        LogPathFileName := ExtractFilePath(ParamStr(0)) + LOG_FileName
      else
        LogPathFileName := LOG_FileName;

      AssignFile(TF, LogPathFileName);
      try
        try
          if FileExists(LogPathFileName) then
            Append(TF)
          else
            ReWrite(TF);
          WriteLn(TF, LogLine);
        except
        end;
      finally
        CloseFile(TF);
      end;
    except
    end;
  finally
{$IFDEF USEFORM}
    if LOG_ShowForm then
    begin
      ShowLogForm;
      StaticLogForm.reLog.Lines.Add(LogLine);
      StaticLogForm.Update;
      if StaticLogForm.Abort then
        Abort;
    end
    else
      HideLogForm;
{$ENDIF}
  end;
end;

// 重整系統紀錄
procedure ResetLog;
var
  TmpLog: TStringList;
  LogPathFileName: string;
  i: Integer;
begin
  if not LOG_Enabled then
    Exit;

  AppendLog('<LOG_SYSTEM>重新整理紀錄, 使紀錄只保留最後' + IntToStr(MaxLogCount) + '筆.');

  if ExtractFilePath(LOG_FileName) = '' then
    LogPathFileName := ExtractFilePath(ParamStr(0)) + LOG_FileName
  else
    LogPathFileName := LOG_FileName;

  if FileExists(LogPathFileName) then
  begin
    TmpLog := TStringList.Create;
    try
      TmpLog.LoadFromFile(LogPathFileName);
      for i := TmpLog.Count - 1 downto MaxLogCount do
        TmpLog.Delete(0);
      TmpLog.SaveToFile(LogPathFileName);
    finally
      TmpLog.Free;
    end;
  end;
end;

{$IFDEF USEFORM}
// 顯示LOG作業紀錄畫面
procedure ShowLogForm;
begin
  if StaticLogForm = nil then
    StaticLogForm := TfrmLog.Create(Application);
  if not StaticLogForm.Showing then
    StaticLogForm.Show;
end;

// 清除LOG作業紀錄畫面
procedure RenewLogForm;
begin
  if StaticLogForm <> nil then
  begin
    try
      StaticLogForm.reLog.Clear;
    except
    end;
  end;
end;

// 隱藏LOG作業紀錄畫面
procedure HideLogForm;
begin
  if StaticLogForm <> nil then
    StaticLogForm.Hide;
end;
{$ENDIF}

initialization
  AppendLog('<LOG_SYSTEM>程式啟動[' + ParamStr(0) + ']');
  ResetLog;

finalization
  AppendLog('<LOG_SYSTEM>程式結束[' + ParamStr(0) + ']');

end.
