unit Psq_Cli;

{$MODE Delphi}

interface

uses
  LCLIntf, LCLType{, LMessages, Messages}, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, StdCtrls, Buttons, ExtCtrls;

type
  TF_Psq_Cli = class(TForm)
    Label1: TLabel;
    Ed_Nome: TEdit;
    Grd_Busca: TDBGrid;
    Label2: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Timer_Fecha_Form: TTimer;
    Label10: TLabel;
    Label11: TLabel;
    Bt_Cadastro: TSpeedButton;
    Bt_Escolhe: TSpeedButton;
    Bt_Saida: TSpeedButton;
    procedure Ed_NomeKeyPress(Sender: TObject; var Key: Char);
    procedure Ed_NomeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Bt_CadastroClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
		Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure Ed_NomeChange(Sender: TObject);
    procedure Timer_Fecha_FormTimer(Sender: TObject);
    procedure Bt_SaidaClick(Sender: TObject);
    procedure Bt_EscolheClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Psq_Cli: TF_Psq_Cli;

implementation

uses Dm_Pedidos, Clientes, DB{, Funcoes para usar função : Troca_Acento_Por_Underline};

{$R *.lfm}



procedure TF_Psq_Cli.Ed_NomeKeyPress(Sender: TObject; var Key: Char);
begin
	If key='*' then
	Begin
		key:=#0; // Anulando tecla, Evitando que apareça o "asterisco digitado" ;
		With F_Dm_Pedidos.Qry_Clientes do // ... NÃO É O EVENTO ONKEYDOWN ;
		Begin
			SQL.Clear;
			SQL.Append('Select * From Cliente');   
			SQL.Append('order by Nome'  );
			Open;
		End;
		//
		Application.MessageBox( Pchar(
		'* Esta técnica, de abrir a TABLE INTEIRA,'+#13+#13+
		'é colocada aqui apenas para TESTE ;'+#13+#13+#13+
		'* Somente deve ser usada em tables com no máximo 300 registros,'+#13+#13+
		'sob o risco de perda de performance por'+#13+#13+
		'causar excesso de tráfego de registros na rede ;'),
		'Leia com atenção', Mb_Ok + Mb_IconInformation );
		Exit;
	End;

	If key='+' then    // Teclou "+" , anula a tecla e filtra ...
	With F_Dm_Pedidos.Qry_Clientes do // ... NÃO É O EVENTO ONKEYDOWN ;
	Begin
		key:=#0; // Anulando tecla, Evitando que apareça o "+" digitado ;
		//
		If Length(   Trim(Ed_Nome.Text)   )<3 then // Impedindo FILTROS com menos de 3 caracteres :
		Begin
			Application.MessageBox( 'Digite pelo menos 3 CARACTERES para filtrar',
			'Filtro Cancelado', Mb_Ok + Mb_IconInformation); Exit;
		End;
		If Trim(Ed_Nome.Text)='' then // Verificando se digitou algo para filtrar
      Begin
         Application.MessageBox( 'Digite algo para filtrar',
         'Impossível filtrar', Mb_Ok + Mb_IconInformation ); Exit;
      End;
		SQL.Clear;
		SQL.Append('Select * From Cliente');   // Select * From Cliente
      SQL.Append('Where Upper(Nome) like '); // Where Upper(Nome) like '%MARIA%'
		SQL.Append( QuotedStr( '%'+UpperCase({Troca_Acento_Por_Underline}( Ed_Nome.Text))+'%')  );
		SQL.Append( 'order by Nome'  );
		//
	   Showmessage('Veja a QUERY a abrir : '+#13+#13+ SQL.TEXT ); Open;
		// Verificando se o filtro resultou em algum registro ;
		If F_Dm_Pedidos.Qry_Clientes.RecordCount=0 then
		Begin
			Application.MessageBox('Nenhum Registro foi filtrado',
			'Filtro não resultou registros', Mb_Ok + Mb_IconInformation); Close;
		End;
		Ed_Nome.Clear;
   End;
end;

procedure TF_Psq_Cli.Ed_NomeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

	With F_Dm_Pedidos do
	If Qry_Clientes.Active then	
	Case key of
      Vk_Up    : Qry_Clientes.MoveBy(-1);  // Seta para Cima
      Vk_Down  : Qry_Clientes.MoveBy(+1);  // Seta para Baixo
      //
      Vk_Prior : Qry_Clientes.MoveBy(-10); // Page UP
      Vk_Next  : Qry_Clientes.MoveBy(+10); // Page DOWN
	End;
	//
	// Cancelando pressionamento da tecla, para evitar reposicionamento
	// do cursor na caixa Ed_Nome ;
	If Key in [ Vk_Up ,	Vk_Down , Vk_Prior , Vk_Next  ] Then
	Key := 0;
end;

procedure TF_Psq_Cli.Bt_CadastroClick(Sender: TObject);
begin
	// Se o formulário não foi enviado para memória, envia-o ;
	If F_Clientes=Nil then  Application.CreateForm(TF_Clientes, F_Clientes);
	F_Clientes.ShowModal; 	// Visualiza o cadastro de clientes ;
end;

procedure TF_Psq_Cli.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
	Case Key of
		Vk_Return : Bt_Escolhe.Click;
		//
      Vk_F10 :
      Begin
      	Key := 0; // inutilizando a tecla para não acionar o menu padrão windows
	      Bt_Cadastro.Click; // Entra no cadastro de Clientes
      End;
      Vk_Escape : Close; // Fecha formulário de Pesquisa de Funcionarios ;
   End;
end;

procedure TF_Psq_Cli.FormShow(Sender: TObject);
begin
	// CONECTANDO no BANCO :
	F_Dm_Pedidos.ZConnection.connected := TRUE;
end;

procedure TF_Psq_Cli.Ed_NomeChange(Sender: TObject);
begin
	// Unit DB
   // loPartialKey : Busca parcial ( Usada para DESCRIÇÕES, NOMES )
   // loCaseInsensitive : Posiciona INDEPENDENTE de maiúsculas/Minúsculas)
   //
   // se Query estiver "aberta" ... Então posiciona conforme o que digitou
   if  F_Dm_Pedidos.Qry_Clientes.Active=True then
	F_Dm_Pedidos.Qry_Clientes.Locate('Nome', Ed_Nome.Text, [loPartialKey, loCaseInsensitive]);
end;

procedure TF_Psq_Cli.Timer_Fecha_FormTimer(Sender: TObject);
begin
	// * Este timer simplesmente, ao ser ativado, desativa ele próprio para não ficar
	// executando-o indefinitivamente, e fecha FORMULÁRIO ;
	Timer_Fecha_Form.Enabled := False; // a) Desativa o timer   ;
	Close;                             // b) Fecha o formulário ;
end;

procedure TF_Psq_Cli.Bt_SaidaClick(Sender: TObject);
begin
	Close;
end;

procedure TF_Psq_Cli.Bt_EscolheClick(Sender: TObject);
begin
	If (F_Dm_Pedidos.Qry_Clientes.Active=True)	 then // * Se SELECT estiver aberto 			;
	If (F_Dm_Pedidos.Qry_Clientes.RecordCount>0) then // * Se RECORDCOUNT houver reg.filtrado ;
	Close

end;

procedure TF_Psq_Cli.FormCreate(Sender: TObject);
begin
	// Redimensionando o form conforme resolução do monitor ;
	ScaleBy(Screen.Width, 1920);

	Grd_Busca.Columns[0].Width := Round(Grd_Busca.Columns[0].Width * (Screen.Width/1920) );
	Grd_Busca.Columns[1].Width := Round(Grd_Busca.Columns[1].Width * (Screen.Width/1920) );
	Grd_Busca.Columns[2].Width := Round(Grd_Busca.Columns[2].Width * (Screen.Width/1920) );
	Grd_Busca.Columns[3].Width := Round(Grd_Busca.Columns[3].Width * (Screen.Width/1920) );
	
end;

procedure TF_Psq_Cli.FormActivate(Sender: TObject);
begin
	Top := 0; // Coloca formulário no TOPO do monitor. Se colocando no evento ONSHOW, não funciona ;
end;

end.
