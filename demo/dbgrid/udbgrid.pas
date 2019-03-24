unit udbgrid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  DBGrids, ExtCtrls, Grids, ExtDlgs, DBCtrls, DateTimePicker;

type

  { TfrmDbgrid }

  TfrmDbgrid = class(TForm)
    bfCustomer: TBufDataset;
    bfCompany: TBufDataset;
    DateTimePicker1: TDateTimePicker;
    dsCustomer: TDataSource;
    DBGrid1: TDBGrid;
    ImageList1: TImageList;
    imgPicture: TImage;
    procedure DateTimePicker1Change(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1EditButtonClick(Sender: TObject);
    procedure DBGrid1PrepareCanvas(Sender: TObject; DataCol: integer;
      Column: TColumn; AState: TGridDrawState);
    procedure DBGrid1TitleClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure CriarCompany;
    procedure CriarCustomer;
    procedure CriarLookup;
    procedure SalvarPicture;

  public

  end;

var
  frmDbgrid: TfrmDbgrid;
  bufdb: TBufDataset;
  ms: TMemoryStream;

implementation

{$R *.lfm}

{ TfrmDbgrid }

// Cria o arquivo company.xml com a tabela e dados
procedure TfrmDbgrid.CriarCompany;
begin
  bufdb := TBufDataset.Create(nil);
  try
    bufdb.FieldDefs.Add('CCOMPANY_ID', ftAutoInc);
    bufdb.FieldDefs.Add('NAME', ftString, 20);
    bufdb.CreateDataset;
    bufdb.Open;
    bufdb.Append;
    bufdb.FieldByName('CCOMPANY_ID').Value := '1';
    bufdb.FieldByName('NAME').Value := 'Apple';
    bufdb.Post;
    bufdb.Append;
    bufdb.FieldByName('CCOMPANY_ID').Value := '2';
    bufdb.FieldByName('NAME').Value := 'Google';
    bufdb.Post;
    bufdb.Append;
    bufdb.FieldByName('CCOMPANY_ID').Value := '3';
    bufdb.FieldByName('NAME').Value := 'Microsoft';
    bufdb.Post;
    bufdb.Append;
    bufdb.FieldByName('CCOMPANY_ID').Value := '4';
    bufdb.FieldByName('NAME').Value := 'Facebook';
    bufdb.Post;
    bufdb.SaveToFile('company.xml');
  finally
    bufdb.Close;
    bufdb.Free;
  end;
end;

// Criar o arquivo customer.xml com a tabela e dados
procedure TfrmDbgrid.CriarCustomer;
begin
  bufdb := TBufDataset.Create(nil);
  try
    bufdb.FieldDefs.Add('CUSTOMER_ID', ftAutoInc);
    bufdb.FieldDefs.Add('NAME', ftString, 20);
    bufdb.FieldDefs.Add('GENDER', ftString, 1);
    bufdb.FieldDefs.Add('COMPANY_ID', ftInteger);
    bufdb.FieldDefs.Add('BIRTHDAY', ftDate);
    bufdb.FieldDefs.Add('BALANCE', ftCurrency);
    bufdb.FieldDefs.Add('PICTURE', ftBlob);
    bufdb.FieldDefs.Add('ENABLED', ftBoolean);
    bufdb.FieldDefs.Add('NOTE', ftBlob);
    bufdb.CreateDataset;
    bufdb.Open;
    bufdb.Append;
    bufdb.FieldByName('CUSTOMER_ID').Value := '1';
    bufdb.FieldByName('NAME').Value := 'GUINTHER';
    bufdb.FieldByName('GENDER').Value := 'M';
    bufdb.FieldByName('COMPANY_ID').Value := '1';
    bufdb.FieldByName('BIRTHDAY').Value := '29/04/1978';
    bufdb.FieldByName('BALANCE').Value := '100,00';
    SalvarPicture;
    bufdb.FieldByName('ENABLED').Value := '0';
    bufdb.FieldByName('NOTE').Value := 'Observação GUINTHER';
    bufdb.Post;
    bufdb.SaveToFile('customer.xml');
  finally
    bufdb.Close;
    bufdb.Free;
  end;
end;

// Salva a PICTURE no campo Blob
procedure TfrmDbgrid.SalvarPicture;
begin
  if (imgPicture.Picture.Width > 0) then
  begin
    ms := TMemoryStream.Create;
    imgPicture.Picture.SaveToStream(ms);
    ms.Position := 0;
    TBlobField(bufdb.FieldByName('PICTURE')).LoadFromStream(ms);
    ms.Free;
  end
  else
    bufdb.FieldByName('PICTURE').AsString := '';
end;

// Cria o Campo Lookup COMPANY_ID --> COMPANY_NAME
procedure TfrmDbgrid.CriarLookup;
var
  nome: string;
  //col: TColumn;
begin
  with TStringField.Create(bfCustomer) do
  begin
    FieldName := 'COMPANY_NAME';
    FieldKind := fkLookup;
    DataSet := bfCustomer;
    nome := DataSet.Name + FieldName;
    KeyFields := 'COMPANY_ID';
    LookupDataSet := bfCompany;
    LookupKeyFields := 'CCOMPANY_ID';
    LookupResultField := 'NAME';
    bfCustomer.FieldDefs.Add(nome, ftString, 20, False);
    //col := DBGrid1.Columns.Add;
    //col.FieldName := 'COMPANY_NAME';
    //col.Title.Caption := 'Company Name';
  end;
end;

procedure TfrmDbgrid.FormCreate(Sender: TObject);
begin
  {$IfDef LINUX}
  DefaultFormatSettings.DateSeparator := '/';
  DefaultFormatSettings.ShortDateFormat := 'dd/mm/yyyy';
  DefaultFormatSettings.DecimalSeparator := ',';
  DefaultFormatSettings.ThousandSeparator := '.';
  DefaultFormatSettings.CurrencyString := 'R$';
  DefaultFormatSettings.CurrencyFormat := 2;
  {$EndIf}
  if not FileExists(ExtractFilePath(Application.Location) + 'company.xml') then
    CriarCompany;
  if not FileExists(ExtractFilePath(Application.Location) + 'customer.xml') then
    CriarCustomer;
  bfCompany.FileName := ExtractFilePath(Application.Location) + 'company.xml';
  bfCompany.Active := True;
  bfCustomer.FileName := ExtractFilePath(Application.Location) + 'customer.xml';
  bfCustomer.Active := True;
  bfCustomer.Active := False;
  CriarLookup;
  bfCustomer.Active := True;
end;

procedure TfrmDbgrid.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if bfCustomer.Active = True then
    bfCustomer.Active := False;
end;

procedure TfrmDbgrid.DBGrid1PrepareCanvas(Sender: TObject; DataCol: integer;
  Column: TColumn; AState: TGridDrawState);
begin
  // DBGrid Zebrado --- Propriedades Color e AlternateColor
  //if not odd(bfCustomer.RecNo) then
  //if not (gdSelected in AState) then
  //DBGrid1.Canvas.Brush.Color := $00FFEF0F;
  // Destacar campo de acordo com o valor
  if Column.Field = bfCustomer.FieldByName('BALANCE') then
    if bfCustomer.FieldByName('BALANCE').AsCurrency < 200 then
    begin
      DBGrid1.Canvas.Font.Style := DBGrid1.Canvas.Font.Style + [fsBold];
      DBGrid1.Canvas.Font.Color := clRed;
    end;
end;

procedure TfrmDbgrid.DBGrid1EditButtonClick(Sender: TObject);
var
  OD: TOpenPictureDialog;
  Frm: TForm;
  MM: TDBMemo;
  ams: TMemoryStream;
  apic: TPicture;
begin
  // Editar Campo PICTURE (Blob)
  if DBGrid1.SelectedField = bfCustomer.FieldByName('PICTURE') then
  begin
    OD := TOpenPictureDialog.Create(nil);
    OD.InitialDir := ExtractFilePath(Application.Location) + 'icons';
    ams := TMemoryStream.Create;
    apic := TPicture.Create;
    try
      if OD.Execute then
        try
          apic.LoadFromFile(OD.FileName);
          apic.SaveToStream(ams);
          ams.Position := 0;
          bfCustomer.Edit;
          TBlobField(bfCustomer.FieldByName('PICTURE')).LoadFromStream(ams);
          bfCustomer.Post;
        finally
          apic.Free;
          ams.Free;
        end;
    finally
      OD.Free;
    end;
  end;
  // Editar e Exibir Campo NOTE (Blob)
  if DBGrid1.SelectedField = bfCustomer.FieldByName('NOTE') then
  begin
    Frm := TForm.Create(nil);
    try
      Frm.Width := 240;
      Frm.Height := 120;
      Frm.Top := Mouse.CursorPos.y;
      frm.Left := Mouse.CursorPos.x;
      Frm.BorderStyle := bsToolWindow;
      Frm.Caption := 'Editing';
      MM := TDBMemo.Create(nil);
      try
        MM.Parent := Frm;
        MM.Align := alClient;
        MM.DataSource := dsCustomer;
        MM.DataField := 'NOTE';
        Frm.ShowModal;
        if bfCustomer.State in [dsEdit, dsInsert] then
          bfCustomer.Post;
      finally
        MM.Free;
      end;
    finally
      Frm.Free;
    end;
  end;
end;

procedure TfrmDbgrid.DateTimePicker1Change(Sender: TObject);
begin
  // Editar BIRTHDAY com o valor do DateTimerPicker
  bfCustomer.Edit;
  bfCustomer.FieldByName('BIRTHDAY').AsDateTime := DateTimePicker1.Date;
end;

procedure TfrmDbgrid.DBGrid1CellClick(Column: TColumn);
begin
  //Código Desnecessário I
  //if Column.Field = bfCustomer.FieldByName('ENABLED') then
  //begin
  //  bfCustomer.Edit;
  //  bfCustomer.FieldByName('ENABLED').AsBoolean :=
  //    not bfCustomer.FieldByName('ENABLED').AsBoolean;
  //end;
end;

procedure TfrmDbgrid.DBGrid1ColEnter(Sender: TObject);
begin
  // Código Desnecessário II
  //if DBGrid1.SelectedField = bfCustomer.FieldByName('ENABLED') then
  //  DBGrid1.Options := DBGrid1.Options - [dgEditing]
  //else
  //  DBGrid1.Options := DBGrid1.Options + [dgEditing];
end;

procedure TfrmDbgrid.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: integer; Column: TColumn; State: TGridDrawState);
var
  unstream: TMemoryStream;
  pic: TPicture;
begin
  // Exibir DateTimerPicker dentro da Célula com o valor de BIRTHDAY
  DateTimePicker1.Visible := DBGrid1.SelectedField = bfCustomer.FieldByName('BIRTHDAY');
  if DateTimePicker1.Visible then
    if gdFocused in State then
    begin
      if not bfCustomer.FieldByName('BIRTHDAY').IsNull then
        DateTimePicker1.Date := bfCustomer.FieldByName('BIRTHDAY').AsDateTime
      else
        DateTimePicker1.Date := Now;
      DateTimePicker1.SetBounds(Rect.Left, Rect.Top,
        Rect.Right - Rect.Left, Rect.Bottom - Rect.Top);
    end;
  // Exibir Images no campo Boolean (True, False, Null)
  if Column.Field = bfCustomer.FieldByName('ENABLED') then
  begin
    DBGrid1.Canvas.FillRect(Rect);
    if bfCustomer.FieldByName('ENABLED').IsNull then
      ImageList1.Draw(DBGrid1.Canvas, Rect.Left + 23, Rect.Top + 3, 1)
    else
    if bfCustomer.FieldByName('ENABLED').AsBoolean then
      ImageList1.Draw(DBGrid1.Canvas, Rect.Left + 23, Rect.Top + 3, 2)
    else
      ImageList1.Draw(DBGrid1.Canvas, Rect.Left + 23, Rect.Top + 3, 0);
  end;
  // Exibir Images no Campo GENDER (Male, Female)
  if Column.Field = bfCustomer.FieldByName('GENDER') then
  begin
    DBGrid1.Canvas.FillRect(Rect);
    if bfCustomer.FieldByName('GENDER').AsString = 'M' then
      ImageList1.Draw(DBGrid1.Canvas, Rect.Left, Rect.Top, 3)
    else
    if bfCustomer.FieldByName('GENDER').AsString = 'F' then
      ImageList1.Draw(DBGrid1.Canvas, Rect.Left, Rect.Top, 4);
  end;
  // Exibir Images no Campo PICTURE
  if Column.Field = bfCustomer.FieldByName('PICTURE') then
  begin
    DBGrid1.Canvas.FillRect(Rect);
    if not bfCustomer.FieldByName('PICTURE').IsNull then
    begin
      try
        unstream := TMemoryStream.Create;
        pic := TPicture.Create;
        unstream.Position := 0;
        TBlobField(bfCustomer.FieldByName('PICTURE')).SaveToStream(unstream);
        unstream.Position := 0;
        pic.LoadFromStream(unstream);
        DBGrid1.Canvas.StretchDraw(Rect, pic.Graphic);
      finally
        pic.Free;
        unstream.Free;
      end;
    end;
  end;
end;

procedure TfrmDbgrid.DBGrid1TitleClick(Column: TColumn);
begin
  // Ordernar DBGrid por Coluna
  if bfCustomer.IndexFieldNames <> '' then
    DBGrid1.Columns[bfCustomer.FieldByName(bfCustomer.IndexFieldNames).Index]
      .Title.Color := DBGrid1.FixedColor;
  if not ((Column.Field.DataType in [ftBlob, ftMemo]) or
    (Column.Field.FieldKind in [fkLookup])) then
  begin
    bfCustomer.IndexFieldNames := Column.FieldName;
    Column.Title.Color := $00FFEFDF;
  end;
end;

end.
