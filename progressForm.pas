unit progressForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Miscellaneous,
  CustomTypes;

type
  TfrmProgress = class(TForm)
    prbSearchProgress: TProgressBar;
    procedure FormShow(Sender: TObject);
  private

  public
    { Public declarations }
    procedure UpdateProgress(prog: integer);
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

procedure TfrmProgress.FormShow(Sender: TObject);
begin
  prbSearchProgress.Position := 0;
end;

procedure TfrmProgress.UpdateProgress(prog: integer);
begin
  prbSearchProgress.Position := prog;
end;

end.
