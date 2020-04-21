unit mainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, screenshotter, PNGImage, customTypes,
  textRecognizer, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Menus,
  OptionHelper, searchForm, Miscellaneous, progressForm;

type
  TfrmMain = class(TForm)
    TrayIcon1: TTrayIcon;
    trayPopupMenu: TPopupMenu;
    Close1: TMenuItem;
    Movecursor1: TMenuItem;
    Highlight1: TMenuItem;
    N2: TMenuItem;
    keyScanTimer: TTimer;
    About1: TMenuItem;
    N1: TMenuItem;
    Help1: TMenuItem;
    formTopperTimer: TTimer;

    procedure Close1Click(Sender: TObject);
    procedure Highlight1Click(Sender: TObject);
    procedure Movecursor1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadSettings();
    procedure keyScanTimerTimer(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure formTopperTimerTimer(Sender: TObject);
  private
    procedure OnRecognizeBegin();
    procedure OnRecognizeProgress(Progress: Integer; var Cancel: Boolean);
    procedure OnRecognizeEnd(Output: TWordInformationArray; Canceled: Boolean);
    procedure Recognize();

  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
  recognizer: TTextRecognizer;
  recognizedOutput: TWordInformationArray;
  OptionHelper: TOptionHelper;
  recognizerBusy: Boolean;

implementation

{$R *.dfm}

procedure TfrmMain.About1Click(Sender: TObject);
begin
  MessageBox(self.Handle, PWideChar('Author : globalpolicy' + #13 +
    'Blog : c0dew0rth.blogspot.com' + #13 +
    'Icon : https://www.flaticon.com/authors/freepik'),
    PWideChar('About'), MB_OK);
end;

procedure TfrmMain.Close1Click(Sender: TObject);
begin
  Application.Terminate();
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if IsFirstRun() then
  begin
    ShowMessage('The application runs minimized.' + #13 +
      ' Heading to the system tray.');
  end;
  OptionHelper := TOptionHelper.Create(SAVE_FILE_NAME);
  LoadSettings();
end;

procedure TfrmMain.formTopperTimerTimer(Sender: TObject);
// see COMMENT 2
begin
  // frmProgress and frmSearch may not have been created by the VCL yet so check if assigned first
  if Assigned(frmProgress) and frmProgress.Visible then
  begin
    ActivateWindow(frmProgress.Handle);
    SetWindowTop(frmProgress.Handle);
  end;

  if Assigned(frmSearch) and frmSearch.Visible then
  begin
    ActivateWindow(frmSearch.Handle);
    SetWindowTop(frmSearch.Handle);
  end;

end;

procedure TfrmMain.Help1Click(Sender: TObject);
begin
  MessageBox(self.Handle,
    PWideChar('Execute the program. It will put itself into the system tray.' +
    #13 + 'Whenever you want to search for any text on screen, use the shortcut : Left Windows + Z'
    + #13 + 'The program will take a screenshot and run an OCR on it. A progressbar will show the progress of this operation.'
    + #13 + 'A search window should appear where you can input your search term. Hit Enter to find your term.'),
    PWideChar('Help'), MB_OK and MB_ICONINFORMATION);
end;

procedure TfrmMain.Highlight1Click(Sender: TObject);
begin
  Highlight1.Checked := not Highlight1.Checked;
  OptionHelper.OptionHighlightText := Highlight1.Checked;
end;

procedure TfrmMain.keyScanTimerTimer(Sender: TObject);
var
  keyStateWin: SHORT;
  keyStateZ: SHORT;
  keyStateEsc: SHORT;
begin
  keyStateWin := GetAsyncKeyState(VK_LWIN);
  if IsMSBSet(keyStateWin) then
  // if most significant bit is set, the key is being held down.
  begin
    keyStateZ := GetAsyncKeyState(Ord('Z'));
    if IsMSBSet(keyStateZ) then
    begin
      // okay, windows AND the Z keys are being held down right now
      if Not recognizerBusy then
      begin
        frmSearch.Hide();
        Recognize();
      end;
    end;
  end;

  keyStateEsc := GetAsyncKeyState(VK_ESCAPE);
  if IsMSBSet(keyStateEsc) then
  begin
    frmSearch.Hide();
  end;

end;

procedure TfrmMain.Movecursor1Click(Sender: TObject);
begin
  Movecursor1.Checked := Not Movecursor1.Checked;
  OptionHelper.OptionMoveCursor := Movecursor1.Checked;
end;

procedure TfrmMain.OnRecognizeBegin();
begin
  recognizerBusy := True;
  frmProgress.Show();
end;

procedure TfrmMain.OnRecognizeProgress(Progress: Integer; var Cancel: Boolean);
begin
  frmProgress.UpdateProgress(Progress);
end;

procedure TfrmMain.OnRecognizeEnd(Output: TWordInformationArray;
  Canceled: Boolean);
{$IFDEF DEBUG}
var
  wordInfo: TWordInformation;
  outputString: TStringList;
{$ENDIF}
begin
  recognizerBusy := false;
  frmProgress.Hide();
  recognizedOutput := Output; // save a reference to the recognized output

{$IFDEF DEBUG}
  outputString := TStringList.Create();
  for wordInfo in Output do
  begin
    outputString.Add(wordInfo.word + ' @ ' + '(' + wordInfo.xpos.ToString() +
      ',' + wordInfo.ypos.ToString() + ')');
  end;
  outputString.SaveToFile('./output.txt');
  outputString.Free();
  // ShowMessage('Done!');
{$ENDIF}
  frmSearch.AllRecognizedWords := recognizedOutput;
  frmSearch.Show();
end;

procedure TfrmMain.Recognize();
var
  screenShotPng: TPNGImage;
begin
  screenShotPng := screenshotter.GetScreenShot();
  recognizer := TTextRecognizer.Create(OnRecognizeBegin, OnRecognizeProgress,
    OnRecognizeEnd);
  recognizer.Recognize(screenShotPng);
end;

procedure TfrmMain.LoadSettings();
begin
  Movecursor1.Checked := OptionHelper.OptionMoveCursor;
  Highlight1.Checked := OptionHelper.OptionHighlightText;
end;

end.

{
  COMMENT 2

  The reason for this timer can be understood as follows:
  1. We're bringing forms to the foreground without user interaction, basically using a hack of AttachThreadInput()
  2. If we do a SetWindowPos with HWND_TOPMOST on such forms once and leave them be, that won't stick.
  3. Any other window the user clicks on will be enough to bring that window to the foreground knocking off our forms' TOPMOST flag
  4. I've verified and seen it happen live using Winspector Spy on a demo project
  5. So, the timer comes in to periodically set the TOPMOST(and the foreground) flag on our forms

}
