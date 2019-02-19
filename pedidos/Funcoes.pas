unit Funcoes;

{$MODE Delphi}

interface

//Function  Troca_Acento_Por_Underline( Str_Enviada:String ) : String;
//Procedure EnterToTab_FKeyPress(Var Key: Char);
Procedure Aviso_Possivel_Erro_QuickReport;

implementation

Uses LCLIntf, LCLType, LMessages{ função keybd_event }, forms{Application.MessageBox};

Procedure Aviso_Possivel_Erro_QuickReport;
Begin
	Application.MessageBox( Pchar(
	'* Existe um "bug" no quick report'+#13+#13+
	'que impede que alguns PROCESSADORES ou PLACAS DE VÍDEO'+#13+#13+
	'visualizem os relatórios nele gerados ;'+#13+#13+#13+
	'* Para contornar este erro, pode-se :'+#13+#13+
	'=> Ajustar , no computador que "falhar", '+#13+
	'para somente imprimir o relatório e NÃO visualizá-lo ;'+#13+#13+
	'=> Criar o relatório no RAVEREPORT (DELPHI 7.0) ;'+#13+#13+
	'=> Criar o relatório com componentes especiais comprados ;' ),
	'Leia com ATENÇÃO', Mb_Ok + Mb_IconWarning);

End;


// Transforma a "Enter" em "Tab",
// ideal para ser colocado em edição de arquivos
// Como usar :
// Insira no evento OnKeyPress do Form :
//
//  If GrupoVerifica.Visible=True then EnterToTab_FKeyPress(Key);
{Procedure EnterToTab_FKeyPress(Var Key: Char);
Begin
   // Se pressionou [Enter], Transforma em Tab;
   If Key=#13 then
   Begin
		Key := #0; // Cancela tecla digitada
		keybd_event(VK_Tab, 0, 0, 0);   //  Pressiona TAB  // keybd_event => Unit Windows
   End;
End;}


// Esta função troca qualquer caractere acentuado ou com cedilha, por "_" (underline).
// Esta função é usada na "montagem" de querys com "like" e filtros por descrições ;
{Function Troca_Acento_Por_Underline( Str_Enviada:String ) : String;
Var
Antes, s:String;
x:Integer;
Begin
	s:='';
	// Se for algum caractere acentuado, substitui por "_"
   Antes := Str_Enviada ;
   For x:=1 to Length(Antes) do
   begin
		If Antes[X] in [
		'á' , 'Á' , 'à','À', 'Ã','ã', 'â', 'Â' , 'ª', 'º',
		'é' , 'É' , 'è','È',          'ê', 'Ê' ,
		'í' , 'Í' , 'ì','Ì',          'î', 'Î' ,
		'ó' , 'Ó' ,          'Õ','õ', 'ô', 'Ô' ,
		'ú' , 'Ú' ,
		'ç' , 'Ç'   ] then
		S:= S + '_'
		Else
		S:= S + Antes[X];
   End;
   Result := S;
End;}

end.
 
