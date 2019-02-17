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

unit Modelo_Cad;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Buttons, DBGrids, DbCtrls, ExtDlgs, ZDataset,
  Unit_rotinas, db, LCLType, LCLIntf, LR_Class,
  LR_DBSet, LR_E_HTM, LR_E_CSV, LR_RRect, LR_Shape, lr_e_pdf;

type

  { TModelo_Cadastro }

  TModelo_Cadastro = class(TForm)
    btSalvar: TBitBtn;
    btCancelar: TBitBtn;
    btExcluir: TBitBtn;
    btNovo: TBitBtn;
    btImprimir: TBitBtn;
    btEditar: TBitBtn;
    frDBDataSet1: TfrDBDataSet;
    frReport1: TfrReport;
    frRoundRectObject1: TfrRoundRectObject;
    frShapeObject1: TfrShapeObject;
    GridDados: TDBGrid;
    DBNavigator1: TDBNavigator;
    lbMensagem: TLabel;
    lbMensagem1: TLabel;
    Notebook1: TNotebook;
    Page1: TPage;
    Page2: TPage;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btCancelarClick(Sender: TObject);
    procedure btEditarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btNovoClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure GridDadosTitleClick(Column: TColumn);
  private
    { private declarations }
  public
    procedure btControle(modo: boolean);
    { public declarations }
  end; 

var
  Modelo_Cadastro: TModelo_Cadastro;
  tabela: TZQuery;

implementation

{ TModelo_Cadastro }

procedure TModelo_Cadastro.FormShow(Sender: TObject);
begin
  DateSeparator:='/';
  DecimalSeparator:=',';
  ThousandSeparator:='.';
  CurrencyFormat:=2;
  CurrencyString:='R$';
  tabela.open;
end;

procedure TModelo_Cadastro.GridDadosTitleClick(Column: TColumn);
begin
  if tag=0 then begin
    tabela.SortedFields:=column.fieldname+' asc';
    tag:=1;
  end else begin
    tabela.SortedFields:=column.fieldname+' desc';
    tag:=0;
  end;
end;

procedure TModelo_Cadastro.btControle(modo: boolean);
begin
//  btAjuda.Enabled:=modo;
  DBNavigator1.Enabled:=modo;
  btImprimir.Enabled:=modo;
  btNovo.Enabled:=modo;
  btEditar.Enabled:=modo;
  btSalvar.Enabled:=not modo;
  btCancelar.Enabled:=not modo;
  btExcluir.Enabled:=modo;
  Page2.TabVisible:=modo;
  Panel1.Enabled:=modo;
  Repaint;
end;

procedure TModelo_Cadastro.btEditarClick(Sender: TObject);
begin
  btControle(false);
  tabela.Edit;
  lbMensagem.Caption:='MODO DE EDIÇÃO';
end;

procedure TModelo_Cadastro.btExcluirClick(Sender: TObject);
begin
  lbMensagem.Caption:='MODO DE EXCLUSÃO';
  if Confirma('Deseja mesmo excluir este registro?')<>6 then begin
	  lbMensagem.Caption:='MODO DE NAVEGAÇÃO';
    abort;
  end;
  try
    tabela.Delete;
    mensagem('Registro excluido!');
  except
    mensagem('Não foi possível excluir o registro!');
  end;
  lbMensagem.Caption:='MODO DE NAVEGAÇÃO';
end;

procedure TModelo_Cadastro.btNovoClick(Sender: TObject);
begin
  btControle(false);
  tabela.Append;
  lbMensagem.Caption:='MODO DE INCLUSÃO';
end;

procedure TModelo_Cadastro.btCancelarClick(Sender: TObject);
begin
  tabela.Cancel;
  btControle(true);
  lbMensagem.Caption:='MODO DE NAVEGAÇÃO';
end;

procedure TModelo_Cadastro.btSalvarClick(Sender: TObject);
begin
  try
    tabela.Post;
    tabela.Refresh;
    btControle(true);
    lbMensagem.Caption:='MODO DE NAVEGAÇÃO';
  except
    mensagem('Não foi possível salvar os dados!');
  end;
end;

procedure TModelo_Cadastro.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  tabela.close;
end;

procedure TModelo_Cadastro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = VK_F3) and (btImprimir.Enabled = true) then begin
     key := 0;
     btImprimir.Click;
  end;
  if (key = VK_F4) and (btNovo.Enabled = true) then begin
     key := 0;
     btNovo.Click;
  end;
  if (key = VK_F5) and (btEditar.Enabled = true) then begin
     key := 0;
     btEditar.Click;
  end;
  if (key = VK_F6) and (btSalvar.Enabled = true) then begin
     key := 0;
     btSalvar.Click;
  end;
  if (key = VK_F7) and (btCancelar.Enabled = true) then begin
     key := 0;
     btCancelar.Click;
  end;
  if (key = VK_F8) and (btExcluir.Enabled = true) then begin
     key := 0;
     btExcluir.Click;
  end;
  if Key = 13 then begin
     if ssShift in Shift then
        SelectNext(activecontrol, false, true)
     else
        SelectNext(activecontrol, true, true);
     Key := 0;
  end;
end;

initialization
  {$I modelo_cad.lrs}

end.

