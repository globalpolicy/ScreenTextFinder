object frmSearch: TfrmSearch
  Left = 57
  Top = 44
  AlphaBlend = True
  AlphaBlendValue = 150
  BorderStyle = bsDialog
  Caption = 'Search'
  ClientHeight = 38
  ClientWidth = 225
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  OnHide = FormHide
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object txtSearchString: TEdit
    Left = 8
    Top = 8
    Width = 209
    Height = 21
    Hint = 'Enter your search string'
    ParentCustomHint = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TextHint = 'Enter your search string'
    OnKeyPress = txtSearchStringKeyPress
  end
end
