unit WordFileConvertSrvMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  ShellCtrls, ExtCtrls;

type
  TWordConvertService = class(TService)
    tmFirstProcess: TTimer;
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure tmFirstProcessTimer(Sender: TObject);
  private
    scmTransDirMon: TShellChangeNotifier;
    procedure scmTransDirMonChange;
  public
    InputPath: string;
    InputFileExt: string;
    OutputPath: string;
    OutputFileExt: string;
    OutputFileFormat: string;
    DeleteInputFile: Boolean;
    DebugMode: Boolean;
    function GetServiceController: TServiceController; override;
  end;

var
  WordConvertService: TWordConvertService;

implementation

{$R *.DFM}

uses
  MSWordFileConvert, LogFunc, ParamUtil, IPCUtils;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  WordConvertService.Controller(CtrlCode);
end;

function TWordConvertService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TWordConvertService.scmTransDirMonChange;
var
  SR: TSearchRec;
  FileList: TStringList;
  i: Integer;
  AllSuccess: Boolean;
  MonLock: TMutex;
  procedure BuildFileList(FilterPathFile: string);
  begin
    if FindFirst(FilterPathFile, faAnyFile, SR) = 0 then
    begin
      repeat
        if SR.Attr and faDirectory = 0 then
          FileList.Add(SR.Name);
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  end;
begin
  MonLock := TMutex.Create('WordFileConvertMonLock');

  try
    if MonLock.Get then
      try
        FileList := TStringList.Create;
        try
          repeat
            AllSuccess := True;

            FileList.Clear;

            if (InputFileExt = '.htm') or (InputFileExt = '.html') then
            begin
              BuildFileList(InputPath + '*.htm');
              BuildFileList(InputPath + '*.html');
            end
            else if (InputFileExt = '.txt') or (InputFileExt = '.text') then
            begin
              BuildFileList(InputPath + '*.txt');
              BuildFileList(InputPath + '*.text');
            end
            else
              BuildFileList(InputPath + '*' + InputFileExt);

            for i := 0 to FileList.Count-1 do
            begin
              try
                if not FileExists(OutputPath + FileList[i] + OutputFileExt) and
                    FileExists(InputPath + FileList[i]) then
                begin
                  WordFileConvert(
                      InputPath + FileList[i],
                      OutputPath + FileList[i] + OutputFileExt,
                      FileExtToFileFormat(OutputFileExt, OutputFileFormat));
                  AllSuccess := False;
                end;

                if DeleteInputFile then
                  DeleteFile(InputPath + FileList[i]);
              except
                on E: Exception do
                  AppendErr('轉檔作業失敗. 從 "' + InputPath + FileList[i] + '" 轉換至 "' +
                      OutputPath + FileList[i] + OutputFileExt + '" 時發生錯誤, 原因: ' + E.Message);
              end;
            end;
          
            if not AllSuccess then
              Sleep(500);
          until AllSuccess;
        finally
          FileList.Free;
        end;
      finally
        MonLock.Release;
      end;
  finally
    MonLock.Free;
  end;
end;

procedure TWordConvertService.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
  try
    Started := False;

    ParamAccess.ApplicationID := 'WordConvertService';

    InputPath := ParamAccess.Value['INPUT', 'PATH'];
    InputFileExt := ParamAccess.Value['INPUT', 'FILE_EXT'];
    OutputPath := ParamAccess.Value['OUTPUT', 'PATH'];
    OutputFileExt := ParamAccess.Value['OUTPUT', 'FILE_EXT'];
    OutputFileFormat := ParamAccess.Value['OUTPUT', 'FILE_FORMAT'];
    DeleteInputFile := ParamAccess.ValueAsBool['OPTIONS', 'DELETE_INPUT_FILE'];
    DebugMode := ParamAccess.ValueAsBool['OPTIONS', 'DEBUG_MODE'];

    if (InputFileExt <> '') and (InputFileExt[1] = '.') then
      Delete(InputFileExt, 1, 1);

    if (OutputFileExt <> '') and (OutputFileExt[1] = '.') then
      Delete(OutputFileExt, 1, 1);

    if (InputPath <> '') and (InputPath[Length(InputPath)] <> '\') then
      InputPath := InputPath + '\';

    if (OutputPath <> '') and (OutputPath[Length(OutputPath)] <> '\') then
      OutputPath := OutputPath + '\';

    if (InputFileExt <> '') and (InputFileExt[1] <> '.') then
      InputFileExt := '.' + InputFileExt;

    if (OutputFileExt <> '') and (OutputFileExt[1] <> '.') then
      OutputFileExt := '.' + OutputFileExt;

    if not DirectoryExists(InputPath) then
    begin
      AppendErr('輸入目錄不存在.');
      Exit;
    end;

    if not DirectoryExists(OutputPath) then
    begin
      AppendErr('輸出目錄不存在.');
      Exit;
    end;

    scmTransDirMon := TShellChangeNotifier.Create(Self);
    scmTransDirMon.Root := InputPath;
    scmTransDirMon.OnChange := scmTransDirMonChange;

    tmFirstProcess.Enabled := True;
    Started := True;
  except
    on E: Exception do
      AppendErr('啟動服務器失敗. ' + E.ClassName + ':' + E.Message);
  end;
end;

procedure TWordConvertService.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
  scmTransDirMon.Free;

  Stopped := True;
end;

procedure TWordConvertService.tmFirstProcessTimer(Sender: TObject);
begin
  scmTransDirMonChange;
  tmFirstProcess.Enabled := False;
end;

end.
