unit Unit_Cad_Marcas; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, 
    Unit_Cad_Mod_Simples, UnitDados;

type

  { TCad_Marcas }

  TCad_Marcas = class(TForm_Cad_Mod_Simples)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Cad_Marcas: TCad_Marcas;

implementation

{ TCad_Marcas }

procedure TCad_Marcas.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dm.Marcas.Close;
end;

procedure TCad_Marcas.FormShow(Sender: TObject);
begin
  dm.Marcas.Open;
end;

initialization
  {$I unit_cad_marcas.lrs}

end.

