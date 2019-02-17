unit Unit_Cad_Unidades;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, 
    Unit_Cad_Mod_Simples, UnitDados;

type
  TForm_Cad_Unidades = class(TForm_Cad_Mod_Simples)
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form_Cad_Unidades: TForm_Cad_Unidades;

implementation

initialization
  {$I unit_cad_unidades.lrs}

end.

