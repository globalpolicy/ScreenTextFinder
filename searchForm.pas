unit searchForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, CustomTypes,
  ScreenPainter, OptionHelper, Vcl.ExtCtrls, Miscellaneous;

type
  TfrmSearch = class(TForm)
    txtSearchString: TEdit;
    procedure txtSearchStringKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormHide(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    totalRecognizedOutput: TWordInformationArray;
    procedure filterAndPaint();

  public
    property AllRecognizedWords: TWordInformationArray
      read totalRecognizedOutput write totalRecognizedOutput;
  end;

var
  frmSearch: TfrmSearch;
  ScreenPainter: TScreenPainterThread;
  OptionHelper: TOptionHelper;

implementation

{$R *.dfm}

procedure TfrmSearch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide; // hide instead of close
end;

procedure TfrmSearch.FormCreate(Sender: TObject);
begin
  OptionHelper := TOptionHelper.Create(SAVE_FILE_NAME);
end;

procedure TfrmSearch.FormHide(Sender: TObject);
begin
  if Assigned(ScreenPainter) and not ScreenPainter.Finished then
  begin
    ScreenPainter.Terminate();
  end;
end;

procedure TfrmSearch.FormShow(Sender: TObject);
begin
  txtSearchString.Text := '';
  Left := GetSystemMetrics(SM_CXSCREEN) - Width;
  Top := GetSystemMetrics(SM_CYSCREEN) - Height;
end;

procedure TfrmSearch.txtSearchStringKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then
  begin
    filterAndPaint();
  end;
end;

procedure TfrmSearch.filterAndPaint();
var
  wordInfo: TWordInformation;
  filteredWordInfos: TWordInformationArray;
  cnt: Integer;
  typedString: string;

begin
  cnt := 0;
  typedString := txtSearchString.Text;
  for wordInfo in AllRecognizedWords do
  begin
    if wordInfo.word.ToLower().Contains(typedString.ToLower()) then
    begin
      SetLength(filteredWordInfos, Length(filteredWordInfos) + 1);
      filteredWordInfos[cnt].word := wordInfo.word;
      filteredWordInfos[cnt].xpos := wordInfo.xpos;
      filteredWordInfos[cnt].ypos := wordInfo.ypos;
      filteredWordInfos[cnt].leftupx := wordInfo.leftupx;
      filteredWordInfos[cnt].leftupy := wordInfo.leftupy;
      filteredWordInfos[cnt].rightdownx := wordInfo.rightdownx;
      filteredWordInfos[cnt].rightdowny := wordInfo.rightdowny;
      Inc(cnt);
    end;
  end;

  if OptionHelper.OptionHighlightText then
  begin
    if Assigned(ScreenPainter) and Not ScreenPainter.Finished then
    // ask the thread to terminate if running
    begin
      ScreenPainter.Terminate();
    end;
    ScreenPainter := TScreenPainterThread.Create(filteredWordInfos);
  end;

  if OptionHelper.OptionMoveCursor then
  begin
    if Length(filteredWordInfos) > 0 then
    begin
      SetCursorPos(filteredWordInfos[0].xpos, filteredWordInfos[0].ypos);
    end;
  end;

end;

end.
