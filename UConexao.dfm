object dmConexao: TdmConexao
  OldCreateOrder = False
  Height = 278
  Width = 354
  object sqlcConexao: TSQLConnection
    DriverName = 'MSSQL'
    LoginPrompt = False
    Params.Strings = (
      'SchemaOverride=%.dbo'
      'DriverUnit=Data.DBXMsSQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DBXMSSQLDriver200.b' +
        'pl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=20.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMsSqlMetaDataCommandFactory,DbxMSSQLDr' +
        'iver200.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMsSqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMSSQLDriver,Version=20.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMSSQL'
      'LibraryName=D:\Desenvolvimento\Delphi\Desafio_Omega\dbxmss.dll'
      'VendorLib=D:\Desenvolvimento\Delphi\Desafio_Omega\sqlncli10.dll'
      
        'VendorLibWin64=D:\Desenvolvimento\Delphi\Desafio_Omega\sqlncli10' +
        '.dll'
      'HostName=PC-ALESSANDRO\SQLEXPRESS'
      'Database=BS'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'IsolationLevel=ReadCommitted'
      'OSAuthentication=False'
      'PrepareSQL=True'
      'OS Authentication=False'
      'User_Name=sa'
      'Password=qwe@123456')
    Left = 72
    Top = 56
  end
  object adocConexao: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=qwe@123456;Persist Security Info=Tr' +
      'ue;User ID=sa;Initial Catalog=BS;Data Source=PC-ALESSANDRO\SQLEX' +
      'PRESS'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 200
    Top = 56
  end
end
