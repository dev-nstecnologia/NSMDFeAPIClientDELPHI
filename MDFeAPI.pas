unit MDFeAPI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, IdHTTP, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack,
  IdSSL, IdSSLOpenSSL, ShellApi, IdCoderMIME, EncdDecd;

// Assinatura das funções
function enviaConteudoParaAPI(conteudoEnviar, url, tpConteudo: String): String;
function emitirMDFeSincrono(conteudo, tpConteudo, CNPJ, tpDown,
  tpAmb: String; caminho: String; exibeNaTela: boolean = false): String;
function emitirMDFe(conteudo, tpConteudo: String): String;
function consultarStatusProcessamento(CNPJ, nsNRec, tpAmb: String): String;
function downloadMDFe(chMDFe, tpDown, tpAmb: String): String;
function downloadEventoMDFe(chMDFe, tpDown, tpAmb, tpEvento,
  nSeqEvento: String): String;
function downloadMDFeESalvar(chMDFe, tpDown, tpAmb: String;
  caminho: String = ''; exibeNaTela: boolean = false): String;
function downloadEventoMDFeESalvar(chMDFe, tpDown, tpAmb, tpEvento,
  nSeqEvento: String; caminho: String = '';
  exibeNaTela: boolean = false): String;
function cancelarMDFe(chMDFe, tpAmb, dhEvento, nProt, xJust, tpDown,
  caminho: String; exibeNaTela: boolean = false): String;
function encerrarMDFe(chMDFe, nProt, dhEvento, dtEnc, cUF, cMun, tpAmb, tpDown,
 caminho: String; exibeNaTela: boolean = false): String;
function incluirCondutorMDFe(chMDFe, tpDown, tpAmb, dhEvento, xNome, CPF,
 nSeqEvento, caminho: String; exibeNaTela: boolean = false): String;
function consultarMDFeNaoEcerrada(tpAmb, cUF, CNPJ:String): String;
function listarNSNRecs(chMDFe:String):String;
function salvarXML(xml, caminho, chMDFe: String; tpEvento: String = ''; nSeqEvento: String = ''): String;
function salvarJSON(json, caminho, chMDFe: String; tpEvento: String = ''; nSeqEvento: String = ''): String;
function salvarPDF(pdf, caminho, chMDFe: String; tpEvento: String = ''; nSeqEvento: String = ''): String;
procedure gravaLinhaLog(conteudo: String);

implementation

uses
  System.json;

var
  token: String = 'COLOQUE_TOKEN';

  // Função genérica de envio para um url, contendo o token no header
function enviaConteudoParaAPI(conteudoEnviar, url, tpConteudo: String): String;
var
  retorno: String;
  conteudo: TStringStream;
  HTTP: TIdHTTP; // Disponível na aba 'Indy Servers'
  IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
  // Disponivel na aba Indy I/O Handlers
begin
  conteudo := TStringStream.Create(conteudoEnviar, TEncoding.UTF8);
  HTTP := TIdHTTP.Create(nil);
  try
    if tpConteudo = 'txt' then // Informa que vai mandar um TXT
    begin
      HTTP.Request.ContentType := 'text/plain;charset=utf-8';
    end
    else if tpConteudo = 'xml' then // Se for XML
    begin
      HTTP.Request.ContentType := 'application/xml;charset=utf-8';
    end
    else // JSON
    begin
      HTTP.Request.ContentType := 'application/json;charset=utf-8';
    end;

    // Abre SSL
    IdSSLIOHandlerSocketOpenSSL1 := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    HTTP.IOHandler := IdSSLIOHandlerSocketOpenSSL1;

    // Avisa o uso de UTF-8
    HTTP.Request.ContentEncoding := 'UTF-8';

    // Adiciona o token ao header
    HTTP.Request.CustomHeaders.Values['X-AUTH-TOKEN'] := token;
    // Result := conteudo.ToString;
    // Faz o envio por POST do json para a url
    try
      retorno := HTTP.Post(url, conteudo);

    except
      on E: EIdHTTPProtocolException do
        retorno := E.ErrorMessage;
      on E: Exception do
        retorno := E.Message;
    end;

  finally
    conteudo.Free();
    HTTP.Free();
  end;

  // Devolve o json de retorno da API
  Result := retorno;
end;

// Esta função emite uma NF-e de forma síncrona, fazendo o envio, a consulta e o download da nota
function emitirMDFeSincrono(conteudo, tpConteudo, CNPJ, tpDown, tpAmb: String;
 caminho: String; exibeNaTela: boolean = false): String;
var
  retorno, resposta: String;
  motivo, nsNRec: String;
  statusEnvio, statusConsulta, statusDownload: String;
  erros: TJSONValue;
  chMDFe, cStat, nProt: String;
  jsonRetorno, jsonAux: TJSONObject;
  aux: String;
begin

  statusEnvio := '';
  statusConsulta := '';
  statusDownload := '';
  motivo := '';
  nsNRec := '';
  erros := TJSONString.Create('');
  chMDFe := '';
  cStat := '';
  nProt := '';

  resposta := emitirMDFe(conteudo, tpConteudo);
  jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(resposta),
    0) as TJSONObject;
  statusEnvio := jsonRetorno.GetValue('status').Value;

  if (statusEnvio = '200') or (statusEnvio = '-6') then
  begin
    nsNRec := jsonRetorno.GetValue('nsNRec').Value;

    sleep(500);

    resposta := consultarStatusProcessamento(CNPJ, nsNRec, tpAmb);
    jsonRetorno := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes(resposta), 0) as TJSONObject;
    statusConsulta := jsonRetorno.GetValue('status').Value;

    if (statusConsulta = '200') then
    begin

      cStat := jsonRetorno.GetValue('cStat').Value;

      if (cStat = '100') then
      begin

        chMDFe := jsonRetorno.GetValue('chMDFe').Value;
        nProt := jsonRetorno.GetValue('nProt').Value;
        motivo := jsonRetorno.GetValue('xMotivo').Value;

        resposta := downloadMDFeESalvar(chMDFe, tpDown, tpAmb, caminho,
          exibeNaTela);
        jsonRetorno := TJSONObject.ParseJSONValue
          (TEncoding.ASCII.GetBytes(resposta), 0) as TJSONObject;
        statusDownload := jsonRetorno.GetValue('status').Value;

        if (statusDownload <> '200') then
        begin
          motivo := jsonRetorno.GetValue('motivo').Value;
        end;

      end
      else if (statusConsulta = '-2') then
      begin
        erros := jsonRetorno.Get('erro').JsonValue;
        jsonAux := TJSONObject.ParseJSONValue
        (TEncoding.ASCII.GetBytes(erros.ToString), 0) as TJSONObject;

        motivo := jsonAux.GetValue('xMotivo').Value;
        cStat := jsonAux.GetValue('cStat').Value;
      end
      else
      begin
        motivo := jsonRetorno.GetValue('xMotivo').Value;
      end;

    end
    else
    begin
      motivo := jsonRetorno.GetValue('motivo').Value;
    end;

  end

  else if (statusEnvio = '-5') then
  begin
    erros := jsonRetorno.Get('erro').JsonValue;
    jsonAux := TJSONObject.ParseJSONValue
     (TEncoding.ASCII.GetBytes(erros.ToString), 0) as TJSONObject;

    motivo := jsonAux.GetValue('xMotivo').Value;
    cStat := jsonAux.GetValue('cStat').Value;
  end

  else if (statusEnvio = '-4') or (statusEnvio = '-2') then
  begin
    motivo := jsonRetorno.GetValue('motivo').Value;

    try
      erros := jsonRetorno.Get('erros').JsonValue;
    except
    end;
  end

  else if (statusEnvio = '-999') then
  begin

    erros := jsonRetorno.Get('erro').JsonValue;
    jsonAux := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes(erros.ToString), 0) as TJSONObject;
    motivo := jsonAux.GetValue('xMotivo').Value;

  end
  else
  begin
    try
      motivo := jsonRetorno.GetValue('motivo').Value;
    except
      motivo := jsonRetorno.ToString;
    end;
  end;

  retorno := '{';
  retorno := retorno + '"statusEnviostatus": "' + statusEnvio + '",';
  retorno := retorno + '"statusConsulta": "'    + statusConsulta + '",';
  retorno := retorno + '"statusDownload": "'    + statusDownload + '",';
  retorno := retorno + '"cStat": "'             + cStat  + '",';
  retorno := retorno + '"chMDFe": "'            + chMDFe  + '",';
  retorno := retorno + '"nProt": "'             + nProt  + '",';
  retorno := retorno + '"motivo": "'            + motivo + '",';
  retorno := retorno + '"nsNRec": "'            + nsNRec + '",';
  retorno := retorno + '"erros": '              + erros.ToString;
  retorno := retorno + '}';

  gravaLinhaLog('[JSON_RETORNO]');
  gravaLinhaLog(retorno);
  gravaLinhaLog('');

  Result := retorno;
end;

// Emitir NF-e
function emitirMDFe(conteudo, tpConteudo: String): String;
var
  url, resposta: String;
begin
  url := 'https://mdfe.ns.eti.br/mdfe/issue';

  gravaLinhaLog('[ENVIO_DADOS]');
  gravaLinhaLog(conteudo);

  resposta := enviaConteudoParaAPI(conteudo, url, tpConteudo);

  gravaLinhaLog('[ENVIO_RESPOSTA]');
  gravaLinhaLog(resposta);

  Result := resposta;
end;

// Consultar Status de Processamento
function consultarStatusProcessamento(CNPJ, nsNRec, tpAmb: String): String;
var
  json: String;
  url, resposta: String;
begin

  json := '{' +
              '"CNPJ": "'         + CNPJ   + '",' +
              '"nsNRec": "'       + nsNRec + '",' +
              '"tpAmb": "'        + tpAmb  + '"'  +
          '}';

  url := 'https://mdfe.ns.eti.br/mdfe/issue/status';

  gravaLinhaLog('[CONSULTA_DADOS]');
  gravaLinhaLog(json);

  resposta := enviaConteudoParaAPI(json, url, 'json');

  gravaLinhaLog('[CONSULTA_RESPOSTA]');
  gravaLinhaLog(resposta);

  Result := resposta;
end;

// Download da NF-e
function downloadMDFe(chMDFe, tpDown, tpAmb: String): String;
var
  json: String;
  url, resposta, status: String;
  jsonRetorno: TJSONObject;
begin

  json := '{' +
              '"chMDFe": "'        + chMDFe  + '",' +
              '"tpDown": "'       + tpDown + '",' +
              '"tpAmb": "'        + tpAmb  + '"'  +
          '}';

  url := 'https://mdfe.ns.eti.br/mdfe/get';

  gravaLinhaLog('[DOWNLOAD_MDFE_DADOS]');
  gravaLinhaLog(json);

  resposta := enviaConteudoParaAPI(json, url, 'json');

  jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(resposta),
    0) as TJSONObject;
  status := jsonRetorno.GetValue('status').Value;

  if (status <> '200') then
  begin
    gravaLinhaLog('[DOWNLOAD_MDFE_RESPOSTA]');
    gravaLinhaLog(resposta);
  end
  else
  begin
    gravaLinhaLog('[DOWNLOAD_MDFE_STATUS]');
    gravaLinhaLog(status);
  end;

  Result := resposta;
end;

// Download da NF-e e Salvar
function downloadMDFeESalvar(chMDFe, tpDown, tpAmb: String;
  caminho: String = ''; exibeNaTela: boolean = false): String;
var
  baixarXML, baixarPDF, baixarJSON: boolean;
  xml, json, pdf: String;
  status, resposta: String;
  jsonRetorno: TJSONObject;
begin

  resposta := downloadMDFe(chMDFe, tpDown, tpAmb);
  jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(resposta),
    0) as TJSONObject;
  status := jsonRetorno.GetValue('status').Value;

  // Se o retorno da API for positivo, salva o que foi solicitado
  if status = '200' then
  begin
    if not DirectoryExists(caminho) then
      CreateDir(caminho);

    // Checa se deve baixar XML
    if Pos('X', tpDown) <> 0 then
    begin
      xml := jsonRetorno.GetValue('xml').Value;
      salvarXML(xml, caminho, chMDFe);
    end;

    // Checa se deve baixar JSON
    if Pos('J', tpDown) <> 0 then
    begin
      json := jsonRetorno.GetValue('mdfeProc').ToString;
      salvarJSON(json, caminho, chMDFe);
    end;

    // Checa se deve baixar PDF
    if Pos('P', tpDown) <> 0 then
    begin
      pdf := jsonRetorno.GetValue('pdf').Value;
      salvarPDF(pdf, caminho, chMDFe);

      if exibeNaTela then
        ShellExecute(0, nil, PChar(caminho + chMDFe + '-MDFe.pdf'), nil, nil,
          SW_SHOWNORMAL);
    end;

  end
  else
  begin
    Showmessage('Ocorreu um erro, veja o Retorno da API para mais informações');
  end;

  Result := resposta;
end;

// Download do Evento da NF-e
function downloadEventoMDFe(chMDFe, tpDown, tpAmb, tpEvento,
  nSeqEvento: String): String;
var
  json: String;
  url, resposta, status: String;
  jsonRetorno: TJSONObject;
begin

  json := '{' +
              '"chMDFe": "' + chMDFe + '",' +
              '"tpAmb": "' + tpAmb + '",' +
              '"tpDown": "' + tpDown + '",' +
              '"tpEvento": "' + tpEvento + '",' +
              '"nSeqEvento": "' + nSeqEvento + '"' +
          '}';

  url := 'https://mdfe.ns.eti.br/mdfe/get/event';

  gravaLinhaLog('[DOWNLOAD_EVENTO_DADOS]');
  gravaLinhaLog(json);

  resposta := enviaConteudoParaAPI(json, url, 'json');
  jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(resposta),
    0) as TJSONObject;
  status := jsonRetorno.GetValue('status').Value;

  if (status <> '200') then
  begin
    gravaLinhaLog('[DOWNLOAD_EVENTO_RESPOSTA]');
    gravaLinhaLog(resposta);
  end
  else
  begin
    gravaLinhaLog('[DOWNLOAD_EVENTO_STATUS]');
    gravaLinhaLog(status);
  end;

  Result := resposta;
end;

// DDownload do Evento da NF-e e Salvar
function downloadEventoMDFeESalvar(chMDFe, tpDown, tpAmb, tpEvento,
  nSeqEvento: String; caminho: String = '';
  exibeNaTela: boolean = false): String;
var
  baixarXML, baixarPDF, baixarJSON: boolean;
  xml, json, pdf: String;
  status, resposta, tpEventoSalvar: String;
  jsonRetorno: TJSONObject;
begin

  resposta := downloadEventoMDFe(chMDFe, tpDown, tpAmb, tpEvento,
    nSeqEvento);
  jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(resposta),
    0) as TJSONObject;
  status := jsonRetorno.GetValue('status').Value;

  // Se o retorno da API for positivo, salva o que foi solicitado
  if status = '200' then
  begin

    // Checa qual o tipo de evento para salvar no nome do arquivo
    if (tpEvento.ToUpper = 'CANC') then
    begin
       tpEventoSalvar := '110111';
    end
    else if (tpEvento.ToUpper = 'ENC') then
    begin
       tpEventoSalvar := '110112';
    end
    else
    begin
       tpEventoSalvar := '110114';
    end;


    // Checa se deve baixar XML
    if Pos('X', tpDown) <> 0 then
    begin
      xml := jsonRetorno.GetValue('xml').Value;
      salvarXML(xml, caminho, chMDFe, tpEventoSalvar, nSeqEvento)
    end;

    // Checa se deve baixar JSON
    if Pos('J', tpDown) <> 0 then
    begin
      json := jsonRetorno.GetValue('json').ToString;
      salvarJSON(json, caminho, chMDFe, tpEventoSalvar, nSeqEvento);
    end;

    // Checa se deve baixar PDF
    if Pos('P', tpDown) <> 0 then
    begin
      pdf := jsonRetorno.GetValue('pdf').Value;
      salvarPDF(pdf, caminho, chMDFe, tpEventoSalvar, nSeqEvento);
      if exibeNaTela then
        ShellExecute(0, nil, PChar(caminho + tpEventoSalvar + chMDFe + nSeqEvento + '-MDFe.pdf'),
        nil, nil, SW_SHOWNORMAL);
    end;

  end
  else
  begin
    Showmessage('Ocorreu um erro, veja o Retorno da API para mais informações');
  end;

  // Devolve o retorno da API
  Result := resposta;
end;

// Realizar o cancelamento da NF-e
function cancelarMDFe(chMDFe, tpAmb, dhEvento, nProt, xJust, tpDown,
  caminho: String; exibeNaTela: boolean = false): String;
var
  json: String;
  url, resposta, respostaDownload: String;
  status: String;
  jsonRetorno: TJSONObject;
begin

  json := '{' +
              '"chMDFe": "'       + chMDFe   + '",' +
              '"tpAmb": "'        + tpAmb    + '",' +
              '"dhEvento": "'     + dhEvento + '",' +
              '"nProt": "'        + nProt    + '",' +
              '"xJust": "'        + xJust    + '"'  +
          '}';

  url := 'https://mdfe.ns.eti.br/mdfe/cancel';

  gravaLinhaLog('[CANCELAMENTO_DADOS]');
  gravaLinhaLog(json);

  resposta := enviaConteudoParaAPI(json, url, 'json');

  gravaLinhaLog('[CANCELAMENTO_RESPOSTA]');
  gravaLinhaLog(resposta);

  jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(resposta),
    0) as TJSONObject;
  status := jsonRetorno.GetValue('status').Value;

  if (status = '200') then
  begin
    respostaDownload := downloadEventoMDFeESalvar(chMDFe, tpDown, tpAmb,
      'CANC', '1', caminho, exibeNaTela);

    jsonRetorno := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes(respostaDownload), 0) as TJSONObject;
    status := jsonRetorno.GetValue('status').Value;

    if (status <> '200') then
    begin
      ShowMessage('Ocorreu um erro ao fazer o download. Verifique os logs.')
    end;

  end;

  Result := resposta;
end;

// Realizar a Carta de Correção da NF-e
function encerrarMDFe(chMDFe, nProt, dhEvento, dtEnc, cUF, cMun, tpAmb, tpDown,
 caminho: String; exibeNaTela: boolean = false): String;
var
  json: String;
  url, resposta, respostaDownload: String;
  status: String;
  jsonRetorno: TJSONObject;
begin

  json := '{' +
              '"chMDFe": "'    + chMDFe      + '",' +
              '"nProt": "'     + nProt      + '",' +
              '"dtEnc": "'     + dtEnc      + '",' +
              '"cUF": "'       + cUF        + '",' +
              '"cMun": "'      + cMun       + '",' +
              '"tpAmb": "'     + tpAmb      + '",' +
              '"dhEvento": "'  + dhEvento   + '"'  +
          '}';

  url := 'https://mdfe.ns.eti.br/mdfe/closure';

  gravaLinhaLog('[ENCERRAMENTO_DADOS]');
  gravaLinhaLog(json);

  resposta := enviaConteudoParaAPI(json, url, 'json');

  gravaLinhaLog('[ENCERRAMENTO_RESPOSTA]');
  gravaLinhaLog(resposta);

  jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(resposta),
    0) as TJSONObject;
  status := jsonRetorno.GetValue('status').Value;

  if (status = '200') then
  begin
    respostaDownload := downloadEventoMDFeESalvar(chMDFe, tpDown, tpAmb,
      'ENC', '1', caminho, exibeNaTela);

    jsonRetorno := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes(respostaDownload), 0) as TJSONObject;
    status := jsonRetorno.GetValue('status').Value;

    if (status <> '200') then
    begin
      ShowMessage('Ocorreu um erro ao fazer o download. Verifique os logs.')
    end;
  end;

  Result := resposta;
end;

function incluirCondutorMDFe(chMDFe, tpDown, tpAmb, dhEvento, xNome, CPF,
 nSeqEvento, caminho: String; exibeNaTela: boolean = false): String;
var
  json: String;
  url, resposta, respostaDownload: String;
  status: String;
  jsonRetorno: TJSONObject;
begin

  json := '{' +
              '"chMDFe": "'    + chMDFe   + '",' +
              '"xNome": "'     + xNome    + '",' +
              '"CPF": "'       + CPF      + '",' +
              '"tpAmb": "'     + tpAmb    + '",' +
              '"dhEvento": "'  + dhEvento + '"'  +
          '}';

  url := 'https://mdfe.ns.eti.br/mdfe/adddriver';

  gravaLinhaLog ('[INCLUSAO_CONDUTOR_DADOS]');
  gravaLinhaLog (json);

  resposta := enviaConteudoParaAPI(json, url, 'json');

  gravaLinhaLog('[INCLUSAO_CONDUTOR_RESPOSTA]');
  gravaLinhaLog(resposta);

  jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(resposta),
    0) as TJSONObject;
  status := jsonRetorno.GetValue('status').Value;

  if (status = '200') then
  begin
    respostaDownload := downloadEventoMDFeESalvar(chMDFe, tpDown, tpAmb,
      'INCCOND', nSeqEvento, caminho, exibeNaTela);

    jsonRetorno := TJSONObject.ParseJSONValue
      (TEncoding.ASCII.GetBytes(respostaDownload), 0) as TJSONObject;
    status := jsonRetorno.GetValue('status').Value;

    if (status <> '200') then
    begin
      ShowMessage('Ocorreu um erro ao fazer o download. Verifique os logs.')
    end;
  end;

  Result := resposta;
end;

function consultarMDFeNaoEcerrada(tpAmb, cUF, CNPJ:String): String;
var
  json: String;
  url, resposta, respostaDownload: String;
  status: String;
  jsonRetorno: TJSONObject;
begin

  json := '{' +
              '"CNPJ": "'   + CNPJ   + '",' +
              '"tpAmb": "'  + tpAmb  + '",' +
              '"cUF": "'    + cUF    + '"'  +
          '}';

  url := 'https://mdfe.ns.eti.br/util/consnotclosed';

  gravaLinhaLog ('[CONSULTA_MDFE_NAO_ENCERRADA_DADOS]');
  gravaLinhaLog (json);

  resposta := enviaConteudoParaAPI(json, url, 'json');

  gravaLinhaLog('[CONSULTA_MDFE_NAO_ENCERRADA_RESPOSTA]');
  gravaLinhaLog(resposta);

  Result := resposta;
end;

function listarNSNRecs(chMDFe:String):String;
var
  json: String;
  url, resposta, respostaDownload: String;
  status: String;
  jsonRetorno: TJSONObject;
begin

  json := '{' + '"chMDFe": "' + chMDFe + '"' + '}';

  url := 'https://mdfe.ns.eti.br/util/list/nsnrecs';

  gravaLinhaLog ('[LISTA_NSNRECS_DADOS]');
  gravaLinhaLog (json);

  resposta := enviaConteudoParaAPI(json, url, 'json');

  gravaLinhaLog('[LISTA_NSNRECS_RESPOSTA]');
  gravaLinhaLog(resposta);

  Result := resposta;
end;



// Função para salvar o XML de retorno
function salvarXML(xml, caminho, chMDFe: String; tpEvento: String = ''; nSeqEvento: String = ''): String;
var
  arquivo: TextFile;
  conteudoSalvar, localParaSalvar: String;
begin
  // Seta o caminho para o arquivo XML
  localParaSalvar := caminho + tpEvento + chMDFe + nSeqEvento + '-MDFe.xml';

  // Associa o arquivo ao caminho
  AssignFile(arquivo, localParaSalvar);
  // Abre para escrita o arquivo
  Rewrite(arquivo);

  // Copia o retorno
  conteudoSalvar := xml;
  // Ajeita o XML retirando as barras antes das aspas duplas
  conteudoSalvar := StringReplace(conteudoSalvar, '\"', '"',
    [rfReplaceAll, rfIgnoreCase]);

  // Escreve o retorno no arquivo
  Writeln(arquivo, conteudoSalvar);

  // Fecha o arquivo
  CloseFile(arquivo);
end;

// Função para salvar o JSON de retorno
function salvarJSON(json, caminho, chMDFe: String; tpEvento: String = ''; nSeqEvento: String = ''): String;
var
  arquivo: TextFile;
  conteudoSalvar, localParaSalvar: String;
begin
  // Seta o caminho para o arquivo JSON
  localParaSalvar := caminho + tpEvento + chMDFe + nSeqEvento + '-MDFe.json';

  // Associa o arquivo ao caminho
  AssignFile(arquivo, localParaSalvar);
  // Abre para escrita o arquivo
  Rewrite(arquivo);

  // Copia o retorno
  conteudoSalvar := json;

  // Escreve o retorno no arquivo
  Writeln(arquivo, conteudoSalvar);

  // Fecha o arquivo
  CloseFile(arquivo);
end;

// Função para salvar o PDF de retorno
function salvarPDF(pdf, caminho, chMDFe: String; tpEvento: String = ''; nSeqEvento: String = ''): String;
var
  conteudoSalvar, localParaSalvar: String;
  base64decodificado: TStringStream;
  arquivo: TFileStream;
begin
  /// /Seta o caminho para o arquivo PDF
  localParaSalvar := caminho + tpEvento + chMDFe + nSeqEvento + '-MDFe.pdf';

  // Copia e cria uma TString com o base64
  conteudoSalvar := pdf;
  base64decodificado := TStringStream.Create(conteudoSalvar);

  // Cria o arquivo .pdf e decodifica o base64 para o arquivo
  try
    arquivo := TFileStream.Create(localParaSalvar, fmCreate);
    try
      DecodeStream(base64decodificado, arquivo);
    finally
      arquivo.Free;
    end;
  finally
    base64decodificado.Free;
  end;
end;

// Grava uma linha no log
procedure gravaLinhaLog(conteudo: String);
var
  caminhoEXE, nomeArquivo, data: String;
  log: TextFile;
begin
  // Pega o caminho do executável
  caminhoEXE := ExtractFilePath(GetCurrentDir);
  caminhoEXE := caminhoEXE + 'log\';

  // Pega a data atual
  data := DateToStr(Date);

  // Ajeita o XML retirando as barras antes das aspas duplas
  data := StringReplace(data, '/', '', [rfReplaceAll, rfIgnoreCase]);

  nomeArquivo := caminhoEXE + data;

  // Se diretório \log não existe, é criado
  if not DirectoryExists(caminhoEXE) then
    CreateDir(caminhoEXE);

  AssignFile(log, nomeArquivo + '.txt');
{$I-}
  Reset(log);
{$I+}
  if (IOResult <> 0) then
    Rewrite(log) { arquivo não existe e será criado }
  else
  begin
    CloseFile(log);
    Append(log); { o arquivo existe e será aberto para saídas adicionais }
  end;

  Writeln(log, DateTimeToStr(Now) + ' - ' + conteudo);

  CloseFile(log);
end;

end.

