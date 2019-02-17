unit uDTMConexao;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ZConnection;

type

  { TdtmPrincipal }

  TdtmPrincipal = class(TDataModule)
    ConexaoDB: TZConnection;
  private

  public

  end;

var
  dtmPrincipal: TdtmPrincipal;

implementation

{$R *.lfm}

end.

