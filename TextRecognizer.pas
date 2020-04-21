unit TextRecognizer;

interface

uses
  SysUtils, tesseractocr, tesseractocr.pagelayout, customTypes, Graphics,
  PNGImage;

type
  TTextRecognizer = class
  private
    onRecognizeBegin: TOnRecognizeBegin;
    onRecognizeProgress: TOnRecognizeProgress;
    onRecognizeEnd: TOnRecognizeEnd;

    procedure beginRecognizeCallback(Sender: TObject);

    procedure progressReportCallback(Sender: TObject; Progress: Integer;
      var Cancel: Boolean);

    procedure recognitionFinishedCallback(Sender: TObject; Canceled: Boolean);

  public
    constructor Create(onRecognizeBegin: TOnRecognizeBegin;
      onRecognizeProgress: TOnRecognizeProgress;
      onRecognizeEnd: TOnRecognizeEnd);
    procedure Recognize(image: TPNGImage);

  end;

implementation

Constructor TTextRecognizer.Create(onRecognizeBegin: TOnRecognizeBegin;
  onRecognizeProgress: TOnRecognizeProgress; onRecognizeEnd: TOnRecognizeEnd);
begin
  self.onRecognizeBegin := onRecognizeBegin;
  self.onRecognizeProgress := onRecognizeProgress;
  self.onRecognizeEnd := onRecognizeEnd;
end;

procedure TTextRecognizer.Recognize(image: TPNGImage);
var

  bmp: Graphics.TBitmap;

begin

  Tesseract := TTesseractOCR4.Create();
  Tesseract.onRecognizeBegin := beginRecognizeCallback;
  Tesseract.onRecognizeProgress := progressReportCallback;
  Tesseract.onRecognizeEnd := recognitionFinishedCallback;

  try
    if Tesseract.Initialize('./', 'eng') then
    // assumes the training data is in current directory
    begin
      bmp := TBitmap.Create();
      bmp.Assign(image);
      // Tesseract.SetImage('./saved.png');
      Tesseract.SetImage(bmp);
      Tesseract.Recognize(true);
    end;
  finally

  end;

end;

procedure TTextRecognizer.beginRecognizeCallback(Sender: TObject);
begin
  self.onRecognizeBegin();
end;

procedure TTextRecognizer.progressReportCallback(Sender: TObject;
  Progress: Integer; var Cancel: Boolean);
begin

  self.onRecognizeProgress(Progress, Cancel);
end;

procedure TTextRecognizer.recognitionFinishedCallback(Sender: TObject;
  Canceled: Boolean);
var
  block: TTesseractBlock;
  paragraph: TTesseractParagraph;
  textline: TTesseractTextline;
  word: TTesseractWord;

  outputList: TWordInformationArray;

  cnt: Integer;

begin
  cnt := 0;
  for block in Tesseract.pagelayout.Blocks do
  begin
    for paragraph in block.Paragraphs do
    begin
      for textline in paragraph.TextLines do
      begin
        for word in textline.Words do
        begin
          SetLength(outputList, Length(outputList) + 1);
          outputList[cnt].word := word.Text;
          outputList[cnt].xpos := word.BoundingRect.CenterPoint.x;
          outputList[cnt].ypos := word.BoundingRect.CenterPoint.y;
          outputList[cnt].leftupx := word.BoundingRect.Left;
          outputList[cnt].leftupy := word.BoundingRect.Top;
          outputList[cnt].rightdownx := word.BoundingRect.Right;
          outputList[cnt].rightdowny := word.BoundingRect.Bottom;
          inc(cnt);

        end;
      end;
    end;
  end;

  self.onRecognizeEnd(outputList, Canceled);
end;

end.
