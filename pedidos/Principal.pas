unit Principal;

{$MODE Delphi}

interface
                                                                                  
uses
  LCLIntf, LCLType{, LMessages, Messages}, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Buttons{, ToolWin}, ComCtrls, StdCtrls, ExtCtrls{, Grids},
  DBGrids, ImgList;

type
  TF_Principal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Clientes1: TMenuItem;
    Funcionrios1: TMenuItem;
    Pedidos1: TMenuItem;
    Produtos1: TMenuItem;
    Relatrios1: TMenuItem;
    Clientes2: TMenuItem;
    Pedidos2: TMenuItem;
    TodosSEMpreviewpersonalizado: TMenuItem;
    FiltradosporData1: TMenuItem;
	 Sobre1: TMenuItem;
	 EscSair1: TMenuItem;
    StatusBar: TStatusBar;
	 ToolBar1: TToolBar;
	 Bt_Calculadora: TSpeedButton;
	 Bt_Pedidos: TSpeedButton;
    Bt_Saida: TSpeedButton;
    Timer: TTimer;
    Panel2: TPanel;
    RichEdit2: TMemo;
	 Bt_ConsultarPedidos: TSpeedButton;
    Panel1: TPanel;
    Img_FIREBIRD: TImage;
    VisualizaoPersonalizada1: TMenuItem;
    N1: TMenuItem;
    VisualizaoPadro1: TMenuItem;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
	 procedure Clientes1Click(Sender: TObject);
	 procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
	 procedure EscSair1Click(Sender: TObject);
	 procedure Bt_CalculadoraClick(Sender: TObject);
	 procedure BtSaidaClick(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
	 procedure TimerTimer(Sender: TObject);

	// Este abaixo, foi inserido pelo PROGRAMADOR
	procedure ShowHint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Funcionrios1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Bt_SaidaClick(Sender: TObject);
    procedure Produtos1Click(Sender: TObject);
    procedure Bt_PedidosClick(Sender: TObject);
	 procedure Pedidos1Click(Sender: TObject);
	 procedure FormKeyDown(Sender: TObject; var Key: Word;
		Shift: TShiftState);
	 procedure Clientes2Click(Sender: TObject);
	// ................................................ //

    procedure TodosSEMpreviewpersonalizadoClick(Sender: TObject);
	 procedure FiltradosporData1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure VisualizaoPadro1Click(Sender: TObject);
	 procedure VisualizaoPersonalizada1Click(Sender: TObject);

Procedure MostrarPreview(Sender: TObject);

  private
{  F_Rel_Clientes_ComoEstava : TNotifyEvent;// USADO EM RELATÓRIOS com PREVIEW PERSONALIZADO  
  F_Rel_Ped_ComoEstava : TNotifyEvent; }

	 { Private declarations }
  public
	 { Public declarations }
  end;

var
  F_Principal: TF_Principal;

implementation

uses {rprntr, Funcoes,} Psq_Cli{Para chamar o form F_Psq_Cli}, Sobre, Dm_Pedidos,
  Psq_Fun, Psq_Pro, IncluiPedido, Psq_Pedidos  ;

{$R *.lfm}


// Este abaixo, foi inserido pelo PROGRAMADOR
procedure TF_Principal.ShowHint(Sender: TObject);
begin
	// barra de Status, parte do meio, mostra a DICA da aplicação ;
   StatusBar.Panels[1].Text := Application.Hint;
end;


procedure TF_Principal.Clientes1Click(Sender: TObject);
begin
	// Se o formulário não foi enviado para memória, envia-o ;
	If F_Psq_Cli=Nil then  Application.CreateForm(TF_Psq_Cli, F_Psq_Cli);
	F_Psq_Cli.ShowModal;  // Visualiza o form de Pesquisa de Clientes ;

	// Desconectando do BANCO :
	F_Dm_Pedidos.ZConnection.connected := False;

end;

procedure TF_Principal.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
	If Application.MessageBox(
	'Deseja sair da Aplicação', 'Responda com Atenção',
	Mb_YesNo + Mb_DefButton2 + Mb_IconQuestion )=MrNo then
	CanClose := False;
end;

procedure TF_Principal.EscSair1Click(Sender: TObject);
begin
	Close
end;

procedure TF_Principal.Bt_CalculadoraClick(Sender: TObject);
begin
  // Atenção : para utilizar esta função, que executa
  // programas externos,
  // é necessário inserir a UNIT "ShellApi"
   OpenDocument('calc.exe'); { *Converted from ShellExecute* }
end;

procedure TF_Principal.BtSaidaClick(Sender: TObject);
begin
	Close;
end;

procedure TF_Principal.Sobre1Click(Sender: TObject);
begin
	// Se o formulário não foi enviado para memória, envia-o ;
	If F_Sobre=Nil then  Application.CreateForm(TF_Sobre, F_Sobre);
	F_Sobre.ShowModal;  // Visualiza o formulário "sobre"
end;

procedure TF_Principal.TimerTimer(Sender: TObject);
begin
	StatusBar.Panels[0].Text := TimeToStr( Time );
   StatusBar.Panels[2].Text := DateToStr( Date );	
end;

procedure TF_Principal.FormCreate(Sender: TObject);
begin
   //
   // Redimensionando o formulário conforme a resolução do monitor ;
   // ou seja, ao utilizar um monitor de 800x600, a tela do programa aumenta.
   // => A base é sempre construir o programa em cima de 640x480.
   // => No form principal, tem-se que alterar a propriedade AUTOSCROOL, do form para FALSE,
   // sendo esta alteração desnecessária para demais forms. 
   F_Principal.ScaleBy( Screen.Width, 1920 );
   //
   // Ajustando largura dos botões, conforme a resolução do Monitor
	Bt_Pedidos.Width 				:= Round(Bt_Pedidos.Width * (Screen.Width / 1920 ));
	Bt_Calculadora.Width 		:= Round(Bt_Calculadora.Width * (Screen.Width / 1920 ));
	Bt_Saida.Width 				:= Round(Bt_Saida.Width * (Screen.Width / 1920 ));
	Bt_ConsultarPedidos.Width 	:= Round(Bt_ConsultarPedidos.Width * (Screen.Width / 1920 ));
	//
	StatusBar.Panels[0].Width 	:= Round(StatusBar.Panels[0].Width * (Screen.Width / 1920 ));
	StatusBar.Panels[1].Width 	:= Round(StatusBar.Panels[1].Width * (Screen.Width / 1920 ));
	StatusBar.Panels[2].Width 	:= Round(StatusBar.Panels[2].Width * (Screen.Width / 1920 ));
	//
	Application.OnHint := ShowHint;
  F_Dm_Pedidos.ZConnection.AutoEncodeStrings:=True;
end;

procedure TF_Principal.Funcionrios1Click(Sender: TObject);
begin
	// Se o formulário não foi enviado para memória, envia-o ;
	If F_Psq_Fun=Nil then  Application.CreateForm(TF_Psq_Fun, F_Psq_Fun);
	F_Psq_Fun.ShowModal;  // Visualiza o form de Pesquisa de Funcionários ;

	// Desconectando do BANCO :
	F_Dm_Pedidos.ZConnection.connected := False;
end;

procedure TF_Principal.FormActivate(Sender: TObject);
begin
	Top := 0; // Coloca formulário no TOPO do monitor. Se colocando no evento ONSHOW, não funciona ;
end;

procedure TF_Principal.Bt_SaidaClick(Sender: TObject);
begin
	Close
end;

procedure TF_Principal.Produtos1Click(Sender: TObject);
begin
	// Se o formulário não foi enviado para memória, envia-o ;
	If F_Psq_Pro=Nil then  Application.CreateForm(TF_Psq_Pro, F_Psq_Pro);
	F_Psq_Pro.ShowModal;  // Visualiza o form de Pesquisa de Produtos ;

	// Desconectando do BANCO :
	F_Dm_Pedidos.ZConnection.connected := False;
end;

procedure TF_Principal.Bt_PedidosClick(Sender: TObject);
Var
Cod_PED_SeraIncluido : Integer;
begin
	// ------------------------------------------------------------------------------ //
	// Abaixo : INICIA INCLUSÃO DOS DADOS BÁSICOS DO PEDIDO :
	// ------------------------------------------------------------------------------ //
	// Se variável pública Estiver como "Entrar_Incluindo", entra incluído novo pedido no formulário
	// a) Funcionário : Pede o código do funcionário ;
	// b) Cliente     : Pede o cliente ;
	// b.1) Busca no GENERATOR, CÓD. do próximo PEDIDO ;
	// b.2) Faz inserção dos dados do PEDIDO ;
	// b.2.1) ABRINDO QUERY com QUALQUER FILTRO, apenas para poder usar MÉTODO <<APPEND>> ;
	// b.3) ABRINDO QUERY com os DADOS DO PEDIDO ATUAL, através do GENERATOR recuperado ;
	// ................................................................................................ //
	// a) Funcionário : Pede o código do funcionário ;
	While True do
	Begin
		// Se o formulário não foi enviado para memória, envia-o ;
		If F_Psq_Fun=Nil then  Application.CreateForm(TF_Psq_Fun, F_Psq_Fun);
		F_Psq_Fun.ShowModal;  // Visualiza o form de Pesquisa de Produtos ;
      //
		If (F_Dm_Pedidos.Qry_Funcionarios.Active=False) or // Se não executou filtro
		(F_Dm_Pedidos.Qry_Funcionarios.RecordCount=0) then // Se filtro não resultou em nenhum registro
		Begin
			If Application.MessageBox( Pchar(
			'Para Escolher um funcionário :'+#13+#13+
			'* Digite um filtro para o Funcionário e tecle [+] ;'),
			'Nenhum Funcionário filtrado', MB_OKCANCEL + Mb_IconInformation)=MrCancel then
			Exit  // Se desistiu de incluir produto, sai da procedure
			Else  // Se clicou em [Ok] tenta incluir produto novamente ;
			Continue;
		End;
		Break ; // Sai do laço WHILE ... TRUE DO
	End;
	// Fim : a) Funcionário : Pede o código do funcionário ;


	// ................................................................................................ //
	// b) Cliente     : Pede o cliente ;
	While True do
	Begin
		// Se o formulário não foi enviado para memória, envia-o ;
		If F_Psq_Cli=Nil then  Application.CreateForm(TF_Psq_Cli, F_Psq_Cli);
		F_Psq_Cli.ShowModal;  // Visualiza o form de Pesquisa de Produtos ;
		//
		If (F_Dm_Pedidos.Qry_Clientes.Active=False) or // Se não executou filtro
		(F_Dm_Pedidos.Qry_Clientes.RecordCount=0) then // Se filtro não resultou em nenhum registro
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
		Break ; // Sai do laço WHILE ... TRUE DO
	End;
	// ................................................................................................ //
	// Fim : b) Cliente     : Pede o cliente ;


	// .................................................................. //
	// b.1) Busca no GENERATOR, CÓD. do próximo PEDIDO ;
	// Obtendo valor do generator da tabela , para FILTRAR ao final da inclusão ;
	// .................................................................. //	
	// O select abaixo, busca o valor atual do generator :
	// Select gen_id ( GEN_xxx_ID ,0 ) from rdb$database}
	// .................................................................. //
	With F_Dm_Pedidos.ZQRY_Livre do
	Begin
		SQL.CLEAR;
		SQL.APPEND('Select gen_id ( GEN_PEDIDOS_ID ,0 )');
		SQL.APPEND('From rdb$database');
		Open;
		// Cód. que será incluído é o CÓD. do GENERATOR, + 1
		Cod_PED_SeraIncluido :=  FieldByname('GEN_ID').AsInteger + 1;
		//
		Close; // Após obter o valor, pode fechar query ;
	End;
	// Fim : b.1) Busca no GENERATOR, CÓD. do próximo PEDIDO ;

	// ................................................................................................ //
	// insert into PEDIDOS
	// ( COD_PEDIDO , DATA_PEDIDO, VALOR_PAGO, COD_CLI, LOJA_CLI, COD_FUN )
	// values
	// (  :COD_PEDIDO, :DATA_PEDIDO, :VALOR_PAGO, :COD_CLI, :LOJA_CLI, :COD_FUN )
	// ................................................................................................ //
	// b.2) Faz inserção dos dados do PEDIDO ;
	With F_Dm_Pedidos do
	Begin
		// b.2.1) ABRINDO QUERY com QUALQUER FILTRO, apenas para poder usar MÉTODO <<APPEND>> ;
		Qry_Pedidos_TodosCampos.SQL.Clear;
		Qry_Pedidos_TodosCampos.SQL.Append('Select * from Pedidos');
		Qry_Pedidos_TodosCampos.SQL.Append('Where COD_PEDIDO=0');
		Qry_Pedidos_TodosCampos.Open; // Abrindo a query, é permitida a INSERÇÃO de DADOS via [ZQRY].APPEND;
		// ................................................................................................ //
		//
		// Colocando "query aberta" em INSERÇÃO :
		Qry_Pedidos_TodosCampos.Append; // o mesmo que : 	Qry_Livre.Insert; => Coloca query em INSERÇÃO ;

		// ................................................................................................ //
		// Abaixo, Lembre-se de de ajustar : Qry_LivreCod_Pedido.Required := False;
		// Qry_Livre.FieldByName('COD_PEDIDO').Clear; //  Nulo, para usar AUTOINCREMENTO ;
		//
		Qry_Pedidos_TodosCampos.FieldByName('DATA_PEDIDO').AsDateTime:= Now ;
		Qry_Pedidos_TodosCampos.FieldByName('VALOR_PAGO').AsFloat    := 0   ;
		Qry_Pedidos_TodosCampos.FieldByName('COD_CLI').AsInteger     := Qry_Clientes.FieldByName('COD_CLI').AsInteger;
		Qry_Pedidos_TodosCampos.FieldByName('LOJA_CLI').AsString     := Qry_Clientes.FieldByName('LOJA_CLI').AsString;
		Qry_Pedidos_TodosCampos.FieldByName('COD_FUN').AsInteger     := Qry_Funcionarios.FieldByName('COD_FUN').AsInteger;
		//
		Qry_Pedidos_TodosCampos.ApplyUpdates; // Confirmando gravação dos dados da query ;
		Zconnection.Commit;      // Gravando FISICAMENTE dados inseridos na query ;

		// Fim : b.2) Faz inserção dos dados do PEDIDO ;
		// ................................................................................................ //
		// b.3) ABRINDO QUERY com os DADOS DO PEDIDO ATUAL
		Qry_Pedidos_TodosCampos.CLOSE;		
		Qry_Pedidos_TodosCampos.SQL.Clear;
		Qry_Pedidos_TodosCampos.SQL.Append('Select * from Pedidos');
		Qry_Pedidos_TodosCampos.SQL.Append('Where COD_PEDIDO=' + IntToStr(Cod_PED_SeraIncluido));
		//
		// SHOWMESSAGE('Veja o pedido que será FILTRADO (O QUE Acabou de INCLUIR)'+#13+#13+
		// Qry_Pedidos_TodosCampos.SQL.TEXT );
		//		
		Qry_Pedidos_TodosCampos.OPEN;

		// Fim : b.3) ABRINDO QUERY com os DADOS DO PEDIDO ATUAL
		// ................................................................................................ //
	End;

	// Se o formulário não foi enviado para memória, envia-o ;
	if F_IncluiPedido=Nil then Application.CreateForm(TF_IncluiPedido, F_IncluiPedido);


	With F_Dm_Pedidos.Qry_Iten_Pedido do
	Begin
		SQL.CLEAR;
		SQL.Append('Select * from ITEN_PEDIDO');
		SQL.Append('Where COD_PED=' + IntToStr(Cod_PED_SeraIncluido));
		Open;
	End;

	F_IncluiPedido.Entrar_Incluindo := True; // Faz entrar já incluindo ITEM ;
	F_IncluiPedido.ShowModal;     // Visualiza o form de Inclusão de Pedidos 
	F_IncluiPedido.Entrar_Incluindo := False;

	// * Ao finalizar inclusão do Pedido, FECHA CONEXÃO com BANCO DE DADOS ;
	// * Assim, fecha TODAS TRANSAÇÕES ABERTAS ;
	F_Dm_Pedidos.Zconnection.Connected := False;
end;

procedure TF_Principal.Pedidos1Click(Sender: TObject);
begin
	// Se o formulário não foi enviado para memória, envia-o ;
  If F_Psq_Pedidos=nil then Application.CreateForm(TF_Psq_Pedidos, F_Psq_Pedidos);
  F_Psq_Pedidos.ShowModal;

	// * Ao finalizar inclusão do Pedido, FECHA CONEXÃO com BANCO DE DADOS ;
	// * Assim, fecha TODAS TRANSAÇÕES ABERTAS ;
	F_Dm_Pedidos.Zconnection.Connected := False;
end;

procedure TF_Principal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
{
	Case Key of
		Vk_Escape : Close;
		Vk_F5  :  Bt_Calculadora.Click;
		//
		Vk_F10 :
		Begin
			Key := 0;
			Bt_ConsultarPedidos.click;
		End;
		//
		Vk_F12 :  Bt_Pedidos.click;
	End;
}
end;

procedure TF_Principal.Clientes2Click(Sender: TObject);
begin
	showmessage('Este software NÃO POSSUI A PARTE DE RELATÓRIOS'+#13+#13+
	'com QUICKREPORT, para poder ser aberto em DELPHI 6 ou SUPERIOR'+#13+#13+
	'ficando ao gosto do usuário criá-lo no QUICK REPORT ou RAVE REPORTS...');

{	Aviso_Possivel_Erro_QuickReport;

	// Caso o Formulário não foi colocado na memória, coloca-o
	If F_Rel_Clientes=Nil then Application.CreateForm(TF_Rel_Clientes, F_Rel_Clientes);


	With 	F_Dm_Pedidos.Qry_Clientes.SQL do
	Begin
		Clear;
		Append('Select * from cliente');
		Append('order by nome');
		F_Dm_Pedidos.Qry_Clientes.Open;
	End;

	If F_Dm_Pedidos.Qry_Clientes.RecordCount=0 then
	Begin
		Application.MessageBox('Nenhum pedido encontrado',
		'Nenhum registro de Pedido a imprimir', Mb_Ok + Mb_IconInformation );
		//
		// Fechando todas querys e conexão com o B.D.
		F_Dm_Pedidos.ZConnection.Connected:=False;
		//
		Exit;
	End;

	// Mostra o formulário de impressão ;
	Try
		F_Rel_Clientes.QuickRep.Preview;
	Except
		Application.MessageBox( Pchar(
		'* Para contornar este erro, pode-se :'+#13+#13+
		'=> Ajustar , no computador que "falhar", '+#13+
		'para somente imprimir o relatório e NÃO visualizá-lo ;'+#13+#13+
		'=> Criar o relatório no RAVEREPORT (DELPHI 7.0) ;'+#13+#13+
		'=> Criar o relatório com componentes especiais comprados ;' ),
		'Incompatibilidade do QUICK REPORT', Mb_Ok + Mb_IconWarning);
	End;

	// Fechando todas querys e conexão com o B.D.
	F_Dm_Pedidos.ZConnection.Connected:=False; }
end;

procedure TF_Principal.TodosSEMpreviewpersonalizadoClick(Sender: TObject);
begin
	showmessage('Este software NÃO POSSUI A PARTE DE RELATÓRIOS'+#13+#13+
	'com QUICKREPORT, para poder ser aberto em DELPHI 6 ou SUPERIOR'+#13+#13+
	'ficando ao gosto do usuário criá-lo no QUICK REPORT ou RAVE REPORTS...');

{	Aviso_Possivel_Erro_QuickReport;

	// Imprimindo TODOS pedidos
	With F_Dm_Pedidos.Qry_Pedidos_Cli_Fun do
	Begin
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
		SQL.Append(' ');		
		SQL.Append('GROUP BY');
		SQL.Append('PEDIDOS.COD_PEDIDO, PEDIDOS.DATA_PEDIDO, CLIENTE.NOME, FUNCIONARIOS.NOME, PEDIDOS.VALOR_PAGO');
      //
		Open;
		//
		If F_Dm_Pedidos.Qry_Pedidos_Cli_Fun.RecordCount=0 then
		Begin
			Application.MessageBox('Nenhum pedido encontrado',
			'Nenhum registro de Pedido a imprimir', Mb_Ok + Mb_IconInformation );
			//
			// Fechando todas querys e conexão com o B.D.
			F_Dm_Pedidos.ZConnection.Connected:=False;
			//
			Exit;
		End;
		Close;
	end;
	


	// Caso o Formulário não foi colocado na memória, coloca-o
	If F_Rel_Ped=Nil then Application.CreateForm(TF_Rel_Ped, F_Rel_Ped);
	//
	// Conectando TABLE DETALHE na TABLE MESTRE :
	With F_dm_Pedidos do
	Begin
		Qry_Iten_Pedido.Close;                                   // Fechando TABLE detalhe
		Qry_Iten_Pedido.MasterSource 		:= Ds_Pedidos_Cli_Fun ; // Datasource da TABLE MESTRE
		Qry_Iten_Pedido.MasterFields 		:= 'Cod_Pedido';        // Chave PRIMÁRIA tabela MESTRE
		Qry_Iten_Pedido.IndexfieldNames 	:= 'Cod_Ped';           // Chave ESTRANGEIRA tabela DETALHE
		Qry_Iten_Pedido.Open;                                    // Abrindo TABLE detalhe
		Qry_Pedidos_Cli_Fun.Open;                                // Abrindo TABLE MESTRE
	End;
	//
	// Mostra o formulário de impressão ;
	Try

		F_Rel_Ped.QuickRep.Preview;
	Except
		Application.MessageBox( Pchar(
		'* Para contornar este erro, pode-se :'+#13+#13+
		'=> Ajustar , no computador que "falhar", '+#13+
		'para somente imprimir o relatório e NÃO visualizá-lo ;'+#13+#13+
		'=> Criar o relatório no RAVEREPORT (DELPHI 7.0) ;'+#13+#13+
		'=> Criar o relatório com componentes especiais comprados ;' ),
		'Incompatibilidade do QUICK REPORT', Mb_Ok + Mb_IconWarning);
	End;
	//
	// Desconectando TABLE DETALHE na TABLE MESTRE :
	With F_dm_Pedidos do
	Begin
		Qry_Iten_Pedido.Close;                             // Fechando TABLE detalhe
		Qry_Iten_Pedido.MasterSource 		:= Nil ;          // Datasource da TABLE MESTRE
		Qry_Iten_Pedido.MasterFields 		:= '';            // Chave PRIMÁRIA tabela MESTRE
		Qry_Iten_Pedido.IndexfieldNames 	:= 'Cod_Ped';     // Chave ESTRANGEIRA tabela DETALHE
		//                                                 // .............
		//
		// Fechando todas querys e conexão com o B.D.
		F_Dm_Pedidos.ZConnection.Connected:=False;
		//
	End;
 }

end;

procedure TF_Principal.FiltradosporData1Click(Sender: TObject);
{Var
Data_MMDDAAAA, Data : String;
ClickedOK : Boolean;         }
begin
	showmessage('Este software NÃO POSSUI A PARTE DE RELATÓRIOS'+#13+#13+
	'com QUICKREPORT, para poder ser aberto em DELPHI 6 ou SUPERIOR'+#13+#13+
	'ficando ao gosto do usuário criá-lo no QUICK REPORT ou RAVE REPORTS...');

{	Aviso_Possivel_Erro_QuickReport;

	// Pergunta DATA A IMPRIMIR os PEDIDOS  ;
	While True do
	Begin
		Data := DateToStr(Date);
		//
		ClickedOK := InputQuery( 'Data dos Pedidos', 'Digite a DATA dos PEDIDOS a IMPRIMIR', Data);
		if ClickedOK=False then Exit; // Se não clicou em OK, cancela inclusão
		// .......................................................................................... //
		Try
			StrToDate( Data )
		Except
			If Application.MessageBox( Pchar(
			'Digite novamente a Data'), 'Data digitada é INVÁLIDA', Mb_OkCancel + Mb_IconWarning)=mrCancel then
			Exit
			Else
			Continue
		End;
		// .......................................................................................... //
		Break ; // Sai do laço WHILE ... TRUE DO
	End;
	// Fim : Pergunta DATA A IMPRIMIR os PEDIDOS  ;

	// Filtrando PEDIDO por DATA digitada
	With F_Dm_Pedidos.Qry_Pedidos_Cli_Fun do
	Begin
		// Invertendo a data para colocá-la no select : dd/mm/yyyy => mm/dd/yyyy
		Data_MMDDAAAA :=
		Copy( Data, 4,2 )+'/'+ Copy( Data, 1,2 ) + '/'+  Copy( Data, 7,4 );
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
		Open;
		//
		If F_Dm_Pedidos.Qry_Pedidos_Cli_Fun.RecordCount=0 then
		Begin
			Application.MessageBox('Nenhum pedido encontrado',
			'Nenhum registro de Pedido a imprimir', Mb_Ok + Mb_IconInformation );
			//
			// Fechando todas querys e conexão com o B.D.
			F_Dm_Pedidos.ZConnection.Connected:=False;
			//
			Exit;
		End;
		Close;
	end;
	
	// Caso o Formulário não foi colocado na memória, coloca-o
	If F_Rel_Ped=Nil then Application.CreateForm(TF_Rel_Ped, F_Rel_Ped);
	//
	// Conectando TABLE DETALHE na TABLE MESTRE :
	With F_dm_Pedidos do
	Begin
		Qry_Iten_Pedido.Close;                                   // Fechando TABLE detalhe
		Qry_Iten_Pedido.MasterSource 		:= Ds_Pedidos_Cli_Fun ; // Datasource da TABLE MESTRE
		Qry_Iten_Pedido.MasterFields 		:= 'Cod_Pedido';        // Chave PRIMÁRIA tabela MESTRE
		Qry_Iten_Pedido.IndexfieldNames 	:= 'Cod_Ped';           // Chave ESTRANGEIRA tabela DETALHE
		Qry_Iten_Pedido.Open;                                    // Abrindo TABLE detalhe
		Qry_Pedidos_Cli_Fun.Open;                                // Abrindo TABLE MESTRE
	End;
	//
	// Mostra o formulário de impressão ;
	Try
		F_Rel_Ped.QuickRep.Preview;
	Except
		Application.MessageBox( Pchar(
		'* Para contornar este erro, pode-se :'+#13+#13+
		'=> Ajustar , no computador que "falhar", '+#13+
		'para somente imprimir o relatório e NÃO visualizá-lo ;'+#13+#13+
		'=> Criar o relatório no RAVEREPORT (DELPHI 7.0) ;'+#13+#13+
		'=> Criar o relatório com componentes especiais comprados ;' ),
		'Incompatibilidade do QUICK REPORT', Mb_Ok + Mb_IconWarning);
	End;
	//
	//
	// Desconectando TABLE DETALHE na TABLE MESTRE :
	With F_dm_Pedidos do
	Begin
		Qry_Iten_Pedido.Close;                             // Fechando TABLE detalhe
		Qry_Iten_Pedido.MasterSource 		:= Nil ;          // Datasource da TABLE MESTRE
		Qry_Iten_Pedido.MasterFields 		:= '';            // Chave PRIMÁRIA tabela MESTRE
		Qry_Iten_Pedido.IndexfieldNames 	:= 'Cod_Ped';     // Chave ESTRANGEIRA tabela DETALHE
		//                                                 // .............
		// Fechando todas querys e conexão com o B.D.
		F_Dm_Pedidos.ZConnection.Connected:=False;
	End; }

end;

procedure TF_Principal.FormShow(Sender: TObject);
begin
	// Para acesso via rede , altere as propriedades do ZCONNECTION :
	// ZCONNECTION.HostName ....: IP do SERVIDOR da base de dados ; Exemplo : "192.168.0.1"
	// ZCONNECTION.DATABASENAME : Caminho da base de dados        ; Exemplo : "\sistemas\db"
	//
	// Ajustando propriedade DATABASE do ZCONNECTION, para a PASTA DO EXECUTÁVE.
	F_Dm_Pedidos.ZConnection.Database := ExtractFilePath(ParamStr(0))  +'PEDIDOS_COM_IR.FDB';
	//
	// Verificando se o banco de dados está na pasta do executável ;
	// (como esta é uma versão para teste, faz esta verificação aqui)	
	If not FileExists( F_Dm_Pedidos.ZConnection.Database   ) then
	Begin
		Application.messageBox( Pchar(
		'* O arquivo "PEDIDOS_COM_IR.FDB" deve'+#13+#13+#13+
		' deve ser DESCOMPACTADO, na pasta da própria aplicação ;'),
		'APLICAÇÃO será FINALIZADA', Mb_Ok + Mb_IconWarning);
		Application.Terminate; Exit;
	End;
	//
{  Se não estiver na pasta SYSTEM do WINDOWS, então tem que estar na pasta do EXECUTÁVEL,
	a biblioteca do BANCO DE DADOS .
	//
	// Verificando se a fbclient.DLL está na pasta do executável ;
	If not FileExists( ExtractFilePath(ParamStr(0))  +'FBCLIENT.DLL'  ) then
	Begin
		Application.messageBox( Pchar(
		'* O arquivo "fbclient.dll" deve'+#13+#13+#13+
		' deve ser estar na pasta do EXECUTÁVEL, pois este é o FIREBIRD 1.5.2,'+#13+#13+
		' e exige tal cópia da .dll para poder fazer a conexão ;'),
		'APLICAÇÃO será FINALIZADA', Mb_Ok + Mb_IconWarning);
		Application.Terminate; Exit;
	End; }

	//
	// Se o FIREBIRD 1.5.2 não estiver na memória, EMITE AVISO e sai da Aplicação ;
	{if (FindWindow('Fb_Server', nil))=0 then
	Begin
		Application.MessageBox( Pchar(
		'* O banco de dados FIREBIRD 1.5.2 não está sendo executado ;'+#13+#13+
		'* Ao clicar em [Ok] , este formulário será fechado ;'+#13+#13+
		'* Instale o banco de dados e Execute-o;'),
		'APLICAÇÃO será FINALIZADA', Mb_Ok + Mb_IconWarning);
		//
		// única maneira de fechar o próprio form, é com um Timer ;
		Application.Terminate; Exit;
	End;}
end;

procedure TF_Principal.VisualizaoPadro1Click(Sender: TObject);
begin
{	// Altera a marca de checagem do ITEM DO MENU ;
	VisualizaoPadro1.Checked := True;
	//
	// Se os forms não foram enviados, envia-os ;	
	If F_Rel_Clientes = Nil then Application.CreateForm( TF_Rel_Clientes, F_Rel_Clientes );
	If F_Rel_Ped      = Nil then Application.CreateForm( TF_Rel_Ped, F_Rel_Ped );
	//
	// RETORNA Como estavam os relatórios, eventos ONPREVIEW ; 
	F_Rel_Clientes.QuickRep.OnPreview 	:= F_Rel_Clientes_ComoEstava 	;
	F_Rel_Ped.QuickRep.OnPreview 	:= F_Rel_Ped_ComoEstava 		; }
end;

procedure TF_Principal.VisualizaoPersonalizada1Click(Sender: TObject);
begin
{	// Altera a marca de checagem do ITEM DO MENU ;
	VisualizaoPersonalizada1.Checked := True;
	//
	// Se os forms não foram enviados, envia-os ;
	If F_Rel_Clientes = Nil then Application.CreateForm( TF_Rel_Clientes, F_Rel_Clientes );
	If F_Rel_Ped      = Nil then Application.CreateForm( TF_Rel_Ped, F_Rel_Ped );
	//
	// MARCA Como estavam os relatórios, eventos ONPREVIEW ;
	F_Rel_Clientes_ComoEstava 	:= F_Rel_Clientes.QuickRep.OnPreview;
	F_Rel_Ped_ComoEstava 		:= F_Rel_Ped.QuickRep.OnPreview;
	//
	// ALTERA eventos ONPREVIEW para usar a função personalizada MOSTRARPREVIEW ;
	F_Rel_Clientes.QuickRep.OnPreview:=MostrarPreview;
	F_Rel_Ped.QuickRep.OnPreview:=MostrarPreview; }
End;

// Procedure CRIADA PELO PROGRAMADOR, para mostrar a visualização PERSONALIZADA de RELATÓRIOS,
// utilizando o FORMULÁRIO F_PREVIEW ;
Procedure TF_Principal.MostrarPreview(Sender: TObject);
Begin
{	 // Adicione a biblioteca "qrprntr"
	 // na cláusula Uses para funcionar esta linha
	F_Preview.QRPreview.QRPrinter := TQRPrinter(Sender);
	F_Preview.ShowModal; }
end;

end.
