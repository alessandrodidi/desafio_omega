unit UConexao;

interface

uses
  System.SysUtils, System.Classes, Data.DBXMsSQL, Data.DB, Data.SqlExpr,
  Data.Win.ADODB;

type
  TdmConexao = class(TDataModule)
    sqlcConexao: TSQLConnection;
    adocConexao: TADOConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmConexao: TdmConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
