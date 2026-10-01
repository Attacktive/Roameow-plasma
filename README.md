# Roameow

[![CodeFactor](https://www.codefactor.io/repository/github/attacktive/roameow-plasma/badge)](https://www.codefactor.io/repository/github/attacktive/roameow-plasma)
[![Release](https://github.com/Attacktive/Roameow-plasma/actions/workflows/release.yaml/badge.svg)](https://github.com/Attacktive/Roameow-plasma/actions/workflows/release.yaml)

A fun Plasma 6 widget that features an animated Nyan Cat roaming around your desktop!

It's completely useless by design. 😏

[nyancat.webm](https://github.com/user-attachments/assets/96ee8750-bfcd-42e3-bd39-f4a3e9866a00)

[tacnayn.webm](https://github.com/user-attachments/assets/82953fea-b08c-4d74-8573-0629e01c540a)


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
