program WordFileConvertSrv;

uses
  SvcMgr,
  WordFileConvertSrvMain in 'WordFileConvertSrvMain.pas' {WordConvertService: TService},
  MSWordFileConvert in 'MSWordFileConvert.pas',
  LogFunc in 'LogFunc.pas',
  ParamUtil in 'ParamUtil.pas',
  IPCUtils in 'IPCUtils.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TWordConvertService, WordConvertService);
  Application.Run;
end.
