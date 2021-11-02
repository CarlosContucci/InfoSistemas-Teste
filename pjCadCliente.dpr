program pjCadCliente;

uses
  Vcl.Forms,
  unCadCliente in 'unCadCliente.pas' {frCadCliente},
  unDM in 'unDM.pas' {DM: TDataModule},
  MidasLib;


{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrCadCliente, frCadCliente);
  Application.Run;
end.
