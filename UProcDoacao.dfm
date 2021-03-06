object frmProcDoacao: TfrmProcDoacao
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'Banco de Sangue [Doa'#231#245'es]'
  ClientHeight = 461
  ClientWidth = 684
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 700
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gpbxPessoa: TGroupBox
    Left = 0
    Top = 33
    Width = 684
    Height = 56
    Align = alTop
    Caption = 'Pessoa'
    TabOrder = 0
    object lblID: TLabel
      Left = 8
      Top = 24
      Width = 11
      Height = 13
      Caption = 'ID'
    end
    object lblNome: TLabel
      Left = 83
      Top = 24
      Width = 27
      Height = 13
      Caption = 'Nome'
    end
    object edtIDPessoa: TEdit
      Left = 23
      Top = 21
      Width = 38
      Height = 21
      Alignment = taRightJustify
      TabOrder = 0
      OnKeyPress = edtIDPessoaKeyPress
    end
    object edtNome: TEdit
      Left = 113
      Top = 21
      Width = 352
      Height = 21
      Enabled = False
      MaxLength = 100
      TabOrder = 1
      OnKeyPress = edtNomeKeyPress
    end
    object btnLocalizar: TButton
      Left = 471
      Top = 19
      Width = 75
      Height = 25
      Caption = '&Localizar'
      TabOrder = 2
      OnClick = btnLocalizarClick
    end
  end
  object pnlComandos: TPanel
    Left = 0
    Top = 0
    Width = 684
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
      OnClick = btnNovoClick
    end
    object btnEditar: TButton
      Left = 158
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Editar'
      TabOrder = 2
      OnClick = btnEditarClick
    end
    object btnExcluir: TButton
      Left = 233
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Excluir'
      TabOrder = 3
      OnClick = btnExcluirClick
    end
  end
  object gpbxDoacoes: TGroupBox
    Left = 0
    Top = 185
    Width = 684
    Height = 276
    Align = alClient
    Caption = 'Doa'#231#245'es'
    Padding.Top = 5
    TabOrder = 2
    object dbgDoacoes: TDBGrid
      Left = 2
      Top = 20
      Width = 680
      Height = 254
      Align = alClient
      DataSource = DataSource
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawColumnCell = dbgDoacoesDrawColumnCell
      OnDblClick = dbgDoacoesDblClick
      OnKeyDown = dbgDoacoesKeyDown
    end
  end
  object gpbxDoacao: TGroupBox
    Left = 0
    Top = 89
    Width = 684
    Height = 96
    Align = alTop
    Caption = 'Doa'#231'ao'
    TabOrder = 3
    object lblIDDoacao: TLabel
      Left = 8
      Top = 24
      Width = 11
      Height = 13
      Caption = 'ID'
    end
    object lblData: TLabel
      Left = 83
      Top = 24
      Width = 23
      Height = 13
      Caption = 'Data'
    end
    object lblQtde: TLabel
      Left = 198
      Top = 24
      Width = 56
      Height = 13
      Caption = 'Quantidade'
    end
    object lblUnidade: TLabel
      Left = 324
      Top = 24
      Width = 10
      Height = 13
      Caption = 'ml'
    end
    object edtIDDoacao: TEdit
      Left = 23
      Top = 21
      Width = 38
      Height = 21
      Alignment = taRightJustify
      Enabled = False
      TabOrder = 0
    end
    object medtDtDoacao: TMaskEdit
      Left = 113
      Top = 21
      Width = 66
      Height = 21
      Alignment = taCenter
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 1
      Text = '  /  /    '
      OnKeyPress = medtDtDoacaoKeyPress
    end
    object btnSalvar: TButton
      Left = 8
      Top = 63
      Width = 75
      Height = 25
      Caption = '&Salvar'
      TabOrder = 3
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 83
      Top = 63
      Width = 75
      Height = 25
      Caption = '&Cancelar'
      TabOrder = 4
      OnClick = btnCancelarClick
    end
    object edtQtde: TEdit
      Left = 260
      Top = 21
      Width = 61
      Height = 21
      Alignment = taRightJustify
      TabOrder = 2
      OnKeyPress = edtQtdeKeyPress
    end
  end
  object ADOQuery: TADOQuery
    Connection = dmConexao.adocConexao
    Parameters = <>
    Left = 304
    Top = 241
  end
  object DataSource: TDataSource
    DataSet = ADOQuery
    Left = 400
    Top = 249
  end
  object ADOQuery2: TADOQuery
    Connection = dmConexao.adocConexao
    Parameters = <>
    Left = 512
    Top = 97
  end
end
