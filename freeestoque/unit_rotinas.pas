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
{ mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUAÇÃO            }
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

unit Unit_rotinas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, LMessages, IniFiles, ExtCtrls, StdCtrls, db,
  ComCtrls, DBCtrls, Graphics, Controls, ZDataset, Dialogs, variants, LCLIntf,
  LCLType, types, dbdateedit, tooledit;

  procedure mensagem(const strmensagem: string);
  function confirma(const strtexto: string): integer;
  procedure comandoSQL (const comSQL: string);
  function gerador (tb: TZQuery; cp: string): Variant;
  procedure editDireita (var ed: TEdit);
  function GetAveCharSize(Canvas: TCanvas): TPoint;
  function InputQueryJW(const ACaption, APrompt: string; var Value: string;Senha: Boolean): Boolean;
  function InputBoxJW(const ACaption, APrompt, ADefault: string; Senha: Boolean): string;
  function UltimoDiaDoMes(Mes: integer; Ano: integer): string;
  procedure LabEditDireita (var ed: TLabeledEdit);
  procedure Mascara(var oEdit: TDBEdit; Tipo: string; tecla: word);
  procedure MascaraDataRX(var oDtEdit: TRxDateEdit; tecla: word);

implementation

procedure Mascara(var oEdit: TDBEdit; Tipo: string; tecla: word);
var
  i,p: Integer;
  texto,texto2: string;
begin
  // Autor: Jean Patrick F. dos Santos - www.jpsoft.com.br
  // para usar esta rotina, no evento onKeyPress do DBEdit coloque por ex.:
  // if ((key<'0') or (key>'9')) or (Length(TDBEdit(Sender).Text)=13) then if key<>#8 then key:=#0;
  // 13 neste exemplo para fone (##)####-####, é o máximo de caractere (só necessário para
  // o Lazarus, se o campo da tabela for maior que a mascara).
  // Se for usar no Delphi fica assim: if ((key<'0') or (key>'9')) then key:=#0;
  // No evento onKeyUp coloque, também:
  // Mascara(TDBEdit(Sender),'fone',key);
  if tecla in [VK_HOME,VK_LEFT,VK_RIGHT,VK_RETURN,VK_END] then abort;
  p:=oEdit.SelStart;
  texto:='';
  for i:=1  to Length(oEdit.Text) do begin
      if ((Copy(oEdit.Text,i,1)>='0')and(Copy(oEdit.Text,i,1)<='9')) then begin
         texto:=texto+Copy(oEdit.Text,i,1);
      end;
  end;
  texto2:='';
  if LowerCase(tipo)='cnpj' then begin
     for i:=1 to Length(texto) do begin
         texto2:=texto2+Copy(texto,i,1);
         if (i=2)and(Length(texto)>2) then texto2:=texto2+'.';
         if (i=5)and(Length(texto)>5) then texto2:=texto2+'.';
         if (i=8)and(Length(texto)>8) then texto2:=texto2+'/';
         if (i=12)and(Length(texto)>12) then texto2:=texto2+'-';
         if (i=14) then break;
     end;
  end;
  if LowerCase(tipo)='cpf' then begin
     for i:=1 to Length(texto) do begin
         texto2:=texto2+Copy(texto,i,1);
         if (i=3)and(Length(texto)>3) then texto2:=texto2+'.';
         if (i=6)and(Length(texto)>6) then texto2:=texto2+'.';
         if (i=9)and(Length(texto)>9) then texto2:=texto2+'-';
         if (i=11) then break;
     end;
  end;
  if LowerCase(tipo)='fone' then begin
     for i:=1 to Length(texto) do begin
         texto2:=texto2+Copy(texto,i,1);
         if (i=2)and(Length(texto)>2) then texto2:='('+texto2+')';
         if (i=6)and(Length(texto)>6) then texto2:=texto2+'-';
         if (i=10) then break;
     end;
  end;
  if LowerCase(tipo)='cep' then begin
     for i:=1 to Length(texto) do begin
         texto2:=texto2+Copy(texto,i,1);
         if (i=2)and(Length(texto)>2) then texto2:=texto2+'.';
         if (i=5)and(Length(texto)>5) then texto2:=texto2+'-';
         if (i=8) then break;
     end;
  end;
  oEdit.Text:=texto2;
  if (p+2)<Length(texto2) then oEdit.SelStart:=p else oEdit.SelStart:=Length(texto2);
end;

function UltimoDiaDoMes(Mes: integer; Ano: integer): string;
var TextoDia: string;
// função encontrada na internet
begin
TextoDia:='%d';
TextoDia:=Format(TextoDia,[MonthDays[IsLeapYear(Ano), Mes]]);
Result:=TextoDia;
end;

function gerador (tb: TZQuery; cp: string): Variant;
begin
  // Autor: Jean Patrick F. dos Santos - www.jpsoft.com.br
tb.Filter:='';
tb.SortedFields:=cp;
tb.Last;
result := tb.FieldByName(cp).AsVariant + 1;
end;

procedure editDireita (var ed: TEdit);
begin
// procedure encontrada na internet
ed.Text := Format('%*.*s', [ed.width,
length(Trim(ed.text)), TRIM(ed.text)]);
ed.SelStart := length(ed.text)+1;
end;

procedure LabEditDireita (var ed: TLabeledEdit);
begin
// procedure adaptada com base na editDireita
ed.Text := Format('%*.*s', [ed.width,
length(Trim(ed.text)), TRIM(ed.text)]);
ed.SelStart := length(ed.text)+1;
end;

procedure mensagem(const strmensagem: string);
begin
  // Autor: Jean Patrick F. dos Santos - www.jpsoft.com.br
  application.MessageBox(pchar(strmensagem), 'Mensagem',MB_OK+MB_ICONINFORMATION);
end;

function confirma(const strtexto: string): integer;
begin
  // Autor: Jean Patrick F. dos Santos - www.jpsoft.com.br
  result := application.MessageBox(pchar(strtexto), 'Confirmação',MB_YESNO+MB_ICONQUESTION);
end;

procedure comandoSQL (const comSQL: string);
begin
// para fazer
end;

// ************ Função InputQueryJW   **************
function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
// Função encontrada no forum www.activedelphi.com.br postada por johnny-walker@hotmail.com
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function InputQueryJW(const ACaption, APrompt: string; var Value: string; Senha: Boolean): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
// Função encontrada no forum www.activedelphi.com.br postada por johnny-walker@hotmail.com
// Modificada por Jean Patrick, para usar o Edit para senha ou não
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      ClientHeight := MulDiv(63, DialogUnits.Y, 8);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        AutoSize := True;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Caption := APrompt;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := MulDiv(19, DialogUnits.Y, 8);
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        if Senha=true then begin
        {$IFDEF WIN32}
          PasswordChar:='|';
          Font.Name:='Wingdings';
        {$IFELSE}
          PasswordChar:='*';
        {$ENDIF}
        end;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := MulDiv(41, DialogUnits.Y, 8);
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'Ok';
        ModalResult := mrOk;  // Unit Controls
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'Cancelar';
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;
// ************** <Fim> Função InputQueryJW <Fim> ***********

function InputBoxJW(const ACaption, APrompt, ADefault: string; Senha: Boolean): string;
begin
// Função encontrada no forum www.activedelphi.com.br postada por johnny-walker@hotmail.com
// Modificada por Jean Patrick, para usar o Edit para senha ou não
Result := ADefault;
InputQueryJW(ACaption, APrompt, Result, Senha);
end;

procedure MascaraDataRX(var oDtEdit: TRxDateEdit; tecla: word);
var
  i,p: Integer;
  texto,texto2: string;
begin
  // Autor: Jean Patrick F. dos Santos - www.jpsoft.com.br
  // para usar esta rotina, no evento onKeyPress do TRxDateEdit coloque por ex.:
  // if ((key<'0') or (key>'9')) or (Length(TRxDateEdit(Sender).Text)=10) then if key<>#8 then key:=#0;
  // 10 neste exemplo para data (dd/mm/yyyy), é o máximo de caractere (só necessário para Lazarus ainda)
  // No evento onKeyUp coloque, também:
  // MascaraDataRx(TRxDateEdit(Sender),key);
  if tecla in [VK_HOME,VK_LEFT,VK_RIGHT,VK_RETURN,VK_END] then abort;
  p:=oDtEdit.SelStart;
  texto:='';
  for i:=1  to Length(oDtEdit.Text) do begin
      if ((Copy(oDtEdit.Text,i,1)>='0')and(Copy(oDtEdit.Text,i,1)<='9')) then begin
         texto:=texto+Copy(oDtEdit.Text,i,1);
      end;
  end;
  texto2:='';
     for i:=1 to Length(texto) do begin
         texto2:=texto2+Copy(texto,i,1);
         if (i=2)and(Length(texto)>2) then texto2:=texto2+'/';
         if (i=4)and(Length(texto)>4) then texto2:=texto2+'/';
         if (i=8) then break;
     end;
  oDtEdit.Text:=texto2;
  if (p+2)<Length(texto2) then oDtEdit.SelStart:=p else oDtEdit.SelStart:=Length(texto2);
  try
    if Length(oDtEdit.Text)>=8 then StrToDate(oDtEdit.Text);
  except
    mensagem('Data Inválida!');
    oDtEdit.Text:='';
  end;
end;

end.

