unit embed_api;

interface

uses
  SysUtils, Classes, embed_lib;

type
  TEmbedApi = class
  private
    { Private declarations }
    keyCode: string;
    lib: TEmbedLib;
    const
      KEY_CODE = 'resultado.chave_pix';
      STATUS_CODE = 'resultado.status_code';
  public
    constructor Create;
    destructor Destroy;
    function Configurar: string;
    function Iniciar: string;
    function GerarPagamento(Valor: string): string;
    function GerarEstorno(Valor: string; IdTx: string; IdE2E: string): string;
    function GeyKeyCode(): string;
    function GetStatus: string;
    function Finalizar: string;
  end;

implementation

constructor TEmbedApi.Create;
begin
  keyCode := '';
  lib := TEmbedLib.Create('lib-embed-x86.dll');
  inherited Create;
end;

destructor TEmbedApi.Destroy;
begin
  lib.Free;
end;

function TEmbedApi.Configurar: string;
begin
  var Produto := 'pix'; // PIX como produto de pagamento
  var SubProduto := '2'; // SubProduto do PIX (pode ser o banco ou parceiro)
  var Timeout := '300'; // Timeout para o tempo de cada operação
  var Username := 'ef2f515f-95d5-487e-9398-0df168db2044'; // Nome de usuário fornecido
  var Password := '1E4WwfmTMJGyrJEkRSE8BRG'; // Senha fornecida
  var Documento := '52548677000162'; // Documento informado para cadastro
  var Input := Produto + ';'
            + SubProduto + ';'
            + Timeout + ';'
            + Username + ';'
            + Password + ';'
            + Documento;
  var Output := lib.Configurar(Input);
end;

function TEmbedApi.Iniciar: string;
begin
  var Operacao := 'pix';
  var Output := lib.Iniciar(Operacao);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.GerarPagamento(Valor: string): string;
begin
  var Operacao := 'get_pagamento';
  var Input := Operacao + ';' + Valor;
  var Output := lib.Processar(Input);
  keyCode := lib.ObterValor(Output, KEY_CODE);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.GerarEstorno(Valor: string; IdTx: string; IdE2E: string): string;
begin
  var Operacao := 'get_estorno';
  var Input := Operacao + ';'
            + Valor + ';'
            + IdTx + ';'
            + IdE2E + ';';
  var Output := lib.Processar(Input);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.GeyKeyCode: string;
begin
  Result := keyCode;
end;

function TEmbedApi.GetStatus: string;
begin
  var Operacao := 'get_status';
  var Output := lib.Processar(Operacao);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

function TEmbedApi.Finalizar: string;
begin
  var Operacao := '';
  var Output := lib.Finalizar(Operacao);
  Result := lib.ObterValor(Output, STATUS_CODE);
end;

end.

