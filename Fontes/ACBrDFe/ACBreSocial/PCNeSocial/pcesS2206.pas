{******************************************************************************}
{ Projeto: Componente ACBreSocial                                              }
{  Biblioteca multiplataforma de componentes Delphi para envio dos eventos do  }
{ eSocial - http://www.esocial.gov.br/                                         }
{                                                                              }
{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }
{                                                                              }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 27/10/2015: Jean Carlo Cantu, Tiago Ravache
|*  - Doa��o do componente para o Projeto ACBr
|* 01/03/2016: Altera��es para valida��o com o XSD
******************************************************************************}
{$I ACBr.inc}

unit pcesS2206;

interface

uses
  SysUtils, Classes,
  pcnConversao,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type

  TS2206Collection = class;
  TS2206CollectionItem = class;
  TEvtAltContratual = class;
  TAltContratual = class;
  TServPubl = class;
  TInfoContratoS2206 = class;

  TS2206Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS2206CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2206CollectionItem);
  public
    function Add: TS2206CollectionItem;
    property Items[Index: Integer]: TS2206CollectionItem read GetItem write SetItem; default;
  end;

  TS2206CollectionItem = class(TCollectionItem)
  private
    FTipoEvento : TTipoEvento;
    FEvtAltContratual: TEvtAltContratual;

    procedure setEvtAltContratual(const Value: TEvtAltContratual);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor  Destroy; override;
  published
    property TipoEvento : TTipoEvento read FTipoEvento;
    property EvtAltContratual : TEvtAltContratual read FEvtAltContratual write setEvtAltContratual;
  end;

  TEvtAltContratual = class(TeSocialEvento)
  private
    FIdeEvento: TIdeEvento2;
    FIdeEmpregador: TIdeEmpregador;
    FIdeVinculo : TIdeVinculo;
    FAltContratual: TAltContratual;
    FACBreSocial: TObject;

    {Geradores da Classe - Necess�rios pois os geradores de ACBreSocialGerador
     possuem campos excedentes que n�o se aplicam ao S2206}
    procedure GerarAltContratual(objAltContratual: TAltContratual);
    procedure GerarInfoCeletista(objInfoCeletista : TInfoCeletista);
    procedure GerarInfoEstaturario(pInfoEstatutario: TInfoEstatutario);
    procedure GerarInfoContrato(ObjInfoContrato : TInfoContratoS2206; pTipo: Integer; pInfoCeletista: TInfoCeletista);
    procedure GerarTrabTemp(pTrabTemp: TTrabTemporario);
    procedure GerarServPubl(pServPubl: TServPubl);
    function  GetAltContratual : TAltContratual;
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property IdeEvento : TIdeEvento2 read FIdeEvento write FIdeEvento;
    property IdeEmpregador : TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeVinculo : TIdeVinculo read FIdeVinculo write FIdeVInculo;
    property AltContratual : TAltContratual read GetAltContratual write FAltContratual;
  end;

  TServPubl = class(TPersistent)
  private
    FMtvAlter: tpMtvAlt;
  public
    property mtvAlter: tpMtvAlt read FMtvAlter write FMtvAlter;
  end;

  TInfoContratoS2206 = class(TInfoContrato)
  private
    FServPubl: TServPubl;

    function getServPubl: TServPubl;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    function servPublInst: boolean;

    property servPubl: TServPubl read getServPubl write FServPubl;
  end;

  TAltContratual = class(TPersistent)
  private
    FdtAlteracao : TDateTime;
    FDtEf: TDateTime;
    FDscAlt: string;
    FVinculo     : TVinculo;
    FinfoRegimeTrab : TinfoRegimeTrab;
    FinfoContrato   : TInfoContratoS2206;
  public
    constructor Create;
    destructor  destroy; override;
  published
    property dtALteracao : TDateTime read FdtAlteracao write FdtAlteracao;
    property dtEf: TDateTime read FDtEf write FDtEf;
    property dscAlt: string read FDscAlt write FDscAlt;
    property Vinculo : TVInculo read FVinculo write FVinculo;
    property infoRegimeTrab : TinfoRegimeTrab read FinfoRegimeTrab write FinfoRegimeTrab;
    property infoContrato : TInfoContratoS2206 read FinfoContrato write FinfoContrato;
  end;

implementation

uses
  IniFiles,
  ACBreSocial, ACBrDFeUtil;

{ TS2206Collection }

function TS2206Collection.Add: TS2206CollectionItem;
begin
  Result := TS2206CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS2206Collection.GetItem(Index: Integer): TS2206CollectionItem;
begin
   Result := TS2206CollectionItem(inherited GetItem(Index));
end;

procedure TS2206Collection.SetItem(Index: Integer; Value: TS2206CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS2206CollectionItem }

constructor TS2206CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS2206;
  FEvtAltContratual := TEvtAltContratual.Create(AOwner);
end;

destructor TS2206CollectionItem.Destroy;
begin
  FEvtAltContratual.Free;

  inherited;
end;

procedure TS2206CollectionItem.setEvtAltContratual(const Value: TEvtAltContratual);
begin
  FEvtAltContratual.Assign(Value)
end;

{ TEvtAltContratual }

constructor TEvtAltContratual.Create(AACBreSocial: TObject);
begin
  inherited;

  FACBreSocial := AACBreSocial;
  FIdeEvento := TIdeEvento2.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeVinculo := TIdeVinculo.Create;
  FAltContratual := TAltContratual.Create;
end;

destructor TEvtAltContratual.destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FAltContratual.Free;

  inherited;
end;

procedure TEvtAltContratual.GerarInfoEstaturario(pInfoEstatutario: TInfoEstatutario);
begin
  Gerador.wGrupo('infoEstaturario');

  Gerador.wCampo(tcInt, '', 'tpPlanRP', 1, 1, 1, eSTpPlanRPToStr(pInfoEstatutario.tpPlanRP));

  Gerador.wGrupo('/infoEstaturario');
end;

procedure TEvtAltContratual.GerarAltContratual(objAltContratual: TAltContratual);
begin
  Gerador.wGrupo('altContratual');

  Gerador.wCampo(tcDat, '', 'dtAlteracao', 10,  10, 1, objAltContratual.dtALteracao);
  Gerador.wCampo(tcDat, '', 'dtEf',        10,  10, 0, objAltContratual.dtEf);
  Gerador.wCampo(tcStr, '', 'dscAlt',       1, 150, 0, objAltContratual.dscAlt);

  GerarVinculo(objAltContratual.Vinculo, 3);

  Gerador.wGrupo('infoRegimeTrab');

  if objAltContratual.infoRegimeTrab.InfoCeletista.cnpjSindCategProf <> '' then
    GerarInfoCeletista(objAltContratual.infoRegimeTrab.InfoCeletista)
  else
    GerarInfoEstaturario(objAltContratual.infoRegimeTrab.InfoEstatutario);

  Gerador.wGrupo('/infoRegimeTrab');

  GerarInfoContrato(objAltContratual.InfoContrato, 3, objAltContratual.infoRegimeTrab.InfoCeletista);

  Gerador.wGrupo('/altContratual');
end;

procedure TEvtAltContratual.GerarTrabTemp(pTrabTemp: TTrabTemporario);
begin
  if pTrabTemp.justProrr <> '' then
  begin
    Gerador.wGrupo('trabTemp');

    Gerador.wCampo(tcStr, '', 'justProrr', 1, 999, 1, pTrabTemp.justProrr);

    Gerador.wGrupo('/trabTemp');
  end;
end;

procedure TEvtAltContratual.GerarInfoCeletista(objInfoCeletista: TInfoCeletista);
begin
  Gerador.wGrupo('infoCeletista');

  Gerador.wCampo(tcStr, '', 'tpRegJor',           1,  1, 1, ord(objInfoCeletista.TpRegJor) + 1);
  Gerador.wCampo(tcStr, '', 'natAtividade',       1,  1, 1, ord(objInfoCeletista.NatAtividade) + 1);

  if objInfoCeletista.dtBase > 0  then
    Gerador.wCampo(tcStr, '', 'dtBase',             1,  2, 0, objInfoCeletista.dtBase);

  Gerador.wCampo(tcStr, '', 'cnpjSindCategProf', 14, 14, 1, objInfoCeletista.cnpjSindCategProf);

  GerarTrabTemp(objInfoCeletista.TrabTemporario);
  GerarInfoAprend(objInfoCeletista.aprend);

  Gerador.wGrupo('/infoCeletista');
end;

procedure TEvtAltContratual.GerarServPubl(pServPubl: TServPubl);
begin
  Gerador.wGrupo('servPubl');

  Gerador.wCampo(tcInt, '', 'mtvAlter', 1, 1, 1, eSTpMtvAltToStr(pServPubl.mtvAlter));

  Gerador.wGrupo('/servPubl');
end;

procedure TEvtAltContratual.GerarInfoContrato(ObjInfoContrato: TInfoContratoS2206; pTipo: Integer; pInfoCeletista: TInfoCeletista);
begin
  Gerador.wGrupo('infoContrato');

  Gerador.wCampo(tcStr, '', 'codCargo',     1, 30, 0, objInfoContrato.CodCargo);
  Gerador.wCampo(tcStr, '', 'codFuncao',    1, 30, 0, objInfoContrato.CodFuncao);
  Gerador.wCampo(tcInt, '', 'codCateg',     1,  3, 1, objInfoContrato.CodCateg);
  Gerador.wCampo(tcStr, '', 'codCarreira',  1, 30, 0, objInfoContrato.codCarreira);
  Gerador.wCampo(tcDat, '', 'dtIngrCarr',  10, 10, 0, objInfoContrato.dtIngrCarr);

  GerarRemuneracao(objInfoContrato.Remuneracao);
  GerarDuracao(objInfoContrato.Duracao, pTipo);
  GerarLocalTrabalho(objInfoContrato.LocalTrabalho); 

  //Informa��es do Hor�rio Contratual do Trabalhador. O preenchimento � obrigat�rio se {tpRegJor} = [1]
  if (pInfoCeletista.TpRegJor = rjSubmetidosHorarioTrabalho) then
    GerarHorContratual(objInfoContrato.HorContratual);

  GerarFiliacaoSindical(objInfoContrato.FiliacaoSindical);
  GerarAlvaraJudicial(objInfoContrato.AlvaraJudicial);
  GerarObservacoes(objInfoContrato.observacoes);

  if objInfoContrato.servPublInst then
    GerarServPubl(objInfoContrato.servPubl);

  Gerador.wGrupo('/infoContrato');
end;

function TEvtAltContratual.GerarXML: boolean;
begin
  try
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtAltContratual');

    Gerador.wGrupo('evtAltContratual Id="' + Self.Id + '"');

    GerarIdeEvento2(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);
    GerarIdeVinculo(Self.IdeVinculo);
    GerarAltContratual(FAltContratual);

    Gerador.wGrupo('/evtAltContratual');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtAltContratual');

    Validar(schevtAltContratual);
  except on e:exception do
    raise Exception.Create(Self.Id + sLineBreak + ' ' + e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtAltContratual.GetAltContratual: TAltContratual;
begin
  if Not(Assigned(FAltContratual)) then
    FAltContratual := TAltContratual.Create;
  Result := FAltContratual;
end;

function TEvtAltContratual.LerArqIni(const AIniString: String): Boolean;
var
  INIRec: TMemIniFile;
  Ok: Boolean;
  sSecao, sFim: String;
  I: Integer;
begin
  Result := False;

  INIRec := TMemIniFile.Create('');
  try
    LerIniArquivoOuString(AIniString, INIRec);

    with Self do
    begin
      // Falta Implementar
    end;

    GerarXML;

    Result := True;
  finally
     INIRec.Free;
  end;
end;

{ TAltContratual }

constructor TAltContratual.Create;
begin
  inherited;

  FVinculo := TVinculo.Create;
  FinfoRegimeTrab := TinfoRegimeTrab.Create;
  FinfoContrato   := TInfoContratoS2206.Create;
end;

destructor TAltContratual.destroy;
begin
  FVinculo.Free;
  FinfoRegimeTrab.Free;
  FinfoContrato.Free;

  inherited;
end;

{ TInfoContratoS2206 }

constructor TInfoContratoS2206.Create;
begin
  inherited;

  FServPubl := nil;
end;

destructor TInfoContratoS2206.Destroy;
begin
  FreeAndNil(FServPubl);

  inherited;
end;

function TInfoContratoS2206.getServPubl: TServPubl;
begin
  if not Assigned(FServPubl) then
    FServPubl := TServPubl.Create;
  Result := FServPubl;
end;

function TInfoContratoS2206.servPublInst: boolean;
begin
  result := Assigned(FServPubl);
end;

end.
