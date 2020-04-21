unit OptionHelper;

interface

uses
  System.Classes, SysUtils, customtypes, Logger;

type
  TOptionHelper = class
  private
    filename: string;
    debugLogger: TLogger;
    function GetOptionMoveCursor(): boolean;
    procedure SetOptionMoveCursor(option: boolean);
    function GetHighlightText(): boolean;
    procedure SetHighlightText(option: boolean);

  public
    constructor Create(saveFilename: string);
    property OptionMoveCursor: boolean read GetOptionMoveCursor
      write SetOptionMoveCursor;
    property OptionHighlightText: boolean read GetHighlightText
      write SetHighlightText;
  end;

implementation

constructor TOptionHelper.Create(saveFilename: string);
begin
  filename := saveFilename;
  if (not FileExists(filename)) then
  begin
    self.OptionMoveCursor := false;
    self.OptionHighlightText := true;
  end;
  debugLogger := TLogger.Create(LOG_FILE_NAME);
end;

function TOptionHelper.GetOptionMoveCursor(): boolean;
var
  stringList: TStringList;

begin
  Result := DEFAULT_OPTION_MOVE_CURSOR;
  if (FileExists(filename)) then
  begin
    stringList := TStringList.Create();
    stringList.LoadFromFile(filename);
    try
      Result := stringList.Values['movecursor'].ToBoolean();
    except
      on E: EConvertError do
        debugLogger.Log(E);
    end;
    stringList.Free();
  end;
end;

procedure TOptionHelper.SetOptionMoveCursor(option: boolean);
var
  stringList: TStringList;
begin
  stringList := TStringList.Create();
  if (FileExists(filename)) then // if file exists then, load contents
  begin
    stringList.LoadFromFile(filename);
  end;
  stringList.Values['movecursor'] := option.ToString();
  stringList.SaveToFile(filename);
  stringList.Free();
end;

function TOptionHelper.GetHighlightText(): boolean;
var
  stringList: TStringList;
begin
  Result := DEFAULT_OPTION_HIGHLIGHT_TEXT;
  if (FileExists(filename)) then
  begin
    stringList := TStringList.Create();
    stringList.LoadFromFile(filename);
    try
      Result := stringList.Values['highlighttext'].ToBoolean();
    except
      on E: EConvertError do
        debugLogger.Log(E);
    end;
    stringList.Free();
  end;
end;

procedure TOptionHelper.SetHighlightText(option: boolean);
var
  stringList: TStringList;
begin
  stringList := TStringList.Create();
  if (FileExists(filename)) then // if file exists then, load contents
  begin
    stringList.LoadFromFile(filename);
  end;
  stringList.Values['highlighttext'] := option.ToString();
  stringList.SaveToFile(filename);
  stringList.Free();
end;

end.
