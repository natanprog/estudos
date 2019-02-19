unit Clientes;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType{, LMessages, Messages}, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, DBCtrls, StdCtrls, MaskEdit{, Grids}, DBGrids, ComCtrls;

type
  TF_Clientes = class(TForm)
    Panel3: TPanel;
    Pn_Confirma_Cancela: TPanel;
    Bt_Confirmar: TSpeedButton;
    Bt_Cancelar: TSpeedButton;
    Pn_Manutencao: TPanel;
    Bt_Incluir: TSpeedButton;
    Bt_Alterar: TSpeedButton;
    Bt_Excluir: TSpeedButton;
    Pn_Edicao: TPanel;
    Label1: TLabel;
	 Label3: TLabel;
    DbEd_Nome: TDBEdit;
    Label4: TLabel;
	 DbEd_Endereco: TDBEdit;
	 Label5: TLabel;
    DbEd_Bairro: TDBEdit;
    Label6: TLabel;
    DbEd_Cep: TDBEdit;
    COD_CLI: TDBText;
    LOJA_CLI: TDBText;
    Label7: TLabel;
    Label8: TLabel;
    Bt_Retornar: TSpeedButton;
    Ed_Nome: TEdit;
    Ed_Endereco: TEdit;
    Ed_Bairro: TEdit;
    Ed_Cep: TMaskEdit;
    Label2: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    RichEdit1: TMemo;
    Panel2: TPanel;
    RichEdit2: TMemo;
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
	 procedure Ed_NomeKeyPress(Sender: TObject; var Key: Char);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Clientes: TF_Clientes;

Incluindo_Alterando : String[1];

// Marca o CLIENTE a ser ALTERADO, para poder alterar DESCONECTADO do B.D.,
// isto mesmo .... como na WEB, <<< DESCONECTADO >>> !!!
NOM_CLI_INCLUIDO, END_CLI_INCLUIDO, Cod_Cli_Alterado , LOJA_Cli_Alterado : String ;



implementation

uses {Funcoes,} Dm_Pedidos;

{$R *.lfm}

Procedure Habilita_EDICAO(Editar:Boolean);
Begin
	With F_Clientes do  // Ajusta os objetos da tela, conforme o valor enviado para "EDITAR"
	Begin
		// AO EDITAR(incluir/Alterar) :Deixa VISÍVEL botões de CONFIRMAR/CANCELAR ;
	   Pn_Confirma_Cancela.Visible := Editar;
      Pn_Edicao.Enabled := Editar; // Ao editar, habilita Painel com caixas de Edição
		Pn_Manutencao.Visible := NOT(Editar); // AO EDITAR(incluir/Alterar) :Deixa INVISÍVEL botões de INCLUIR+ALTERAR+EXCLUIR+RETORNAR ;
		//
      // AO EDITAR(incluir/Alterar) : Deixando VISÍVEIS caixas para EDITAR ;
		Ed_Nome.Visible     := Editar; Ed_Endereco.Visible := Editar;
		Ed_Bairro.Visible   := Editar; Ed_Cep.Visible 		:= Editar;
		//
		// ************************************************************************************* //
		// SE ALTERANDO OU INCLUINDO (EDITANDO) ;
		If Editar=True then
		Begin
			// Se tiver INCLUINDO, então LIMPA CAIXAS DE EDIÇÃO :		
			If Incluindo_Alterando='I' then
			Begin
				Ed_Nome.Clear  ; Ed_Endereco.Clear; Ed_Bairro.Clear; Ed_Cep.Clear 		;
			End;
			//
			// Se tiver ALTERANDO, então PEGA OS VALORES DO CLIENTE SELECIONADO :
			If Incluindo_Alterando='A' then
			Begin
				Ed_Nome.Text     := F_Dm_Pedidos.Qry_Clientes.fieldbyName('NOME').AsString ;
				Ed_Endereco.Text := F_Dm_Pedidos.Qry_Clientes.fieldbyName('ENDERECO').AsString ;
				Ed_Bairro.Text   := F_Dm_Pedidos.Qry_Clientes.fieldbyName('BAIRRO').AsString ;
				Ed_Cep.Text      := F_Dm_Pedidos.Qry_Clientes.fieldbyName('CEP').AsString ;
			End;
		End; // If Editar=True then .... // SE ALTERANDO OU INCLUINDO (EDITANDO) ;
		// ************************************************************************************* //
		//
		// Deixando VISÍVEIS/INVISÍVEIS caixas de VISUALIZAÇÃO DOS DADOS DOS CAMPOS ;
		DbEd_Nome.Visible     := Not(Editar); DbEd_Endereco.Visible:= Not(Editar);
		DbEd_Bairro.Visible   := Not(Editar); DbEd_Cep.Visible 	 := Not(Editar);
		//
		// Se Entrar em ALTERAÇÃO ou INCLUSÃO, AJUSTA FOCO
		If Editar=True then Ed_Nome.Setfocus;
	End;
End;



procedure TF_Clientes.Bt_IncluirClick(Sender: TObject);
begin
	// Marca o CLIENTE , para poder incluir DESCONECTADO do B.D.,
	// isto mesmo .... como na WEB, <<< DESCONECTADO >>> !!!
	Cod_Cli_Alterado  :=  F_Dm_Pedidos.Qry_Clientes.FieldByName( 'Cod_Cli' ).AsString ;
	LOJA_Cli_Alterado :=  F_Dm_Pedidos.Qry_Clientes.FieldByName( 'Loja_Cli' ).AsString;

	// Ajustando VARIÁVEL para saber que está INCLUINDO ;
	Incluindo_Alterando := 'I';
	//
	// Ajustando TODOS OBJETOS para INCLUSÃO :
	Habilita_EDICAO( TRUE );

	// Entra em INCLUSÃO, Sem CONEXÃO ;
	F_Dm_Pedidos.Zconnection.Connected := False;
end;

procedure TF_Clientes.Bt_AlterarClick(Sender: TObject);
begin
	// Marca o CLIENTE a ser ALTERADO, para poder alterar DESCONECTADO do B.D.,
	// isto mesmo .... como na WEB, <<< DESCONECTADO >>> !!!
	Cod_Cli_Alterado  :=  F_Dm_Pedidos.Qry_Clientes.FieldByName( 'Cod_Cli' ).AsString ;
	LOJA_Cli_Alterado :=  F_Dm_Pedidos.Qry_Clientes.FieldByName( 'Loja_Cli' ).AsString;

	// Se a query de clientes estiver DESATIVADA (fechada), filtre para poder alterar algo ;
	if F_Dm_Pedidos.Qry_Clientes.Active=False then
	Begin
		Application.MessageBox('Apenas INCLUA, pois não selecionou nenhum registro',
		'Filtre antes de Visualizar Cliente', Mb_Ok + Mb_IconInformation);
		Exit;
	End;

	// Ajustando VARIÁVEL para saber que está ALTERANDO ;
	Incluindo_Alterando := 'A';
	//
	// Ajustando TODOS OBJETOS para ALTERAÇÃO :
	Habilita_EDICAO( TRUE );

	// Até funciona, mas tenho que gravar o cód. cliente numa var	
	F_Dm_Pedidos.Zconnection.Connected := False;
end;

// Conseguiu Incluir, retorna TRUE,  SENÃO retorna FALSE;
Function Confirma_Inclusao:Boolean;
Begin
	Result := True;
	//
	With F_Clientes do
	With F_Dm_Pedidos.ZQRY_Livre.SQL do
	Begin
		Clear; 		// Código de INSERÇÃO na table de CLIENTES ;
		Append('Insert into CLIENTE');
		Append('( COD_CLI, LOJA_CLI , NOME, ENDERECO, BAIRRO, CEP)' );
		Append('Values' );
		Append( '( null ,');    // COD_CLI  : Automático, implementado com TRIGGER + GENERATOR ;
		Append(' 1 , ');        // LOJA_CLI : Considera que está "incluindo" na LOJA "1" ;
		Append( QuotedStr(Ed_Nome.Text)  +',' ); // QUOTEDSTR(X) => "Envolve" a variável "X", com aspas
		Append( QuotedStr(Ed_Endereco.Text) +',' ); Append( QuotedStr(Ed_Bairro.Text)   +',' );
		Append( QuotedStr(Ed_Cep.Text)  + ')'    );
		// TENTA INCLUIR o registro DIGITADO ;
		Try
			Showmessage('Veja a query : '+ #13 + #13+  '"'+F_Dm_Pedidos.ZQRY_Livre.SQL.Text+'"');
			F_Dm_Pedidos.ZQRY_Livre.ExecSQL; // Trava o registro . (destrava no COMMIT)
		Except On E:Exception do
			Begin
				Application.MessageBox( Pchar(
				'ERRO  : "'+ E.Message +'" ;' ),
				'Impossível INCLUIR', MB_Ok);
				Result := False;	EXIT;
			End;
		End;
		F_Dm_Pedidos.ZConnection.Commit; // GRAVA FISICAMENTE, finaliza transação, e destrava o registro
	End;
End; // Function Confirma_Inclusao:Boolean;

// Conseguiu EXCLUIR, retorna TRUE,  SENÃO retorna FALSE;
Function Confirma_Exclusao:Boolean;
Begin
	Result := True;
	With F_Clientes do
	With F_Dm_Pedidos.ZQRY_Livre.SQL do
	Begin
		Clear;
		// Código de EXCLUSÃO na table de CLIENTES ;
		Append('Delete From CLIENTE Where');
		Append('COD_CLI='+F_Dm_Pedidos.Qry_Clientes.FieldByName('COD_CLI').asString );
		Append(' and ' );
		Append('LOJA_CLI='+F_Dm_Pedidos.Qry_Clientes.FieldByName('LOJA_CLI').asString );            
      Try 		// Tenta EXCLUIR o registro ;
         Showmessage('Veja a query : '+#13+#13+	'"'+F_Dm_Pedidos.ZQRY_Livre.SQL.Text+'"');
         F_Dm_Pedidos.ZQRY_Livre.ExecSQL; // Trava o registro . (destrava no COMMIT)
		Except On E:Exception do
			Begin
				Application.MessageBox( Pchar(
				'ERRO  : "'+ E.Message +'" ;' ),
				'Impossível EXCLUIR', MB_Ok);
				Result := False;	EXIT;
			End;
		End;
      F_Dm_Pedidos.ZConnection.Commit;
	End;
End; // Function Confirma_Exclusao:Boolean;



Function Confirma_Alteracao:Boolean ;
Begin
	Result := True;
	With F_Clientes do
	With F_Dm_Pedidos.ZQRY_Livre.SQL do
	Begin
		Clear;
		Append('Update CLIENTE');  // Código de ALTERAÇÃO na table de CLIENTES ;
		Append('Set');
		Append('NOME = ' + QuotedStr(Ed_NOME.Text) + ' , ');
		Append('ENDERECO = ' + QuotedStr(Ed_ENDERECO.Text) + ' , ');
		Append('BAIRRO = ' + QuotedStr(Ed_BAIRRO.Text)  + ' , ' );
		Append('CEP = ' + QuotedStr(Ed_CEP.Text)  );
		Append('Where COD_CLI=' + Cod_Cli_Alterado  );// Qry_Clientes.FieldByName('COD_CLI').asString );
		Append('  and LOJA_CLI='+ LOJA_Cli_Alterado );// Qry_Clientes.FieldByName('LOJA_CLI').asString );
		//
      Try // Tenta ALTERAR o registro ;
			Showmessage('ALTERAÇÃO : Veja a query : '+#13+#13+'"'+F_Dm_Pedidos.ZQRY_Livre.SQL.Text+'"');
			//
			F_Dm_Pedidos.ZQRY_Livre.ExecSQL; // Trava o registro . (destrava no COMMIT)
		Except On E:Exception do
			Begin
				Application.MessageBox( Pchar(
				'ERRO  : "'+ E.Message +'" ;' ),
				'Impossível ALTERAR', MB_Ok);     	Result := False;	EXIT;
			End;
		End;
		F_Dm_Pedidos.ZConnection.Commit; // GRAVA FISICAMENTE, finaliza transação, e destrava o registro
		//
		// F_Dm_Pedidos.Qry_Clientes.Refresh; => só teria sentido, se a QUERY tivesse aberta ;
	End;
End; // Function Confirma_Alteracao:Boolean ;


Procedure REABRE_POSICIONA_QRY_CLIENTES ;
Begin
	// ***** REABRINDO A QUERY no registro INCLUÍDO ou ALTERADO : *******

	// Se foi "aceita a ALTERAÇÃO", filtra pelo registro que acabou de ALTERAR :
	If Incluindo_Alterando='A' then
	With F_Dm_Pedidos.Qry_Clientes do
	Begin
		Sql.Clear ;
		Sql.Append('Select * from Cliente');
		Sql.Append('Where COD_CLI=' + Cod_Cli_Alterado  );// Qry_Clientes.FieldByName('COD_CLI').asString );
		Sql.Append('  and LOJA_CLI='+ LOJA_Cli_Alterado );// Qry_Clientes.FieldByName('LOJA_CLI').asString );
		//
		SHOWMESSAGE('REABRINDO A QUERY com TODOS CAMPOS, CLIENTE ANTES DE ALTERAR : '+#13+#13+
		SQL.TEXT);
		Open;
	End;

	// Se foi "aceita a INCLUSÃO", filtra pelo registro que acabou de incluir :
	// * O filtro é feito por uma variável LOCAL que contém o NOME DO CLIENTE INCLUÍDO ;
	If Incluindo_Alterando='I' then
	With F_Dm_Pedidos.Qry_Clientes do
	Begin
		Sql.Clear ;
		Sql.Append('Select * from Cliente');
		Sql.Append('Where NOME=' + QuotedStr( NOM_CLI_INCLUIDO )  );   // QuotedStr = Entre aspas simples ;
		Sql.Append('  and ENDERECO='+ QuotedStr( END_CLI_INCLUIDO ) ); // QuotedStr = Entre aspas simples ;
		//
		SHOWMESSAGE('REABRINDO A QUERY com TODOS CAMPOS, CLIENTE QUE INCLUIU : '+#13+#13+
		SQL.TEXT);
		Open;
	End;
End;






procedure TF_Clientes.Bt_ConfirmarClick(Sender: TObject);
begin
	// Marcando o que foi INCLUÍDO para poder reabrir na posição correta ;
	If Incluindo_Alterando='I' then
	Begin
		NOM_CLI_INCLUIDO :=  Ed_Nome.Text;
		END_CLI_INCLUIDO :=  Ed_Endereco.Text;
	End;

	// ************************************************************************ //
	// **************** CONFIRMANDO ALTERAÇÃO DE REGISTRO ********************* //
	// ************************************************************************ //

	// ---------------------------------------------------------------- //
	// Se entrou em ALTERAÇÃO, confirma ALTERAÇÃO ;
	if Incluindo_Alterando='A' then  // * Variável local que verifica se estava alterando ou incluindo
	If Confirma_Alteracao=False then // * Function que dá um UPDATE na QUERY de CLIENTES ;
	Begin
		Ed_NOME.Setfocus; Exit;
	End ;

	//
	// ************************************************************************ //
	// **************** CONFIRMANDO INCLUSÃO DE REGISTRO ********************** //
	// ************************************************************************ //
	// Se entrou em INCLUSÃO, confirma INCLUSÃO ;
	if Incluindo_Alterando='I' then   // * Variável local que verifica se estava alterando ou incluindo
	If Confirma_Inclusao=False then   // * Function que dá um INSERT na QUERY de CLIENTES ;
	Begin
		Ed_NOME.Setfocus; Exit;
	End;
	//
	Habilita_EDICAO( FALSE );

	// Reabre QUERY na table de clientes, no cliente que INCLUIU ou ALTEROU
	REABRE_POSICIONA_QRY_CLIENTES;
end;


procedure TF_Clientes.Bt_CancelarClick(Sender: TObject);
begin
	// Marcando o que foi INCLUÍDO para poder reabrir na posição correta ;
	If Incluindo_Alterando='I' then
	Begin
		NOM_CLI_INCLUIDO :=  Ed_Nome.Text;
		END_CLI_INCLUIDO :=  Ed_Endereco.Text;
	End;

	// Ajusta OBJETOS da tela ;
	Habilita_EDICAO( FALSE );

	// Reabre QUERY na table de clientes, no cliente que INCLUIU ou ALTEROU
	REABRE_POSICIONA_QRY_CLIENTES;
end;

procedure TF_Clientes.Bt_ExcluirClick(Sender: TObject);
begin
	// Se a query de clientes estiver DESATIVADA (fechada), filtre para poder excluir registro ;
	if F_Dm_Pedidos.Qry_Clientes.Active=False then
	Begin
		Application.MessageBox('Apenas INCLUA, pois não selecionou nenhum registro',
		'Filtre antes de Visualizar Cliente', Mb_Ok + Mb_IconInformation);
		Exit;
	End;

   // Confirme SEMPRE antes de excluir um registro ;
	if Application.MessageBox( 'Deseja excluir o registro', 'Responda com Atenção',
	Mb_YesNo + Mb_IconQuestion)=mrNo then Exit;
	//
	If Confirma_Exclusao=True then Close;

	// Se table aberto, ao retornar, dar um refresh;
	If F_Dm_Pedidos.QRY_Clientes.Active=True then
	Begin
		F_Dm_Pedidos.QRY_Clientes.Refresh;
		If F_Dm_Pedidos.QRY_Clientes.RecordCount=0 then
		Begin
			F_Dm_Pedidos.QRY_Clientes.Close;
			F_Clientes.Close;
		End;
	end;
end;

procedure TF_Clientes.Bt_RetornarClick(Sender: TObject);
begin
	F_Clientes.Close  ; // Poderia ser somente CLOSE,
   // que já estaria subentendido o form
end;

procedure TF_Clientes.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	If Pn_Manutencao.Visible=True then // Se NÃO ESTIVER alterando ou incluindo
	If F_Dm_Pedidos.Qry_Clientes.Active=True then  // Se query aberta
	With F_Dm_Pedidos.Qry_Clientes do
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

procedure TF_Clientes.FormCloseQuery(Sender: TObject;
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

procedure TF_Clientes.FormKeyPress(Sender: TObject; var Key: Char);
begin
	// Quando o FOCO estiver no PRIMEIRO CAMPO, não pode executar a função abaixo,
	// pois ao teclar ENTER para alterar, automaticamente passaria para o segundo campo.
	// Então "anulo" a função e executo no próprio evento ONKEYPRESS do NOME 
	//
	// Se estiver ALTERANDO ou INCLUINDO, troca ENTER por TAB
	If Pn_Confirma_Cancela.Visible then
	If (Ed_Cep.focused=False) and (Ed_Nome.focused=False) then	//Se o foco não estiver no CEP
	//EnterToTab_FKeyPress(Key);
end;

procedure TF_Clientes.Ed_NomeKeyPress(Sender: TObject; var Key: Char);
begin
	If Key=#13 then Ed_Endereco.Setfocus;
end;



end.
 
