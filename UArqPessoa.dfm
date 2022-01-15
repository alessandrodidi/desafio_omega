object frmArqPessoa: TfrmArqPessoa
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'Banco de Sangue [Pessoa]'
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gpbxCadastro: TGroupBox
    Left = 0
    Top = 33
    Width = 684
    Height = 176
    Align = alTop
    Caption = 'Cadastro'
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
    object lblDtNasc: TLabel
      Left = 8
      Top = 64
      Width = 96
      Height = 13
      Caption = 'Data de Nascimento'
    end
    object lblCPF: TLabel
      Left = 192
      Top = 64
      Width = 19
      Height = 13
      Caption = 'CPF'
    end
    object lblTipoSanguineo: TLabel
      Left = 340
      Top = 64
      Width = 73
      Height = 13
      Caption = 'Tipo Sangu'#237'neo'
    end
    object lblCelular: TLabel
      Left = 8
      Top = 104
      Width = 33
      Height = 13
      Caption = 'Celular'
    end
    object lblEmail: TLabel
      Left = 157
      Top = 104
      Width = 24
      Height = 13
      Caption = 'Email'
    end
    object edtID: TEdit
      Left = 23
      Top = 21
      Width = 38
      Height = 21
      Enabled = False
      TabOrder = 0
    end
    object edtNome: TEdit
      Left = 113
      Top = 21
      Width = 352
      Height = 21
      MaxLength = 100
      TabOrder = 1
      OnKeyPress = edtNomeKeyPress
    end
    object medtDtNasc: TMaskEdit
      Left = 107
      Top = 61
      Width = 66
      Height = 21
      Alignment = taCenter
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 2
      Text = '  /  /    '
      OnKeyPress = medtDtNascKeyPress
    end
    object medtCPF: TMaskEdit
      Left = 215
      Top = 61
      Width = 106
      Height = 21
      Alignment = taCenter
      EditMask = '999.999.999-99;1;_'
      MaxLength = 14
      TabOrder = 3
      Text = '   .   .   -  '
      OnKeyPress = medtCPFKeyPress
    end
    object cbTipoSanguineo: TComboBox
      Left = 417
      Top = 61
      Width = 48
      Height = 21
      TabOrder = 4
      OnSelect = cbTipoSanguineoSelect
      Items.Strings = (
        'A+'
        'A-'
        'B+'
        'B-'
        'O+'
        'O-')
    end
    object medtCelular: TMaskEdit
      Left = 44
      Top = 101
      Width = 94
      Height = 21
      Alignment = taCenter
      EditMask = '!\(99\) 0.0000-0000;1;_'
      MaxLength = 16
      TabOrder = 5
      Text = '(  )  .    -    '
      OnKeyPress = medtCelularKeyPress
    end
    object edtEmail: TEdit
      Left = 184
      Top = 101
      Width = 281
      Height = 21
      MaxLength = 100
      TabOrder = 6
      OnKeyPress = edtEmailKeyPress
    end
    object btnSalvar: TButton
      Left = 8
      Top = 145
      Width = 75
      Height = 25
      Caption = '&Salvar'
      TabOrder = 7
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 83
      Top = 145
      Width = 75
      Height = 25
      Caption = '&Cancelar'
      TabOrder = 8
    end
  end
  object pnlComandos: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 33
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 731
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
  object gpbxPessoas: TGroupBox
    Left = 0
    Top = 209
    Width = 684
    Height = 252
    Align = alClient
    Caption = 'Pessoas'
    Padding.Top = 5
    TabOrder = 2
    ExplicitTop = 226
    ExplicitWidth = 731
    ExplicitHeight = 203
    object dbgPessoas: TDBGrid
      Left = 2
      Top = 20
      Width = 680
      Height = 230
      Align = alClient
      DataSource = DataSource
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnKeyDown = dbgPessoasKeyDown
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
end
