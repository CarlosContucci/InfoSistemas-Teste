{
   Tela:       Módulo do Cadastro de Clientes
   Autor:      Carlos Contucci
   Data:       01/11/2021
   Proposito:  Teste técnico de candidatura a vaga Info Sistemas
}

unit unDM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, dialogs,
  IPPeerClient, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.Components, Data.Bind.ObjectScope, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
  IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdMessage, System.Actions, Vcl.ActnList, Vcl.ExtActns, IdAttachmentFile,
  IdAttachmentMemory, idGlobal, IdText, vcl.Forms, System.UITypes;

type
  TDM = class(TDataModule)
    dsCadCliente: TClientDataSet;
    dsCadClienteNome: TStringField;
    dsCadClienteIdentidade: TStringField;
    dsCadClienteDDD: TIntegerField;
    dsCadClienteEmail: TStringField;
    dsCadClienteLogradouro: TStringField;
    dsCadClienteNumero: TStringField;
    dsCadClienteComplemento: TStringField;
    dsCadClienteBairro: TStringField;
    dsCadClienteCidade: TStringField;
    dsCadClienteEstado: TStringField;
    dsCadClientePais: TStringField;
    dsCadClienteCPF: TStringField;
    rqCEP: TRESTRequest;
    rcCEP: TRESTClient;
    rrCEP: TRESTResponse;
    raCEP: TRESTResponseDataSetAdapter;
    tbCEP: TFDMemTable;
    dsCadClienteCEP: TStringField;
    dsCadClienteTelefone: TStringField;
    procedure dsCadClienteCEPSetText(Sender: TField; const Text: string);
  private
    { Private declarations }
    procedure EnviarEmail(pDestino: string; pCorpo: TStrings; pAnexo: string);
    function CriarXMLTemp:string;
    function CriarCorpo:TStrings;
  public
    { Public declarations }
    procedure EnviarDados;
    function ValidaCPF: boolean;
    function ValidaEmail(const Value: string): Boolean;
    function ValidaCamposObrigatorios:boolean;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDM.ValidaCamposObrigatorios: boolean;
var
   vLoop:integer;
begin
   // verifica se os campos obrigatórios estão preenchidos
   // true se os campos obrigatórios estao preenchidos
   // false se os campos obrigatórios NÃO estão preenchidos
   result := true;
   for vLoop := 0 to dsCadCliente.FieldCount - 1 do begin
      if (dsCadCliente.Fields[vLoop].Required) and (dsCadCliente.Fields[vLoop].AsString = '') then begin
         showmessage('O campo '+dsCadCliente.Fields[vLoop].DisplayLabel+' é obrigatório');
         result := false;
         exit;
      end;
   end;
end;

function TDM.ValidaEmail(const Value: string): Boolean;
   // verifica se é um e-mail válido
   // true se é valido
   // false se NÃO é válido
   // função retirada da internet, validada e adaptada por Carlos Contucci em 01/11/2021
   function CheckAllowed(const s: string): Boolean;
   var
      i: Integer;
   begin
      Result := False;
      for i := 1 to Length(s) do
         if not(s[i] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '-', '.']) then
      Exit;
      Result := true;
  end;
var
  i: Integer;
  NamePart, ServerPart: string;
begin
  Result := False;
  i := Pos('@', Value);
  if i = 0 then
    Exit;
  NamePart := Copy(Value, 1, i - 1);
  ServerPart := Copy(Value, i + 1, Length(Value));
  if (Length(NamePart) = 0) or ((Length(ServerPart) < 5)) then
    Exit;
  i := Pos('.', ServerPart);
  if (i = 0) or (i > (Length(ServerPart) - 2)) then
    Exit;
  Result := CheckAllowed(NamePart) and CheckAllowed(ServerPart);
end;

function TDM.ValidaCPF: boolean;
var  dig10, dig11: string;
    s, i, r, peso: integer;
    cpf:string;
begin
   // verifica se é um CPF válido
   // true se é valido
   // false se NÃO é válido
   // função retirada da internet, validada e adaptada por Carlos Contucci em 01/11/2021

   result := true;

   cpf := dsCadClienteCPF.AsString;
   cpf := StringReplace(cpf,'_','',[rfReplaceAll]);
   cpf := StringReplace(cpf,'-','',[rfReplaceAll]);
   cpf := StringReplace(cpf,'.','',[rfReplaceAll]);

   // verifica se é uma alteração ou inclusão e se o CPF está preenchido
   // para seguir com a validação.
   // caso contrário a validação não faz sentido
   if (dsCadCliente.State in [dsEdit,dsInsert]) and (trim(cpf) <> '') then begin

   // length - retorna o tamanho da string (CPF é um número formado por 11 dígitos)
      if ((CPF = '00000000000') or (CPF = '11111111111') or
          (CPF = '22222222222') or (CPF = '33333333333') or
          (CPF = '44444444444') or (CPF = '55555555555') or
          (CPF = '66666666666') or (CPF = '77777777777') or
          (CPF = '88888888888') or (CPF = '99999999999') or
          (length(CPF) <> 11))
      then begin
         result := false;
         exit;
      end;

      // try - protege o código para eventuais erros de conversão de tipo na função StrToInt
      try
         { *-- Cálculo do 1o. Digito Verificador --* }
            s := 0;
            peso := 10;
         for i := 1 to 9 do
            begin
            // StrToInt converte o i-ésimo caractere do CPF em um número
               s := s + (StrToInt(CPF[i]) * peso);
               peso := peso - 1;
            end;
         r := 11 - (s mod 11);
         if ((r = 10) or (r = 11)) then
            dig10 := '0'
         else str(r:1, dig10); // converte um número no respectivo caractere numérico

         { *-- Cálculo do 2o. Digito Verificador --* }
         s := 0;
         peso := 11;
         for i := 1 to 10 do
            begin
               s := s + (StrToInt(CPF[i]) * peso);
               peso := peso - 1;
            end;
         r := 11 - (s mod 11);
         if ((r = 10) or (r = 11)) then
            dig11 := '0'
         else str(r:1, dig11);

         { Verifica se os digitos calculados conferem com os digitos informados. }
         if ((dig10 = CPF[10]) and (dig11 = CPF[11]))then
            result := true
         else result := false;
      except
         result := false
      end;
   end;
end;


procedure TDM.EnviarDados;
begin
   // envia as informações cadastrais da tela para o e-mail do usuário e
   // anexa um arquivo XML com as mesmas informações cadastrais
   if (dsCadCliente.State = dsBrowse) and (dsCadCliente.RecordCount > 0) then begin
      EnviarEmail(dsCadClienteEmail.AsString,CriarCorpo,CriarXMLTemp);
   end;
end;

procedure TDM.EnviarEmail(pDestino:string;pCorpo:TStrings;pAnexo:string);
var
   // função de envio de e-mail via componente INDY
   // extraída da internet, testada e validada por Carlos Contucci em 01/11/2021

  // variáveis e objetos necessários para o envio
  IdSSLIOHandlerSocket  : TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP                : TIdSMTP;
  IdMessage             : TIdMessage;
  IdText                : TIdText;
begin
  // instanciação dos objetos
  IdSSLIOHandlerSocket  := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
  IdSMTP                := TIdSMTP.Create(Self);
  IdMessage             := TIdMessage.Create(Self);

  try
    // Configuração do protocolo SSL (TIdSSLIOHandlerSocketOpenSSL)
    IdSSLIOHandlerSocket.SSLOptions.Method   := sslvSSLv23;
    IdSSLIOHandlerSocket.SSLOptions.Mode     := sslmClient;

    // Configuração do servidor SMTP (TIdSMTP)
    IdSMTP.IOHandler                   := IdSSLIOHandlerSocket;
    IdSMTP.UseTLS                      := utUseImplicitTLS;
    IdSMTP.AuthType                    := satDefault;
    IdSMTP.Port                        := 465;
    IdSMTP.Host                        := 'email-ssl.com.br';
    IdSMTP.Username                    := 'noreply-teste@gruporevenda.com.br';
    IdSMTP.Password                    := 'hg@#$%jsdg64jJJJ.';

    // Configuração da mensagem (TIdMessage)
    IdMessage.From.Address             := 'noreply-teste@gruporevenda.com.br';
    IdMessage.From.Name                := '[TESTE] NoReply - Info Sistemas';
    IdMessage.ReplyTo.EMailAddresses   := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text      := pDestino;
    IdMessage.Subject                  := 'Seu cadastro foi realizado com sucesso';
    IdMessage.Encoding                 := meMIME;

    // Configuração do corpo do email (TIdText)
    IdText                             := TIdText.Create(IdMessage.MessageParts);
    IdText.Body                        := pCorpo;
    IdText.ContentType                 := 'text/plain; charset=iso-8859-1';

    // Opcional - Anexo da mensagem (TIdAttachmentFile)
    if FileExists(pAnexo) then
    begin
      TIdAttachmentFile.Create(IdMessage.MessageParts, pAnexo);
    end;

    // Conexão e autenticação
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        MessageDlg('Erro na conexão ou autenticação: ' +
          E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    // Envio da mensagem
    try
      IdSMTP.Send(IdMessage);
      MessageDlg('Mensagem enviada com sucesso!', mtInformation, [mbOK], 0);
    except
      On E:Exception do
      begin
        MessageDlg('Erro ao enviar a mensagem: ' +
          E.Message, mtWarning, [mbOK], 0);
      end;
    end;
  finally
    // desconecta do servidor
    IdSMTP.Disconnect;
    // liberação da DLL
    UnLoadOpenSSLLibrary;
    // liberação dos objetos da memória
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;
end;


function TDM.CriarCorpo: TStrings;
var
   vLoop : integer;
begin
   // cria o corpo do e-mail a ser enviado para a pessoa que teve seu registro cadastrado
   // a funcção retornará um TStrings que será usada no procedimento de disparo de e-mail
   result := TStringList.Create;

   Result.Add('Olá! Seu registro está completo. Segue abaixo seus dados cadastrados e, em anexo, o arquivo comprovante.');
   Result.Add('');

   for vLoop := 0 to dsCadCliente.FieldCount - 1 do begin
      Result.Add(dsCadCliente.Fields[vLoop].DisplayLabel + ': ' + dsCadCliente.Fields[vLoop].AsString);
   end;

   Result.Add('');
   Result.Add('Agradecemos pelo contato e em breve entraremos em contato');
   Result.Add('');
   Result.Add('Equipe Info Sistemas');
end;

function TDM.CriarXMLTemp:string;
var
   XMLDocument  : TXMLDocument;
   NodeTabela, NodeRegistro, NodeEndereco: IXMLNode;
   vCpfAux      : string;
begin

   // Cria um arquivo XML temporário para anexar no envio do e-mail
   // o resultado (retorno) da função trará o nome e localização do arquivo temporário
   // para que a função de disparo de e-mail possa identificar o arquivo a ser anexado

   XMLDocument := TXMLDocument.Create(Self);
   try
      XMLDocument.Active := True;
      NodeTabela                                := XMLDocument.AddChild('Pessoa');
      NodeRegistro                              := NodeTabela.AddChild('Registro');

      NodeRegistro.ChildValues['cpf']           := dsCadCliente.FieldByName('cpf').AsString;
      NodeRegistro.ChildValues['nome']          := dsCadCliente.FieldByName('nome').AsString;
      NodeRegistro.ChildValues['identidade']    := dsCadCliente.FieldByName('identidade').AsString;
      NodeRegistro.ChildValues['ddd']           := dsCadCliente.FieldByName('ddd').AsString;
      NodeRegistro.ChildValues['telefone']      := dsCadCliente.FieldByName('telefone').AsString;
      NodeRegistro.ChildValues['email']         := dsCadCliente.FieldByName('email').AsString;

      NodeEndereco                              := NodeRegistro.AddChild('Endereco');
      NodeEndereco.ChildValues['Logradouro']    := dsCadCliente.FieldByName('logradouro').AsString;
      NodeEndereco.ChildValues['Numero']        := dsCadCliente.FieldByName('numero').AsString;
      NodeEndereco.ChildValues['complemento']   := dsCadCliente.FieldByName('complemento').AsString;
      NodeEndereco.ChildValues['bairro']        := dsCadCliente.FieldByName('bairro').AsString;
      NodeEndereco.ChildValues['cidade']        := dsCadCliente.FieldByName('cidade').AsString;
      NodeEndereco.ChildValues['estado']        := dsCadCliente.FieldByName('estado').AsString;
      NodeEndereco.ChildValues['pais']          := dsCadCliente.FieldByName('pais').AsString;

      // variárial apenas com os números do CPF para criar arquivo temporário de nome único
      vCpfAux  := dsCadCliente.FieldByName('cpf').AsString;
      vCpfAux  := StringReplace(vCpfAux,'-','',[rfReplaceAll]);
      vCpfAux  := StringReplace(vCpfAux,'.','',[rfReplaceAll]);

      result   := ExtractFileDir(Application.ExeName)+'\'+vCpfAux+'.xml';

      XMLDocument.SaveToFile(result);
   finally
      XMLDocument.Free;
   end;
end;

procedure TDM.dsCadClienteCEPSetText(Sender: TField; const Text: string);
begin

   // função responsável por buscar as informações do CEP na API viacep
   // e retornar os dados de endereço para seus respectivos campos
   // foi usada a ferramenta rest debugger para facilitar a criação dos componentes

   // busca CEP na API
   // verifica se o DS está em modo de edição o inserção para requisitar a API
   // desnecessariamente
   if dsCadCliente.State in [dsEdit, dsInsert] then begin
      rqCEP.params.ParameterByName('CEP').value := text;
      rqCEP.execute;

      // Verifica se algum dado foi encontrado
      if (tbCEP.FindField('logradouro') <> nil) then begin
         dsCadClienteLogradouro.AsString  :=  tbCEP.FieldByName('logradouro').AsString;
         dsCadClienteComplemento.AsString :=  tbCEP.FieldByName('complemento').AsString;
         dsCadClienteBairro.AsString      :=  tbCEP.FieldByName('bairro').AsString;
         dsCadClienteCidade.AsString      :=  tbCEP.FieldByName('localidade').AsString;
         dsCadClienteEstado.AsString      :=  tbCEP.FieldByName('uf').AsString;
         dsCadClienteDDD.AsString         :=  tbCEP.FieldByName('ddd').AsString;
      end else begin
         // caso não não tenha sido encontradas informações, informa o usuário,
         // mas não impede a continuidade do cadastro.
         showmessage('CEP não encontrado na base de dados. Por favor verifique se a informação está correta.');
      end;
   end;
   Sender.Value := text;
end;

end.
