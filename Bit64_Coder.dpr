program Bit64_Coder;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Base64Unit in 'Base64Unit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
