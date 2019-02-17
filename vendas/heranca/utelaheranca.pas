unit uTelaHeranca;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, MaskEdit, Buttons, DBGrids, DbCtrls, StdCtrls, ZDataset,
  uDTMConexao, uEnum;

type

  { TfrmTelaHeranca }

  TfrmTelaHeranca = class(TForm)
    btnNovo: TBitBtn;
    btnAlterar: TBitBtn;
    btnCancelar: TBitBtn;
    btnGravar: TBitBtn;
    btnApagar: TBitBtn;
    btnFechar: TBitBtn;
    btnPesquisar: TBitBtn;
    btnNavigator: TDBNavigator;
    dtsListagem: TDataSource;
    grdListagem: TDBGrid;
    lblIndice: TLabel;
    mskPesquisar: TMaskEdit;
    pnlListagemTopo: TPanel;
    pgcPrincipal: TPageControl;
    pnlRodape: TPanel;
    tabListagem: TTabSheet;
    tabManutencao: TTabSheet;
    qryListagem: TZQuery;
    procedure btnAlterarClick(Sender: TObject);
    procedure btnApagarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure FormClose(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure grdListagemTitleClick(Column: TColumn);
  private
    EstadoDoCadastro : TEstadoDoCadastro;
    procedure ControlarBotoes(cbNovo, cbAlterar, cbCancelar, cbGravar,
      cbApagar: TBitBtn; cbNavegador: TDBNavigator; cbPage: TPageControl;
      cbFlag: Boolean);
    procedure ControlarIndiceTab(citPageControl: TPageControl;
      citIndice: Integer);
    function RetornarCampoTraduzido(Campo: String): String;
  public
    IndiceAtual : String;
  end;

var
  frmTelaHeranca: TfrmTelaHeranca;

implementation

{$R *.lfm}

{ TfrmTelaHeranca }

// Procedimentos de Controle de Tela
procedure TfrmTelaHeranca.ControlarIndiceTab(citPageControl : TPageControl;
          citIndice : Integer);
begin
  if (citPageControl.Pages[citIndice].TabVisible) then
    citPageControl.TabIndex := citIndice;
end;

procedure TfrmTelaHeranca.ControlarBotoes(cbNovo, cbAlterar, cbCancelar,
          cbGravar, cbApagar : TBitBtn; cbNavegador : TDBNavigator; cbPage :
          TPageControl; cbFlag : Boolean);
begin
  cbNovo.Enabled := cbFlag;
  cbAlterar.Enabled := cbFlag;
  cbCancelar.Enabled := not(cbFlag);
  cbGravar.Enabled := not(cbFlag);
  cbApagar.Enabled := cbFlag;
  cbNavegador.Enabled := cbFlag;
  cbPage.Pages[0].TabVisible := cbFlag;
end;

function TfrmTelaHeranca.RetornarCampoTraduzido(Campo : String) : String;
var i : Integer;
begin
  for i := 0 to (qryListagem.Fields.Count - 1) do begin
    if qryListagem.Fields[i].FieldName = Campo then begin
      Result := qryListagem.Fields[i].DisplayLabel;
      Break;
    end;
  end;
end;

procedure TfrmTelaHeranca.FormCreate(Sender: TObject);
begin
  qryListagem.Connection := dtmPrincipal.ConexaoDB;
  dtsListagem.DataSet := qryListagem;
  grdListagem.DataSource := dtsListagem;
  //EstadoDoCadastro := ecNenhum;
end;

procedure TfrmTelaHeranca.FormShow(Sender: TObject);
begin
  if (qryListagem.SQL.Text <> EmptyStr) then
    qryListagem.Open;
end;

procedure TfrmTelaHeranca.grdListagemTitleClick(Column: TColumn);
begin
  IndiceAtual := Column.FieldName;
  qryListagem.IndexFieldNames := IndiceAtual;
  lblIndice.Caption := RetornarCampoTraduzido(IndiceAtual);
end;

procedure TfrmTelaHeranca.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmTelaHeranca.btnGravarClick(Sender: TObject);
begin
  try
    ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
    btnNavigator, pgcPrincipal, True);
    ControlarIndiceTab(pgcPrincipal, 0);
    //if (EstadoDoCadastro = ecNovo) then
    //  ShowMessage('Novo')
    //else if (EstadoDoCadastro = ecAlterar) then
    //  ShowMessage('Altera')
    //else
    //  ShowMessage('Nada Acontece');
  finally
    EstadoDoCadastro := ecNenhum;
  end;
end;

procedure TfrmTelaHeranca.btnAlterarClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
  btnNavigator, pgcPrincipal, False);
  EstadoDoCadastro := ecAlterar;
end;

procedure TfrmTelaHeranca.btnApagarClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
  btnNavigator, pgcPrincipal, True);
  ControlarIndiceTab(pgcPrincipal, 0);
  EstadoDoCadastro := ecNenhum;
end;

procedure TfrmTelaHeranca.btnCancelarClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
  btnNavigator, pgcPrincipal, True);
  ControlarIndiceTab(pgcPrincipal, 0);
  EstadoDoCadastro := ecNenhum;
end;

procedure TfrmTelaHeranca.btnNovoClick(Sender: TObject);
begin
  ControlarBotoes(btnNovo, btnAlterar, btnCancelar, btnGravar, btnApagar,
  btnNavigator, pgcPrincipal, False);
  EstadoDoCadastro := ecNovo;
end;

procedure TfrmTelaHeranca.FormClose(Sender: TObject);
begin
  qryListagem.Close;
end;

end.

