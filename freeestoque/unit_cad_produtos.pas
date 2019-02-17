unit Unit_Cad_Produtos; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, DbCtrls, DBGrids, Buttons, ExtDlgs, LR_Class, LR_DBSet,
  LR_RRect, LR_Shape, Modelo_Cad, rxdbdateedit, rxlookup, rxdbcomb, db, IniFiles,
  UnitDados, Unit_rotinas, Unit_Cad_Grupos, Unit_Cad_Marcas, Unit_Cad_Modelos,
  Unit_Cad_Unidades, unitcad_fornecedores, rxtooledit, LCLType, DBExtCtrls;

type

  { TCad_Produtos }

  TCad_Produtos = class(TModelo_Cadastro)
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    btMostrar: TButton;
    btFiltrar: TButton;
    btLimpar: TButton;
    ftCarregar: TButton;
    ftDialogo: TOpenPictureDialog;
    ftLimpar: TButton;
    chk1: TCheckBox;
    chk2: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    DBEdit2: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    dt1: TDBDateEdit;
    dt2: TDBDateEdit;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBMemo1: TDBMemo;
    GroupBox3: TGroupBox;
    imgFoto: TImage;
    imgPadrao: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label28: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RxDBLookupCombo1: TRxDBLookupCombo;
    RxDBLookupCombo2: TRxDBLookupCombo;
    RxDBLookupCombo3: TRxDBLookupCombo;
    RxDBLookupCombo4: TRxDBLookupCombo;
    RxDBLookupCombo5: TRxDBLookupCombo;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    procedure btCancelarClick(Sender: TObject);
    procedure btEditarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btFiltrarClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure btMostrarClick(Sender: TObject);
    procedure btNovoClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure DBEdit2Exit(Sender: TObject);
    procedure DBEdit7Enter(Sender: TObject);
    procedure DBEdit8Enter(Sender: TObject);
    procedure DBMemo1Change(Sender: TObject);
    procedure DBMemo1Enter(Sender: TObject);
    procedure DBMemo1Exit(Sender: TObject);
    procedure dt1Enter(Sender: TObject);
    procedure dt1Exit(Sender: TObject);
    procedure dt1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dt1KeyPress(Sender: TObject; var Key: char);
    procedure dt1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure ftCarregarClick(Sender: TObject);
    procedure ftLimparClick(Sender: TObject);
    procedure GridDadosTitleClick(Column: TColumn);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
  private
    FlagFoto: byte;
    caminho: string;
    sCom: string;
    procedure SoLeitura(modo: boolean);
    procedure dsDataChange(Sender: TObject; Field: TField);
    { private declarations }
  public
    { public declarations }
  end; 

var
  Cad_Produtos: TCad_Produtos;

implementation

{ TCad_Produtos }

procedure TCad_Produtos.FormShow(Sender: TObject);
var dia,mes,ano: word;
uDia: string;
ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  {if ini.ReadString('configs','uso','')='Cliente' then caminho:=ini.ReadString('configs','servidor','')+':'+ini.ReadString('configs','fotos','')
     else} caminho:=ini.ReadString('configs','fotos','');
  btMostrar.Caption:='Mostrar a Foto';
  dm.Grupos.Open;
  dm.Marcas.Open;
  dm.Modelos.Open;
  dm.Unidades.Open;
  dm.Fornecedores.Open;
  tabela:=dm.Produtos;
  inherited;
  dm.dsProdutos.OnDataChange:=@dsDataChange; //em freepascal é necessário o @
  dsDataChange(nil,nil);
  DecodeDate(date,ano,mes,dia);
  uDia:=UltimoDiaDoMes(mes,ano);
  dt1.Text:=FormatDateTime('dd/mm/yyyy',StrToDate('1/'+inttostr(mes)+'/'+inttostr(ano)));
  dt2.Text:=FormatDateTime('dd/mm/yyyy',StrToDate(uDia+'/'+inttostr(mes)+'/'+inttostr(ano)));
//  ComboBox1.ItemIndex:=0;
end;

procedure TCad_Produtos.frReport1EnterRect(Memo: TStringList; View: TfrView);
begin
    if (View.Name='Picture1') then begin
      if (dm.ProdutosFOTO.AsString <> '')and(fileexists(caminho+dm.ProdutosFOTO.AsString)) then begin
        (View as TfrPictureView).picture.loadfromfile(caminho+dm.ProdutosFOTO.AsString);
        (View as TfrPictureView).Stretched:=true;
      end else (View as TfrPictureView).picture.Clear;
    end;
end;

procedure TCad_Produtos.ftCarregarClick(Sender: TObject);
var reg: Int64;
begin
  if tabela.state=dsInsert then reg:=dm.sProdutos.GetCurrentValue+1;
  if tabela.State=dsEdit then reg:=tabela.FieldByName('id').Value;
  if ftDialogo.Execute then begin
     try
        imgFoto.Picture.LoadFromFile(ftDialogo.FileName);
        tabela.FieldByName('foto').AsString:='foto_produto_'+IntToStr(reg)+ExtractFileExt(ftDialogo.FileName);
        FlagFoto:=1;
     except
        mensagem('Arquivo de imagem inválido!');
     end;
  end;
end;

procedure TCad_Produtos.ftLimparClick(Sender: TObject);
begin
  if confirma('Esta ação não é cancelada pelo botão Cancelar!'+#13+
     'Tem certeza que quer excluir a foto?')<>6 then abort;
  try
     DeleteFile(caminho+tabela.FieldByName('foto').Value);
     imgFoto.Picture:=nil;
     tabela.FieldByName('foto').Value:=null;
     FlagFoto:=0;
     imgPadrao.Visible:=true;
  except
     mensagem('Não foi possível excluir a foto!');
  end;
end;

procedure TCad_Produtos.GridDadosTitleClick(Column: TColumn);
begin
  inherited;
end;

procedure TCad_Produtos.SpeedButton2Click(Sender: TObject);
begin
  Cad_Grupos := TCad_Grupos.Create(nil);
  Cad_Grupos.ShowModal;
  FreeAndNil(Cad_Grupos);
  dm.Grupos.Open;
end;

procedure TCad_Produtos.SpeedButton3Click(Sender: TObject);
begin
  Cad_Marcas:=TCad_Marcas.Create(nil);
  Cad_Marcas.ShowModal;
  FreeAndNil(Cad_Marcas);
  dm.Marcas.Open;
end;

procedure TCad_Produtos.SpeedButton4Click(Sender: TObject);
begin
  Cad_Modelos:=TCad_Modelos.Create(nil);
  Cad_Modelos.ShowModal;
  FreeAndNil(Cad_Modelos);
  dm.Modelos.Open;
end;

procedure TCad_Produtos.SpeedButton5Click(Sender: TObject);
begin
  Form_Cad_Unidades:=TForm_Cad_Unidades.Create(nil);
  Form_Cad_Unidades.ShowModal;
  FreeAndNil(Form_Cad_Unidades);
  dm.Unidades.Open;
end;

procedure TCad_Produtos.SpeedButton6Click(Sender: TObject);
begin
  Cad_Fornecedores:=TCad_Fornecedores.Create(nil);
  Cad_Fornecedores.ShowModal;
  FreeAndNil(Cad_Fornecedores);
  dm.Fornecedores.Open;
end;

procedure TCad_Produtos.SoLeitura(modo: boolean);
begin
  RxDBLookupCombo1.ReadOnly:=modo;
  RxDBLookupCombo2.ReadOnly:=modo;
  RxDBLookupCombo3.ReadOnly:=modo;
  RxDBLookupCombo4.ReadOnly:=modo;
  RxDBLookupCombo5.ReadOnly:=modo;
  DBEdit2.ReadOnly:=modo;
  DBEdit4.ReadOnly:=modo;
  DBEdit5.ReadOnly:=modo;
  DBEdit6.ReadOnly:=modo;
  DBEdit7.ReadOnly:=modo;
  DBEdit8.ReadOnly:=modo;
  DBEdit9.ReadOnly:=modo;
end;

procedure TCad_Produtos.dsDataChange(Sender: TObject; Field: TField);
begin
  if not (tabela.State in [dsInsert,dsEdit]) then begin
     if tabela.FieldByName('foto').AsString<>'' then begin
        //imgFoto.Picture.LoadFromFile(tabela.FieldByName('foto').Value)
        imgPadrao.Visible:=false;
        imgFoto.Visible:=false;
        btMostrar.Visible:=true;
     end else begin
        imgFoto.Picture:=nil;
        imgPadrao.Visible:=true;
        btMostrar.Visible:=false;
     end;
  end;
  lbMensagem1.Caption:='N.º DE REGISTROS: '+FormatFloat('00000',tabela.RecordCount);
end;

procedure TCad_Produtos.btNovoClick(Sender: TObject);
begin
  imgPadrao.Visible:=true;
  btMostrar.Visible:=false;
  if dm.Produtos.Filter<>'' then
     if confirma('Deseja limpar o(s) filtro(s) antes de criar um novo registro?')=6 then btLimpar.Click;
  inherited;
  SoLeitura(false);
  dm.ProdutosDATA_CAD.Value:=date;
  dm.ProdutosESTOQUE_ATUAL.Value:=0.00;
  dm.ProdutosESTOQUE_MIN.Value:=0.00;
  dm.ProdutosPRECO_COMP.Value:=0.00;
  dm.ProdutosPRECO_VEND.Value:=0.00;
  imgFoto.Picture:=nil;
  ftCarregar.Enabled:=true;
  ftLimpar.Enabled:=true;
  DBEdit4.SetFocus;
end;

procedure TCad_Produtos.btSalvarClick(Sender: TObject);
var
  reg: Int64;
begin
  if trim(DBEdit6.Text)='' then begin
     mensagem('Preencha a Descrição!');
     abort;
  end;
  reg:=0;
  if tabela.State=dsInsert then reg:=dm.sProdutos.GetCurrentValue+1;
//  if tabela.State=dsEdit then reg:=tabela.FieldByName('ID').Value;
  inherited;
  if reg<>0 then dm.Produtos.Locate('id',inttostr(reg),[]);
  if (tabela.FieldByName('foto').Value<>null) then
     if not FileExists(caminho+tabela.FieldByName('foto').AsString) or (FlagFoto=1) then
        CopyFile(ftDialogo.FileName,caminho+tabela.FieldByName('foto').Value);
  FlagFoto:=0;
  dsDataChange(nil,nil);
  ftCarregar.Enabled:=false;
  ftLimpar.Enabled:=false;
  SoLeitura(true);
end;

procedure TCad_Produtos.ComboBox1Change(Sender: TObject);
begin
  sCom:=ComboBox1.Text;
  if sCom='Descrição' then sCom:='DESCRICAO';
  if sCom='Estoque Mínimo' then sCom:='ESTOQUE_MIN';
  if sCom='Estoque Atual' then sCom:='ESTOQUE_ATUAL';
  if sCom='Preço de Compra' then sCom:='PRECO_COMP';
  if sCom='Preço de Venda' then sCom:='PRECO_VEND';
  dm.sql.Close;
  if sCom='Grupo' then dm.SQL.SQL.Text:='SELECT DISTINCT GRUPO FROM GRUPOS' else
  if sCom='Marca' then dm.SQL.SQL.Text:='SELECT DISTINCT MARCA FROM MARCAS' else
  if sCom='Modelo' then dm.SQL.SQL.Text:='SELECT DISTINCT MODELO FROM MODELOS' else
  if sCom='Unidade' then dm.SQL.SQL.Text:='SELECT DISTINCT UNIDADE FROM UNIDADES' else
  if sCom='Fornecedor' then dm.SQL.SQL.Text:='SELECT DISTINCT NOME "Fornecedor" FROM FORNECEDORES' else
     dm.SQL.SQL.Text:='SELECT DISTINCT '+sCom+' FROM PRODUTOS';
  dm.SQL.Open;
  dm.sql.First;
  ComboBox2.Clear;
  while not dm.sql.EOF do begin
    ComboBox2.Items.Add(dm.SQL.FieldByName(sCom).AsString);
    dm.sql.next;
  end;
  dm.sql.Close;
  if sCom='Grupo' then sCom:='GRUPO_1';
  if sCom='Marca' then sCom:='MARCA_1';
  if sCom='Modelo' then sCom:='MODELO_1';
  if sCom='Unidade' then sCom:='UNIDADE_1';
  if sCom='Fornecedor' then sCom:='NOME';
end;

procedure TCad_Produtos.ComboBox3Change(Sender: TObject);
var sVal, sCom2: string;
begin
  if dm.Produtos.Filter<>'' then
     if confirma('Deseja limpar o(s) filtro(s) antes de localizar?')=6 then btLimpar.Click;
  sCom2:=ComboBox3.Text;
  if sCom2='Referência' then sCom2:='REFERENCIA';
  if sCom2='Código de Barras' then sCom2:='COD_BARRA';
  if sCom2='Descrição' then sCom2:='DESCRICAO';
  if sCom2='Código' then sCom2:='ID';
  sVal:='';
  InputQueryJW('Localizar','Digite o(a) '+ComboBox3.Text+':',sVal,false);
  dm.Produtos.Locate(sCom2,sVal,[loPartialKey,loCaseInsensitive]);
  ComboBox3.ItemIndex:=-1;
end;

procedure TCad_Produtos.DBEdit2Exit(Sender: TObject);
begin
  if tabela.State in [dsInsert,dsEdit] then begin
    try
      if trim(TDBEdit(Sender).Text)<>'' then StrToFloat(TDBEdit(Sender).Text) else TDBEdit(Sender).Text:='0,00';
    except
      mensagem('O valor digitado não é válido!');
      abort;
    end;
  end;
end;

procedure TCad_Produtos.DBEdit7Enter(Sender: TObject);
var
  i: Integer;
  texto: string;
begin
  if tabela.State in [dsInsert,dsEdit] then begin
    for i:=1  to Length(TDBEdit(Sender).Text) do begin
        if ((Copy(TDBEdit(Sender).Text,i,1)>='0')and(Copy(TDBEdit(Sender).Text,i,1)<='9'))or(Copy(TDBEdit(Sender).Text,i,1)=',') then begin
           texto:=texto+Copy(TDBEdit(Sender).Text,i,1);
        end;
    end;
    if texto='0,00' then TDBEdit(Sender).Text:='' else TDBEdit(Sender).Text:=texto;
  end;
end;

procedure TCad_Produtos.DBEdit8Enter(Sender: TObject);
begin
  if tabela.State in [dsInsert,dsEdit] then
     if TDBEdit(Sender).Text='0,00' then TDBEdit(Sender).Text:='';
end;

procedure TCad_Produtos.DBMemo1Change(Sender: TObject);
begin
  if TDBMemo(sender).DataSource<>nil then
  if not (TDBMemo(sender).DataSource.DataSet.State in [dsEdit,dsInsert]) then
  if TDBMemo(sender).Field<>nil then
     TDBMemo(sender).Text:=TDBMemo(sender).DataSource.DataSet.FieldByName(TDBMemo(sender).Field.FieldName).AsString;
end;

procedure TCad_Produtos.DBMemo1Enter(Sender: TObject);
begin
  if (tabela.State in [dsInsert,dsEdit]) then KeyPreview:=false;
end;

procedure TCad_Produtos.DBMemo1Exit(Sender: TObject);
begin
  KeyPreview:=true;
end;

procedure TCad_Produtos.dt1Enter(Sender: TObject);
begin
  KeyPreview:=false;
end;

procedure TCad_Produtos.dt1Exit(Sender: TObject);
begin
  KeyPreview:=true;
end;

procedure TCad_Produtos.dt1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key in [VK_TAB,VK_RETURN] then dt2.SetFocus;
end;

procedure TCad_Produtos.dt1KeyPress(Sender: TObject; var Key: char);
begin
  if ((key<'0') or (key>'9')) or (Length(TRxDateEdit(Sender).Text)=10) then if key<>#8 then key:=#0;
end;

procedure TCad_Produtos.dt1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MascaraDataRx(TRxDateEdit(Sender),key);
end;

procedure TCad_Produtos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  inherited;
  dm.Grupos.Close;
  dm.Marcas.Close;
  dm.Modelos.Close;
  dm.Unidades.Close;
  dm.Fornecedores.Close;
  dm.Produtos.close;
  dm.dsProdutos.OnDataChange:=nil;
end;

procedure TCad_Produtos.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
end;

procedure TCad_Produtos.btEditarClick(Sender: TObject);
var reg: int64;
begin
  reg:=dm.ProdutosID.Value;
  if dm.Produtos.Filter<>'' then begin
     if confirma('Deseja limpar o(s) filtro(s) antes de editar?')=6 then begin
     btLimpar.Click;
     dm.Produtos.Locate('ID',IntToStr(reg),[]);
     end;
  end;
  inherited;
  if tabela.FieldByName('foto').Value<>null then begin
     if not FileExists(caminho+tabela.FieldByName('foto').AsString) then begin
        tabela.FieldByName('foto').Value:=null;
        mensagem('AVISO: A foto deste produto foi excluida!');
     end;
  end;
  ftCarregar.Enabled:=true;
  ftLimpar.Enabled:=true;
  if tabela.FieldByName('data_cad').Value=null then tabela.FieldByName('data_cad').Value:=date;
  if imgPadrao.Visible=false then btMostrar.Click;
  SoLeitura(false);
end;

procedure TCad_Produtos.btExcluirClick(Sender: TObject);
var arqFoto: String;
begin
  arqFoto:=tabela.FieldByName('foto').AsString;
  inherited;
  try
     DeleteFile(caminho+arqFoto);
  except
     mensagem('Não foi possível excluir a foto!');
  end;
end;

procedure TCad_Produtos.btFiltrarClick(Sender: TObject);
var fTexto: string;
begin
  if chk2.Checked then begin
     if ComboBox1.Text='' then begin
        mensagem('Você precisa escolher um campo!');
        abort;
     end;
  end;
  dm.Produtos.Close;
  dm.Produtos.Filter:='';
  if chk1.Checked then begin
     fTexto:='((DATA_CAD>='+#39+FormatDateTime('yyyy/mm/dd',dt1.Date)+
     #39+') AND (DATA_CAD<='+#39+FormatDateTime('yyyy/mm/dd',dt2.Date)+#39+'))';
  end;
  if chk2.Checked then begin
     if chk1.Checked then fTexto:=fTexto+' AND ';
     fTexto:=fTexto+'('+sCom+'='+#39+ComboBox2.Text+#39+')';
     if ComboBox2.Text='' then fTexto:=fTexto+' OR ('+sCom+' IS NULL)';
  end;
  dm.Produtos.Filter:=fTexto;
  dm.Produtos.Open;
end;

procedure TCad_Produtos.btLimparClick(Sender: TObject);
begin
  chk1.Checked:=false;
  chk2.Checked:=false;
  ComboBox1.ItemIndex:=0;
  ComboBox2.ItemIndex:=-1;
  ComboBox2.Clear;
  btFiltrar.Click;
end;

procedure TCad_Produtos.btMostrarClick(Sender: TObject);
begin
  try
    imgFoto.Picture.LoadFromFile(caminho+tabela.FieldByName('foto').Value);
    imgFoto.Visible:=true;
    btMostrar.Visible:=false;
  except
    mensagem('Não foi possível carregar a foto');
  end;
end;

procedure TCad_Produtos.btCancelarClick(Sender: TObject);
begin
  inherited;
  if tabela.FieldByName('foto').Value<>null then begin
     if not FileExists(caminho+tabela.FieldByName('foto').AsString) then begin
        tabela.Edit;
        tabela.FieldByName('foto').Value:=null;
        tabela.Post;
     end else imgFoto.Picture.LoadFromFile(caminho+tabela.FieldByName('foto').AsString);
  end;
  ftCarregar.Enabled:=false;
  ftLimpar.Enabled:=false;
  FlagFoto:=0;
  SoLeitura(true);
end;

initialization
  {$I unit_cad_produtos.lrs}

end.

