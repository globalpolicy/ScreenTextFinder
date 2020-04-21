unit Miscellaneous;

interface

uses Windows, CustomTypes, SysUtils;

function IsMSBSet(number: SHORT): boolean;

procedure ActivateWindow(handle: HWND);

procedure SetWindowTop(handle: HWND);

function IsFirstRun(): boolean;

implementation

function IsMSBSet(number: SHORT): boolean;
// the MSB is checked by bitwise AND'ing with the binary number 1000000000000000 i.e. hex 8000. note the size is that of SHORT i.e. 2 bytes
// the result of the AND operation is 0 if the MSB is 0
var
  andResult: SHORT;
begin
  andResult := number and $8000;
  Result := andResult <> 0;
end;

procedure ActivateWindow(handle: HWND);
// brings a window to the foreground thus capturing user inputs
// https://stackoverflow.com/a/59659421/7647225
var
  currentForegroundWindow: HWND;
  currentForegroundWindowThreadId: DWORD;

begin

  currentForegroundWindow := GetForegroundWindow();
  currentForegroundWindowThreadId := GetWindowThreadProcessId
    (currentForegroundWindow);
  AttachThreadInput(GetCurrentThreadId(),
    currentForegroundWindowThreadId, True);
  SetForegroundWindow(handle);
  SetActiveWindow(handle);
end;

procedure SetWindowTop(handle: HWND);
begin
  SetWindowPos(handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or
    SWP_NOREPOSITION);
end;

function IsFirstRun(): boolean;
begin
  if FileExists(SAVE_FILE_NAME) then
    Result := false
  else
    Result := True;
end;

end.
