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
|* 01/03/2016: Guilherme Costa
|*  - Passado o namespace para gera��o do cabe�alho
******************************************************************************}
{$I ACBr.inc}

unit pcesS2260;

interface

uses
  SysUtils, Classes,
  pcnConversao,
  pcesCommon, pcesConversaoeSocial, pcesGerador;

type
  TS2260Collection = class;
  TS2260CollectionItem = class;
  TEvtConvInterm = class;
  TInfoConvInterm = class;
  Tjornada = class;
  TlocalTrab = class;

  TS2260Collection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TS2260CollectionItem;
    procedure SetItem(Index: Integer; Value: TS2260CollectionItem);
  public
    function Add: TS2260CollectionItem;
    property Items[Index: Integer]: TS2260CollectionItem read GetItem write SetItem; default;
  end;

  TS2260CollectionItem = class(TCollectionItem)
  private
    FTipoEvento: TTipoEvento;
    FEvtConvInterm: TEvtConvInterm;

    procedure setEvtConvInterm(const Value: TEvtConvInterm);
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  published
    property TipoEvento: TTipoEvento read FTipoEvento;
    property EvtConvInterm: TEvtConvInterm read FEvtConvInterm write setEvtConvInterm;
  end;

  TEvtConvInterm = class(TeSocialEvento)
  private
    FIdeEvento: TIdeEvento2;
    FIdeEmpregador: TIdeEmpregador;
    FIdeVinculo: TIdeVinculo;
    FInfoConvInterm: TInfoConvInterm;
    FACBreSocial: TObject;

    procedure GerarInfoConvInterm;
    procedure Gerarjornada;
    procedure GerarlocalTrab;
  public
    constructor Create(AACBreSocial: TObject);overload;
    destructor  Destroy; override;

    function GerarXML: boolean; override;
    function LerArqIni(const AIniString: String): Boolean;

    property IdeEvento: TIdeEvento2 read FIdeEvento write FIdeEvento;
    property IdeEmpregador: TIdeEmpregador read FIdeEmpregador write FIdeEmpregador;
    property IdeVinculo: TIdeVinculo read FIdeVinculo write FIdeVinculo;
    
    property InfoConvInterm: TInfoConvInterm read FInfoConvInterm write FInfoConvInterm;
  end;

  TInfoConvInterm = class
  private
    FcodConv: string;
    FdtInicio: TDateTime;
    FdtFim: TDateTime;
    Fjornada : Tjornada;
    FlocalTrab: TlocalTrab;
  public
    constructor create;
    destructor Destroy; override;

    property codConv: string read FcodConv write FcodConv;
    property dtInicio: TDateTime read FdtInicio write FdtInicio;
    property dtFim: TDateTime read FdtFim write FdtFim;
    property jornada: Tjornada read Fjornada write Fjornada;
    property localTrab: TlocalTrab read FlocalTrab write FlocalTrab;
  end;

  Tjornada = class
  private
    FcodHorContrat: string;
    FdscJornada: string;
  public
    property codHorContrat: string read FcodHorContrat write FcodHorContrat;
    property dscJornada: string read FdscJornada write FdscJornada;
  end;

  TlocalTrab = class
  private
    FindLocal: string;
    FlocalTrabInterm: TBrasil;
  public
    constructor create;
    destructor Destroy; override;

    property indLocal: string read FindLocal write FindLocal;
    property localTrabInterm: TBrasil read FlocalTrabInterm write FlocalTrabInterm;
  end;

implementation

uses
  IniFiles,
  ACBreSocial, ACBrDFeUtil;

{ TS2260Collection }

function TS2260Collection.Add: TS2260CollectionItem;
begin
  Result := TS2260CollectionItem(inherited Add);
  Result.Create(TComponent(Self.Owner));
end;

function TS2260Collection.GetItem(Index: Integer): TS2260CollectionItem;
begin
  Result := TS2260CollectionItem(inherited GetItem(Index));
end;

procedure TS2260Collection.SetItem(Index: Integer;
  Value: TS2260CollectionItem);
begin
  inherited SetItem(Index, Value);
end;

{ TS2260CollectionItem }

constructor TS2260CollectionItem.Create(AOwner: TComponent);
begin
  FTipoEvento := teS2260;
  FEvtConvInterm := TEvtConvInterm.Create(AOwner);
end;

destructor TS2260CollectionItem.Destroy;
begin
  FEvtConvInterm.Free;

  inherited;
end;

procedure TS2260CollectionItem.setEvtConvInterm(
  const Value: TEvtConvInterm);
begin
  FEvtConvInterm.Assign(Value);
end;

{ TEvtConvInterm }

constructor TEvtConvInterm.Create(AACBreSocial: TObject);
begin
  inherited;

  FACBreSocial := AACBreSocial;
  FIdeEvento := TIdeEvento2.Create;
  FIdeEmpregador := TIdeEmpregador.Create;
  FIdeVinculo := TIdeVinculo.Create;
  FInfoConvInterm := TInfoConvInterm.Create;
end;

destructor TEvtConvInterm.Destroy;
begin
  FIdeEvento.Free;
  FIdeEmpregador.Free;
  FIdeVinculo.Free;
  FInfoConvInterm.Free;

  inherited;
end;

procedure TEvtConvInterm.GerarlocalTrab;
begin
  Gerador.wGrupo('localTrab');

  Gerador.wCampo(tcStr, '', 'indLocal', 1, 1, 1, self.InfoConvInterm.localTrab.indLocal);

  GerarEnderecoLocalTrabInterm(self.InfoConvInterm.localTrab.localTrabInterm);

  Gerador.wGrupo('/localTrab');
end;

procedure TEvtConvInterm.Gerarjornada;
begin
  Gerador.wGrupo('jornada');

  Gerador.wCampo(tcStr, '', 'codHorContrat', 1,  30, 0, self.InfoConvInterm.jornada.codHorContrat);
  Gerador.wCampo(tcStr, '', 'dscJornada',    1, 999, 0, self.InfoConvInterm.jornada.dscJornada);

  Gerador.wGrupo('/jornada');
end;

procedure TEvtConvInterm.GerarInfoConvInterm;
begin
  Gerador.wGrupo('infoConvInterm');

  Gerador.wCampo(tcStr, '', 'codConv',   1, 30, 1, self.InfoConvInterm.codConv);
  Gerador.wCampo(tcDat, '', 'dtInicio', 10, 10, 1, self.InfoConvInterm.dtInicio);
  Gerador.wCampo(tcDat, '', 'dtFim',    10, 10, 1, self.InfoConvInterm.dtFim);

  Gerarjornada;
  GerarlocalTrab;

  Gerador.wGrupo('/infoConvInterm');
end;

function TEvtConvInterm.GerarXML: boolean;
begin
  try
    Self.VersaoDF := TACBreSocial(FACBreSocial).Configuracoes.Geral.VersaoDF;
     
    Self.Id := GerarChaveEsocial(now, self.ideEmpregador.NrInsc, self.Sequencial);

    GerarCabecalho('evtConvInterm');
    Gerador.wGrupo('evtConvInterm Id="' + Self.Id + '"');

    GerarIdeEvento2(self.IdeEvento);
    GerarIdeEmpregador(self.IdeEmpregador);
    GerarIdeVinculo(self.IdeVinculo);
    GerarInfoConvInterm;

    Gerador.wGrupo('/evtConvInterm');

    GerarRodape;

    XML := Assinar(Gerador.ArquivoFormatoXML, 'evtConvInterm');

    Validar(schevtConvInterm);
  except on e:exception do
    raise Exception.Create(e.Message);
  end;

  Result := (Gerador.ArquivoFormatoXML <> '')
end;

function TEvtConvInterm.LerArqIni(const AIniString: String): Boolean;
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

{ TInfoConvInterm }

constructor TInfoConvInterm.create;
begin
  Fjornada  := Tjornada.create;
  FlocalTrab := TlocalTrab.Create;
end;

destructor TInfoConvInterm.destroy;
begin
  Fjornada.Free;
  FlocalTrab.Free;

  inherited;
end;

{ TlocalTrab }

constructor TlocalTrab.create;
begin
  FlocalTrabInterm := TBrasil.Create;
end;

destructor TlocalTrab.Destroy;
begin
  FlocalTrabInterm.Free;

  inherited;
end;

end.

