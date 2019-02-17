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

unit UnitPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, FileUtil, LResources, Forms, Controls,
  Graphics, Dialogs, ComCtrls, Menus, ExtCtrls, unitcad_clientes, UnitDados,
  Unit_rotinas, Unit_Empresa, unitcad_fornecedores, Unit_Config, IniFiles,
  Unit_Cad_Produtos, Unit_Cad_Grupos, Unit_Cad_Marcas, Unit_Cad_Modelos,
  Unit_Cad_Unidades;

type

  { TFormPrincipal }

  TFormPrincipal = class(TForm)
    IBConnection1: TIBConnection;
    Image1: TImage;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    SQLScript1: TSQLScript;
    SQLTransaction1: TSQLTransaction;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure FormShow(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem16Click(Sender: TObject);
    procedure MenuItem17Click(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure MenuItem20Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FormPrincipal: TFormPrincipal;

implementation

{ TFormPrincipal }

procedure TFormPrincipal.ToolButton1Click(Sender: TObject);
begin
  Application.CreateForm(TCad_Clientes, Cad_Clientes);
  Cad_Clientes.ShowModal;
  Cad_Clientes.Release;
end;

procedure TFormPrincipal.ToolButton2Click(Sender: TObject);
begin
  Cad_Produtos := TCad_Produtos.Create(self);
  Cad_Produtos.ShowModal;
  FreeAndNil(Cad_Produtos);
end;

procedure TFormPrincipal.ToolButton3Click(Sender: TObject);
begin
  Cad_Fornecedores:=TCad_Fornecedores.Create(self);
  Cad_Fornecedores.ShowModal;
  FreeAndNil(Cad_Fornecedores);
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
var ini: TIniFile;
begin
  try
     ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  except
     mensagem('Não foi possível acessar o arquivo de configuração! O programa não pode executar!');
     Application.Terminate;
  end;
  if ini.ReadString('configs','inicial','')<>'1' then begin
     mensagem('Você precisa configurar o sistema! Portanto, vou abrir o diálogo de configurações!');
     Form_Config:=TForm_Config.Create(nil);
     Form_Config.ShowModal;
     if Form_Config.ModalResult=mrOK then begin
        mensagem('Alterações Efetuadas! O programa será fechado! Abra-o novamente!');
        Application.Terminate;
     end else begin
        if Form_Config.ModalResult=mrAbort then mensagem('ERRO: Não foi possível gravar as alterações! O programa não pode executar!')
           else mensagem('ATENÇÃO: As configurações não foram salvas! O programa será fechado!');
        Application.Terminate;
     end;
  end;
  if (not FileExists(ini.ReadString('configs','banco','')+'freeestoque.fdb'))and(ini.ReadString('configs','uso','')='Servidor') then begin
    if confirma('O Banco de Dados não Existe! Deseja criá-lo ou abrir o diálogo de configuração? [Yes=Criar, No=Configurar]')<>6 then begin
       ini.WriteString('configs','inicial','0');
       ini.free;
       FormShow(sender);
    end;
    dm.banco.Disconnect;
    dm.banco.Properties.Add('CreateNewDatabase=CREATE DATABASE ' +
             QuotedStr (ini.ReadString('configs','banco','')+'freeestoque.fdb')+
             ' USER '+QuotedStr('sysdba')+' PASSWORD '+
             QuotedStr('masterkey')+
             ' PAGE_SIZE 4096 DEFAULT CHARACTER SET NONE');
    dm.banco.Connect;
    dm.banco.Disconnect;
    IBConnection1.HostName:=ini.ReadString('configs','servidor','');
    IBConnection1.DatabaseName:=ini.ReadString('configs','banco','')+'freeestoque.fdb';
    SQLTransaction1.Active:=true;
    IBConnection1.Connected:=true;
    SQLScript1.Script.LoadFromFile(ExtractFilePath(Application.ExeName)+PathDelim+'banco'+PathDelim+'freeestoque.sql');
    SQLScript1.ExecuteScript;
    SQLTransaction1.Commit;
    IBConnection1.Connected:=false;
    SQLTransaction1.Active:=false;
    dm.banco.Properties.Clear;
  end;
  dm.banco.Database:=ini.ReadString('configs','banco','')+'freeestoque.fdb';
  dm.banco.HostName:=ini.ReadString('configs','servidor','');
  try
     dm.banco.Connect;
  except
    if confirma('Não foi possível conectar-se ao banco! Deseja abrir o diálogo de configuração?')=6 then begin
       ini.WriteString('configs','inicial','0');
       ini.free;
       FormShow(sender);
    end;
     mensagem(' O programa vai ser fechado!');
     Application.Terminate;
  end;
end;

procedure TFormPrincipal.MenuItem10Click(Sender: TObject);
begin
  Form_Config:=TForm_Config.Create(self);
  Form_Config.ShowModal;
  if Form_Config.ModalResult=mrOK then mensagem('Configurações gravadas com sucesso! Feche a abra o programa novamente!')
     else if Form_Config.ModalResult=mrAbort then mensagem('ERRO: Não foi possível gravar as alterações!');
  FreeAndNil(Form_Config);
end;

procedure TFormPrincipal.MenuItem11Click(Sender: TObject);
begin
  Cad_Grupos := TCad_Grupos.Create(self);
  Cad_Grupos.ShowModal;
  FreeAndNil(Cad_Grupos);
end;

procedure TFormPrincipal.MenuItem12Click(Sender: TObject);
begin
  ToolButton2.Click;
end;

procedure TFormPrincipal.MenuItem13Click(Sender: TObject);
begin
  ToolButton3.Click;
end;

procedure TFormPrincipal.MenuItem16Click(Sender: TObject);
begin
  Cad_Marcas:=TCad_Marcas.Create(nil);
  Cad_Marcas.ShowModal;
  FreeAndNil(Cad_Marcas);
end;

procedure TFormPrincipal.MenuItem17Click(Sender: TObject);
begin
  Cad_Modelos:=TCad_Modelos.Create(nil);
  Cad_Modelos.ShowModal;
  FreeAndNil(Cad_Modelos);
end;

procedure TFormPrincipal.MenuItem18Click(Sender: TObject);
begin
  Form_Cad_Unidades:=TForm_Cad_Unidades.Create(nil);
  Form_Cad_Unidades.ShowModal;
  FreeAndNil(Form_Cad_Unidades);
end;

procedure TFormPrincipal.MenuItem20Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormPrincipal.MenuItem2Click(Sender: TObject);
begin
  ToolButton1.Click;
end;

procedure TFormPrincipal.MenuItem9Click(Sender: TObject);
begin
  Form_Empresa:=TForm_Empresa.Create(self);
  Form_Empresa.ShowModal;
  FreeAndNil(Form_Empresa);
end;

initialization
  {$I unitprincipal.lrs}

end.

