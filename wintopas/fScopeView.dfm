object ScopeView: TScopeView
  Left = 342
  Top = 116
  Width = 578
  Height = 465
  Caption = 'Scope Viewer'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 161
    Top = 33
    Height = 398
  end
  object lbSyms: TListBox
    Left = 0
    Top = 33
    Width = 161
    Height = 398
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
    OnClick = lbSymsClick
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 570
    Height = 33
    Align = alTop
    TabOrder = 1
    DesignSize = (
      570
      33)
    object swSorted: TCheckBox
      Left = 8
      Top = 8
      Width = 57
      Height = 17
      Caption = 'sorted'
      TabOrder = 0
      OnClick = swSortedClick
    end
    object lbScopes: TTabControl
      Left = 192
      Top = 4
      Width = 370
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      OnChange = lbScopesChange
    end
    object buTranslate: TButton
      Left = 64
      Top = 8
      Width = 73
      Height = 17
      Caption = 'Translate'
      TabOrder = 2
      OnClick = buTranslateClick
    end
    object buUnit: TButton
      Left = 144
      Top = 8
      Width = 41
      Height = 17
      Caption = 'Unit'
      TabOrder = 3
      OnClick = buUnitClick
    end
  end
  object edDef: TMemo
    Left = 164
    Top = 33
    Width = 406
    Height = 398
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
  end
end
