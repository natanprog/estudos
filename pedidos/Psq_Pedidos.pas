unit Psq_Pedidos;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType{, LMessages, Messages}, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, MaskEdit, Buttons, Grids, DBGrids;

type
  TF_Psq_Pedidos = class(TForm)
    Ed_Data: TMaskEdit;
    Label1: TLabel;
    Label11: TLabel;
    Label10: TLabel;
    Bt_Cadastro: TSpeedButton;
    Grd_Pedidos: TDBGrid;
    Bt_Saida: TSpeedButton;
    Chk_MostrarSelect: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Bt_CadastroClick(Sender: TObject);
    procedure Ed_DataKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Bt_SaidaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Chk_MostrarSelectClick(Sender: TObject);
    procedure Chk_MostrarSelectKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Grd_PedidosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Psq_Pedidos: TF_Psq_Pedidos;

implementation

uses Dm_Pedidos, IncluiPedido;

{$R *.lfm}

procedure TF_Psq_Pedidos.FormCreate(Sender: TObject);
begin
	ScaleBy(Screen.Width, 1920);
	//
	Grd_Pedidos.Columns[0].Width := Round(Grd_Pedidos.Columns[0].Width * (Screen.Width/1920) );
	Grd_Pedidos.Columns[1].Width := Round(Grd_Pedidos.Columns[1].Width * (Screen.Width/1920) );
	Grd_Pedidos.Columns[2].Width := Round(Grd_Pedidos.Columns[2].Width * (Screen.Width/1920) );
	Grd_Pedidos.Columns[3].Width := Round(Grd_Pedidos.Columns[3].Width * (Screen.Width/1920) );
	Grd_Pedidos.Columns[4].Width := Round(Grd_Pedidos.Columns[4].Width * (Screen.Width/1920) );
	Grd_Pedidos.Columns[5].Width := Round(Grd_Pedidos.Columns[5].Width * (Screen.Width/1920) );
   //
{  Pode-ser fazer uma implementação interessante aqui :
	* Ao teclar [Enter] visualizar os ITENS do PEDIDO e colocar o  FOCO nos ITENS ;
	* Ao perder o foco do GRID de ITENS, ficar invisível GRID com itens e ;
	Grd_Itens.Columns[0].Width := Round(Grd_Itens.Columns[0].Width * (Screen.Width/1920) );
	Grd_Itens.Columns[1].Width := Round(Grd_Itens.Columns[1].Width * (Screen.Width/1920) );
	Grd_Itens.Columns[2].Width := Round(Grd_Itens.Columns[2].Width * (Screen.Width/1920) ); }
end;

procedure TF_Psq_Pedidos.FormActivate(Sender: TObject);
begin
	Top := 0; // Coloca formulário no TOPO do monitor. Se colocando no evento ONSHOW, não funciona ;
end;

procedure TF_Psq_Pedidos.Bt_CadastroClick(Sender: TObject);
begin
	If F_Dm_Pedidos.QRY_Pedidos_Cli_Fun.Active=False then
	begin
		Application.MessageBox('Filtre primeiro, para depois entrar na consulta de Pedidos',
		'Nenhum registro selecionado', Mb_Ok + mb_IconWarning);
		Exit;
	End;

	//	Filtrando ITENS do PEDIDO selecionado
	With F_Dm_Pedidos.Qry_Iten_Pedido do
	Begin
		SQL.CLEAR;
		SQL.Append('Select * from ITEN_PEDIDO');
		SQL.Append('Where COD_PED=' +
		F_Dm_Pedidos.Qry_Pedidos_Cli_Fun.FieldByName('Cod_Pedido').AsString );
		Open;
	End;
	//
	// Se o formulário não foi enviado para memória, envia-o ;
	If F_IncluiPedido=Nil then  Application.CreateForm(TF_IncluiPedido, F_IncluiPedido);
	//
	// Atualizando  QUERY da tela F_IncluiPedido
	With F_Dm_Pedidos.Qry_Pedidos_TodosCampos do
	Begin
		SQL.Clear;
		SQL.Append('Select * from Pedidos');
		SQL.Append('Where COD_PEDIDO='+
		F_Dm_Pedidos.Qry_Pedidos_Cli_Fun.FieldByName('COD_PEDIDO').AsString);
		Open; 
	End; // Fim :  Atualizando  QUERY da tela F_IncluiPedido

	F_IncluiPedido.ShowModal;  // Visualiza o form de Inclusão de Pedidos ;
	//
	F_Dm_Pedidos.QRY_Pedidos_Cli_Fun.Refresh;
	//
	Ed_Data.Setfocus;
end;

procedure TF_Psq_Pedidos.Ed_DataKeyPress(Sender: TObject; var Key: Char);
Var
Data_MMDDAAAA : String;
begin
{ O "SELECT" Abaixo, foi criado VISUALMENTE pelo IBEASY ;
=> Ela seleciona o CÓD.PEDIDO, DATA DO PEDIDO, NOME DO CLIENTE, NOME DO FUNCIONÁRIO,
TOTAL DO PEDIDO e VALOR JÁ PAGO DO PEDIDO ;

SELECT
PEDIDOS.COD_PEDIDO as "Cod_Pedido", PEDIDOS.DATA_PEDIDO as "Data",
CLIENTE.NOME as "Cliente"         , FUNCIONARIOS.NOME as "Funcionário",

Sum(QTDE_ITEN*VALOR_ITEN ) as  "Total do Pedido",
PEDIDOS.VALOR_PAGO as "Valor já Pago"

FROM ITEN_PEDIDO,CLIENTE,PEDIDOS,FUNCIONARIOS

WHERE PEDIDOS.LOJA_CLI=CLIENTE.LOJA_CLI
AND PEDIDOS.COD_CLI=CLIENTE.COD_CLI         AND PEDIDOS.COD_FUN=FUNCIONARIOS.COD_FUN
AND ITEN_PEDIDO.COD_PED=PEDIDOS.COD_PEDIDO
GROUP BY
PEDIDOS.COD_PEDIDO, PEDIDOS.DATA_PEDIDO, CLIENTE.NOME, FUNCIONARIOS.NOME, PEDIDOS.VALOR_PAGO
}


	// Filtrando PEDIDO por DATA digitada
	If key='+' then
	With F_Dm_Pedidos.Qry_Pedidos_Cli_Fun do
	Begin
		// 1) Testar Data;
		Try StrToDate( Ed_Data.Text )
		Except
			Application.MessageBox(
			'Digite novamente',
			'Data Inválida', Mb_Ok + Mb_IconWarning);
         Ed_Data.Clear; Ed_Data.SetFocus;
			Exit;
		End;

		// 2) Se data INVÁLIDA, então emite aviso e limpa caixa de digitação

		// Invertendo a data para colocá-la no select : dd/mm/yyyy => mm/dd/yyyy
		Data_MMDDAAAA :=
		Copy( Ed_Data.Text, 4,2 )+'/'+ Copy( Ed_Data.Text, 1,2 ) + '/'+  Copy( Ed_Data.Text, 7,4 );
		// 					MÊS							DIA										ANO               			
		// .......................................................................................... //
		SQL.CLEAR;
      // 
		SQL.Append('SELECT PEDIDOS.COD_PEDIDO as "Cod_Pedido", PEDIDOS.DATA_PEDIDO as "Data", ');
		SQL.Append('CLIENTE.NOME as "Cliente"         , FUNCIONARIOS.NOME as "Funcionário",');
		SQL.Append(' ');
		//
		SQL.Append('Sum(QTDE_ITEN*VALOR_ITEN ) as  "Total do Pedido",');
		SQL.Append('PEDIDOS.VALOR_PAGO as "Valor já Pago"');
		SQL.Append(' ');
		//
		SQL.Append('FROM ITEN_PEDIDO,CLIENTE,PEDIDOS,FUNCIONARIOS');
		//
		SQL.Append(' ');
		SQL.Append('WHERE PEDIDOS.LOJA_CLI=CLIENTE.LOJA_CLI');
		SQL.Append('AND PEDIDOS.COD_CLI=CLIENTE.COD_CLI');
		SQL.Append('AND PEDIDOS.COD_FUN=FUNCIONARIOS.COD_FUN');
		SQL.Append('AND ITEN_PEDIDO.COD_PED=PEDIDOS.COD_PEDIDO  ');
		//
		SQL.Append('AND PEDIDOS.DATA_PEDIDO = '+  QuotedStr(Data_MMDDAAAA) );		
		//
		SQL.Append(' ');		
		SQL.Append('GROUP BY');
		SQL.Append('PEDIDOS.COD_PEDIDO, PEDIDOS.DATA_PEDIDO, CLIENTE.NOME, FUNCIONARIOS.NOME, PEDIDOS.VALOR_PAGO');
		//
		if Chk_MostrarSelect.Checked=True then
		showmessage('Veja a QUERY montada :'+#13+#13+SQL.Text);
		//
		OPEN;
	end;

	// Mostrando TODOS pedidos ;
	If key='*' then
	With F_Dm_Pedidos.Qry_Pedidos_Cli_Fun do
	Begin
		SQL.CLEAR;

		SQL.Append('SELECT PEDIDOS.COD_PEDIDO as "Cod_Pedido", PEDIDOS.DATA_PEDIDO as "Data", ');
		SQL.Append('CLIENTE.NOME as "Cliente"         , FUNCIONARIOS.NOME as "Funcionário",');
		//
		SQL.Append('Sum(QTDE_ITEN*VALOR_ITEN ) as  "Total do Pedido",');
		SQL.Append('PEDIDOS.VALOR_PAGO as "Valor já Pago"');
		//
		SQL.Append('FROM ITEN_PEDIDO,CLIENTE,PEDIDOS,FUNCIONARIOS');
		SQL.Append('WHERE PEDIDOS.LOJA_CLI=CLIENTE.LOJA_CLI');
		SQL.Append('AND PEDIDOS.COD_CLI=CLIENTE.COD_CLI');
		SQL.Append('AND PEDIDOS.COD_FUN=FUNCIONARIOS.COD_FUN');
		SQL.Append('AND ITEN_PEDIDO.COD_PED=PEDIDOS.COD_PEDIDO  ');
      //
		SQL.Append('GROUP BY');
		SQL.Append('PEDIDOS.COD_PEDIDO, PEDIDOS.DATA_PEDIDO, CLIENTE.NOME, FUNCIONARIOS.NOME, PEDIDOS.VALOR_PAGO');
		//
		SQL.Append('Order By PEDIDOS.DATA_PEDIDO');
		//
		if Chk_MostrarSelect.Checked=True then
		showmessage('Veja a QUERY montada :'+#13+#13+SQL.Text);
		//
		OPEN;
	end;



end;

procedure TF_Psq_Pedidos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	With F_Dm_Pedidos do
	If F_Dm_Pedidos.QRY_Pedidos_Cli_Fun.Active then
	With F_Dm_Pedidos.QRY_Pedidos_Cli_Fun do
	Case key of
		Vk_Up    : MoveBy(-1);  // Seta para Cima
		Vk_Down  : MoveBy(+1);  // Seta para Baixo
		//
		Vk_Prior : MoveBy(-10); // Page UP
		Vk_Next  : MoveBy(+10); // Page DOWN
	End;
	// .......................................................................................... //
	Case Key of
		Vk_Escape : Close;
		//
		Vk_Return :
		Begin
			Key := 0; // Cancelando tecla digitada, para não abrir "menu do windows"
			Bt_Cadastro.click;
		End;
	end;

end;

procedure TF_Psq_Pedidos.Bt_SaidaClick(Sender: TObject);
begin
	Close
end;

procedure TF_Psq_Pedidos.FormShow(Sender: TObject);
begin
	F_Dm_Pedidos.ZConnection.Connected := True;
end;

procedure TF_Psq_Pedidos.Chk_MostrarSelectClick(Sender: TObject);
begin
	Ed_Data.Setfocus
end;

procedure TF_Psq_Pedidos.Chk_MostrarSelectKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
	// Se a pessoa pressionar alguma tecla, com o foco neste objeto, envia foco para caixa de edição
	Ed_Data.Setfocus;
end;

procedure TF_Psq_Pedidos.Grd_PedidosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	// Se a pessoa pressionar alguma tecla, com o foco neste objeto, envia foco para caixa de edição
	Ed_Data.Setfocus;
end;

end.
