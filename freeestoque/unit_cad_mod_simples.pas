unit Unit_Cad_Mod_Simples;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, DbCtrls, DBGrids, UnitDados;

type

  { TForm_Cad_Mod_Simples }

  TForm_Cad_Mod_Simples = class(TForm)
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form_Cad_Mod_Simples: TForm_Cad_Mod_Simples;

implementation

initialization
  {$I unit_cad_mod_simples.lrs}

end.

