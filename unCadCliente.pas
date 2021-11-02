{
   Tela:       Cadastro de Clientes
   Autor:      Carlos Contucci
   Data:       01/11/2021
   Proposito:  Teste técnico de candidatura a vaga Info Sistemas
}

unit unCadCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Data.DB,
  Datasnap.Provider, Datasnap.DBClient, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, System.Json, System.UITypes,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Client, IPPeerClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, Vcl.Bind.Grid, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.Grid, Data.Bind.DBScope,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, Xml.xmldom,
  Xml.XMLIntf, Xml.XMLDoc, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdMessage, System.Actions, Vcl.ActnList, Vcl.ExtActns, IdAttachmentFile,
  IdAttachmentMemory, IdAttachment, idGlobal, IdText;

type
  TfrCadCliente = class(TForm)
    pgCadCliente: TPageControl;
    tbLista: TTabSheet;
    tbDados: TTabSheet;
    pnCadCliente: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Bevel1: TBevel;
    edCPF: TDBEdit;
    edNome: TDBEdit;
    edIdentidade: TDBEdit;
    edDDD: TDBEdit;
    edTelefone: TDBEdit;
    edEmail: TDBEdit;
    edCEP: TDBEdit;
    edLogradouro: TDBEdit;
    edNumero: TDBEdit;
    edComplemento: TDBEdit;
    edBairro: TDBEdit;
    edCidade: TDBEdit;
    edEstado: TDBEdit;
    edPais: TDBEdit;
    btIncluir: TButton;
    btSalvar: TButton;
    btCancelar: TButton;
    btExcluir: TButton;
    grCadCliente: TDBGrid;
    scCadCliente: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btIncluirClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure BotoesPreparar(Sender: TObject);
    procedure edCPFExit(Sender: TObject);
    procedure edEmailExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frCadCliente: TfrCadCliente;

implementation

{$R *.dfm}

uses unDM;

procedure TfrCadCliente.BotoesPreparar(Sender: TObject);
begin
   // Habilita/Desabilita os botões de acordo com o estado do DatSet
   if (scCadCliente.DataSet.State in [dsEdit,dsInsert]) then begin
      btIncluir.Enabled    := false;
      btSalvar.Enabled     := true;
      btCancelar.Enabled   := true;
      btExcluir.Enabled    := false;
   end
   else begin
      btIncluir.Enabled    := true;
      btSalvar.Enabled     := false;
      btCancelar.Enabled   := false;

      if (scCadCliente.DataSet.RecordCount > 0) then
         btExcluir.Enabled := true
      else btExcluir.Enabled := false;
   end;
end;

procedure TfrCadCliente.btCancelarClick(Sender: TObject);
begin
   scCadCliente.DataSet.Cancel;
end;

procedure TfrCadCliente.btExcluirClick(Sender: TObject);
begin
   // Solicita ao usuário a confirmação para exclusão de registro
   if MessageDlg('Deseja realmente excluir esse registro?' +#13+
                 'Os dados excluídos não poderão ser recuperados.',
                 mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrNo then
      MessageDlg('Nenhuma alteração no registro foi realizada.', mtInformation, [mbOk], 0, mbOk)
   else scCadCliente.DataSet.Delete;
end;

procedure TfrCadCliente.btIncluirClick(Sender: TObject);
begin
   scCadCliente.DataSet.Append;
   edCPF.SetFocus;
end;

procedure TfrCadCliente.btSalvarClick(Sender: TObject);
begin
   // valida campos obrigatórios antes de permitir salvar o registro
   if DM.ValidaCamposObrigatorios then begin
      scCadCliente.DataSet.Post;
      DM.EnviarDados;
   end;
end;

procedure TfrCadCliente.edCPFExit(Sender: TObject);
begin
   // verifica se o CPF é valido
   if (edCPF.Text <> '') then begin
      if not DM.ValidaCPF then begin
         showmessage('CPF inválido');
         edCPF.SetFocus;
      end;
   end;
end;

procedure TfrCadCliente.edEmailExit(Sender: TObject);
begin
   // verifica se o email é valido
   if (edEmail.Text <> '') then begin
      if not DM.ValidaEmail(edEmail.Text) then begin
         showmessage('Email inválido');
         edEmail.SetFocus;
      end;
   end;
end;

procedure TfrCadCliente.FormCreate(Sender: TObject);
begin
   // prepara ClientDataSet para cadastros
   DM.dsCadCliente.CreateDataSet;
   pgCadCliente.ActivePage := tbDados;
end;

end.
