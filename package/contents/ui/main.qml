import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import QtMultimedia
import "../code/MediaPaths.js" as MediaPaths

PlasmoidItem {
	id: root

	readonly property double volume: plasmoid.configuration.volume
	readonly property var defaultImages: ({
		'nyancat': Qt.resolvedUrl('../images/nyancat.gif'),
		'tacnayn': Qt.resolvedUrl('../images/tacnayn.gif')
	})

	readonly property var defaultIdleImages: ({
		'nyancat': Qt.resolvedUrl('../images/sleepingcat.svg'),
		'tacnayn': Qt.resolvedUrl('../images/sleepingtacnayn.svg')
	})

	Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
	Plasmoid.status: PlasmaCore.Types.PassiveStatus

	preferredRepresentation: fullRepresentation

	MediaPlayer {
		id: meowSound
		source: MediaPaths.source(
			plasmoid.configuration.customSoundPath,
			Qt.resolvedUrl('../effects/meow.mp3')
		)
		audioOutput: AudioOutput {
			volume: root.volume
		}
	}

	fullRepresentation: Cat {
		id: cat
		imageSize: plasmoid.configuration.imageSize
		imageSource: MediaPaths.source(
			plasmoid.configuration.customImagePath,
			root.defaultImages[plasmoid.configuration.defaultImage] || Qt.resolvedUrl('../images/nyancat.gif')
		)
		idleImageSource: MediaPaths.source(
			plasmoid.configuration.customIdleImagePath,
			root.defaultIdleImages[plasmoid.configuration.defaultImage] || Qt.resolvedUrl('../images/sleepingcat.svg')
		)
		showIdleImage: plasmoid.configuration.showIdleImage
		enableMovement: plasmoid.configuration.enableMovement
		speed: plasmoid.configuration.speed
		enableRandomIdle: plasmoid.configuration.enableRandomIdle
		idleProbability: plasmoid.configuration.idleProbability
		enableFlipping: plasmoid.configuration.enableFlipping
		mirrorImage: plasmoid.configuration.mirrorImage

		onClicked: {
			meowSound.stop();
			meowSound.play();
		}
	}
}
