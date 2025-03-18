unit embed_ui;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, System.NetEncoding, Vcl.Imaging.pngimage, embed_api;

type
  TEmbedUi = class(TForm)
    BtnGetPagamento: TButton;
    BtnGetEstorno: TButton;
    ImgEmbed: TImage;
    EditLink: TEdit;
    procedure BtnGetPagamentoClick(Sender: TObject);
    procedure BtnGetEstornoClick(Sender: TObject);
    procedure ShowStatus(Status: string);
  private
    { Private declarations }
    api: TEmbedApi;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  EmbedUi: TEmbedUi;

implementation

{$R *.dfm}

constructor TEmbedUi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  api := TEmbedApi.Create;
  api.Configurar;
end;

procedure TEmbedUi.BtnGetPagamentoClick(Sender: TObject);
var
  ValorStr, Output: string;
begin
  ValorStr := InputBox('Pix - Pagamento', 'Digite o valor (em centavos):', '');
  api.Iniciar();
  ShowStatus('[PIX] Iniciado');
  Output := api.GerarPagamento(ValorStr);
  EditLink.Text := api.GeyKeyCode;
  if Output = '1' then
  begin
    ShowStatus('[PIX] Pagamento');
    while Output = '1' do
    begin
      Output := api.GetStatus;
      if Output = '0' then
        ShowStatus('[PIX] Autorizado')
      else if Output = '-1' then
        ShowStatus('[PIX] Falha no processamento')
      else
        ShowStatus('[PIX] Processando');
    end;
    EditLink.Text := '';
    Output := api.Finalizar;
    if Output = '0' then
        ShowStatus('[PIX] Finalizado')
    else
      ShowStatus('[PIX] Falha na confirmação');
  end
  else
  begin
    ShowStatus('[PIX] Falha ao iniciar pagamento');
  end;
end;

procedure TEmbedUi.BtnGetEstornoClick(Sender: TObject);
var
  ValorStr, IdTxStr, IdE2EStr, Output: string;
begin
  ValorStr := InputBox('Pix - Estorno', 'Digite o valor (em centavos):', '');
  IdTxStr := InputBox('Pix - Estorno', 'Digite o ID da transação (TXID):', '');
  IdE2EStr := InputBox('Pix - Estorno', 'Digite o ID da transação ponta-a-ponta (E2EID):', '');
  api.Iniciar();
  ShowStatus('[PIX] Iniciado');
  Output := api.GerarEstorno(ValorStr, IdTxStr, IdE2EStr);
  if Output = '1' then
  begin
    ShowStatus('[PIX] Estorno');
    while Output = '1' do
    begin
      Output := api.GetStatus;
      if Output = '0' then
        ShowStatus('[PIX] Autorizado')
      else if Output = '-1' then
        ShowStatus('[PIX] Falha no processamento')
      else
        ShowStatus('[PIX] Processando');
    end;
    Output := api.Finalizar;
    if Output = '0' then
        ShowStatus('[PIX] Finalizado')
    else
      ShowStatus('[PIX] Falha na confirmação');
  end
  else
  begin
    ShowStatus('[PIX] Falha ao iniciar pagamento');
  end;
end;

procedure TEmbedUi.ShowStatus(Status: string);
begin
  ShowMessage(Status);
end;

end.
