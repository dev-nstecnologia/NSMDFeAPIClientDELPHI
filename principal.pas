unit principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmPrincipal = class(TForm)
    Label6: TLabel;
    pgControl: TPageControl;
    formEmissao: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnEmitir: TButton;
    memoConteudoEnviar: TMemo;
    cbTpConteudo: TComboBox;
    chkExibirEmis: TCheckBox;
    txtCNPJ: TEdit;
    GroupBox4: TGroupBox;
    memoRetornoEmis: TMemo;
    txtCaminhoSalvar: TEdit;
    labelTokenEnviar: TLabel;
    TabSheet1: TTabSheet;
    txtchMDFeEnc: TEdit;
    txtcUFEnc: TEdit;
    txtcMunEnc: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    txtnProtEnc: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    chkExibirEnc: TCheckBox;
    btnEncerrar: TButton;
    GroupBox1: TGroupBox;
    memoRetornoEnc: TMemo;
    cbtpDownEnc: TComboBox;
    cbtpAmbEnc: TComboBox;
    cbTpDownEmis: TComboBox;
    cbTpAmbEmis: TComboBox;
    Label13: TLabel;
    procedure btnEncerrarClick(Sender: TObject);
    procedure btnEnviarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses MDFeAPI, System.JSON;

procedure TfrmPrincipal.btnEnviarClick(Sender: TObject);
var
  retorno, statusEnvio, statusConsulta, statusDownload: String;
  cStat, chMDFe, nProt, motivo, nsNRec, erros: String;
  jsonRetorno: TJSONObject;
begin
  // Valida se todos os campos foram preenchidos
  if ((txtCaminhoSalvar.Text <> '') and (txtCNPJ.Text <> '') and
  (memoConteudoEnviar.Text <> '')) then
  begin
    memoRetornoEmis.Lines.Clear;
    retorno := emitirMDFeSincrono(memoConteudoEnviar.Text,
    cbTpConteudo.Text, txtCNPJ.Text, cbTpDownEmis.Text, cbTpAmbEmis.Text,
    txtCaminhoSalvar.Text, chkExibirEmis.Checked);
    memoRetornoEmis.Text := retorno;

    jsonRetorno := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(retorno),
    0) as TJSONObject;
    statusEnvio := jsonRetorno.GetValue('statusEnvio').Value;
    statusConsulta := jsonRetorno.GetValue('statusConsulta').Value;
    statusDownload := jsonRetorno.GetValue('statusDownload').Value;
    cStat := jsonRetorno.GetValue('cStat').Value;
    chMDFe := jsonRetorno.GetValue('chMDFe').Value;
    nProt := jsonRetorno.GetValue('nProt').Value;
    motivo := jsonRetorno.GetValue('motivo').Value;
    nsNRec := jsonRetorno.GetValue('nsNRec').Value;
    erros := jsonRetorno.GetValue('erros').Value;

    if ((statusEnvio = '200') Or (statusEnvio = '-6')) then
    begin
      if(statusConsulta = '200') then
      begin
        if (cStat = '100') then
        begin
            ShowMessage(motivo);
            if (statusDownload <> '200') then
            begin
                // Aqui você pode realizar um tratamento em caso de erro no download
            end
        end
        else
        begin
            ShowMessage(motivo);
        end
      end
      else
      begin
        ShowMessage(motivo + #13 + erros);
      end
    end
    else
    begin
      ShowMessage(motivo + #13 + erros);
    end;
  end
  else
  begin
    Showmessage('Todos os campos devem estar preenchidos');
  end;
end;
procedure TfrmPrincipal.btnEncerrarClick(Sender: TObject);
var
  retorno, dhEvento, dtEnc, hora, fuso: String;
begin
  // Valida se todos os campos foram preenchidos
  if ((txtCaminhoSalvar.Text <> '') and (txtchMDFeEnc.Text <> '') and
  (txtnProtEnc.Text <> '') and (txtcUFEnc.Text <> '') and (txtcMunEnc.Text <> '')) then
  begin
    fuso := '-03:00';
    dtEnc := FormatDateTime('yyyy-mm-dd',now);
    hora := FormatDateTime('hh:mm:ss',now);
    dhEvento := dtEnc + 'T' + hora + fuso;
    memoRetornoEnc.Lines.Clear;
    retorno := encerrarMDFe(txtchMDFeEnc.Text, txtnProtEnc.Text, dhEvento,
     dtEnc, txtcUFEnc.Text, txtcMunEnc.Text, cbTpAmbEnc.Text, cbTpDownEnc.Text,
     txtCaminhoSalvar.Text, chkExibirEnc.Checked);
    memoRetornoEnc.Text := retorno;
  end
  else
  begin
    Showmessage('Todos os campos devem estar preenchidos');
  end;
end;
end.
