object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Main Form'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TrayIcon1: TTrayIcon
    Animate = True
    Hint = 'Screen text finder'
    BalloonHint = 'Screen Text Finder will remain active in system tray.'
    BalloonTitle = 'Screen Text Finder'
    BalloonFlags = bfInfo
    PopupMenu = trayPopupMenu
    Visible = True
    Left = 104
    Top = 136
  end
  object trayPopupMenu: TPopupMenu
    Left = 208
    Top = 128
    object Movecursor1: TMenuItem
      Caption = 'Move cursor'
      Hint = 'Move mouse cursor to the first occurrence of the search string'
      OnClick = Movecursor1Click
    end
    object Highlight1: TMenuItem
      Caption = 'Highlight'
      Checked = True
      OnClick = Highlight1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object About1: TMenuItem
      Caption = 'About'
      OnClick = About1Click
    end
    object Help1: TMenuItem
      Caption = 'Help'
      OnClick = Help1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Close1: TMenuItem
      Caption = 'Close'
      OnClick = Close1Click
    end
  end
  object keyScanTimer: TTimer
    Interval = 50
    OnTimer = keyScanTimerTimer
    Left = 352
    Top = 80
  end
  object formTopperTimer: TTimer
    Interval = 100
    OnTimer = formTopperTimerTimer
    Left = 224
    Top = 48
  end
end
