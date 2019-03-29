unit uCadCategoria;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, MaskEdit, Buttons, StdCtrls, DBGrids, DBCtrls, uTelaHeranca;

type

  { TfrmCadCategoria }

  TfrmCadCategoria = class(TfrmTelaHeranca)
    qryListagemcategoriaId: TLongintField;
    qryListagemdescricao: TWideStringField;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmCadCategoria: TfrmCadCategoria;

implementation

{$R *.lfm}

{ TfrmCadCategoria }

procedure TfrmCadCategoria.FormCreate(Sender: TObject);
begin
  inherited;
  IndiceAtual := 'descricao';
end;

end.

