unit Unit_Cad_Grupos;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs, 
    Unit_Cad_Mod_Simples,UnitDados;

type

  { TCad_Grupos }

  TCad_Grupos = class(TForm_Cad_Mod_Simples)
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Cad_Grupos: TCad_Grupos;

implementation

{ TCad_Grupos }

procedure TCad_Grupos.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dm.Grupos.Close;
end;

procedure TCad_Grupos.FormShow(Sender: TObject);
begin
  dm.Grupos.Open;
  DBGrid1.SetFocus;
end;

initialization
  {$I unit_cad_grupos.lrs}

end.

