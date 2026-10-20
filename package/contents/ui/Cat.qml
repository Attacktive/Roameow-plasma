import QtQuick

Item {
	id: cat

	property int imageSize: 128
	property url imageSource
	property url idleImageSource
	property bool showIdleImage: false
	property bool enableMovement: true
	property real speed: 1.3
	property bool enableRandomIdle: false
	property int idleProbability: 13
	property bool enableFlipping: true
	property bool mirrorImage: false

	signal clicked()

	property bool isIdle: false
	property bool canIdle: false
	property point targetPosition: Qt.point(0, 0)
	property bool movingRight: true

	function moveToRandomPosition() {
		if (enableRandomIdle && !isIdle && canIdle && Math.random() * 100 < idleProbability) {
			isIdle = true;
			canIdle = false;
			idleTimer.start();
			return;
		}

		canIdle = true;
		const maxX = Math.max(0, width - imageContainer.width);
		const maxY = Math.max(0, height - imageContainer.height);
		const targetX = Math.random() * maxX;
		const targetY = Math.random() * maxY;

		targetPosition = Qt.point(targetX, targetY);
		movingRight = targetX > imageContainer.x;
	}

	onEnableMovementChanged: {
		if (!enableMovement) {
			canIdle = false;
			if (isIdle) {
				isIdle = false;
				idleTimer.stop();
			}
		} else {
			moveToRandomPosition();
		}
	}

	onEnableRandomIdleChanged: {
		if (!enableRandomIdle && isIdle) {
			canIdle = false;
			isIdle = false;
			idleTimer.stop();
			if (enableMovement) {
				moveToRandomPosition();
			}
		}
	}

	Item {
		id: imageContainer
		width: cat.imageSize
		height: cat.imageSize
		x: 0
		y: 0

		AnimatedImage {
			id: sprite
			objectName: 'catSprite'
			anchors.fill: parent

			readonly property bool baseMirror: {
				if (cat.enableFlipping) {
					return !cat.movingRight;
				}

				return false;
			}

			readonly property bool toMirror: {
				if (cat.mirrorImage) {
					return !baseMirror;
				}

				return baseMirror;
			}

			source: {
				if (cat.showIdleImage && cat.isIdle && cat.idleImageSource != '') {
					return cat.idleImageSource;
				}

				return cat.imageSource;
			}

			mirror: toMirror
			playing: true

			onStatusChanged: {
				playing = (status === AnimatedImage.Ready);
			}

			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor

				onClicked: {
					cat.clicked();
				}
			}
		}

		Component.onCompleted: {
			if (cat.enableMovement) {
				cat.moveToRandomPosition();
			}
		}
	}

	FrameAnimation {
		running: cat.enableMovement

		onTriggered: {
			if (cat.isIdle) {
				return;
			}

			const step = cat.speed * frameTime * 50;
			const dx = cat.targetPosition.x - imageContainer.x;
			const dy = cat.targetPosition.y - imageContainer.y;
			const length = Math.hypot(dx, dy);
			if (length <= step) {
				imageContainer.x = cat.targetPosition.x;
				imageContainer.y = cat.targetPosition.y;
				cat.moveToRandomPosition();
			} else {
				imageContainer.x += dx / length * step;
				imageContainer.y += dy / length * step;
			}
		}
	}

	Timer {
		id: idleTimer
		interval: 2000
		repeat: false
		running: false

		onTriggered: {
			cat.isIdle = false;
			cat.canIdle = false;
			cat.moveToRandomPosition();
		}
	}
}
