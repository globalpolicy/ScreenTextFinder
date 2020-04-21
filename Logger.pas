unit Logger;

interface

uses
  System.Classes, SysUtils, Windows;

type
  TLogger = class
  private
    filename: string;
  public
    constructor Create(filename: string);
    procedure Log(output: string); overload;
    procedure Log(ex: Exception); overload;
  end;

implementation

constructor TLogger.Create(filename: string);
begin
  self.filename := filename;
end;

procedure TLogger.Log(output: string);
var
  stringList: TStringList;

begin
  OutputDebugString(PChar(output));

  stringList := TStringList.Create();
  if FileExists(filename) then
  begin
    stringList.LoadFromFile(filename);
  end;
  stringList.Add(output);
  stringList.SaveToFile(filename);
  stringList.Free();
end;

procedure TLogger.Log(ex: Exception);
begin
  self.Log(ex.QualifiedClassName + ' : ' + ex.Message);
end;

end.
