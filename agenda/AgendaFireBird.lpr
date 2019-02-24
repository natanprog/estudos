program AgendaFireBird;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes
  { you can add units after this },
  IBDatabase, IBQuery, IBCustomDataSet, sysutils, Crt;

var
  Database : TIBDataBase;
  Trans : TIBTransaction;
  Query : TIBQuery;
  OP,
  Codigo : Integer;
  Nome,
  Telefone : String;

// Cadastra uma Pessoa na Agenda...
procedure Cadastra;
begin
  // Monta uma tela bem simples...
  ClrScr;
  WriteLn('*********************');
  WriteLn('Agenda 1.0 - Cadastro');
  WriteLn('*********************');
  WriteLn;
  WriteLn('Deixe o nome em branco para sair...');
  WriteLn;
  Nome := '';
  Telefone := '';
  //Solicita o Nome
  Write('Informe o Nome: '); ReadLn(Nome);
  if Nome = '' then
    Exit;
  //Solicita o telefone...
  Write('Informe o Fone: '); ReadLn(Telefone);
  WriteLn;
  try
    Query.Close;
    Query.SQL.Clear;
    WriteLn('Inserindo Registro');
    // Inicia a transação... o método Trans.StartTransaction não está estável...
    Query.AutoCommit := acCommitRetaining;
    Trans.Active := True;
    // Apesar da query já possuir o método prepare, os parâmetros não são
    //informados corretamente, sendo assim optei em utilizar tudo em uma
    //única linha.
    Query.SQL.Add('INSERT INTO AGENDA (NOME, TELEFONE) VALUES ('+#39+Nome+#39+
                  ', '+#39+Telefone+#39+')');
    // Executa a query...
    Query.ExecSQL;
    // Comita a Transação
    Trans.Commit;
    WriteLn('Registro Inserido...');
  except
    // Se falhar...
    on E:Exception do
    begin
      WriteLn('Erro Inserindo Registro...');
      Query.SQL.Clear;
      // Realiza um rollback...
      Trans.Rollback;
    end;
  end;
  WriteLn;
end;

// Altera os dados de uma pessoa na Agenda.
procedure Altera;
var
  S : String;
  NomeNovo : String;
  FoneNovo : String;
begin
  // Monta uma tela bem simples...
  ClrScr;
  WriteLn('**********************');
  WriteLn('Agenda 1.0 - Alteração');
  WriteLn('**********************');
  WriteLn;
  WriteLn('Informe 0 (Zero) para sair...');
  WriteLn;
  Codigo := 0;
  // Solicita o código a alterar...
  Write('Código a Alterar: '); ReadLn(Codigo);
  if Codigo = 0 then
    Exit;
  // Inicia a transação... o método Trans.StartTransaction não está estável...
  Query.AutoCommit := acCommitRetaining;
  Trans.Active := True;
  WriteLn('Buscando Registro...');
  Query.SQL.Clear;
  Query.SQL.Add('SELECT FIRST 1 * FROM AGENDA WHERE CODIGO = '+#39+
                IntToStr(Codigo)+#39);
  // Abre a query, e recupera os dados...
  Query.Open;
  Codigo := Query.FieldByName('CODIGO').AsInteger;
  Nome := Query.FieldByName('NOME').AsString;
  Telefone := Query.FieldByName('TELEFONE').AsString;
  // Fecha a query e a transação...
  Query.Close;
  Trans.Commit;
  Query.SQL.Clear;
  // Se o código informado não estiver disponível no banco de dados,
  // sai da rotina.
  if Codigo = 0 then
  begin
    WriteLn('Registro não encontrado...');
    Exit;
  end;
  WriteLn;
  WriteLn('Dados Atuais');
  WriteLn('Nome....: ', Nome);
  WriteLn('Telefone: ', Telefone);
  WriteLn;
  WriteLn;
  WriteLn('Informe os Novos Dados (Deixe em branco para manter)');
  Write('Nome....: '); ReadLn(NomeNovo);
  Write('Telefone: '); ReadLn(FoneNovo);
  WriteLn;
  // Só grava se foi alterado o nome ou telefone!
  if NomeNovo = Nome then
    NomeNovo := '';
  if FoneNovo = Telefone then
    FoneNovo := '';
  if (NomeNovo = '') and (FoneNovo = '') then
  begin
    WriteLn('Não a dados a alterar!');
    Exit;
  end;
  try
    S := '';
    if (NomeNovo <> '') then
      S := 'NOME = '+#39+NomeNovo+#39;
    if (FoneNovo <> '') then
    begin
      if (S <> '') then
        S := S+', ';
      S := S+'TELEFONE = '+#39+FoneNovo+#39;
    end;
    // Monta o Update apenas dos dados alterados...
    S := 'UPDATE AGENDA SET '+S+' WHERE CODIGO = ';
    S := S + #39+IntToStr(Codigo)+#39;
    //WriteLn(S);
    Query.SQL.Add(S);
    // Inicia a transação... o método Trans.StartTransaction não está estável...
    Query.AutoCommit := acCommitRetaining;
    Trans.Active := True;
    // Executa a Query e commita a transação...
    Query.ExecSQL;
    Trans.Commit;
    Query.SQL.Clear;
    WriteLn('Registro alterado...');
  except
    // Se falhar, mostra uma mensagem e faz um rollback...
    on E:Exception do
    begin
      Query.SQL.Clear;
      WriteLn('Erro Alterando Registro...');
      Trans.Rollback;
    end;
  end;
end;

// Apaga uma pessoa da agenda...
procedure Exclui;
var
  Ok : String;
begin
  // Monta uma tela bem simples...
  clrscr;
  WriteLn('*********************');
  WriteLn('Agenda 1.0 - Exclusão');
  WriteLn('*********************');
  WriteLn;
  WriteLn('Informe 0 (Zero) para sair...');
  WriteLn;
  // Solicita o código para excluir...
  Codigo := 0;
  Write('Código a Excluir: '); ReadLn(Codigo);
  if Codigo = 0 then
    Exit;
  Query.SQL.Clear;
  // Inicia a transação...
  Query.AutoCommit := acCommitRetaining;
  Trans.Active := True;
  WriteLn('Buscando Registro...');
  Query.SQL.Add('SELECT FIRST 1 * FROM AGENDA WHERE CODIGO = '+#39+
                IntToStr(Codigo)+#39);
  // Abre a query, recupera os campos e fecha a transação...
  Query.Open;
  Codigo := Query.FieldByName('CODIGO').AsInteger;
  Nome := Query.FieldByName('NOME').AsString;
  Telefone := Query.FieldByName('TELEFONE').AsString;
  Query.Close;
  Trans.Commit;
  Query.SQL.Clear;
  if Codigo = 0 then
  begin
    WriteLn('Registro não encontrado...');
    Exit;
  end;
  // Exibe os dados atuais...
  WriteLn;
  WriteLn('Dados Atuais');
  WriteLn('Nome....: ', Nome);
  WriteLn('Telefone: ', Telefone);
  WriteLn;
  WriteLn;
  Write('Deseja Realmente Excluir este registro ? [S]im ou [N]ão: '); ReadLn(Ok);
  if Ok <> 'S' then
    Exit;
  try
    // Inicia a transação...
    Query.AutoCommit := acCommitRetaining;
    Trans.Active := True;
    // Monta a query e exclui o registro...
    Query.SQL.Add('DELETE FROM AGENDA WHERE CODIGO = '+#39+IntToStr(Codigo)+#39);
    Query.ExecSQL;
    //Commita a transação...
    Trans.Commit;
    Query.SQL.Clear;
    WriteLn('Registro Excluído...');
  except
    // Se falhar, faz um rollback...
    on E:Exception do
    begin
      Query.SQL.Clear;
      WriteLn('Erro excluindo Registro...');
      Trans.Rollback;
    end;
  end;
end;

// Lista todos os registros na tela em ordem alfabética...
procedure ListaTodos;
var
  Linha : Integer;
begin
  // Monta uma tela bem simples...
  ClrScr;
  WriteLn('************************');
  WriteLn('Agenda 1.0 - Lista Todos');
  WriteLn('************************');
  WriteLn;
  Linha := 6;
  GotoXY(1,5); Write('Codigo');
  GotoXY(8,5); Write('Nome');
  GotoXY(63,5); Write('Telefone');
  // Inicia a transação...
  Query.AutoCommit := acCommitRetaining;
  Trans.Active := True;
  // Monta a Query...
  Query.SQL.Text := 'SELECT * FROM AGENDA ORDER BY NOME';
  try
    Query.Open;
    // Enquanto tiver registros...
    while not Query.EOF do
    begin
      // Faz o salto de página, mas espera uma tecla...
      if Linha > 23 then
      begin
        Repeat Until KeyPressed;
        ClrScr;
        WriteLn('************************');
        WriteLn('Agenda 1.0 - Lista Todos');
        WriteLn('************************');
        WriteLn;
        Linha := 6;
        GotoXY(1,5); Write('Codigo');
        GotoXY(8,5); Write('Nome');
        GotoXY(63,5); Write('Telefone');
      end;
      // Imprime a linha...
      GotoXY(1, Linha); Write(Query.FieldByName('CODIGO').AsInteger:6);
      GotoXY(8, Linha); Write(Query.FieldByName('NOME').AsString);
      GotoXY(63, Linha); Write(Query.FieldByName('TELEFONE').AsString:15);
      Inc(Linha);
      // Avança um registro...
      Query.Next;
    end;
    // Termina a Transação...
    Query.Close;
    Trans.Commit;
    Query.SQL.Text := '';
  except
    // Se falhar, faz um rollback...
    on E:Exception do
    begin
      Query.Close;
      WriteLn;
      WriteLn('Erro Consultando Registros...');
      Trans.Rollback;
      Query.SQL.Text := '';
    end;
  end;
  ReadLn;
end;

// Rotina principal do programa...
var
  Ok : Boolean;
begin
  // Inicializa a conexão com o banco e a transação...
  WriteLn;
  WriteLn('Criando componentes...');
  Database := TIBDataBase.Create(Nil);
  Trans := TIBTransaction.Create(Nil);
  //Database.DatabaseName := '127.0.0.1/3050:/home/natanprog/estudos/agenda/agenda.fdb';
  Database.LoginPrompt := False;
  Database.SQLDialect := 3;
  Database.Params.Clear;
  Database.Params.Add('user_name=SYSDBA');
  Database.Params.Add('password=Zero2040');
  Database.Params.Add('lc_ctype=UTF8');
  Database.DefaultTransaction := Trans;
  Database.DatabaseName := 'localhost/3050:/home/natanprog/estudos/agenda/agenda.fdb';
  // Tenta conectar com o banco, se falhar finaliza o aplicativo...
  Write('Abrindo Banco... Conectou ? ');
  try
    Database.Open;
    Ok := Database.Connected;
  except
    Ok := False;
  end;
  if not Ok then
  begin
    WriteLn('Não!');
    WriteLn('Abandonando o sistema!');
  end
  else
  begin
    WriteLn('Sim!');
    //Cria a query...
    Query := TIBQuery.Create(Nil);
    // Liga a Query ao Banco de Dados e a transação...
    Query.Database := Database;
    Query.Transaction := Trans;
    OP := 1;
    // Menu principal do programa...
    while OP <> 0 do
    begin
      ClrScr;
      WriteLn('******************************************************');
      WriteLn('Controle de Agenda 1.0 - Modo Console ( 32 bits Real )');
      WriteLn('******************************************************');
      WriteLn;
      WriteLn;
      WriteLn('1 - Cadastrar');
      WriteLn('2 - Alterar');
      WriteLn('3 - Excluir');
      WriteLn('4 - Listar Todos');
      WriteLn('0 - Sair');
      WriteLn;
      WriteLn;
      WriteLn('Aviso! Todas as opções deste programa estão funcionando!');
      WriteLn;
      WriteLn{('Mas, o compilador ainda não é 100% confiável, portando, '
              + 'determinadas opções,')};
      WriteLn{('quando executadas mais de uma vez sem reiniciar o programa, '
              + 'podem falhar.')};
      WriteLn;
      // Le o menu e executa as opções...
      Write('Informe a opção desejada: ');
      ReadLn(OP);
      case OP of
        1: Cadastra;
        2: Altera;
        3: Exclui;
        4: ListaTodos;
      end;
      if OP <> 0 then
      begin
        WriteLn;
        WriteLn('Pressione qualquer tecla para continuar...');
        Repeat Until KeyPressed;
      end;
    end;
    WriteLn('Fechando Query...');
    //Trans.Commit;
    Query.Free;
  end;
  Write('Desconectando banco de dados...');
  Database.Close;
  WriteLn;
  Trans.Free;
  Database.Free;
end.
