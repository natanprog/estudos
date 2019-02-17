unit Unit_Cad_Modelos; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, 
    Unit_Cad_Mod_Simples, UnitDados;

type

  { TCad_Modelos }

  TCad_Modelos = class(TForm_Cad_Mod_Simples)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Cad_Modelos: TCad_Modelos;

implementation

{ TCad_Modelos }

procedure TCad_Modelos.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  dm.Modelos.close;
end;

procedure TCad_Modelos.FormShow(Sender: TObject);
begin
  dm.Modelos.Open;
end;

initialization
  {$I unit_cad_modelos.lrs}

end.

