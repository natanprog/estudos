unit Funcionarios;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType{, LMessages, Messages}, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, DBCtrls, StdCtrls, MaskEdit{, Grids}, DBGrids, ComCtrls;

type
  TF_Funcionarios = class(TForm)
    Panel3: TPanel;
    Pn_Confirma_Cancela: TPanel;
    Bt_Confirmar: TSpeedButton;
    Bt_Cancelar: TSpeedButton;
    Pn_Manutencao: TPanel;
    Bt_Incluir: TSpeedButton;
    Bt_Alterar: TSpeedButton;
    Bt_Excluir: TSpeedButton;
    Pn_Edicao: TPanel;
    Dbt_Cod_Fun: TDBText;
    Label8: TLabel;
    Bt_Retornar: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    DbEd_Nome: TDBEdit;
    Label4: TLabel;
    DbEd_Fone: TDBEdit;
    Label5: TLabel;
    DbEd_CEP: TDBEdit;
    Label6: TLabel;
    DbEd_CPF: TDBEdit;
    DBNavigator1: TDBNavigator;
    Panel2: TPanel;
    RichEdit2: TMemo;
    Panel1: TPanel;
    RichEdit1: TMemo;
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
    procedure DbEd_NomeKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Funcionarios: TF_Funcionarios;

implementation

uses DB{dsInsert e TBookMark}{, Funcoes}, Dm_Pedidos;

{$R *.lfm}

Procedure Habilita_EDICAO(Editar:Boolean);
Begin
	With F_Funcionarios do  // Ajusta os objetos da tela, conforme o valor enviado para "EDITAR"
	Begin
      // AO EDITAR(incluir/Alterar) :Deixa VISÍVEL botões de CONFIRMAR/CANCELAR ;
	   Pn_Confirma_Cancela.Visible := Editar;
      Pn_Edicao.Enabled := Editar; // Ao editar, habilita Painel com caixas de Edição
		Pn_Manutencao.Visible := NOT(Editar); // AO EDITAR(incluir/Alterar) :Deixa INVISÍVEL botões de INCLUIR+ALTERAR+EXCLUIR+RETORNAR ;
		//
		If Editar=True then
		Begin
			DbEd_Nome.Setfocus; // Se editar, AJUSTA FOCO
			//
			// Ajustando a MÁSCARA para digitação de dados ;
			// Atenção : Este tipo de máscara, no próprio objeto "field" do banco de dados,
			// só pode ser usado AO EDITAR UM CAMPO. Depois , retira-se a máscara
			F_Dm_Pedidos.Qry_FuncionariosCPF.EditMask := '!999\.999\.999\-99;1;_';
			F_Dm_Pedidos.Qry_FuncionariosCEP.EditMask := '!99999\-999;1;_';
		End
		Else
		Begin
			// Ajustando a MÁSCARA para digitação de dados ;
			// Atenção : Este tipo de máscara, no próprio objeto "field" do banco de dados,
			// só pode ser usado AO EDITAR UM CAMPO. Depois , retira-se a máscara
			F_Dm_Pedidos.Qry_FuncionariosCPF.EditMask := '';
			F_Dm_Pedidos.Qry_FuncionariosCEP.EditMask := '';
		End;


	End;
End;



procedure TF_Funcionarios.Bt_IncluirClick(Sender: TObject);
begin
   // Se a ZQUERY tiver fechada, tem-se que abrí-la antes,
   // selecionando qualquer registro, OU MESMO "NENHUM",
   // para que o método "INSERT" a ser dado na TABLE, funcione.
   // Isto acontece porque um "INSERT" exige uma "transação aberta".
   If F_Dm_Pedidos.Qry_Funcionarios.Active=False then
	With F_Dm_Pedidos.Qry_Funcionarios do
   Begin
		Sql.Clear ;
		Sql.Append('Select * from Funcionarios');
		Sql.Append('Where COD_FUN is null'); // Pode selecionar qualquer funcionário ;
      Open;
   End;
   //
	Try
		// MÉTODO "APPEND" ou "INSERT" : Coloca registro atual em INCLUSÃO
   	F_Dm_Pedidos.Qry_Funcionarios.Append ;
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
end;

procedure TF_Funcionarios.Bt_AlterarClick(Sender: TObject);
begin
	if F_Dm_Pedidos.Qry_Funcionarios.Active=False then
	Begin
		Application.MessageBox('Apenas INCLUA, pois não selecionou nenhum registro',
		'Filtre antes de Visualizar Funcionário', Mb_Ok + Mb_IconInformation);
		Exit;
	End;
	//
	if F_Dm_Pedidos.Qry_Funcionarios.RecordCount=0 then
	Begin
		Application.MessageBox('Apenas INCLUA, pois não tem nenhum registro sendo visualizado',
		'Nenhum registro sendo visualizado', Mb_Ok + Mb_IconInformation);
		Exit;
	End;
	//
	Try
		// MÉTODO "EDIT" : Coloca registro atual em ALTERAÇÃO
   	F_Dm_Pedidos.Qry_Funcionarios.Edit ;
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


procedure TF_Funcionarios.Bt_ConfirmarClick(Sender: TObject);
Var
Nome_Incluido_ou_Alterado : String;
Estava_Incluindo          : Boolean;
Cod_Fun_SeraIncluido      : Integer;
begin
	Cod_Fun_SeraIncluido := 0;
	// Grava na variável, se estava INCLUINDO ou não ;
	Estava_Incluindo := F_Dm_Pedidos.Qry_Funcionarios.State=DsInsert; // DsInsert => Unit DB
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
		SQL.APPEND('Select gen_id ( GEN_FUNCIONARIOS_ID ,0 )');
		SQL.APPEND('From rdb$database');
		Open;
		// Cód. que será incluído é o CÓD. do GENERATOR, + 1
		Cod_Fun_SeraIncluido :=  FieldByname('GEN_ID').AsInteger + 1;
		//
		Close; // Após obter o valor, pode fechar query ;		
	End;
	// Fim : Se for incluir, grava o cód. do funcionário que será incluído ;
	// .................................................................. //
	Try
		F_Dm_Pedidos.Qry_Funcionarios.ApplyUpdates ; // Confirma alteração / Exclusão / Inclusão
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
	// o cód.do funcionário (que foi, como disse, gerado pela trigger) ;
	If Estava_Incluindo=True then
	With F_Dm_Pedidos.Qry_Funcionarios do
	Begin
		Nome_Incluido_ou_Alterado := DbEd_Nome.Text ;
		Sql.Clear ;
		Sql.Append('Select * from Funcionarios');
		Sql.Append('Where COD_FUN='+ IntToStr(Cod_Fun_SeraIncluido));
		// SHOWMESSAGE(SQL.TEXT);
		Open;
	End;
	// Fim : Abrindo um SELECT para selecionar o PRÓPRIO REGISTRO que acabou de INCLUIR.	
	// .................................................................. //
	//
	Habilita_EDICAO( FALSE );
end;

procedure TF_Funcionarios.Bt_CancelarClick(Sender: TObject);
begin
	F_Dm_Pedidos.Qry_Funcionarios.CancelUpdates ;
	Habilita_EDICAO( FALSE );
end;

procedure TF_Funcionarios.Bt_ExcluirClick(Sender: TObject);
begin
	if F_Dm_Pedidos.Qry_Funcionarios.Active=False then
	Begin
		Application.MessageBox('Apenas INCLUA, pois não selecionou nenhum registro',
		'Filtre antes de Visualizar Funcionário', Mb_Ok + Mb_IconInformation);
		Exit;
	End;
	//
	if F_Dm_Pedidos.Qry_Funcionarios.RecordCount=0 then
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
   	F_Dm_Pedidos.Qry_Funcionarios.Delete ;       // Executa método de Exclusão do registro atual ;
		F_Dm_Pedidos.Qry_Funcionarios.ApplyUpdates ; // Confirma alteração / Exclusão / Inclusão
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
	if F_Dm_Pedidos.Qry_Funcionarios.RecordCount=0 then
	Begin
		F_Dm_Pedidos.Qry_Funcionarios.Close;
		F_Funcionarios.Close;
	end;
end;

procedure TF_Funcionarios.Bt_RetornarClick(Sender: TObject);
begin
	F_Funcionarios.Close  ; // Poderia ser somente CLOSE,
   // que já estaria subentendido o form
end;

procedure TF_Funcionarios.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

	If Pn_Manutencao.Visible=True then // Se NÃO ESTIVER alterando ou incluindo
	If F_Dm_Pedidos.Qry_Funcionarios.Active=True then  // Se query aberta
	With F_Dm_Pedidos.Qry_Funcionarios do
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
		Vk_Return :
		Begin
			Key:=0;
			Bt_Alterar.Click	;
		End;

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

procedure TF_Funcionarios.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
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

procedure TF_Funcionarios.FormKeyPress(Sender: TObject; var Key: Char);
begin
	// Quando o FOCO estiver no PRIMEIRO CAMPO, não pode executar a função abaixo,
	// pois ao teclar ENTER para alterar, automaticamente passaria para o segundo campo.
	// Então "anulo" a função e executo no próprio evento ONKEYPRESS do NOME 
	//
	// Se estiver ALTERANDO ou INCLUINDO, troca ENTER por TAB
	If Pn_Confirma_Cancela.Visible then
	If (DbEd_CPF.focused=False) and (DbEd_Nome.focused=False) then //Se o foco não estiver no CPF
	//EnterToTab_FKeyPress(Key); 
end;

procedure TF_Funcionarios.DbEd_NomeKeyPress(Sender: TObject;
  var Key: Char);
begin
	If Key=#13 then DbEd_Fone.Setfocus;
end;

end.
