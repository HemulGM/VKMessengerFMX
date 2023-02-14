unit ChatFMX.Frame.Message.Base;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  VK.API;

type
  TFrameMessageBase = class(TFrame)
  private
    FVK: TCustomVK;
    FVisibility: Boolean;
    FMessageId: Int64;
    FDate: TDateTime;
  protected
    procedure SetVK(const Value: TCustomVK); virtual;
    procedure SetDate(const Value: TDateTime); virtual;
    procedure SetVisibility(const Value: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent; AVK: TCustomVK); reintroduce; virtual;
    property VK: TCustomVK read FVK write SetVK;
    property Visibility: Boolean read FVisibility write SetVisibility;
    property MessageId: Int64 read FMessageId write FMessageId;
    property Date: TDateTime read FDate write SetDate;
    procedure Flash; virtual;
  end;

implementation

{$R *.fmx}

{ TFrameMessageBase }

constructor TFrameMessageBase.Create(AOwner: TComponent; AVK: TCustomVK);
begin
  inherited Create(AOwner);
  Name := '';
  FVK := AVK;
  FVisibility := False;
end;

procedure TFrameMessageBase.Flash;
begin
  //
end;

procedure TFrameMessageBase.SetDate(const Value: TDateTime);
begin
  FDate := Value;
end;

procedure TFrameMessageBase.SetVisibility(const Value: Boolean);
begin
  if FVisibility = Value then
    Exit;
  FVisibility := Value;
end;

procedure TFrameMessageBase.SetVK(const Value: TCustomVK);
begin
  FVK := Value;
end;

end.

