unit ChatFMX.Events;

interface

uses
  System.Classes, VK.Types, System.Messaging, System.SysUtils,
  System.Generics.Collections, VK.UserEvents;

type
  TEventUserStatus = class(TMessage)
  private
    FUserId: TVkPeerId;
    FIsOnline: Boolean;
    FVkPlatform: TVkPlatform;
  public
    property UserId: TVkPeerId read FUserId;
    property IsOnline: Boolean read FIsOnline;
    property VkPlatform: TVkPlatform read FVkPlatform;
    constructor Create(AUserId: TVkPeerId; AIsOnline: Boolean; AVkPlatform: TVkPlatform = TVkPlatform.Unknown); reintroduce;
  end;

  TEventMessage = class(TMessage)
    Data: TMessageData;
    constructor Create(MessageData: TMessageData); reintroduce;
  end;

  TEventNewMessage = class(TEventMessage);

  TEventEditMessage = class(TEventMessage);

  TEventActionMessage = class(TMessage)
    PeerId: TVkPeerId;
    LocalId: Int64;
    constructor Create(APeerId: TVkPeerId; ALocalId: Int64); reintroduce;
  end;

  TEventReadMessages = class(TEventActionMessage)
    Incoming: Boolean;
    constructor Create(AIncoming: Boolean; APeerId: TVkPeerId; ALocalId: Int64); reintroduce;
  end;

  TEventDeleteMessage = class(TEventActionMessage);

  TEventRecoverMessage = class(TEventActionMessage);

  TEventMessageChange = class(TMessage)
    Data: TMessageChangeData;
    constructor Create(MessageChangeData: TMessageChangeData); reintroduce;
  end;

  TEventChangeSort = class(TMessage)
    PeerId: TVkPeerId;
    NewId: Int64;
    IsMajor: Boolean;
    constructor Create(APeerId: TVkPeerId; ANewId: Int64; AIsMajor: Boolean); reintroduce;
  end;

  TQueueSubscribers = class(TThreadList<TObject>);

  Event = class
  private
    class var
      FManager: TMessageManager;
      FQueueSubscribers: TQueueSubscribers;
  public
    class constructor Create;
    class destructor Destroy;
    class procedure Send(Message: TMessage);
    class function Subscribe(const AMessageClass: TClass; const AListenerMethod: TMessageListenerMethod): Integer; overload;
    class procedure Unsubscribe(const AMessageClass: TClass; const AListenerMethod: TMessageListenerMethod; Immediate: Boolean = False); overload;
    class procedure QueueSubscribe(AObject: TObject);
    class procedure QueueUnsubscribe(AObject: TObject);
    class procedure Queue(Owner: TObject; Proc: TProc);
    class procedure Sync(Owner: TObject; Proc: TProc);
  end;

implementation

{ Event }

class constructor Event.Create;
begin
  FManager := TMessageManager.Create;
  FQueueSubscribers := TQueueSubscribers.Create;
end;

class destructor Event.Destroy;
begin
  FManager.Free;
  FQueueSubscribers.Free;
end;

class procedure Event.Queue(Owner: TObject; Proc: TProc);
begin
  TThread.ForceQueue(nil,
    procedure
    begin
      var List := FQueueSubscribers.LockList;
      try
        if List.Contains(Owner) then
          Proc;
      finally
        FQueueSubscribers.UnlockList;
      end;
    end);
end;

class procedure Event.QueueSubscribe(AObject: TObject);
begin
  FQueueSubscribers.Add(AObject);
end;

class procedure Event.QueueUnsubscribe(AObject: TObject);
begin
  FQueueSubscribers.Remove(AObject);
end;

class procedure Event.Send(Message: TMessage);
begin
  TThread.Queue(nil,
    procedure
    begin
      FManager.SendMessage(FManager, Message, True);
    end);
end;

class function Event.Subscribe(const AMessageClass: TClass; const AListenerMethod: TMessageListenerMethod): Integer;
var
  Res: Integer;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      Res := FManager.SubscribeToMessage(AMessageClass, AListenerMethod);
    end);
  Result := Res;
end;

class procedure Event.Sync(Owner: TObject; Proc: TProc);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      var List := FQueueSubscribers.LockList;
      try
        if List.Contains(Owner) then
          Proc;
      finally
        FQueueSubscribers.UnlockList;
      end;
    end);
end;

class procedure Event.Unsubscribe(const AMessageClass: TClass; const AListenerMethod: TMessageListenerMethod; Immediate: Boolean);
begin
  TThread.Queue(nil,
    procedure
    begin
      FManager.Unsubscribe(AMessageClass, AListenerMethod, Immediate);
    end);
end;

{ TEventUserStatus }

constructor TEventUserStatus.Create(AUserId: TVkPeerId; AIsOnline: Boolean; AVkPlatform: TVkPlatform);
begin
  inherited Create;
  FUserId := AUserId;
  FIsOnline := AIsOnline;
  FVkPlatform := AVkPlatform;
end;

{ TEventMessage }

constructor TEventMessage.Create(MessageData: TMessageData);
begin
  inherited Create;
  Data := MessageData;
end;

{ TEventReadMessages }

constructor TEventReadMessages.Create(AIncoming: Boolean; APeerId: TVkPeerId; ALocalId: Int64);
begin
  inherited Create(APeerId, ALocalId);
  Incoming := AIncoming;
end;

{ TEventActionMessage }

constructor TEventActionMessage.Create(APeerId: TVkPeerId; ALocalId: Int64);
begin
  inherited Create;
  PeerId := APeerId;
  LocalId := ALocalId;
end;

{ TEventMessageChange }

constructor TEventMessageChange.Create(MessageChangeData: TMessageChangeData);
begin
  inherited Create;
  Data := MessageChangeData;
end;

{ TEventChangeSort }

constructor TEventChangeSort.Create(APeerId: TVkPeerId; ANewId: Int64; AIsMajor: Boolean);
begin
  inherited Create;
  PeerId := APeerId;
  NewId := ANewId;
  IsMajor := AIsMajor;
end;

end.

