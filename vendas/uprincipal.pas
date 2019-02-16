unit uPrincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  uDTMConexao, uCadCategoria, Enter;

type

  { TfrmPrincipal }

  TfrmPrincipal = class(TForm)
    mainPrincipal: TMainMenu;
    menuCadastro: TMenuItem;
    menuVendas: TMenuItem;
    menuRelatorioCliente: TMenuItem;
    MenuItem12: TMenuItem;
    menuRelatorioProduto: TMenuItem;
    MenuItem14: TMenuItem;
    menuRelatorioVendaPorData: TMenuItem;
    menuMovimentacao: TMenuItem;
    menuRelatorios: TMenuItem;
    menuCliente: TMenuItem;
    MenuItem5: TMenuItem;
    menuCategoria: TMenuItem;
    menuProduto: TMenuItem;
    MenuItem8: TMenuItem;
    menuFechar: TMenuItem;
    procedure FormClose(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure menuCategoriaClick(Sender: TObject);
    procedure menuFecharClick(Sender: TObject);
  private
    TeclaEnter : TMREnter;
  public

  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.lfm}

{ TfrmPrincipal }

procedure TfrmPrincipal.menuFecharClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  {
  dtmPrincipal := TdtmPrincipal.Create(Self);
  dtmPrincipal.ConexaoDB.SQLHourGlass := True;
  dtmPrincipal.ConexaoDB.Protocol := 'FreeTDS_MsSQL>=2005';
  dtmPrincipal.ConexaoDB.LibraryLocation := '/usr/lib/x86_64-linux-gnu/libsybdb.so';
  dtmPrincipal.ConexaoDB.HostName := 'localhost';
  dtmPrincipal.ConexaoDB.Port := 1433;
  dtmPrincipal.ConexaoDB.User := 'SA';
  dtmPrincipal.ConexaoDB.Password := 'Zero2040';
  dtmPrincipal.ConexaoDB.Database := 'vendas';
  dtmPrincipal.ConexaoDB.Connected := True;
  }
  dtmPrincipal := TdtmPrincipal.Create(Self);
  with dtmPrincipal.ConexaoDB do begin
    SQLHourGlass := True;
    Protocol := 'FreeTDS_MsSQL>=2005';
    LibraryLocation := '/usr/lib/x86_64-linux-gnu/libsybdb.so';
    HostName := 'localhost';
    Port := 1433;
    User := 'SA';
    Password := 'Zero2040';
    Database := 'vendas';
    Connected := True;
  end;
  TeclaEnter := TMREnter.Create(Self);
  with TeclaEnter do begin
    FocusEnabled := True;
    FocusColor := clInfoBk;
  end;
end;

procedure TfrmPrincipal.FormClose(Sender: TObject);
begin
  FreeAndNil(TeclaEnter);
  FreeAndNil(dtmPrincipal);
end;

procedure TfrmPrincipal.menuCategoriaClick(Sender: TObject);
begin
  frmCadCategoria := TfrmCadCategoria.Create(Self);
  frmCadCategoria.ShowModal;
  frmCadCategoria.Release;
end;

end.

