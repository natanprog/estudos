unit Unit_Config;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, FileUtil, LResources, Forms, Controls, Graphics,
  Dialogs, DbCtrls, StdCtrls, Buttons, ExtCtrls, UnitDados, Unit_rotinas,
  IniFiles;

type

  { TForm_Config }

  TForm_Config = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    sdd: TSelectDirectoryDialog;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  Form_Config: TForm_Config;

implementation

{ TForm_Config }

procedure TForm_Config.SpeedButton1Click(Sender: TObject);
begin
  if sdd.Execute then Edit2.Text:=sdd.FileName+PathDelim;
end;

procedure TForm_Config.SpeedButton2Click(Sender: TObject);
begin
  if sdd.Execute then Edit3.Text:=sdd.FileName+PathDelim;
end;

procedure TForm_Config.SpeedButton3Click(Sender: TObject);
begin
  if sdd.Execute then Edit4.Text:=sdd.FileName+PathDelim;
end;

procedure TForm_Config.FormShow(Sender: TObject);
var arq: TIniFile;
begin
  arq := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
  Edit1.Text:=arq.ReadString('configs','servidor','');
  ComboBox1.Text:=arq.ReadString('configs','uso','');
  Edit2.Text:=arq.ReadString('configs','banco','');
  Edit3.Text:=arq.ReadString('configs','fotos','');
  Edit4.Text:=arq.ReadString('configs','backups','');
  arq.Free;
end;

procedure TForm_Config.BitBtn1Click(Sender: TObject);
begin
  close;
end;

procedure TForm_Config.BitBtn2Click(Sender: TObject);
var arq: TIniFile;
begin
  try
    arq := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
    arq.WriteString('configs','servidor',Edit1.Text);
    arq.WriteString('configs','uso',ComboBox1.Text);
    arq.WriteString('configs','banco',Edit2.Text);
    arq.WriteString('configs','fotos',Edit3.Text);
    arq.WriteString('configs','backups',Edit4.Text);
    arq.WriteString('configs','inicial','1');
    arq.Free;
    ModalResult:=mrOK;
  except
    ModalResult:=mrAbort;
  end;
end;

initialization
  {$I unit_config.lrs}

end.

