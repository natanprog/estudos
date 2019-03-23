unit udbgrid;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  DBGrids, ExtCtrls, Grids;

type

  { TfrmDbgrid }

  TfrmDbgrid = class(TForm)
    bfCustomer: TBufDataset;
    bfCompany: TBufDataset;
    dsCompany: TDataSource;
    dsCustomer: TDataSource;
    DBGrid1: TDBGrid;
    imgPicture: TImage;
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
    bufdb.SaveToFile('company.xml');
  finally
    bufdb.Close;
    bufdb.Free;
  end;
end;

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
end;

procedure TfrmDbgrid.DBGrid1TitleClick(Column: TColumn);
begin
  // Ordernar DBGrid por Coluna
  if bfCustomer.IndexFieldNames <> '' then
    DBGrid1.Columns[bfCustomer.FieldByName(bfCustomer.IndexFieldNames).Index]
      .Title.Color := DBGrid1.FixedColor;
  if not ((Column.Field.DataType in [ftBlob, ftMemo]) or (Column.Field.FieldKind in
    [fkLookup])) then
  begin
    bfCustomer.IndexFieldNames := Column.FieldName;
    Column.Title.Color := $00FFEFDF;
  end;
end;

end.
