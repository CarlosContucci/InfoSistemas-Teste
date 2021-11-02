object DM: TDM
  OldCreateOrder = False
  Height = 137
  Width = 303
  object dsCadCliente: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 39
    Top = 16
    object dsCadClienteCPF: TStringField
      FieldName = 'CPF'
      EditMask = '!999\.999\.999\-99;1;_'
      Size = 14
    end
    object dsCadClienteNome: TStringField
      FieldName = 'Nome'
      Required = True
      Size = 50
    end
    object dsCadClienteIdentidade: TStringField
      FieldName = 'Identidade'
      Size = 15
    end
    object dsCadClienteDDD: TIntegerField
      FieldName = 'DDD'
    end
    object dsCadClienteTelefone: TStringField
      FieldName = 'Telefone'
      Size = 10
    end
    object dsCadClienteEmail: TStringField
      FieldName = 'Email'
      Required = True
      Size = 200
    end
    object dsCadClienteCEP: TStringField
      FieldName = 'CEP'
      OnSetText = dsCadClienteCEPSetText
      EditMask = '!99999\-999;1;_'
      Size = 9
    end
    object dsCadClienteLogradouro: TStringField
      FieldName = 'Logradouro'
      Size = 200
    end
    object dsCadClienteNumero: TStringField
      FieldName = 'Numero'
      Size = 5
    end
    object dsCadClienteComplemento: TStringField
      FieldName = 'Complemento'
      Size = 30
    end
    object dsCadClienteBairro: TStringField
      FieldName = 'Bairro'
      Size = 30
    end
    object dsCadClienteCidade: TStringField
      FieldName = 'Cidade'
      Size = 30
    end
    object dsCadClienteEstado: TStringField
      FieldName = 'Estado'
      Size = 2
    end
    object dsCadClientePais: TStringField
      FieldName = 'Pais'
      Size = 30
    end
  end
  object rqCEP: TRESTRequest
    Client = rcCEP
    Params = <
      item
        Kind = pkURLSEGMENT
        name = 'cep'
        Options = [poAutoCreated]
      end>
    Resource = 'ws/{cep}/json'
    Response = rrCEP
    SynchronizedEvents = False
    Left = 32
    Top = 72
  end
  object rcCEP: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'UTF-8, *;q=0.8'
    AcceptEncoding = 'identity'
    BaseURL = 'http://viacep.com.br'
    Params = <>
    HandleRedirects = True
    RaiseExceptionOn500 = False
    Left = 64
    Top = 72
  end
  object rrCEP: TRESTResponse
    ContentType = 'text/html'
    Left = 96
    Top = 72
  end
  object raCEP: TRESTResponseDataSetAdapter
    Dataset = tbCEP
    FieldDefs = <>
    Response = rrCEP
    Left = 132
    Top = 74
  end
  object tbCEP: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    AutoCommitUpdates = False
    StoreDefs = True
    Left = 168
    Top = 72
  end
end
