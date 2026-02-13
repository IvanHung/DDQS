object frmSelectDir: TfrmSelectDir
  Left = 192
  Top = 133
  Width = 365
  Height = 273
  Caption = #30446#37636#36984#25799
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #26032#32048#26126#39636
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    357
    246)
  PixelsPerInch = 96
  TextHeight = 12
  object stvMain: TShellTreeView
    Left = 0
    Top = 0
    Width = 357
    Height = 207
    ObjectTypes = [otFolders]
    Root = 'rfDesktop'
    UseShellImages = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    TabOrder = 0
  end
  object btnOK: TBitBtn
    Left = 124
    Top = 214
    Width = 136
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = #30906#23450
    TabOrder = 1
    Kind = bkOK
  end
  object btnCancel: TBitBtn
    Left = 273
    Top = 214
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    TabOrder = 2
    Kind = bkCancel
  end
end
