object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'frmPrincipal'
  ClientHeight = 609
  ClientWidth = 580
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label6: TLabel
    Left = 360
    Top = 8
    Width = 38
    Height = 16
    Caption = 'CNPJ:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object labelTokenEnviar: TLabel
    Left = 8
    Top = 8
    Width = 64
    Height = 16
    Caption = 'Salvar em:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object pgControl: TPageControl
    Left = 8
    Top = 47
    Width = 561
    Height = 561
    ActivePage = formEmissao
    Align = alCustom
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object formEmissao: TTabSheet
      Caption = 'Emiss'#227'o S'#237'ncrona'
      object Label1: TLabel
        Left = 16
        Top = 15
        Width = 61
        Height = 16
        Caption = 'Conteudo:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 339
        Top = 15
        Width = 111
        Height = 16
        Caption = 'Tipo de Conteudo:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 16
        Top = 204
        Width = 119
        Height = 16
        Caption = 'Tipo de Download*:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label4: TLabel
        Left = 16
        Top = 233
        Width = 372
        Height = 16
        Caption = '* X - XML; J - JSON; P - PDF; XP - XML e PDF; JP - JSON e PDF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 216
        Top = 202
        Width = 110
        Height = 16
        Caption = 'Tipo de Ambiente:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object btnEmitir: TButton
        Left = 21
        Top = 264
        Width = 516
        Height = 28
        Caption = 'Enviar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnEnviarClick
      end
      object memoConteudoEnviar: TMemo
        Left = 16
        Top = 37
        Width = 511
        Height = 153
        ScrollBars = ssBoth
        TabOrder = 1
      end
      object cbTpConteudo: TComboBox
        Left = 456
        Top = 3
        Width = 76
        Height = 28
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 2
        Text = 'txt'
        Items.Strings = (
          'txt'
          'xml'
          'json')
      end
      object chkExibirEmis: TCheckBox
        Left = 421
        Top = 205
        Width = 111
        Height = 17
        Caption = 'Exibir em tela?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object GroupBox4: TGroupBox
        Left = 3
        Top = 311
        Width = 544
        Height = 212
        Caption = 'Retorno API'
        TabOrder = 4
        object memoRetornoEmis: TMemo
          Left = 12
          Top = 24
          Width = 517
          Height = 177
          TabOrder = 0
        end
      end
      object cbTpDownEmis: TComboBox
        Left = 141
        Top = 196
        Width = 52
        Height = 28
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 5
        Text = 'XP'
        Items.Strings = (
          'XP'
          'JP'
          'X'
          'P'
          'J')
      end
      object cbTpAmbEmis: TComboBox
        Left = 332
        Top = 196
        Width = 41
        Height = 28
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 6
        Text = '2'
        Items.Strings = (
          '2'
          '1')
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Encerrar MDF-e'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label7: TLabel
        Left = 13
        Top = 24
        Width = 83
        Height = 16
        Caption = 'Chave MDF-e'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label8: TLabel
        Left = 13
        Top = 98
        Width = 90
        Height = 16
        Caption = 'C'#243'digo Estado'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label9: TLabel
        Left = 277
        Top = 98
        Width = 104
        Height = 16
        Caption = 'C'#243'digo Munic'#237'pio'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label10: TLabel
        Left = 277
        Top = 24
        Width = 153
        Height = 16
        Caption = 'N'#250'mero Protocolo MDF-e'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label11: TLabel
        Left = 19
        Top = 175
        Width = 119
        Height = 16
        Caption = 'Tipo de Download*:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label12: TLabel
        Left = 207
        Top = 175
        Width = 110
        Height = 16
        Caption = 'Tipo de Ambiente:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label13: TLabel
        Left = 19
        Top = 223
        Width = 372
        Height = 16
        Caption = '* X - XML; J - JSON; P - PDF; XP - XML e PDF; JP - JSON e PDF'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object txtchMDFeEnc: TEdit
        Left = 13
        Top = 46
        Width = 236
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object txtcUFEnc: TEdit
        Left = 13
        Top = 120
        Width = 236
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        Text = '.\Notas\'
      end
      object txtcMunEnc: TEdit
        Left = 277
        Top = 120
        Width = 257
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Text = '.\Notas\'
      end
      object txtnProtEnc: TEdit
        Left = 277
        Top = 46
        Width = 257
        Height = 24
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Text = '.\Notas\'
      end
      object chkExibirEnc: TCheckBox
        Left = 397
        Top = 176
        Width = 111
        Height = 17
        Caption = 'Exibir em tela?'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object btnEncerrar: TButton
        Left = 18
        Top = 264
        Width = 516
        Height = 28
        Caption = 'Encerrar'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = btnEncerrarClick
      end
      object GroupBox1: TGroupBox
        Left = 9
        Top = 314
        Width = 544
        Height = 212
        Caption = 'Retorno API'
        TabOrder = 6
        object memoRetornoEnc: TMemo
          Left = 12
          Top = 24
          Width = 517
          Height = 177
          TabOrder = 0
        end
      end
      object cbtpDownEnc: TComboBox
        Left = 144
        Top = 169
        Width = 49
        Height = 28
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 7
        Text = 'XP'
        Items.Strings = (
          'XP'
          'JP'
          'X'
          'P'
          'J')
      end
      object cbtpAmbEnc: TComboBox
        Left = 323
        Top = 169
        Width = 46
        Height = 28
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 8
        Text = '2'
        Items.Strings = (
          '2'
          '1')
      end
    end
  end
  object txtCNPJ: TEdit
    Left = 400
    Top = 8
    Width = 154
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Text = '07364617000135'
  end
  object txtCaminhoSalvar: TEdit
    Left = 75
    Top = 8
    Width = 269
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    Text = '.\Notas\'
  end
end
