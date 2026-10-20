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
	property var idleRandom: Math.random
	property var positionRandom: Math.random
	property bool enableFlipping: true
	property bool mirrorImage: false

	signal clicked()

	property bool isIdle: false
	property bool initialPositionSet: false
	property point targetPosition: Qt.point(0, 0)
	property bool movingRight: true

	function moveToRandomPosition() {
		const maxX = Math.max(0, width - imageContainer.width);
		const maxY = Math.max(0, height - imageContainer.height);
		const targetX = positionRandom() * maxX;
		const targetY = positionRandom() * maxY;

		targetPosition = Qt.point(targetX, targetY);
		movingRight = targetX > imageContainer.x;
	}

	function placeInitially() {
		if (initialPositionSet || !enableMovement || width <= 0 || height <= 0) {
			return;
		}

		moveToRandomPosition();
		imageContainer.x = targetPosition.x;
		imageContainer.y = targetPosition.y;
		initialPositionSet = true;
		moveToRandomPosition();
	}

	function updateIdleState() {
		if (!enableMovement || !enableRandomIdle || idleProbability <= 0) {
			isIdle = false;
			return;
		}

		if (idleProbability >= 100) {
			isIdle = true;
			return;
		}

		isIdle = idleRandom() * 100 < idleProbability;
	}

	onEnableMovementChanged: {
		updateIdleState();
		if (enableMovement && !initialPositionSet) {
			Qt.callLater(placeInitially);
		}
	}

	onWidthChanged: {
		if (!initialPositionSet) {
			Qt.callLater(placeInitially);
		}
	}

	onHeightChanged: {
		if (!initialPositionSet) {
			Qt.callLater(placeInitially);
		}
	}

	onEnableRandomIdleChanged: updateIdleState()
	onIdleProbabilityChanged: updateIdleState()

	Component.onCompleted: {
		Qt.callLater(placeInitially);
		updateIdleState();
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
	}

	FrameAnimation {
		running: cat.initialPositionSet && cat.enableMovement && !cat.isIdle

		onTriggered: {
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
		interval: 2000
		repeat: true
		running: cat.enableMovement && cat.enableRandomIdle && cat.idleProbability > 0 && cat.idleProbability < 100
		onTriggered: cat.updateIdleState()
	}
}
