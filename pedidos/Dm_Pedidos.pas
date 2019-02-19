unit Dm_Pedidos;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType{, LMessages, Messages}, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db{, ZAbstractRODataset, ZAbstractDataset}, ZDataset, ZConnection{,
  ZAbstractTable}, ZSqlUpdate, sqldb;

type

  { TF_Dm_Pedidos }

  TF_Dm_Pedidos = class(TDataModule)
    ZConnection: TZConnection;
    Qry_Clientes: TZQuery;
    Ds_Clientes: TDataSource;
    Qry_ClientesCOD_CLI: TIntegerField;
    Qry_ClientesLOJA_CLI: TIntegerField;
    Qry_ClientesNOME: TStringField;
    Qry_ClientesENDERECO: TStringField;
    Qry_ClientesBAIRRO: TStringField;
    Qry_ClientesCEP: TStringField;
    ZQRY_Livre: TZQuery;
    Qry_Produtos: TZQuery;
    Ds_Produtos: TDataSource;
    Qry_Funcionarios: TZQuery;
    Ds_Funcionarios: TDataSource;
    Qry_FuncionariosCOD_FUN: TIntegerField;
    Qry_FuncionariosNOME: TStringField;
    Qry_FuncionariosFONE: TStringField;
    Qry_FuncionariosCEP: TStringField;
    Qry_FuncionariosCPF: TStringField;
    Qry_ProdutosCOD_PROD: TIntegerField;
    Qry_ProdutosNOM_PRO: TStringField;
    Qry_ProdutosPRECO_VENDA: TFloatField;
    Qry_ProdutosPRECO_COMPRA: TFloatField;
    Qry_ProdutosDATA_INCLUSAO: TDateField;
    Qry_ProdutosQTDE_ESTOQUE: TFloatField;
    Qry_Pedidos_Cli_Fun: TZQuery;
    Qry_Iten_Pedido: TZQuery;
    Ds_Pedidos_Cli_Fun: TDataSource;
    Qry_Iten_PedidoCOD_ITEM: TIntegerField;
    Qry_Iten_PedidoCOD_PRO: TIntegerField;
    Qry_Iten_PedidoCOD_PED: TIntegerField;
    Qry_Iten_PedidoNOM_PRODUTO: TStringField;
    Qry_Iten_PedidoQTDE_ITEN: TFloatField;
    Qry_Iten_PedidoVALOR_ITEN: TFloatField;
    Ds_Iten_Pedido: TDataSource;
    Qry_Pedidos_Cli_FunData: TDateField;
    Qry_Pedidos_Cli_FunCliente: TStringField;
    Qry_Pedidos_Cli_FunTotaldoPedido: TFloatField;
    Qry_Pedidos_Cli_FunValorjPago: TIntegerField;
    Qry_Pedidos_Cli_FunFuncionrio: TStringField;
    Qry_Pedidos_Cli_FunCod_Pedido: TIntegerField;
    Qry_Pedidos_TodosCampos: TZQuery;
    Qry_Pedidos_TodosCamposCOD_PEDIDO: TIntegerField;
    Qry_Pedidos_TodosCamposDATA_PEDIDO: TDateField;
    Qry_Pedidos_TodosCamposVALOR_PAGO: TIntegerField;
    Qry_Pedidos_TodosCamposCOD_CLI: TIntegerField;
    Qry_Pedidos_TodosCamposLOJA_CLI: TIntegerField;
    Qry_Pedidos_TodosCamposCOD_FUN: TIntegerField;
    Ds_Pedidos_TodosCampos: TDataSource;
    Qry_Iten_PedidoSubtotal_Calc: TFloatField;
    ZQuery1Cliente: TStringField;
    ZQuery1Cod_Pedido: TLongintField;
    ZQuery1Data: TDateField;
    ZQuery1Funcionrio: TStringField;
    ZQuery1TotaldoPedido: TFloatField;
    ZQuery1ValorjPago: TLongintField;
    Upd_Funcionarios: TZUpdateSQL;
    Upd_Clientes: TZUpdateSQL;
    Upd_Produtos: TZUpdateSQL;
    Upd_Pedidos_Cli_Fun: TZUpdateSQL;
    Upd_Iten_Pedido: TZUpdateSQL;
    Upd_Pedidos_TodosCampos: TZUpdateSQL;
    procedure Qry_Iten_PedidoCalcFields(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Dm_Pedidos: TF_Dm_Pedidos;

implementation

{$R *.lfm}

procedure TF_Dm_Pedidos.Qry_Iten_PedidoCalcFields(DataSet: TDataSet);
begin
	Qry_Iten_PedidoSubtotal_Calc.Value :=
	Qry_Iten_PedidoQTDE_ITEN.Value *  Qry_Iten_PedidoVALOR_ITEN.Value;
end;

end.
