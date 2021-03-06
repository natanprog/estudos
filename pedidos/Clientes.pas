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
		// AO EDITAR(incluir/Alterar) :Deixa VIS??VEL bot??es de CONFIRMAR/CANCELAR ;
	   Pn_Confirma_Cancela.Visible := Editar;
      Pn_Edicao.Enabled := Editar; // Ao editar, habilita Painel com caixas de Edi????o
		Pn_Manutencao.Visible := NOT(Editar); // AO EDITAR(incluir/Alterar) :Deixa INVIS??VEL bot??es de INCLUIR+ALTERAR+EXCLUIR+RETORNAR ;
		//
      // AO EDITAR(incluir/Alterar) : Deixando VIS??VEIS caixas para EDITAR ;
		Ed_Nome.Visible     := Editar; Ed_Endereco.Visible := Editar;
		Ed_Bairro.Visible   := Editar; Ed_Cep.Visible 		:= Editar;
		//
		// ************************************************************************************* //
		// SE ALTERANDO OU INCLUINDO (EDITANDO) ;
		If Editar=True then
		Begin
			// Se tiver INCLUINDO, ent??o LIMPA CAIXAS DE EDI????O :		
			If Incluindo_Alterando='I' then
			Begin
				Ed_Nome.Clear  ; Ed_Endereco.Clear; Ed_Bairro.Clear; Ed_Cep.Clear 		;
			End;
			//
			// Se tiver ALTERANDO, ent??o PEGA OS VALORES DO CLIENTE SELECIONADO :
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
		// Deixando VIS??VEIS/INVIS??VEIS caixas de VISUALIZA????O DOS DADOS DOS CAMPOS ;
		DbEd_Nome.Visible     := Not(Editar); DbEd_Endereco.Visible:= Not(Editar);
		DbEd_Bairro.Visible   := Not(Editar); DbEd_Cep.Visible 	 := Not(Editar);
		//
		// Se Entrar em ALTERA????O ou INCLUS??O, AJUSTA FOCO
		If Editar=True then Ed_Nome.Setfocus;
	End;
End;



procedure TF_Clientes.Bt_IncluirClick(Sender: TObject);
begin
	// Marca o CLIENTE , para poder incluir DESCONECTADO do B.D.,
	// isto mesmo .... como na WEB, <<< DESCONECTADO >>> !!!
	Cod_Cli_Alterado  :=  F_Dm_Pedidos.Qry_Clientes.FieldByName( 'Cod_Cli' ).AsString ;
	LOJA_Cli_Alterado :=  F_Dm_Pedidos.Qry_Clientes.FieldByName( 'Loja_Cli' ).AsString;

	// Ajustando VARI??VEL para saber que est?? INCLUINDO ;
	Incluindo_Alterando := 'I';
	//
	// Ajustando TODOS OBJETOS para INCLUS??O :
	Habilita_EDICAO( TRUE );

	// Entra em INCLUS??O, Sem CONEX??O ;
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
		Application.MessageBox('Apenas INCLUA, pois n??o selecionou nenhum registro',
		'Filtre antes de Visualizar Cliente', Mb_Ok + Mb_IconInformation);
		Exit;
	End;

	// Ajustando VARI??VEL para saber que est?? ALTERANDO ;
	Incluindo_Alterando := 'A';
	//
	// Ajustando TODOS OBJETOS para ALTERA????O :
	Habilita_EDICAO( TRUE );

	// At?? funciona, mas tenho que gravar o c??d. cliente numa var	
	F_Dm_Pedidos.Zconnection.Connected := False;
end;

// Conseguiu Incluir, retorna TRUE,  SEN??O retorna FALSE;
Function Confirma_Inclusao:Boolean;
Begin
	Result := True;
	//
	With F_Clientes do
	With F_Dm_Pedidos.ZQRY_Livre.SQL do
	Begin
		Clear; 		// C??digo de INSER????O na table de CLIENTES ;
		Append('Insert into CLIENTE');
		Append('( COD_CLI, LOJA_CLI , NOME, ENDERECO, BAIRRO, CEP)' );
		Append('Values' );
		Append( '( null ,');    // COD_CLI  : Autom??tico, implementado com TRIGGER + GENERATOR ;
		Append(' 1 , ');        // LOJA_CLI : Considera que est?? "incluindo" na LOJA "1" ;
		Append( QuotedStr(Ed_Nome.Text)  +',' ); // QUOTEDSTR(X) => "Envolve" a vari??vel "X", com aspas
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
				'Imposs??vel INCLUIR', MB_Ok);
				Result := False;	EXIT;
			End;
		End;
		F_Dm_Pedidos.ZConnection.Commit; // GRAVA FISICAMENTE, finaliza transa????o, e destrava o registro
	End;
End; // Function Confirma_Inclusao:Boolean;

// Conseguiu EXCLUIR, retorna TRUE,  SEN??O retorna FALSE;
Function Confirma_Exclusao:Boolean;
Begin
	Result := True;
	With F_Clientes do
	With F_Dm_Pedidos.ZQRY_Livre.SQL do
	Begin
		Clear;
		// C??digo de EXCLUS??O na table de CLIENTES ;
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
				'Imposs??vel EXCLUIR', MB_Ok);
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
		Append('Update CLIENTE');  // C??digo de ALTERA????O na table de CLIENTES ;
		Append('Set');
		Append('NOME = ' + QuotedStr(Ed_NOME.Text) + ' , ');
		Append('ENDERECO = ' + QuotedStr(Ed_ENDERECO.Text) + ' , ');
		Append('BAIRRO = ' + QuotedStr(Ed_BAIRRO.Text)  + ' , ' );
		Append('CEP = ' + QuotedStr(Ed_CEP.Text)  );
		Append('Where COD_CLI=' + Cod_Cli_Alterado  );// Qry_Clientes.FieldByName('COD_CLI').asString );
		Append('  and LOJA_CLI='+ LOJA_Cli_Alterado );// Qry_Clientes.FieldByName('LOJA_CLI').asString );
		//
      Try // Tenta ALTERAR o registro ;
			Showmessage('ALTERA????O : Veja a query : '+#13+#13+'"'+F_Dm_Pedidos.ZQRY_Livre.SQL.Text+'"');
			//
			F_Dm_Pedidos.ZQRY_Livre.ExecSQL; // Trava o registro . (destrava no COMMIT)
		Except On E:Exception do
			Begin
				Application.MessageBox( Pchar(
				'ERRO  : "'+ E.Message +'" ;' ),
				'Imposs??vel ALTERAR', MB_Ok);     	Result := False;	EXIT;
			End;
		End;
		F_Dm_Pedidos.ZConnection.Commit; // GRAVA FISICAMENTE, finaliza transa????o, e destrava o registro
		//
		// F_Dm_Pedidos.Qry_Clientes.Refresh; => s?? teria sentido, se a QUERY tivesse aberta ;
	End;
End; // Function Confirma_Alteracao:Boolean ;


Procedure REABRE_POSICIONA_QRY_CLIENTES ;
Begin
	// ***** REABRINDO A QUERY no registro INCLU??DO ou ALTERADO : *******

	// Se foi "aceita a ALTERA????O", filtra pelo registro que acabou de ALTERAR :
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

	// Se foi "aceita a INCLUS??O", filtra pelo registro que acabou de incluir :
	// * O filtro ?? feito por uma vari??vel LOCAL que cont??m o NOME DO CLIENTE INCLU??DO ;
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
	// Marcando o que foi INCLU??DO para poder reabrir na posi????o correta ;
	If Incluindo_Alterando='I' then
	Begin
		NOM_CLI_INCLUIDO :=  Ed_Nome.Text;
		END_CLI_INCLUIDO :=  Ed_Endereco.Text;
	End;

	// ************************************************************************ //
	// **************** CONFIRMANDO ALTERA????O DE REGISTRO ********************* //
	// ************************************************************************ //

	// ---------------------------------------------------------------- //
	// Se entrou em ALTERA????O, confirma ALTERA????O ;
	if Incluindo_Alterando='A' then  // * Vari??vel local que verifica se estava alterando ou incluindo
	If Confirma_Alteracao=False then // * Function que d?? um UPDATE na QUERY de CLIENTES ;
	Begin
		Ed_NOME.Setfocus; Exit;
	End ;

	//
	// ************************************************************************ //
	// **************** CONFIRMANDO INCLUS??O DE REGISTRO ********************** //
	// ************************************************************************ //
	// Se entrou em INCLUS??O, confirma INCLUS??O ;
	if Incluindo_Alterando='I' then   // * Vari??vel local que verifica se estava alterando ou incluindo
	If Confirma_Inclusao=False then   // * Function que d?? um INSERT na QUERY de CLIENTES ;
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
	// Marcando o que foi INCLU??DO para poder reabrir na posi????o correta ;
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
		Application.MessageBox('Apenas INCLUA, pois n??o selecionou nenhum registro',
		'Filtre antes de Visualizar Cliente', Mb_Ok + Mb_IconInformation);
		Exit;
	End;

   // Confirme SEMPRE antes de excluir um registro ;
	if Application.MessageBox( 'Deseja excluir o registro', 'Responda com Aten????o',
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
   // que j?? estaria subentendido o form
end;

procedure TF_Clientes.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
	If Pn_Manutencao.Visible=True then // Se N??O ESTIVER alterando ou incluindo
	If F_Dm_Pedidos.Qry_Clientes.Active=True then  // Se query aberta
	With F_Dm_Pedidos.Qry_Clientes do
	Case Key of
		Vk_Right: MoveBy(+1); // [SetaDireita ]  = Pr??x.Registro    // Qry.MoveBy(+1);
		Vk_Left : MoveBy(-1); // [SetaEsquerda]  = Reg.Anterior     // Qry.MoveBy(-1);
		Vk_Up   : First     ; // [Seta p/ Cima]  = Primeiro Registro// Qry.First;
		Vk_Down : Last      ; // [Seta p/ Baixo] = Reg.Anterior     // Qry.Last;
	End;
	//
	// Se N??O ESTIVER alterando ou incluindo
	If Pn_Manutencao.Visible=True then
	Case Key of
		// Teclou DELETE, TENTA EXCLUIR ;
		Vk_Delete : Bt_Excluir.Click	;

		// Teclou INSERT, entra em INCLUS??O
		Vk_Insert :
      Begin
         Bt_Incluir.Click	; Exit;
		End;
		// Teclou ENTER, entra em ALTERA????O
		Vk_Return : Bt_Alterar.Click	;

		// Teclou ESC, fecha formul??rio
		Vk_Escape : Close	;
	End; 	// FIM : Se N??O ESTIVER alterando ou incluindo
	// ------------------------------------------------------------ //
	// Se ESTIVER alterando ou incluindo
	If Pn_Manutencao.Visible=False then
	Case Key of
		// Teclou INSERT, confirma INCLUS??O/ALTERA????O ;
		Vk_Insert : Bt_Confirmar.Click	;

		// Teclou ESC, confirma INCLUS??O/ALTERA????O ;
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
		'Confirme ou cancele antes de sair do formul??rio',
		'Editando registros - Imposs??vel sair', Mb_Ok + Mb_IconWarning);
		//
		// Par??metro que, se ajustado para FALSE, evita fechamento do formul??rio
		Canclose:=False;
	End;

end;

procedure TF_Clientes.FormKeyPress(Sender: TObject; var Key: Char);
begin
	// Quando o FOCO estiver no PRIMEIRO CAMPO, n??o pode executar a fun????o abaixo,
	// pois ao teclar ENTER para alterar, automaticamente passaria para o segundo campo.
	// Ent??o "anulo" a fun????o e executo no pr??prio evento ONKEYPRESS do NOME 
	//
	// Se estiver ALTERANDO ou INCLUINDO, troca ENTER por TAB
	If Pn_Confirma_Cancela.Visible then
	If (Ed_Cep.focused=False) and (Ed_Nome.focused=False) then	//Se o foco n??o estiver no CEP
	//EnterToTab_FKeyPress(Key);
end;

procedure TF_Clientes.Ed_NomeKeyPress(Sender: TObject; var Key: Char);
begin
	If Key=#13 then Ed_Endereco.Setfocus;
end;



end.
 
