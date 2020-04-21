unit screenshotter;

interface

uses
  Windows, PNGImage, Graphics, Sysutils;

function GetScreenShot(): TPngImage;

implementation

function GetScreenShot(): TPngImage;
var
  deviceContext: cardinal;
  pngScreenshot: TPngImage;
  bmpScreenshot: Graphics.TBitMap;
  screenHeight: integer;
  screenWidth: integer;

begin
  screenHeight := GetSystemMetrics(SM_CYSCREEN);
  screenWidth := GetSystemMetrics(SM_CXSCREEN);
  deviceContext := GetDC(0);
  bmpScreenshot := Graphics.TBitMap.Create();
  bmpScreenshot.Height := screenHeight;
  bmpScreenshot.Width := screenWidth;
  BitBlt(bmpScreenshot.Canvas.Handle, 0, 0, screenWidth, screenHeight,
    deviceContext, 0, 0, SRCCOPY);
  pngScreenshot := TPngImage.Create();
  pngScreenshot.Assign(bmpScreenshot);
{$IFDEF DEBUG}
  pngScreenshot.SaveToFile('saved.png');
{$ENDIF}
  Result := pngScreenshot;
  bmpScreenshot.Free();
end;

end.
