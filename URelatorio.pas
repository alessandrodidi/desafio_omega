unit URelatorio;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, ppParameter,
  ppDesignLayer, ppVar, ppBands, ppCtrls, ppPrnabl, ppClass, ppCache, ppProd,
  ppReport, ppComm, ppRelatv, ppDB, ppDBPipe, daDataView, daQueryDataView,
  daADO, ppModule, daDataModule;

type
  TdmRelatorio = class(TDataModule)
    pprDoacoes: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppLabel1: TppLabel;
    ppLine1: TppLine;
    ppDetailBand1: TppDetailBand;
    ppFooterBand1: TppFooterBand;
    ppsvPagina: TppSystemVariable;
    ppLine2: TppLine;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppParameterList1: TppParameterList;
    daDataModule1: TdaDataModule;
    daADOQueryDataView1: TdaADOQueryDataView;
    ppLabel2: TppLabel;
    ppDBText1: TppDBText;
    ppLabel3: TppLabel;
    ppDBText2: TppDBText;
    ppTitleBand1: TppTitleBand;
    ppLabel4: TppLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmRelatorio: TdmRelatorio;

implementation

uses
  UConexao;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
