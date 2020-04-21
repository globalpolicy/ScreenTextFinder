program ScreenTextFinder;

uses
  Vcl.Forms,
  mainForm in 'mainForm.pas' {frmMain},
  screenshotter in 'screenshotter.pas',
  tesseractocr.capi in 'TesseractUnits\tesseractocr.capi.pas',
  tesseractocr.consts in 'TesseractUnits\tesseractocr.consts.pas',
  tesseractocr.leptonica in 'TesseractUnits\tesseractocr.leptonica.pas',
  tesseractocr.pagelayout in 'TesseractUnits\tesseractocr.pagelayout.pas',
  tesseractocr in 'TesseractUnits\tesseractocr.pas',
  tesseractocr.utils in 'TesseractUnits\tesseractocr.utils.pas',
  TextRecognizer in 'TextRecognizer.pas',
  customtypes in 'customtypes.pas',
  OptionHelper in 'OptionHelper.pas',
  Logger in 'Logger.pas',
  searchForm in 'searchForm.pas' {frmSearch},
  Miscellaneous in 'Miscellaneous.pas',
  progressForm in 'progressForm.pas' {frmProgress},
  ScreenPainter in 'ScreenPainter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Screen Text Finder';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmSearch, frmSearch);
  Application.CreateForm(TfrmProgress, frmProgress);
  Application.ShowMainForm := false;
  Application.Run;

end.
