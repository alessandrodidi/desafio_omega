unit UFuncoes;

interface

uses
  Windows, Forms, SysUtils, Controls, Data.Win.ADODB, IniFiles, Dialogs;

  procedure Encerrar;
  procedure InciarConexao(Conn: TADOConnection; ArqConfBD: String);

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

procedure InciarConexao(Conn: TADOConnection; ArqConfBD: String);
var
  CaminhoArqIni, DadosConexao: String;
  ArqIni: TIniFile;
begin
  CaminhoArqIni := ExtractFilePath(Application.ExeName)+ArqConfBD;
  ShowMessage(CaminhoArqIni);
  if FileExists(CaminhoArqIni) then
    begin
      try
        ArqIni := TIniFile.Create(CaminhoArqIni);

        DadosConexao := ArqIni.ReadString('CONEXAO','CONEXAO','');
      except
        ArqIni.Free;
        Application.MessageBox('Falha ao ler o arquivo de configura��o','Erro', MB_ICONERROR + MB_OK);
      end;
    end
  else
    begin
      ArqIni.Free;
      Application.MessageBox(PChar('O arquivo de configura��o n�o foi encontrado'+#13#13+'Arquivo: '+ArqConfBD),'Erro', MB_ICONSTOP + MB_OK);
    end;
end;

end.
