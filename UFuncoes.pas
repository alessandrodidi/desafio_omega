unit UFuncoes;

interface

uses
  Windows, Forms, SysUtils, Controls;

  procedure Encerrar;

implementation

procedure Encerrar;
begin
  //Solicita confirma��o para sair do programa
  if Application.MessageBox('Deseja sair do sistema?'
                           ,'Confirma��o'
                           ,MB_ICONQUESTION + MB_YESNO) = mrYes then
    //Casso a��o seja confirma encerra a aplica��o
    Application.Terminate
  else
    Abort;
end;

end.
