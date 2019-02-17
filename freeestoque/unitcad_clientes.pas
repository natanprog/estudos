{******************************************************************************}
{ Projeto: FreeEstoque                                                         }
{  Sistema multiplataforma para controle de estoque, controle de vendas e      }
{  financeiro                                                                  }
{                                                                              }
{ Direitos Autorais Reservados (c) 2009 Jean Patrick F. dos Santos             }
{                                                                              }
{ Este arquivo é parte do programa FreeEstoque                                 }
{                                                                              }
{  Você pode obter a última versão desse arquivo na pagina do  Projeto         }
{ FreeEstoque localizado em http://www.jpsoft.com.br                           }
{                                                                              }
{  FreeEstoque é um software livre; você pode redistribui-lo e/ou              }
{ modifica-lo dentro dos termos da Licença Pública Geral GNU como              }
{ publicada pela Fundação do Software Livre (FSF); na versão 3 da              }
{ Licença, ou (na sua opnião) qualquer versão.                                 }
{                                                                              }
{  Este programa é distribuido na esperança que possa ser util,                }
{ mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUAÇÂO            }
{ a qualquer MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a Licença Pública        }
{ Geral GNU para maiores detalhes.                                             }
{                                                                              }
{  Você deve ter recebido uma cópia da Licença Pública Geral GNU               }
{ junto com este programa, se não, escreva para a Fundação do Software         }
{ Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA    }
{                                                                              }
{ Jean Patrick F. dos Santos - jpsoft-sac-pa@hotmail.com - www.jpsoft.com.br   }
{                                                                              }
{******************************************************************************}

unit unitcad_clientes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, DbCtrls, DBGrids, Buttons, StdCtrls, EditBtn, ExtDlgs,
  Modelo_Cad, UnitDados, Unit_rotinas, tooledit, Unit_Modelo_Form_Rel,
  ACBrValidador, LCLType, Grids, LR_Class, LR_DBSet, LR_E_HTM, LR_E_CSV,
  LR_RRect, LR_Shape, lr_e_pdf, IniFiles;

type

  { TCad_Clientes }

  TCad_Clientes = class(TModelo_Cadastro)
    ACBrValidador1: TACBrValidador;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    btFiltrar: TButton;
    btLimpar: TButton;
    btMostrar: TButton;
    chk1: TCheckBox;
    chk2: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBMemo1: TDBMemo;
    DBRadioGroup1: TDBRadioGroup;
    ftLimpar: TButton;
    ftCarregar: TButton;
    DBComboBox1: TDBComboBox;
    DBComboBox2: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    GroupBox1: TGroupBox;
    imgFoto: TImage;
    imgPadrao: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ftDialogo: TOpenPictureDialog;
    Label9: TLabel;
    dt1: TRxDateEdit;
    dt2: TRxDateEdit;
    procedure btCancelarClick(Sender: TObject);
    procedure btEditarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btFiltrarClick(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure btLimparClick(Sender: TObject);
    procedure btMostrarClick(Sender: TObject);
    procedure btNovoClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure DBEdit10KeyPress(Sender: TObject; var Key: char);
    procedure DBEdit10KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBEdit11KeyPress(Sender: TObject; var Key: char);
    procedure DBEdit12KeyPress(Sender: TObject; var Key: char);
    procedure DBEdit12KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBEdit13KeyPress(Sender: TObject; var Key: char);
    procedure DBEdit14KeyPress(Sender: TObject; var Key: char);
    procedure DBEdit14KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBEdit8KeyPress(Sender: TObject; var Key: char);
    procedure DBEdit8KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBEdit9KeyPress(Sender: TObject; var Key: char);
    procedure DBMemo1Change(Sender: TObject);
    procedure DBMemo1Enter(Sender: TObject);
    procedure DBMemo1Exit(Sender: TObject);
    procedure dt1Enter(Sender: TObject);
    procedure dt1Exit(Sender: TObject);
    procedure dt1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure frReport1EnterRect(Memo: TStringList; View: TfrView);
    procedure ftCarregarClick(Sender: TObject);
    procedure ftLimparClick(Sender: TObject);
    procedure GridDadosTitleClick(Column: TColumn);
    procedure RxDateEdit1KeyPress(Sender: TObject; var Key: char);
    procedure RxDateEdit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure SoLeitura(modo: boolean);
    procedure dsDataChange(Sender: TObject; Field: TField);
    FlagFoto: byte;
    caminho: string;
    { private declarations }
  public
    { public declarations }
  end; 

var
  Cad_Clientes: TCad_Clientes;

implementation

{ TCad_Clientes }

procedure TCad_Clientes.FormShow(Sender: TObject);
var dia,mes,ano: word;
uDia: string;
ini: TIniFile;
begin
  ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  {if ini.ReadString('configs','uso','')='Cliente' then caminho:=ini.ReadString('configs','servidor','')+':'+ini.ReadString('configs','fotos','')
     else} caminho:=ini.ReadString('configs','fotos','');
  btMostrar.Caption:='Mostrar a Foto';
  tabela:=dm.Clientes;
  inherited;
  dm.dsClientes.OnDataChange:=@dsDataChange; //em freepascal é necessário o @
  dsDataChange(nil,nil);
  DecodeDate(date,ano,mes,dia);
  uDia:=UltimoDiaDoMes(mes,ano);
  dt1.Text:=FormatDateTime('dd/mm/yyyy',StrToDate('1/'+inttostr(mes)+'/'+inttostr(ano)));
  dt2.Text:=FormatDateTime('dd/mm/yyyy',StrToDate(uDia+'/'+inttostr(mes)+'/'+inttostr(ano)));
//  ComboBox1.ItemIndex:=0;
end;

procedure TCad_Clientes.frReport1EnterRect(Memo: TStringList; View: TfrView);
begin
    if (View.Name='Picture1') then begin
      if (dm.ClientesFOTO.AsString <> '')and(fileexists(caminho+dm.ClientesFOTO.AsString)) then begin
        (View as TfrPictureView).picture.loadfromfile(caminho+dm.ClientesFOTO.AsString);
        (View as TfrPictureView).Stretched:=true;
      end else (View as TfrPictureView).picture.Clear;
    end;
end;

procedure TCad_Clientes.ftCarregarClick(Sender: TObject);
var reg: Int64;
begin
  if tabela.state=dsInsert then reg:=dm.sClientes.GetCurrentValue+1;
  if tabela.State=dsEdit then reg:=tabela.FieldByName('id').Value;
  if ftDialogo.Execute then begin
     try
        imgFoto.Picture.LoadFromFile(ftDialogo.FileName);
        tabela.FieldByName('foto').AsString:='foto_cliente_'+IntToStr(reg)+ExtractFileExt(ftDialogo.FileName);
        FlagFoto:=1;
     except
        mensagem('Arquivo de imagem inválido!');
     end;
  end;
end;

procedure TCad_Clientes.ftLimparClick(Sender: TObject);
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

procedure TCad_Clientes.GridDadosTitleClick(Column: TColumn);
begin
  inherited;
end;

procedure TCad_Clientes.RxDateEdit1KeyPress(Sender: TObject; var Key: char);
begin
  if ((key<'0') or (key>'9')) or (Length(TRxDateEdit(Sender).Text)=10) then if key<>#8 then key:=#0;
end;

procedure TCad_Clientes.RxDateEdit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MascaraDataRx(TRxDateEdit(Sender),key);
end;

procedure TCad_Clientes.SoLeitura(modo: boolean);
begin
DBEdit1.ReadOnly:=modo;
DBEdit5.ReadOnly:=modo;
DBEdit7.ReadOnly:=modo;
DBEdit6.ReadOnly:=modo;
DBEdit3.ReadOnly:=modo;
DBEdit8.ReadOnly:=modo;
DBEdit9.ReadOnly:=modo;
DBEdit10.ReadOnly:=modo;
DBEdit11.ReadOnly:=modo;
DBEdit12.ReadOnly:=modo;
DBEdit13.ReadOnly:=modo;
DBEdit14.ReadOnly:=modo;
DBEdit15.ReadOnly:=modo;
DBEdit16.ReadOnly:=modo;
DBEdit17.ReadOnly:=modo;
DBEdit18.ReadOnly:=modo;
DBEdit19.ReadOnly:=modo;
DBEdit20.ReadOnly:=modo;
DBEdit21.ReadOnly:=modo;
DBEdit22.ReadOnly:=modo;
DBEdit23.ReadOnly:=modo;
end;

procedure TCad_Clientes.dsDataChange(Sender: TObject; Field: TField);
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

procedure TCad_Clientes.btEditarClick(Sender: TObject);
var reg: int64;
begin
  reg:=dm.ClientesID.Value;
  if dm.Clientes.Filter<>'' then begin
     if confirma('Deseja limpar o(s) filtro(s) antes de editar?')=6 then begin
     btLimpar.Click;
     dm.Clientes.Locate('ID',IntToStr(reg),[]);
     end;
  end;
  inherited;
  if tabela.FieldByName('foto').Value<>null then begin
     if not FileExists(caminho+tabela.FieldByName('foto').AsString) then begin
        tabela.FieldByName('foto').Value:=null;
        mensagem('AVISO: A foto deste cliente foi excluida!');
     end;
  end;
  ftCarregar.Enabled:=true;
  ftLimpar.Enabled:=true;
  if imgPadrao.Visible=false then btMostrar.Click;
  SoLeitura(false);
end;

procedure TCad_Clientes.btExcluirClick(Sender: TObject);
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

procedure TCad_Clientes.btFiltrarClick(Sender: TObject);
var fTexto: string;
begin
  if chk2.Checked then begin
     if ComboBox1.Text='' then begin
        mensagem('Você precisa escolher um campo!');
        abort;
     end;
  end;
  dm.Clientes.Close;
  dm.Clientes.Filter:='';
  if chk1.Checked then begin
     fTexto:='((DATA_CAD>='+#39+FormatDateTime('yyyy/mm/dd',dt1.Date)+
     #39+') AND (DATA_CAD<='+#39+FormatDateTime('yyyy/mm/dd',dt2.Date)+#39+'))';
  end;
  if chk2.Checked then begin
     if chk1.Checked then fTexto:=fTexto+' AND ';
     fTexto:=fTexto+'('+ComboBox1.Text+'='+#39+ComboBox2.Text+#39+')';
     if ComboBox2.Text='' then fTexto:=fTexto+' OR ('+ComboBox1.Text+' IS NULL)';
  end;
  dm.Clientes.Filter:=fTexto;
  dm.Clientes.Open;
end;

procedure TCad_Clientes.btImprimirClick(Sender: TObject);
begin
  {Rel_Clientes:=TRel_Clientes.Create(self);
     Rel_Clientes.ShowModal;
     if Rel_Clientes.ModalResult=11 then mensagem('Visualizar');
     if Rel_Clientes.ModalResult=12 then mensagem('Imprimir');
     FreeAndNil(Rel_Clientes);
     abort;}
  dm.Empresa.Open;
  frReport1.LoadFromFile(ExtractFilePath(Application.ExeName)+'relatorios'+
  PathDelim+'RelClientes1.lrf');
  frReport1.ShowReport;
  dm.Empresa.Close;
end;

procedure TCad_Clientes.btLimparClick(Sender: TObject);
begin
  chk1.Checked:=false;
  chk2.Checked:=false;
  ComboBox1.ItemIndex:=-1;
  ComboBox2.ItemIndex:=-1;
  ComboBox2.Clear;
  btFiltrar.Click;
end;

procedure TCad_Clientes.btMostrarClick(Sender: TObject);
begin
  try
    imgFoto.Picture.LoadFromFile(caminho+tabela.FieldByName('foto').Value);
    imgFoto.Visible:=true;
    btMostrar.Visible:=false;
  except
    mensagem('Não foi possível carregar a foto');
  end;
end;

procedure TCad_Clientes.btNovoClick(Sender: TObject);
begin
  imgPadrao.Visible:=true;
  btMostrar.Visible:=false;
  if dm.Clientes.Filter<>'' then
     if confirma('Deseja limpar o(s) filtro(s) antes de criar um novo registro?')=6 then btLimpar.Click;
  inherited;
  SoLeitura(false);
  tabela.FieldByName('data_cad').Value:=date;
  tabela.FieldByName('ativo').Value:='Sim';
  imgFoto.Picture:=nil;
  ftCarregar.Enabled:=true;
  ftLimpar.Enabled:=true;
  DBEdit1.SetFocus;
end;

procedure TCad_Clientes.btCancelarClick(Sender: TObject);
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

procedure TCad_Clientes.btSalvarClick(Sender: TObject);
var reg: int64;
begin
  if DBComboBox2.Text='' then begin
     mensagem('Escolha o Estado!');
     abort;
  end;
  if trim(DBEdit1.Text)='' then begin
     mensagem('Preencha o Nome/Fantasia!');
     abort;
  end;
  if trim(DBEdit10.Text)<>'' then begin
     ACBrValidador1.TipoDocto:=docCNPJ;
     ACBrValidador1.Documento:=DBEdit10.Text;
     if ACBrValidador1.Validar=false then begin
        mensagem('O CNPJ digitado não é válido!');
        abort;
     end;
  end;
  if trim(DBEdit12.Text)<>'' then begin
     ACBrValidador1.TipoDocto:=docCPF;
     ACBrValidador1.Documento:=DBEdit12.Text;
     if ACBrValidador1.Validar=false then begin
        mensagem('O CPF digitado não é válido!');
        abort;
     end;
  end;
  if trim(DBEdit11.Text)<>'' then begin
     ACBrValidador1.TipoDocto:=docInscEst;
     ACBrValidador1.Complemento:=DBComboBox2.Text;
     ACBrValidador1.Documento:=DBEdit11.Text;
     if ACBrValidador1.Validar=false then begin
        mensagem('A Inscrição Estadual digitada não é válida!');
        abort;
     end;
  end;
  if trim(DBEdit8.Text)<>'' then begin
     ACBrValidador1.TipoDocto:=docCEP;
     ACBrValidador1.Complemento:=DBComboBox2.Text;
     ACBrValidador1.Documento:=DBEdit8.Text;
     if ACBrValidador1.Validar=false then begin
        mensagem('O CEP digitado não é válido!');
        abort;
     end;
  end;
  reg:=0;
  if tabela.State=dsInsert then reg:=dm.sClientes.GetCurrentValue+1;
  inherited;
  if reg<>0 then dm.Clientes.Locate('id',inttostr(reg),[]);
  if (tabela.FieldByName('foto').Value<>null) then
     if not FileExists(caminho+tabela.FieldByName('foto').AsString) or (FlagFoto=1) then
        CopyFile(ftDialogo.FileName,caminho+tabela.FieldByName('foto').Value);
  FlagFoto:=0;
  dsDataChange(nil,nil);
  ftCarregar.Enabled:=false;
  ftLimpar.Enabled:=false;
  SoLeitura(true);
end;

procedure TCad_Clientes.ComboBox1Change(Sender: TObject);
begin
  dm.sql.Close;
  dm.SQL.SQL.Text:='SELECT DISTINCT '+ComboBox1.Text+' FROM CLIENTES';
  dm.SQL.Open;
  dm.sql.First;
  ComboBox2.Clear;
  while not dm.sql.EOF do begin
    ComboBox2.Items.Add(dm.SQL.FieldByName(ComboBox1.Text).AsString);
    dm.sql.next;
  end;
  dm.sql.Close;
end;

procedure TCad_Clientes.ComboBox3Change(Sender: TObject);
var sVal, sCom: string;
begin
  if dm.Clientes.Filter<>'' then
     if confirma('Deseja limpar o(s) filtro(s) antes de localizar?')=6 then btLimpar.Click;
  sCom:=ComboBox3.Text;
  if sCom='Razão Social' then sCom:='RAZAO';
  if sCom='Fone 1' then sCom:='FONE1';
  if sCom='Fone 2' then sCom:='FONE2';
  if sCom='Fax 1' then sCom:='FAX1';
  if sCom='Fax 2' then sCom:='FAX2';
  if sCom='Celular 1' then sCom:='CEL1';
  if sCom='Celular 2' then sCom:='CEL2';
  if sCom='Email 1' then sCom:='EMAIL1';
  if sCom='Email 2' then sCom:='EMAIL2';
  if sCom='Web Site' then sCom:='SITE';
  if sCom='Caixa Postal' then sCom:='CAIXA_POSTAL';
  sVal:='';
  InputQueryJW('Localizar','Digite o(a) '+ComboBox3.Text+':',sVal,false);
  dm.Clientes.Locate(sCom,sVal,[loPartialKey,loCaseInsensitive]);
  ComboBox3.ItemIndex:=-1;
end;

procedure TCad_Clientes.DBEdit10KeyPress(Sender: TObject; var Key: char);
begin
if ((key<'0') or (key>'9')) or (Length(TDBEdit(Sender).Text)=18) then if key<>#8 then key:=#0;
end;

procedure TCad_Clientes.DBEdit10KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Mascara(TDBEdit(Sender),'cnpj',key);
end;

procedure TCad_Clientes.DBEdit11KeyPress(Sender: TObject; var Key: char);
begin
if not(key in ['0'..'9','.','-','/',#8,#13,#19,#4,#36,#35]) then key := #0;
if key = '-' then if pos(key,TEdit(Sender).Text) <> 0 then key := #0;
if key = '/' then if pos(key,TEdit(Sender).Text) <> 0 then key := #0;
end;

procedure TCad_Clientes.DBEdit12KeyPress(Sender: TObject; var Key: char);
begin
if ((key<'0') or (key>'9')) or (Length(TDBEdit(Sender).Text)=14) then if key<>#8 then key:=#0;
end;

procedure TCad_Clientes.DBEdit12KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Mascara(TDBEdit(Sender),'cpf',key);
end;

procedure TCad_Clientes.DBEdit13KeyPress(Sender: TObject; var Key: char);
begin
if not(key in ['0'..'9',#8,#13,#19,#4,#36,#35]) then key := #0;
end;

procedure TCad_Clientes.DBEdit14KeyPress(Sender: TObject; var Key: char);
begin
if ((key<'0') or (key>'9')) or (Length(TDBEdit(Sender).Text)=13) then if key<>#8 then key:=#0;
end;

procedure TCad_Clientes.DBEdit14KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Mascara(TDBEdit(Sender),'fone',key);
end;

procedure TCad_Clientes.DBEdit8KeyPress(Sender: TObject; var Key: char);
begin
  if ((key<'0') or (key>'9')) or (Length(TDBEdit(Sender).Text)=10) then if key<>#8 then key:=#0;
end;

procedure TCad_Clientes.DBEdit8KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  Mascara(TDBEdit(Sender),'cep',key);
end;

procedure TCad_Clientes.DBEdit9KeyPress(Sender: TObject; var Key: char);
begin
if not(key in ['0'..'9',#8,#13,#19,#4,#36,#35]) then key := #0;
end;

procedure TCad_Clientes.DBMemo1Change(Sender: TObject);
begin
if TDBMemo(sender).DataSource<>nil then
if not (TDBMemo(sender).DataSource.DataSet.State in [dsEdit,dsInsert]) then
if TDBMemo(sender).Field<>nil then
TDBMemo(sender).Text:=TDBMemo(sender).DataSource.DataSet.FieldByName(TDBMemo(sender).Field.FieldName).AsString;
end;

procedure TCad_Clientes.DBMemo1Enter(Sender: TObject);
begin
  if (tabela.State in [dsInsert,dsEdit]) then KeyPreview:=false;
end;

procedure TCad_Clientes.DBMemo1Exit(Sender: TObject);
begin
  KeyPreview:=true;
end;

procedure TCad_Clientes.dt1Enter(Sender: TObject);
begin
  KeyPreview:=false;
end;

procedure TCad_Clientes.dt1Exit(Sender: TObject);
begin
  KeyPreview:=true;
end;

procedure TCad_Clientes.dt1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key in [VK_TAB,VK_RETURN] then dt2.SetFocus;
end;

procedure TCad_Clientes.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  inherited;
  dm.dsClientes.OnDataChange:=nil;
end;

procedure TCad_Clientes.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
end;

initialization
  {$I unitcad_clientes.lrs}

end.

