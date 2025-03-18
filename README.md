![embed](https://github.com/user-attachments/assets/9d78c555-3f53-483b-987c-98ec533f3fa3)

Exemplo demonstrativo para o uso da `lib-embed` no transações com PIX.

## Instalação

### Requisitos

É necessário ter o Delphi instalado em sua máquina.

### Clonar

```git
git clone git@github.com:embed-labs/example-lib-embed-delphi-pix.git
```

### Configurações 

Para iniciar o processo, nosso time de suporte e integração irá disponibilizar as credenciais para os testes.

### Sobre o exemplo
Este exemplo contem três itens fundamentais:

1. embed_lib.pas: carregamemento das bibliotecas
2. embed_api.pas: utilização dos métodos para transações/operações com PIX
3. embed_ui.pas: interface gráfica simplificada que consome os métodos

## API

### Fluxos
Vamos definir o fluxo que deve ser seguido para que sua implementação seja realizada seguindo as melhores práticas no uso da nossa API

![fluxo-geral](https://github.com/user-attachments/assets/fb62c910-0027-443f-ad99-8898f368cb1f)

### Métodos

#### 1. Configurar 

Este método realiza a configuração do produto, para este caso PIX

##### 1.1. Assinatura

```c++
char* embed_configurar(char* input);
```

##### 1.2. Parâmetros

Aqui estão as definições para _input_ e _output_ para este método

###### 1.2.1. Input

Pode ser parametrizado de duas maneiras:

1. JSON
```json
{
    "configs": {
        "produto": "pix",                                        
        "sub_produto": "2",                                       
            "infos": {
            "timeout": "300",                
            "username": "",             // gerado pelo time de integração
            "password": "",             // gerado pelo time de integração
            "documento": ""             // documento informado para cadastro
        }
    }
}
```
2. Metaparâmetro (obedecendo a sequência)
```c
"pix;2;timeout;username;password;documento"
```

###### 1.2.2. Output

O retorno para este método consiste em um Json (sempre), no seguinte formato:

```json
{
  "codigo": 0,
  "mensagem": "Sucesso"
}
```

#### 2. Iniciar

Este método realiza a inicialização do produto, para este caso POS

##### 2.1. Assinatura

```c++
char* embed_iniciar(char* input);
```

##### 2.2. Parâmetros

Aqui estão as definições para _input_ e _output_ para este método.

###### 2.2.1. Input

Pode ser parametrizado de duas maneiras:

1. JSON
```json
{
    "iniciar": {
        "operacao": "pix"
    }
}
```
2. Metaparâmetro
```c
"pix"
```

###### 2.2.2. Output

O retorno para este método consiste em um JSON (sempre), no seguinte formato:

```json
{
    "codigo": 0,
    "mensagem": "Sucesso",
    "resultado": {
        "status_code": 0,
        "status_message": "iniciado"
    }
}
```

#### 3. Processar

Este método realiza o processamento de transações POS

##### 3.1. Assinatura

```c++
char* embed_processar(char* input);
```

##### 3.2. Parâmetros

Aqui estão as definições para _input_ e _output_ para este método.

###### 3.2.1. Input

Temos cinco modalidades de processamento que podem ser realizadas:
1. get_pagamento
2. get_estorno
5. get_status (transação atual)

Estas modalidades podem ser parametrizadas de duas formas:

1. JSON
```json
// Get Pagamento
{
    "processar": {
        "operacao": "get_pagamento",    // get_pagamento 
        "valor": ""                     // em centavos (se R$ 1,00 logo 100)
    }
}
// Get Reembolso
{
    "processar": {
        "operacao": "get_reembolso",    // get_reembolso
        "valor": "",                    // em centavos (se R$ 1,00 logo 100)
        "tid": "",                      // id da transação pix
        "e2eid": ""                     // id da transferencia entre bancos
    }
}
// Get Status
{
    "processar": {
        "operacao": "get_status",       // get_estorno
        "tid": ""                       // id da transação pix (opcional)
    }
}
```
2. Metaparâmetro (obedecendo a sequência)
```c
// Get Pagamento
"get_pagamento;valor"
// Get Reembolso
"get_reembolso;valor"
// Get Status
"get_status"
```
###### 3.2.2. Output

O retorno para este método consiste em um JSON (sempre), no seguinte formato:

```json
{
    "codigo": 0,
    "mensagem": "Sucesso",
    "resultado": {
        "status_code": 1,
        "status_message": "iniciado",
        "chave_pix": "",                // chave pix para pagamento (copia e cola)
        "tid": "",                      // id da transação pix
        "e2eid": ""                     // id da transferencia entre bancos
    }
}
```

#### 4. Finalizar

Este método realiza a finalização de transações POS

##### 4.1. Assinatura

```c++
char* embed_finalizar(char* input);
```

##### 4.2. Parâmetros

Aqui estão as definições para os _inputs_ e _output_ para este método.

###### 4.2.1. Input

Pode ser parametrizado de duas maneiras:

1. JSON
```json
{
    "finalizar": {
        "operacao": "",
    }
}
```
2. Metaparâmetro
```c
""
```

###### 4.2.2. Output

O retorno para este método consiste em um JSON (sempre), no seguinte formato:

```json
{
    "codigo": 0,
    "mensagem": "Sucesso",
    "resultado": {
        "status_code": 1,
        "status_message": "iniciado"
    }
}
```

#### 5. Obter Valor

Este método responsável por buscar um valor contido em uma chave ou objeto de um JSON válido. 

##### 5.1. Assinatura

```c++
char* embed_obter_valor(char* json, char* key);
```

##### 5.2. Parâmetros

Aqui estão as definições para os _inputs_ e _output_ para este método.

###### 5.2.1. Input

Deve ser informado sempre um String com conteúdo JSON.

```json
// Json
{
    "key1": "value1",
    "key2": {
        "key21": "value21",
        "key22": "value22",
        "key23": "value23",
        "key24": "value24",
        "key25": "value25"
    }
}
```
```c
// Key
"key2.key25"
```

###### 5.2.2. Output

Será um String com valor informado em _key_ se conter em _json_ 

```c
// Value
"value25"
```

### Retornos 

Os possíveis retornos para os métodos utilizando o produto POS conforme as tabelas abaixo

| codigo | mensagem |
| - | - |
| 0 | Sucesso | 
| -1 | Erro |
| -2 | Deserialize |
| -3 | ProviderError |
| -11 | PixError |
| -12 | PixMissingParameter |
| -13 | PixInvalidOperation |
| -14 | PixInputBadFormat |
| -15 | PixTransactionError |

| status_code | status_message |
| - | - |
| -1 | erro |
| 0 | finalizado |
| 1 | processando |
