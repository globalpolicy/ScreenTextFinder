unit ScreenPainter;

interface

uses
  System.Classes, Windows, CustomTypes;

type
  TScreenPainterThread = class(TThread)
  private
    sleepTime: Integer;
    filteredWords: TWordInformationArray;
    procedure PaintOnWords();
  public
    constructor Create(filteredWords: TWordInformationArray;
      sleepTime: Integer = 300);
  protected
    procedure Execute; override; // this is called by the framework internally.
  end;

implementation

constructor TScreenPainterThread.Create(filteredWords: TWordInformationArray;
  sleepTime: Integer = 300);
begin
  // initialize fields
  self.filteredWords := filteredWords;
  self.sleepTime := sleepTime;

  Inherited Create(False); // COMMENT 1 (SEE BOTTOM)
  // Base class' Create(False) immediately starts the thread execution i.e. Execute() routine

end;

procedure TScreenPainterThread.Execute();
begin
  NameThreadForDebugging('Screen Painter Thread');

  while Not self.Terminated do
  // if Terminated flag is not set, loop indefinitely
  begin
    PaintOnWords();
    Sleep(sleepTime);
  end;

end;

procedure TScreenPainterThread.PaintOnWords();
var
  deviceContext: HDC;
  transparentBrush: HGDIOBJ;
  blackPen: HGDIOBJ;
  filteredWord: TWordInformation;

begin

  // get entire window's device context
  deviceContext := GetDC(0);
  // get transparent brush. ref. http://forums.codeguru.com/showthread.php?112824-Transparent-Brush
  transparentBrush := GetStockObject(NULL_BRUSH);
  // select the transparent brush into the deviceContext
  SelectObject(deviceContext, transparentBrush);
  blackPen := GetStockObject(BLACK_PEN); // get black pen
  // select black pen into the deviceContext
  SelectObject(deviceContext, blackPen);

  for filteredWord in filteredWords do
  // draw rectangular outline. uses current pen for outline. current brush for fill
  begin
    Rectangle(deviceContext, filteredWord.leftupx, filteredWord.leftupy,
      filteredWord.rightdownx, filteredWord.rightdowny);
    // this API call takes ~30ms. that's very slow when in a for loop
  end;

end;

end.

{
  COMMENT 1

  Delphi In A Nutshell by Ray Lischner recommends calling Inherited Create(True) to start thread suspended and then do the initializations and the call Resume()
  But Delphi 2010+ (I'm using 10.3) warns not to use the Deprecated Resume() method. So, I replaced it with Start() method. But Delphi gives an error 'Cannot call Start on a running or suspended thread'.
  So, according to:
  https://stackoverflow.com/questions/1624071/resuming-suspended-thread-in-delphi-2010
  ++++++++++++++++++++++++++++++++++++++++++++++++++
  -----------------------------------------------
  Short answer: call inherited Create(false) and omitt the Start!
  The actual Start of a non-create-suspended thread is done in AfterConstruction, which is called after all constructors have been called.
  -----------------------------------------------
  Note that this is a relatively recent development. Older versions really would start running as soon as the inherited constructor finished running. There's a really easy workaround to that, though: Call the inherited constructor last. (There's little reason to call it first; a descendant rarely needs any of the property values that the base TThread constructor sets.)
  -----------------------------------------------
  ++++++++++++++++++++++++++++++++++++++++++++++++++

  So, I first initialized all the fields and then called Inherited Create(False) that immmediately starts the Execute() procedure
  Man... so many fragments of scattered knowledge in Delphi and ofc lack of good official documentation. Being based on a dying language doesn't help with the google searches either.
}
