object SymView: TSymView
  Left = 342
  Top = 116
  Width = 567
  Height = 421
  Caption = 'Symbol Viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 161
    Top = 33
    Height = 354
  end
  object lbSyms: TListBox
    Left = 0
    Top = 33
    Width = 161
    Height = 354
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbSymsClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 559
    Height = 33
    Align = alTop
    TabOrder = 1
    object swSorted: TCheckBox
      Left = 8
      Top = 8
      Width = 57
      Height = 17
      Caption = 'sorted'
      TabOrder = 0
      OnClick = swSortedClick
    end
    object buTestMacro: TButton
      Left = 88
      Top = 4
      Width = 73
      Height = 21
      Caption = 'TestMacro'
      TabOrder = 1
      OnClick = buTestMacroClick
    end
  end
  object edDef: TMemo
    Left = 164
    Top = 33
    Width = 395
    Height = 354
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
end
