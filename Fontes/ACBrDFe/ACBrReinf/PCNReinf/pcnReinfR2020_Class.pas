{******************************************************************************}
{ Projeto: Componente ACBrReinf                                                }
{  Biblioteca multiplataforma de componentes Delphi para envio de eventos do   }
{ Reinf                                                                        }

{ Direitos Autorais Reservados (c) 2017 Leivio Ramos de Fontenele              }
{                                                                              }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }


{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Leivio Ramos de Fontenele  -  leivio@yahoo.com.br                            }
{******************************************************************************}
{******************************************************************************
|* Historico
|*
|* 04/12/2017: Renato Rubinho
|*  - Implementados registros que faltavam e isoladas as respectivas classes 
*******************************************************************************}

unit pcnReinfR2020_Class;

interface

uses
  Classes, Sysutils, pcnConversaoReinf, Controls, Contnrs, pcnReinfClasses,
  pcnReinfR2010_Class;

type
  TideTomadors = class;

  { TideEstabPrest }
  TideEstabPrest = class
  private
    FnrInscEstabPrest: string;
    FtpInscEstabPrest: TtpInsc;
    FideTomador: TideTomadors;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    property tpInscEstabPrest: TtpInsc read FtpInscEstabPrest write FtpInscEstabPrest default tiCNPJ;
    property nrInscEstabPrest: string read  FnrInscEstabPrest write FnrInscEstabPrest;
    property ideTomadors: TideTomadors read FideTomador;
  end;

  { TinfoServPrest }
  TinfoServPrest = class
  private
    FideEstabPrest: TideEstabPrest;
    FidePeriodo: TIdePeriodo;
  public
    property IdePeriodo: TIdePeriodo read FidePeriodo write FidePeriodo;
    property ideEstabPrest: TideEstabPrest read FideEstabPrest;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

  { TideTomador }
  TideTomador = class(TideServico)
  private
    FnrInscTomador: string;
    FtpInscTomador: TtpInsc;
    FindObra: TpindObra;
  public
    property nrInscTomador: string read FnrInscTomador write FnrInscTomador;
    property tpInscTomador: TtpInsc read FtpInscTomador write FtpInscTomador default tiCNPJ;
    property indObra: TpindObra read FindObra write FindObra;
  end;

  { TideTomadors }
  TideTomadors = class(TObjectList)
  private
    function GetItem(Index: Integer): TideTomador;
    procedure SetItem(Index: Integer; const Value: TideTomador);
  public
    function New: TideTomador;
    property Items[Index: Integer]: TideTomador read GetItem write SetItem;
  end;

implementation

{ TideEstabPrest }

procedure TideEstabPrest.AfterConstruction;
begin
  inherited;
  FideTomador := TideTomadors.Create;
end;

procedure TideEstabPrest.BeforeDestruction;
begin
  inherited;
  FideTomador.Free;
end;

{ TinfoServPrest }

procedure TinfoServPrest.AfterConstruction;
begin
  inherited;
  FidePeriodo := TIdePeriodo.Create;
  FideEstabPrest := TideEstabPrest.Create;
end;

procedure TinfoServPrest.BeforeDestruction;
begin
  inherited;
  FidePeriodo.Free;
  FideEstabPrest.Free;
end;

{ TideTomadors }

function TideTomadors.GetItem(Index: Integer): TideTomador;
begin
  Result := TideTomador(Inherited Items[Index]);
end;

function TideTomadors.New: TideTomador;
begin
  Result := TideTomador.Create;
  Add(Result);
end;

procedure TideTomadors.SetItem(Index: Integer; const Value: TideTomador);
begin
  Put(Index, Value);
end;

end.

