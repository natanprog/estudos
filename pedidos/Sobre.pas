unit Sobre;

{$MODE Delphi}

interface

uses LCLIntf, LCLType{, LMessages}, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TF_Sobre = class(TForm)
    Panel1: TPanel;
    ProductName: TLabel;
	 Version: TLabel;
    Copyright: TLabel;
    OKButton: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Lb_Mail: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label6: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Panel2: TPanel;
    procedure Lb_MailMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
	 procedure Lb_MailClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Sobre: TF_Sobre;

implementation
Uses Dm_Pedidos;

{$R *.lfm}

procedure TF_Sobre.Lb_MailMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
	Lb_Mail.Font.Color := clBlue;
	Lb_Mail.Font.Style := [fsBold]; // Negrito
end;

procedure TF_Sobre.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
	Lb_Mail.Font.Color := clBlack;
	Lb_Mail.Font.Style := []; // Não Negrito e Não Itálico	
end;

procedure TF_Sobre.FormCreate(Sender: TObject);
begin
	ScaleBy( Screen.Width, 1920 );
end;

procedure TF_Sobre.Lb_MailClick(Sender: TObject);
begin
	// ShellExecute : usa biblioteca shellApi
    OpenDocument(Pchar('mailto:'+Lb_Mail.Caption)); { *Converted from ShellExecute* }
end;

procedure TF_Sobre.OKButtonClick(Sender: TObject);
begin
	Close
end;

procedure TF_Sobre.FormShow(Sender: TObject);
begin
	F_Dm_Pedidos.Zconnection.Connected := False;
end;

end.
 
