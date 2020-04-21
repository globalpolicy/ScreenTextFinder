unit CustomTypes;

interface

uses
  SysUtils;

type
  TWordInformation = record
    word: string;
    xpos: integer;
    ypos: integer;
    leftupx: integer;
    leftupy: integer;
    rightdownx: integer;
    rightdowny: integer;
  end;

  TWordInformationArray = Array of TWordInformation;

  { tesseract callback delegates }
  TOnRecognizeBegin = procedure of object;
  TOnRecognizeProgress = procedure(Progress: integer; var Cancel: Boolean)
    of object;
  TOnRecognizeEnd = procedure(Output: TWordInformationArray; Canceled: Boolean)
    of object;

  { constants }
const
  SAVE_FILE_NAME = 'options.dat';
  DEFAULT_OPTION_MOVE_CURSOR = false;
  DEFAULT_OPTION_HIGHLIGHT_TEXT = true;
  LOG_FILE_NAME = 'logs.txt';

implementation

end.
