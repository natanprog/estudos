{******************************************************************************}
{ Projeto: FreeEstoque                                                         }
{  Sistema multiplataforma para controle de estoque, controle de vendas e      }
{  financeiro                                                                  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009 Jean Patrick F. dos Santos             }
{                                                                              }
{ Este arquivo é parte do programa FreeEstoque                                 }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto         }
{ FreeEstoque localizado em http://www.jpsoft.com.br                           }
{                                                                              }
{  FreeEstoque é um software livre; você pode redistribui-lo e/ou              }
{ modifica-lo dentro dos termos da Licença Pública Geral GNU como              }
{ publicada pela Fundação do Software Livre (FSF); na versão 3 da              }
{ Licença, ou (na sua opnião) qualquer versão.                                 }
{                                                                              }
{  Este programa é distribuido na esperança que possa ser util,                }
{ mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUAÇÂO            }
{ a qualquer MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a Licença Pública        }
{ Geral GNU para maiores detalhes.                                             }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral GNU               }
{ junto com este programa, se não, escreva para a Fundação do Software         }
{ Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA    }
{                                                                              }
{ Jean Patrick F. dos Santos - jpsoft-sac-pa@hotmail.com - www.jpsoft.com.br   }
{                                                                              }
{******************************************************************************}

unit UnitDados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Dialogs,
  ZConnection, ZDataset, ZSequence, ZSqlUpdate, ZSqlProcessor, ZSqlMonitor, db;

type

  { Tdm }

  Tdm = class(TDataModule)
    banco: TZConnection;
    ClientesATIVO: TStringField;
    ClientesBAIRRO: TStringField;
    ClientesCAIXA_POSTAL: TStringField;
    ClientesCEL1: TStringField;
    ClientesCEL2: TStringField;
    ClientesCEP: TStringField;
    ClientesCIDADE: TStringField;
    ClientesCNPJ: TStringField;
    ClientesCONTATO: TStringField;
    ClientesCPF: TStringField;
    ClientesDATA_CAD: TDateField;
    ClientesEMAIL1: TStringField;
    ClientesEMAIL2: TStringField;
    ClientesENDERECO: TStringField;
    ClientesESTADO: TStringField;
    ClientesFAX1: TStringField;
    ClientesFAX2: TStringField;
    ClientesFONE1: TStringField;
    ClientesFONE2: TStringField;
    ClientesFOTO: TStringField;
    ClientesID: TLargeintField;
    ClientesIE: TStringField;
    ClientesNOME: TStringField;
    ClientesOBS: TMemoField;
    ClientesRAZAO: TStringField;
    ClientesRG: TStringField;
    ClientesSITE: TStringField;
    ClientesTIPO: TStringField;
    dsProdutos: TDatasource;
    dsModelos: TDatasource;
    dsUnidades: TDatasource;
    dsMarcas: TDatasource;
    dsGrupos: TDatasource;
    dsFornecedores: TDatasource;
    dsClientes: TDatasource;
    FornecedoresATIVO: TSmallintField;
    FornecedoresBAIRRO: TStringField;
    FornecedoresCAIXA_POSTAL: TStringField;
    FornecedoresCEL1: TStringField;
    FornecedoresCEL2: TStringField;
    FornecedoresCEP: TStringField;
    FornecedoresCIDADE: TStringField;
    FornecedoresCNPJ: TStringField;
    FornecedoresCONTATO: TStringField;
    FornecedoresDATA_CAD: TDateField;
    FornecedoresEMAIL1: TStringField;
    FornecedoresEMAIL2: TStringField;
    FornecedoresENDERECO: TStringField;
    FornecedoresESTADO: TStringField;
    FornecedoresFAX1: TStringField;
    FornecedoresFAX2: TStringField;
    FornecedoresFONE1: TStringField;
    FornecedoresFONE2: TStringField;
    FornecedoresID: TLargeintField;
    FornecedoresIE: TStringField;
    FornecedoresNOME: TStringField;
    FornecedoresOBS: TMemoField;
    FornecedoresRAZAO: TStringField;
    FornecedoresSITE: TStringField;
    MarcasID: TLargeintField;
    MarcasMARCA: TStringField;
    ModelosID: TLargeintField;
    ModelosMODELO: TStringField;
    ProdutosCOD_BARRA: TStringField;
    ProdutosDATA_CAD: TDateField;
    ProdutosDESCRICAO: TStringField;
    ProdutosESTOQUE_ATUAL: TFloatField;
    ProdutosESTOQUE_MIN: TFloatField;
    ProdutosFORNECEDOR: TLargeintField;
    ProdutosFOTO: TStringField;
    ProdutosGRUPO: TLargeintField;
    ProdutosGRUPO1: TStringField;
    ProdutosGRUPO_1: TStringField;
    ProdutosID: TLargeintField;
    ProdutosMARCA: TLargeintField;
    ProdutosMARCA_1: TStringField;
    ProdutosMODELO: TLargeintField;
    ProdutosMODELO_1: TStringField;
    ProdutosNOME: TStringField;
    ProdutosOBS: TMemoField;
    ProdutosPRECO_COMP: TFloatField;
    ProdutosPRECO_VEND: TFloatField;
    ProdutosREFERENCIA: TStringField;
    ProdutosUNIDADE: TLongintField;
    ProdutosUNIDADE_1: TStringField;
    sClientes: TZSequence;
    uClientes: TZUpdateSQL;
    Clientes: TZQuery;
    SQL: TZQuery;
    Empresa: TZTable;
    Fornecedores: TZQuery;
    uFornecedores: TZUpdateSQL;
    sFornecedores: TZSequence;
    Marcas: TZTable;
    sGrupos: TZSequence;
    sMarcas: TZSequence;
    sModelos: TZSequence;
    sUnidades: TZSequence;
    Modelos: TZTable;
    Unidades: TZTable;
    Produtos: TZQuery;
    sProdutos: TZSequence;
    UnidadesID: TLongintField;
    UnidadesUNIDADE: TStringField;
    uProdutos: TZUpdateSQL;
    Grupos: TZTable;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  dm: Tdm;

implementation

initialization
  {$I unitdados.lrs}

end.

