unit ChatFMX.Frame.MessageDate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TFrameMessageDate = class(TFrame)
    LabelText: TLabel;
  private
    FDate: TDateTime;
    FMessageId: Extended;
    FVisibility: Boolean;
    procedure SetDate(const Value: TDateTime);
    procedure SetVisibility(const Value: Boolean);
  public
    procedure Fill(ADate: TDateTime; AMessageId: Extended);
    constructor Create(AOwner: TComponent); override;
    property Date: TDateTime read FDate write SetDate;
    property MessageId: Extended read FMessageId;
    property Visibility: Boolean read FVisibility write SetVisibility;
  end;

implementation

uses
  ChatFMX.Utils, System.DateUtils;

{$R *.fmx}

{ TFrameMessageDate }

constructor TFrameMessageDate.Create(AOwner: TComponent);
begin
  inherited;
  Name := '';
end;

procedure TFrameMessageDate.Fill(ADate: TDateTime; AMessageId: Extended);
begin
  Date := ADate;
  FMessageId := AMessageId;
  TagFloat := FMessageId;
end;

procedure TFrameMessageDate.SetDate(const Value: TDateTime);
begin
  FDate := Value;
  LabelText.Text := HumanDateTime(IncSecond(Value));
end;

procedure TFrameMessageDate.SetVisibility(const Value: Boolean);
begin
  FVisibility := Value;
end;

end.

