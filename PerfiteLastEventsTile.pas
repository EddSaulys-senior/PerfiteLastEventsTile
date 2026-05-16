unit PerfiteLastEventsTile;

interface

uses
  Winapi.Messages,
  Winapi.Windows,
  System.Classes,
  System.SysUtils,
  System.Types,
  Vcl.Controls,
  Vcl.Graphics,
  Vcl.GraphUtil,
  Vcl.Themes,
  cxControls,
  cxGraphics,
  cxImageList,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxCoreGraphics,
  dxSVGImage;

type
  TPerfiteEventKind = (
    pekUnknown,
    pekEnter,
    pekExit,
    pekRegister
  );

  TPerfiteEventItem = class(TCollectionItem)
  private
    FText: string;
    FDateTime: TDateTime;
    FCheckpoint: string;
    FKind: TPerfiteEventKind;
    procedure SetCheckpoint(const Value: string);
    procedure SetEventDateTime(const Value: TDateTime);
    procedure SetKind(const Value: TPerfiteEventKind);
    procedure SetText(const Value: string);
  protected
    function GetDisplayName: string; override;
  published
    property Text: string read FText write SetText;
    property EventDateTime: TDateTime read FDateTime write SetEventDateTime;
    property Checkpoint: string read FCheckpoint write SetCheckpoint;
    property Kind: TPerfiteEventKind read FKind write SetKind default pekUnknown;
  end;

  TPerfiteEventCollection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TPerfiteEventItem;
    procedure SetItem(Index: Integer; const Value: TPerfiteEventItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent);
    function Add: TPerfiteEventItem;
    property Items[Index: Integer]: TPerfiteEventItem read GetItem write SetItem; default;
  end;

  TPerfiteLastEventsTile = class(TcxCustomControl)
  private
    FEvents: TPerfiteEventCollection;
    FShowCheckpoint: Boolean;
    FTransparentBackground: Boolean;
    FSelected: Boolean;
    FSelectedColor: TColor;
    FNormalColor: TColor;
    FImages: TcxCustomImageList;
    FEnterImageIndex: Integer;
    FExitImageIndex: Integer;
    FRegisterImageIndex: Integer;
    FUnknownImageIndex: Integer;
    FTitle: string;
    FIconSize: Integer;
    FUseSkinColors: Boolean;
    FTextColor: TColor;
    FSecondaryTextColor: TColor;
    FSeparatorColor: TColor;
    FBorderColor: TColor;
    FRowSeparatorColor: TColor;
    FShowRowSeparators: Boolean;
    FMaxEvents: Integer;
    FDateFormat: string;
    FEmptyText: string;
    FEventTextStyle: TFontStyles;
    procedure SetEvents(const Value: TPerfiteEventCollection);
    procedure SetShowCheckpoint(const Value: Boolean);
    procedure SetTransparentBackground(const Value: Boolean);
    procedure SetSelected(const Value: Boolean);
    procedure SetSelectedColor(const Value: TColor);
    procedure SetNormalColor(const Value: TColor);
    procedure SetImages(const Value: TcxCustomImageList);
    procedure SetEnterImageIndex(const Value: Integer);
    procedure SetExitImageIndex(const Value: Integer);
    procedure SetRegisterImageIndex(const Value: Integer);
    procedure SetUnknownImageIndex(const Value: Integer);
    procedure SetTitle(const Value: string);
    procedure SetIconSize(const Value: Integer);
    procedure SetUseSkinColors(const Value: Boolean);
    procedure SetTextColor(const Value: TColor);
    procedure SetSecondaryTextColor(const Value: TColor);
    procedure SetSeparatorColor(const Value: TColor);
    procedure SetBorderColor(const Value: TColor);
    procedure SetRowSeparatorColor(const Value: TColor);
    procedure SetShowRowSeparators(const Value: Boolean);
    procedure SetMaxEvents(const Value: Integer);
    procedure SetDateFormat(const Value: string);
    procedure SetEmptyText(const Value: string);
    procedure SetEventTextStyle(const Value: TFontStyles);
    function ActualBackColor: TColor;
    function ActualTextColor: TColor;
    function ActualSecondaryTextColor: TColor;
    function ActualSeparatorColor: TColor;
    function ActualRowSeparatorColor: TColor;
    function ActualBorderColor: TColor;
    function GetAuthor: string;
    function GetImageIndex(AKind: TPerfiteEventKind): Integer;
    function ScaleValue(Value: Integer): Integer;
    procedure DrawBackground(ACanvas: TCanvas; const R: TRect);
    procedure DrawFallbackIcon(ACanvas: TCanvas; const R: TRect; AKind: TPerfiteEventKind);
    procedure DrawIcon(ACanvas: TCanvas; const R: TRect; AKind: TPerfiteEventKind);
    procedure EventsChanged;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property PopupMenu;
    property Visible;
    property Enabled;
    property Hint;
    property ShowHint;
    property Font;
    property ParentFont;
    property Author: string read GetAuthor stored False;
    property Title: string read FTitle write SetTitle;
    property IconSize: Integer read FIconSize write SetIconSize default 10;
    property UseSkinColors: Boolean read FUseSkinColors write SetUseSkinColors default True;
    property TextColor: TColor read FTextColor write SetTextColor default clWindowText;
    property SecondaryTextColor: TColor read FSecondaryTextColor write SetSecondaryTextColor default clGrayText;
    property SeparatorColor: TColor read FSeparatorColor write SetSeparatorColor default $00E6E6E6;
    property RowSeparatorColor: TColor read FRowSeparatorColor write SetRowSeparatorColor default $00EEEEEE;
    property ShowRowSeparators: Boolean read FShowRowSeparators write SetShowRowSeparators default True;
    property BorderColor: TColor read FBorderColor write SetBorderColor default clBtnShadow;
    property MaxEvents: Integer read FMaxEvents write SetMaxEvents default 6;
    property DateFormat: string read FDateFormat write SetDateFormat;
    property EmptyText: string read FEmptyText write SetEmptyText;
    property EventTextStyle: TFontStyles read FEventTextStyle write SetEventTextStyle;
    property Events: TPerfiteEventCollection read FEvents write SetEvents;
    property ShowCheckpoint: Boolean read FShowCheckpoint write SetShowCheckpoint default True;
    property TransparentBackground: Boolean read FTransparentBackground write SetTransparentBackground default False;
    property Selected: Boolean read FSelected write SetSelected default False;
    property SelectedColor: TColor read FSelectedColor write SetSelectedColor default $00FFF0D8;
    property NormalColor: TColor read FNormalColor write SetNormalColor default clWhite;
    property Images: TcxCustomImageList read FImages write SetImages;
    property EnterImageIndex: Integer read FEnterImageIndex write SetEnterImageIndex default -1;
    property ExitImageIndex: Integer read FExitImageIndex write SetExitImageIndex default -1;
    property RegisterImageIndex: Integer read FRegisterImageIndex write SetRegisterImageIndex default -1;
    property UnknownImageIndex: Integer read FUnknownImageIndex write SetUnknownImageIndex default -1;
  end;

implementation

uses
  System.Math;

const
  MaxVisibleEvents = 6;
  DefaultTitle = 'Last Events';
  DefaultIconSize = 10;
  DefaultDateFormat = 'dd.mm.yyyy hh:nn';
  DefaultEmptyText = 'No events';
  ComponentAuthor = 'Perfite | LisEd (c) 2026';

procedure DrawCanvasText(ACanvas: TCanvas; const AText: string; const ARect: TRect; AFlags: Cardinal);
var
  R: TRect;
begin
  R := ARect;
  DrawText(ACanvas.Handle, PChar(AText), -1, R, AFlags);
end;

procedure NotifyCollectionOwner(ACollection: TCollection);
var
  LOwner: TPersistent;
begin
  if ACollection = nil then
    Exit;
  LOwner := ACollection.Owner;
  if LOwner is TPerfiteLastEventsTile then
    TPerfiteLastEventsTile(LOwner).EventsChanged;
end;

procedure TPerfiteEventItem.SetCheckpoint(const Value: string);
begin
  if FCheckpoint <> Value then
  begin
    FCheckpoint := Value;
    Changed(False);
  end;
end;

procedure TPerfiteEventItem.SetEventDateTime(const Value: TDateTime);
begin
  if FDateTime <> Value then
  begin
    FDateTime := Value;
    Changed(False);
  end;
end;

procedure TPerfiteEventItem.SetKind(const Value: TPerfiteEventKind);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    Changed(False);
  end;
end;

procedure TPerfiteEventItem.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    Changed(False);
  end;
end;

function TPerfiteEventItem.GetDisplayName: string;
begin
  Result := FText;
  if Result = '' then
    Result := inherited GetDisplayName;
end;

constructor TPerfiteEventCollection.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TPerfiteEventItem);
end;

function TPerfiteEventCollection.Add: TPerfiteEventItem;
begin
  Result := TPerfiteEventItem(inherited Add);
end;

function TPerfiteEventCollection.GetItem(Index: Integer): TPerfiteEventItem;
begin
  Result := TPerfiteEventItem(inherited Items[Index]);
end;

procedure TPerfiteEventCollection.SetItem(Index: Integer; const Value: TPerfiteEventItem);
begin
  inherited Items[Index] := Value;
end;

procedure TPerfiteEventCollection.Update(Item: TCollectionItem);
begin
  inherited;
  NotifyCollectionOwner(Self);
end;

constructor TPerfiteLastEventsTile.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 320;
  Height := 240;
  FEvents := TPerfiteEventCollection.Create(Self);
  FShowCheckpoint := True;
  FNormalColor := clWhite;
  FSelectedColor := $00FFF0D8;
  FEnterImageIndex := -1;
  FExitImageIndex := -1;
  FRegisterImageIndex := -1;
  FUnknownImageIndex := -1;
  FTitle := DefaultTitle;
  FIconSize := DefaultIconSize;
  FUseSkinColors := True;
  FTextColor := clWindowText;
  FSecondaryTextColor := clGrayText;
  FSeparatorColor := $00E6E6E6;
  FBorderColor := clBtnShadow;
  FRowSeparatorColor := $00EEEEEE;
  FShowRowSeparators := True;
  FMaxEvents := MaxVisibleEvents;
  FDateFormat := DefaultDateFormat;
  FEmptyText := DefaultEmptyText;
  FEventTextStyle := [];
  ControlStyle := ControlStyle + [csOpaque, csReplicatable];
  ParentFont := True;
end;

destructor TPerfiteLastEventsTile.Destroy;
begin
  FEvents.Free;
  inherited;
end;

procedure TPerfiteLastEventsTile.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FImages) then
    FImages := nil;
end;

procedure TPerfiteLastEventsTile.EventsChanged;
begin
  Invalidate;
end;

function TPerfiteLastEventsTile.ScaleValue(Value: Integer): Integer;
begin
  Result := MulDiv(Value, CurrentPPI, 96);
end;

procedure TPerfiteLastEventsTile.SetEvents(const Value: TPerfiteEventCollection);
begin
  FEvents.Assign(Value);
  Invalidate;
end;

procedure TPerfiteLastEventsTile.SetShowCheckpoint(const Value: Boolean);
begin
  if FShowCheckpoint <> Value then
  begin
    FShowCheckpoint := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetTransparentBackground(const Value: Boolean);
begin
  if FTransparentBackground <> Value then
  begin
    FTransparentBackground := Value;
    if Value then
      ControlStyle := ControlStyle - [csOpaque]
    else
      ControlStyle := ControlStyle + [csOpaque];
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetSelected(const Value: Boolean);
begin
  if FSelected <> Value then
  begin
    FSelected := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetSelectedColor(const Value: TColor);
begin
  if FSelectedColor <> Value then
  begin
    FSelectedColor := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetNormalColor(const Value: TColor);
begin
  if FNormalColor <> Value then
  begin
    FNormalColor := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetImages(const Value: TcxCustomImageList);
begin
  if FImages <> Value then
  begin
    if FImages <> nil then
      FImages.RemoveFreeNotification(Self);
    FImages := Value;
    if FImages <> nil then
      FImages.FreeNotification(Self);
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetEnterImageIndex(const Value: Integer);
begin
  if FEnterImageIndex <> Value then
  begin
    FEnterImageIndex := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetExitImageIndex(const Value: Integer);
begin
  if FExitImageIndex <> Value then
  begin
    FExitImageIndex := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetRegisterImageIndex(const Value: Integer);
begin
  if FRegisterImageIndex <> Value then
  begin
    FRegisterImageIndex := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetUnknownImageIndex(const Value: Integer);
begin
  if FUnknownImageIndex <> Value then
  begin
    FUnknownImageIndex := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetTitle(const Value: string);
begin
  if FTitle <> Value then
  begin
    FTitle := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetIconSize(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := EnsureRange(Value, 6, 64);
  if FIconSize <> LValue then
  begin
    FIconSize := LValue;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetUseSkinColors(const Value: Boolean);
begin
  if FUseSkinColors <> Value then
  begin
    FUseSkinColors := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetTextColor(const Value: TColor);
begin
  if FTextColor <> Value then
  begin
    FTextColor := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetSecondaryTextColor(const Value: TColor);
begin
  if FSecondaryTextColor <> Value then
  begin
    FSecondaryTextColor := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetSeparatorColor(const Value: TColor);
begin
  if FSeparatorColor <> Value then
  begin
    FSeparatorColor := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetBorderColor(const Value: TColor);
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetRowSeparatorColor(const Value: TColor);
begin
  if FRowSeparatorColor <> Value then
  begin
    FRowSeparatorColor := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetShowRowSeparators(const Value: Boolean);
begin
  if FShowRowSeparators <> Value then
  begin
    FShowRowSeparators := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetMaxEvents(const Value: Integer);
var
  LValue: Integer;
begin
  LValue := EnsureRange(Value, 1, 20);
  if FMaxEvents <> LValue then
  begin
    FMaxEvents := LValue;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetDateFormat(const Value: string);
begin
  if FDateFormat <> Value then
  begin
    FDateFormat := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetEmptyText(const Value: string);
begin
  if FEmptyText <> Value then
  begin
    FEmptyText := Value;
    Invalidate;
  end;
end;

procedure TPerfiteLastEventsTile.SetEventTextStyle(const Value: TFontStyles);
begin
  if FEventTextStyle <> Value then
  begin
    FEventTextStyle := Value;
    Invalidate;
  end;
end;

function TPerfiteLastEventsTile.ActualBackColor: TColor;
begin
  if not FUseSkinColors then
  begin
    if FSelected then
      Result := FSelectedColor
    else
      Result := FNormalColor;
    Exit;
  end;
  if StyleServices.Enabled then
    Result := StyleServices.GetSystemColor(clWindow)
  else if FSelected then
    Result := FSelectedColor
  else
    Result := FNormalColor;
end;

function TPerfiteLastEventsTile.ActualTextColor: TColor;
begin
  if FUseSkinColors and StyleServices.Enabled then
    Result := StyleServices.GetSystemColor(clWindowText)
  else
    Result := FTextColor;
end;

function TPerfiteLastEventsTile.ActualSecondaryTextColor: TColor;
begin
  if FUseSkinColors and StyleServices.Enabled then
    Result := StyleServices.GetSystemColor(clGrayText)
  else
    Result := FSecondaryTextColor;
end;

function TPerfiteLastEventsTile.ActualSeparatorColor: TColor;
begin
  if FUseSkinColors and StyleServices.Enabled then
    Result := StyleServices.GetSystemColor(clBtnFace)
  else
    Result := FSeparatorColor;
end;

function TPerfiteLastEventsTile.ActualRowSeparatorColor: TColor;
begin
  if FUseSkinColors and StyleServices.Enabled then
    Result := StyleServices.GetSystemColor(clBtnFace)
  else
    Result := FRowSeparatorColor;
end;

function TPerfiteLastEventsTile.ActualBorderColor: TColor;
begin
  if FUseSkinColors and StyleServices.Enabled then
    Result := StyleServices.GetSystemColor(clBtnShadow)
  else
    Result := FBorderColor;
end;

function TPerfiteLastEventsTile.GetAuthor: string;
begin
  Result := ComponentAuthor;
end;

function TPerfiteLastEventsTile.GetImageIndex(AKind: TPerfiteEventKind): Integer;
begin
  case AKind of
    pekEnter:
      Result := FEnterImageIndex;
    pekExit:
      Result := FExitImageIndex;
    pekRegister:
      Result := FRegisterImageIndex;
  else
    Result := FUnknownImageIndex;
  end;
end;

procedure TPerfiteLastEventsTile.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TPerfiteLastEventsTile.DrawBackground(ACanvas: TCanvas; const R: TRect);
var
  LColor: TColor;
begin
  if FTransparentBackground then
    Exit;
  LColor := ActualBackColor;
  ACanvas.Brush.Color := LColor;
  ACanvas.Pen.Color := ActualBorderColor;
  ACanvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, ScaleValue(14), ScaleValue(14));
end;

procedure TPerfiteLastEventsTile.DrawFallbackIcon(ACanvas: TCanvas; const R: TRect; AKind: TPerfiteEventKind);
var
  LColor: TColor;
  LMidY: Integer;
  LArrow: array[0..2] of TPoint;
begin
  case AKind of
    pekEnter:
      LColor := $0055B65A;
    pekExit:
      LColor := $00D49A35;
    pekRegister:
      LColor := $000098FF;
  else
    LColor := $00909090;
  end;
  ACanvas.Brush.Color := LColor;
  ACanvas.Pen.Color := LColor;
  ACanvas.Ellipse(R);
  if AKind in [pekEnter, pekExit] then
  begin
    ACanvas.Pen.Color := clWhite;
    ACanvas.Pen.Width := Max(1, ScaleValue(2));
    LMidY := (R.Top + R.Bottom) div 2;
    if AKind = pekEnter then
    begin
      ACanvas.MoveTo(R.Left + ScaleValue(7), LMidY);
      ACanvas.LineTo(R.Right - ScaleValue(8), LMidY);
      LArrow[0] := Point(R.Right - ScaleValue(8), LMidY);
      LArrow[1] := Point(R.Right - ScaleValue(13), LMidY - ScaleValue(5));
      LArrow[2] := Point(R.Right - ScaleValue(13), LMidY + ScaleValue(5));
    end
    else
    begin
      ACanvas.MoveTo(R.Right - ScaleValue(7), LMidY);
      ACanvas.LineTo(R.Left + ScaleValue(8), LMidY);
      LArrow[0] := Point(R.Left + ScaleValue(8), LMidY);
      LArrow[1] := Point(R.Left + ScaleValue(13), LMidY - ScaleValue(5));
      LArrow[2] := Point(R.Left + ScaleValue(13), LMidY + ScaleValue(5));
    end;
    ACanvas.Brush.Color := clWhite;
    ACanvas.Pen.Color := clWhite;
    ACanvas.Polygon(LArrow);
    ACanvas.Pen.Width := 1;
  end;
end;

procedure TPerfiteLastEventsTile.DrawIcon(ACanvas: TCanvas; const R: TRect; AKind: TPerfiteEventKind);
var
  LIndex: Integer;
begin
  LIndex := GetImageIndex(AKind);
  if (FImages <> nil) and (LIndex >= 0) and (LIndex < FImages.Count) then
    FImages.Draw(ACanvas, R, LIndex, True, False, Enabled)
  else
    DrawFallbackIcon(ACanvas, R, AKind);
end;

procedure TPerfiteLastEventsTile.Paint;
var
  LCanvas: TCanvas;
  LScale: Single;
  LRect: TRect;
  LContent: TRect;
  LHeaderHeight: Integer;
  LRowHeight: Integer;
  LPadding: Integer;
  LIconSize: Integer;
  LIconCenterX: Integer;
  LTextLeft: Integer;
  LRightWidth: Integer;
  I: Integer;
  LItem: TPerfiteEventItem;
  LRowRect: TRect;
  LIconRect: TRect;
  LTextRect: TRect;
  LDateRect: TRect;
  LCheckpointRect: TRect;
  LDateText: string;
  LCount: Integer;
  LTextColor: TColor;
  LSecondaryTextColor: TColor;
begin
  LCanvas := Canvas;
  LScale := CurrentPPI / 96;
  LRect := ClientRect;
  LPadding := Round(14 * LScale);
  LHeaderHeight := ScaleValue(38);
  LRowHeight := Max(ScaleValue(38), ScaleValue(FIconSize + 16));
  LIconSize := ScaleValue(FIconSize);
  LTextColor := ActualTextColor;
  LSecondaryTextColor := ActualSecondaryTextColor;

  if FTransparentBackground then
    inherited Paint
  else
    DrawBackground(LCanvas, LRect);

  LContent := LRect;
  InflateRect(LContent, -LPadding, -LPadding);
  LCanvas.Font.Assign(Font);
  LCanvas.Font.Style := [fsBold];
  LCanvas.Font.Size := Font.Size + 1;
  LCanvas.Font.Color := LTextColor;
  LCanvas.Brush.Style := bsClear;
  DrawCanvasText(LCanvas, FTitle, Rect(LContent.Left, LContent.Top, LContent.Right, LContent.Top + LHeaderHeight), DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
  LCanvas.Pen.Color := ActualRowSeparatorColor;
  LCanvas.Pen.Width := Max(1, ScaleValue(1));
  LCanvas.MoveTo(LContent.Left, LContent.Top + LHeaderHeight);
  LCanvas.LineTo(LContent.Right, LContent.Top + LHeaderHeight);
  LCanvas.Pen.Width := 1;

  LCanvas.Font.Style := [];
  LCanvas.Font.Size := Font.Size;
  if FEvents.Count = 0 then
  begin
    LCanvas.Font.Style := [];
    LCanvas.Font.Size := Font.Size;
    LCanvas.Font.Color := LSecondaryTextColor;
    DrawCanvasText(LCanvas, FEmptyText, Rect(LContent.Left, LContent.Top + LHeaderHeight, LContent.Right, LContent.Bottom), DT_LEFT or DT_TOP or DT_SINGLELINE or DT_END_ELLIPSIS);
    Exit;
  end;
  LCount := Min(FEvents.Count, FMaxEvents);
  LIconCenterX := LContent.Left + LIconSize div 2;
  LTextLeft := LContent.Left + LIconSize + ScaleValue(12);
  LRightWidth := ScaleValue(94);
  for I := 0 to LCount - 1 do
  begin
    LItem := FEvents[I];
    LRowRect := Rect(LContent.Left, LContent.Top + LHeaderHeight + I * LRowHeight, LContent.Right, LContent.Top + LHeaderHeight + (I + 1) * LRowHeight);
    if FShowRowSeparators then
    begin
      LCanvas.Pen.Color := ActualRowSeparatorColor;
      LCanvas.Pen.Width := Max(1, ScaleValue(1));
      LCanvas.MoveTo(LTextLeft, LRowRect.Top);
      LCanvas.LineTo(LContent.Right, LRowRect.Top);
      LCanvas.Pen.Width := 1;
    end;
    if I < LCount - 1 then
    begin
      LCanvas.Pen.Color := ActualSeparatorColor;
      LCanvas.Pen.Width := Max(1, ScaleValue(1));
      LCanvas.MoveTo(LIconCenterX, LRowRect.Top + (LRowHeight + LIconSize) div 2 + ScaleValue(3));
      LCanvas.LineTo(LIconCenterX, LRowRect.Bottom + (LRowHeight - LIconSize) div 2 - ScaleValue(3));
      LCanvas.Pen.Width := 1;
    end;
    LIconRect := Rect(LRowRect.Left, LRowRect.Top + (LRowHeight - LIconSize) div 2, LRowRect.Left + LIconSize, LRowRect.Top + (LRowHeight - LIconSize) div 2 + LIconSize);
    DrawIcon(LCanvas, LIconRect, LItem.Kind);
    LTextRect := Rect(LTextLeft, LRowRect.Top, LRowRect.Right - LRightWidth - ScaleValue(8), LRowRect.Bottom);
    LDateRect := Rect(LRowRect.Right - LRightWidth, LRowRect.Top + ScaleValue(2), LRowRect.Right, LRowRect.Top + LRowHeight div 2);
    LCheckpointRect := Rect(LRowRect.Right - LRightWidth, LRowRect.Top + LRowHeight div 2, LRowRect.Right, LRowRect.Bottom - ScaleValue(2));
    LCanvas.Font.Style := FEventTextStyle;
    LCanvas.Font.Color := LTextColor;
    DrawCanvasText(LCanvas, LItem.Text, LTextRect, DT_LEFT or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
    LCanvas.Font.Style := [];
    if LItem.EventDateTime > 0 then
      LDateText := FormatDateTime(FDateFormat, LItem.EventDateTime)
    else
      LDateText := '';
    LCanvas.Font.Color := LSecondaryTextColor;
    DrawCanvasText(LCanvas, LDateText, LDateRect, DT_RIGHT or DT_BOTTOM or DT_SINGLELINE);
    if FShowCheckpoint and (LItem.Checkpoint <> '') then
    begin
      LCanvas.Font.Color := LSecondaryTextColor;
      DrawCanvasText(LCanvas, LItem.Checkpoint, LCheckpointRect, DT_RIGHT or DT_TOP or DT_SINGLELINE or DT_END_ELLIPSIS);
    end;
  end;
end;

end.
