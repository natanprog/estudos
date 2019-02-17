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

unit Unit_Empresa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, StdCtrls, DbCtrls, Buttons, ExtCtrls, ExtDlgs,Unit_rotinas,UnitDados;

type

  { TForm_Empresa }

  TForm_Empresa = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Datasource1: TDatasource;
    DBComboBox1: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBImage1: TDBImage;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    OpenLogo: TOpenPictureDialog;
    Shape1: TShape;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form_Empresa: TForm_Empresa;

implementation

{ TForm_Empresa }

procedure TForm_Empresa.BitBtn3Click(Sender: TObject);
begin
  dm.Empresa.Post;
  close;
end;

procedure TForm_Empresa.BitBtn1Click(Sender: TObject);
begin
  if OpenLogo.Execute then begin
    try
      DBImage1.Picture.LoadFromFile(OpenLogo.FileName);
    except
      mensagem('Não foi possível carregar a imagem!');
    end;
  end;
end;

procedure TForm_Empresa.BitBtn2Click(Sender: TObject);
begin
  DBImage1.Picture.Clear;
end;

procedure TForm_Empresa.BitBtn4Click(Sender: TObject);
begin
  dm.Empresa.Cancel;
  close;
end;

procedure TForm_Empresa.FormShow(Sender: TObject);
begin
  dm.Empresa.Open;
  if dm.Empresa.RecordCount=0 then begin
    dm.Empresa.Append;
    dm.Empresa.FieldByName('ID').Value:=1;
  end else dm.Empresa.Edit;
end;

initialization
  {$I unit_empresa.lrs}

end.

