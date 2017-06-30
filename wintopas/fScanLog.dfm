object ScanLog: TScanLog
  Left = 134
  Top = 97
  Caption = 'ToPas'
  ClientHeight = 476
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 249
    Width = 478
    Height = 4
    Cursor = crVSplit
    Align = alTop
    ResizeStyle = rsUpdate
    ExplicitWidth = 486
  end
  object lbMsg: TListBox
    Left = 0
    Top = 29
    Width = 478
    Height = 220
    Align = alTop
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbMsgClick
  end
  object lbSrc: TListBox
    Left = 0
    Top = 253
    Width = 478
    Height = 200
    Style = lbVirtualOwnerDraw
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Pitch = fpFixed
    Font.Style = []
    IntegralHeight = True
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
    OnMouseUp = LinkPush
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 457
    Width = 478
    Height = 19
    Panels = <
      item
        Text = '00000'
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 478
    Height = 29
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 3
    DesignSize = (
      478
      29)
    object Label1: TLabel
      Left = 9
      Top = 8
      Width = 16
      Height = 13
      Caption = 'File'
    end
    object edFile: TEdit
      Left = 32
      Top = 4
      Width = 413
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'wintest.c'
    end
    object udLinks: TUpDown
      Left = 452
      Top = 8
      Width = 25
      Height = 16
      Anchors = [akTop, akRight]
      Orientation = udHorizontal
      TabOrder = 1
      OnClick = udLinksClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 216
    Top = 124
    object File1: TMenuItem
      Caption = '&File'
      object mnuFileSel: TMenuItem
        Caption = '&Select'
        OnClick = mnuFileSelClick
      end
      object Preprocess1: TMenuItem
        Caption = 'Pr&eprocess'
        object mnuPrepTrad: TMenuItem
          Caption = '&traditional'
          OnClick = Preprocess1Click
        end
        object mnuPrepLock: TMenuItem
          Caption = '&locklevel'
          OnClick = mnuPrepLockClick
        end
      end
      object mnuParse: TMenuItem
        Caption = '&Parse'
        OnClick = mnuWinTestClick
      end
      object LoadTest1: TMenuItem
        Caption = 'Convert &Types'
        OnClick = LoadTest1Click
      end
      object mnuSaveMetadata: TMenuItem
        Caption = 'Save &Metadata'
        OnClick = mnuSaveMetadataClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Stop1: TMenuItem
        Caption = 'St&op'
        OnClick = Stop1Click
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
        OnClick = Exit1Click
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      object Config1: TMenuItem
        Caption = '&Config'
        OnClick = Config1Click
      end
      object N2: TMenuItem
        Caption = '&Macros'
        OnClick = N2Click
      end
      object Scopes1: TMenuItem
        Caption = '&Scopes'
        OnClick = Scopes1Click
      end
      object mnuViewSymbols: TMenuItem
        Caption = 'S&ymbols'
        OnClick = mnuViewSymbolsClick
      end
      object mnuViewTypes: TMenuItem
        Caption = '&Types'
        OnClick = mnuViewTypesClick
      end
    end
    object Test1: TMenuItem
      Caption = '&Test'
      object mnuTestScan: TMenuItem
        Caption = '&Scanner'
        OnClick = mnuTestScanClick
      end
      object mnuTestParse: TMenuItem
        Caption = '&Parser'
        OnClick = mnuParseClick
      end
    end
  end
  object dlgOpen: TOpenDialog
    Filter = 'C files (*.c, *.h)|*.c;*.h|All files (*.*)|*.*'
    Options = [ofReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 104
    Top = 124
  end
end
