unit uCadCategoria;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, MaskEdit, Buttons, StdCtrls, DBGrids, DbCtrls, uTelaHeranca;

type

  { TfrmCadCategoria }

  TfrmCadCategoria = class(TfrmTelaHeranca)
    qryListagemcategoriaId: TLongintField;
    qryListagemdescricao: TWideStringField;
  private

  public

  end;

var
  frmCadCategoria: TfrmCadCategoria;

implementation

{$R *.lfm}

end.

