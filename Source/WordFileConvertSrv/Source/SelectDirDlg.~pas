unit SelectDirDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ShellCtrls;

type
  TfrmSelectDir = class(TForm)
    stvMain: TShellTreeView;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
  private
  public
  end;

function SelectDir(DefaultDir: string): string;

implementation

{$R *.dfm}

function SelectDir(DefaultDir: string): string;
var
  frmSelectDir: TfrmSelectDir;
begin
  frmSelectDir := TfrmSelectDir.Create(Application);
  try
    with frmSelectDir do
    begin
      if DirectoryExists(DefaultDir) then
        stvMain.Path := DefaultDir;
      if ShowModal = mrOK then
        Result := stvMain.Path
      else
        Result := DefaultDir;
    end;
  finally
    frmSelectDir.Free;
  end;
end;

end.

