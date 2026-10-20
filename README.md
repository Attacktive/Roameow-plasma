# Roameow

[![CodeFactor](https://www.codefactor.io/repository/github/attacktive/roameow-plasma/badge)](https://www.codefactor.io/repository/github/attacktive/roameow-plasma)
[![Release](https://github.com/Attacktive/Roameow-plasma/actions/workflows/release.yaml/badge.svg)](https://github.com/Attacktive/Roameow-plasma/actions/workflows/release.yaml)

A fun Plasma 6 widget that features an animated Nyan Cat roaming around your desktop!

It's completely useless by design. 😏

[nyancat.webm](https://github.com/user-attachments/assets/96ee8750-bfcd-42e3-bd39-f4a3e9866a00)

[tacnayn.webm](https://github.com/user-attachments/assets/82953fea-b08c-4d74-8573-0629e01c540a)

## Customization

Open the widget's configuration to choose a built-in cat or a custom image, adjust movement, and pick a meow sound.
Click the cat to hear it meow.

- **Image:** change the size, mirror the image, or choose a PNG, JPEG, GIF, or SVG file.
- **Idle time:** with **Random Idle** enabled, the percentage is the approximate share of time spent asleep, not a chance at each destination.
  **0%** never sleeps, **50%** averages about half its time asleep, and **100%** stays asleep continuously.
  Intermediate values are sampled every two seconds, independently of movement speed; consecutive sleeping or moving intervals are normal.
  Percentage and enable/disable changes apply immediately.
  Previously saved percentages keep their numeric values and use this new meaning.
- **Idle pose:** enable **Random Idle** on the Movement page, then **Show a different image while idling** on the Image page.
  Leave the custom idle image empty to use the matching built-in sleeping Nyan Cat or Tac Nayn, or choose your own static or animated image.
  The pose is optional and off by default; the cat resumes its normal image when its nap ends.
- **Sound:** adjust the volume, choose an MP3, WAV, or OGG file, and use **Test** to preview it.
- **Restore Defaults** resets only the current configuration page; use Plasma's **Apply** or **OK** button to save changes.

Custom image, idle-image, and sound paths are browse-only: use the file picker to choose a file, or the clear/reset action to return to the built-in asset.

If a custom image or sound cannot load, its configuration page shows an error with actions to choose another file or return to the built-in asset.
The selected path is kept until you explicitly replace or reset it.
For existing settings, absolute paths containing `#` or `?` are supported, as are percent-encoded paths saved by older versions.
Existing percent escapes are preserved for compatibility; use the file picker for filenames containing literal sequences such as `%20`.


## Installation

Use Plasma's **Install New Widgets** interface and search for **Roameow**.

Roameow is also available on the [KDE Store](https://store.kde.org/p/2263448/).

After installation, add the widget to your desktop or panel through the Plasma widgets menu.

### Install from source

Installing from source is intended for development. Roameow itself does not need to be compiled; Plasma loads the widget package directly.

The translation catalogs are generated from the source `.po` files, so make sure `msgfmt` from gettext is installed, then run:

```bash
$ bash package/translate/build
$ kpackagetool6 --type Plasma/Applet --install package
```

If Roameow is already installed, use `--upgrade` instead of `--install`.

## Development checks

Run the sprite interaction, idle-transition, compact configuration dialog, and media-path regression tests with Qt's QML test runner:

```bash
QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software /usr/lib/qt6/bin/qmltestrunner -input tests
```

The executable may instead be named `qmltestrunner6` or `qmltestrunner` on your distribution.
