unit UFuncoes;

interface

uses
  Windows, Forms, SysUtils, Controls;

  procedure Encerrar;

implementation

procedure Encerrar;
begin
  //Solicita confirmação para sair do programa
  if Application.MessageBox('Deseja sair do sistema?'
                           ,'Confirmação'
                           ,MB_ICONQUESTION + MB_YESNO) = mrYes then
    //Casso ação seja confirma encerra a aplicação
    Application.Terminate
  else
    Abort;
end;

procedure ConnStart(Conn: TSQLConnection; IniSysConf, IniUserPref: String);
var
  IniDBConf, Alias, DatabaseName: String;
begin
  with Conn do
    begin
      try
        IniDBConf := ReadIni(IniSysConf,'DatabaseSettings','AliasFile');
        Alias := ReadIni(IniUserPref,'Alias','AliasName');
        DatabaseName := ReadIni(IniDBConf,Alias,'Database');
        if CheckIniSessionExists(IniDBConf,Alias) then
          begin
            ConnectionName := ReadIni(IniDBConf,Alias,'ConnectionName');
            DriverName := ReadIni(IniDBConf,Alias,'DriverName');
            GetDriverFunc := ReadIni(IniDBConf,Alias,'GetDriverFunc');
            LibraryName := ReadIni(IniDBConf,Alias,'LibraryName');
            LoginPrompt := StrToBool(ReadIni(IniDBConf,Alias,'LoginPrompt'));
            VendorLib := ReadIni(IniDBConf,Alias,'VendorLib');

            LoadParamsFromIniFile(IniDBConf);

            Connected := True;
          end
        else
          begin
            Application.MessageBox(PChar('Não foi possível localizar a conexão com o banco de dados '+Alias),'Aviso',MB_ICONEXCLAMATION + MB_OK);
          end;
      except on E: exception do
        begin
          Connected := False;
          Application.MessageBox(PChar('Não foi possível se conectar ao banco de dados '+DatabaseName+#13#13+'Detalhes: '+E.Message),'Erro de conexão',MB_ICONERROR + MB_OK);
          //Conn.Free;
          Abort;
          Exit;
        end;
      end;
    end;
end;

end.
