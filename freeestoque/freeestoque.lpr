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

program freeestoque;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  zcomponent, Interfaces, // this includes the LCL widgetset
  Forms, lazreport, SQLDBLaz, lazreportpdfexport, Unit_rotinas,
  Unit_Modelo_Form_Rel, UnitPrincipal, UnitDados, Modelo_Cad, rxnew, ACBr_LCL,
  Unit_Empresa, unitcad_fornecedores, Unit_Config, unitcad_clientes,
  Unit_Cad_Mod_Simples, Unit_Cad_Grupos, Unit_Cad_Marcas, Unit_Cad_Modelos,
  Unit_Cad_Unidades, Unit_Cad_Produtos;

{$IFDEF WINDOWS}{$R freeestoque.rc}{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TFormPrincipal, FormPrincipal);
//  Application.CreateForm(TForm_Cad_Mod_Simples, Form_Cad_Mod_Simples);
//  Application.CreateForm(TForm_Config, Form_Config);
  Application.Run;
end.

