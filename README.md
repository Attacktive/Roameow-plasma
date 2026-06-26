# Roameow

[![CodeFactor](https://www.codefactor.io/repository/github/attacktive/roameow-plasma/badge)](https://www.codefactor.io/repository/github/attacktive/roameow-plasma)
[![Release](https://github.com/Attacktive/Roameow-plasma/actions/workflows/release.yaml/badge.svg)](https://github.com/Attacktive/Roameow-plasma/actions/workflows/release.yaml)

A fun Plasma 6 widget that features an animated nyancat wandering around your desktop!

It's completely useless by design. 😏

![Nyan Cat](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExeDBscW5yOXB0dmtwdGIwN2tndDN6YXNuczJtM3BxYzFtaWRxbDBwbSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3nZckcvfbUZuTrYxND/giphy.gif)

## Installation

1. Make sure you have the required dependencies:
	- Arch Linux
	```bash
	$ sudo pacman -S base-devel extra-cmake-modules plasma-sdk
	```
	- Ubuntu 24.04
	```bash
	# Adding KDE neon PPA to the containerized Ubuntu because it lacks dependencies for Plasma 6
	$ echo "deb [trusted=yes] http://archive.neon.kde.org/user noble main" | sudo tee /etc/apt/sources.list.d/neon.list
	$ sudo apt update
	$ sudo apt install build-essential kf6-extra-cmake-modules plasma-framework6-dev
	```

2. Build and install the widget:
	```bash
	$ ./install.sh
	```

3. Add the widget to your desktop or panel through the Plasma widgets menu
