unit ChatFMX.Frame.MessageDate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, ChatFMX.Frame.Message.Base;

type
  TFrameMessageDate = class(TFrameMessageBase)
    LabelText: TLabel;
  private
  protected
    procedure SetDate(const Value: TDateTime); override;
  public
    procedure Fill(ADate: TDateTime; AMessageId: Extended);
  end;

implementation

uses
  ChatFMX.Utils, System.DateUtils;

{$R *.fmx}

{ TFrameMessageDate }

procedure TFrameMessageDate.Fill(ADate: TDateTime; AMessageId: Extended);
begin
  Date := ADate;
  MessageId := Trunc(AMessageId);
  TagFloat := AMessageId;
end;

procedure TFrameMessageDate.SetDate(const Value: TDateTime);
begin
  inherited;
  LabelText.Text := HumanDateTime(Date);
end;

end.

