import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore
import QtMultimedia
import org.kde.kirigami as Kirigami
import "../../code/MediaPaths.js" as MediaPaths

Page {
	id: soundPage
	title: i18n('Sound')

	property double cfg_volume: cfg_volumeDefault
	property string cfg_customSoundPath: cfg_customSoundPathDefault

	property double cfg_volumeDefault: 1.0
	property string cfg_customSoundPathDefault: ''

	function restoreDefaults() {
		cfg_volume = cfg_volumeDefault;
		cfg_customSoundPath = cfg_customSoundPathDefault;
	}

	readonly property bool hasSoundError: {
		if (soundPage.cfg_customSoundPath === '') {
			return false;
		}

		if (testSound.error !== MediaPlayer.NoError) {
			return true;
		}

		if (testSound.mediaStatus === MediaPlayer.InvalidMedia) {
			return true;
		}

		return false;
	}

	MediaPlayer {
		id: testSound
		source: {
			if (soundPage.cfg_customSoundPath !== '') {
				return MediaPaths.source(soundPage.cfg_customSoundPath, '');
			}

			return Qt.resolvedUrl('../../effects/meow.mp3');
		}
		audioOutput: AudioOutput {
			volume: soundPage.cfg_volume
		}
	}

	FileDialog {
		id: soundFileDialog
		title: i18n('Choose a sound file')
		currentFolder: {
			if (soundPage.cfg_customSoundPath.length > 0) {
				const resolved = MediaPaths.source(soundPage.cfg_customSoundPath, '');
				const lastSlash = resolved.lastIndexOf('/');
				if (lastSlash > 'file://'.length) {
					return resolved.substring(0, lastSlash);
				}
			}

			return StandardPaths.writableLocation(StandardPaths.HomeLocation);
		}
		nameFilters: [
			i18n('Audio files (*.mp3 *.wav *.ogg)'),
			i18n('All files (*)')
		]
		onAccepted: {
			soundPage.cfg_customSoundPath = selectedFile.toString();
		}
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: Kirigami.Units.smallSpacing

		Kirigami.FormLayout {
			Layout.fillWidth: true

			RowLayout {
				Kirigami.FormData.label: i18n('Volume:')
				Layout.fillWidth: true

				Slider {
					id: volumeSlider
					from: 0
					to: 100
					stepSize: 1
					value: Math.round(soundPage.cfg_volume * 100)
					onMoved: soundPage.cfg_volume = value / 100
					Layout.fillWidth: true

					ToolTip {
						parent: volumeSlider.handle
						visible: volumeSlider.pressed
						text: `${Math.round(volumeSlider.value)}%`
					}
				}

				Binding {
					target: volumeSlider
					property: 'value'
					value: Math.round(soundPage.cfg_volume * 100)
				}

				Label {
					text: `${Math.round(soundPage.cfg_volume * 100)}%`
					Layout.minimumWidth: Kirigami.Theme.defaultFont.pointSize * 6
					horizontalAlignment: Text.AlignRight
				}

				Button {
					text: i18n('Test')
					icon.name: 'media-playback-start'
					enabled: !soundPage.hasSoundError
					onClicked: {
						testSound.stop();
						testSound.play();
					}
				}
			}

			RowLayout {
				Kirigami.FormData.label: i18n('Custom sound:')
				Layout.fillWidth: true

				TextField {
					id: soundPathField
					text: soundPage.cfg_customSoundPath
					placeholderText: i18n('Leave empty for built-in sound')
					Layout.fillWidth: true
					readOnly: true
				}

				Button {
					text: i18n('Browse…')
					icon.name: 'document-open'
					onClicked: soundFileDialog.open()
				}

				Button {
					text: i18n('Reset')
					icon.name: 'edit-undo'
					enabled: soundPage.cfg_customSoundPath !== ''
					onClicked: soundPage.cfg_customSoundPath = ''
				}
			}

			Kirigami.InlineMessage {
				id: soundErrorNotice
				objectName: 'soundErrorMessage'
				Layout.fillWidth: true
				type: Kirigami.MessageType.Error
				visible: soundPage.hasSoundError
				text: i18n('Failed to load custom sound effect. Please select a valid audio file or reset to the built-in sound.')
				actions: [
					Kirigami.Action {
						text: i18n('Choose File…')
						icon.name: 'document-open'
						onTriggered: soundFileDialog.open()
					},
					Kirigami.Action {
						text: i18n('Use Built-in Sound')
						icon.name: 'edit-undo'
						onTriggered: soundPage.cfg_customSoundPath = ''
					}
				]
			}

			Button {
				id: restoreDefaultsButton
				objectName: 'restoreDefaultsButton'
				text: i18n('Restore Defaults')
				icon.name: 'edit-undo'
				onClicked: soundPage.restoreDefaults()
			}
		}

		Item {
			Layout.fillHeight: true
		}
	}
}
