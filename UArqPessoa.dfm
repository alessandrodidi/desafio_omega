object frmArqPessoa: TfrmArqPessoa
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Banco de Sangue [Pessoa]'
  ClientHeight = 429
  ClientWidth = 731
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gpbxCadastro: TGroupBox
    Left = 0
    Top = 33
    Width = 731
    Height = 193
    Align = alTop
    Caption = 'Cadastro'
    TabOrder = 0
  end
  object pnlComandos: TPanel
    Left = 0
    Top = 0
    Width = 731
    Height = 33
    Align = alTop
    TabOrder = 1
    object btnAtualizar: TButton
      Left = 8
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Atualizar'
      TabOrder = 0
      OnClick = btnAtualizarClick
    end
    object btnNovo: TButton
      Left = 83
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Novo'
      TabOrder = 1
    end
    object btnEditar: TButton
      Left = 158
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Editar'
      TabOrder = 2
    end
    object btnExcluir: TButton
      Left = 233
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Excluir'
      TabOrder = 3
    end
  end
  object gpbxPessoas: TGroupBox
    Left = 0
    Top = 226
    Width = 731
    Height = 203
    Align = alClient
    Caption = 'Pessoas'
    Padding.Top = 5
    TabOrder = 2
    object dbgPessoas: TDBGrid
      Left = 2
      Top = 20
      Width = 727
      Height = 181
      Align = alClient
      DataSource = DataSource
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object ADOQuery: TADOQuery
    Connection = dmConexao.adocConexao
    Parameters = <>
    Left = 344
    Top = 73
  end
  object DataSource: TDataSource
    DataSet = ADOQuery
    Left = 416
    Top = 81
  end
end
