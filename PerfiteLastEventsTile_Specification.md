# PerfiteLastEventsTile

Delphi 11 Alexandria + DevExpress VCL 23.1.4

## Назначение

Компонента dashboard-плитки для отображения последних событий регистрации:

- Въезд
- Выезд
- Регистрация
- Неизвестное событие

Компонента должна:
- визуально размещаться на форме
- поддерживать настройку через Object Inspector
- поддерживать SVG-иконки
- поддерживать DevExpress LookAndFeel/Skin
- поддерживать прозрачный и selected background
- поддерживать Collection Editor
- входить в набор компонентов `Perfite`

---

# Архитектура

Проект должен состоять из 4 файлов:

```text
PerfiteLastEventsTile.pas
PerfiteLastEventsTileReg.pas
PerfiteLastEventsRT.dpk
PerfiteLastEventsDT.dpk
```

---

# Требования

## Среда

- Delphi 11 Alexandria
- DevExpress VCL 23.1.4
- Win32/Win64

---

# Основной класс

Компонента должна наследоваться от:

```delphi
TcxCustomControl
```

Причины:
- поддержка DevExpress Themes
- корректная работа DPI
- корректная интеграция в IDE
- поддержка Paint
- поддержка прозрачности
- поддержка LookAndFeel

---

# Типы событий

```delphi
type
  TPerfiteEventKind = (
    pekUnknown,
    pekEnter,
    pekExit,
    pekRegister
  );
```

---

# Структура события

```delphi
type
  TPerfiteEventItem = class(TCollectionItem)
  private
    FText: string;
    FDateTime: TDateTime;
    FCheckpoint: string;
    FKind: TPerfiteEventKind;
  published
    property Text: string read FText write FText;
    property EventDateTime: TDateTime read FDateTime write FDateTime;
    property Checkpoint: string read FCheckpoint write FCheckpoint;
    property Kind: TPerfiteEventKind read FKind write FKind;
  end;
```

---

# Коллекция событий

```delphi
type
  TPerfiteEventCollection = class(TOwnedCollection)
  public
    constructor Create(AOwner: TPersistent);
  end;
```

---

# Основная компонента

```delphi
type
  TPerfiteLastEventsTile = class(TcxCustomControl)
  private
    FEvents: TPerfiteEventCollection;

    FShowCheckpoint: Boolean;
    FTransparentBackground: Boolean;
    FSelected: Boolean;

    FSelectedColor: TColor;
    FNormalColor: TColor;

    procedure SetEvents(const Value: TPerfiteEventCollection);

  protected
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

    property LookAndFeel;
    property Style;

    property Events: TPerfiteEventCollection
      read FEvents
      write SetEvents;

    property ShowCheckpoint: Boolean
      read FShowCheckpoint
      write FShowCheckpoint;

    property TransparentBackground: Boolean
      read FTransparentBackground
      write FTransparentBackground;

    property Selected: Boolean
      read FSelected
      write FSelected;

    property SelectedColor: TColor
      read FSelectedColor
      write FSelectedColor;

    property NormalColor: TColor
      read FNormalColor
      write FNormalColor;
  end;
```

---

# SVG Иконки

Использовать:

```delphi
uses
  dxSVGImage;
```

SVG должны поддерживаться через:

- TdxSVGImageCollection
- ресурсы
- DevExpress ImageCollection

---

# Типы SVG

## Въезд

- зелёный круг
- стрелка вправо

## Выезд

- синий круг
- стрелка влево

## Регистрация

- оранжевый круг

## Неизвестно

- серый круг

---

# Внешний вид

Компонента должна визуально выглядеть как dashboard tile:

- светлый фон
- rounded corners
- поддержка selected state
- мягкие отступы
- до 6 событий
- современный flat UI

---

# Paint

В Paint необходимо рисовать:

1. Background
2. Header
3. SVG icon
4. Event text
5. Date/time
6. Checkpoint
7. Hover/selected effects

---

# Заголовок

```text
Последние события
```

---

# Формат даты

```text
dd.mm.yyyy hh:nn
```

---

# Collection Editor

Свойство:

```delphi
property Events: TPerfiteEventCollection
```

должно открывать стандартный Collection Editor IDE.

Пользователь должен иметь возможность:
- добавлять события
- удалять события
- редактировать событие
- менять тип события
- задавать дату
- задавать КПП

без написания кода.

---

# Регистрация компоненты

## PerfiteLastEventsTileReg.pas

```delphi
unit PerfiteLastEventsTileReg;

interface

procedure Register;

implementation

uses
  System.Classes,
  DesignIntf,
  DesignEditors,
  PerfiteLastEventsTile;

procedure Register;
begin
  RegisterComponents(
    'Perfite',
    [TPerfiteLastEventsTile]
  );
end;

end.
```

---

# Runtime package

## PerfiteLastEventsRT.dpk

```delphi
package PerfiteLastEventsRT;

requires
  rtl,
  vcl,
  cxLibraryVCL,
  dxCore,
  dxTheme,
  dxGDIPlusClasses;

contains
  PerfiteLastEventsTile in 'PerfiteLastEventsTile.pas';

end.
```

---

# Design package

## PerfiteLastEventsDT.dpk

```delphi
package PerfiteLastEventsDT;

requires
  rtl,
  vcl,
  designide,
  PerfiteLastEventsRT;

contains
  PerfiteLastEventsTileReg in 'PerfiteLastEventsTileReg.pas';

end.
```

---

# Установка

## Шаг 1

Build Runtime package:

```text
PerfiteLastEventsRT.dpk
```

## Шаг 2

Build Design package:

```text
PerfiteLastEventsDT.dpk
```

## Шаг 3

Install package.

После установки компонент должен появиться на вкладке:

```text
Perfite
```

---

# Поддержка DPI

Обязательно:

- High DPI
- PerMonitorV2
- масштабирование SVG
- корректные отступы

---

# Поддержка DevExpress

Компонента должна:
- поддерживать LookAndFeel
- поддерживать Skin
- автоматически перерисовываться при смене темы
- корректно работать внутри:
  - dxLayoutControl
  - cxGroupBox
  - dxDashboard
  - dxTileControl

---

# Возможные расширения

## Hover animation

Подсветка строки при наведении.

## TcxHint

Подсказки для длинного текста.

## Dataset support

Привязка к Dataset.

## Async update

Асинхронное обновление списка событий.

## Auto refresh

Автообновление по Timer.

## Dark Theme

Поддержка тёмных тем.

## SVG recoloring

Автоматическая перекраска SVG под тему.

---

# Инструкции для Codex

## Важно

НЕ использовать:
- TcxPanel
- TcxCanvas
- dxPanel
- нестабильные internal DevExpress классы

Использовать:
- TcxCustomControl
- обычный Canvas
- официальные DevExpress API

---

## Код должен:

- компилироваться в Delphi 11
- компилироваться с DevExpress 23.1.4
- не содержать deprecated API
- не использовать старые cxPanel решения

---

## Важно для Paint

Paint должен:
- корректно работать в IDE Designer
- не мигать
- использовать DoubleBuffered
- корректно обрабатывать transparency

---

## Важно для Collection

Collection должна:
- корректно сериализоваться в DFM
- корректно работать в Object Inspector
- корректно отображаться в Collection Editor

---

## Важно для SVG

SVG должны:
- масштабироваться
- поддерживать DPI
- поддерживать Skin Colors
- поддерживать repaint

---

# Ожидаемый результат

Готовая production-ready DevExpress компонента:

- визуально размещаемая
- поддерживающая themes
- поддерживающая SVG
- поддерживающая collection editor
- устанавливаемая через design package
- пригодная для dashboard UI
