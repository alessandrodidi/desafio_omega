object dmRelatorio: TdmRelatorio
  OldCreateOrder = False
  Height = 234
  Width = 383
  object pprDoacoes: TppReport
    AutoStop = False
    DataPipeline = daADOQueryDataView1.BS_DOACAO
    PrinterSetup.BinName = 'Default'
    PrinterSetup.DocumentName = 'Report'
    PrinterSetup.PaperName = 'A4'
    PrinterSetup.PrinterName = 'Default'
    PrinterSetup.SaveDeviceSettings = False
    PrinterSetup.mmMarginBottom = 6350
    PrinterSetup.mmMarginLeft = 6350
    PrinterSetup.mmMarginRight = 6350
    PrinterSetup.mmMarginTop = 6350
    PrinterSetup.mmPaperHeight = 297000
    PrinterSetup.mmPaperWidth = 210000
    PrinterSetup.PaperSize = 9
    Template.FileName = 'D:\Desenvolvimento\Delphi\Desafio_Omega\RResDoacoes.rtm'
    ArchiveFileName = '($MyDocuments)\ReportArchive.raf'
    DeviceType = 'Screen'
    DefaultFileDeviceType = 'PDF'
    EmailSettings.ReportFormat = 'PDF'
    LanguageID = 'Default'
    OpenFile = False
    OutlineSettings.CreateNode = True
    OutlineSettings.CreatePageNodes = True
    OutlineSettings.Enabled = True
    OutlineSettings.Visible = True
    ThumbnailSettings.Enabled = True
    ThumbnailSettings.Visible = True
    ThumbnailSettings.DeadSpace = 30
    ThumbnailSettings.PageHighlight.Width = 3
    PDFSettings.EmbedFontOptions = [efUseSubset]
    PDFSettings.EncryptSettings.AllowCopy = True
    PDFSettings.EncryptSettings.AllowInteract = True
    PDFSettings.EncryptSettings.AllowModify = True
    PDFSettings.EncryptSettings.AllowPrint = True
    PDFSettings.EncryptSettings.AllowExtract = True
    PDFSettings.EncryptSettings.AllowAssemble = True
    PDFSettings.EncryptSettings.AllowQualityPrint = True
    PDFSettings.EncryptSettings.Enabled = False
    PDFSettings.EncryptSettings.KeyLength = kl40Bit
    PDFSettings.EncryptSettings.EncryptionType = etRC4
    PDFSettings.FontEncoding = feAnsi
    PDFSettings.ImageCompressionLevel = 25
    PDFSettings.PDFAFormat = pafNone
    PreviewFormSettings.PageBorder.mmPadding = 0
    RTFSettings.DefaultFont.Charset = DEFAULT_CHARSET
    RTFSettings.DefaultFont.Color = clWindowText
    RTFSettings.DefaultFont.Height = -13
    RTFSettings.DefaultFont.Name = 'Arial'
    RTFSettings.DefaultFont.Style = []
    TextFileName = '($MyDocuments)\Report.pdf'
    TextSearchSettings.DefaultString = '<FindText>'
    TextSearchSettings.Enabled = True
    XLSSettings.AppName = 'ReportBuilder'
    XLSSettings.Author = 'ReportBuilder'
    XLSSettings.Subject = 'Report'
    XLSSettings.Title = 'Report'
    XLSSettings.WorksheetName = 'Report'
    Left = 63
    Top = 26
    Version = '19.03'
    mmColumnWidth = 0
    DataPipelineName = 'BS_DOACAO'
    object ppTitleBand1: TppTitleBand
      Background.Brush.Style = bsClear
      Border.mmPadding = 0
      mmBottomOffset = 0
      mmHeight = 24606
      mmPrintPosition = 0
      object ppLabel1: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'lblTitulo'
        Border.mmPadding = 0
        Caption = 'Relat'#243'rio de Doa'#231#245'es'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 18
        Font.Style = [fsBold]
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 7672
        mmLeft = 3175
        mmTop = 1588
        mmWidth = 64823
        BandType = 1
        LayerName = Foreground
      end
      object ppLine1: TppLine
        DesignLayer = ppDesignLayer1
        UserName = 'Line1'
        Border.mmPadding = 0
        Pen.Color = cl3DDkShadow
        Pen.Width = 2
        Weight = 1.500000000000000000
        mmHeight = 3969
        mmLeft = -265
        mmTop = 19315
        mmWidth = 198173
        BandType = 1
        LayerName = Foreground
      end
      object ppLabel4: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label3'
        Border.mmPadding = 0
        Caption = 'Total de doa'#231#245'es por tipo sangu'#237'neo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = cl3DDkShadow
        Font.Name = 'Arial'
        Font.Size = 11
        Font.Style = [fsItalic]
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 4498
        mmLeft = 3175
        mmTop = 10319
        mmWidth = 62177
        BandType = 1
        LayerName = Foreground
      end
    end
    object ppHeaderBand1: TppHeaderBand
      Background.Brush.Style = bsClear
      Border.mmPadding = 0
      mmBottomOffset = 0
      mmHeight = 7408
      mmPrintPosition = 0
      object ppLabel2: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label1'
        AutoSize = False
        Border.mmPadding = 0
        Caption = 'Tipo Sangu'#237'neo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Name = 'Arial'
        Font.Size = 11
        Font.Style = [fsBold]
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        Transparent = True
        mmHeight = 4763
        mmLeft = 5821
        mmTop = 2644
        mmWidth = 33338
        BandType = 0
        LayerName = Foreground
      end
      object ppLabel3: TppLabel
        DesignLayer = ppDesignLayer1
        UserName = 'Label2'
        AutoSize = False
        Border.mmPadding = 0
        Caption = 'Quantidade'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Name = 'Arial'
        Font.Size = 11
        Font.Style = [fsBold]
        FormFieldSettings.FormSubmitInfo.SubmitMethod = fstPost
        FormFieldSettings.FormFieldType = fftNone
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 4763
        mmLeft = 46038
        mmTop = 2644
        mmWidth = 23548
        BandType = 0
        LayerName = Foreground
      end
    end
    object ppDetailBand1: TppDetailBand
      Background1.Brush.Style = bsClear
      Background2.Brush.Style = bsClear
      Border.mmPadding = 0
      PrintHeight = phDynamic
      mmBottomOffset = 0
      mmHeight = 6879
      mmPrintPosition = 0
      object ppDBText1: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'DBText1'
        Border.mmPadding = 0
        DataField = 'PES_TIPOSANG'
        DataPipeline = daADOQueryDataView1.BS_DOACAO
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Name = 'Arial'
        Font.Size = 11
        Font.Style = []
        ParentDataPipeline = False
        TextAlignment = taCentered
        Transparent = True
        DataPipelineName = 'BS_DOACAO'
        mmHeight = 4763
        mmLeft = 5821
        mmTop = 1060
        mmWidth = 33338
        BandType = 4
        LayerName = Foreground
      end
      object ppDBText2: TppDBText
        DesignLayer = ppDesignLayer1
        UserName = 'DBText2'
        Border.mmPadding = 0
        DataField = 'QTDE'
        DataPipeline = daADOQueryDataView1.BS_DOACAO
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Name = 'Arial'
        Font.Size = 11
        Font.Style = []
        ParentDataPipeline = False
        TextAlignment = taRightJustified
        Transparent = True
        DataPipelineName = 'BS_DOACAO'
        mmHeight = 4763
        mmLeft = 48154
        mmTop = 1058
        mmWidth = 21431
        BandType = 4
        LayerName = Foreground
      end
    end
    object ppFooterBand1: TppFooterBand
      Background.Brush.Style = bsClear
      Border.mmPadding = 0
      mmBottomOffset = 0
      mmHeight = 11113
      mmPrintPosition = 0
      object ppsvPagina: TppSystemVariable
        DesignLayer = ppDesignLayer1
        UserName = 'ppsvPagina'
        Border.mmPadding = 0
        VarType = vtPageNoDesc
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Name = 'Arial'
        Font.Size = 10
        Font.Style = [fsBold]
        TextAlignment = taRightJustified
        Transparent = True
        mmHeight = 4234
        mmLeft = 184944
        mmTop = 5556
        mmWidth = 11642
        BandType = 8
        LayerName = Foreground
      end
      object ppLine2: TppLine
        DesignLayer = ppDesignLayer1
        UserName = 'Line2'
        Border.mmPadding = 0
        Pen.Color = cl3DDkShadow
        Pen.Width = 2
        Weight = 1.500000000000000000
        mmHeight = 3969
        mmLeft = -265
        mmTop = 1323
        mmWidth = 198173
        BandType = 8
        LayerName = Foreground
      end
    end
    object daDataModule1: TdaDataModule
      object daADOQueryDataView1: TdaADOQueryDataView
        UserName = 'Query_BS_DOACAO'
        Height = 453
        Left = 10
        NameColumnWidth = 105
        SizeColumnWidth = 35
        SortMode = 0
        Top = 10
        TypeColumnWidth = 52
        Width = 1005
        AutoSearchTabOrder = 0
        object BS_DOACAO: TppChildDBPipeline
          AutoCreateFields = False
          UserName = 'BS_DOACAO'
          object ppField1: TppField
            FieldAlias = 'PES_TIPOSANG'
            FieldName = 'PES_TIPOSANG'
            FieldLength = 2
            DisplayWidth = 2
            Position = 0
          end
          object ppField2: TppField
            FieldAlias = 'QTDE'
            FieldName = 'QTDE'
            FieldLength = 0
            DataType = dtInteger
            DisplayWidth = 10
            Position = 1
          end
        end
        object daSQL1: TdaSQL
          GuidCollationType = gcMSSQLServer
          DatabaseName = 'adocConexao'
          DatabaseType = dtMSSQLServer
          DataPipelineName = 'BS_DOACAO'
          EditSQLAsText = True
          LinkColor = clMaroon
          LinkType = ltParameterizedSQL
          MaxSQLFieldAliasLength = 25
          SQLText.Strings = (
            'SELECT BS_PESSOA.PES_TIPOSANG, COUNT(BS_DOACAO.DOA_QTDE) QTDE '
            'FROM dbo.BS_DOACAO BS_DOACAO'
            '      INNER JOIN dbo.BS_PESSOA BS_PESSOA ON '
            '     (BS_PESSOA.PES_ID = BS_DOACAO.PES_ID)'
            'GROUP BY BS_PESSOA.PES_TIPOSANG '
            '         '
            'ORDER BY QTDE DESC,'
            '         BS_PESSOA.PES_TIPOSANG '
            '         ')
          SQLType = sqSQL2
          object daField1: TdaField
            Alias = 'PES_TIPOSANG'
            DisplayWidth = 2
            FieldAlias = 'PES_TIPOSANG'
            FieldLength = 2
            FieldName = 'PES_TIPOSANG'
            SQLFieldName = 'PES_TIPOSANG'
          end
          object daField2: TdaField
            Alias = 'QTDE'
            DataType = dtInteger
            DisplayWidth = 10
            FieldAlias = 'QTDE'
            FieldLength = 0
            FieldName = 'QTDE'
            SQLFieldName = 'QTDE'
          end
        end
      end
    end
    object ppDesignLayers1: TppDesignLayers
      object ppDesignLayer1: TppDesignLayer
        UserName = 'Foreground'
        LayerType = ltBanded
        Index = 0
      end
    end
    object ppParameterList1: TppParameterList
    end
  end
end
