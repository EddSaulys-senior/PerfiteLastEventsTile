# PerfiteLastEventsTile

`PerfiteLastEventsTile` is a Delphi VCL dashboard tile component for displaying recent registration/access events.

The component is designed for **Delphi 11 Alexandria** and **DevExpress VCL 23.1.4**.

## Features

- VCL visual component inherited from `TcxCustomControl`
- Design-time registration in the `Perfite` component palette
- Editable event collection through the standard Delphi Collection Editor
- DevExpress/VCL image list support, including SVG images through `TcxImageList`
- Optional fallback icons when no image list is assigned
- DPI-aware layout
- Configurable title, colors, date format, icon size, and maximum visible events
- Optional VCL style/theme-aware colors
- Static dashboard rendering without list-box/table-like hover behavior

## Component

Main class:

```delphi
TPerfiteLastEventsTile
```

Event kind:

```delphi
TPerfiteEventKind = (
  pekUnknown,
  pekEnter,
  pekExit,
  pekRegister
);
```

Event item:

```delphi
TPerfiteEventItem = class(TCollectionItem)
published
  property Text: string;
  property EventDateTime: TDateTime;
  property Checkpoint: string;
  property Kind: TPerfiteEventKind;
end;
```

## Files

```text
PerfiteLastEventsTile.pas       Runtime component unit
PerfiteLastEventsTileReg.pas    Design-time registration unit
PerfiteLastEventsRT.dpk         Runtime package
PerfiteLastEventsDT.dpk         Design-time package
PerfiteLastEventsTileReg.rc     Component palette icon resource script
PerfiteLastEventsTileReg.dcr    Component palette icon resource
icon.bmp                        Source bitmap for component palette icon
```

## Requirements

- Delphi 11 Alexandria / RAD Studio 11
- DevExpress VCL 23.1.4
- Win32/Win64 VCL application

The runtime package uses DevExpress packages with RAD Studio 11 suffixes:

```delphi
requires
  rtl,
  vcl,
  dxCoreRS28,
  dxGDIPlusRS28,
  cxLibraryRS28;
```

## Installation

1. Open Delphi IDE.
2. Build the runtime package:

   ```text
   PerfiteLastEventsRT.dpk
   ```

3. Build the design-time package:

   ```text
   PerfiteLastEventsDT.dpk
   ```

4. Install the design-time package:

   ```text
   Component -> Install Packages... -> Add...
   ```

5. Select:

   ```text
   PerfiteLastEventsDT.bpl
   ```

After installation the component appears on the palette tab:

```text
Perfite
```

Install only the design-time package manually. The runtime package is a dependency and should not be installed as a palette package.

## DevExpress paths

If Delphi cannot find packages such as `cxLibraryRS28`, make sure the DevExpress DCP path is available in the Delphi Library Path:

```text
C:\Users\Public\Documents\Embarcadero\Studio\22.0\Dcp
```

Depending on the local DevExpress installation, these source paths may also be useful:

```text
C:\Program Files (x86)\Embarcadero\Components\Delphi.DevExpress\VCL\ExpressLibrary\Sources
C:\Program Files (x86)\Embarcadero\Components\Delphi.DevExpress\VCL\ExpressCore Library\Sources
C:\Program Files (x86)\Embarcadero\Components\Delphi.DevExpress\VCL\ExpressGDI+ Library\Sources
```

## Basic usage

Drop `TPerfiteLastEventsTile` onto a VCL form and edit the `Events` collection in the Object Inspector.

Example:

```delphi
var
  AItem: TPerfiteEventItem;
begin
  AItem := PerfiteLastEventsTile1.Events.Add;
  AItem.Text := 'Entry allowed';
  AItem.EventDateTime := Now;
  AItem.Checkpoint := 'KPP-1';
  AItem.Kind := pekEnter;
end;
```

## Important properties

### Content

| Property | Description |
| --- | --- |
| `Title` | Tile header text. Default: `Last Events`. |
| `Events` | Event collection displayed by the tile. |
| `ShowCheckpoint` | Shows or hides checkpoint text. |
| `DateFormat` | Date/time display format. Default: `dd.mm.yyyy hh:nn`. |
| `EmptyText` | Text displayed when the event collection is empty. |
| `MaxEvents` | Maximum number of visible events. Default: `6`. |

### Appearance

| Property | Description |
| --- | --- |
| `IconSize` | Event icon size in logical pixels. Default: `10`. |
| `Images` | `TcxCustomImageList` image source. Can contain SVG images. |
| `EnterImageIndex` | Image index for entry events. |
| `ExitImageIndex` | Image index for exit events. |
| `RegisterImageIndex` | Image index for registration events. |
| `UnknownImageIndex` | Image index for unknown events. |
| `TransparentBackground` | Does not draw tile background when enabled. |
| `Selected` | Draws selected background color when enabled. |

### Colors

| Property | Description |
| --- | --- |
| `UseSkinColors` | Uses VCL style/theme colors when enabled. Default: `True`. |
| `NormalColor` | Background color when `UseSkinColors = False`. |
| `SelectedColor` | Selected background color. |
| `TextColor` | Main text color when `UseSkinColors = False`. |
| `SecondaryTextColor` | Date/checkpoint color when `UseSkinColors = False`. |
| `SeparatorColor` | Timeline separator color when `UseSkinColors = False`. |
| `BorderColor` | Tile border color when `UseSkinColors = False`. |

## Recommended settings

Light appearance:

```text
UseSkinColors = False
NormalColor = clWhite
TextColor = clWindowText
SecondaryTextColor = clGrayText
SeparatorColor = $00E6E6E6
BorderColor = $00DADADA
IconSize = 10
MaxEvents = 6
ShowCheckpoint = True
```

Dark appearance:

```text
UseSkinColors = False
NormalColor = $002D2D30
TextColor = clWhite
SecondaryTextColor = $00B0B0B0
SeparatorColor = $004A4A4A
BorderColor = $00555555
IconSize = 10
```

## Demo skin presets

These presets can be used as starting points when `UseSkinColors = False`.

### Clean Light

Minimal light dashboard style.

```text
UseSkinColors = False
NormalColor = clWhite
SelectedColor = $00FFF0D8
TextColor = $00333333
SecondaryTextColor = $00808080
SeparatorColor = $00E6E6E6
BorderColor = $00DADADA
IconSize = 10
MaxEvents = 6
Title = Last Events
```

### Soft Blue

Light style with a cool blue accent.

```text
UseSkinColors = False
NormalColor = $00FFFDF9
SelectedColor = $00FFE8D6
TextColor = $00402A1F
SecondaryTextColor = $00908078
SeparatorColor = $00F0D8C8
BorderColor = $00E4C7B5
IconSize = 10
MaxEvents = 6
Title = Access Events
```

### Graphite Dark

Dark dashboard style.

```text
UseSkinColors = False
NormalColor = $002D2D30
SelectedColor = $00404040
TextColor = clWhite
SecondaryTextColor = $00B0B0B0
SeparatorColor = $004A4A4A
BorderColor = $00555555
IconSize = 10
MaxEvents = 6
Title = Last Events
```

### Midnight Blue

Dark blue control-room style.

```text
UseSkinColors = False
NormalColor = $0031261C
SelectedColor = $00504030
TextColor = $00F5F5F5
SecondaryTextColor = $00C8B8A8
SeparatorColor = $005C4738
BorderColor = $00624E40
IconSize = 10
MaxEvents = 6
Title = Checkpoints
```

### Compact

Useful for narrow dashboard tiles.

```text
UseSkinColors = False
NormalColor = clWhite
SelectedColor = $00F7F7F7
TextColor = $00282828
SecondaryTextColor = $00757575
SeparatorColor = $00EAEAEA
BorderColor = $00E0E0E0
IconSize = 8
MaxEvents = 4
Title = Events
```

### Applying a preset in code

```delphi
procedure ApplyGraphiteDarkPreset(ATile: TPerfiteLastEventsTile);
begin
  ATile.UseSkinColors := False;
  ATile.NormalColor := $002D2D30;
  ATile.SelectedColor := $00404040;
  ATile.TextColor := clWhite;
  ATile.SecondaryTextColor := $00B0B0B0;
  ATile.SeparatorColor := $004A4A4A;
  ATile.BorderColor := $00555555;
  ATile.IconSize := 10;
  ATile.MaxEvents := 6;
  ATile.Title := 'Last Events';
end;
```

### Using application theme colors

For automatic VCL style/theme color adaptation:

```text
UseSkinColors = True
```

When this mode is enabled, manual color properties are ignored for the tile text, border, separator, and normal background.

## Notes

- The component is intentionally rendered as a static dashboard tile.
- It does not implement row selection, scrolling, or hover highlighting.
- For SVG images use a DevExpress `TcxImageList` and assign its indices to the event kind image index properties.
