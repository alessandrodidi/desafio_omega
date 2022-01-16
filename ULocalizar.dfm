object frmLocalizar: TfrmLocalizar
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Pesquisar'
  ClientHeight = 271
  ClientWidth = 694
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gpbxCriteriosPesquisa: TGroupBox
    Left = 0
    Top = 0
    Width = 694
    Height = 70
    Align = alTop
    Caption = 'Crit'#233'rios de busca'
    TabOrder = 0
    object lblCampo: TLabel
      Left = 8
      Top = 16
      Width = 33
      Height = 13
      Caption = 'Campo'
      Color = clBtnFace
      ParentColor = False
    end
    object lblCriterio: TLabel
      Left = 104
      Top = 16
      Width = 35
      Height = 13
      Caption = 'Crit'#233'rio'
      Color = clBtnFace
      ParentColor = False
    end
    object lblValor: TLabel
      Left = 220
      Top = 16
      Width = 24
      Height = 13
      Caption = 'Valor'
      Color = clBtnFace
      ParentColor = False
    end
    object lblE_1: TLabel
      Left = 374
      Top = 40
      Width = 6
      Height = 13
      Caption = 'E'
      Color = clBtnFace
      ParentColor = False
      Visible = False
    end
    object lblCondicao: TLabel
      Left = 544
      Top = 16
      Width = 44
      Height = 13
      Caption = 'Condi'#231#227'o'
      Color = clBtnFace
      ParentColor = False
      Visible = False
    end
    object sbtnIncluirCriterio: TSpeedButton
      Left = 599
      Top = 36
      Width = 23
      Height = 23
      Hint = 'Incluir crit'#233'rio'
      Caption = '+'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Pitch = fpVariable
      Font.Style = [fsBold]
      Font.Quality = fqDraft
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = sbtnIncluirCriterioClick
    end
    object sbtnPesquisar: TSpeedButton
      Left = 624
      Top = 36
      Width = 23
      Height = 23
      Hint = 'Pesquisar'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbtnPesquisarClick
    end
    object sbtnLimparPesquisa_999: TSpeedButton
      Left = 644
      Top = 36
      Width = 23
      Height = 23
      Hint = 'Limpar pesquisa'
      ParentShowHint = False
      ShowHint = True
      OnClick = sbtnLimparPesquisa_999Click
    end
    object cbCampo_1: TComboBox
      Left = 8
      Top = 36
      Width = 85
      Height = 23
      Hint = 'Campo'
      Style = csOwnerDrawFixed
      ItemHeight = 17
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object cbCriterio_1: TComboBox
      Left = 104
      Top = 36
      Width = 106
      Height = 23
      Hint = 'Crit'#233'rio'
      Style = csOwnerDrawFixed
      ItemHeight = 17
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnChange = cbCriterio_1Change
      Items.Strings = (
        #233' igual'
        'n'#227'o '#233' igual'
        'cont'#233'm'
        'n'#227'o cont'#233'm'
        'est'#225' entre'
        'n'#227'o est'#225' entre'
        #233' nulo'
        'n'#227'o '#233' nulo'
        #233' verdadeiro'
        #233' falso')
    end
    object edtValor1_1: TEdit
      Left = 220
      Top = 36
      Width = 150
      Height = 21
      Hint = 'Valor'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
    object edtValor2_1: TEdit
      Left = 384
      Top = 36
      Width = 150
      Height = 21
      Hint = 'Valor final'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      Visible = False
    end
    object cbCondicao_1: TComboBox
      Left = 544
      Top = 36
      Width = 51
      Height = 23
      Hint = 'Condi'#231#227'o'
      Style = csOwnerDrawFixed
      ItemHeight = 17
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      Visible = False
      Items.Strings = (
        'E'
        'OU')
    end
  end
  object gpbxResultado: TGroupBox
    Left = 0
    Top = 70
    Width = 694
    Height = 201
    Align = alClient
    Caption = 'Resultados da busca'
    TabOrder = 1
    ExplicitLeft = 240
    ExplicitTop = 144
    ExplicitWidth = 185
    ExplicitHeight = 105
    object pnlComandos: TPanel
      Left = 2
      Top = 15
      Width = 690
      Height = 34
      Align = alTop
      TabOrder = 0
    end
    object dbgResultados: TDBGrid
      Left = 2
      Top = 49
      Width = 690
      Height = 150
      Align = alClient
      DataSource = DataSource
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 1
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
    Left = 480
    Top = 112
  end
  object DataSource: TDataSource
    DataSet = ADOQuery
    Left = 544
    Top = 168
  end
end
