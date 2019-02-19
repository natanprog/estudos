unit Produtos;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType{, LMessages, Messages}, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, DBCtrls, StdCtrls, MaskEdit{, Grids}, DBGrids, ComCtrls;

type
  TF_Produtos = class(TForm)
    Panel3: TPanel;
    Pn_Confirma_Cancela: TPanel;
    Bt_Confirmar: TSpeedButton;
    Bt_Cancelar: TSpeedButton;
    Pn_Manutencao: TPanel;
    Bt_Incluir: TSpeedButton;
    Bt_Alterar: TSpeedButton;
    Bt_Excluir: TSpeedButton;
    Pn_Edicao: TPanel;
    Label8: TLabel;
    Bt_Retornar: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Db_NOM_PRO: TDBEdit;
    Label3: TLabel;
    Db_PRECO_VENDA: TDBEdit;
    Label4: TLabel;
    Db_PRECO_COMPRA: TDBEdit;
    Label5: TLabel;
    Db_DATA_INCLUSAO: TDBEdit;
    Label6: TLabel;
    Db_QTDE_ESTOQUE: TDBEdit;
    Panel2: TPanel;
    RichEdit2: TMemo;
    Panel1: TPanel;
    RichEdit1: TMemo;
    DbT_COD_PROD: TDBText;
    DBNavigator1: TDBNavigator;
    procedure Bt_IncluirClick(Sender: TObject);
    procedure Bt_AlterarClick(Sender: TObject);
    procedure Bt_ExcluirClick(Sender: TObject);
    procedure Bt_ConfirmarClick(Sender: TObject);
    procedure Bt_CancelarClick(Sender: TObject);
	 procedure Bt_RetornarClick(Sender: TObject);
	 procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Db_NOM_PROKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Produtos: TF_Produtos;

Var_Private_Incluindo_Alterando : String[1];

implementation

uses DB{dsInsert}{, Funcoes}, Dm_Pedidos;

{$R *.lfm}

Procedure Habilita_EDICAO(Editar:Boolean);
Begin
	With F_Produtos do  // Ajusta os objetos da tela, conforme o valor enviado para "EDITAR"
	Begin
      // AO EDITAR(incluir/Alterar) :Deixa VISÍVEL botões de CONFIRMAR/CANCELAR ;
	   Pn_Confirma_Cancela.Visible := Editar;
      Pn_Edicao.Enabled := Editar; // Ao editar, habilita Painel com caixas de Edição
		Pn_Manutencao.Visible := NOT(Editar); // AO EDITAR(incluir/Alterar) :Deixa INVISÍVEL botões de INCLUIR+ALTERAR+EXCLUIR+RETORNAR ;
		//
		If Editar=True then
		Begin
			Db_NOM_PRO.Setfocus; // Se editar, AJUSTA FOCO
			//
			// Ajustando a MÁSCARA para digitação de dados ;
			// Atenção : Este tipo de máscara, no próprio objeto "field" do banco de dados,
			// só pode ser usado AO EDITAR UM CAMPO. Depois , retira-se a máscara
			F_Dm_Pedidos.Qry_ProdutosDATA_INCLUSAO.EditMask := '99/99/9999;1;_';
		End
		Else
		// Ajustando a MÁSCARA para digitação de dados ;
		// Atenção : Este tipo de máscara, no próprio objeto "field" do banco de dados,
		// só pode ser usado AO EDITAR UM CAMPO. Depois , retira-se a máscara
		F_Dm_Pedidos.Qry_ProdutosDATA_INCLUSAO.EditMask := '';
	End;
End;



procedure TF_Produtos.Bt_IncluirClick(Sender: TObject);
begin
   // Se a ZQUERY tiver fechada, tem-se que abrí-la antes,
   // selecionando qualquer registro, OU MESMO "NENHUM",
   // para que o método "INSERT" a ser dado na TABLE, funcione.
   // Isto acontece porque um "INSERT" exige uma "transação aberta".
   If F_Dm_Pedidos.Qry_Produtos.Active=False then
	With F_Dm_Pedidos.Qry_Produtos do
   Begin
		Sql.Clear ;
		Sql.Append('Select * from Produtos');
		Sql.Append('Where COD_PROD is null'); // Pode selecionar qualquer Produto ;
      Open;
	End;
   //
   // Tentando executar método "APPEND" (inserção de registros, no final da table)
	Try
		// MÉTODO "APPEND" ou "INSERT" : Coloca registro atual em INCLUSÃO
   	F_Dm_Pedidos.Qry_Produtos.Append ;
   Except On E:Exception do
      Begin
         Application.MessageBox( Pchar(
         'ERRO  : "'+ E.Message +'" ;' ),
         'Impossível Atualizar Registro', MB_Ok);
         EXIT;
      End;
   End;
	//
	// Ajustando TODOS OBJETOS para INCLUSÃO :
	Habilita_EDICAO( TRUE );
	//
	// Enviando a DATA ATUAL para o campo data, NA INCLUSÃO DO REGISTRO ;
	// NOW 	=> Retorna DATA + HORA atuais ;
	// DATE 	=> Retorna DATA ATUAL ;
	// TIME  => Retorna HORA ATUAL ;
  	F_Dm_Pedidos.Qry_Produtos.FieldByName( 'DATA_INCLUSAO' ).AsDateTime := Now;
end;

procedure TF_Produtos.Bt_AlterarClick(Sender: TObject);
begin
	if F_Dm_Pedidos.Qry_Produtos.Active=False then
	Begin
		Application.MessageBox('Apenas INCLUA, pois não selecionou nenhum registro',
		'Filtre antes de Visualizar Produto', Mb_Ok + Mb_IconInformation);
		Exit;
	End;
	//
	if F_Dm_Pedidos.Qry_Produtos.RecordCount=0 then
	Begin
		Application.MessageBox('Apenas INCLUA, pois não tem nenhum registro sendo visualizado',
		'Nenhum registro sendo visualizado', Mb_Ok + Mb_IconInformation);
		Exit;
	End;
	//
	Try
		// MÉTODO "EDIT" : Coloca registro atual em ALTERAÇÃO
   	F_Dm_Pedidos.Qry_Produtos.Edit ;
   Except On E:Exception do
      Begin
         Application.MessageBox( Pchar(
         'ERRO  : "'+ E.Message +'" ;' ),
         'Impossível Atualizar Registro', MB_Ok);
         EXIT;
      End;
   End;
	//
	// Ajustando TODOS OBJETOS para ALTERAÇÃO :
	Habilita_EDICAO( TRUE );

end;









procedure TF_Produtos.Bt_ConfirmarClick(Sender: TObject);
Var
Nome_Incluido_ou_Alterado : String ;
Estava_Incluindo          : Boolean;
Cod_Pro_SeraIncluido      : Integer;
begin
	Cod_Pro_SeraIncluido := 0;
	// Grava na variável, se estava INCLUINDO ou não ;
	Estava_Incluindo := F_Dm_Pedidos.Qry_Produtos.State=DsInsert; // DsInsert => Unit DB
	//
	// .................................................................. //
	// Início : Se for incluir, grava o cód. do funcionário que será incluído ;
	// .................................................................. //
	// O select abaixo, busca o valor atual do generator :
	// Select gen_id ( GEN_xxx_ID ,0 ) from rdb$database}
	// .................................................................. //
	// Obtendo valor do generator da tabela , para FILTRAR ao final da inclusão ;
	If Estava_Incluindo=True then
	With F_Dm_Pedidos.ZQRY_Livre do
	Begin
		SQL.CLEAR;
		SQL.APPEND('Select gen_id ( GEN_PRODUTOS_ID ,0 )');
		SQL.APPEND('From rdb$database');
		Open;
		// Cód. que será incluído é o CÓD. do GENERATOR, + 1
		Cod_Pro_SeraIncluido :=  FieldByname('GEN_ID').AsInteger + 1;
		//
		Close; // Após obter o valor, pode fechar query ;
	End;
	// Fim : Se for incluir, grava o cód. do REGISTRO que será incluído ;
	// .................................................................. //
	//
	Try
		F_Dm_Pedidos.Qry_Produtos.ApplyUpdates ; // Confirma alteração / Exclusão / Inclusão
   Except On E:Exception do
      Begin
         Application.MessageBox( Pchar(
         'ERRO  : "'+ E.Message +'" ;' ),
         'Impossível Atualizar Registro', MB_Ok);
         EXIT;
      End;
   End;
   //
	F_Dm_Pedidos.ZConnection.Commit; // GRAVA FISICAMENTE, finaliza transação, e destrava o registro


	//
	// .................................................................. //
	// * Abrindo um SELECT para selecionar o PRÓPRIO REGISTRO que acabou de INCLUIR.
	// .................................................................. //
	// * Isto fará atualizar o campo "AUTOINCREMENTO" gerado pela TRIGGER,
	// e evitará o CACHE do ZEOS, que porventura, deixaria temporariamente invisível
	// o cód.do REGISTRO (que foi, como disse, gerado pela trigger) ;
	If Estava_Incluindo=True then
	With F_Dm_Pedidos.Qry_Produtos do
	Begin
		Nome_Incluido_ou_Alterado := Db_NOM_PRO.Text ;
		Sql.Clear ;
		Sql.Append('Select * from PRODUTOS');
		Sql.Append('Where COD_PROD='+ IntToStr(Cod_Pro_SeraIncluido));
		// SHOWMESSAGE(SQL.TEXT);
		Open;
	End;
	// Fim : Abrindo um SELECT para selecionar o PRÓPRIO REGISTRO que acabou de INCLUIR.	
	// .................................................................. //
	//


	Habilita_EDICAO( FALSE );
end;

procedure TF_Produtos.Bt_CancelarClick(Sender: TObject);
begin
	F_Dm_Pedidos.Qry_Produtos.CancelUpdates ;
	Habilita_EDICAO( FALSE );
end;

procedure TF_Produtos.Bt_ExcluirClick(Sender: TObject);
begin
	if F_Dm_Pedidos.Qry_Produtos.Active=False then
	Begin
		Application.MessageBox('Apenas INCLUA, pois não selecionou nenhum registro',
		'Filtre antes de Visualizar Produto', Mb_Ok + Mb_IconInformation);
		Exit;
	End;
	//
	if F_Dm_Pedidos.Qry_Produtos.RecordCount=0 then
	Begin
		Application.MessageBox('Apenas INCLUA, pois não tem nenhum registro sendo visualizado',
		'Nenhum registro sendo visualizado', Mb_Ok + Mb_IconInformation);
		Exit;
	End;
	//
   // Confirmando EXCLUSÃO de REGISTRO
	if Application.MessageBox( 'Deseja excluir o registro', 'Responda com Atenção',
	Mb_YesNo + Mb_IconQuestion)=mrNo then Exit;
	//
	Try
		// MÉTODO "DELETE"  : Coloca registro atual em EXCLUSÃO
   	F_Dm_Pedidos.Qry_Produtos.Delete ;       // Executa método de Exclusão do registro atual ;
		F_Dm_Pedidos.Qry_Produtos.ApplyUpdates ; // Confirma alteração / Exclusão / Inclusão
	   F_Dm_Pedidos.ZConnection.Commit; // GRAVA FISICAMENTE, finaliza transação, e destrava o registro
   Except On E:Exception do
      Begin
         Application.MessageBox( Pchar(
         'ERRO  : "'+ E.Message +'" ;' ),
         'Impossível EXCLUIR Registro', MB_Ok);
         EXIT;
      End;
	End;
	//
	// Se não "sobrou" nenhum registro sendo visualizado, fecha o formulário
	if F_Dm_Pedidos.Qry_Produtos.RecordCount=0 then
	Begin
		F_Dm_Pedidos.Qry_Produtos.Close;
		F_Produtos.Close;
	End;
end;

procedure TF_Produtos.Bt_RetornarClick(Sender: TObject);
begin
	F_Produtos.Close  ; // Poderia ser somente CLOSE,
   // que já estaria subentendido o form
end;

procedure TF_Produtos.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	If Pn_Manutencao.Visible=True then // Se NÃO ESTIVER alterando ou incluindo
	If F_Dm_Pedidos.Qry_Produtos.Active=True then  // Se query aberta
	With F_Dm_Pedidos.Qry_Produtos do
	Case Key of
		Vk_Right: MoveBy(+1); // [SetaDireita ]  = Próx.Registro    // Qry.MoveBy(+1);
		Vk_Left : MoveBy(-1); // [SetaEsquerda]  = Reg.Anterior     // Qry.MoveBy(-1);
		Vk_Up   : First     ; // [Seta p/ Cima]  = Primeiro Registro// Qry.First;
		Vk_Down : Last      ; // [Seta p/ Baixo] = Reg.Anterior     // Qry.Last;
	End;
	//
	// Se NÃO ESTIVER alterando ou incluindo
	If Pn_Manutencao.Visible=True then
	Case Key of
		// Teclou DELETE, TENTA EXCLUIR ;
		Vk_Delete : Bt_Excluir.Click	;

		// Teclou INSERT, entra em INCLUSÃO
		Vk_Insert :
      Begin
         Bt_Incluir.Click	; Exit;
		End;
		// Teclou ENTER, entra em ALTERAÇÃO
		Vk_Return : Bt_Alterar.Click	;

		// Teclou ESC, fecha formulário
		Vk_Escape : Close	;
	End; 	// FIM : Se NÃO ESTIVER alterando ou incluindo
	// ------------------------------------------------------------ //
	// Se ESTIVER alterando ou incluindo
	If Pn_Manutencao.Visible=False then
	Case Key of
		// Teclou INSERT, confirma INCLUSÃO/ALTERAÇÃO ;
		Vk_Insert : Bt_Confirmar.Click	;

		// Teclou ESC, confirma INCLUSÃO/ALTERAÇÃO ;
		Vk_Escape : Bt_Cancelar.Click		;
	End; // FIM : Se ESTIVER alterando ou incluindo
	// ------------------------------------------------------------ //
end;

procedure TF_Produtos.FormCloseQuery(Sender: TObject;  var CanClose: Boolean);
begin
	// Evitando sair do form, quando estiver INCLUINDO ou ALTERANDO registros ;
	If Pn_Confirma_Cancela.Visible then  // mesmo que :  If Pn_Confirma_Cancela.Visible=True then
	Begin
		Application.MessageBox(
		'Confirme ou cancele antes de sair do formulário',
		'Editando registros - Impossível sair', Mb_Ok + Mb_IconWarning);
		//
		// Parâmetro que, se ajustado para FALSE, evita fechamento do formulário
		Canclose:=False;
	End;
end;

procedure TF_Produtos.FormKeyPress(Sender: TObject; var Key: Char);
begin
	// Quando o FOCO estiver no PRIMEIRO CAMPO, não pode executar a função abaixo,
	// pois ao teclar ENTER para alterar, automaticamente passaria para o segundo campo.
	// Então "anulo" a função e executo no próprio evento ONKEYPRESS do NOME 
	//
	// Se estiver ALTERANDO ou INCLUINDO, troca ENTER por TAB
	If Pn_Confirma_Cancela.Visible then
	If (Db_QTDE_ESTOQUE.focused=False) and (Db_NOM_PRO.focused=False) then	//Se o foco não estiver na QTDE EM ESTOQUE
	//EnterToTab_FKeyPress(Key);
end;

procedure TF_Produtos.Db_NOM_PROKeyPress(Sender: TObject; var Key: Char);
begin
	If Key=#13 then Db_PRECO_VENDA.Setfocus;
end;

end.
