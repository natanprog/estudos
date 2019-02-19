program Pedidos;

{$MODE Delphi}

uses
  Forms, graphics, Interfaces, SysUtils,
  Principal in 'Principal.pas' {F_Principal},
  Funcionarios in 'Funcionarios.pas' {F_Funcionarios},
  Dm_Pedidos in 'Dm_Pedidos.pas' {F_Dm_Pedidos: TDataModule},
  Psq_Pro in 'Psq_Pro.pas' {F_Psq_Pro},
  Sobre in 'Sobre.pas' {F_Sobre},
  Psq_Fun in 'Psq_Fun.pas' {F_Psq_Fun},
  Clientes in 'Clientes.pas' {F_Clientes},
  Produtos in 'Produtos.pas' {F_Produtos},
  Psq_Cli in 'Psq_Cli.pas' {F_Psq_Cli},
  Funcoes in 'Funcoes.pas',
  IncluiPedido in 'IncluiPedido.pas' {F_IncluiPedido},
  Psq_Pedidos in 'Psq_Pedidos.pas' {F_Psq_Pedidos};

{.$R *.RES}

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TF_Dm_Pedidos, F_Dm_Pedidos);
  Application.CreateForm(TF_Principal, F_Principal);
  Application.Run;
end.
