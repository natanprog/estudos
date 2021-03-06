unit IncluiPedido;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType{, LMessages, Messages}, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, MaskEdit, DBCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TF_IncluiPedido = class(TForm)
    Grd_Itens: TDBGrid;
    Label1: TLabel;
    Bt_AdicionarItem: TSpeedButton;
    Bt_Finaliza: TSpeedButton;
    Db_Funcionario: TDBText;
    Bt_ExcluirItem: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    DbT_Cliente: TDBText;
    Panel1: TPanel;
	 RichEdit2: TMemo;
    DbEd_DATA_PEDIDO: TDBEdit;
    DbEd_VALOR_PAGO: TDBEdit;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
	 procedure Bt_AdicionarItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Bt_ExcluirItemClick(Sender: TObject);
    procedure Bt_FinalizaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DbEd_DATA_PEDIDOKeyPress(Sender: TObject; var Key: Char);
    procedure DbEd_VALOR_PAGOKeyPress(Sender: TObject; var Key: Char);
    procedure DbEd_DATA_PEDIDOKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
	 { Public declarations }
	 Entrar_Incluindo : Boolean;
  end;

var
  F_IncluiPedido: TF_IncluiPedido;

implementation

uses Dm_Pedidos, Psq_Pro, Clientes, Psq_Fun, Psq_Cli;

{$R *.lfm}

procedure TF_IncluiPedido.FormCreate(Sender: TObject);
begin
	Grd_Itens.Columns[0].Width := Round(Grd_Itens.Columns[0].Width * (Screen.Width/1920) );
	Grd_Itens.Columns[1].Width := Round(Grd_Itens.Columns[1].Width * (Screen.Width/1920) );
	Grd_Itens.Columns[2].Width := Round(Grd_Itens.Columns[2].Width * (Screen.Width/1920) );
	Grd_Itens.Columns[3].Width := Round(Grd_Itens.Columns[3].Width * (Screen.Width/1920) );

	ScaleBy(Screen.Width, 1920 );
end;

procedure TF_IncluiPedido.Bt_AdicionarItemClick(Sender: TObject);
Var
Valor_Vendido, Qtde_Vender : Double ;
ClickedOK: Boolean;
Qtde_String, Valor_String  : String ;
begin
	Valor_Vendido := 0; Qtde_Vender := 0;
	// a) Escolhe Produto a incluir no Pedido ;
	// b) Pergunta QTDE A a incluir no Pedido   ;
	// c) Pergunta o PRE??O DO ITEM no Pedido, mostrando seu "PRE??O PADR??O" ;
	// d) Grava dados do ITEM  ;
	// .......................................................................................... //
	// a) Escolhe Produto a incluir no Pedido ;
	While True do
	Begin
		// Se o formul??rio n??o foi enviado para mem??ria, envia-o ;
		If F_Psq_Pro=Nil then  Application.CreateForm(TF_Psq_Pro, F_Psq_Pro);
		F_Psq_Pro.ShowModal;  // Visualiza o form de Pesquisa de Produtos ;

		If (F_Dm_Pedidos.Qry_Produtos.Active=False) or // Se n??o executou filtro
		(F_Dm_Pedidos.Qry_Produtos.RecordCount=0) then // Se filtro n??o resultou em nenhum registro
		Begin
			If Application.MessageBox( Pchar(
			'Para selecionar um produto para vender :'+#13+#13+
			'a) Digite um filtro para o produto e tecle [+] ;'+#13+#13+
			'b) Escolha o produto e tecle [Enter]; '), 'Nenhum Produto filtrado', MB_OKCANCEL + Mb_IconInformation)=MrCancel then
			Exit  // Se desistiu de incluir produto, sai da procedure
			Else  // Se clicou em [Ok] tenta incluir produto novamente ;
			Continue;
		End;
		Break ; // Sai do la??o WHILE ... TRUE DO
	End;
	// Fim : a) Escolhe Produto a incluir no Pedido ;
	// .......................................................................................... //
	// b) Pergunta QTDE A a incluir no Pedido   ;
	While True do
	Begin
		ClickedOK := InputQuery( 'Quantidade Pedida', 'Digite a Quantidade do Item do Pedido', Qtde_String);
		if ClickedOK=False then Exit; // Se n??o clicou em OK, cancela inclus??o
		// .......................................................................................... //
		Try
			Qtde_Vender := StrToFloat(Qtde_String)
		Except
			Application.MessageBox( Pchar(
			'Digite um n??mero REAL para QTDE'), 'Qtde digitada ?? INV??LIDA', Mb_Ok + Mb_IconWarning);
			Continue
		End;
		// .......................................................................................... //		
		Break ; // Sai do la??o WHILE ... TRUE DO
	End;
	// Fim : b) Pergunta QTDE A a incluir no Pedido   ;

	// .......................................................................................... //
	// c) Pergunta QTDE A a incluir no Pedido e pre??o, mostrando seu "PRE??O PADR??O" ;
	While True do
	Begin
		//  Se pre??o de venda n??o foi digitado, ENT??O valor vendido inicia com ZERO ;	
		If F_Dm_Pedidos.Qry_Produtos.FieldByName('PRECO_VENDA').IsNull then
		Valor_String := '0'
		Else  // Sen??o inicia com PRE??O de venda gravado no produto
		Valor_String := FloatToStrF( F_Dm_Pedidos.Qry_Produtos.FieldByName('PRECO_VENDA').AsFloat, fffixed, 13,2 );
		//
		ClickedOK := InputQuery( 'Se necess??rio, corrija o valor', 'Corrija o valor de venda do Item', Valor_String);
		//
		if ClickedOK=False then Exit; // Se n??o clicou em OK, cancela inclus??o
		// .......................................................................................... //
		Try
			Valor_Vendido := StrToFloat(Valor_String)
		Except
			Application.MessageBox( Pchar(
			'Digite um n??mero REAL para QTDE'), 'Qtde digitada ?? INV??LIDA', Mb_Ok + Mb_IconWarning);
			Continue
		End;
		// .......................................................................................... //
		Break ; // Sai do la??o WHILE ... TRUE DO
	End;
	// Fim : c) Pergunta QTDE A a incluir no Pedido e pre??o, mostrando seu "PRE??O PADR??O" ;


	// Query de inser????o de ITEM :
	// insert into ITEN_PEDIDO
	// ( COD_ITEM, COD_PRO, COD_PED, NOM_PRODUTO, QTDE_ITEN, VALOR_ITEN)
	// values
	// (  :COD_ITEM , :COD_PRO , :COD_PED , :NOM_PRODUTO , :QTDE_ITEN , :VALOR_ITEN )
   //
	// d) Grava dados do ITEM ;
	With F_Dm_Pedidos.ZQRY_Livre do
	With F_Dm_Pedidos do
	Begin
		// Como a INSER????O ?? feita com SQL "INSERT INTO" ,
		// tem-se que ajustar o "separador de casas decimais" para PONTO,
		// pois tem valor N??MERO REAL gravado em QTDE e VALOR MOEDA ;
		//
		// Na QUERY, o separador de casas decimais tem que ser "." (ponto)
		DefaultFormatSettings.DecimalSeparator := '.';   // Separador de decimais (30,2)
		//
		SQL.Clear; 		// C??digo de INSER????O na table de CLIENTES ;
		SQL.Append('insert into ITEN_PEDIDO');
		SQL.Append('( COD_ITEM, COD_PRO, COD_PED, NOM_PRODUTO, QTDE_ITEN, VALOR_ITEN)' );
		SQL.Append('Values' );
		SQL.Append( '( null, ' ); // COD_ITEM: Autom??tico, implementado com TRIGGER + GENERATOR ;
		SQL.Append( Qry_Produtos.FieldByName('Cod_Prod').AsString +',' );    //  COD_PRO,
		SQL.Append( Qry_Pedidos_TodosCampos.FieldByName('Cod_Pedido').AsString  +',' );             // COD_PED,
		SQL.Append( QuotedStr( Qry_Produtos.FieldByName('Nom_Pro').AsString)  +',' );   // NOM_PRODUTO,
		SQL.Append( FloatToStrF( Qtde_Vender, ffFixed, 10,3 )  +',' );          			 // QTDE_ITEN,
		SQL.Append( FloatToStrF( Valor_Vendido, ffFixed, 10,3 )  +')' );           		 // VALOR_ITEN )
		//
		// Voltando ao padr??o do BRASIL 
		DefaultFormatSettings.DecimalSeparator := ',';   // Separador de decimais (30,2)
		//
		// TENTA INCLUIR o registro DIGITADO ;
		Showmessage('Veja a query : '+ #13 + #13+  '"'+F_Dm_Pedidos.Qry_Pedidos_TodosCampos.SQL.Text+'"');
		F_Dm_Pedidos.ZQRY_Livre.ExecSQL; // Trava o registro . (destrava no COMMIT)
		//
		F_Dm_Pedidos.ZConnection.Commit; // GRAVA FISICAMENTE, finaliza transa????o, e destrava o registro
		//
		// Abaixo, dando um REFRESH na QUERY, pois a inser????o  do ITEM VENDIDO,
		// foi feita atrav??s de outra query ;
		Qry_Iten_Pedido.Refresh;
	End;

{  * Abaixo, n??o apague . Deixe como explica????o.
	* ?? o uso do "outro m??todo" de INCLUS??O de INFORMA????ES na table de ITENS do PEDIDO ,
	utilizando o M??IODO ZQUERY.INSERT  ; ZQUERY.APPLYUPDATES ; ZCONNECTION.COMMIT ;
	//
	showmessagE('incluiu em um m??todo, incluir?? em outro agora');
   //
	// Abaixo, o "outro m??todo" de inser????o, UTILIZANDO o APPEND/INSERT ;
	With F_Dm_Pedidos.Qry_Iten_Pedido do
	With F_Dm_Pedidos do
	Begin
		Insert; 		// Coloca query em INSER????O
		//
		// Abaixo, enviando valores para os campos : Qry_Iten_Pedido.FieldByName ...
		FieldByName('COD_PRO').AsInteger    := Qry_Produtos.FieldByName('Cod_Prod').AsInteger;
		FieldByName('COD_PED').AsInteger 	:= Qry_Pedidos_TodosCampos.FieldByName('Cod_Pedido').AsInteger;
		FieldByName('NOM_PRODUTO').AsString := Qry_Produtos.FieldByName('Nom_Pro').AsString;
		FieldByName('QTDE_ITEN').AsFloat 	:= Qtde_Vender;
		FieldByName('VALOR_ITEN').AsFloat 	:= Valor_Vendido;
		//
		ApplyUpdates; // Confirma Grava????o dos dados do registro
		//
		ZConnection.Commit;           // Grava fisicamente os dados  do registro alterado ;
	end;  }

end;

procedure TF_IncluiPedido.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
	Entrar_Incluindo := False;
   //
	// Se "alterou" a data do pedido, ent??o GRAVA A ALTERA????O FISICAMENTE :
	F_Dm_Pedidos.Qry_Pedidos_TodosCampos.ApplyUpdates;
	F_Dm_Pedidos.Zconnection.Commit;
	//
	// Ajustando a M??SCARA para digita????o da data .
	// Aten????o : Este tipo de m??scara, no pr??prio objeto "field" do banco de dados,
	// s?? pode ser usado AO EDITAR UM CAMPO. Depois , retira-se a m??scara
	F_Dm_Pedidos.Qry_Pedidos_TodosCamposDATA_PEDIDO.EditMask := '';
	// No evento ONCLOSE retiro a m??scara ;
end;


Procedure Altera_Cliente;
Begin
	With F_Dm_Pedidos do
	Begin
		// Cliente     : Pede o cliente ;
		While True do
		Begin
			// Se o formul??rio n??o foi enviado para mem??ria, envia-o ;
			If F_Psq_Cli=Nil then  Application.CreateForm(TF_Psq_Cli, F_Psq_Cli);
			F_Psq_Cli.ShowModal;  // Visualiza o form de Pesquisa de Produtos ;
			//
			If (F_Dm_Pedidos.Qry_Clientes.Active=False) or // Se n??o executou filtro
			(F_Dm_Pedidos.Qry_Clientes.RecordCount=0) then // Se filtro n??o resultou em nenhum registro
			Begin
				If Application.MessageBox( Pchar(
				'Para Escolher um Cliente :'+#13+#13+
				'1* Digite um filtro para o Cliente e tecle [+] ;'+#13+#13+
				'2* Escolha o Cliente e tecle [Enter] ;'),
				'Nenhum Cliente filtrado', MB_OKCANCEL + Mb_IconInformation)=MrCancel then
				Exit  // Se desistiu de incluir produto, sai da procedure
				Else  // Se clicou em [Ok] tenta incluir produto novamente ;
				Continue;
			End;
			Break ; // Sai do la??o WHILE ... TRUE DO
		End;
		// ................................................................................................ //
		// Fim : b) Cliente     : Pede o cliente ;

		// Colocando TABLE em ALTERA????O  ;
		Qry_Pedidos_TodosCampos.Edit;
		//
		Qry_Pedidos_TodosCampos.FieldByName('COD_CLI').AsInteger:= Qry_Clientes.FieldByName('COD_CLI').AsInteger;
		Qry_Pedidos_TodosCampos.FieldByName('LOJA_CLI').AsString:= Qry_Clientes.FieldByName('LOJA_CLI').AsString;
		Qry_Pedidos_TodosCampos.FieldByName('COD_FUN').AsInteger:= Qry_Funcionarios.FieldByName('COD_FUN').AsInteger;
		//
		Qry_Pedidos_TodosCampos.ApplyUpdates;	// Confirmando grava????o dos dados da query ;
		Zconnection.Commit;      					// Gravando FISICAMENTE dados inseridos na query ;
      //
		Qry_Clientes.Close;  // Ap??s uso, fecha query de clientes ;
	End;

End; // Fim :   Procedure Altera_Cliente;


Procedure Altera_Funcionario ;
Begin
	With F_Dm_Pedidos do
	Begin
		// Funcion??rio : Pede o c??digo do funcion??rio ;
		While True do
		Begin
			// Se o formul??rio n??o foi enviado para mem??ria, envia-o ;
			If F_Psq_Fun=Nil then  Application.CreateForm(TF_Psq_Fun, F_Psq_Fun);
			F_Psq_Fun.ShowModal;  // Visualiza o form de Pesquisa de Produtos ;
			//
			If (F_Dm_Pedidos.Qry_Funcionarios.Active=False) or // Se n??o executou filtro
			(F_Dm_Pedidos.Qry_Funcionarios.RecordCount=0) then // Se filtro n??o resultou em nenhum registro
			Begin
				If Application.MessageBox( Pchar(
				'Para Escolher um funcion??rio :'+#13+#13+
				'* Digite um filtro para o Funcion??rio e tecle [+] ;'),
				'Nenhum Funcion??rio filtrado', MB_OKCANCEL + Mb_IconInformation)=MrCancel then
				Exit  // Se desistiu de incluir produto, sai da procedure
				Else  // Se clicou em [Ok] tenta incluir produto novamente ;
				Continue;
			End;
			Break ; // Sai do la??o WHILE ... TRUE DO
		End;
		// Fim : a) Funcion??rio : Pede o c??digo do funcion??rio ;
		//
		// Colocando TABLE em ALTERA????O  ;
		Qry_Pedidos_TodosCampos.Edit;
		//
		Qry_Pedidos_TodosCampos.FieldByName('COD_FUN').AsInteger:= Qry_Funcionarios.FieldByName('COD_FUN').AsInteger;
		//
		Qry_Pedidos_TodosCampos.ApplyUpdates;	// Confirmando grava????o dos dados da query ;
		Zconnection.Commit;      					// Gravando FISICAMENTE dados inseridos na query ;

		Qry_Funcionarios.Close;   // Ap??s o uso fecha query de funcion??rios ;
	End;
	
End; // Fim : Procedure Altera_Funcionario;

procedure TF_IncluiPedido.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	If (ssCtrl in Shift) then // Se estiver pressionando CTRL
	If Key=Vk_Delete then // Se estiver pressionando DELETE
	Bt_ExcluirItem.click;

	Case Key of
		Vk_Escape :  Bt_Finaliza.click;
		//
		Vk_F5 : Altera_Funcionario;		
		Vk_F8 : Altera_Cliente;
	End;
end;

procedure TF_IncluiPedido.Bt_ExcluirItemClick(Sender: TObject);
begin
	if F_Dm_Pedidos.Qry_Iten_Pedido.RecordCount=0 then
	Begin
		Application.MessageBox('Apenas INCLUA, pois existe nenhum Item',
		'Nenhum registro a Excluir', Mb_Ok + Mb_IconInformation);
		Exit;
	End;
	//
   // Confirmando EXCLUS??O de REGISTRO
	if Application.MessageBox( 'Deseja excluir o registro', 'Responda com Aten????o',
	Mb_YesNo + Mb_IconQuestion)=mrNo then Exit;
	//
	Try
		// M??TODO "DELETE"  : Coloca registro atual em EXCLUS??O
		F_Dm_Pedidos.Qry_Iten_Pedido.Delete ;       // Executa m??todo de Exclus??o do registro atual ;
		F_Dm_Pedidos.Qry_Iten_Pedido.ApplyUpdates ; // Confirma altera????o / Exclus??o / Inclus??o
	   F_Dm_Pedidos.ZConnection.Commit; // GRAVA FISICAMENTE, finaliza transa????o, e destrava o registro
   Except On E:Exception do
      Begin
         Application.MessageBox( Pchar(
         'ERRO  : "'+ E.Message +'" ;' ),
         'Imposs??vel EXCLUIR Registro', MB_Ok);
         EXIT;
      End;
	End;
end;

procedure TF_IncluiPedido.Bt_FinalizaClick(Sender: TObject);
begin
	Close;
end;

procedure TF_IncluiPedido.FormShow(Sender: TObject);
begin
	If Entrar_Incluindo=True then 	Bt_AdicionarItem.Click;

	// Ajustando a M??SCARA para digita????o da data .
	// Aten????o : Este tipo de m??scara, no pr??prio objeto "field" do banco de dados,
	// s?? pode ser usado AO EDITAR UM CAMPO. Depois , retira-se a m??scara
	F_Dm_Pedidos.Qry_Pedidos_TodosCamposDATA_PEDIDO.EditMask := '99/99/9999;1;_';
	// No evento ONCLOSE retiro a m??scara ;

	DbEd_DATA_PEDIDO.SetFocus;
end;

procedure TF_IncluiPedido.DbEd_DATA_PEDIDOKeyPress(Sender: TObject;
  var Key: Char);
begin
	If key=#13 then DbEd_VALOR_PAGO.SetFocus;
end;

procedure TF_IncluiPedido.DbEd_VALOR_PAGOKeyPress(Sender: TObject;
  var Key: Char);
begin
	If key=#13 then DbEd_DATA_PEDIDO.SetFocus;
end;

procedure TF_IncluiPedido.DbEd_DATA_PEDIDOKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
	// Se perdeu o foco da digita????o da data para filtro, retorna FILTRO ;
	If (not( DbEd_DATA_PEDIDO.Focused )) AND  (not( DbEd_VALOR_PAGO.Focused )) then
	DbEd_DATA_PEDIDO.Setfocus;
	//
	// 
	With F_Dm_Pedidos do
 	If F_Dm_Pedidos.QRY_Iten_Pedido.Active then
	With F_Dm_Pedidos.QRY_Iten_Pedido do
	Case key of
      Vk_Up    : MoveBy(-1);  // Seta para Cima
      Vk_Down  : MoveBy(+1);  // Seta para Baixo
      //
      Vk_Prior : MoveBy(-10); // Page UP
      Vk_Next  : MoveBy(+10); // Page DOWN
	End;
	//

end;

procedure TF_IncluiPedido.FormKeyPress(Sender: TObject; var Key: Char);
begin
	If key='+' then Bt_AdicionarItem.Click;
end;

procedure TF_IncluiPedido.FormActivate(Sender: TObject);
begin
	Top := 0; // Coloca formul??rio no TOPO do monitor. Se colocando no evento ONSHOW, n??o funciona ;
end;

end.
