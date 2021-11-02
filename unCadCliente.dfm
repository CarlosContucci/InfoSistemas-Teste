object frCadCliente: TfrCadCliente
  Left = 0
  Top = 110
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Cadastro de clientes'
  ClientHeight = 305
  ClientWidth = 661
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Calibri'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object pgCadCliente: TPageControl
    Left = 0
    Top = 0
    Width = 661
    Height = 305
    ActivePage = tbDados
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 444
    object tbLista: TTabSheet
      Caption = 'Listagem'
      ExplicitHeight = 414
      object grCadCliente: TDBGrid
        Left = 0
        Top = 0
        Width = 653
        Height = 275
        Align = alClient
        DataSource = scCadCliente
        Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -13
        TitleFont.Name = 'Calibri'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'CPF'
            Width = 111
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Nome'
            Width = 246
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Telefone'
            Width = 139
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Cidade'
            Width = 127
            Visible = True
          end>
      end
    end
    object tbDados: TTabSheet
      Caption = 'Dados'
      ImageIndex = 1
      ExplicitHeight = 414
      object pnCadCliente: TPanel
        Left = 0
        Top = 0
        Width = 653
        Height = 275
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitHeight = 414
        object Label1: TLabel
          Left = 16
          Top = 16
          Width = 20
          Height = 15
          Caption = 'CPF'
          FocusControl = edCPF
        end
        object Label2: TLabel
          Left = 127
          Top = 16
          Width = 31
          Height = 15
          Caption = 'Nome'
          FocusControl = edNome
        end
        object Label3: TLabel
          Left = 529
          Top = 16
          Width = 58
          Height = 15
          Caption = 'Identidade'
          FocusControl = edIdentidade
        end
        object Label4: TLabel
          Left = 16
          Top = 168
          Width = 24
          Height = 15
          Caption = 'DDD'
          FocusControl = edDDD
        end
        object Label5: TLabel
          Left = 64
          Top = 168
          Width = 45
          Height = 15
          Caption = 'Telefone'
          FocusControl = edTelefone
        end
        object Label6: TLabel
          Left = 182
          Top = 168
          Width = 31
          Height = 15
          Caption = 'Email'
          FocusControl = edEmail
        end
        object Label7: TLabel
          Left = 16
          Top = 67
          Width = 20
          Height = 15
          Caption = 'CEP'
          FocusControl = edCEP
        end
        object Label8: TLabel
          Left = 98
          Top = 62
          Width = 63
          Height = 15
          Caption = 'Logradouro'
          FocusControl = edLogradouro
        end
        object Label9: TLabel
          Left = 555
          Top = 67
          Width = 43
          Height = 15
          Caption = 'N'#250'mero'
          FocusControl = edNumero
        end
        object Label10: TLabel
          Left = 16
          Top = 117
          Width = 75
          Height = 15
          Caption = 'Complemento'
          FocusControl = edComplemento
        end
        object Label11: TLabel
          Left = 141
          Top = 117
          Width = 35
          Height = 15
          Caption = 'Bairro'
          FocusControl = edBairro
        end
        object Label12: TLabel
          Left = 308
          Top = 117
          Width = 38
          Height = 15
          Caption = 'Cidade'
          FocusControl = edCidade
        end
        object Label13: TLabel
          Left = 475
          Top = 117
          Width = 14
          Height = 15
          Caption = 'UF'
          FocusControl = edEstado
        end
        object Label14: TLabel
          Left = 513
          Top = 117
          Width = 24
          Height = 15
          Caption = 'Pais'
          FocusControl = edPais
        end
        object Bevel1: TBevel
          Left = 16
          Top = 213
          Width = 618
          Height = 10
          Shape = bsBottomLine
        end
        object edCPF: TDBEdit
          Left = 16
          Top = 33
          Width = 105
          Height = 23
          DataField = 'CPF'
          DataSource = scCadCliente
          TabOrder = 0
          OnExit = edCPFExit
        end
        object edNome: TDBEdit
          Left = 127
          Top = 32
          Width = 396
          Height = 23
          DataField = 'Nome'
          DataSource = scCadCliente
          TabOrder = 1
        end
        object edIdentidade: TDBEdit
          Left = 529
          Top = 32
          Width = 105
          Height = 23
          DataField = 'Identidade'
          DataSource = scCadCliente
          TabOrder = 2
        end
        object edDDD: TDBEdit
          Left = 16
          Top = 184
          Width = 42
          Height = 23
          DataField = 'DDD'
          DataSource = scCadCliente
          TabOrder = 11
        end
        object edTelefone: TDBEdit
          Left = 64
          Top = 184
          Width = 112
          Height = 23
          DataField = 'Telefone'
          DataSource = scCadCliente
          TabOrder = 12
        end
        object edEmail: TDBEdit
          Left = 182
          Top = 184
          Width = 452
          Height = 23
          DataField = 'Email'
          DataSource = scCadCliente
          TabOrder = 13
        end
        object edCEP: TDBEdit
          Left = 16
          Top = 83
          Width = 76
          Height = 23
          DataField = 'CEP'
          DataSource = scCadCliente
          TabOrder = 3
        end
        object edLogradouro: TDBEdit
          Left = 98
          Top = 83
          Width = 451
          Height = 23
          DataField = 'Logradouro'
          DataSource = scCadCliente
          TabOrder = 4
        end
        object edNumero: TDBEdit
          Left = 555
          Top = 83
          Width = 79
          Height = 23
          DataField = 'Numero'
          DataSource = scCadCliente
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Calibri'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
        end
        object edComplemento: TDBEdit
          Left = 16
          Top = 133
          Width = 119
          Height = 23
          DataField = 'Complemento'
          DataSource = scCadCliente
          TabOrder = 6
        end
        object edBairro: TDBEdit
          Left = 141
          Top = 133
          Width = 161
          Height = 23
          DataField = 'Bairro'
          DataSource = scCadCliente
          TabOrder = 7
        end
        object edCidade: TDBEdit
          Left = 308
          Top = 133
          Width = 161
          Height = 23
          DataField = 'Cidade'
          DataSource = scCadCliente
          TabOrder = 8
        end
        object edEstado: TDBEdit
          Left = 475
          Top = 133
          Width = 32
          Height = 23
          DataField = 'Estado'
          DataSource = scCadCliente
          TabOrder = 9
        end
        object edPais: TDBEdit
          Left = 513
          Top = 133
          Width = 121
          Height = 23
          DataField = 'Pais'
          DataSource = scCadCliente
          TabOrder = 10
        end
        object btIncluir: TButton
          Left = 57
          Top = 232
          Width = 118
          Height = 33
          Caption = '&Incluir'
          TabOrder = 14
          OnClick = btIncluirClick
        end
        object btSalvar: TButton
          Left = 195
          Top = 232
          Width = 118
          Height = 33
          Caption = '&Salvar'
          TabOrder = 15
          OnClick = btSalvarClick
        end
        object btCancelar: TButton
          Left = 332
          Top = 232
          Width = 118
          Height = 33
          Caption = '&Cancelar'
          TabOrder = 16
          OnClick = btCancelarClick
        end
        object btExcluir: TButton
          Left = 471
          Top = 232
          Width = 118
          Height = 33
          Caption = '&Excluir'
          TabOrder = 17
          OnClick = btExcluirClick
        end
      end
    end
  end
  object scCadCliente: TDataSource
    DataSet = DM.dsCadCliente
    OnStateChange = BotoesPreparar
    Left = 311
    Top = 8
  end
end
